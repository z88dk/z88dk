
#ifndef CPMDISK_H
#define CPMDISK_H

// We need the FATfs header
#include "ff.h"

enum diskmode{ DEFAULT, FM500, FM300, FM250, MFM500, MFM300, MFM250 };

typedef struct {
    const char *name;           // Name of the format
    // Generic parameters
    uint8_t   sectors_per_track;
    uint16_t  tracks;
    uint8_t   sides;
    uint16_t  sector_size;
    uint8_t   gap3_length;
    uint8_t   filler_byte;
    uint16_t  directory_entries;

    // CP/M Parameters
    uint8_t   boottracks;        /* What track does the directory start */
    uint16_t  extent_size;       /* In bytes */
    uint8_t   byte_size_extents; /* If set, extends in directories are single byte */
    uint8_t   first_sector_offset; /* If set, first sector in Track-Info is 1, else 0 */
    uint8_t   boot_tracks_sector_offset;   /* Sector offset for boot tracks (0 = ignore) */
    uint32_t  offset;            /* Offset to directory (format kludge) */

    // FAT parameters
    uint8_t   number_of_fats;
    uint16_t  fat_format_flags;
    uint16_t  cluster_size;

    // Hardware/Image peculiarities
    uint8_t   disk_mode;    /* 0..5: 500,300,250 kbps FM .. 500,300,250 kbps MFM */

    // Image layout
    uint8_t   alternate_sides;
    uint8_t   has_skew;
    uint8_t   xor_data;
    uint8_t   inverted_sides;
    uint16_t  skew_track_start;
    uint8_t   skew_tab[32];

    // Optional 2nd side options
    uint8_t   side2_sector_numbering;   /* If set, sector numbering is progressive from side 0 to side 1 */

    // Optional mixed-density boot region (RC702: Track 0 is FM on side 0, MFM on side 1).
    // disc_spec otherwise assumes ONE density/geometry for every track; these fields let a
    // format override just Track 0's per-side geometry so the emitted IMD physically matches
    // the real diskette (side 0 = FM 128 B, side 1 = MFM 256 B).  Only the IMD writer honours
    // them.  The uniform in-memory image still carries a full-size dummy Track 0; its bytes are
    // ignored on output when boot_zero_tracks covers Track 0.
    uint8_t   mixed_density_track0;     /* If set, Track 0 uses the t0sX_* geometry below */
    uint8_t   t0s0_mode;                /* enum diskmode for Track 0 side 0 (e.g. FM500) */
    uint8_t   t0s0_sectors;             /* sectors per track, Track 0 side 0 */
    uint16_t  t0s0_sector_size;         /* sector size in bytes, Track 0 side 0 */
    uint8_t   t0s1_mode;                /* enum diskmode for Track 0 side 1 (e.g. MFM500) */
    uint8_t   t0s1_sectors;             /* sectors per track, Track 0 side 1 */
    uint16_t  t0s1_sector_size;         /* sector size in bytes, Track 0 side 1 */

    // Non-bootable "data diskette" emission.  When boot_zero_tracks > 0 the IMD writer emits
    // that many leading tracks (both sides) with all sector bytes = 0x00 instead of the image's
    // filler.  RC702 autoload reads Track 0 into RAM and dispatches on the " RC702"/" RC700"
    // signatures there; zeroing Tracks 0-1 removes any signature so autoload treats the disk as
    // a data diskette (not bootable) rather than halting on a stray/garbage boot track.
    uint8_t   boot_zero_tracks;         /* # leading tracks whose sector data is zero-filled (0 = off) */

} disc_spec;

typedef struct disc_handle_s disc_handle;

// Utility functions in cpm2.c
extern disc_handle *cpm_create_with_format(const char *disc_format);
extern void cpm_create_filename(const char *binary_name, char *cpm_filename, char force_com_extension, char include_dot);
extern int cpm_write_file_to_image(const char *disc_format, const char *container, const char *output_file, const char *binary_name, const char *crt_filename, const char *boot_filename);
extern int fat_write_file_to_image(const char *disc_format, const char *container, const char* output_file, const char* binary_name, const char* crt_filename, const char* boot_filename);


// Create an in memory disc image
extern disc_handle *disc_create(disc_spec *spec);
extern disc_handle *cpm_create(disc_spec *spec);
extern disc_handle *fat_create(disc_spec* spec);
extern void fat_mount(disc_handle *h);

extern void disc_write_boot_track(disc_handle *h, void *data, size_t len);
extern size_t disc_boot_region_size(disc_spec *spec);
extern void disc_write_boot_region(disc_handle *h, void *data, size_t len);
extern void disc_write_file(disc_handle *h, char filename[11], void *data, size_t len);
extern void disc_free(disc_handle *h);

typedef int (*disc_writer_func)(disc_handle *h, const char *flename);
extern disc_writer_func disc_get_writer(const char *container_name, const char **extension);
extern int disc_write_raw(disc_handle *h, const char *filename);
extern int disc_write_edsk(disc_handle *h, const char *filename);
extern int disc_write_d88(disc_handle *h, const char *filename);
extern int disc_write_anadisk(disc_handle* h, const char* filename);
extern int disc_write_h17(disc_handle* h, const char* filename);
extern int disc_write_h17raw(disc_handle* h, const char* filename);
extern int disc_write_imd(disc_handle* h, const char* filename);
extern int disc_write_dmk(disc_handle* h, const char* filename);
extern int disc_write_td0(disc_handle* h, const char* filename);
extern void disc_print_writers(FILE *fp);


void disc_write_sector(disc_handle *h, int track, int sector, int head, const void *data);
void disc_read_sector(disc_handle *h, int track, int sector, int head, void *data);
void disc_read_sector_lba(disc_handle *h, int sector_nr, int count, void *data);
void disc_write_sector_lba(disc_handle *h, int sector_nr, int count, const void *data);
int disc_get_sector_size(disc_handle *h);
int disc_get_sector_count(disc_handle *h);

#endif

