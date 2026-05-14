# Pyonair Invoice

**Your AI Team. Trained on You.**

Professional invoicing with quotes, recurring billing, online payments, and client management. Beautiful modern UI for service businesses. Part of the Pyonair AI Team platform.

---

## Features

- **Quotes & Invoices** - Create professional quotes and convert them to invoices in one click
- **Recurring Billing** - Automate recurring invoices on flexible schedules
- **Online Payments** - Accept payments via Stripe, PayPal, and other gateways
- **Client Management** - Organize clients, contacts, and track payment history
- **Multi-Currency** - Full multi-currency support with proper money handling
- **Tax Management** - Configure tax rates and discounts (percentage or fixed)
- **Branded PDFs** - Generate professional PDF invoices and quotes
- **REST API** - Full API (JSON-LD, JSON-HAL, JSON, XML) powered by API Platform 4
- **AI Agent Integration** - Built-in MCP server for AI automation
- **Multi-Tenancy** - Run multiple companies from one install

## Brand

| Element | Value |
|---------|-------|
| Primary Red | `#E63946` |
| Navy | `#0F172A` |
| Font | Inter |

## Tech Stack

- **Framework**: Symfony 7
- **Language**: PHP 8.4
- **Database**: MySQL / PostgreSQL
- **Frontend**: Tabler UI, Bootstrap 5.3, Stimulus, Webpack Encore
- **API**: API Platform 4
- **Payments**: Payum (Stripe, PayPal, and more)

## Quick Start

### Docker

```bash
docker run -p 8080:80 solidinvoice/solidinvoice
```

### From Source

```bash
git clone https://github.com/pyonair-hub/pyonair-invoice.git
cd pyonair-invoice
composer install
bun install && bun run dev
```

**Requirements:** PHP 8.4+, ext-curl, ext-gd, ext-intl, ext-openssl, ext-pdo, ext-soap, ext-xsl, MySQL/MariaDB or PostgreSQL.

## License

MIT License

Built on [SolidInvoice](https://github.com/SolidInvoice/SolidInvoice) (MIT License).

## Links

- [Pyonair](https://pyonair.com)
