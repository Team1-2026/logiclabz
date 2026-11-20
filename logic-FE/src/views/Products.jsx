import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import {
  Building2,
  Fuel,
  Calculator,
  CalendarDays,
  Package,
  ArrowRight,
  ArrowUpRight,
  Star,
} from "lucide-react";
import { Link } from "react-router-dom";
import DynamicIcon from "@/components/DynamicIcon";
import { useTheme } from "@/context/ThemeContext";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const STATIC_PRODUCTS = [
  {
    slug: "logic-erp",
    title: "Logic ERP",
    category: "ERP Solutions",
    icon: Building2,
    description:
      "An end-to-end ERP suite consolidating finance, inventory and HR — modular architecture for growing enterprises.",
    image:
      "https://static.prod-images.emergentagent.com/jobs/ab47ab39-9ae3-4f62-903a-fabf5bc57ffb/images/45be161bcc51a044c5702a318c198d20c44fc4b1b78f6db7bf2706edff118dac.png",
    features: ["Finance", "Inventory", "HR", "Multi-branch"],
    is_featured: true,
  },
  {
    slug: "fuel-management-suite",
    title: "Fuel Management Suite",
    category: "Fuel Management",
    icon: Fuel,
    description:
      "Petrol pump software for opening/closing readings, multi-nozzle sales, and payment reconciliation.",
    image: null,
    features: ["Nozzle tracking", "Cash · UPI · Card", "Daily close"],
    is_featured: true,
  },
  {
    slug: "accounting-modules",
    title: "Accounting Modules",
    category: "Accounting",
    icon: Calculator,
    description:
      "Ledger, GST, invoicing and reporting modules built for Indian compliance and day-to-day ops.",
    image: null,
    features: ["GST ready", "Invoicing", "Ledgers"],
    is_featured: false,
  },
  {
    slug: "scheduling-system",
    title: "Scheduling System",
    category: "Operations",
    icon: CalendarDays,
    description:
      "Conflict-aware scheduling for institutions and teams — auto-resolve overlaps and save admin hours.",
    image: null,
    features: ["Auto conflict resolve", "Multi-role", "Reports"],
    is_featured: false,
  },
];

const Products = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";
  const [productList, setProductList] = useState(STATIC_PRODUCTS);

  useEffect(() => {
    const API_BASE_URL =
      process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000";
    fetch(`${API_BASE_URL}/api/products`)
      .then((res) => {
        if (!res.ok) throw new Error("API failed");
        return res.json();
      })
      .then((data) => {
        if (Array.isArray(data) && data.length > 0) {
          setProductList(data);
        }
      })
      .catch((err) => {
        console.warn(
          "Using offline fallback products due to API error:",
          err.message
        );
      });
  }, []);

  const renderIcon = (iconSource, className) => {
    if (typeof iconSource === "string") {
      return <DynamicIcon name={iconSource} className={className} />;
    }
    const IconComponent = iconSource || Package;
    return <IconComponent className={className} />;
  };

  return (
    <div data-testid="products-page" className="pt-28 pb-24">
      <section className="relative overflow-hidden pb-12">
        <div
          className={`absolute inset-0 ${
            isDark ? "hero-mesh opacity-60" : "hero-mesh-light"
          }`}
        />
        <div className="relative max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div
            initial={{ opacity: 0, y: 14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="max-w-3xl"
          >
            <span
              className={`inline-flex px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
                isDark
                  ? "border-[#007AFF]/40 bg-[#007AFF]/10"
                  : "border-[#007AFF]/30 bg-[#007AFF]/5"
              }`}
            >
              Our Products
            </span>
            <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
              Built Products.{" "}
              <span className="text-[#007AFF]">Ready to Scale.</span>
            </h1>
            <p
              className={`mt-6 text-lg leading-relaxed ${
                isDark ? "text-slate-300" : "text-slate-600"
              }`}
            >
              ERP, fuel management, accounting, and operations products —
              engineered in Kottayam for teams that need reliability on day one.
            </p>
          </motion.div>
        </div>
      </section>

      <section className="max-w-7xl mx-auto px-6 sm:px-10">
        <div className="grid sm:grid-cols-2 gap-5">
          {productList.map((p, i) => (
            <motion.div
              key={p.slug || p.title || i}
              {...fadeUp}
              transition={{ ...fadeUp.transition, delay: (i % 2) * 0.06 }}
              data-testid={`product-card-${i}`}
              className={`group relative overflow-hidden rounded-3xl border transition-all ${
                isDark
                  ? "border-white/10 bg-[#0a1628]/70 hover:border-[#007AFF]/50"
                  : "border-black/8 bg-white shadow-sm hover:border-[#007AFF]/40 hover:shadow-md"
              }`}
            >
              {p.image ? (
                <div className="aspect-[16/9] overflow-hidden">
                  <img
                    src={p.image}
                    alt={p.title}
                    className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-[1.03]"
                  />
                </div>
              ) : (
                <div
                  className={`aspect-[16/9] grid place-items-center ${
                    isDark
                      ? "bg-gradient-to-br from-[#007AFF]/20 via-[#0a1628] to-transparent"
                      : "bg-gradient-to-br from-[#007AFF]/10 via-slate-50 to-white"
                  }`}
                >
                  {renderIcon(p.icon, "w-12 h-12 text-[#007AFF]")}
                </div>
              )}

              <div className="p-7 sm:p-8">
                <div className="flex items-center gap-2 flex-wrap">
                  <span
                    className={`text-[11px] px-2.5 py-1 rounded-full border uppercase tracking-wide font-semibold text-[#007AFF] ${
                      isDark
                        ? "border-[#007AFF]/30 bg-[#007AFF]/10"
                        : "border-[#007AFF]/25 bg-[#007AFF]/5"
                    }`}
                  >
                    {p.category}
                  </span>
                  {(p.is_featured === true || p.is_featured === 1) && (
                    <span className="inline-flex items-center gap-1 text-[11px] px-2.5 py-1 rounded-full bg-amber-500/15 text-amber-600 font-semibold">
                      <Star className="w-3 h-3" /> Featured
                    </span>
                  )}
                </div>

                <div className="mt-4 flex items-start gap-3">
                  {!p.image && (
                    <div className="w-10 h-10 rounded-full bg-[#007AFF]/15 grid place-items-center shrink-0 mt-0.5">
                      {renderIcon(p.icon, "w-4 h-4 text-[#007AFF]")}
                    </div>
                  )}
                  <div className="min-w-0">
                    <h3 className="text-xl sm:text-2xl font-bold tracking-tight">
                      {p.title}
                    </h3>
                    <div className="mt-2 w-8 h-0.5 bg-[#007AFF] rounded-full" />
                  </div>
                </div>

                <p
                  className={`mt-4 text-sm leading-relaxed ${
                    isDark ? "text-slate-400" : "text-slate-600"
                  }`}
                >
                  {p.description}
                </p>

                <div className="mt-5 flex flex-wrap gap-2">
                  {p.features?.map((f) => (
                    <span
                      key={f}
                      className={`text-[11px] px-2.5 py-1 rounded-full border ${
                        isDark
                          ? "border-white/10 text-slate-300"
                          : "border-black/10 text-slate-700"
                      }`}
                    >
                      {f}
                    </span>
                  ))}
                </div>
              </div>

              <div className="absolute right-6 top-6 opacity-0 group-hover:opacity-100 transition">
                <ArrowUpRight className="w-4 h-4 text-[#007AFF]" />
              </div>
            </motion.div>
          ))}
        </div>

        <motion.div
          {...fadeUp}
          className={`mt-20 relative overflow-hidden rounded-3xl p-10 sm:p-14 border ${
            isDark
              ? "border-white/10 bg-gradient-to-br from-[#007AFF]/15 via-[#0a1628]/60 to-transparent"
              : "border-black/8 bg-gradient-to-br from-[#007AFF]/8 via-white to-slate-50"
          }`}
        >
          <div className="absolute -right-20 -bottom-20 w-80 h-80 bg-[#007AFF]/15 blur-3xl rounded-full" />
          <div className="relative grid md:grid-cols-2 gap-8 items-center">
            <div>
              <h2 className="text-3xl sm:text-4xl font-bold tracking-tighter">
                Need a product tailored to your ops?
              </h2>
              <p
                className={`mt-4 ${
                  isDark ? "text-slate-300" : "text-slate-600"
                }`}
              >
                We adapt our product suites — or build net-new — around how your
                teams actually work.
              </p>
            </div>
            <div className="flex md:justify-end">
              <Link
                to="/contact"
                data-testid="products-cta"
                className="inline-flex items-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold brand-glow transition-all"
              >
                Talk to us <ArrowRight className="w-4 h-4" />
              </Link>
            </div>
          </div>
        </motion.div>
      </section>
    </div>
  );
};

export default Products;
