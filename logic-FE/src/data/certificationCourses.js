export const STATIC_COURSES = [
  {
    slug: "laravel-certification",
    title: "Laravel Certification",
    category: "Backend",
    duration: "6 weeks",
    icon: "GraduationCap",
    description:
      "A hands-on certification covering Laravel application structure, Eloquent, authentication, queues, and production deployment.",
    image: null,
    highlights: ["Routing & Eloquent", "Auth & policies", "Queues & testing", "Deployment"],
    is_featured: true,
  },
  {
    slug: "react-nextjs-certification",
    title: "React & Next.js Certification",
    category: "Frontend",
    duration: "5 weeks",
    icon: "Code2",
    description:
      "Build production React and Next.js interfaces — component design, data fetching, and performance for real product teams.",
    image: null,
    highlights: ["React components", "Next.js routing", "Data fetching", "Performance"],
    is_featured: true,
  },
  {
    slug: "flutter-app-development",
    title: "Flutter App Development",
    category: "Mobile",
    duration: "6 weeks",
    icon: "Smartphone",
    description:
      "Ship cross-platform mobile apps with Flutter, covering UI, state, APIs, and release-ready builds.",
    image: null,
    highlights: ["Widget layout", "State management", "API integration", "Store release"],
    is_featured: false,
  },
];

export const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
