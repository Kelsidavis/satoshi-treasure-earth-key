# Satoshi's Treasure - Earth Key #6 Solution

This is the solution to Earth Key #6 from Satoshi's Treasure, which had been unsolved since May 2019. After 6+ years, I finally cracked it and wanted to share the methodology.

## Quick Summary

**The Puzzle:** A Russian nesting doll image with multi-layer encryption and hidden barcodes
**Release Date:** May 12, 2019
**Solved:** November 16, 2025
**Duration:** 6 years, 6 months unsolved

**The Solution:**
- Two barcodes hidden in diagonal regions: `500077` and `965642`
- Combined value: `500077965642`
- Most likely interpretation: Geographic coordinates `50.0077°N, 9.65642°E`
- Location: Main-Kinzig-Kreis, Hesse, Germany (about 50km from Frankfurt)

---

## Background

Satoshi's Treasure was a global cryptographic treasure hunt that ran from April 2019 to September 2020 with a $1 million Bitcoin prize. The game used Shamir's Secret Sharing - you needed to collect 400 of 1,000 key fragments to unlock the prize.

Earth Key #6 was released on May 12, 2019 with the title "Breakbeats on the Beach". It was marked as "Unknown" in the archive and never solved. The game ended in 2020 after designer Adam Dupre passed away, but this puzzle remained a mystery.

Looking through the archived repository, you can see ST-0006 is completely missing from the keys.py file - just a blank line where it should be.

---

## The Clue

The puzzle provided a bitmap image (`quickbrownfox-doll.bmp`) and this clue:

> ESV Luke 12:2, first three words, and then last 5 words

The Bible verse reads:
> "Nothing is covered up that will not be revealed, or hidden that will not be known."

Most people tried combining this into one passphrase. That doesn't work. The trick is understanding the grammatical structure.

---

## How I Solved It

### Three-Layer Encryption

The clue hints at splitting the verse, not combining it. There are actually three passphrases:

**Layer 1 - Full Image:**
Passphrase: `nothing is covered` (lowercase, important!)
This decrypts the entire 1950x2956 pixel image.

**Layer 2 - Diagonal Regions:**
Passphrase: `that will not be revealed`
Applied to TWO regions after decrypting layer 1:
- Right diagonal: 1700x800 pixels at position +100+100 → contains barcode `500077`
- Left diagonal: 700x800 pixels at position +0+100 → contains barcode `965642`

**Layer 3 - Center Body:**
Passphrase: `or hidden that will not be known`
This is a decoy. The obvious encrypted center doesn't have the answer.

### The Process

```bash
# Step 1: Decrypt full image
echo "nothing is covered" > pass1.txt
magick quickbrownfox-doll.bmp -decipher pass1.txt layer1.png

# Step 2: Crop and decrypt right diagonal
echo "that will not be revealed" > pass2.txt
magick layer1.png -crop 1700x800+100+100 right.png
magick right.png -decipher pass2.txt right_decrypted.png
zbarimg right_decrypted.png
# Output: I2/5:500077

# Step 3: Crop and decrypt left diagonal
magick layer1.png -crop 700x800+0+100 left.png
magick left.png -decipher pass2.txt left_decrypted.png
zbarimg left_decrypted.png
# Output: I2/5:965642
```

### The Barcodes

Both barcodes are in Interleaved 2 of 5 format:
- Right: `500077`
- Left: `965642`

The "nesting doll" theme makes perfect sense now - multiple hidden values, just like nested dolls!

---

## Geographic Coordinates Theory

The name "Earth Key" plus two 6-digit numbers screams geographic coordinates:

`50.0077°N, 9.65642°E`

This points to Main-Kinzig-Kreis in Hesse, Germany. It's about 50km from Frankfurt, near a place called Strandbad Kinzigsee (a beach area on the Kinzig river).

Given that Satoshi's Treasure had physical components (field agents, geocaches), this was likely the intended destination. Players would go there, find a geocache or meet an agent, and retrieve the actual ST-0006 key fragment.

The puzzle was released on May 12, 2019 with the title "Breakbeats on the Beach" - possibly referencing a music event or the beach location itself.

---

## Why Nobody Solved This

**Common mistakes:**
1. Combining the clue into one passphrase instead of splitting it
2. Using uppercase "Nothing" instead of lowercase "nothing"
3. Only checking the obvious center region (which is a decoy)
4. Trying two-layer encryption but missing the shoulder regions
5. Not realizing there were TWO barcodes (left and right)

**The critical insights:**
- The verse structure matters (three clauses = three passphrases)
- Case sensitivity is crucial (lowercase works, uppercase doesn't)
- The diagonal shoulder regions looked like noise but were actually encrypted layers
- Decrypt the full image FIRST, then crop and decrypt regions (not the other way around)
- Check both sides for symmetry (nesting doll theme)

---

## Verification

I ran exhaustive tests to make sure I didn't miss anything:

- Tested all four corners of the image
- Tried all passphrase combinations on various regions
- Grid searched the entire image in 500px blocks
- Tested for QR codes and other barcode formats
- Statistical variance analysis to find encrypted areas

**Result:** Exactly 2 barcodes exist, no more.

---

## How to Reproduce

### Requirements

```bash
# macOS
brew install imagemagick zbar

# Linux
apt-get install imagemagick zbar-tools
```

### Get the Original File

```bash
git clone https://github.com/suhailvs-archive/treasure.git
cd treasure/images
```

### Run the Solution

Either use the automated script:

```bash
./scripts/solve.sh quickbrownfox-doll.bmp
```

Or run verification:

```bash
cd verification
./verify_solution.sh
```

Both will extract the two barcodes and show you the coordinates.

---

## Repository Structure

```
earth-key-solution/
├── README.md                    (this file)
├── scripts/
│   └── solve.sh                 (automated solution)
├── verification/
│   └── verify_solution.sh       (verify from scratch)
└── images/
    └── quickbrownfox-doll.bmp   (original puzzle)
```

---

## Technical Details

**Encryption:** ImageMagick's `-encipher` uses AES-256 in CBC mode with SHA-256 key derivation from the passphrase.

**Barcode Format:** Interleaved 2 of 5 (I2/5) - a numeric-only barcode format.

**Original File:**
- Format: Windows 3.x BMP
- Size: 16MB
- Dimensions: 1950x2956 pixels
- Color: 24-bit RGB

---

## Historical Note

This puzzle is from a concluded treasure hunt. There's no active prize or submission mechanism anymore. I'm sharing this for educational and historical purposes.

The Satoshi's Treasure community tried hard to solve this. Looking through old Reddit threads and GitHub issues, people attempted:
- Dictionary attacks (100,000+ words)
- LSB steganography
- JPEG compression recovery
- Multi-layer nested decryption
- Various passphrase combinations

But nobody put it all together until now.

---

## Contact

Found an issue or have questions? Open an issue on this repo.

---

**Status:** SOLVED
**Puzzle Released:** May 2019
**Solution Found:** November 2025
**Unsolved Duration:** 6 years, 6 months
