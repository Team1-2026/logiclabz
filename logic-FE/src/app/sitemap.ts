import type { MetadataRoute } from "next";
import { ROUTES, SITE_URL } from "@/lib/seo";

export default function sitemap(): MetadataRoute.Sitemap {
  return ROUTES.map(
    (route: (typeof ROUTES)[number]): MetadataRoute.Sitemap[number] => ({
      url: `${SITE_URL}${route.path === "/" ? "" : route.path}`,
      lastModified: new Date(),
      changeFrequency: route.changeFrequency as MetadataRoute.Sitemap[number]["changeFrequency"],
      priority: route.priority,
    })
  );
}
