1. Clone the repository
Clone this repository to your local machine:
git clone https://github.com/Anjolaoluwa-Oluyale/Continuous-Threat-Detection-Windows.git

2. Edit the script (optional)
Open the threat-detection.ps1 file and modify it to include any custom patterns, keywords, or events you want to monitor.

3. Run the script
You can run the script manually from PowerShell:
.\threat-detection.ps1
The script will start monitoring Windows Event Logs for any suspicious activity or patterns that match the detection criteria.

4. Continuous Monitoring
Once the script is running, it will continuously check for suspicious activities and notify you when something unusual is detected. To keep it running, you can leave the PowerShell window open or run it in the background using an appropriate method like Start-Process.

Example of running in the background:
Start-Process powershell -ArgumentList "-NoExit -File C:\path\to\threat-detection.ps1"

5. Log Output
The script generates logs of detected threats and activities. These logs can be saved to a file for further analysis, for example:
C:\ThreatDetection\logs\log.txt

Example Log Output
When a potential threat is detected, the log file will include entries like:
[INFO] 2025-02-18 14:30:12 - No threats detected.
[ALERT] 2025-02-18 14:35:20 - Suspicious login attempt detected from IP: 192.168.1.100
[ALERT] 2025-02-18 14:40:45 - Potential privilege escalation attempt detected in Event ID: 4672

To Automate it:
1. Open Task Scheduler:
Press Win + R, type taskschd.msc, and press Enter to open Task Scheduler.

2.Create a New Task:
In Task Scheduler, click Create Task on the right-hand side.

3. Configure Task:
Under the General tab:
Name your task (e.g., "Threat Detection Script").
Check the box Run with highest privileges to ensure the script has the necessary permissions.

Under the Triggers tab:
Click New and select At logon to trigger the task when you log in.

Under the Actions tab:
Click New, then set Action to Start a program.
Browse and select the powershell.exe executable.
In the Add arguments field, enter the full path to your script (e.g., C:\path\to\threat-detection.ps1).

4.Save the Task:
Click OK to save the task.

5.Test the Task:
Restart your system to verify that the script runs automatically when you log in.


How It Works:
The script runs in a continuous loop, checking the Security, System, and Application logs for any failed login attempts (Event ID 4625) and privilege escalation events (Event ID 4672).
If it detects suspicious behavior (failed login attempts above the threshold or privilege escalation), it will send an alert message (you can customize this function to send real alerts like emails).
After each check, the script waits for 10 minutes (Start-Sleep -Minutes 10) before running the next check.

Customizing the Script:
Adjust the Event IDs: If you're looking for different kinds of security events, you can change the Event IDs in the Where-Object filter.
Adjust the Log Names: If you want to analyze additional event logs, you can modify the $logNames array.
Modify Alerts: You can customize the Send-Alert function to send emails or integrate with a Security Information and Event Management (SIEM) tool if needed.

Contributing
Feel free to fork this repository and submit pull requests for improvements, bug fixes, or new features!

