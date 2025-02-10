import { motion } from "framer-motion";

const FlickeringLantern = () => {
  return (
    <motion.span
      className="inline-block text-yellow-400"
      animate={{
        opacity: [1, 0.8, 1, 0.6, 1, 0.9, 1],
      }}
      transition={{
        duration: 1.5,
        repeat: Infinity,
        ease: "easeInOut",
      }}
    >
      🏮
    </motion.span>
  );
};

export default FlickeringLantern;
