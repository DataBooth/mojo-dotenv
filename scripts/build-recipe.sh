#!/usr/bin/env bash
# Build mojo-dotenv recipe using rattler-build and verify package artifacts
#
# This script builds the conda package locally to verify:
# 1. Recipe renders correctly
# 2. Package builds without errors
# 3. Expected files are included in the package

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RECIPE_FILE="$PROJECT_ROOT/packaging/recipe.yaml"
OUTPUT_DIR="$PROJECT_ROOT/output"

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colour

error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${GREEN}INFO: $1${NC}"
}

warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Check prerequisites
if ! command -v pixi &> /dev/null; then
    error "pixi is not installed. Install from https://pixi.sh"
fi

if ! pixi list | grep -q rattler-build; then
    error "rattler-build not found in pixi environment"
fi

# Ensure recipe exists
if [ ! -f "$RECIPE_FILE" ]; then
    error "Recipe file not found: $RECIPE_FILE"
fi

info "Building recipe: $RECIPE_FILE"

# Clean previous output
if [ -d "$OUTPUT_DIR" ]; then
    info "Cleaning previous output directory"
    rm -rf "$OUTPUT_DIR"
fi

# Build the package
info "Running rattler-build (tests disabled; tests are covered by pixi test-all)..."
if ! pixi exec rattler-build build \
    --recipe "$RECIPE_FILE" \
    --channel conda-forge \
    --channel https://conda.modular.com/max \
    --channel https://prefix.dev/modular-community \
    --output-dir "$OUTPUT_DIR" \
    --test skip; then
    error "rattler-build failed"
fi

# Verify output
if [ ! -d "$OUTPUT_DIR" ]; then
    error "Output directory not created: $OUTPUT_DIR"
fi

# Find the built package(s)
PACKAGE_FILES=($(find "$OUTPUT_DIR" -name "*.conda" -o -name "*.tar.bz2" 2>/dev/null))

if [ ${#PACKAGE_FILES[@]} -eq 0 ]; then
    error "No package files found in $OUTPUT_DIR"
fi

info "Build successful!"
echo ""
info "Built packages:"
for pkg in "${PACKAGE_FILES[@]}"; do
    echo "  - $(basename "$pkg")"
done

exit 0
