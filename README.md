# Setup

1. create access token with dns edit permission for the zone
2. copy .env.example to .env
3. copy .env to the location of wacs.exe
4. set correct zone id and access token

## Maybe needed
- unblock the script: `Unblock-File -Path 'C:\Path\To\Script.ps1'`
- copy the zone id and access token into renew.ps1 and remove the code that loads the .env file (this may be unsupported on older systems)
