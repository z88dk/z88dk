/*

 $Id: cpndisk.c $

 * Quick and dirty (AI generated) file export tool for the CPN disk images
 * for the Torch Z80 coprocessor OS (BBC Micro)
 
 * Stefano Bodrato, December 2025

 *  Usage:
 *       List the directory content of the Torch CPN filesystem:
 *       ./cpndisk image.dsd
 *
 *       Extract a file from the disk image:
 *       ./cpndisk image.dsd -e USER NAME.EXT OUTFILE


 *  Build:
 *       gcc -std=c99 -O2 -Wall -Wextra -o cpndisk cpndisk.c


 *  Technical notes:
 *    - Sectors A–F (10–15) do not really exist on the 400K disks: must be ignored
 *    - L3 tells the record hasn't been written, add 128 zeroed bytes.
 *    - The "used sectors" count refers to the actual data only  (the space used by L2/L3 is not considered).

 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

#define SECTOR_SIZE         256
#define LOG_DIR_START       0x0000
#define LOG_DIR_END         0x0015

static long logical_sector_to_offset(uint16_t logical_sector)
{
    int track  = logical_sector / 32;
    int rem    = logical_sector % 32;
    int side   = rem / 16;        // 0 o 1
    int sector = rem % 16;        // 0..15 (10..15 not existing on 400K)

    if (sector >= 10) {
        return -1; // physical sector missing on 400K (A-F)
    }
    long real_linear_sector = (long)(track * 2 + side) * 10L + (long)sector;
    return real_linear_sector * SECTOR_SIZE;
}

static int read_logical_sector(FILE *fp, uint16_t logical_sector, uint8_t *buf)
{
    long off = logical_sector_to_offset(logical_sector);
    if (off < 0) return -1;
    if (fseek(fp, off, SEEK_SET) != 0) return -1;
    size_t rd = fread(buf, 1, SECTOR_SIZE, fp);
    return (rd == SECTOR_SIZE) ? 0 : -1;
}

static inline uint16_t rd16le(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

static inline char clean_char(uint8_t b)
{
    char c = (char)(b & 0x7F);
    if (c < 32 || c > 126) c = ' ';
    return c;
}

/* ---------- Print directory ---------- */

static int count_file_data_sectors(FILE *fp, uint16_t block_word, uint16_t highest_record_word)
{
    uint32_t total_records = (uint32_t)highest_record_word + 1;
    if (total_records == 0) return 0;

    uint32_t total_pairs   = (total_records + 1) / 2;        // 2 records per sector
    uint32_t l3_per_file   = (total_records + 255) / 256;    // 256 records per L3

    bool used[4096];
    memset(used, 0, sizeof(used));

    uint8_t buf[SECTOR_SIZE];

    if (block_word == 0xFFFF) {
        return 0;
    }

    bool     is_L2      = (block_word & 0x8000) != 0;
    uint16_t base_sector = (uint16_t)(block_word & 0x3FFF);

    if (!is_L2) {
        if (read_logical_sector(fp, base_sector, buf) != 0) {
            return 0;
        }
        uint32_t pairs_here = (total_pairs < 128) ? total_pairs : 128;

        for (uint32_t i = 0; i < pairs_here; i++) {
            uint16_t w   = rd16le(&buf[i * 2]);
            uint16_t sec = (uint16_t)(w & 0x3FFF);
            bool r0 = (w & 0x4000) != 0;
            bool r1 = (w & 0x8000) != 0;
            if ((r0 || r1) && sec != 0) {
                int track  = sec / 32;
                int rem    = sec % 32;
                int side   = rem / 16;
                int sector = rem % 16;
                if (sector < 10) used[sec] = true;
            }
        }
    } else {
        if (read_logical_sector(fp, base_sector, buf) != 0) {
            return 0;
        }
        for (uint32_t k = 0; k < l3_per_file && k < 128; k++) {
            uint16_t l3_sec = rd16le(&buf[k * 2]);
            if (l3_sec == 0) continue;

            uint8_t l3buf[SECTOR_SIZE];
            if (read_logical_sector(fp, l3_sec, l3buf) != 0) continue;

            uint32_t pairs_remaining = (total_pairs > k * 128) ? (total_pairs - k * 128) : 0;
            uint32_t here = (pairs_remaining < 128) ? pairs_remaining : 128;

            for (uint32_t i = 0; i < here; i++) {
                uint16_t w   = rd16le(&l3buf[i * 2]);
                uint16_t sec = (uint16_t)(w & 0x3FFF);
                bool r0 = (w & 0x4000) != 0;
                bool r1 = (w & 0x8000) != 0;
                if ((r0 || r1) && sec != 0) {
                    int track  = sec / 32;
                    int rem    = sec % 32;
                    int side   = rem / 16;
                    int sector = rem % 16;
                    if (sector < 10) used[sec] = true;
                }
            }
        }
    }

    int count = 0;
    for (int i = 0; i < 4096; i++) {
        if (used[i]) count++;
    }
    return count;
}

/* ---------- File extraction ---------- */

typedef struct {
    uint16_t block_word;
    uint16_t highest_rec;
    uint8_t  user;
    char     name[9]; // 8 + '\0'
    char     ext[4];  // 3 + '\0'
} DirEntry;

// Case insensitive compare of the file name
static void normalize_name(char *s) {
    // upper e trim trailing spazi
    for (size_t i = 0; s[i]; ++i) s[i] = (char)toupper((unsigned char)s[i]);
    for (int i = (int)strlen(s) - 1; i >= 0 && s[i] == ' '; --i) s[i] = '\0';
}

// Extract file records in out_fp.
// On exit: 0 OK, -1 error
static int extract_file(FILE *fp, const DirEntry *de, FILE *out_fp)
{
    uint32_t total_records = (uint32_t)de->highest_rec + 1;
    if (total_records == 0) return 0;

    bool     is_L2       = (de->block_word & 0x8000) != 0;
    uint16_t base_sector = (uint16_t)(de->block_word & 0x3FFF);

    uint8_t l2buf[SECTOR_SIZE];
    bool    l2_loaded = false;

    uint16_t current_l3_sec = 0;
    uint8_t  l3buf[SECTOR_SIZE];
    bool     l3_loaded = false;

    uint16_t last_data_sec = 0xFFFF;
    uint8_t  databuf[SECTOR_SIZE];

    if (de->block_word == 0xFFFF || de->block_word == 0x0000) {
        return -1; // empty entry or directory end
    }

    if (is_L2) {
        if (read_logical_sector(fp, base_sector, l2buf) != 0) {
            fprintf(stderr, "Error: can't get L2 @%u\n", base_sector);
            return -1;
        }
        l2_loaded = true;
    } else {
        // L3 directly
        if (read_logical_sector(fp, base_sector, l3buf) != 0) {
            fprintf(stderr, "Error: can't get L3 @%u\n", base_sector);
            return -1;
        }
        l3_loaded = true;
        current_l3_sec = base_sector;
        if (total_records > 256) {
            fprintf(stderr, "Warning: file >256 records but directory points straight to L3, extracting 256 records.\n");
            total_records = 256;
        }
    }

    for (uint32_t r = 0; r < total_records; r++) {
        // Determine L3 to be used
        uint16_t l3_sec;
        if (is_L2) {
            uint32_t group = r / 256; // a single L3 maps 256 records
            if (group >= 128) {
                fprintf(stderr, "Record index out of L2 range (%u)\n", r);
                return -1;
            }
            l3_sec = rd16le(&l2buf[group * 2]);
            if (l3_sec == 0) {
                // No L3 -> 128 bytes set to zero
                static const uint8_t zeros[128] = {0};
                if (fwrite(zeros, 1, 128, out_fp) != 128) return -1;
                continue;
            }
            if (!l3_loaded || l3_sec != current_l3_sec) {
                if (read_logical_sector(fp, l3_sec, l3buf) != 0) {
                    // L3 can't be read -> zeros
                    static const uint8_t zeros[128] = {0};
                    if (fwrite(zeros, 1, 128, out_fp) != 128) return -1;
                    l3_loaded = false;
                    current_l3_sec = 0;
                    continue;
                }
                l3_loaded = true;
                current_l3_sec = l3_sec;
            }
        } else {
            l3_sec = current_l3_sec;
        }

        // L3 mapping the record couple (2n, 2n+1)
        uint32_t within = (r % 256) / 2; // 0..127
        uint16_t w      = rd16le(&l3buf[within * 2]);
        uint16_t sec    = (uint16_t)(w & 0x3FFF);
        bool r0_written = (w & 0x4000) != 0;
        bool r1_written = (w & 0x8000) != 0;

        bool is_even = ((r % 2) == 0);
        bool written = is_even ? r0_written : r1_written;

        // If not written or invalid sector -> zeros
        int track  = sec / 32;
        int rem    = sec % 32;
        int side   = rem / 16;
        int sector = rem % 16;

        if (!written || sec == 0 || sector >= 10) {
            static const uint8_t zeros[128] = {0};
            if (fwrite(zeros, 1, 128, out_fp) != 128) return -1;
            continue;
        }

        // Get data sector
        if (sec != last_data_sec) {
            if (read_logical_sector(fp, sec, databuf) != 0) {
                static const uint8_t zeros[128] = {0};
                if (fwrite(zeros, 1, 128, out_fp) != 128) return -1;
                last_data_sec = 0xFFFF;
                continue;
            }
            last_data_sec = sec;
        }

        // Copy the right sector halve (0..127 if even, 128..255 if odd)
        size_t offset = is_even ? 0 : 128;
        if (fwrite(&databuf[offset], 1, 128, out_fp) != 128) return -1;
    }

    return 0;
}

/* ---------- Directory browsing ---------- */

static bool read_dir_entries(FILE *fp, DirEntry *list, size_t *count)
{
    *count = 0;
    uint8_t secbuf[SECTOR_SIZE];
    bool end_of_dir = false;

    for (uint16_t logsec = LOG_DIR_START; logsec <= LOG_DIR_END && !end_of_dir; logsec++) {
        if (read_logical_sector(fp, logsec, secbuf) != 0) {
            continue; // non existing sector: jump over
        }
        for (int e = 0; e < SECTOR_SIZE / 16 && !end_of_dir; e++) {
            const uint8_t *entry = &secbuf[e * 16];

            uint16_t block_word   = rd16le(&entry[0]);
            uint16_t highest_rec  = rd16le(&entry[2]);
            uint8_t  user         = entry[4];

            if (block_word == 0x0000) {
                end_of_dir = true;
                break;
            }
            if (block_word == 0xFFFF) {
                continue; // missing entry
            }

            DirEntry de;
            de.block_word  = block_word;
            de.highest_rec = highest_rec;
            de.user        = user;
            for (int i = 0; i < 8; i++) de.name[i] = clean_char(entry[5 + i]);
            de.name[8] = '\0';
            for (int i = 7; i >= 0; i--) { if (de.name[i] == ' ') de.name[i] = '\0'; else break; }
            for (int i = 0; i < 3; i++) de.ext[i] = clean_char(entry[13 + i]);
            de.ext[3] = '\0';
            for (int i = 2; i >= 0; i--) { if (de.ext[i] == ' ') de.ext[i] = '\0'; else break; }

            list[*count] = de;
            (*count)++;
            if (*count >= 1024) return true; // set a reasonable limit
        }
    }
    return true;
}

static void print_directory(FILE *fp)
{
    uint8_t secbuf[SECTOR_SIZE];
    bool end_of_dir = false;

    printf("USER  NAME.EXT            SECTORS_USED\n");
    printf("----- -------------------- ------------\n");

    for (uint16_t logsec = LOG_DIR_START; logsec <= LOG_DIR_END && !end_of_dir; logsec++) {
        if (read_logical_sector(fp, logsec, secbuf) != 0) {
            continue;
        }
        for (int e = 0; e < SECTOR_SIZE / 16 && !end_of_dir; e++) {
            const uint8_t *entry = &secbuf[e * 16];

            uint16_t block_word   = rd16le(&entry[0]);
            uint16_t highest_rec  = rd16le(&entry[2]);
            uint8_t  user         = entry[4];

            if (block_word == 0x0000) { end_of_dir = true; break; }
            if (block_word == 0xFFFF) { continue; }

            char name[9];  name[8] = '\0';
            char ext[4];   ext[3]  = '\0';
            for (int i = 0; i < 8; i++) name[i] = clean_char(entry[5 + i]);
            for (int i = 0; i < 3; i++) ext[i]  = clean_char(entry[13 + i]);
            for (int i = 7; i >= 0; i--) { if (name[i] == ' ') name[i] = '\0'; else break; }
            for (int i = 2; i >= 0; i--) { if (ext[i] == ' ') ext[i] = '\0'; else break; }

            int sectors_used = count_file_data_sectors(fp, block_word, highest_rec);

            if (ext[0] != '\0')
                printf("%3u   %-8s.%-3s      %12d\n", user, name, ext, sectors_used);
            else
                printf("%3u   %-8s          %12d\n", user, name, sectors_used);
        }
    }
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr,
            "Usage:\n"
            "  cpndisk <disk.dsd>\n"
            "  cpndisk <disk.dsd> -e USER NAME.EXT OUTFILE\n");
        return 1;
    }

    const char *path = argv[1];
    FILE *fp = fopen(path, "rb");
    if (!fp) {
        perror("Can't open the disk image file");
        return 1;
    }

    if (argc == 2) {
        print_directory(fp);
        fclose(fp);
        return 0;
    }

    if (argc >3 && isdigit(argv[3][0]) && strcmp(argv[2], "-e") == 0) {
        // Parameters
        int want_user = atoi(argv[3]);
        char want_full[64];
        strncpy(want_full, argv[4], sizeof(want_full)-1);
        want_full[sizeof(want_full)-1] = '\0';
        normalize_name(want_full);

        // Split NAME and EXT
        char want_name[32] = {0};
        char want_ext[8]   = {0};
        char *dot = strchr(want_full, '.');
        if (dot) {
            size_t nlen = (size_t)(dot - want_full);
            if (nlen > sizeof(want_name)-1) nlen = sizeof(want_name)-1;
            memcpy(want_name, want_full, nlen);
            strncpy(want_ext, dot + 1, sizeof(want_ext)-1);
        } else {
            strncpy(want_name, want_full, sizeof(want_name)-1);
            want_ext[0] = '\0';
        }

        // Get the directory and search
        DirEntry entries[1024];
        size_t   count = 0;
        if (!read_dir_entries(fp, entries, &count)) {
            fprintf(stderr, "Error reading the directory.\n");
            fclose(fp);
            return 1;
        }

        DirEntry *found = NULL;
        for (size_t i = 0; i < count; ++i) {
            char nbuf[32]; strncpy(nbuf, entries[i].name, sizeof(nbuf)-1); nbuf[sizeof(nbuf)-1] = '\0';
            char ebuf[16]; strncpy(ebuf, entries[i].ext, sizeof(ebuf)-1);  ebuf[sizeof(ebuf)-1] = '\0';
            normalize_name(nbuf);
            normalize_name(ebuf);

            if (entries[i].user == (uint8_t)want_user &&
                strcmp(nbuf, want_name) == 0 &&
                strcmp(ebuf, want_ext) == 0) {
                found = &entries[i];
                break;
            }
        }

        if (!found) {
            fprintf(stderr, "Missing entry: user=%d, name.ext=%s.%s\n",
                    want_user, want_name, want_ext);
            fclose(fp);
            return 2;
        }

        // Create output file
        const char *outpath = argv[4];
        // OUTFILE must be argv[4] in usage, but we have 5 arguments.
        // if argc==6 we use argv[5]
        const char *outfile = (argc >= 6) ? argv[5] : "output.bin";

        FILE *out_fp = fopen(outfile, "wb");
        if (!out_fp) {
            perror("Can't create the output file");
            fclose(fp);
            return 1;
        }

        if (extract_file(fp, found, out_fp) != 0) {
            fprintf(stderr, "File extraction error.\n");
            fclose(out_fp);
            fclose(fp);
            return 1;
        }

        fclose(out_fp);
        fclose(fp);
        fprintf(stderr, "Extracting: %s.%s (user %u) -> %s\n",
                found->name, found->ext, found->user, outfile);
        return 0;
    }

    fprintf(stderr,
            "Parameter error. usage:\n"
            "  cpndisk <disk.dsd>\n"
            "  cpndisk <disk.dsd> -e USER NAME.EXT OUTFILE\n");

    fclose(fp);
    return 1;
}
