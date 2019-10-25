#!/usr/bin/env ruby

require "csv"
require "erb"

file = File.expand_path(ARGV[0], __FILE__)

items = CSV.foreach(file).map do |row|
  {
    date: row[0].strip,
    type: row[4].strip,
    amount: row[7].strip,
    memo: row[8].strip
  }
end


transaction_types = {
  "CR" => "CREDIT",
  "DR" => "DEBIT"
}

items.each do |item|
  item[:type] = transaction_types[item[:type]] || type
end


dates = []
items.each do |item|
  date = item[:date]
  dates << item[:date]
  seq = dates.count(date).to_s.rjust(4, "0")
  item[:fit_id] = "#{date}#{seq}"
end


template = ERB.new <<-EOF

OFXHEADER:100
DATA:OFXSGML
VERSION:102
SECURITY:NONE
ENCODING:USASCII
CHARSET:1252
COMPRESSION:NONE
OLDFILEUID:NONE
NEWFILEUID:NONE

<OFX>
    <BANKMSGSRSV1>
        <STMTTRNRS>
            <STMTRS>
                <CURDEF>GBP</CURDEF>

                <BANKTRANLIST>

                <% items.each do |item| %>
                  <STMTTRN>
                    <TRNTYPE><%= item[:type] %></TRNTYPE>
                    <DTPOSTED><%= item[:date] %></DTPOSTED>
                    <TRNAMT><%= item[:amount] %></TRNAMT>
                    <FITID><%= item[:fit_id] %></FITID>
                    <NAME><%= item[:memo] %></NAME>
                  </STMTTRN>
                <% end %>

                </BANKTRANLIST>

            </STMTRS>
        </STMTTRNRS>
    </BANKMSGSRSV1>
</OFX>

EOF

puts template.run(binding)
