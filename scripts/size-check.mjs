import { readFileSync } from "node:fs";
import { execSync } from "node:child_process";

const arg = process.argv.find((a) => a.startsWith("--budget"));
const budget = parseInt((arg?.split(" ")[1] || arg?.split("=")[1]) ?? "250", 10); // KB

execSync("npm run build", { stdio: "inherit" });

// naive: look for dist assets total size
const { default: fs } = await import("node:fs/promises");
let total = 0;
for await (const f of await fs.opendir("dist")) {
  if (f.name.endsWith(".js") || f.name.endsWith(".css")) {
    const buf = readFileSync(`dist/${f.name}`);
    total += buf.byteLength;
  }
}

const kb = Math.round(total / 1024);
if (kb > budget) {
  console.error(`❌ Bundle ${kb}KB > budget ${budget}KB`);
  process.exit(1);
} else {
  console.log(`✅ Bundle ${kb}KB within ${budget}KB`);
}
