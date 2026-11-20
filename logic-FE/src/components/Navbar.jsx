import { Link, NavLink, useLocation } from "react-router-dom";
import { useEffect, useState } from "react";
import { Menu, X, ChevronDown } from "lucide-react";
import { useTheme } from "@/context/ThemeContext";
import { motion, AnimatePresence } from "framer-motion";

const navLinks = [
  { to: "/", label: "Home", end: true },
  { to: "/about", label: "About Us" },
  { to: "/services", label: "Services", hasDropdown: true },
  { to: "/products", label: "Products" },
  { to: "/certifications", label: "Courses" },
  { to: "/portfolio", label: "Portfolio" },
  { to: "/top-level-team", label: "Top Level Team" },
  { to: "/contact", label: "Contact" },
];

const serviceLinks = [
  { to: "/services", label: "All Services" },
  { to: "/services#web", label: "Web & Mobile" },
  { to: "/services#cloud", label: "Cloud & DevOps" },
  { to: "/portfolio", label: "Portfolio" },
];

const Navbar = () => {
  const { theme } = useTheme();
  const [open, setOpen] = useState(false);
  const [servicesOpen, setServicesOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const location = useLocation();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 12);
    window.addEventListener("scroll", onScroll);
    onScroll();
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    setOpen(false);
    setServicesOpen(false);
  }, [location.pathname]);

  const isDark = theme === "dark";

  const linkClass = (isActive) =>
    `relative px-3 lg:px-4 py-2 text-sm font-medium rounded-lg transition-colors whitespace-nowrap ${
      isActive
        ? "text-[#007AFF]"
        : isDark
        ? "text-slate-300 hover:text-white"
        : "text-slate-600 hover:text-slate-900"
    }`;

  return (
    <header
      data-testid="primary-nav"
      className={`fixed top-0 inset-x-0 z-50 transition-all duration-300 ${
        scrolled ? "py-3" : "py-5"
      }`}
    >
      <div className="mx-auto max-w-7xl px-5 sm:px-8">
        <div
          className={`flex items-center justify-between rounded-2xl px-4 sm:px-6 py-3 border transition-all duration-300 backdrop-blur-xl ${
            isDark
              ? "border-white/10 bg-[#050a14]/70"
              : "border-black/8 bg-white/80"
          }`}
        >
          <Link
            to="/"
            data-testid="brand-logo-link"
            className="relative z-20 flex items-center gap-2.5 group shrink-0 -my-2"
          >
            <img
              src="/logo.png"
              alt="LogicLabz"
              className="h-14 sm:h-16 w-auto object-contain relative z-20 drop-shadow-[0_8px_24px_rgba(0,122,255,0.45)] transition-transform duration-300 group-hover:scale-110 group-hover:-translate-y-0.5"
            />
          </Link>

          <nav className="hidden lg:flex items-center gap-0.5 absolute left-1/2 -translate-x-1/2">
            {navLinks.map((l) =>
              l.hasDropdown ? (
                <div
                  key={l.to}
                  className="relative"
                  onMouseEnter={() => setServicesOpen(true)}
                  onMouseLeave={() => setServicesOpen(false)}
                >
                  <NavLink
                    to={l.to}
                    data-testid="nav-link-services"
                    className={({ isActive }) =>
                      `inline-flex items-center gap-1 ${linkClass(
                        isActive || location.pathname.startsWith("/services")
                      )}`
                    }
                    onClick={() => setServicesOpen(false)}
                  >
                    {({ isActive }) => (
                      <>
                        <span className="relative">
                          {l.label}
                          {(isActive ||
                            location.pathname.startsWith("/services")) && (
                            <motion.span
                              layoutId="nav-indicator"
                              className="absolute -bottom-1.5 left-0 right-0 mx-auto h-0.5 w-6 bg-[#007AFF] rounded-full"
                            />
                          )}
                        </span>
                        <ChevronDown
                          className={`w-3.5 h-3.5 transition-transform ${
                            servicesOpen ? "rotate-180" : ""
                          }`}
                        />
                      </>
                    )}
                  </NavLink>
                  <AnimatePresence>
                    {servicesOpen && (
                      <motion.div
                        initial={{ opacity: 0, y: 6 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: 6 }}
                        className={`absolute top-full left-0 mt-1 min-w-[200px] rounded-xl border p-2 shadow-xl backdrop-blur-xl ${
                          isDark
                            ? "border-white/10 bg-[#0a1628]/95"
                            : "border-black/8 bg-white/95"
                        }`}
                      >
                        {serviceLinks.map((s) => (
                          <Link
                            key={s.to}
                            to={s.to}
                            className={`block px-3 py-2.5 text-sm rounded-lg transition-colors ${
                              isDark
                                ? "text-slate-300 hover:bg-white/5 hover:text-white"
                                : "text-slate-600 hover:bg-slate-50 hover:text-slate-900"
                            }`}
                          >
                            {s.label}
                          </Link>
                        ))}
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              ) : (
                <NavLink
                  key={l.to}
                  to={l.to}
                  end={l.end}
                  data-testid={`nav-link-${l.label.toLowerCase().replace(/\s+/g, "-")}`}
                  className={({ isActive }) => linkClass(isActive)}
                >
                  {({ isActive }) => (
                    <span className="relative">
                      {l.label}
                      {isActive && (
                        <motion.span
                          layoutId="nav-indicator"
                          className="absolute -bottom-1.5 left-0 right-0 mx-auto h-0.5 w-6 bg-[#007AFF] rounded-full"
                        />
                      )}
                    </span>
                  )}
                </NavLink>
              )
            )}
          </nav>

          <div className="flex items-center gap-2">
            <Link
              to="/contact"
              data-testid="nav-cta-consultation"
              className="hidden sm:inline-flex items-center px-5 py-2.5 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white text-sm font-semibold transition-colors"
            >
              Get in Touch
            </Link>

            <button
              onClick={() => setOpen((o) => !o)}
              data-testid="mobile-menu-toggle"
              className={`lg:hidden w-10 h-10 grid place-items-center rounded-lg border ${
                isDark ? "border-white/10" : "border-black/10"
              }`}
              aria-label="Menu"
            >
              {open ? <X className="w-4 h-4" /> : <Menu className="w-4 h-4" />}
            </button>
          </div>
        </div>

        <AnimatePresence>
          {open && (
            <motion.div
              initial={{ opacity: 0, y: -8 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -8 }}
              data-testid="mobile-menu"
              className={`lg:hidden mt-2 rounded-2xl p-3 border backdrop-blur-xl ${
                isDark
                  ? "border-white/10 bg-[#050a14]/90"
                  : "border-black/8 bg-white/90"
              }`}
            >
              {navLinks.map((l) => (
                <NavLink
                  key={l.to}
                  to={l.to}
                  end={l.end}
                  data-testid={`mobile-nav-link-${l.label.toLowerCase().replace(/\s+/g, "-")}`}
                  className={({ isActive }) =>
                    `block px-4 py-3 text-sm rounded-lg ${
                      isActive
                        ? "text-[#007AFF] bg-[#007AFF]/10"
                        : isDark
                        ? "text-slate-300"
                        : "text-slate-700"
                    }`
                  }
                >
                  {l.label}
                </NavLink>
              ))}
              <Link
                to="/contact"
                className="mt-2 block text-center px-4 py-3 rounded-xl bg-[#007AFF] text-white text-sm font-semibold"
              >
                Get in Touch
              </Link>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </header>
  );
};

export default Navbar;
