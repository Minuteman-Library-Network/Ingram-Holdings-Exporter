# Ingram Holdings Exporter
Python script for sending minimal MARC exports to Ingram for use with Ipage's holdings feature.
Created and maintained by Jeremy Goldstein for test purposes only. Use at your own risk. Not supported by the Minuteman Library Network. 

For this feature Ingram requires .mrc or .out files of MARC records.  However, the feature only looks at the 020 and 024 fields for matching purposes.

Accordingly this script creates pseudo-MARC records that contain the minimal amount of data necessary for their needs and serves to automate the process of building those records and ftping them to Ingram.
