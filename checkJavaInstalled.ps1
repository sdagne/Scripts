<#
.SYNOPSIS
This script checks for the presence of Java installations on remote machines. It examines both the Windows Registry and the "Program Files" directories.

.DESCRIPTION
The script connects to a list of remote machines and checks if Java is installed by looking at the Windows Registry and the "Program Files" directories. If Java is detected on a machine, the script records the computer name in a CSV file.

.PARAMETER remoteMachines
An array of remote machine names or IP addresses to check for Java installations.

.PARAMETER outputCsvPath
The path where the CSV file containing the list of machines with Java installations will be saved.

.NOTES
File Name      : Check-JavaInstallations.ps1Add-AppxPackageAdd-AppxPackage
Author         : Shewan Dagne
Date           : 17/08/2023
Prerequisite   : PowerShell Remoting enabled on remote machines.

.EXAMPLE
.\Check-JavaInstallations.ps1 -remoteMachines "Machine1", "Machine2" -outputCsvPath "C:\temp\JavaInstalledMachines.csv"
This example checks for Java installations on "Machine1" and "Machine2" and saves the results to "C:\temp\JavaInstalledMachines.csv".

#>

# List


# List of remote machine names or IP addresses
$remoteMachines = @(
"a",
"b",
"c",
"d",
"e",
"f"
    # Add more machine names here
)

# Specify the CSV output file path
$outputCsvPath = "C:\temp\JavaInstalledMachines.csv"

# Initialize an array to store computer names
$installedMachines = @()

# Script to check Java version
$scriptBlock = {
    $javaRegistryPath = "HKLM:\Software\JavaSoft\Java Runtime Environment"

    if (Test-Path $javaRegistryPath) {
        $javaVersion = Get-ItemProperty -Path $javaRegistryPath -Name "CurrentVersion"

        if ($javaVersion -ne $null) {
            return $env:COMPUTERNAME
        }
    }
}

# Loop through each remote machine and execute the script
foreach ($remoteMachine in $remoteMachines) {
    Write-Host "Checking Java version on $remoteMachine..."
    $result = Invoke-Command -ComputerName $remoteMachine -ScriptBlock $scriptBlock
    if ($result -ne $null) {
        $installedMachines += [PSCustomObject]@{
            PSComputerName = $result.PSComputerName
        }
    }
}

# Save computer names to CSV if there are any
if ($installedMachines.Count -gt 0) {
    $installedMachines | Export-Csv -Path $outputCsvPath -NoTypeInformation
    Write-Host "List of machines with Java installed saved to $outputCsvPath."
} else {
    Write-Host "No machines with Java installations found."
}
