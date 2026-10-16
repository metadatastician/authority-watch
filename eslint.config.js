import js from "@eslint/js";
import globals from "globals";

export default [
  // 1. Tell ESLint to use the recommended rules out-of-the-box
  js.configs.recommended,
  
  // 2. Define environment variables (like browser and node environments)
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
    // 3. You can define custom rule overrides here if needed
    rules: {
      "no-unused-vars": "warn",
      "no-console": "off"
    }
  }
];
