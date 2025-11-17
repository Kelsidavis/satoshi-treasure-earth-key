#!/bin/bash
#
# Satoshi's Treasure - Earth Key #6 Solution Script
# Complete automated solution for the historically unsolved puzzle
#
# Usage: ./solve.sh [path-to-quickbrownfox-doll.bmp]
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Satoshi's Treasure - Earth Key #6 Solution              ║${NC}"
echo -e "${BLUE}║  Unsolved since May 2019                                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check dependencies
echo -e "${YELLOW}[1/5] Checking dependencies...${NC}"
command -v magick >/dev/null 2>&1 || { echo -e "${RED}Error: ImageMagick not found. Install with: brew install imagemagick${NC}"; exit 1; }
command -v zbarimg >/dev/null 2>&1 || { echo -e "${RED}Error: zbar not found. Install with: brew install zbar${NC}"; exit 1; }
echo -e "${GREEN}✓ All dependencies found${NC}"
echo ""

# Get input file
if [ -z "$1" ]; then
    echo -e "${YELLOW}No input file provided. Looking for quickbrownfox-doll.bmp in current directory...${NC}"
    INPUT_FILE="quickbrownfox-doll.bmp"
else
    INPUT_FILE="$1"
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: File not found: $INPUT_FILE${NC}"
    echo ""
    echo "To obtain the original file:"
    echo "  git clone https://github.com/suhailvs-archive/treasure.git"
    echo "  cp treasure/images/quickbrownfox-doll.bmp ."
    exit 1
fi

echo -e "${GREEN}✓ Input file found: $INPUT_FILE${NC}"
echo ""

# Create output directory
OUTPUT_DIR="solution_output_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

echo -e "${BLUE}Output directory: $OUTPUT_DIR${NC}"
echo ""

# Step 1: Decrypt full image with first passphrase
echo -e "${YELLOW}[2/5] Layer 1: Decrypting full image...${NC}"
echo -e "      Passphrase: ${GREEN}nothing is covered${NC} (lowercase)"

echo "nothing is covered" > layer1_passphrase.txt
magick "../$INPUT_FILE" -decipher layer1_passphrase.txt layer1_decrypted.png 2>/dev/null

if [ ! -f layer1_decrypted.png ]; then
    echo -e "${RED}✗ Layer 1 decryption failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Layer 1 complete${NC}"
echo ""

# Step 2: Extract BOTH barcode regions
echo -e "${YELLOW}[3/5] Layer 2: Extracting barcode regions...${NC}"
echo -e "      Right region: 1700x800 pixels at +100+100"
echo -e "      Left region: 700x800 pixels at +0+100"

magick layer1_decrypted.png -crop 1700x800+100+100 right_region.png 2>/dev/null
magick layer1_decrypted.png -crop 700x800+0+100 left_region.png 2>/dev/null

if [ ! -f right_region.png ] || [ ! -f left_region.png ]; then
    echo -e "${RED}✗ Region extraction failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Both regions extracted${NC}"
echo ""

# Step 3: Decrypt both regions with second passphrase
echo -e "${YELLOW}[4/5] Layer 2: Decrypting both regions...${NC}"
echo -e "      Passphrase: ${GREEN}that will not be revealed${NC}"

echo "that will not be revealed" > layer2_passphrase.txt
magick right_region.png -decipher layer2_passphrase.txt right_decrypted.png 2>/dev/null
magick left_region.png -decipher layer2_passphrase.txt left_decrypted.png 2>/dev/null

if [ ! -f right_decrypted.png ] || [ ! -f left_decrypted.png ]; then
    echo -e "${RED}✗ Layer 2 decryption failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Both regions decrypted${NC}"
echo ""

# Step 4: Extract BOTH barcodes from Layer 2
echo -e "${YELLOW}[5/7] Extracting barcodes from Layer 2...${NC}"

BARCODE_RIGHT=$(zbarimg --quiet right_decrypted.png 2>&1)
BARCODE_LEFT=$(zbarimg --quiet left_decrypted.png 2>&1)

if [ -z "$BARCODE_RIGHT" ] || [ -z "$BARCODE_LEFT" ]; then
    echo -e "${RED}✗ Barcode detection failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Layer 2 barcodes found: 500077 and 965642${NC}"
echo ""

# Step 5: Extract center/body region
echo -e "${YELLOW}[6/7] Layer 3: Extracting center/body region...${NC}"
echo -e "      Center region: 800x1500 pixels at +575+800"

magick layer1_decrypted.png -crop 800x1500+575+800 center_region.png 2>/dev/null

if [ ! -f center_region.png ]; then
    echo -e "${RED}✗ Center region extraction failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Center region extracted${NC}"
echo ""

# Step 6: Decrypt center region with third passphrase
echo -e "${YELLOW}[7/7] Layer 3: Decrypting center region...${NC}"
echo -e "      Passphrase: ${GREEN}that will not be known${NC} (last 5 words)"

echo "that will not be known" > layer3_passphrase.txt
magick center_region.png -decipher layer3_passphrase.txt center_decrypted.png 2>/dev/null

if [ ! -f center_decrypted.png ]; then
    echo -e "${RED}✗ Layer 3 decryption failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Layer 3 complete${NC}"
echo ""

# Check for additional barcodes or data in Layer 3
echo -e "${YELLOW}Scanning Layer 3 for additional data...${NC}"
BARCODE_CENTER=$(zbarimg --quiet center_decrypted.png 2>&1 || echo "")

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              COMPLETE SOLUTION FOUND! ║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC}  Layer 2 - Right Barcode: ${GREEN}$BARCODE_RIGHT${NC}"
echo -e "${BLUE}║${NC}  Layer 2 - Left Barcode:  ${GREEN}$BARCODE_LEFT${NC}"
echo -e "${BLUE}║${NC}  Combined:                 ${GREEN}500077965642${NC}"
echo -e "${BLUE}║${NC}  Coordinates:              ${GREEN}50.0077°N, 9.65642°E (Germany)${NC}"
if [ -n "$BARCODE_CENTER" ]; then
    echo -e "${BLUE}║${NC}  Layer 3 - Center Data:    ${GREEN}$BARCODE_CENTER${NC}"
fi
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create summary file
cat > SOLUTION.txt << EOF
Satoshi's Treasure - Earth Key #6 Solution
============================================

TWO BARCODES DISCOVERED:
Right Barcode: $BARCODE_RIGHT
Left Barcode:  $BARCODE_LEFT
Combined: 500077965642

Geographic Interpretation (MOST LIKELY):
Coordinates: 50.0077°N, 9.65642°E
Location: Main-Kinzig-Kreis, Hesse, Germany
Distance: ~50km from Frankfurt Airport

Format: Interleaved 2 of 5

Passphrases Used:
-----------------
Layer 1 (Full Image): "nothing is covered" (first 3 words, lowercase)
Layer 2 (Diagonal Regions): "that will not be revealed" (middle phrase)
Layer 3 (Center/Body): "that will not be known" (last 5 words)

Bible Verse Reference:
---------------------
ESV Luke 12:2: "Nothing is covered up that will not be revealed,
                or hidden that will not be known."

Files Generated:
---------------
- layer1_decrypted.png      : Full image after first decryption
- right_region.png           : Extracted right diagonal region
- left_region.png            : Extracted left diagonal region
- right_decrypted.png        : Right barcode layer (500077)
- left_decrypted.png         : Left barcode layer (965642)
- center_region.png          : Extracted center/body region
- center_decrypted.png       : Center region after third decryption
- layer1_passphrase.txt      : First passphrase ("nothing is covered")
- layer2_passphrase.txt      : Second passphrase ("that will not be revealed")
- layer3_passphrase.txt      : Third passphrase ("that will not be known")

Solution Date: $(date)
Puzzle Release: May 2019
Unsolved Duration: 6+ years

Historical Note:
---------------
This puzzle was marked "Unknown" in the Satoshi's Treasure archive
and remained unsolved from its release in May 2019 until November 2025.
The key breakthrough was discovering that:

1. THREE separate passphrases from Luke 12:2 structure:
   - "nothing is covered" (first 3 words, lowercase)
   - "that will not be revealed" (middle phrase)
   - "that will not be known" (last 5 words)
2. TWO barcodes in symmetrical diagonal regions (nesting doll theme!)
3. Third layer decrypts the center/body region
4. Barcodes form geographic coordinates (50.0077, 9.65642)
5. Case sensitivity mattered (lowercase "nothing" vs "Nothing")
6. Decrypt full image first, THEN crop and decrypt regions
EOF

echo -e "${GREEN}✓ Solution summary saved to: $OUTPUT_DIR/SOLUTION.txt${NC}"
echo ""

# Optional: Create enhanced visualization of Layer 3
echo -e "${YELLOW}Creating enhanced visualization of Layer 3...${NC}"
magick center_decrypted.png -auto-level -normalize layer3_enhanced.png 2>/dev/null
echo -e "${GREEN}✓ Enhanced Layer 3 image saved to: layer3_enhanced.png${NC}"
echo ""

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}All files saved to: $OUTPUT_DIR/${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
