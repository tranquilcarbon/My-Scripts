# Check if the current theme is Light or Dark
$theme = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount" -Name "SystemSettings::Globalization::ColorPreferDarkMode").PSObject.Properties.Item('Value').Value

# Prompt the user for their preference
$userPreference = Read-Host "Enter 'dark' to switch to Dark Mode, or 'light' to switch to Light Mode"

# Convert user input to lowercase for comparison
$lowerUserPreference = $userPreference.ToLower()

# Check if the user's preference is valid
if ($lowerUserPreference -eq 'dark' -or $lowerUserPreference -eq 'light') {
    # Set the system theme based on the user's preference
    switch ($lowerUserPreference) {
        'dark' {
            if ($theme -ne 1) {
                Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount" -Name "SystemSettings::Globalization::ColorPreferDarkMode" -Value 1
                Write-Host "Switched to Dark Mode."
            } else {
                Write-Host "You are already in Dark Mode."
            }
        }
        'light' {
            if ($theme -ne 0) {
                Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount" -Name "SystemSettings::Globalization::ColorPreferDarkMode" -Value 0
                Write-Host "Switched to Light Mode."
            } else {
                Write-Host "You are already in Light Mode."
            }
        }
    }
} else {
    Write-Host "Invalid input. Please enter 'dark' or 'light'."
}
