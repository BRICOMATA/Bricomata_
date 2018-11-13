# Luxemburg traffic scenario with VSimRTI

This VSimRTI-scenario connects the Luxembourg SUMO Traffic (LuST) Scenario with VSimRTI. 

* Download LuST scenario with the provided scripts in `sumo` subdir (git or svn-client required in PATH)
* Adjust the `mapping_config.json` to get your apps mapped onto the available vehicle types
* Execute VSimRTI with provided `defaults.xml`  :
  ```
  vsimrti.bat/sh -s LuST -u <user-id> -d scenarios/LuST/defaults.xml
  ```

