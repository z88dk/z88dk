/* Some hopeless naive d88 writing functions */

#include "appmake.h"

#include <fcntl.h>
#include <stddef.h>


FILE *d88_create_disk(const char *filename, d88_hdr_t *header, int num_tracks, int sectors_per_track, int sector_size)
{
    uint8_t buf[1024] = {0};  // Plenty big enough
    uint8_t  *ptr = buf;
    uint32_t  size;
    size_t  track_size = (sectors_per_track * (sector_size + sizeof(d88_sct_t)));
    FILE    *fp;
    int      i;

    if ( (fp = fopen(filename, "w") ) == NULL) {
        exit_log(1,"Cannot open d88 disc <%s> for writing\n", filename);
    }
    num_tracks *= 2;
    for ( i = 0; i < num_tracks; i++ ) {
        header->trkptr[i] = sizeof(d88_hdr_t) + track_size * i;
    }
    // total size of file
    size = sizeof(d88_hdr_t) + track_size * i;

    memcpy(buf, header, offsetof(d88_hdr_t, size));
    ptr += offsetof(d88_hdr_t, size);
    *ptr++ = size % 256;
    *ptr++ = (size / 256) % 256;
    *ptr++ = (size / 65536 ) % 256;
    *ptr++ = (size / 65536 ) / 256;
    for ( i = 0; i < num_tracks; i++ ) {
        *ptr++ = header->trkptr[i] % 256;
        *ptr++ = (header->trkptr[i]/ 256) % 256;
        *ptr++ = (header->trkptr[i] / 65536 ) % 256;
        *ptr++ = (header->trkptr[i] / 65536 ) / 256;
    }
    fwrite(  buf, 1, sizeof(*header), fp);

    return fp;
}

/* Needs to be called in order */
int   d88_write_sector(FILE *handle, d88_sct_t *sector, void *data, size_t datalen)
{
     uint8_t  *buf = malloc(sizeof(sector) + datalen);
     uint8_t  *ptr = buf;

     *ptr++ = sector->c;
     *ptr++ = sector->h;
     *ptr++ = sector->r;
     *ptr++ = sector->n;
     *ptr++ = sector->nsec % 256;
     *ptr++ = sector->nsec / 256;
     *ptr++ = sector->dens;
     *ptr++ = sector->del;
     *ptr++ = sector->stat;
     *ptr++ = 0;
     *ptr++ = 0;
     *ptr++ = 0;
     *ptr++ = 0;
     *ptr++ = 0;
     *ptr++ = datalen % 256;
     *ptr++ = datalen / 256;
     memcpy(ptr, data, datalen);

     return fwrite(buf, 1, sizeof(*sector) + datalen, handle);
}


