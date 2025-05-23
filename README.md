# GenC Bank Management System

A Salesforce-based application designed to streamline core banking operations such as account management, transactions, loan processing, and customer service. This project leverages Salesforce's standard and custom objects, screen flows, approval processes, and Lightning components to offer an end-to-end banking experience.

---

## 🌟 Features

### 🏦 Account Management
- Open new accounts via interactive screen flows.
- KYC verification with approval process.
- Auto email notifications on account creation.
- PAN card validation with image uploads.
- Account freezing/unfreezing functionality.

### 💳 Transaction Management
- Perform deposits, withdrawals, and fund transfers.
- Track all transactions with automated balance updates.
- Email alerts for each transaction.
- Prevents overdrafts and enforces minimum balance requirements.

### 🔄 Fund Transfer
- Internal bank account transfers with validations.
- Screen flow enabled for ease of use.
---

## 📚 Use Cases Implemented

- Secure account creation with PAN verification.
- KYC submission and approval system.
- Real-time transaction recording with validation.
- Customer portal using Experience Cloud.
- Dynamic dashboards and reports for analysis.

---

## 🧩 Data Model

### Objects Used
| Object Type      | Name               | Description                       |
|------------------|--------------------|-----------------------------------|
| Standard Contact | Bank Account       | Customer account information      |
| Standard Account | Branch             | Bank branch data                  |
| Custom           | Bank               | Bank details                      |
| Custom           | Deposit            | Deposit transactions              |
| Custom           | Withdrawal         | Withdrawal transactions           |
| Custom           | Transfer           | Fund transfers between accounts   |
| Custom           | Transaction        | Unified transaction log           |

### Key Fields & Validations
- **PAN Card**: Format validation and mandatory check.
- **Initial Deposit**: Minimum ₹2000, non-editable post-creation.
- **Phone Number**: Must be exactly 10 digits.
- **Freeze Status**: Restricts transaction if account is frozen.

---

## 🔐 Security & Sharing

- Role-based access control for customers and employees.
- Record-level sharing and field-level visibility settings.
- Email and alert-based notification flows.

---

## ⚙️ Automation & Flows

- Screen Flows:
  - Account creation
  - Freeze/Unfreeze account
  - Transfer funds
- Record-Trigger Flows:
  - Email on account creation/update
- Approval Processes:
  - KYC verification
  - Loan application approval

---

## 📊 Reports & Dashboards

- **Account Overview Report** – List of all accounts by type and branch.
- **Deposit Trends** – Monthly deposit statistics.
- **Transaction Analysis** – Transfers and activity logs.
- **Withdrawal & Reserve Health** – Cash reserve insights.

---

## ⚡ Lightning Components

- Custom Lightning Web Components (LWC) for:
  - Transaction panels
  - Account overview
  - 
- Lightning Messaging Service for cross-component communication.

---

## 🌐 Experience Cloud

- Customer-facing portal to:
  - View account status
  - Perform basic banking operations
  - Submit service requests

---

## 📁 Folder Structure

```bash
src/
├── apex/                   # Apex classes, triggers, handlers
├── lwc/                    # Lightning Web Components
├── flows/                  # Screen & record-triggered flows
├── reports/                # Dashboard components and report definitions
├── experienceCloud/        # Customer portal configurations
├── approvalProcesses/      # KYC approval workflows
# 🚀 Getting Started
```
# 🚀 Getting Started
## Clone the repo

```bash
git clone (https://github.com/HaswanthKurevella/Bank-Management-System.git)
```
## Deploy to your Salesforce Org using SFDX
```bash
sfdx force:source:deploy -p force-app
```
# Team Members
- Pujitha
- Sravya
- Sai Kiran
- Prayatakshnaa
- Haswanth Kumar
  
#👨‍💻 Author
Haswanth – Salesforce Developer and Admin

#📄 License
This project is licensed under the MIT License.
