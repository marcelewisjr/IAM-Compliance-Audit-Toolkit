# File: scripts/Audit-OrphanedAccounts.ps1
<#
.SYNOPSIS
    Identifies orphaned accounts - disabled AD users with active Entra ID/SaaS licenses.
.DESCRIPTION
    Queries Active Directory for disabled accounts, then cross-references against
    Entra ID via Microsoft Graph to flag users that still hold active licenses
    or cloud access after offboarding. Exports a dated CSV for compliance review.
    Aligned to NIST 800-53 AC-2 (Account Management) and AC-3 (Access Enforcement).
.NOTES
    Requires: ActiveDirectory module, Microsoft.Graph module
    Run: Install-Module Microsoft.Graph -Scope CurrentUser
    Permissions: User.Read.All, Directory.Read.All
#>

Import-Module ActiveDirectory

# Connect to Microsoft Graph for Entra ID license data
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -NoWelcome

$Results   = @()
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReportPath = ".\reports\OrphanedAccounts_$Timestamp.csv"

Write-Host "Starting Identity Audit for Orphaned Accounts..." -ForegroundColor Cyan

# Pull all disabled AD accounts that have an email address
# NIST AC-2: Disabled accounts must be reviewed for residual cloud access
$DisabledUsers = Get-ADUser -Filter { Enabled -eq $false } `
                            -Properties SamAccountName, EmailAddress, WhenChanged |
                 Where-Object { $_.EmailAddress -ne $null }

Write-Host "Found $($DisabledUsers.Count) disabled AD accounts to audit." -ForegroundColor Yellow

foreach ($User in $DisabledUsers) {

    # Cross-reference against Entra ID by UPN
    $EntraUser = Get-MgUser -Filter "userPrincipalName eq '$($User.EmailAddress)'" `
                            -Property "DisplayName,AssignedLicenses,AccountEnabled" `
                            -ErrorAction SilentlyContinue

    if ($EntraUser) {
        $LicenseCount  = $EntraUser.AssignedLicenses.Count
        $CloudEnabled  = $EntraUser.AccountEnabled
        $RiskLevel     = "Low"

        # High risk: disabled in AD but still holds licenses or remains cloud-enabled
        if ($LicenseCount -gt 0 -or $CloudEnabled -eq $true) {
            $RiskLevel = "High"
            Write-Host "ALERT: $($User.SamAccountName) - Disabled in AD | Entra Licenses: $LicenseCount | Cloud Enabled: $CloudEnabled" -ForegroundColor Red
        }

        $Results += [PSCustomObject]@{
            Timestamp         = Get-Date
            SamAccountName    = $User.SamAccountName
            Email             = $User.EmailAddress
            ADDisabledDate    = $User.WhenChanged
            EntraCloudEnabled = $CloudEnabled
            ActiveLicenses    = $LicenseCount
            RiskLevel         = $RiskLevel
            RemediationAction = if ($RiskLevel -eq "High") { "Open ServiceNow deprovisioning ticket" } else { "No action required" }
            NISTControl       = "AC-2, AC-3"
        }
    }
}

# Export dated compliance report
if (-not (Test-Path ".\reports")) { New-Item -ItemType Directory -Path ".\reports" | Out-Null }
$Results | Export-Csv -Path $ReportPath -NoTypeInformation

$HighRisk = ($Results | Where-Object { $_.RiskLevel -eq "High" }).Count
Write-Host "`nAudit Complete." -ForegroundColor Cyan
Write-Host "Total accounts reviewed        : $($Results.Count)"
Write-Host "High-risk orphaned accounts    : $HighRisk" -ForegroundColor Red
Write-Host "Report saved to                : $ReportPath" -ForegroundColor Green
