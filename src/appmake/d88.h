
#ifndef D88_H
#define D88_H

/* Hopelessly naive writing functions, caller is responsible for writing all
   sectors
 */

typedef struct {
        char title[17];
        uint8_t rsrv[9];
        uint8_t protect;
        uint8_t type;
        uint32_t size;
        uint32_t trkptr[164];
} d88_hdr_t;

typedef struct {
        uint8_t c, h, r, n;
        uint16_t nsec;
        uint8_t dens, del, stat;
        uint8_t rsrv[5];
        uint16_t size;
} d88_sct_t;


FILE  *d88_create_disk(const char *name, d88_hdr_t *header, int num_tracks, int sectors_per_track, int sector_size);
int   d88_write_sector(FILE *handle, d88_sct_t *sector, void *data, size_t datalen);



#endif

