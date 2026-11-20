import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { ArrowRight, Clock, Star } from "lucide-react";
import { Link } from "react-router-dom";
import DynamicIcon from "@/components/DynamicIcon";
import { useTheme } from "@/context/ThemeContext";
import { API_BASE_URL, STATIC_COURSES } from "@/data/certificationCourses";

const fadeUp = {
  initial: { opacity: 0, y: 20 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-60px" },
  transition: { duration: 0.55 },
};

const Certifications = () => {
  const { theme } = useTheme();
  const isDark = theme === "dark";
  const [courses, setCourses] = useState(STATIC_COURSES);

  useEffect(() => {
    fetch(`${API_BASE_URL}/api/courses`)
      .then((res) => {
        if (!res.ok) throw new Error("API failed");
        return res.json();
      })
      .then((data) => {
        if (Array.isArray(data) && data.length > 0) setCourses(data);
      })
      .catch(() => {});
  }, []);

  return (
    <div data-testid="certifications-page" className="pt-28 pb-24">
      <section className="relative overflow-hidden pb-12">
        <div className={`absolute inset-0 ${isDark ? "hero-mesh opacity-60" : "hero-mesh-light"}`} />
        <div className="relative max-w-7xl mx-auto px-6 sm:px-10">
          <motion.div
            initial={{ opacity: 0, y: 14 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="max-w-3xl"
          >
            <span
              className={`inline-flex px-3.5 py-1.5 rounded-full border text-[11px] font-semibold tracking-wide uppercase text-[#007AFF] ${
                isDark ? "border-[#007AFF]/40 bg-[#007AFF]/10" : "border-[#007AFF]/30 bg-[#007AFF]/5"
              }`}
            >
              Certification Courses
            </span>
            <h1 className="mt-5 text-4xl sm:text-5xl lg:text-6xl font-bold tracking-tighter leading-[1.08]">
              Learn the stack.{" "}
              <span className="text-[#007AFF]">Get certified.</span>
            </h1>
            <p className={`mt-6 text-lg leading-relaxed ${isDark ? "text-slate-300" : "text-slate-600"}`}>
              Practical certification courses in Laravel, React, Next.js, and Flutter — taught by the same team that ships production software.
            </p>
          </motion.div>
        </div>
      </section>

      <section className="max-w-7xl mx-auto px-6 sm:px-10">
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {courses.map((course, i) => (
            <motion.div key={course.slug || i} {...fadeUp} transition={{ ...fadeUp.transition, delay: (i % 3) * 0.06 }}>
              <Link
                to={`/certifications/${course.slug}`}
                data-testid={`course-card-${course.slug}`}
                className={`group relative flex h-full flex-col overflow-hidden rounded-3xl border transition-all ${
                  isDark
                    ? "border-white/10 bg-[#0a1628]/70 hover:border-[#007AFF]/50"
                    : "border-black/8 bg-white shadow-sm hover:border-[#007AFF]/40 hover:shadow-md"
                }`}
              >
                <div
                  className={`aspect-[16/9] grid place-items-center ${
                    course.image
                      ? ""
                      : isDark
                      ? "bg-gradient-to-br from-[#007AFF]/20 via-[#0a1628] to-transparent"
                      : "bg-gradient-to-br from-[#007AFF]/10 via-slate-50 to-white"
                  }`}
                >
                  {course.image ? (
                    <img src={course.image} alt={course.title} className="h-full w-full object-cover" />
                  ) : (
                    <DynamicIcon name={course.icon || "GraduationCap"} className="w-12 h-12 text-[#007AFF]" />
                  )}
                </div>
                <div className="flex flex-1 flex-col p-7">
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className="text-[11px] px-2.5 py-1 rounded-full border uppercase tracking-wide font-semibold text-[#007AFF] border-[#007AFF]/30 bg-[#007AFF]/10">
                      {course.category}
                    </span>
                    <span className={`inline-flex items-center gap-1 text-[11px] px-2.5 py-1 rounded-full ${isDark ? "bg-white/5 text-slate-300" : "bg-slate-100 text-slate-700"}`}>
                      <Clock className="w-3 h-3" /> {course.duration}
                    </span>
                    {(course.is_featured === true || course.is_featured === 1) && (
                      <span className="inline-flex items-center gap-1 text-[11px] px-2.5 py-1 rounded-full bg-amber-500/15 text-amber-500 font-semibold">
                        <Star className="w-3 h-3" /> Featured
                      </span>
                    )}
                  </div>
                  <h3 className="mt-4 text-xl font-bold tracking-tight">{course.title}</h3>
                  <p className={`mt-3 text-sm leading-relaxed flex-1 ${isDark ? "text-slate-400" : "text-slate-600"}`}>
                    {course.description}
                  </p>
                  <span className="mt-5 inline-flex items-center gap-2 text-sm font-semibold text-[#007AFF]">
                    View course <ArrowRight className="w-4 h-4 transition-transform group-hover:translate-x-1" />
                  </span>
                </div>
              </Link>
            </motion.div>
          ))}
        </div>
      </section>
    </div>
  );
};

export default Certifications;
