import { Link } from "react-router-dom";
import { Github, Linkedin, Twitter, ArrowUpRight } from "lucide-react";
import { useTheme } from "@/context/ThemeContext";

const Footer = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";

  return (
    <footer
      data-testid="site-footer"
      className={`relative mt-8 ${isDark ? "bg-[#050a14]" : "bg-[#f4f6f9]"}`}
    >
      <div
        className={`max-w-7xl mx-auto px-6 sm:px-10 pt-16 pb-8 ${
          isDark
            ? "border-t border-white/10"
            : "border-t border-black/5 rounded-t-[2rem]"
        }`}
      >
        <div className="grid md:grid-cols-12 gap-10">
          <div className="md:col-span-5">
            <Link to="/" className="relative z-10 inline-flex items-center gap-2.5 group">
              <img
                src="/logo.png"
                alt="LogicLabz"
                className="h-14 sm:h-16 w-auto object-contain relative z-10 drop-shadow-[0_8px_24px_rgba(0,122,255,0.35)] transition-transform duration-300 group-hover:scale-105"
              />
            </Link>
            <p
              className={`mt-5 text-sm max-w-sm leading-relaxed ${
                isDark ? "text-slate-400" : "text-slate-600"
              }`}
            >
              Software development company and ERP providers in Kottayam,
              Kerala — custom software development, accounting software, and
              enterprise platforms across India.
            </p>
            <div className="flex items-center gap-2.5 mt-6">
              {[Github, Linkedin, Twitter].map((Ico, i) => (
                <a
                  key={i}
                  href="#"
                  data-testid={`social-link-${i}`}
                  className="w-9 h-9 grid place-items-center rounded-full bg-[#007AFF]/15 text-[#007AFF] hover:bg-[#007AFF] hover:text-white transition-colors"
                >
                  <Ico className="w-4 h-4" />
                </a>
              ))}
            </div>
          </div>

          <div className="md:col-span-2">
            <h4 className="text-xs uppercase tracking-widest text-[#007AFF] mb-4 font-semibold">
              Quick Links
            </h4>
            <ul
              className={`space-y-2.5 text-sm ${
                isDark ? "text-slate-300" : "text-slate-700"
              }`}
            >
              <li>
                <Link to="/" className="hover:text-[#007AFF]">
                  Home
                </Link>
              </li>
              <li>
                <Link to="/about" className="hover:text-[#007AFF]">
                  About
                </Link>
              </li>
              <li>
                <Link to="/services" className="hover:text-[#007AFF]">
                  Services
                </Link>
              </li>
              <li>
                <Link to="/products" className="hover:text-[#007AFF]">
                  Products
                </Link>
              </li>
              <li>
                <Link to="/certifications" className="hover:text-[#007AFF]">
                  Courses
                </Link>
              </li>
              <li>
                <Link to="/portfolio" className="hover:text-[#007AFF]">
                  Portfolio
                </Link>
              </li>
              <li>
                <Link to="/top-level-team" className="hover:text-[#007AFF]">
                  Top Level Team
                </Link>
              </li>
              <li>
                <Link to="/contact" className="hover:text-[#007AFF]">
                  Contact
                </Link>
              </li>
            </ul>
          </div>

          <div className="md:col-span-2">
            <h4 className="text-xs uppercase tracking-widest text-[#007AFF] mb-4 font-semibold">
              Stack
            </h4>
            <ul
              className={`space-y-2.5 text-sm ${
                isDark ? "text-slate-400" : "text-slate-600"
              }`}
            >
              <li>Laravel / PHP</li>
              <li>Next.js / React</li>
              <li>Flutter</li>
              <li>Docker / CI-CD</li>
            </ul>
          </div>

          <div className="md:col-span-3">
            <h4 className="text-xs uppercase tracking-widest text-[#007AFF] mb-4 font-semibold">
              Talk to us
            </h4>
            <a
              href="mailto:hello@logiclabz.co.in"
              className="text-sm hover:text-[#007AFF] block"
            >
              hello@logiclabz.co.in
            </a>
            <p
              className={`text-sm mt-1 ${
                isDark ? "text-slate-400" : "text-slate-600"
              }`}
            >
              Kottayam, Kerala, India
            </p>
            <a
              href="https://logiclabz.co.in"
              className={`text-sm mt-1 block hover:text-[#007AFF] ${
                isDark ? "text-slate-400" : "text-slate-600"
              }`}
            >
              logiclabz.co.in
            </a>
            <Link
              to="/contact"
              data-testid="footer-cta-consultation"
              className="mt-5 inline-flex items-center gap-2 text-sm font-semibold text-[#007AFF] hover:gap-3 transition-all"
            >
              Start a project <ArrowUpRight className="w-4 h-4" />
            </Link>
          </div>
        </div>

        <div
          className={`mt-14 pt-6 border-t flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs ${
            isDark
              ? "border-white/5 text-slate-500"
              : "border-black/5 text-slate-500"
          }`}
        >
          <p>© {new Date().getFullYear()} LogicLabz. Engineered with precision.</p>
          <div className="flex items-center gap-2">
            <Link to="/terms" className="hover:text-[#007AFF] transition-colors">
              Terms & Conditions
            </Link>
            <span className="opacity-40">·</span>
            <Link
              to="/privacy"
              className="hover:text-[#007AFF] transition-colors"
            >
              Privacy Policy
            </Link>
          </div>
          <p>Built on a headless architecture · 95+ PageSpeed</p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
