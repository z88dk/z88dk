
/*
 * h17raw.c
 * Extract formats from H17Disk (.h17) images:
 *   - RAW/H8D-style user-data stream (default)
 *
 * Usage:
 *   h17raw input.h17 output.h8d (TODO: --h17raw for the H89JS emulator)
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define H17_MAGIC "H17D"
#define H17_MAGIC_LEN 4

typedef enum { MODE_H8D_RAW=0, MODE_H17RAW=2 } out_mode_t;

static int read_n(FILE *fp, void *buf, size_t n) { return (fread(buf, 1, n, fp) == n) ? 0 : -1; }
static int write_n(FILE *fp, const void *buf, size_t n) { return (fwrite(buf, 1, n, fp) == n) ? 0 : -1; }

static int read_be32(FILE *fp, uint32_t *out) {
    uint8_t b[4];
    if (read_n(fp, b, 4) != 0) return -1;
    *out = ((uint32_t)b[0] << 24) | ((uint32_t)b[1] << 16) | ((uint32_t)b[2] << 8) | (uint32_t)b[3];
    return 0;
}

/* DskF info if present: heads/sides, tracks, sectors/track, sector_size */
typedef struct {
    int have_dskf;
    uint32_t heads, tracks, sectors, sector_size;
} dskf_info_t;

static void init_dskf(dskf_info_t *info) { memset(info, 0, sizeof(*info)); }

/*
 * Minimal DskF parser – common layout (BE32 fields):  heads, tracks, sectors/track, sector_size
 */
static void parse_dskf_block(const uint8_t *data, uint32_t len, dskf_info_t *out) {
    if (len >= 16) {
        out->have_dskf = 1;
        out->heads       = ((uint32_t)data[0] << 24) | ((uint32_t)data[1] << 16) | ((uint32_t)data[2] << 8) | data[3];
        out->tracks      = ((uint32_t)data[4] << 24) | ((uint32_t)data[5] << 16) | ((uint32_t)data[6] << 8) | data[7];
        out->sectors     = ((uint32_t)data[8] << 24) | ((uint32_t)data[9] << 16) | ((uint32_t)data[10] << 8) | data[11];
        out->sector_size = ((uint32_t)data[12] << 24) | ((uint32_t)data[13] << 16) | ((uint32_t)data[14] << 8) | data[15];
    }
}

/*
 * A simple SecM holder:
 * We assume SecM contains per-sector header fields and status including checksums.
 * The exact schema varies; we keep the raw payload and let the code below index it
 * as needed for hdrdata mode when possible.
 * Ref: H17Disk drafts mention Sector Metadata (SecM). (https://github.com/sebhc/sebhc/blob/master/software.html)
 */
typedef struct {
    int have_secm;
    uint8_t *payload;
    uint32_t len;
} secm_info_t;

static void init_secm(secm_info_t *si) { memset(si, 0, sizeof(*si)); }

/* Helper: derive expected count */
static uint64_t expected_bytes(const dskf_info_t *info) {
    if (info->have_dskf && info->heads && info->tracks && info->sectors && info->sector_size)
        return (uint64_t)info->heads * (uint64_t)info->tracks * (uint64_t)info->sectors * (uint64_t)info->sector_size;
    return 0;
}

/* CLI parsing – detect --h17raw */
static out_mode_t parse_mode(int argc, char **argv) {
    for (int i = 3; i < argc; ++i) {
        if (strncmp(argv[i], "--h17raw", 8) == 0) return MODE_H17RAW;
    }
    return MODE_H8D_RAW;
}

/* Extractor */
int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr,
//            "Usage: %s input.h17 output.raw [--h17raw]\n"
//            "Default: output is H8D-style RAW user data (H8DB).\n", argv[0]);
            "Usage: %s input.h17 output.h8d\n", argv[0]);
        return 1;
    }
    const char *in_path = argv[1];
    const char *out_path = argv[2];
    out_mode_t mode = parse_mode(argc, argv);

    FILE *fin = fopen(in_path, "rb");
    if (!fin) { perror("fopen(input)"); return 1; }

    /* Header: "H17D" + 3 ASCII digits + 0xFF */
    char magic[H17_MAGIC_LEN];
    if (read_n(fin, magic, H17_MAGIC_LEN) != 0 || memcmp(magic, H17_MAGIC, H17_MAGIC_LEN) != 0) {
        fprintf(stderr, "Error: Not an H17Disk file (missing 'H17D' magic).\n");
        fclose(fin);
        return 1;
    }
    uint8_t ver[3];
    if (read_n(fin, ver, 3) != 0) { fprintf(stderr, "Error: Short read on version.\n"); fclose(fin); return 1; }
    uint8_t clean;
    if (read_n(fin, &clean, 1) != 0 || clean != 0xFF) { fprintf(stderr, "Error: Missing 0xFF marker.\n"); fclose(fin); return 1; }

    dskf_info_t info; init_dskf(&info);
    secm_info_t si; init_secm(&si);

    uint8_t *h8db = NULL; uint32_t h8db_len = 0;

    /* Block scan */
    for (;;) {
        uint8_t id[4];
        size_t r = fread(id, 1, 4, fin);
        if (r == 0) break;
        if (r < 4) { fprintf(stderr, "Error: Truncated block ID.\n"); goto fail; }

        uint32_t blen;
        if (read_be32(fin, &blen) != 0) { fprintf(stderr, "Error: Truncated block length.\n"); goto fail; }

        uint8_t *payload = (uint8_t*)malloc(blen);
        if (!payload) { fprintf(stderr, "Error: OOM %u bytes.\n", blen); goto fail; }
        if (read_n(fin, payload, blen) != 0) {
            fprintf(stderr, "Error: Truncated block payload.\n"); free(payload); goto fail;
        }

        if (memcmp(id, "DskF", 4) == 0) {
            parse_dskf_block(payload, blen, &info);
        } else if (memcmp(id, "H8DB", 4) == 0) {
            if (!h8db) { h8db = payload; h8db_len = blen; payload = NULL; }
            else { fprintf(stderr, "Warning: multiple H8DB blocks; using first.\n"); }
        } else if (memcmp(id, "SecM", 4) == 0) {
            if (!si.have_secm) { si.have_secm = 1; si.payload = payload; si.len = blen; payload = NULL; }
            else { fprintf(stderr, "Warning: multiple SecM blocks; using first.\n"); }
        }

        if (payload) free(payload);
    }

    if (!h8db || h8db_len == 0) {
        fprintf(stderr, "Error: No H8DB block found; cannot extract RAW data.\n");
        goto fail;
    }

    /* Sanity check vs. DskF (if present) */
    uint64_t exp = expected_bytes(&info);
    if (exp && exp != h8db_len) {
        fprintf(stderr, "Warning: H8DB length (%u) != expected (%llu) from DskF.\n",
                h8db_len, (unsigned long long)exp);
    }

    FILE *fout = fopen(out_path, "wb");
    if (!fout) { perror("fopen(output)"); goto fail; }

    if (mode == MODE_H8D_RAW)
        /* Emit user-data stream verbatim */
        if (write_n(fout, h8db, h8db_len) != 0) { fprintf(stderr, "Error: write output.\n"); goto fail_out; }
    else if (mode == MODE_H17RAW) {

// TODO: H17RAW format


    }

fail_out:
    fclose(fout);
fail:
    if (h8db) free(h8db);
    if (si.payload) free(si.payload);
    fclose(fin);
}
