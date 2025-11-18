# Satoshi's Treasure - Earth Key #6 Solution

This is the solution to Earth Key #6 from Satoshi's Treasure, which had been unsolved since May 2019. After 6+ years, I finally cracked it and wanted to share the methodology.

## Quick Summary

- **The Puzzle:** A Russian nesting doll image with multi-layer encryption and hidden barcodes
- **Release Date:** May 12, 2019
- **Solved:** November 16, 2025
- **Duration:** 6 years, 6 months unsolved

**The Solution:**
- **Two-layer encryption** using two passphrases from the first clause of Luke 12:2
- Two barcodes hidden in diagonal regions: `500077` and `965642`
- Combined value: `500077965642`
- Most likely interpretation: Geographic coordinates `50.0077°N, 9.65642°E`
- Location: Southwest of Gemünden am Main, Main-Spessart district, Bavaria, Germany
- Physical destination unclear (likely a geocache or agent meeting point)

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

### Understanding the Clue

At first, this clue seems contradictory. The instruction says "first three words, and then last 5 words" but our working solution uses the MIDDLE clause "that will not be revealed" which isn't mentioned at all. Here's why the clue actually makes perfect sense:

**Luke 12:2 has two clauses:**
1. "Nothing is covered up that will not be revealed," (9 words)
2. "or hidden that will not be known." (7 words)

**The instruction refers to the FIRST CLAUSE only:**
- First 3 words: "nothing is covered" (words 1-3)
- Last 5 words OF THAT CLAUSE: "that will not be revealed" (words 5-9)

This interpretation is confirmed by exhaustive testing - "that will not be revealed" is the ONLY 5-word sequence from the entire verse that successfully decrypts the barcode regions. Testing all twelve possible 5-word combinations from Luke 12:2 revealed only one match.

This is likely why the puzzle remained unsolved for 6+ years. Most people interpreted "last 5 words" as referring to the entire verse ("that will not be known") rather than the first clause.

---

## How I Solved It

### Two-Layer Encryption

Based on the clue structure referring to the first clause only:
> "first three words, and then last 5 words"

There are **two passphrases** derived from the first clause of Luke 12:2:

**Layer 1 - Full Image:**
- Passphrase: `nothing is covered` (lowercase, important!)
- Source: First 3 words of the first clause
- Decrypts the entire 1950x2956 pixel image

**Layer 2 - Diagonal Regions:**
- Passphrase: `that will not be revealed`
- Source: Last 5 words of the first clause
- Applied to TWO regions after decrypting layer 1:
  - Right diagonal: 1700x800 pixels at position +100+100 → contains barcode `500077`
  - Left diagonal: 700x800 pixels at position +0+100 → contains barcode `965642`

The "nesting doll" theme is reflected in the two-layer encryption and the two separate barcodes hidden in symmetric diagonal regions.

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

## Geographic Coordinates

The name "Earth Key" plus two 6-digit numbers suggests geographic coordinates:

`50.0077°N, 9.65642°E`

These coordinates point to an area southwest of Gemünden am Main in the Main-Spessart district of Bavaria, Germany.

Given that Satoshi's Treasure had physical components (field agents, geocaches), these coordinates likely indicated where players should retrieve the actual ST-0006 key fragment. The exact intended destination is unknown.

Note: The puzzle was titled "Breakbeats on the Beach" when released in May 2019, though the title's relevance to the solution is unclear.

---

## Why Nobody Solved This

**Common mistakes:**
1. Combining the clue into one passphrase instead of splitting it
2. Using uppercase "Nothing" instead of lowercase "nothing"
3. Interpreting "last 5 words" as the entire verse instead of the first clause only
4. Not realizing Luke 12:2 has two clauses separated by a comma
5. Testing "that will not be known" (from the second clause) instead of "that will not be revealed" (from the first clause)
6. Only checking one diagonal region, not both
7. Not realizing there were TWO barcodes (left and right)

**The critical insights:**
- "First three words, and then last 5 words" refers to the FIRST CLAUSE only
- The first clause is: "Nothing is covered up that will not be revealed,"
- First 3 words: "nothing is covered" (words 1-3)
- Last 5 words of first clause: "that will not be revealed" (words 5-9)
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

- **Encryption:** ImageMagick's `-encipher` uses AES-256 in CBC mode with SHA-256 key derivation from the passphrase
- **Barcode Format:** Interleaved 2 of 5 (I2/5) - numeric-only barcode format
- **Original File:**
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
