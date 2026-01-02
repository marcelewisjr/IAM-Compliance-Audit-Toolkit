# 📑 Layer 2 (L2) Escalation & Triage Process

This document outlines the standardized workflow for escalating unresolved Tier 1 incidents to the Tier 2 Systems Administration and IAM Engineering teams. Implementing this structure ensures a **20% reduction in unnecessary escalations** and maintains strict SLA compliance.

### 1. Escalation Criteria
Before a ticket is moved to L2, the following "Minimum Viable Data" must be present:
* **User Impact:** Number of users affected (Single, Department, or Site-wide).
* **Troubleshooting Steps:** Documentation of all L1 actions taken (e.g., password reset, cache cleared, local hardware verified).
* **Error Documentation:** Screenshots or logs of the specific error code (e.g., 403 Forbidden, 0x80041010).

### 2. The Workflow Logic


1.  **L1 Triage:** Initial contact and basic troubleshooting.
2.  **Escalation Trigger:** Issue remains unresolved after 30 minutes or requires Administrative/Elevated privileges (AD, Intune, or Exchange Admin).
3.  **L2 Acceptance:** Tier 2 technician reviews the ticket. If "Minimum Viable Data" is missing, the ticket is returned to L1 for further discovery.
4.  **Root Cause Analysis:** L2 performs deep-dive technical discovery using tools like **Datadog, Splunk, or Entra ID logs**.

### 3. Technical Areas for L2 Focus
* **Identity Management:** Complex MFA resets, conditional access policy failures, or orphaned account remediation.
* **Endpoint Security:** BitLocker recovery, Intune policy sync errors, and manual patch deployments.
* **SaaS Administration:** Exchange Online mail-flow issues or ServiceNow group permission conflicts.

### 4. SLA & Resolution Targets
| Priority | Response Target | Resolution Target |
| :--- | :--- | :--- |
| **P1 - Critical** | 15 Minutes | 4 Hours |
| **P2 - High** | 1 Hour | 8 Hours |
| **P3 - Moderate** | 4 Hours | 3 Business Days |
