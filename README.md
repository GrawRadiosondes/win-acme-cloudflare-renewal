# General

## Problem
An IIS Website needs to be served inside the intranet but traffic needs to be SSL encrypted using HTTPS.  
The Server has outgoing, but no incoming internet connections.  
Providing a local CA is cumbersome and difficult to operate securely.

## Solution
Public certs and public domain that points to a local ip.

> "Use public certs, but for internal addresses."

https://security.stackexchange.com/questions/121163/how-do-i-run-proper-https-on-an-internal-network/174743#174743

### Script to generate the cert and automatically renew
https://www.win-acme.com

For "How would you like prove ownership for the domain(s)?" choose "[dns] Create verification records with your own script".

# Setup
1. create access token with dns edit permission for the zone (https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
2. copy .env.example to .env
3. copy .env to the location of wacs.exe
4. set correct zone id and access token

## Maybe needed
- unblock the script via powershell: `Unblock-File -Path 'C:\Path\To\Script.ps1'`
- copy the zone id and access token into renew.ps1 and remove the code that loads the .env file because this may be unsupported on older systems
