/** @type {import('stylelint').Config} */
export default {
  // Extends the standard core rule set that we installed via npm
  extends: ["stylelint-config-standard"],
  
  // Custom styling rule adjustments go here
  rules: {
    "comment-empty-line-before": "always",
    "block-no-empty": true
  }
};
