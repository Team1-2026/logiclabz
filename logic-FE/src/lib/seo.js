export const SITE_URL =
  process.env.NEXT_PUBLIC_SITE_URL ?? "https://logiclabz.co.in";

export const SITE_NAME = "LogicLabz";

export const DEFAULT_TITLE =
  "LogicLabz | Software Development Company in Kottayam, Kerala";

export const DEFAULT_DESCRIPTION =
  "LogicLabz is a highly skilled software development company with 16+ years of experience delivering custom, scalable, and high-performance web solutions. We have completed 500+ successful projects globally.";

export const SEO_KEYWORDS = [
  "software development company",
  "ERP providers",
  "ERP provider Kerala",
  "software companies in India",
  "software companies in Kerala",
  "software companies in Kottayam",
  "custom software development",
  "accounting software",
  "LogicLabz",
  "logiclabz.co.in",
  "enterprise software Kerala",
  "web development Kottayam",
  "mobile app development Kerala",
];

/** @type {const} */
export const ROUTES = [
  { path: "/", priority: 1, changeFrequency: "weekly" },
  { path: "/services", priority: 0.9, changeFrequency: "monthly" },
  { path: "/products", priority: 0.9, changeFrequency: "monthly" },
  { path: "/certifications", priority: 0.9, changeFrequency: "monthly" },
  { path: "/portfolio", priority: 0.9, changeFrequency: "monthly" },
  { path: "/about", priority: 0.8, changeFrequency: "monthly" },
  { path: "/top-level-team", priority: 0.85, changeFrequency: "monthly" },
  { path: "/contact", priority: 0.85, changeFrequency: "monthly" },
  { path: "/terms", priority: 0.3, changeFrequency: "yearly" },
  { path: "/privacy", priority: 0.3, changeFrequency: "yearly" },
];

export const PAGE_SEO = {
  "/": {
    title: DEFAULT_TITLE,
    description: DEFAULT_DESCRIPTION,
    keywords: SEO_KEYWORDS,
  },
  "/services": {
    title: "Custom Software & ERP Services | LogicLabz Kottayam",
    description:
      "ERP development, custom software development, accounting software, and enterprise web platforms. LogicLabz — software development company serving Kerala and India.",
    keywords: [
      ...SEO_KEYWORDS,
      "ERP development services",
      "custom ERP Kerala",
    ],
  },
  "/products": {
    title: "ERP & Business Software Products | LogicLabz",
    description:
      "Explore LogicLabz products — Logic ERP, fuel management, accounting modules, and scheduling systems built for Indian businesses.",
    keywords: [
      ...SEO_KEYWORDS,
      "ERP software products",
      "fuel management software",
      "accounting software Kerala",
    ],
  },
  "/certifications": {
    title: "Certification Courses | LogicLabz",
    description:
      "Certification courses in Laravel, React, Next.js, and Flutter from LogicLabz in Kottayam, Kerala.",
    keywords: [...SEO_KEYWORDS, "certification courses", "Laravel training Kerala"],
  },
  "/portfolio": {
    title: "ERP & Accounting Software Portfolio | LogicLabz",
    description:
      "Explore Logic ERP, fuel management, accounting modules, and scheduling systems built by our software company in Kottayam, Kerala.",
    keywords: [
      ...SEO_KEYWORDS,
      "ERP software portfolio",
      "accounting software India",
    ],
  },
  "/about": {
    title: "About LogicLabz | Software Company in Kottayam, Kerala",
    description:
      "Meet LogicLabz — senior engineers delivering scalable software for founders and enterprises across India, from our base in Kottayam, Kerala.",
    keywords: SEO_KEYWORDS,
  },
  "/top-level-team": {
    title: "Top Level Team | LogicLabz Leadership",
    description:
      "Meet LogicLabz leadership — Jesvin Mathew (CTO), Tojo (Marketing Head India), Nikhil (Marketing Head UK & Europe), and Soger (Business Analyst).",
    keywords: [
      ...SEO_KEYWORDS,
      "LogicLabz team",
      "CTO Kottayam",
      "software company leadership",
    ],
  },
  "/marketing-team": {
    title: "Top Level Team | LogicLabz Leadership",
    description:
      "Meet LogicLabz leadership — Jesvin Mathew (CTO), Tojo (Marketing Head India), Nikhil (Marketing Head UK & Europe), and Soger (Business Analyst).",
    keywords: [
      ...SEO_KEYWORDS,
      "LogicLabz team",
      "CTO Kottayam",
      "software company leadership",
    ],
  },
  "/contact": {
    title: "Contact LogicLabz | Software Development Kottayam",
    description:
      "Start your ERP or custom software project. Contact LogicLabz in Kottayam, Kerala — accounting software, enterprise web, and mobile development.",
    keywords: [
      ...SEO_KEYWORDS,
      "hire software developers Kerala",
    ],
  },
  "/terms": {
    title: "Terms & Conditions | LogicLabz",
    description: "Terms and conditions of service for custom software development and ERP solutions by LogicLabz.",
    keywords: SEO_KEYWORDS,
  },
  "/privacy": {
    title: "Privacy Policy | LogicLabz",
    description: "Privacy policy and data protection practices of LogicLabz for custom software development.",
    keywords: SEO_KEYWORDS,
  },
};

export const ORGANIZATION = {
  name: SITE_NAME,
  legalName: "LogicLabz",
  url: SITE_URL,
  logo: `${SITE_URL}/logo.png`,
  email: "hello@logiclabz.co.in",
  telephone: "+91-90610-33764",
  address: {
    addressLocality: "Kottayam",
    addressRegion: "Kerala",
    addressCountry: "IN",
  },
  geo: {
    latitude: "9.5916",
    longitude: "76.5222",
  },
  areaServed: ["India", "Kerala", "Kottayam"],
  sameAs: [],
};

export function getPageSeo(pathname) {
  if (PAGE_SEO[pathname]) return PAGE_SEO[pathname];
  if (pathname.startsWith("/certifications/")) {
    return {
      title: "Certification Course | LogicLabz",
      description:
        "View a LogicLabz certification course and send an enquiry for the next batch.",
      keywords: [...SEO_KEYWORDS, "certification courses"],
    };
  }
  return PAGE_SEO["/"];
}

export function absoluteUrl(path = "/") {
  const base = SITE_URL.replace(/\/$/, "");
  if (!path || path === "/") return `${base}/`;
  const normalized = path.startsWith("/") ? path : `/${path}`;
  return `${base}${normalized}`;
}

export function buildOrganizationJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: ORGANIZATION.name,
    url: ORGANIZATION.url,
    logo: ORGANIZATION.logo,
    email: ORGANIZATION.email,
    description: DEFAULT_DESCRIPTION,
    address: {
      "@type": "PostalAddress",
      addressLocality: ORGANIZATION.address.addressLocality,
      addressRegion: ORGANIZATION.address.addressRegion,
      addressCountry: ORGANIZATION.address.addressCountry,
    },
    areaServed: ORGANIZATION.areaServed.map((name) => ({
      "@type": "AdministrativeArea",
      name,
    })),
  };
}

export function buildLocalBusinessJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "ProfessionalService",
    name: `${SITE_NAME} — Software Development Company`,
    image: ORGANIZATION.logo,
    url: ORGANIZATION.url,
    email: ORGANIZATION.email,
    description: DEFAULT_DESCRIPTION,
    priceRange: "$$",
    address: {
      "@type": "PostalAddress",
      addressLocality: ORGANIZATION.address.addressLocality,
      addressRegion: ORGANIZATION.address.addressRegion,
      addressCountry: ORGANIZATION.address.addressCountry,
    },
    geo: {
      "@type": "GeoCoordinates",
      latitude: ORGANIZATION.geo.latitude,
      longitude: ORGANIZATION.geo.longitude,
    },
    areaServed: ["Kottayam", "Kerala", "India"],
    knowsAbout: [
      "Software development",
      "ERP systems",
      "Custom software development",
      "Accounting software",
    ],
  };
}

export function buildWebSiteJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: SITE_NAME,
    url: SITE_URL,
    description: DEFAULT_DESCRIPTION,
    publisher: { "@type": "Organization", name: SITE_NAME },
    inLanguage: "en-IN",
  };
}

export function buildWebPageJsonLd(pathname, title, description) {
  return {
    "@context": "https://schema.org",
    "@type": "WebPage",
    name: title,
    description,
    url: absoluteUrl(pathname),
    isPartOf: { "@type": "WebSite", url: SITE_URL, name: SITE_NAME },
    about: {
      "@type": "Thing",
      name: "Software development and ERP solutions",
    },
  };
}
