# LogicLabz Website — Master Prompt

Use this prompt when generating or updating copy, metadata, blog posts, or marketing assets for **https://logiclabz.co.in**.

---

## Brand

| Item | Value |
|------|--------|
| **Company** | LogicLabz |
| **Domain** | logiclabz.co.in |
| **Location** | Kottayam, Kerala, India |
| **Tone** | Premium, technical, confident — senior engineering partner, not a generic agency |
| **Colors** | Teal `#00A9C1`, Gold `#F9C80E`, Black `#000000` |
| **Audience** | Founders, CTOs, operators in India (especially Kerala) evaluating ERP, accounting software, and custom development partners |

---

## Primary SEO Keywords (use naturally — never stuff)

1. software development company  
2. ERP providers  
3. software companies in India  
4. software companies in Kerala  
5. software companies in Kottayam  
6. custom software development  
7. accounting software  

**Secondary:** enterprise web development, Laravel, Next.js, Flutter, Docker, fuel management ERP, student scheduling software.

---

## Site Prompt (copy & structure)

```
You are writing for LogicLabz (logiclabz.co.in), a software development company
based in Kottayam, Kerala, India. We are ERP providers specializing in custom
software development and accounting software for businesses across India.

Requirements:
- Mention Kottayam / Kerala / India where relevant for local SEO (1–2 times per page max).
- Highlight: ERP systems, accounting software, custom software development, enterprise web & mobile.
- Keep paragraphs short. Use active voice. No hype clichés ("world-class", "cutting-edge").
- Every page needs one clear H1, supporting H2s, and a CTA to /contact.
- Meta title: 50–60 characters, include "LogicLabz" and location or service where fitting.
- Meta description: 150–160 characters, include 2–3 target keywords naturally.

Pages:
- Home: Hero + services overview + ERP/accounting proof + process + CTA
- Services: 8 capability cards (web, mobile, Docker, data, AI, security, modernization, augmentation)
- Portfolio: Logic ERP, Fuel Management, Accounting Module, Scheduling
- About: Story, values, why LogicLabz vs generic vendors
- Contact: Form, Kottayam Kerala location, hello@
```

---

## Per-Page Meta Prompts

### Home (`/`)

**Title:** `LogicLabz | Software Development Company in Kottayam, Kerala`  
**Description:** `ERP providers and custom software development in Kottayam, Kerala. LogicLabz builds accounting software, enterprise web apps, and mobile solutions across India.`  
**H1 angle:** Scalable digital ecosystems + software company in Kerala.

---

### Services (`/services`)

**Title:** `Custom Software & ERP Services | LogicLabz Kottayam`  
**Description:** `ERP development, custom software, and accounting software from a software development company in Kottayam, Kerala — serving teams across India.`  
**Focus:** Map each service card to keywords (ERP, accounting, custom dev).

---

### Portfolio (`/portfolio`)

**Title:** `ERP & Accounting Software Portfolio | LogicLabz`  
**Description:** `Case studies: Logic ERP, fuel management, accounting modules, and scheduling — built by a software company in Kottayam, Kerala.`  
**Focus:** Proof for "ERP providers" and "accounting software" searches.

---

### About (`/about`)

**Title:** `About LogicLabz | Software Company in Kottayam, Kerala`  
**Description:** `Senior engineers in Kottayam delivering ERP and custom software for Indian enterprises — depth over generic agency output.`  

---

### Contact (`/contact`)

**Title:** `Contact LogicLabz | Software Development Kottayam`  
**Description:** `Book a consult for ERP, accounting software, or custom development. LogicLabz — Kottayam, Kerala, India.`  

---

## JSON-LD / Technical SEO Checklist

- [x] `sitemap.xml` via Next.js `src/app/sitemap.ts`
- [x] `robots.txt` via `src/app/robots.ts`
- [x] Organization + LocalBusiness + WebPage schema (client `Seo` component)
- [x] Canonical URLs on `logiclabz.co.in`
- [x] Open Graph + Twitter cards
- [ ] Submit sitemap in Google Search Console after deploy
- [ ] Set `NEXT_PUBLIC_SITE_URL=https://logiclabz.co.in` in production env
- [ ] Replace placeholder phone in `src/lib/seo.js` when available

---

## Sample Paragraph (Home hero — optional)

> LogicLabz is a **software development company** in **Kottayam, Kerala** — **ERP providers** for operators who need **custom software development**, **accounting software**, and platforms that scale. From our base in India, we ship Laravel, React, and Flutter systems with the same rigor as global product teams.

---

## Image Alt-Text Prompt

```
Write alt text for LogicLabz marketing images. Include service context (ERP, accounting,
mobile, Docker) where relevant. Max 125 characters. Do not start with "Image of".
Brand: LogicLabz, Kottayam Kerala software company.
```

---

*Last updated: 2026 — align with `src/lib/seo.js` for live meta values.*
