

#ifndef CPMDISK_H
#define CPMDISK_H

typedef struct {
    uint8_t   sectors_per_track;
    uint8_t   tracks;
    uint8_t   sides;
    uint16_t  sector_size;
    uint8_t   gap3_length;
    uint8_t   filler_byte;
    uint8_t   boottracks;       /* What track does the directory start */

    uint16_t  directory_entries;
    uint16_t  extent_size;
} cpm_discspec;

typedef struct cpm_handle_s cpm_handle;

extern cpm_handle *cpm_create(cpm_discspec *spec);
extern void cpm_write_boot_track(cpm_handle *h, void *data, size_t len);
extern void cpm_write_file(cpm_handle *h, char filename[11], void *data, size_t len);
extern int cpm_write_image(cpm_handle *h, const char *filename);
extern void cpm_free(cpm_handle *h);


#endif

