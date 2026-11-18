#!/bin/bash
# setup-prototype-repo.sh
# Manual fallback for initializing ./prototypes/ inside a PM Product folder.
# Under normal use, create_prototype handles this automatically via INIT_PRODUCT_LINE.
#
# Usage (run from your PM Product folder):
#   bash setup-prototype-repo.sh <product-slug> [remote-url]
#
# Arguments:
#   product-slug  kebab-case product identifier, e.g. bim-viewer
#   remote-url    (optional) GitHub remote — can be added later
#
# Example:
#   cd "/Users/greg/Products/BIM Viewer"
#   bash hyprlayer-pm/setup-prototype-repo.sh bim-viewer https://github.com/koutsouros/hyprlayer-prototypes-bim-viewer

set -e

SLUG="${1:-}"
REMOTE="${2:-}"

if [ -z "$SLUG" ]; then
  echo "Usage: bash setup-prototype-repo.sh <product-slug> [remote-url]"
  exit 1
fi

TARGET="./prototypes"
REPO_NAME="hyprlayer-prototypes-${SLUG}"

# ─── Preflight ────────────────────────────────────────────────────────────────

if [ -d "$TARGET/.git" ]; then
  echo "⚠️  ./prototypes already has a git repo. Aborting."
  exit 1
fi

command -v git  >/dev/null 2>&1 || { echo "❌ git is required."; exit 1; }
command -v node >/dev/null 2>&1 || { echo "❌ Node.js >= 20 is required."; exit 1; }
command -v pnpm >/dev/null 2>&1 || { echo "❌ pnpm is required: npm install -g pnpm"; exit 1; }

echo ""
echo "🚀 Initializing ./prototypes/ for ${SLUG}"
[ -n "$REMOTE" ] && echo "   Remote: $REMOTE"
echo ""

# ─── Root files ───────────────────────────────────────────────────────────────

mkdir -p "$TARGET"

cat > "$TARGET/package.json" << EOF
{
  "name": "${REPO_NAME}",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "dev": "echo 'Run pnpm dev from a specific prototype directory'"
  }
}
EOF

cat > "$TARGET/pnpm-workspace.yaml" << 'EOF'
packages:
  - '*'
EOF

cat > "$TARGET/.gitignore" << 'EOF'
node_modules/
dist/
handoff/
.DS_Store
*.local
.env
.env.local
EOF

cat > "$TARGET/README.md" << EOF
# ${REPO_NAME}

Prototypes for the **${SLUG}** product line — Vite + React + Strong Tie Design System.

Use \`create_prototype\` and \`iterate_prototype\` from the Hyprlayer-PM layer to add and evolve prototypes.

Each prototype lives at \`{feature-slug}/\`. Run one:

\`\`\`bash
cd {feature-slug}
pnpm install
pnpm dev
\`\`\`
EOF

echo "✓ Root files written"

# ─── Git ──────────────────────────────────────────────────────────────────────

cd "$TARGET"
git init

if [ -n "$REMOTE" ]; then
  git remote add origin "$REMOTE"
fi

git add .
git commit -m "chore: initial prototype repo scaffold

Product: ${SLUG}
Stack: Vite + React + TypeScript + Strong Tie Design System"

echo ""
echo "✅ ./prototypes/ is ready."
echo ""

if [ -z "$REMOTE" ]; then
  echo "When ready, push to GitHub:"
  echo "  cd prototypes"
  echo "  git remote add origin https://github.com/{org}/hyprlayer-prototypes-${SLUG}"
  echo "  git push -u origin main"
  echo ""
fi
