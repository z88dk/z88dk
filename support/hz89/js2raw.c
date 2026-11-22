/*
 * js2raw.c - Convert H89JS ".h17raw" (by-track) files to raw .h8d
 *
 * What it does:
 *   - Scans the input stream for H17 sector frames:
 *       [zeros] 0xFD  VOL TRK SEC HCK   [zeros] 0xFD  <256 DATA>  DCK  [gap]
 *   - Verifies header checksum (HCK) and data checksum (DCK).
 *   - Writes only the 256-byte payload to the output, in the order found.
 *
 * Notes:
 *   - Default sector size is 256. Tracks/sides are not required to be known.
 *   - Robust sync seeking: counts of pre-zeros/post-gap bytes may vary.
 *   - Optionally stops after a given number of sectors if requested.
 *
 * Build:
 *   cc -O2 -Wall -o js2raw js2raw.c
 *
 * Usage:
 *   ./js2raw input.h17raw output.h8d
 *
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/* --- H17 checksum: XOR then RLC (rotate left through carry) per byte.
 * Header checksum starts with seed 0xFD; data checksum starts with seed 0x00.
 * Matches the algorithm used by H17 controllers and H89JS writer.
 */
static uint8_t h17_checksum(const uint8_t *buf, size_t n, uint8_t seed) {
    uint8_t d = seed;
    for (size_t k = 0; k < n; ++k) {
        d ^= buf[k];                // XOR
        d = (uint8_t)((d << 1) | (d >> 7)); // RLC (rotate left through carry)
    }
    return d;
}

/* Read next byte; return -1 on EOF/error, else [0..255] */
static int read_byte(FILE *fp) {
    int c = fgetc(fp);
    return c;
}

/* Seek forward until we find a 0xFD "sync" byte, allowing any number of 0x00 padding.
 * Return 0 on found, -1 on EOF.
 */
static int seek_sync_fd(FILE *fp) {
    int c;
    // Allow zero padding before sync and tolerate FF/fill if present.
    while ((c = read_byte(fp)) != -1) {
        if (c == 0xFD) return 0;
        // Typical H17 frame uses 0x00 padding; gaps may have 0xFF, but we just skip all.
    }
    return -1;
}

/* Read exactly n bytes into buf; return 0 on success, -1 on EOF */
static int read_exact(FILE *fp, uint8_t *buf, size_t n) {
    size_t got = fread(buf, 1, n, fp);
    if (got != n) return -1;
    return 0;
}

/* Optional: scan past gap area (00.. then FF..). We just skip until next FD is found by seek_sync_fd().
 * This function is present for clarity but not strictly required.
 */
static void skip_gap(FILE *fp) {
    // Do nothing: seek_sync_fd() will consume any padding/gap as needed.
    (void)fp;
}

static void usage(const char *prog) {
    fprintf(stderr,
        "Usage: %s <input.h17raw> <output.h8d>\n"
        "Converts H89JS .h17raw (per-track frames) to a raw image (.h8d) containing\n"
        "only 256-byte sector payloads in the order encountered.\n",
        prog);
}

int main(int argc, char **argv) {
    const char *in_path = NULL;
    const char *out_path = NULL;
    const size_t SECTOR_SIZE = 256; // H17 data payload size

    // Parse args
    if (argc != 3) { usage(argv[0]); return 1; }
    in_path  = argv[1];
    out_path = argv[2];

    FILE *fin = fopen(in_path, "rb");
    if (!fin) {
        fprintf(stderr, "Cannot open input '%s': %s\n", in_path, strerror(errno));
        return 1;
    }
    FILE *fout = fopen(out_path, "wb");
    if (!fout) {
        fprintf(stderr, "Cannot create output '%s': %s\n", out_path, strerror(errno));
        fclose(fin);
        return 1;
    }

    long sectors_out = 0;
    uint8_t hdr[4];    // VOL, TRK, SEC, HCK
    uint8_t data[SECTOR_SIZE];
    int rc;

    // Main loop: find header sync, parse header; then find data sync, read data.
    while (1) {
        // 1) Seek header sync FD
        rc = seek_sync_fd(fin);
        if (rc < 0) break; // EOF: we're done

        // 2) Read header: VOL, TRK, SEC, HCK
        if (read_exact(fin, hdr, 4) < 0) {
            // Possibly trailing junk: stop cleanly.
            break;
        }
        uint8_t vol = hdr[0];
        uint8_t trk = hdr[1];
        uint8_t sec = hdr[2];
        uint8_t hck = hdr[3];

        // Verify header checksum
        uint8_t calc_hck = h17_checksum((const uint8_t[]){vol, trk, sec}, 3, 0xFD);
        if (calc_hck != hck) {
            fprintf(stderr,
                "Warning: header checksum mismatch at TRK=%u SEC=%u (VOL=%u). "
                "Expected 0x%02X, got 0x%02X. Continuing...\n",
                trk, sec, vol, calc_hck, hck);
            // Continue; some captures may have header anomalies.
        }

        // 3) Seek data sync FD
        rc = seek_sync_fd(fin);
        if (rc < 0) {
            fprintf(stderr, "Unexpected EOF seeking data sync after TRK=%u SEC=%u.\n", trk, sec);
            break;
        }

        // 4) Read 256 data bytes + 1 byte DCK
        if (read_exact(fin, data, SECTOR_SIZE) < 0) {
            fprintf(stderr, "Unexpected EOF reading data at TRK=%u SEC=%u.\n", trk, sec);
            break;
        }
        int dck = read_byte(fin);
        if (dck < 0) {
            fprintf(stderr, "Unexpected EOF reading data checksum at TRK=%u SEC=%u.\n", trk, sec);
            break;
        }
        uint8_t calc_dck = h17_checksum(data, SECTOR_SIZE, 0x00);
        if (calc_dck != (uint8_t)dck) {
            fprintf(stderr,
                "Warning: data checksum mismatch at TRK=%u SEC=%u. "
                "Expected 0x%02X, got 0x%02X. Continuing...\n",
                trk, sec, calc_dck, (uint8_t)dck);
            // Continue; keep payload.
        }

        // 5) Write payload to output image
        if (fwrite(data, 1, SECTOR_SIZE, fout) != SECTOR_SIZE) {
            fprintf(stderr, "Write error at TRK=%u SEC=%u: %s\n", trk, sec, strerror(errno));
            break;
        }
        ++sectors_out;

        // 6) Skip gap (00.. then FF..), which we ignore. Next loop will seek the next header FD.
        skip_gap(fin);
    }

    fprintf(stderr, "Done. Wrote %ld sectors (%ld bytes).\n", sectors_out, sectors_out * 256L);

    fclose(fout);
    fclose(fin);
    return 0;
}
