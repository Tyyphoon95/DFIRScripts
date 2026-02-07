# DFIRScripts
Scripts I have created throughout my career that could be useful to others.

I'm by *no* means a professional or advanced coder, but I welcome any feedback, positive or negative, and encourage others to submit their scripts or ideas to make these scripts better!

## Script Breakdown

- **hash_generator.ps1**:
  -  As the name implies, this is a PowerShell script to recursively generate hash values for files within a given directory.
- **import_cert.ps1**:
  - Imports .p12 certificate files located in a provided directory and utilizes data from a provided password file to successfully import them under the local user account.
- **K2D.ps1**:
  - Very basic PowerShell script that creates directories named after keywords obtained from a provided keyword list.
- **MSG_Extractor.ps1**
  -  Extracts MSG files that are saved as attachments within another MSG file. <sub> Not exactly sure if the "extract_msg" Python library already does this recursively, but I did it anyways </sub>

### Dependencies
1. PowerShell
2. Python 3.14 **Only required for MSG_Extractor.ps1**
   - Library ***extract_msg*** and dependencies installed

## Planned Ideas
- [ ] Convert "MSG_Extractor.ps1" into a Python script and/or Python executable
- [ ] Develop a C++ based work log application
