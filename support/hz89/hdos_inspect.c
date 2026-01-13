
/*
 * hdos_inspect.c
 * Inspect a raw HDOS disk image (H8D/IMG: 256-byte sectors sequentially).
 *
 * Build:   gcc -O2 -Wall -o hdos_inspect hdos_inspect.c
 * Usage:   ./hdos_inspect disk.h8d [--dump-label] [--file NAME.EXT]
 *
 * Notes:
 * - Assumes 256-byte sectors, 10 sectors per track.
 * - Label is at sector #9 (zero-based).
 * - GRT is one sector (200 entries).
 * - Directory blocks are 2 sectors (512 bytes), linked by last 2 bytes.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

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

static uint16_t u16le(const uint8_t *p) {
    return p[0] | (p[1] << 8);
}

static void read_sector(FILE *fp, int sector, uint8_t *buf) {
    fseek(fp, sector * SECTOR_SIZE, SEEK_SET);
    fread(buf, 1, SECTOR_SIZE, fp);
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

static void decode_geometry(uint8_t vfl, int *tracks, int *sides) {
    *tracks = (vfl & 0b10) ? 80 : 40;
    *sides  = (vfl & 0b01) ? 2 : 1;
}

static void hexdump(const uint8_t *buf, size_t len) {
    for (size_t i = 0; i < len; i += 16) {
        printf("%04X  ", (unsigned)i);
        for (size_t j = 0; j < 16 && i+j < len; j++)
            printf("%02X ", buf[i+j]);
        printf("\n");
    }
}

static void parse_directory(FILE *fp, HDOS_Label lab, const uint8_t *grt) {
    int next_sector = lab.dis;
	int entry_count = 0;
	int entry_used = 0;
    printf("\n=== DIRECTORY ===\n");
    printf("%-12s %-5s %-10s %-8s %s\n", "NAME", "FLAGS", "SIZE(B)", "SECTORS", "GROUPS");
    while (next_sector != 0) {
        uint8_t blk[512];
        read_sector(fp, next_sector, blk);
        read_sector(fp, next_sector+1, blk+256);
        for (int i = 0; i < 22; i++) {
            int off = i * 23;
            if (off+23 > 506) break;
            const uint8_t *e = blk + off;
            if (e[0] == 0) continue; // empty
            HDOS_DirEntry d;
            memcpy(d.name, e, 8); d.name[8] = '\0';
            memcpy(d.ext, e+8, 3); d.ext[3] = '\0';
			if (strlen(d.ext)) {
				strcat(d.name, ".");
				strcat(d.name, d.ext);
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
            printf("%-12s %-5s %-10d %-8d ", d.name, flags_s, size_b, sectors);
            if (clen) {
                printf("%d->%d->0\n", chain[0], chain[clen-1]);
				entry_used++;
            } else {
                printf("-\n");
            }
        }
        next_sector = u16le(blk+510);
    }
	printf("%d Directory slots, %d allocated.\n", entry_count, entry_used);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s disk.h8d [--dump-label]\n", argv[0]);
        return 1;
    }
    const char *path = argv[1];
    int dump_label = (argc >= 3 && strcmp(argv[2], "--dump-label") == 0);

    FILE *fp = fopen(path, "rb");
    if (!fp) { perror("open"); return 1; }

    uint8_t sector[SECTOR_SIZE];
    read_sector(fp, 9, sector);
    HDOS_Label lab = parse_label(sector);
    int tracks, sides;
    decode_geometry(lab.vfl, &tracks, &sides);

    printf("=== HDOS LABEL ===\n");
    printf("Volume label    : %s\n", lab.lab);
    printf("Volume serial   : %d\n", lab.ser);
    printf("Directory @sec  : %d\n", lab.dis);
    printf("GRT       @sec  : %d\n", lab.grt);
    printf("Sectors/group   : %d\n", lab.spg);
    printf("Total sectors   : %d\n", lab.siz);
    printf("Geometry        : %d tracks, %d side(s)\n", tracks, sides);
    if (dump_label) {
        printf("\n-- Label hexdump --\n");
        hexdump(sector, SECTOR_SIZE);
    }

    // Read GRT
    uint8_t grt_sector[SECTOR_SIZE];
    read_sector(fp, lab.grt, grt_sector);
    printf("\n=== GRT SUMMARY ===\n");
    int free_chain_len = 0;
    int cur = grt_sector[0];
    while (cur != 0 && free_chain_len < 200) {
        free_chain_len++;
        cur = grt_sector[cur];
    }
    printf("Free chain length: %d groups (~%d sectors free)\n", free_chain_len, free_chain_len*lab.spg);

    // Directory
    parse_directory(fp, lab, grt_sector);

    fclose(fp);
    return 0;
}
