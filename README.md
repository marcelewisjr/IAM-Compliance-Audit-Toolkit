# 🔍 IAM Compliance Audit Toolkit

### 📋 Project Overview
* **The Problem:** Orphaned accounts from former employees posed a significant security risk and complicated compliance audits.
* **The Solution:** Created PowerShell audit scripts to identify inactive accounts and verify multi-factor authentication (MFA) enforcement.
* **Business Impact:** Strengthened the security perimeter by automating **quarterly access reviews**, meeting strict HIPAA and NIST requirements.

### 🛠️ Key Capabilities
* **Orphaned Account Discovery:** Scripts to flag disabled AD users with active licenses.
* **MFA Verification:** Auditing user authentication methods to ensure MFA coverage.
* **Compliance Reporting:** Exporting audit logs for security team review.

### 🔧 Usage
1. Run `.\scripts\Audit-OrphanedAccounts.ps1` to generate a report of high-risk accounts.
2. Review the output log to initiate deprovisioning in ServiceNow.
