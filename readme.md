# CSV to OFX

A simple csv -> ofx translator to convert Yorkshire Bank csv format to the minimal viable ofx format for FreeAgent

Assumes transactions on the same day will always be returned in the same order, and uses their position to derive the `FITID` identifier