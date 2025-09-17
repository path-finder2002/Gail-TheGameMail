import { execSync } from "node:child_process";

try {
  execSync("node scripts/check-rls.mjs", { stdio: "inherit" });
  execSync("node scripts/migration-dry-run.mjs", { stdio: "inherit" });
  execSync("node scripts/test-accounts.mjs", { stdio: "inherit" });
  console.log("✅ Supabase guard passed");
} catch (e) {
  console.error("❌ Supabase guard failed");
  process.exit(1);
}
