# LogicLabz Flutter Application (`logic_flutter`)

The complete cross-platform Flutter application for **LogicLabz Enterprise ERP & Cloud Services**, converted from the Next.js `logic-app` frontend with 100% feature parity, Material 3 responsive styling, and multi-tenant ERP integration.

---

## 📱 Supported Platforms
- **Android** (Phone, Tablet, Foldable)
- **iOS** (iPhone, iPad)
- **macOS Desktop**
- **Web** (Chrome, Safari, Firefox, Edge)

---

## 🚀 Key Features

### 1. Enterprise Services & Modular Pricing
- Interactive software catalog fetching from `logic-be` `/api/v1/catalog` (with robust offline fallback).
- Dynamic module selector (Accounting, Attendance, Batch, Branches, CRM, POS, Sales, etc.).
- Real-time calculation supporting **Flat-Rate** licenses and **Per-User Licensing Tiers** (`1-3`, `4-10`, `11-50`, `51+` users).
- One-off **Setup & Implementation Charge** calculation.
- Live annual renewal estimates.

### 2. Cart & Tax Checkout
- Live cart state with badge notifications.
- Optional addons: Custom Domain (`.com`) and Dedicated Managed NVMe Cloud Server.
- Full statutory **18% GST Breakdown** (`Subtotal`, `CGST 9.0%`, `SGST 9.0%`, `Grand Total`).
- Enterprise billing form: Company Name, Contact, Email, Phone, GSTIN, Address.
- ICICI Bank Payment Gateway & corporate NEFT/RTGS flow with immediate tax invoice issuance.

### 3. Client Operations Portal (`/dashboard`)
- Live license and subscription overview.
- Order history with status tags (`COMPLETED`, `PENDING`).
- Official GST Tax Invoices table with **View / Print Tax Receipt** dialog.

### 4. Official GST Tax Invoice Dialog
- Complete statutory tax invoice matching government requirements.
- Remittance bank details (ICICI Bank A/c, IFSC).
- Customer billed-to details and GSTIN.
- Itemized line items table with quantity, unit rate, and total.
- Printable styling with one-click print simulation.

### 5. Executive Admin Console (`/admin`)
- **KPI Summary Cards**: Revenue, Orders count, Invoices count, ERP status.
- **Invoices Tab**: List invoices, filter paid/unpaid/synced, push local invoice to ERP, generate new invoice modal, delete invoice.
- **Orders Tab**: Customer deployment orders with one-click status toggle (`PENDING` <-> `COMPLETED`).
- **Products Tab**: Catalog listing with base prices, setup costs, and module counts.
- **ERP Customers Tab**: Real-time directory of customers synced from `be-app` ERP with GSTIN.
- **ERP Accounting Tab**: Synced Chart of Accounts (Bank Accounts, Receivables, GST Liability, Revenue, Expenses).

### 6. Multi-Tenant ERP Integration Console (`/admin/erp-config`)
- Dedicated ERP management interface matching `/admin/erp-config`.
- Base API URL, Bearer Secret Token, and **`X-Tenant-Domain`** header configuration.
- One-click presets:
  - **"Load be-app Presets"**: Auto-populates `be-app` sample ERP endpoints and `default` tenant domain.
  - **"ERPLogic Cloud"**: Live production ERP endpoints.
- Live **Test Connection** with ping latency indicator.
- One-click manual sync triggers for Customers, Invoices, and Accounting.

---

## 🛠️ Project Structure

```
logic_flutter/
├── lib/
│   ├── main.dart                      # MultiProvider & Material 3 routing
│   ├── config/
│   │   └── api_config.dart            # Device-aware base URL (Android 10.0.2.2 vs Web/Desktop 127.0.0.1)
│   ├── models/
│   │   ├── user_model.dart            # UserModel & Demo accounts
│   │   ├── product_model.dart         # ProductCatalogItem, ModuleItem, PerUserCharges
│   │   ├── cart_model.dart            # SelectedProduct, PricingSummary
│   │   ├── order_model.dart           # OrderModel
│   │   ├── invoice_model.dart         # InvoiceModel & InvoiceItem
│   │   ├── erp_models.dart            # ErpConfigModel, ErpCustomerModel, ChartOfAccountModel
│   │   └── stats_model.dart           # AdminStatsModel
│   ├── services/
│   │   ├── api_service.dart           # HTTP client with Bearer auth & offline fallback
│   │   ├── auth_service.dart          # Token persistence & demo roles
│   │   ├── catalog_service.dart       # Catalog loader & rich default products
│   │   ├── invoice_service.dart       # Invoices CRUD & ERP sync
│   │   └── erp_service.dart           # ERP test connection & sync triggers
│   ├── providers/
│   │   ├── auth_provider.dart         # Authentication state management
│   │   ├── cart_provider.dart         # Cart & dynamic pricing state
│   │   ├── catalog_provider.dart      # Catalog state
│   │   └── admin_provider.dart        # Admin data & operations state
│   ├── widgets/
│   │   ├── app_navbar.dart            # Responsive top navigation & cart badge
│   │   ├── app_drawer.dart            # Mobile navigation drawer
│   │   ├── invoice_detail_dialog.dart # Official GST tax receipt dialog
│   │   ├── create_invoice_dialog.dart # Generate tax invoice dialog
│   │   └── demo_booking_dialog.dart   # Book a demo modal
│   └── screens/
│       ├── home_screen.dart           # Landing screen
│       ├── services_screen.dart       # Interactive catalog & module configurator
│       ├── checkout_screen.dart       # Cart review & payment
│       ├── dashboard_screen.dart      # Client portal
│       ├── admin_screen.dart          # Admin control tower
│       ├── erp_config_screen.dart     # Dedicated ERP integration screen
│       ├── login_screen.dart          # Login screen with quick demo accounts
│       └── register_screen.dart       # Registration screen
└── test/
    └── widget_test.dart               # Responsive smoke test
```

---

## ⚡ How to Run

### 1. Run on Chrome Web:
```bash
cd logic_flutter
flutter run -d chrome
```

### 2. Run on macOS Desktop:
```bash
cd logic_flutter
flutter run -d macos
```

### 3. Run on Android Emulator:
```bash
cd logic_flutter
flutter run -d android
```

### 4. Run on iOS Simulator:
```bash
cd logic_flutter
flutter run -d ios
```

---

## 🔑 Demo Credentials
Both accounts are accessible with one-click buttons on the Sign In screen (`/login`) or the top-right profile avatar:
- **Admin**: `admin@logiclabz.com` / `admin123`
- **Client**: `client@logiclabz.com` / `password123`
