
#ifndef CPMDISK_H
#define CPMDISK_H

// We need the FATfs header
#include "ff.h"

typedef struct {
    const char *name;			// Name of the format
    // Generic parameters
    uint8_t   sectors_per_track;
    uint8_t   tracks;
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
    uint32_t  offset;		/* Offset to directory (format kludge) */

    // FAT parameters
    uint8_t   number_of_fats;
    uint16_t  fat_format_flags;
    uint16_t  cluster_size;

    // Image layout
    uint8_t   alternate_sides;
    uint8_t   has_skew;
    uint16_t  skew_track_start;
    uint8_t   skew_tab[32];
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


extern void disc_write_boot_track(disc_handle *h, void *data, size_t len);
extern void disc_write_file(disc_handle *h, char filename[11], void *data, size_t len);
extern void disc_free(disc_handle *h);

typedef int (*disc_writer_func)(disc_handle *h, const char *flename);
extern disc_writer_func disc_get_writer(const char *container_name, const char **extension);
extern int disc_write_raw(disc_handle *h, const char *filename);
extern int disc_write_edsk(disc_handle *h, const char *filename);
extern int disc_write_d88(disc_handle *h, const char *filename);
extern int disc_write_anadisk(disc_handle* h, const char* filename);
extern int disc_write_imd(disc_handle* h, const char* filename);
extern void disc_print_writers(FILE *fp);


void disc_write_sector(disc_handle *h, int track, int sector, int head, const void *data);
void disc_read_sector(disc_handle *h, int track, int sector, int head, void *data);
void disc_read_sector_lba(disc_handle *h, int sector_nr, int count, void *data);
void disc_write_sector_lba(disc_handle *h, int sector_nr, int count, const void *data);
int disc_get_sector_size(disc_handle *h);
int disc_get_sector_count(disc_handle *h);

#endif

