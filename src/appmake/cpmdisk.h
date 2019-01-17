
#ifndef CPMDISK_H
#define CPMDISK_H

typedef struct {
    uint8_t   sectors_per_track;
    uint8_t   tracks;
    uint8_t   sides;
    uint16_t  sector_size;
    uint8_t   gap3_length;
    uint8_t   filler_byte;
    uint8_t   boottracks;        /* What track does the directory start */
    uint16_t  directory_entries;
    uint16_t  extent_size;       /* In bytes */
    uint8_t   byte_size_extents; /* If set, extends in directories are single byte */
    uint8_t   first_sector_offset; /* If set, first sector in Track-Info is 1, else 0 */
    uint8_t   boot_tracks_sector_offset;   /* Sector offset for boot tracks (0 = ignore) */
    uint8_t   alternate_sides;
    uint8_t   has_skew;
    uint16_t  skew_track_start;
    uint8_t   skew_tab[16];
    uint32_t  offset;		/* Offset to directory */
} cpm_discspec;

typedef struct cpm_handle_s cpm_handle;

extern cpm_handle *cpm_create(cpm_discspec *spec);
extern void cpm_write_boot_track(cpm_handle *h, void *data, size_t len);
extern void cpm_write_file(cpm_handle *h, char filename[11], void *data, size_t len);
extern int cpm_write_raw(cpm_handle *h, const char *filename);
extern int cpm_write_edsk(cpm_handle *h, const char *filename);
extern void cpm_free(cpm_handle *h);

int cpm_write_file_to_image(const char *disc_format, const char *container, const char *output_file, const char *binary_name, const char *crt_filename, const char *boot_filename);
void cpm_write_sector(cpm_handle *h, int track, int sector, int head, void *data);

#endif

