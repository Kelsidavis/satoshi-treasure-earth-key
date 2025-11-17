#!/bin/bash
set -e

echo "============================================"
echo "Verifying Earth Key #6 Solution"
echo "============================================"
echo ""

# Clean start
rm -f verify_*.png 2>/dev/null || true

# Layer 1: Decrypt full image
echo "Step 1: Decrypting full image with 'nothing is covered'..."
echo "nothing is covered" > /tmp/verify_pass1.txt
magick quickbrownfox-doll.bmp -decipher /tmp/verify_pass1.txt verify_layer1.png

# Layer 2: Extract and decrypt BOTH regions
echo "Step 2: Extracting both diagonal regions..."
magick verify_layer1.png -crop 1700x800+100+100 verify_right.png
magick verify_layer1.png -crop 700x800+0+100 verify_left.png

echo "Step 3: Decrypting both regions with 'that will not be revealed'..."
echo "that will not be revealed" > /tmp/verify_pass2.txt
magick verify_right.png -decipher /tmp/verify_pass2.txt verify_right_final.png
magick verify_left.png -decipher /tmp/verify_pass2.txt verify_left_final.png

# Scan for both barcodes
echo "Step 4: Scanning for barcodes..."
RIGHT=$(zbarimg --quiet verify_right_final.png 2>&1)
LEFT=$(zbarimg --quiet verify_left_final.png 2>&1)

echo ""
echo "============================================"
echo "Right Barcode: $RIGHT"
echo "Left Barcode:  $LEFT"
echo "Combined: 500077965642"
echo "Coordinates: 50.0077°N, 9.65642°E"
echo "============================================"
echo ""

if [[ "$RIGHT" == *"500077"* ]] && [[ "$LEFT" == *"965642"* ]]; then
    echo "✓ SOLUTION VERIFIED!"
    echo "✓ Both barcodes successfully extracted"
    exit 0
else
    echo "✗ Verification failed"
    exit 1
fi
