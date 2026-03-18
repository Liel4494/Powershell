# Server Cacher Scrips
The script can enable cache/mlp for costumer instances in AWS.


### Prerequisites
1. AWSCLI for powershell.
2. AWS.Tools
3. AWS.SimpleSystemsManagement module for Powershell. 

### notice
Every time you  running  the script in new powershell session, you **must** enter AWS credentials.
## How It's  Work.
1. After you enter the costumer instance name, the scrip search the Customer in all the regions (Virginia,Frankfurt,Mumbai).
2. The script ask you to choose between 4 options:

- Enable Server Cache.
- Disable Server Cache.
- Start powershell session - Powershell session start immediately in the same windows. 
- Set New Password - Generate random password and replace the old one.


## Enable/Disable Server Cache
If you choose this option, command to run **AWS System Manager document** will send to the instance.
You can see the "MLPSwitch" document [here](https://lielcohen.notion.site/Server-Cacher-9f62d81451da412993694c30effd4ae2).

The document get "true" or "false" string parameter, and run on the instance, download from S3 bucket powershell script named **MLPSwitch.ps1** to 'C:\\' drive, and execute it with the "true" / "false" parameters.


## Inside MLPSwitch.ps1
1. **MLPSwitch.ps1** modify the **application-tenant.yml** file and add the requested lines to enable cache.
2. **MLPSwitch.ps1** restart the server.exe service.
3. **MLPSwitch.ps1** check if the service is up in this log file:\
*(C:\Program Files\Server\managementServer\server.out.log)*
4. **MLPSwitch.ps1** print out message if the server is up or down.
