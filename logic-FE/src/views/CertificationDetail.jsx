import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { motion } from "framer-motion";
import { ArrowLeft, CheckCircle2, Clock, Loader2 } from "lucide-react";
import { toast, Toaster } from "sonner";
import DynamicIcon from "@/components/DynamicIcon";
import { useTheme } from "@/context/ThemeContext";
import { API_BASE_URL, STATIC_COURSES } from "@/data/certificationCourses";

const emptyForm = { name: "", email: "", phone: "", message: "" };

const CertificationDetail = () => {
  const { slug } = useParams();
  const { theme } = useTheme();
  const isDark = theme === "dark";
  const [course, setCourse] = useState(null);
  const [missing, setMissing] = useState(false);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState(emptyForm);
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    setMissing(false);
    setSubmitted(false);
    setCourse(null);

    fetch(`${API_BASE_URL}/api/courses/${slug}`)
      .then(async (res) => {
        if (res.status === 404) return { missing: true };
        if (!res.ok) throw new Error("API failed");
        return { course: await res.json() };
      })
      .then((result) => {
        if (cancelled) return;
        if (result.missing) setMissing(true);
        else setCourse(result.course);
      })
      .catch(() => {
        if (cancelled) return;
        const fallback = STATIC_COURSES.find((item) => item.slug === slug);
        if (fallback) setCourse(fallback);
        else setMissing(true);
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, [slug]);

  useEffect(() => {
    if (course?.title) {
      document.title = `${course.title} | LogicLabz Certification`;
    }
  }, [course]);

  const inputCls = `w-full rounded-xl border px-4 py-3 text-base outline-none transition-colors ${
    isDark
      ? "border-white/10 bg-white/5 focus:border-[#007AFF] placeholder:text-slate-500 text-slate-100"
      : "border-black/10 bg-white focus:border-[#007AFF] placeholder:text-slate-400 text-slate-900"
  }`;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.name || !form.email || !form.message) {
      toast.error("Please fill in name, email and message.");
      return;
    }

    setSubmitting(true);
    try {
      const response = await fetch(`${API_BASE_URL}/api/courses/${slug}/enquiries`, {
        method: "POST",
        headers: { "Content-Type": "application/json", Accept: "application/json" },
        body: JSON.stringify(form),
      });

      if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body.message || "Could not send your enquiry.");
      }

      setSubmitted(true);
      toast.success("Enquiry received. We'll be in touch shortly.");
    } catch (error) {
      toast.error(error.message || "Could not send your enquiry.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="pt-40 pb-24 grid place-items-center">
        <Loader2 className="w-6 h-6 animate-spin text-[#007AFF]" />
      </div>
    );
  }

  if (missing || !course) {
    return (
      <div className="pt-40 pb-24 max-w-3xl mx-auto px-6 text-center">
        <h1 className="text-3xl font-bold tracking-tight">Course not found</h1>
        <p className={`mt-3 ${isDark ? "text-slate-400" : "text-slate-600"}`}>
          That certification is no longer listed.
        </p>
        <Link to="/certifications" className="mt-6 inline-flex items-center gap-2 text-[#007AFF] font-semibold">
          <ArrowLeft className="w-4 h-4" /> All courses
        </Link>
      </div>
    );
  }

  return (
    <div data-testid="course-detail-page" className="pt-28 pb-24">
      <Toaster position="top-right" theme={isDark ? "dark" : "light"} />
      <div className="max-w-7xl mx-auto px-6 sm:px-10">
        <Link to="/certifications" className="inline-flex items-center gap-2 text-sm font-semibold text-[#007AFF]">
          <ArrowLeft className="w-4 h-4" /> All courses
        </Link>

        <div className="mt-8 grid lg:grid-cols-12 gap-8">
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="lg:col-span-7"
          >
            <div className="flex items-center gap-2 flex-wrap">
              <span className="text-[11px] px-2.5 py-1 rounded-full border uppercase tracking-wide font-semibold text-[#007AFF] border-[#007AFF]/30 bg-[#007AFF]/10">
                {course.category}
              </span>
              <span className={`inline-flex items-center gap-1 text-[11px] px-2.5 py-1 rounded-full ${isDark ? "bg-white/5 text-slate-300" : "bg-slate-100 text-slate-700"}`}>
                <Clock className="w-3 h-3" /> {course.duration}
              </span>
            </div>
            <div className="mt-5 flex items-start gap-4">
              <div className="w-12 h-12 rounded-2xl bg-[#007AFF]/15 grid place-items-center shrink-0">
                <DynamicIcon name={course.icon || "GraduationCap"} className="w-6 h-6 text-[#007AFF]" />
              </div>
              <h1 className="text-4xl sm:text-5xl font-bold tracking-tighter leading-[1.08]">{course.title}</h1>
            </div>
            <p className={`mt-6 text-lg leading-relaxed ${isDark ? "text-slate-300" : "text-slate-600"}`}>
              {course.description}
            </p>
            {course.image ? (
              <img src={course.image} alt={course.title} className="mt-8 w-full rounded-3xl object-cover aspect-[16/9]" />
            ) : null}
            <h2 className="mt-10 text-2xl font-bold tracking-tight">What you will learn</h2>
            <ul className="mt-4 space-y-3">
              {(course.highlights || []).map((item) => (
                <li key={item} className="flex items-start gap-3">
                  <CheckCircle2 className="w-5 h-5 text-[#007AFF] shrink-0 mt-0.5" />
                  <span className={isDark ? "text-slate-300" : "text-slate-700"}>{item}</span>
                </li>
              ))}
            </ul>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            className="lg:col-span-5"
          >
            <div className={`rounded-3xl border p-7 sm:p-8 ${isDark ? "border-white/10 bg-[#0a1628]/70" : "border-black/8 bg-white shadow-sm"}`}>
              {submitted ? (
                <div className="text-center py-10" data-testid="course-enquiry-success">
                  <div className="w-14 h-14 mx-auto rounded-full bg-[#007AFF]/15 grid place-items-center">
                    <CheckCircle2 className="w-7 h-7 text-[#007AFF]" />
                  </div>
                  <h3 className="mt-5 text-2xl font-bold tracking-tight">Enquiry received.</h3>
                  <p className={`mt-3 ${isDark ? "text-slate-300" : "text-slate-600"}`}>
                    Thanks {form.name}. We will reply at <span className="text-[#007AFF]">{form.email}</span>.
                  </p>
                </div>
              ) : (
                <form onSubmit={handleSubmit} data-testid="course-enquiry-form" className="space-y-4">
                  <div>
                    <h2 className="text-2xl font-bold tracking-tight">Enquire about this course</h2>
                    <p className={`mt-2 text-sm ${isDark ? "text-slate-400" : "text-slate-600"}`}>
                      Share your details and we will confirm the next batch.
                    </p>
                  </div>
                  <div>
                    <label className="text-xs uppercase tracking-widest font-semibold text-slate-400">Full name</label>
                    <input
                      required
                      value={form.name}
                      onChange={(e) => setForm({ ...form, name: e.target.value })}
                      className={`${inputCls} mt-2`}
                      data-testid="course-enquiry-name"
                    />
                  </div>
                  <div>
                    <label className="text-xs uppercase tracking-widest font-semibold text-slate-400">Email</label>
                    <input
                      required
                      type="email"
                      value={form.email}
                      onChange={(e) => setForm({ ...form, email: e.target.value })}
                      className={`${inputCls} mt-2`}
                      data-testid="course-enquiry-email"
                    />
                  </div>
                  <div>
                    <label className="text-xs uppercase tracking-widest font-semibold text-slate-400">Phone</label>
                    <input
                      value={form.phone}
                      onChange={(e) => setForm({ ...form, phone: e.target.value })}
                      className={`${inputCls} mt-2`}
                      data-testid="course-enquiry-phone"
                    />
                  </div>
                  <div>
                    <label className="text-xs uppercase tracking-widest font-semibold text-slate-400">Message</label>
                    <textarea
                      required
                      rows={4}
                      value={form.message}
                      onChange={(e) => setForm({ ...form, message: e.target.value })}
                      className={`${inputCls} mt-2 resize-none`}
                      data-testid="course-enquiry-message"
                    />
                  </div>
                  <button
                    type="submit"
                    disabled={submitting}
                    data-testid="course-enquiry-submit"
                    className="inline-flex w-full items-center justify-center gap-2 px-7 py-4 rounded-full bg-[#007AFF] hover:bg-[#0066D9] text-white font-semibold disabled:opacity-60"
                  >
                    {submitting ? <Loader2 className="w-4 h-4 animate-spin" /> : null}
                    {submitting ? "Sending..." : "Send enquiry"}
                  </button>
                </form>
              )}
            </div>
          </motion.div>
        </div>
      </div>
    </div>
  );
};

export default CertificationDetail;
