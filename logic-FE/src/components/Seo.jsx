import { useEffect, useRef } from "react";
import { useLocation } from "react-router-dom";
import {
  SITE_NAME,
  absoluteUrl,
  buildLocalBusinessJsonLd,
  buildOrganizationJsonLd,
  buildWebPageJsonLd,
  buildWebSiteJsonLd,
  getPageSeo,
} from "@/lib/seo";

const JSON_LD_ID = "logiclabz-jsonld";

function upsertMeta(selector, attrs) {
  let el = document.head.querySelector(selector);
  if (!el) {
    el = document.createElement("meta");
    document.head.appendChild(el);
  }
  Object.entries(attrs).forEach(([key, value]) => {
    if (value != null) el.setAttribute(key, value);
  });
}

function upsertLink(rel, href) {
  let el = document.head.querySelector(`link[rel="${rel}"]`);
  if (!el) {
    el = document.createElement("link");
    el.setAttribute("rel", rel);
    document.head.appendChild(el);
  }
  el.setAttribute("href", href);
}

function setJsonLd(schemas) {
  let script = document.getElementById(JSON_LD_ID);
  if (!script) {
    script = document.createElement("script");
    script.id = JSON_LD_ID;
    script.type = "application/ld+json";
    document.head.appendChild(script);
  }
  script.textContent = JSON.stringify(schemas);
}

const Seo = () => {
  const { pathname } = useLocation();
  const seo = getPageSeo(pathname);
  const skipFirstPageView = useRef(true);
  const canonical = absoluteUrl(pathname);
  const keywords = (seo.keywords ?? []).join(", ");

  useEffect(() => {
    if (skipFirstPageView.current) {
      skipFirstPageView.current = false;
    } else {
      if (typeof window.fbq === "function") {
        window.fbq("track", "PageView");
      }
      if (typeof window.gtag === "function") {
        window.gtag("config", "G-BYKRF6MGNW", { page_path: pathname });
      }
    }

    if (!pathname.startsWith("/certifications/")) {
      document.title = seo.title;
    }

    upsertMeta('meta[name="description"]', {
      name: "description",
      content: seo.description,
    });
    upsertMeta('meta[name="keywords"]', {
      name: "keywords",
      content: keywords,
    });
    upsertMeta('meta[name="author"]', {
      name: "author",
      content: SITE_NAME,
    });
    upsertMeta('meta[name="robots"]', {
      name: "robots",
      content: "index, follow",
    });
    upsertMeta('meta[property="og:type"]', {
      property: "og:type",
      content: "website",
    });
    upsertMeta('meta[property="og:site_name"]', {
      property: "og:site_name",
      content: SITE_NAME,
    });
    upsertMeta('meta[property="og:title"]', {
      property: "og:title",
      content: seo.title,
    });
    upsertMeta('meta[property="og:description"]', {
      property: "og:description",
      content: seo.description,
    });
    upsertMeta('meta[property="og:url"]', {
      property: "og:url",
      content: canonical,
    });
    upsertMeta('meta[property="og:locale"]', {
      property: "og:locale",
      content: "en_IN",
    });
    upsertMeta('meta[property="og:image"]', {
      property: "og:image",
      content: absoluteUrl("/logo.png"),
    });
    upsertMeta('meta[name="twitter:card"]', {
      name: "twitter:card",
      content: "summary_large_image",
    });
    upsertMeta('meta[name="twitter:title"]', {
      name: "twitter:title",
      content: seo.title,
    });
    upsertMeta('meta[name="twitter:description"]', {
      name: "twitter:description",
      content: seo.description,
    });
    upsertMeta('meta[name="twitter:image"]', {
      name: "twitter:image",
      content: absoluteUrl("/logo.png"),
    });
    upsertMeta('meta[name="geo.region"]', {
      name: "geo.region",
      content: "IN-KL",
    });
    upsertMeta('meta[name="geo.placename"]', {
      name: "geo.placename",
      content: "Kottayam",
    });

    upsertLink("canonical", canonical);

    setJsonLd([
      buildOrganizationJsonLd(),
      buildLocalBusinessJsonLd(),
      buildWebSiteJsonLd(),
      buildWebPageJsonLd(pathname, seo.title, seo.description),
    ]);
  }, [pathname, seo.title, seo.description, canonical, keywords]);

  return null;
};

export default Seo;
