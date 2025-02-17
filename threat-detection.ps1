# Define the event logs to monitor (e.g., Security, System, Application)
$logNames = @("Security", "System", "Application")

# Define threshold values for alerts (e.g., 5 failed login attempts within 10 minutes)
$failedLoginThreshold = 5
$timeWindow = (Get-Date).AddMinutes(-10)

# Function to check failed login attempts in the last 10 minutes
function Check-FailedLoginAttempts {
    $failedLogins = Get-WinEvent -LogName Security |
                    Where-Object { $_.Id -eq 4625 -and $_.TimeCreated -gt $timeWindow }  # Event ID 4625 is for failed login attempts
    
    # Group by user and check for threshold
    $failedLoginsGrouped = $failedLogins | Group-Object -Property Message
    foreach ($group in $failedLoginsGrouped) {
        if ($group.Count -ge $failedLoginThreshold) {
            Write-Host "ALERT: Failed login attempts detected for user $($group.Name)"
            Send-Alert "Multiple failed login attempts detected for user $($group.Name)"
        }
    }
}

# Function to check for Privilege Escalation (Event ID 4672)
function Check-PrivilegeEscalation {
    $privEscalationEvents = Get-WinEvent -LogName Security |
                            Where-Object { $_.Id -eq 4672 -and $_.TimeCreated -gt $timeWindow }  # Event ID 4672 is for privilege escalation
    
    if ($privEscalationEvents.Count -gt 0) {
        Write-Host "ALERT: Privilege escalation detected."
        Send-Alert "Privilege escalation detected"
    }
}

# Function to send alerts (could be extended to email or integration with other systems)
function Send-Alert {
    param([string]$message)

    # Here you can implement an email alert or an integration with other tools (e.g., SIEM)
    Write-Host "Sending Alert: $message"
    # Example: Send-MailMessage -To "admin@example.com" -Subject "Security Alert" -Body $message -SmtpServer "smtp.example.com"
}

# Main loop to check logs every 10 minutes
while ($true) {
    foreach ($logName in $logNames) {
        Write-Host "Analyzing log: $logName"
        # Check for failed login attempts and privilege escalation in each log
        Check-FailedLoginAttempts
        Check-PrivilegeEscalation
    }
    
    # Wait for 10 minutes before checking again
    Start-Sleep -Minutes 10
}
