/*
 * hdos_edit.c
 * z88dk tool to inspect or modify a raw HDOS disk image.
 *
 * Supports:  --dir
 *            --inspect
 *            --get <NAME.EXT> <hostfile>,
 *            --add <hostfile> <NAME.EXT>,
 *            --add <hostfile> <NAME.ABS> address,
 *            --delete <NAME.EXT>
 * 
 * By Stefano Bodrato, Jan 2026
 *
 * Build: gcc -O2 -Wall -o hdos_edit hdos_edit.c
 *
 * Links:  https://github.com/DarrellH89/DiskImageUtility/
 *         https://github.com/sebhc/sebhc/
 *         https://heathkit.garlanger.com/software/OSes/HDOS/
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

#define SECTOR_SIZE 256

typedef struct {
    uint8_t ser;
    uint16_t ind, dis, grt, rgt, siz;
    uint8_t spg, vlt, ver, vfl, spt;
    char lab[61];
} HDOS_Label;

typedef struct {
    char name[9], ext[4];
    uint8_t project, version, cluster_factor, flags;
    uint8_t fgn, lgn, lsi;
    uint16_t crd, ald;
} HDOS_DirEntry;

typedef struct {
    int day;
    int month;
    int year;
} DecodedDate;

typedef struct {
    uint8_t B1;
    uint8_t B2;
} EncodedTimestamp;


static uint16_t u16le(const uint8_t *p) { return p[0] | (p[1] << 8); }
static void w16le(uint8_t *p, uint16_t v) { p[0] = v & 0xFF; p[1] = v >> 8; }

/*
 * Decode the 2-byte timestamp format:
 *
 *   B1: bits 0..4 -> day
 *       bits 5..7 -> month low bits (0..7)
 *
 *   B2: bit 0     -> month high bit (MSB of month)
 *       bits 1..7 -> year offset from 1970
 *
 *   month range is 1..12 but the encoding does not validate
 *   calendar correctness (e.g., 31-SEP is possible).
 */
DecodedDate decode_timestamp(unsigned int dt)
{
    uint8_t B1, B2;
    DecodedDate d;

    B1 =  dt & 0xFF;
    B2 =  dt >> 8;

    d.day   = B1 & 0x1F;                  // 5 lower bits
    d.month = (B1 >> 5) | ((B2 & 0x01) << 3);
    //d.year  = 1970 + (B2 >> 1);
    d.year  = 70 + (B2 >> 1);

    return d;
}


/*
 * Encode date into 2-byte timestamp format:
 *
 *   Input constraints (not enforced):
 *     day   = 1..31
 *     month = 1..12
 *     year  = >= 1970
 *
 *   Encoding:
 *     B1 bits 0..4  -> day
 *     B1 bits 5..7  -> month low 3 bits
 *
 *     B2 bit 0      -> month high bit (month bit 3)
 *     B2 bits 1..7  -> (year - 1970)
 */
EncodedTimestamp encode_timestamp(int day, int month, int year)
{
    EncodedTimestamp e;

    int year_offset = year - 1970;
    int month_low3  = month & 0x07;   // lower 3 bits of month
    int month_high1 = (month >> 3) & 0x01; // MSB of month (bit 3)

    e.B1 = (day & 0x1F) | (month_low3 << 5);
    e.B2 = (month_high1) | (year_offset << 1);

    return e;
}


static void read_sector(FILE *fp, int sector, uint8_t *buf) {
    fseek(fp, sector * SECTOR_SIZE, SEEK_SET);
    fread(buf, 1, SECTOR_SIZE, fp);
}

static void write_sector(FILE *fp, int sector, const uint8_t *buf) {
    fseek(fp, sector * SECTOR_SIZE, SEEK_SET);
    fwrite(buf, 1, SECTOR_SIZE, fp);
}

static HDOS_Label parse_label(const uint8_t *s) {
    HDOS_Label lab;
    lab.ser = s[0];
    lab.ind = u16le(s+1);
    lab.dis = u16le(s+3);
    lab.grt = u16le(s+5);
    lab.spg = s[7];
    lab.vlt = s[8];
    lab.ver = s[9];
    lab.rgt = u16le(s+10);
    lab.siz = u16le(s+12);
    lab.vfl = s[16];
    memcpy(lab.lab, s+17, 60);
    lab.lab[60] = '\0';
    lab.spt = s[79];
    return lab;
}


// Delete a file: free its groups back to the GRT free chain and clear its directory entry.
// Returns 0 on success, 1 if not found, 2 if write-protected/locked, 3 on structural error.
static int delete_file(FILE *fp, HDOS_Label lab, uint8_t *grt, const char *filename)
{
    int next_sector = lab.dis;

    while (next_sector != 0) {
        uint8_t blk[512];
        // Read one directory block (two 256-byte sectors)
        read_sector(fp, next_sector,   blk);
        read_sector(fp, next_sector+1, blk+256);

        for (int i = 0; i < 22; i++) {
            int off = i * 23;
            if (off + 23 > 506) break;           // safety bound

            uint8_t *e = blk + off;
            if (e[0] == 0) continue;                // empty slot
            if (e[0] == 0xFE) continue;             // empty slot
            if (e[0] == 0xFF) continue;             // freed slot

            // Compose NAME.EXT for match (case-insensitive)
            char name[13]; memcpy(name, e, 8); name[8] = '\0';
            char ext[4];  memcpy(ext, e+8, 3);   ext[3]  = '\0';
            if (strlen(ext)) { strcat(name, "."); strcat(name, ext); }

            if (strcasecmp(name, filename) == 0) {
                uint8_t flags = e[14];
                uint8_t fgn   = e[16];           // first group number
                uint8_t lgn   = e[17];           // last group number

                if (fgn == 0) {                   // structurally odd (no groups)
                    // Clear the entry anyway
                    memset(e, 0, 23);
                    write_sector(fp, next_sector,   blk);
                    write_sector(fp, next_sector+1, blk+256);
                    printf("Deleted empty entry %s (no groups).\n", filename);
                    return 0;
                }

                // Respect write-protect/locked flags if desired:
                // W bit (0x20) indicates write-protected, L (0x40) locks flag updates.
                if (flags & 0x20) {
                    fprintf(stderr, "Warning, erasing a write-protected file: %s\n", filename);
                }

                // Optional: warn if L flag set; we still proceed.
                if (flags & 0x40) {
                    fprintf(stderr, "Warning: %s has L (flags locked) set; proceeding with delete.\n", filename);
                }

                // Verify the chain ends where the directory says it does (defensive).
                // Follow GRT from fgn until 0 or lgn. This is optional but helps catch corruption.
                int cur = fgn;
                int steps = 0, found_last = 0;
                while (cur != 0 && steps < 200) {
                    if (cur == lgn) { found_last = 1; break; }
                    cur = grt[cur];
                    steps++;
                }
                if (!found_last) {
                    fprintf(stderr, "GRT chain for %s does not end at lgn=%u (possible corruption).\n", filename, lgn);
                    // We can still attempt freeing, but return a diagnostic code.
                    // Fall through to freeing logic.
                }

                // Free the file's group chain:
                // Link the file's last group to current free-chain head, then make fgn the new head.
                // See: GRT semantics, free head at grt[0].  (H-17 Disk System doc)
                // grt[lgn] currently should be 0; we replace it with old head.
                uint8_t old_head = grt[0];
                grt[lgn] = old_head;
                grt[0]   = fgn;

                // Clear the directory entry (mark as empty by zeroing first byte; we zero all 23 bytes for cleanliness).
                //memset(e, 0, 23);
                // This is the classic method, it should suffice
                e[0] = 0xFF;   // NOTE: 0x00 would truncate the directory, 0xFE raise errors

                // Write back directory block and GRT sector
                write_sector(fp, next_sector,   blk);
                write_sector(fp, next_sector+1, blk+256);
                write_sector(fp, lab.grt, grt);

                printf("Deleted %s: groups returned to free chain (head now %u).\n", filename, grt[0]);
                return found_last ? 0 : 3;
            }
        }

        // Follow linked directory blocks: next block index at offset 510..511 (little-endian)
        next_sector = u16le(blk + 510);
    }

    fprintf(stderr, "File %s not found.\n", filename);
    return 1;
}


// Extract file from disk image
// If outpath is a null string, then we use extract_file to check whether a filename is already present (0 if file exists)
static int extract_file(FILE *fp, HDOS_Label lab, const uint8_t *grt, const char *filename, const char *outpath) {
    int next_sector = lab.dis;
    while (next_sector != 0) {
        uint8_t blk[512];
        read_sector(fp, next_sector, blk);
        read_sector(fp, next_sector+1, blk+256);
        for (int i = 0; i < 22; i++) {
            int off = i * 23;
            if (off+23 > 506) break;
            const uint8_t *e = blk + off;
            if (e[0] == 0) continue;
            char name[13];
            memcpy(name, e, 8); name[8]='\0';
            char ext[4]; memcpy(ext, e+8, 3); ext[3]='\0';
            if (strlen(ext)) { strcat(name, "."); strcat(name, ext); }
            if (*outpath == '\0') {
                if (strcasecmp(name, filename)==0) return 0;
            } else {
                if (strcasecmp(name, filename)==0) {
                    uint8_t fgn = e[16];
                    uint8_t lgn = e[17];
                    uint8_t lsi = e[18];
                    FILE *out = fopen(outpath, "wb");
                    if (!out) { perror("open out"); return 1; }
                    int cur = fgn;
                    int group_count = 0;
                    while (cur != 0) {
                        for (int s = 0; s < lab.spg; s++) {
                            int sector_num = (cur * lab.spg) + s;             // HDOS: group g -> sectors [g*spg .. g*spg+(spg-1)]
                            uint8_t buf[SECTOR_SIZE];
                            read_sector(fp, sector_num, buf);
                            // Last group may have partial sectors
                            if (cur == lgn && s > lsi) break;
                            fwrite(buf, 1, SECTOR_SIZE, out);
                        }
                        cur = grt[cur];
                        group_count++;
                    }
                    fclose(out);
                    printf("Extracted %s to %s (%d groups)\n", filename, outpath, group_count);
                    return 0;
                }
            }
        }
        next_sector = u16le(blk+510);
    }
    return 1;
}


// Insert file into disk image
static int insert_file(FILE *fp, HDOS_Label lab, uint8_t *grt,
                       const char *inpath, const char *filename, int abs_addr)
{
    FILE *in = fopen(inpath, "rb");
    if (!in) { perror("open in"); return 1; }

    // Determine sizes
    fseek(in, 0, SEEK_END);
    long host_size = ftell(in);
    rewind(in);

    const int make_abs = (abs_addr != 0);
    long on_disk_size = host_size + (make_abs ? 8 : 0);   // include ABS header if requested
    int sectors_needed = (int)((on_disk_size + SECTOR_SIZE - 1) / SECTOR_SIZE);
    int groups_needed  = (sectors_needed + lab.spg - 1) / lab.spg;

    // Collect free groups (from free chain head at grt[0])
    int free_groups[200], free_count = 0;
    int gcur = grt[0];
    while (gcur != 0 && free_count < 200) {
        free_groups[free_count++] = gcur;
        gcur = grt[gcur];
    }
    if (free_count < groups_needed) {
        fprintf(stderr, "Not enough space\n");
        fclose(in);
        return 1;
    }

    // Allocate: link the chosen groups together and terminate with 0
    int fgn = free_groups[0];
    int lgn = free_groups[groups_needed - 1];
    for (int i = 0; i < groups_needed - 1; ++i)
        grt[free_groups[i]] = (uint8_t)free_groups[i + 1];
    grt[free_groups[groups_needed - 1]] = 0;

    // Advance free chain head beyond the allocated run
    grt[0] = (free_count > groups_needed) ? (uint8_t)free_groups[groups_needed] : 0;

    // Write file data into allocated groups
    uint8_t buf[SECTOR_SIZE];
    int written = 0;

    for (int g = 0; g < groups_needed; ++g) {
        int gnum = free_groups[g];  // actual group number we allocated
        for (int s = 0; s < lab.spg; ++s) {

            size_t r = 0;

            if (make_abs && g == 0 && s == 0) {
                // First sector: build ABS header + payload prefix
                // ABS header: 0xFF,0x00, then three big-endian words (load, length, entry)
                memset(buf, 0, sizeof(buf));
                buf[0] = 0xFF; buf[1] = 0x00;
                w16le(buf + 2, (uint16_t)abs_addr);
                w16le(buf + 4, (uint16_t)(on_disk_size - 8));  // payload byte count (no header)
                w16le(buf + 6, (uint16_t)abs_addr);
                r = fread(buf + 8, 1, SECTOR_SIZE - 8, in);     // may be 0..(SECTOR_SIZE-8)
                // If r < SECTOR_SIZE-8, buffer tail is already zeroed by memset above
            } else {
                r = fread(buf, 1, SECTOR_SIZE, in);             // may be 0..SECTOR_SIZE
                if (r < SECTOR_SIZE) memset(buf + r, 0, SECTOR_SIZE - r);
            }

            // Always write this sector if it's part of the logical size we computed
            int sector_num = (gnum * lab.spg) + s; // group g -> sectors [g*spg .. g*spg+(spg-1)]
            write_sector(fp, sector_num, buf);
            written++;

            // Stop once we've written all needed sectors (handles exact fit)
            if (written >= sectors_needed)
                break;
        }
        if (written >= sectors_needed)
            break;
    }
    fclose(in);

    // Update directory: first empty slot
    int next_sector = lab.dis;
    while (next_sector != 0) {
        uint8_t blk[512];
        read_sector(fp, next_sector, blk);
        read_sector(fp, next_sector + 1, blk + 256);

        for (int i = 0; i < 22; ++i) {
            int off = i * 23;
            if (off + 23 > 506) break;

            if ((blk[off] == 0xFE)||(blk[off] == 0xFF)||(blk[off] == 0x00)) {
                printf("Identified Directory slot at offset %u\n",off);
                // Prepare NAME.EXT in 8.3 uppercase
                memset(blk + off, 0, 23);
                char name8[8] = {0}, ext3[3] = {0};
                const char *dot = strchr(filename, '.');
                if (dot) {
                    size_t base_len = (size_t)(dot - filename);
                    if (base_len > 8) base_len = 8;
                    memcpy(name8, filename, base_len);
                    memcpy(ext3, dot + 1, 3);
                } else {
                    memcpy(name8, filename, 8);
                }
                memcpy(blk + off,     name8, 8);
                memcpy(blk + off + 8, ext3,  3);

                // Uppercase name + ext (do not clobber outer loop index!)
                for (int j = 0; j < 11; ++j) {
                    blk[off + j] = (uint8_t)toupper((unsigned char)blk[off + j]);
                }
                
                // Optionally set flags/project/version/cluster_factor              
                blk[off + 13] = lab.spg+1;    // cluster factor (+1 as seen in the wild)
                blk[off + 14] = 0x00;         // flags, e.g. 0x20 = WR protect

                // Fill in chain info
                blk[off + 16] = (uint8_t)fgn;                           // first group
                blk[off + 17] = (uint8_t)lgn;                           // last group
                blk[off + 18] = (uint8_t)((sectors_needed - 1) % lab.spg); // last sector index in last group

                // Put z88dk signature in the file timestamp
                EncodedTimestamp ts = encode_timestamp(1, 1, 1988);
                blk[off + 19] = blk[off + 21] = ts.B1;
                blk[off + 20] = blk[off + 22] = ts.B2;

                write_sector(fp, next_sector,     blk);
                write_sector(fp, next_sector + 1, blk + 256);

                // Persist GRT
                write_sector(fp, lab.grt, grt);

                printf("Inserted %s from %s (%ld bytes on host, %ld on-disk)\n",
                       filename, inpath, host_size, on_disk_size);
                return 0;
            }
        }
        next_sector = u16le(blk + 510);
    }

    fprintf(stderr, "No free directory slot\n");
    return 1;
}


static void decode_geometry(uint8_t vfl, int *tracks, int *sides) {
    *tracks = (vfl & 0b10) ? 80 : 40;
    *sides  = (vfl & 0b01) ? 2 : 1;
}


static void dump_sector_hex(FILE *fp, int sector) {
    uint8_t buf[SECTOR_SIZE];
    read_sector(fp, sector, buf);
    //printf("=== SECTOR %d (0x%X) HEX DUMP ===\n", sector, sector);
    for (int i = 0; i < SECTOR_SIZE; i += 16) {
        printf("%04X : ", i);
        for (int j = 0; j < 16; j++)
            printf("%02X ", buf[i + j]);
        //printf(" | ");
        //for (int j = 0; j < 16; j++) {
        //    uint8_t c = buf[i + j];
        //    printf("%c", (c >= 32 && c < 127) ? c : '.');
        //}
        printf("\n");
    }
    printf("\n");
}

// Print the directory chain and get the block and sector count.
// A "directory block" is 512 bytes long (= 2 sectors); the next block link is at offset 510..511.

static void report_directory_chain(FILE *fp, HDOS_Label lab)
{
    int next_sector = lab.dis;
    int blocks = 0, sectors = 0;

    printf("\n=== DIRECTORY CHAIN ===\n");
    while (next_sector != 0) {
        uint8_t blk[512];
        // Get the directory block (2 sectors)
        read_sector(fp, next_sector,     blk);
        read_sector(fp, next_sector + 1, blk + 256);

        // 508..509 = "block start" sector index, 510..511 = link to next block
        uint16_t this_begin = u16le(blk + 508);
        uint16_t next_begin = u16le(blk + 510);

        printf("Block #%d @sec %u (verify begin=%u) -> next %u\n",
               blocks, next_sector, this_begin, next_begin);

        blocks++;
        sectors += 2; // 512 B = 2 settori
        next_sector = next_begin;
        if (sectors >= 200) {
            printf("Error: circular directory chaining\n");
            return;
        }
    }
    printf("Total directory: %d blocks, %d sectors\n", blocks, sectors);
}


// === GRT helpers ===================================================
// Each GRT byte is a "next group" index; grt[0] is the free-list head.
// Valid group numbers for classic H-17 HDOS are typically 1..200.
// The number of sectors per group is lab.spg.

static int grt_next(const uint8_t *grt, int g) {
    if (g < 0 || g > 255) return 0; // defensive
    return grt[g];
}

// Count free groups by following the free-list from grt[0]
static int grt_count_free(const uint8_t *grt, int max_steps) {
    int head = grt[0];
    int cnt = 0, steps = 0;
    int seen[256] = {0};
    while (head != 0 && steps < max_steps) {
        if (head < 0 || head > 255) break;
        if (seen[head]) {
            printf("Error: loop in free-list at group %d\n", head);
            break;
        }
        seen[head] = 1;
        cnt++;
        head = grt_next(grt, head);
        steps++;
    }
    return cnt;
}

// Verify a single file chain (fgn..lgn, lsi) and return group count.
// Sets *ends_at_lgn = 1 if last visited group == lgn.
// Returns -1 on loop/corruption detection.
static int grt_verify_file_chain(const uint8_t *grt, int fgn, int lgn, int *ends_at_lgn) {
    int seen[256] = {0};
    int cur = fgn, clen = 0;
    *ends_at_lgn = 0;

    while (cur != 0) {
        if (cur < 0 || cur > 255) {
            printf("Error: invalid group index %d in chain\n", cur);
            return -1;
        }
        if (seen[cur]) {
            printf("Error: Loop detected in file chain at group %d\n", cur);
            return -1;
        }
        seen[cur] = 1;
        clen++;
        int nxt = grt_next(grt, cur);
        if (nxt == 0) {
            if (cur == lgn) *ends_at_lgn = 1;
            else printf("Error: chain does not end at lgn (%d != %d)\n", cur, lgn);
        }
        cur = nxt;
    }
    return clen;
}

static void print_grt_chain(const uint8_t *grt, int start)
{
    if (start <= 0) {
        printf(" - ");
        return;
    }

    int cur = start;
    int count = 0;

    while (cur != 0 && count < 200) {
        printf("%d", cur);
        cur = grt[cur];
        if (cur != 0) printf(" -> ");
        count++;
    }

    printf(" -> 0 ");
}

// Compute file size in sectors given clen, lsi, and lab.spg
static int file_sectors_from_chain(int clen, int lsi, int spg) {
    if (clen <= 0) return 0;
    return (clen - 1) * spg + (lsi + 1);
}



static int check_sector10_fingerprint(FILE *fp)
{
    uint8_t buf[SECTOR_SIZE];
    int i;

    read_sector(fp, 10, buf); /* LSN 10 */

    /* Check first 5 signature bytes */
    if (!(buf[0] == 0x00 && buf[1] == 0x00 &&
          buf[2] == 0xFF && buf[3] == 0xFF && buf[4] == 0xFF))
        return 0;

    /* Check tail: last 56 bytes should be 0xFF.
     * Be tolerant: we check indices [SECTOR_SIZE-56 .. SECTOR_SIZE-1].
     */
    for (i = SECTOR_SIZE - 56; i < SECTOR_SIZE; ++i) {
        if (buf[i] != 0xFF)
            return 0;
    }
    return 1;
}


static void inspect(FILE *fp, HDOS_Label lab, uint8_t *grt) {
    uint8_t sector[SECTOR_SIZE];
    read_sector(fp, 9, sector);
    int tracks, sides;
    decode_geometry(lab.vfl, &tracks, &sides);

    printf("=== HDOS LABEL ===\n");
    printf("Volume label    : %s\n", lab.lab);
    printf("Volume serial   : %d\n", lab.ser);
    printf("Volume Type     : ");
    switch (lab.vlt) {
        case 0:
            printf("Data\n");
            break;
        case 1:
            printf("System\n");
            break;
        default:
            printf("Unknown: $%02X\n", lab.vlt);
    }

    printf("System Version  : %u.%u\n", lab.ver/16 , lab.ver&15);
    // Initialization date
    DecodedDate ts = decode_timestamp(lab.ind);
    printf("Creation date   : %02d-%02d-%02d\n", ts.day, ts.month, ts.year);

    //printf("Directory @sec  : %d\n", lab.dis);
    printf("Sectors/group   : %d\n", lab.spg);
    printf("Total sectors   : %d\n", lab.siz);
    printf("Geometry        : %d tracks, %d side(s)\n", tracks, sides);
    if (lab.ver < 0x20)
        printf("SPT flags       : %d\n", lab.spt);
    else
        printf("Sectors/track   : %d\n", lab.spt);

    // RGT (Root Group Table) – 256 bytes
    printf("\n=== RGT (Root Group Table, @sector %u) ===\n",lab.rgt);
    //printf("RGT       @sec  : %d\n", lab.rgt);
    if (lab.rgt) dump_sector_hex(fp, lab.rgt);

    // Read GRT
    uint8_t grt_sector[SECTOR_SIZE];
    read_sector(fp, lab.grt, grt_sector);
    printf("=== GRT (Group Reference Table, @sector %u) ===\n", lab.grt);
    //printf("GRT       @sec  : %d\n", lab.grt);
    
    int free_chain_len =grt_count_free(grt_sector, lab.siz);
    
    //int free_chain_len = 0;
    //int cur = grt_sector[0];
    //while (cur != 0 && free_chain_len < 200) {
    //    free_chain_len++;
    //    cur = grt_sector[cur];
    //}
    //printf("Free chain length: %d groups (~%d sectors free)\n", free_chain_len, free_chain_len*lab.spg);

    printf("\nFree chain: ");
    print_grt_chain(grt_sector, grt_sector[0]);
    printf(",  %d groups (%d sectors) free.\n", free_chain_len, free_chain_len * lab.spg);

    //printf("\nGRT Summary (first 64 groups):\n");
    //printf("Grp | Next\n");
    //printf("----+------\n");
    //for (int i = 0; i < 64; i++) {
    //  printf("%3d | %3d\n", i, grt_sector[i]);
    //}

    printf("\n=== GRT (Group Reference Table) ===\n");
    dump_sector_hex(fp, lab.grt);

    //printf("=== 1st directory sector: %u ===\n", lab.dis);
    report_directory_chain(fp,lab);

	if (check_sector10_fingerprint(fp))
		printf("\nHDOS fingerprint in sector #10 -> OK\n");
	else
		printf("\nWarning: invalid fingerprint in sector #10, possibly invalid HDOS disk.\n");

}


static void parse_directory(FILE *fp, HDOS_Label lab, const uint8_t *grt, int add_detail) {
    int next_sector = lab.dis;
    int entry_count = 0;
    int entry_used = 0;
    char entry_fname[14];
    
    printf("\n=== DIRECTORY ===\n");
    printf("%-12s  %-5s %-10s  %-8s  %-8s  %s\n", "NAME", "FLAGS", "SIZE(B)", "SECTORS", "DATE", "GROUPS");
    while (next_sector != 0) {
        uint8_t blk[512];
        read_sector(fp, next_sector, blk);
        read_sector(fp, next_sector+1, blk+256);
        for (int i = 0; i < 22; i++) {
            int off = i * 23;
            if (off+23 > 506) break;
            const uint8_t *e = blk + off;
            if (e[0] == 0) continue; // empty, but never used on the early  HDOS versions (not sure abt the late versions)
            if (e[0] == 0xFE) {entry_count++; continue;} // empty
            if (e[0] == 0xFF) continue; // empty, not to be used
            HDOS_DirEntry d;
            
            memcpy(entry_fname, e, 8); entry_fname[8] = '\0';
            memcpy(d.ext, e+8, 3); d.ext[3] = '\0';
            if (strlen(d.ext)) {
                strcat(entry_fname, ".");
                strcat(entry_fname, d.ext);
            }
            d.project = e[11];
            d.version = e[12];
            d.cluster_factor = e[13];
            d.flags = e[14];
            d.fgn = e[16];
            d.lgn = e[17];
            d.lsi = e[18];
            d.crd = u16le(e+19);
            d.ald = u16le(e+21);
            // Follow chain
            int chain[200], clen = 0;
            int cur = d.fgn;
            while (cur != 0 && clen < 200) {
                chain[clen++] = cur;
                cur = grt[cur];
            }
            entry_count++;
            int sectors = clen ? ((clen-1)*lab.spg + (d.lsi+1)) : 0;
            int size_b = sectors * SECTOR_SIZE;
            char flags_s[5] = "-";
            if (d.flags & 0x80) flags_s[0]='S';
            if (d.flags & 0x40) flags_s[1]='L';
            if (d.flags & 0x20) flags_s[2]='W';
            if (d.flags & 0x10) flags_s[3]='C';
            
            // Creation Date
            DecodedDate ts = decode_timestamp(d.crd);
            // Last Update
            //DecodedDate ts = decode_timestamp(d.ald);
            
            // Compare the actual sector count to the file lsi
            char sec_check=(sectors==file_sectors_from_chain(clen, d.lsi, lab.spg)) ? ' ' : '!';

            printf("%-12s  %-5s %-10d  %c%-8d %02d-%02d-%02d  ", entry_fname, flags_s, size_b, sec_check, sectors-1, ts.day, ts.month, ts.year);

            int ends_at_lgn;
            if (clen != grt_verify_file_chain(grt, d.fgn, d.lgn, &ends_at_lgn)) printf ("[!] ");
            else if (!ends_at_lgn) printf ("[!] ");

            if (clen) {
                printf("%d->%d->0\n", chain[0], chain[clen-1]);
                entry_used++;
            } else {
                printf("-\n");
            }

            
            // Optionaly, print the whole chain
            if (add_detail) {
                printf("   [ ");
                for (int k = 0; k < clen; k++) {
                    printf("%d", chain[k]);
                    if (k < clen - 1)
                        printf(" -> ");
                }
            printf(" -> 0 ]\n\n");
            }


        }
        next_sector = u16le(blk+510);
        if (entry_used >= 200)  {
            printf("Error: circular directory chaining\n");
            return;
        }
    }
    printf("%d Directory slots, %d allocated.\n", entry_count, entry_used);
}


int main(int argc,char**argv){
    if (argc<3){
        fprintf(stderr,"z88dk HDOS Heath/Zenith disk image editor/analyzer\n");
        fprintf(stderr,"Usage: %s disk.h8d {command}\n",argv[0]);
        fprintf(stderr,"\t[--dir <+>]\n");
        fprintf(stderr,"\t[--inspect]\n");
        fprintf(stderr,"\t[--get name.ext out]\n");
        fprintf(stderr,"\t[--add hostfile name.ext <addr>]\n");
        fprintf(stderr,"\t[--delete name.ext]\n");
        return 1;
        }
    const char*path=argv[1];
    FILE*fp=fopen(path,"r+b"); if(!fp){perror("Missing disk image file");return 1;}

    uint8_t sector[SECTOR_SIZE];read_sector(fp,9,sector);
    HDOS_Label lab=parse_label(sector);
    uint8_t grt_sector[SECTOR_SIZE];read_sector(fp,lab.grt,grt_sector);

    if(argc>=3) {
        if(strcmp(argv[2],"--get")==0){
            if(argc==4) {
                fprintf(stderr, "Output filename missing.\n");
                fclose(fp);
                return 1;
            }
            if (extract_file(fp,lab,grt_sector,argv[3],argv[4])) {
                fprintf(stderr, "File %s not found.\n", argv[3]);
                fclose(fp);
                return 1;
            }
            goto program_end;
        }
        if(strcmp(argv[2],"--add")==0){
            if (extract_file(fp,lab,grt_sector,argv[4],"")==0) {
                fprintf(stderr,"hdos_edit: file already present");
                fclose(fp);
                return 1;
            }
            rewind(fp);
            insert_file(fp,lab,grt_sector,argv[3],argv[4],(argc < 6) ? 0 :atoi(argv[5])); goto program_end;
        }
        if(strcmp(argv[2],"--delete")==0){delete_file(fp,lab,grt_sector,argv[3]); goto program_end;}
        if(strcmp(argv[2],"--inspect")==0){inspect(fp,lab,grt_sector); goto program_end;}
        if(strcmp(argv[2],"--dir")==0){parse_directory(fp, lab, grt_sector,(argc < 4) ? 0 : 1); goto program_end;}
        fprintf(stderr,"hdos_edit: wrong option");
        fclose(fp);
        return 1;
    }

program_end:
    fclose(fp);
    return 0;
}
