import * as LucideIcons from "lucide-react";

const DynamicIcon = ({ name, ...props }) => {
  const IconComponent = LucideIcons[name] || LucideIcons.HelpCircle;
  return <IconComponent {...props} />;
};

export default DynamicIcon;
