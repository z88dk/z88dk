/*
 * Disc image handling
 */

#include "appmake.h"
#include "diskio.h"


// d88 media type
#define MEDIA_TYPE_2D   0x00
#define MEDIA_TYPE_2DD  0x10
#define MEDIA_TYPE_2HD  0x20
#define MEDIA_TYPE_144  0x30
#define MEDIA_TYPE_UNK  0xff

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


// dmk media type
typedef struct
{
    uint8_t writeProtected;
    uint8_t numTracks;
    uint8_t trackLen[2];
    uint8_t flags;
    uint8_t reserved[7];
    uint8_t format[4];
} dmk_header_t;


struct disc_handle_s {
    disc_spec  spec;

    uint8_t      *image;

    // CP/M information
    uint8_t      *extents;
    int           num_extents;

    // FAT information
    FATFS         fatfs;

    // Routine delegation
    void         (*write_file)(disc_handle *h, char *filename, void *data, size_t bin);
};


static void cpm_write_file(disc_handle* h, char *filename, void* data, size_t len);
static void fat_write_file(disc_handle* h, char *filename, void* data, size_t len);

// Generic routines

disc_handle *disc_create(disc_spec* spec)
{
    disc_handle* h = calloc(1, sizeof(*h));
    size_t len;

    h->spec = *spec;
    len = spec->tracks * spec->sectors_per_track * spec->sector_size * spec->sides;
    h->image = calloc(len, sizeof(char));
    memset(h->image, spec->filler_byte, len);


#if 0
    // Code that marks each sector so we can see what is actually loaded
    for ( int t = 0, offs = 0; t < spec->tracks; t++ ) {
        for ( int head = 0; head < spec->sides; head++ ) {
           for ( int s = 0; s < spec->sectors_per_track; s++ ) {
              for ( int b = 0; b < spec->sector_size / 4 ; b++ ) {
                 h->image[offs++] = t; //^ 255;
                 h->image[offs++] = head; //^ 255;
                 h->image[offs++] = s; //^ 255;
                 h->image[offs++] = 0; //^ 255;
              }
           }
        }
    }
#endif
    return h;
}


void disc_write_file(disc_handle* h, char *filename, void* data, size_t len)
{
    h->write_file(h, filename, data, len);
}


void disc_write_boot_track(disc_handle* h, void* data, size_t len)
{
    memcpy(h->image, data, len);
}

void disc_write_sector_lba(disc_handle *h, int sector_nr, int count, const void *data)
{
    const uint8_t *ptr = data;
    int      i;

    for ( i = 0; i < count; i++ ) {
        int track = sector_nr / h->spec.sectors_per_track;
        int sector = sector_nr % h->spec.sectors_per_track;
        int head;

            head = track % 2;
                   track /= 2;

        disc_write_sector(h, track, sector, head, ptr);
        sector_nr++;
        ptr += h->spec.sector_size;
    }
}


int track_offset(disc_handle* h, int t, int s)
{
    size_t track_length = h->spec.sector_size * h->spec.sectors_per_track;

    if ( h->spec.alternate_sides == 0 )
        return ( track_length * t + ((h->spec.inverted_sides ^ s) * track_length * h->spec.tracks) );

    return ( track_length * ((t * 2) + (h->spec.inverted_sides ^ s)) );
}


void disc_write_sector(disc_handle *h, int track, int sector, int head, const void *data)
{
    size_t offset;

    offset = track_offset(h,track,head);
    offset += sector * h->spec.sector_size;
    memcpy(&h->image[offset], data, h->spec.sector_size);
}

void disc_read_sector_lba(disc_handle *h, int sector_nr, int count, void *data)
{
    uint8_t *ptr = data;
    int      i;

    for ( i = 0; i < count; i++ ) {
        int track = sector_nr / h->spec.sectors_per_track;
        int sector = sector_nr % h->spec.sectors_per_track;
        int head;

            head = track % 2;
                   track /= 2;

        disc_read_sector(h, track, sector, head, ptr);
        sector_nr++;
        ptr += h->spec.sector_size;
    }
}

void disc_read_sector(disc_handle *h, int track, int sector, int head, void *data)
{
    size_t offset;

    offset = track_offset(h,track,head);
    offset += sector * h->spec.sector_size;
    memcpy(data, &h->image[offset], h->spec.sector_size);
}




int disc_get_sector_size(disc_handle *h)
{
    return h->spec.sector_size;
}

int disc_get_sector_count(disc_handle *h)
{
    return h->spec.sides  * h->spec.sectors_per_track * h->spec.tracks;
}


void disc_free(disc_handle* h)
{
    free(h->image);
    free(h->extents);
    free(h);
}

// Image writing routines
struct container {
    const char        *name;
    const char        *extension;
    const char        *description;
    disc_writer_func   writer;
} containers[] = {
    { "dsk",        ".dsk", "CPC extended .dsk format",    disc_write_edsk },
    { "d88",        ".D88", "d88 format",                  disc_write_d88 },
    { "ana",        ".dump", "Anadisk format",             disc_write_anadisk },
    { "h17",        ".h17", "Heathkit H17 Hard-sectored",  disc_write_h17 },
    { "h17raw",     ".h17raw", "H89js RAW format",         disc_write_h17raw },
    { "imd",        ".imd", "IMD (Imagedisk) format",      disc_write_imd },
    { "dmk",        ".dmk", "dmk (TRS-80/MSX) format",     disc_write_dmk },
    { "td0",        ".TD0", "TeleDisk (TD0) format",       disc_write_td0 },
    { "raw",        ".img", "Raw image",                   disc_write_raw },
    { NULL, NULL, NULL }
};

disc_writer_func disc_get_writer(const char *container_name, const char **extension)
{
    struct container *c = &containers[0];
    while (c->name != NULL) {
        *extension = c->extension;
        if (strcasecmp(container_name, c->name) == 0) {
            return c->writer;
        }
        c++;
    }
    return NULL;
}

void disc_print_writers(FILE *fp)
{
    struct container *c = &containers[0];

    while ( c->name ) {
        fprintf(fp, "%-20s%s\n", c->name, c->description);
        c++;
    }
}


// If necessary, apply the skew table
int skew_sector(disc_handle* h, int j, int track)
{
    int sect;
    
    if (c_linear) return (j);

    if ( h->spec.has_skew && track + (track * h->spec.sides) >= h->spec.skew_track_start ) {
        for ( sect = 0; sect < h->spec.sectors_per_track; sect++ ) {
            if ( h->spec.skew_tab[sect] == j ) break;
        }
    } else return (j);

    return (sect);
}


// Invert or xor in some way the disk data if needed
void xorblock(uint8_t *pos, int count, int mask)
{
    int i;
    for ( i = 0; i < count; i++ )
        pos[i] ^= mask;
}


/*
 *  Heath/Zenith specific containers
 *  ================================
 *  The volume "number" is zero for CP/M,
 *  on HDOS (not supported by cpmdisk) it is the vol number of the disk label
 */

static uint8_t h17_checksum(const uint8_t *buf, size_t n, uint8_t d) {
  for (size_t k=0; k<n; ++k) {
    d ^= buf[k];             // XOR
    d = (d << 1) | (d >> 7); // RLC
  }
  return d;
}


// Write hard sectored disk image (H17)
int disc_write_h17(disc_handle* h, const char* filename)
{
    size_t offs;
    FILE* fp;
    int i, j, s;

    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }

    /* Header "H17D" + "200" + 0xFF */
    uint8_t header[8] = {'H','1','7','D','2','0','0',0xFF};
    fwrite(header, sizeof(header), 1, fp);

     /* DskF (sides, tracks, ro) */
    uint8_t dskf[12] = {'D','s','k','F', 0,0,0,3, 1,40,0};
    dskf[8] = (h->spec.sides == 2) ? 2 : 1;
    dskf[9] = h->spec.tracks;            // 40 o 80
    dskf[10]= 0;                         // not write-protected
    fwrite(dskf, 12-1, 1, fp);           // 11 bytes total

    /* Labl (optional) */
    uint8_t labl[13] = {'L','a','b','l', 0,0,0,5, 'z','8','8','d','k'};
    fwrite(labl, sizeof(labl), 1, fp);

    /* Padding: zero-fill up to 248 */
    long pos = ftell(fp);       //should be 32
    while (pos < 248) { fputc(0, fp); ++pos; }

    /* H8DB header with length (bytes) */
    uint8_t h8db[8] = {'H','8','D','B', 0,0,0,0};
    uint32_t h8d_len = h->spec.sector_size * h->spec.sectors_per_track * h->spec.tracks * h->spec.sides;
    h8db[4] = (h8d_len >> 24) & 0xFF;
    h8db[5] = (h8d_len >> 16) & 0xFF;
    h8db[6] = (h8d_len >>  8) & 0xFF;
    h8db[7] = (h8d_len      ) & 0xFF;
    fwrite(h8db, 8, 1, fp);
    
    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                 fwrite(h->image + offs + j*h->spec.sector_size, h->spec.sector_size, 1, fp);       // NO SKEW here !!
            }
        }
    }

    // Sector metadata block header
    uint8_t meta[16];   // Metadata data
    uint32_t sectors = h->spec.tracks * h->spec.sectors_per_track * h->spec.sides;
    uint32_t secm_len = sectors * 16;
    uint8_t secm[8] = {'S','e','c','M', 0,0,0,0};
    secm[4] = (secm_len >> 24) & 0xFF;
    secm[5] = (secm_len >> 16) & 0xFF;
    secm[6] = (secm_len >>  8) & 0xFF;
    secm[7] = (secm_len      ) & 0xFF;
    fwrite(secm, 8, 1, fp);

    // Sector metadata (physical order), with offset and checksum
    // 'skew' does not apply here, we're shuffling the sector contents only
    uint32_t h8d_base = 256;
    uint32_t track_len = h->spec.sector_size * h->spec.sectors_per_track;

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            size_t offs = track_offset(h,i,s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
               memset(meta, 0, sizeof(meta));

               uint32_t h8d_offs = h8d_base + (((i * h->spec.sides) + s) * track_len) + (skew_sector(h, j, i) * h->spec.sector_size);

               meta[0] = (h8d_offs >> 24) & 0xFF;
               meta[1] = (h8d_offs >> 16) & 0xFF;
               meta[2] = (h8d_offs >>  8) & 0xFF;
               meta[3] = (h8d_offs      ) & 0xFF;
               
               meta[4]  = 0x00;        // status (no error)

               meta[5]  = 0xFD;        // Sync

               uint8_t vol = 0;                // CP/M: always 0
               /* UNUSED HACK: if we have c_linear (no skew), we assume it is HDOS */
               // if (c_linear && i) vol = 88;    // HDOS: 0 on track 0, otherwise "volume number"
               
               meta[6]  = vol;
               meta[7]  = i;
               meta[8]  = j;           // sector number in headers (0..9)

               // header checksum (vol,trk,sec)
               meta[9]  = h17_checksum((uint8_t[]){vol,i,j}, 3, 0xfD);
               meta[10] = 0xFD;        // Sync
               uint8_t *sp = h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size);
               meta[11] = h17_checksum(sp, h->spec.sector_size, 0);
  
               // on H17 the sector size should always be 256
               meta[12] = h->spec.sector_size & 0xFF;
               meta[13] = (h->spec.sector_size >> 8) & 0xFF;
               // remaining bytes (14–15) are reserved (=0)        

               fwrite(meta, 16, 1, fp);
            }
        }
    }
    
    fclose(fp);
    return 0;
}


/* Write a sector "frame" (header + data + gap) */
static void h17raw_write_sector_frame(FILE *fp, uint8_t vol, uint8_t track, uint8_t j, const uint8_t *payload256)
{
    uint8_t b;
    int i;
    
    /* --- Header: 00..00, FD, VOL/TRK/SEC/HCK --- */
    for (i = 0; i < 10; ++i) fputc(0x00, fp);      // zero padding before the 0xFD header sync
    fputc(0xFD, fp);  /* sync header */

    fputc(vol,   fp);
    fputc(track, fp);
    fputc(j,fp);

    b = h17_checksum((const uint8_t[]){vol,track,j}, 3, 0xFD);  // header checksum on [VOL,TRK,SEC]
    fputc(b, fp);

    /* --- Data: 00..00, FD, 256 bytes, DCK --- */
    for (i = 0; i < 10; ++i) fputc(0x00, fp);      // Zero padding before the 0xFD data sync
    fputc(0xFD, fp);  /* sync data */

    fwrite(payload256, 1, 256, fp);                // 256 data bytes payload

    b = h17_checksum(payload256, 256, 0);          // data bytes checksum
    fputc(b, fp);

    /* Gap between sectors */
    for (i = 0; i < 3; ++i) fputc(0x00, fp);       // Post data zeroes
    for (i = 0; i < 34; ++i) fputc(0xFF, fp);      // 0xFF filler between sectors
}


/* ------------------------------------------------------------------------
 * H17-RAW (per-sector) writer
 * Writes: [00..] FD [VOL][TRK][SEC][HCK] [00..] FD [256 DATA][DCK] [FF..]
 * ------------------------------------------------------------------------ */
int disc_write_h17raw(disc_handle *h, const char *filename)
{
    int i, j;

    FILE *fp = fopen(filename, "wb");
    if (!fp) return -1;

    for (i = 0; i < h->spec.tracks; ++i) {
        for (int s = 0; s < h->spec.sides; ++s) {

           size_t offs = track_offset(h, i, s);

           /* Sectors are in "physical" order 0..(N-1) */
           for (j = 0; j < h->spec.sectors_per_track; ++j) {

               uint8_t vol = 0;                  // CP/M: always 0
               /* UNUSED HACK: if we have c_linear (no skew), we assume it is HDOS */
               // if (c_linear && i) vol = 88;    // HDOS: 0 on track 0, otherwise "volume number"

               /* Write the full frame (header + data + gap) */
               /* 'skew' the sector data only */
               h17raw_write_sector_frame(fp, vol, i, j, h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size));
           }
        }
    }

    fclose(fp);
    return 0;
}


// Write a raw disk, no headers for tracks etc
int disc_write_raw(disc_handle* h, const char* filename)
{
    size_t offs;
    FILE* fp;
    int i, j, s;

    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                 xorblock(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, h->spec.xor_data);
                 fwrite(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, 1, fp);
            }
        }
    }
    fclose(fp);
    return 0;
}


int disc_write_edsk(disc_handle* h, const char* filename)
{
    uint8_t header[256] = { 0 };
    char    title[15];
    size_t offs;
    FILE* fp;
    int i, j, s;
    int sector_size = 0;

    i = h->spec.sector_size;
    while (i > 128) {
        sector_size++;
        i /= 2;
    }

    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }
    memset(header, 0, 256);
    memcpy(header, "EXTENDED CPC DSK File\r\nDisk-Info\r\n", 34);
    snprintf(title,sizeof(title),"z88dk/%s", h->spec.name ? h->spec.name : "appmake");
    memcpy(header + 0x22, title, strlen(title));
    header[0x30] = h->spec.tracks % 256;
    header[0x31] = h->spec.sides;
    for (i = 0; i < h->spec.tracks * h->spec.sides; i++) {
        header[0x34 + i] = (h->spec.sector_size * h->spec.sectors_per_track + 256) / 256;
    }
    fwrite(header, 256, 1, fp);

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            uint8_t* ptr;
            offs = track_offset(h, i, s);
            memset(header, 0, 256);
            memcpy(header, "Track-Info\r\n", 12);
            header[0x10] = i;
            header[0x11] = s; // side
            header[0x14] = sector_size;
            header[0x15] = h->spec.sectors_per_track;
            header[0x16] = h->spec.gap3_length;
            header[0x17] = h->spec.filler_byte;
            ptr = header + 0x18;
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                *ptr++ = i; // Track
                *ptr++ = s; // Side

                // side2_sector_numbering option tested on MAME (Kaypro4)
                if ( h->spec.side2_sector_numbering || h->spec.inverted_sides ) {
                    // SKEW table introduced to support the Sharp MZ80A, MZ80B..
                    if ( (! h->spec.side2_sector_numbering) || (! (h->spec.inverted_sides ^ s)) ) {
                        if (  i + (i*h->spec.sides) <= h->spec.boottracks && h->spec.boot_tracks_sector_offset ) {
                            *ptr++ = skew_sector(h, j, i) + h->spec.boot_tracks_sector_offset; // Sector ID
                        } else {
                            *ptr++ = skew_sector(h, j, i) + h->spec.first_sector_offset; // Sector ID
                        }
                    } else {
                        if (  i + (i*h->spec.sides) <= h->spec.boottracks && h->spec.boot_tracks_sector_offset ) {
                            *ptr++ = skew_sector(h, j, i) + h->spec.boot_tracks_sector_offset + h->spec.sectors_per_track; // Sector ID
                        } else {
                            *ptr++ = skew_sector(h, j, i) + h->spec.first_sector_offset + h->spec.sectors_per_track ; // Sector ID
                        }
                    }
                } else {
                    // Usually implementing SKEW is not necessary (tested on MAME)
                    if ( (! h->spec.side2_sector_numbering) || (! (h->spec.inverted_sides ^ s)) ) {
                        if (  i + (i*h->spec.sides) <= h->spec.boottracks && h->spec.boot_tracks_sector_offset ) {
                            *ptr++ = j + h->spec.boot_tracks_sector_offset; // Sector ID
                        } else {
                            *ptr++ = j + h->spec.first_sector_offset; // Sector ID
                        }
                    } else {
                        if (  i + (i*h->spec.sides) <= h->spec.boottracks && h->spec.boot_tracks_sector_offset ) {
                            *ptr++ = j + h->spec.boot_tracks_sector_offset + h->spec.sectors_per_track; // Sector ID
                        } else {
                            *ptr++ = j + h->spec.first_sector_offset + h->spec.sectors_per_track ; // Sector ID
                        }
                    }
                }

                *ptr++ = sector_size;
                *ptr++ = 0; // FDC status register 1
                *ptr++ = 0; // FDC status register 2
                *ptr++ = h->spec.sector_size % 256;
                *ptr++ = h->spec.sector_size / 256;
            }
            fwrite(header, 256, 1, fp);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                 xorblock(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, h->spec.xor_data);
                 fwrite(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, 1, fp);
            }
        }
    }
    fclose(fp);
    return 0;
}



int disc_write_d88(disc_handle* h, const char* filename)
{
    uint8_t header[1024] = { 0 };
    char    title[18];
    uint8_t *ptr;
    size_t offs;
    FILE* fp;
    int i, j, s;
    int sector_size = 0;
    int track_length = h->spec.sector_size * h->spec.sectors_per_track;


    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }


    i = h->spec.sector_size;
    while (i > 128) {
        sector_size++;
        i /= 2;
    }

    ptr = header;
    snprintf(title,sizeof(title),"z88dk/%s", h->spec.name ? h->spec.name : "appmake");
    memcpy(ptr, title, strlen(title)); ptr += 17;
    ptr += 9;  // Reserved
    *ptr++ = 0; // Protect
    // Calculate data size of the disc
    offs = track_length * h->spec.tracks * h->spec.sides;
    *ptr++ =  (offs < (368640 + 655360) / 2) ? MEDIA_TYPE_2D : (offs < (737280 + 1228800) / 2) ? MEDIA_TYPE_2DD : MEDIA_TYPE_2HD;
    // Calculate the file length of the disc image
    offs = sizeof(d88_hdr_t) + (sizeof(d88_sct_t) * h->spec.sectors_per_track + track_length) * (h->spec.tracks * h->spec.sides);
    *ptr++ = offs % 256;
    *ptr++ = (offs / 256) % 256;
    *ptr++ = (offs / 65536) % 256;
    *ptr++ = ((offs / 65536) / 256) % 256;
    
    for ( i = 0; i < h->spec.tracks * h->spec.sides; i++ ) {
        offs = sizeof(d88_hdr_t) + (sizeof(d88_sct_t) * h->spec.sectors_per_track +  track_length) * i;
        *ptr++ = offs % 256;
        *ptr++ = (offs / 256) % 256;
        *ptr++ = (offs / 65536) % 256;
        *ptr++ = ((offs / 65536) / 256) % 256;
        if ( h->spec.sides == 1 ) {
           *ptr++ = 0;
           *ptr++ = 0;
           *ptr++ = 0;
           *ptr++ = 0;
        }
    }
    fwrite(header, sizeof(d88_hdr_t), 1, fp);

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                 uint8_t *ptr = header;

                 *ptr++ = i;                //track
                 *ptr++ = s;                //head

                 if ( (! h->spec.side2_sector_numbering) || (! (h->spec.inverted_sides ^ s)) )
                    *ptr++ =  skew_sector(h, j, i) + h->spec.first_sector_offset;       //sector
                 else
                    *ptr++ =  skew_sector(h, j, i) + h->spec.first_sector_offset + h->spec.sectors_per_track ;   //sector (2nd side)

                 *ptr++ = sector_size;      //n
                 *ptr++ = (h->spec.sectors_per_track) % 256;
                 *ptr++ = (h->spec.sectors_per_track) / 256;
                 *ptr++ = 0;                //dens
                 *ptr++ = 0;                //del
                 *ptr++ = 0;                //stat
                 *ptr++ = 0;                //reserved
                 *ptr++ = 0;                //reserved
                 *ptr++ = 0;                //reserved
                 *ptr++ = 0;                //reserved
                 *ptr++ = 0;                //reserved
                 *ptr++ = (h->spec.sector_size % 256);
                 *ptr++ = (h->spec.sector_size / 256);
                 fwrite(header, ptr - header, 1, fp);
                 xorblock(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, h->spec.xor_data);
                 fwrite(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, 1, fp);
            }
        }
    }
    fclose(fp);
    return 0;
}

int disc_write_anadisk(disc_handle* h, const char* filename)
{
    size_t offs;
    FILE* fp;
    int i, j, s;
    int sector_size = 0;

    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }

    i = h->spec.sector_size;
    while (i > 128) {
        sector_size++;
        i /= 2;
    }

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                uint8_t header[8] = { 0 };

                // Track header:
                // physical cylinder
                // physical head
                // cylinder
                // head
                // secotr number
                // size code
                // length word
                header[0] = i;
                header[1] = s;
                header[2] = i;
                header[3] = s;
                if ( (! h->spec.side2_sector_numbering) || (! s) )
                    header[4] = skew_sector(h, j, i) + h->spec.first_sector_offset;
                else
                    header[4] = skew_sector(h, j, i) + h->spec.first_sector_offset + h->spec.sectors_per_track;
                header[5] = sector_size;
                header[6] = h->spec.sector_size % 256;
                header[7] = h->spec.sector_size / 256;

                fwrite(header, 8, 1, fp);
                xorblock(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, h->spec.xor_data);
                fwrite(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, 1, fp);
            }
        }
    }
    fclose(fp);
    return 0;
}

int disc_write_imd(disc_handle* h, const char* filename)
{
    size_t offs;
    FILE* fp;
    int i, j, s;
    int sector_size = 0;
    uint8_t buffer[80];
    uint8_t *ptr;
    time_t tim;
    struct tm *tm;


    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }

    // Write header
    time(&tim);
    tm = localtime(&tim);
    fprintf(fp, "IMD z88dk: %2d/%2d/%4d %02d:%02d:%02d\r\n%s\x1a",
          tm->tm_mday, tm->tm_mon + 1, tm->tm_year + 1900,
          tm->tm_hour, tm->tm_min, tm->tm_sec, h->spec.name);


    i = h->spec.sector_size;
    while (i > 128) {
        sector_size++;
        i /= 2;
    }

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            ptr = buffer;

            if (h->spec.disk_mode)
                *ptr++ = h->spec.disk_mode-1; // Mode + transfer rate
            else 
                *ptr++ = 3; // 500 kbps MFM
            
            *ptr++ = i; // track
            *ptr++ = s; // head
            *ptr++ = h->spec.sectors_per_track; // Sectors per track
            *ptr++ = sector_size; // Size of sector

            // Write sector map
            // "If ImageDisk is unable to obtain all sector numbers in a single revolution of the disk, it will report 
            // 'Unable to determine interleave' and rearrange the sector numbers into a simple sequential list."
            // In most of the situations the sequential map is the best choice, but on the MZ80A/MZ80B which are
            // currently the only case with the disk sides swapped.
            // At the moment we use "spec.inverted_sides" to apply the skew map properly.

            if (h->spec.inverted_sides) {
                for ( j = 0; j < h->spec.sectors_per_track; j++ ) {
                    if ( (! h->spec.side2_sector_numbering) || (! (h->spec.inverted_sides ^ s)) )
                        *ptr++ = skew_sector(h, j, 99)  +  h->spec.first_sector_offset;
                    else
                        *ptr++ = skew_sector(h, j, 99)  +  h->spec.first_sector_offset + h->spec.sectors_per_track;
                }
            } else {
                for ( j = 0; j < h->spec.sectors_per_track; j++ ) {
                    if ( (! h->spec.side2_sector_numbering) || (! (h->spec.inverted_sides ^ s)) )
                        *ptr++ = j  +  h->spec.first_sector_offset;
                    else
                        *ptr++ = j  +  h->spec.first_sector_offset + h->spec.sectors_per_track;
                }
            }

            // And write the header
            fwrite(buffer, ptr - buffer, 1, fp);

            // And now write each sector - we don't do compression and all sectors are good
            offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                fputc(1, fp);   // Sector type 1  = has data
                xorblock(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, h->spec.xor_data);
                fwrite(h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size, 1, fp);
            }
        }
    }
    fclose(fp);
    return 0;
}


static uint16_t dmk_crc(uint8_t *cp, int sz)
{
    int x,i,crc;

    crc = 0xffff;
    for (x = 0; x < sz; ++x) {
        for (i = 8; i < 16; ++i) {
            crc = (crc << 1) ^ ((((crc ^ (cp[x] << i)) & 0x8000) ? 0x1021 : 0));
        }
    }
    
    return (crc);
}


int disc_write_dmk(disc_handle* h, const char* filename)
{
    dmk_header_t header;
    size_t offs;
    FILE* fp;
    int i, j, s;
    int rawTrackLen,rawSectorLen,dmkTrackLen;
    int sector_size = 0;
    int gap1 = 50;
    int gap2 = 22;
    int gap4a = 80;
    int gap4b = 182;

    int pos;
    uint16_t crc;  // CRC checksum

    i = h->spec.sector_size;
    while (i > 128) {
        sector_size++;
        i /= 2;
    }

    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }
    
    // Disk header
    rawSectorLen = 12 + 3 + 1 + 6 + gap2 + 12 + 4 + h->spec.sector_size + 2 +  h->spec.gap3_length;
    rawTrackLen  = gap4a + 12 + 4 + gap1 + h->spec.sectors_per_track * rawSectorLen + gap4b;
    dmkTrackLen  = rawTrackLen + 128;

    memset(&header, 0, sizeof(header));
    header.numTracks = h->spec.tracks;
    header.trackLen[0] = dmkTrackLen & 0xff;
    header.trackLen[1] = dmkTrackLen >> 8;

    // Bit 4, if set, means this is a single sided ONLY disk. 
    header.flags = ((h->spec.sides == 2) ? 0 : (1 << 4));

    // Bit 6, if set, means this disk is to be single density size
    // and the emulator will access one byte instead of two when doing I/O in single density
    if (h->spec.disk_mode < MFM500)
        header.flags += (1 << 6);

    fwrite(&header, sizeof(header), 1, fp);

    // Tracks

    uint8_t **addrPos = calloc(h->spec.sectors_per_track, sizeof(uint8_t *));
    uint8_t **dataPos = calloc(h->spec.sectors_per_track, sizeof(uint8_t *));
    uint8_t *buf = calloc(dmkTrackLen, sizeof(char));

    uint8_t *ip = &buf[0];   // pointer in IDAM table
    uint8_t *tp = &buf[128]; // pointer in actual track data

    memset(tp, 0x4e, gap4a);  tp +=gap4a;
    memset(tp, 0x00, 12);     tp += 12;
    memset(tp, 0xc2, 3);      tp += 3;
    memset(tp, 0xfc, 1);      tp++;
    memset(tp, 0x4e, gap1);   tp += gap1;

    // We prepare the skeleton for a track
    // and the pointer vectors for IDAM entry and data block for each sector
    for (j = 0; j < h->spec.sectors_per_track; ++j) {

        memset(tp, 0x00, 12);     tp += 12;    // sync
        memset(tp, 0xa1, 3);      tp += 3;     // ID addr mark
        pos = tp - &buf[0];
        *ip++ = pos & 0xff;
        // Bit 15 is set if the sector is double density.
        if (h->spec.disk_mode < MFM500)
            *ip++ = (pos >> 8);  // single density
        else
            *ip++ = (pos >> 8) | 0x80;  // double density (MFM) sector

        // Track pointed by the IDAM pointer
        memset(tp, 0xfe, 1);      tp++;        // ID addr mark (cont)

        // ----  (overwritten later) ----
        addrPos[j] = (uint8_t *)tp;
        memset(tp, 0x00, 6);      tp += 6;     // C H R N CRC (overwritten later)
        // ------------------------------

        memset(tp, 0x4e, gap2);   tp += gap2;  // gap2
        memset(tp, 0x00, 12);     tp += 12;    // sync
        memset(tp, 0xa1, 3);      tp += 3;     // data mark
        memset(tp, 0xfb, 1);      tp++;

        // ----  (overwritten later) ----
        dataPos[j] = (uint8_t *)tp;
        memset(tp, 0x00, h->spec.sector_size);  tp += h->spec.sector_size; // sector data (overwritten later)
        memset(tp, 0x00, 2);      tp += 2;     // CRC (overwritten later)
        memset(tp, 0x4e, h->spec.gap3_length);   tp += h->spec.gap3_length;
        // ------------------------------
    }

    memset(tp, 0x4e, gap4b);   //tp += gap4b;

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; j++) {

                // ---  IDAM ---
                uint8_t *ap = addrPos[j];
                *ap++ = i;
                *ap++ = s;
                //*ap++ = j + h->spec.first_sector_offset;  //*ap++ = j + 1;
                if ( (! h->spec.side2_sector_numbering) || (! (h->spec.inverted_sides ^ s)) )
                    *ap++ = skew_sector(h, j, i) + h->spec.first_sector_offset;       //sector
                else
                    *ap++ = skew_sector(h, j, i) + h->spec.first_sector_offset + h->spec.sectors_per_track ;   //sector (2nd side)

                // Sector size code
                switch (h->spec.sector_size) {
                    case 1024:
                        *ap++ = 3;
                        break;
                    case 256:
                        *ap++ = 1;
                        break;
                    case 128:
                        *ap++ = 0;
                        break;
                    default:
                        *ap++ = 2;  // e.g. 512
                };
                
                // CRC of ID Address Mark (IDAM)
                crc = dmk_crc(ap - 8, 8);
                *ap++ = crc >> 8;
                *ap++ = crc & 0xff;

                // ---  DATA ---
                uint8_t *dp = dataPos[j];
                memcpy (dp, h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size), h->spec.sector_size);
                xorblock (dp, h->spec.sector_size, h->spec.xor_data);
                dp += h->spec.sector_size;
                
                // CRC of sector data block
                crc = dmk_crc(dp - h->spec.sector_size - 4, h->spec.sector_size + 4);
                *dp++ = crc >> 8;
                *dp++ = crc & 0xff;

            }
            fwrite(&buf[0], dmkTrackLen, 1, fp);
        }
    }
    
    free(addrPos);
    free(dataPos);
    free(buf);

    fclose(fp);
    return 0;
}



/* TD0 CRC-16 (poly 0xA097), initial value 0x0000; MSB-first bit processing.
 * See: Dave Dunfield's "Teledisk .TD0 notes" (CRC section). */
static uint16_t td0_crc16(const uint8_t *p, size_t n)
{
    uint16_t crc = 0;
    while (n--) {
        uint8_t b = *p++;
        for (int i = 0; i < 8; i++) {
            uint16_t mix = (crc ^ (b << 8)) & 0x8000;
            crc <<= 1;
            if (mix) crc ^= 0xA097;
            b <<= 1;
        }
    }
    return crc;
}


int disc_write_td0(disc_handle *h, const char *filename)
{
    uint8_t ssize_code;
    int i, j, s;
    
    FILE *fp = fopen(filename, "wb");
    if (!fp) return -1;

    /* ---------- TD0 Image Header (12 bytes) ---------- */
    uint8_t hdr[12] = {0};
    hdr[0] = 'T'; hdr[1] = 'D';          /* normal compression signature */
    hdr[2] = 0;                          /* sequence (single volume) */
    hdr[3] = 0;                          /* checksequence */
    hdr[4] = 0x21;                       /* TeleDisk version (2.1) */

    /* Data rate (lower 2 bits: 0=250,1=300,2=500; bit7 may indicate FM on very old images) */
    if (h->spec.disk_mode == DEFAULT)
        hdr[5] = 1;                        /* Default rpm: 300 */
    else if (h->spec.disk_mode >= MFM500)
        hdr[5] = MFM250 - h->spec.disk_mode;
    else
        hdr[5] = FM250 - h->spec.disk_mode;

/*  Drive type
   
    0 = 5,25″ 96 tpi (double stepping)
    1 = 5,25″ (generic - good default case)
    2 = 5,25″ 48 tpi
    3 = 3,5″
    4 = 3,5″ (variant)
    5 = 8″
    6 = 3,5″ (another variant)
*/
    if (h->spec.tracks == 77)
      hdr[6] = 5;   // 8"
    else if ((h->spec.sector_size == 512) && (h->spec.tracks == 80))
      hdr[6] = 3;   // 3"
    else
      hdr[6] = 1;   // generic 5,25″ (default)
  
    hdr[7] = 0x00;                       /* stepping (00=single); no comment => high bit clear */
    hdr[8] = 0x00;                       /* DOS allocation flag (0 = none) */
    hdr[9] = (h->spec.sides == 1) ? 0x01 : 0x02; /* sides: 1 or 2 */
    uint16_t hcrc = td0_crc16(hdr, 10); /* CRC over first 10 bytes */
    hdr[10] = (uint8_t)(hcrc & 0xFF);
    hdr[11] = (uint8_t)(hcrc >> 8);
    fwrite(hdr, 1, sizeof(hdr), fp);

    /* ---------- Tracks ---------- */

    switch (h->spec.sector_size) {
    case 128:  ssize_code = 0;
               break;
    case 256:  ssize_code = 1;
               break;
    case 512:  ssize_code = 2;
               break;
    case 1024: ssize_code = 3;
               break;
    case 2048: ssize_code = 4;
               break;
    case 4096: ssize_code = 5;
               break;
    case 8192: ssize_code = 6;
               break;
    default:   ssize_code = 2; /* default to 512 */
               break;
    }

    for (i = 0; i < h->spec.tracks; ++i) {
        for (s = 0; s < h->spec.sides; ++s) {
            /* Track Header: [numsects, cyl, side, CRC(low)] */
            uint8_t th[4];
            th[0] = h->spec.sectors_per_track;
            th[1] = i;
            /* TD0 sets bit7 of "side" for single-density on mixed-density images.
               We don't change density per track here, so keep side as 0/1. */
            th[2] = s;
            if ((h->spec.disk_mode >= FM500)&&(h->spec.disk_mode <= FM250))  th[2] |= 0x80; /* mark FM per-track */
            uint16_t tcrc = td0_crc16(th, 3);
            th[3] = (uint8_t)(tcrc & 0xFF);
            fwrite(th, 1, sizeof(th), fp);

            /* Sector loop */
            size_t offs = track_offset(h, i, s);
            for (j = 0; j < h->spec.sectors_per_track; ++j) {
                
                /* Logical sector number */
                uint8_t sec_id;

                if (!h->spec.side2_sector_numbering || !(h->spec.inverted_sides ^ s)) {
                    /* side 0 or numbering not used: 1..N */
                    sec_id = j + h->spec.first_sector_offset;
                } else {
                    /* side 1 with side2 numbering: N+1..2N */
                    sec_id = skew_sector(h, j, i) + h->spec.first_sector_offset + h->spec.sectors_per_track;
                }

                /* Sector Header: [C, H, R, N, Flags, CRC(low)] */
                uint8_t sh[6] = {0};
                sh[0] = i;                 /* logical C */
                sh[1] = s;                 /* logical H */
                sh[2] = sec_id;            /* logical R */
                sh[3] = ssize_code;        /* N (size code) */
                sh[4] = 0x00;              /* Flags: none (no deleted data/dup/errors) */

                /* Data header + payload (encoding = 0 -> raw) */
                const uint8_t *sp = h->image + offs + (skew_sector(h, j, i) * h->spec.sector_size);

                /* Copy to a temp buffer so that optional XOR can be applied before CRC */
                uint8_t *tmp = malloc(h->spec.sector_size);
                if (!tmp) { fclose(fp); return -1; }
                memcpy(tmp, sp, h->spec.sector_size);
                xorblock(tmp, h->spec.sector_size, h->spec.xor_data);

                /* Sector Data Header: [len_lo, len_hi, encoding] ; len includes 'encoding' byte */
                uint8_t dh[3];
                uint16_t data_len = (uint16_t)(h->spec.sector_size + 1); /* encoding + data bytes */
                dh[0] = (uint8_t)(data_len & 0xFF);
                dh[1] = (uint8_t)(data_len >> 8);
                dh[2] = 0x00; /* encoding method 0 = raw sector data */

                /* Compute sector CRC over: first 5 bytes of SH + full DH + data */
                uint16_t scrc = 0;
                scrc = td0_crc16(sh, 5);
                scrc = td0_crc16(dh, 3) ^ scrc; /* accumulate by XOR of sequential td0_crc16 results? */
                /* NOTE: td0_crc16 returns CRC for a block; to concatenate blocks, we must feed bytes sequentially. */
                {
                    /* Build a transient buffer covering [SH(5) | DH(3) | DATA(ssize)] for CRC */
                    uint8_t *crcbuf = malloc(5 + 3 + h->spec.sector_size);
                    if (!crcbuf) { free(tmp); fclose(fp); return -1; }
                    memcpy(crcbuf + 0, sh, 5);
                    memcpy(crcbuf + 5, dh, 3);
                    memcpy(crcbuf + 8, tmp, h->spec.sector_size);
                    scrc = td0_crc16(crcbuf, 5 + 3 + h->spec.sector_size);
                    free(crcbuf);
                }
                sh[5] = (uint8_t)(scrc & 0xFF); /* only the low byte is stored */

                /* Write sector header + data header + payload */
                fwrite(sh, 1, sizeof(sh), fp);
                fwrite(dh, 1, sizeof(dh), fp);
                fwrite(tmp, 1, h->spec.sector_size, fp);
                free(tmp);
            }
        }
    }

    /* End-of-image marker: one byte 0xFF (track header with sector count=255) */
    fputc(0xFF, fp);

    fclose(fp);
    return 0;
}



// CP/M routines
static int first_free_extent(disc_handle* h)
{
    int i;

    for (i = 0; i < h->num_extents; i++) {
        if (h->extents[i] == 0) {
            return i;
        }
    }
    exit_log(1,"No free extents on disc\n");
    return -1;
}

static size_t get_directory_offset(disc_handle* h) {
    return (h->spec.offset ? h->spec.offset : (h->spec.boottracks * h->spec.sectors_per_track * h->spec.sector_size));
}

static size_t find_first_free_directory_entry(disc_handle* h)
{
    int i;
    size_t directory_offset = get_directory_offset(h);

    for (i = 0; i < h->spec.directory_entries; i++) {
        if (h->image[directory_offset] == h->spec.filler_byte) {
            return directory_offset;
        }
        directory_offset += 32;
    }
    exit_log(1,"No free directory entries on disc\n");
    return 0;
}

disc_handle *cpm_create(disc_spec* spec)
{
    disc_handle* h = disc_create(spec);
    int directory_extents;
    int i;


    directory_extents = (h->spec.directory_entries * 32) / h->spec.extent_size;
    h->num_extents = ((spec->tracks - h->spec.boottracks) * h->spec.sectors_per_track * h->spec.sector_size) / h->spec.extent_size + 1;
    h->extents = calloc(h->num_extents, sizeof(uint8_t));

    /* Now reserve the directory extents */
    for (i = 0; i < directory_extents; i++) {
        h->extents[i] = 1;
    }

    h->write_file = cpm_write_file;
    size_t directory_offset = get_directory_offset(h);
    //memset(h->image +directory_offset, 0xe5, 512);
    memset(h->image +directory_offset, h->spec.filler_byte, (h->spec.directory_entries * 32));
    return h;
}


static void cpm_write_file(disc_handle* h, char *filename, void* data, size_t len)
{
    //size_t num_extents = (len / h->spec.extent_size) + 1;
    size_t num_extents = (len + h->spec.extent_size - 1) / h->spec.extent_size;
    size_t directory_offset;
    size_t offset;
    uint8_t direntry[32];
    int i, j, current_extent;
    int extents_per_entry = h->spec.byte_size_extents ? 16 : 8;

    directory_offset = find_first_free_directory_entry(h);
    // Now, write the directory entry, we can start from extent 1
    current_extent = first_free_extent(h);
    // We need to turn that extent into an offset into the disc
    offset = get_directory_offset(h) + (current_extent * h->spec.extent_size);

    memcpy(h->image + offset, data, len);

    for (i = 0; i <= (num_extents / extents_per_entry); i++) {
        int extents_to_write;

        memset(direntry, 0, sizeof(direntry));

        direntry[0] = 0; // User 0
        memcpy(direntry + 1, filename, 11);
        direntry[12] = i; // Extent number
        direntry[13] = 0;
        direntry[14] = 0;
        if (num_extents - (i * extents_per_entry) > extents_per_entry) {
            direntry[15] = 0x80;
            extents_to_write = extents_per_entry;
        } else {
            direntry[15] = (((len % (extents_per_entry * h->spec.extent_size))+ 127) / 128) % 256;
            extents_to_write = ((int)num_extents - (i * extents_per_entry));
        }
        for (j = 0; j < extents_per_entry; j++) {
            if (j < extents_to_write) {
                h->extents[current_extent] = 1;
                if (h->spec.byte_size_extents) {
                    direntry[j + 16] = (current_extent) % 256;
                } else {
                    direntry[j * 2 + 16] = (current_extent) % 256;
                    direntry[j * 2 + 16 + 1] = (current_extent) / 256;
                }
                current_extent++;
            }
        }
        
        // Wipe the directory entry if empty (no extents)
        if (!(direntry[16] | direntry[17]))
            memset(direntry, 0, sizeof(direntry));

        memcpy(h->image + directory_offset, direntry, 32);
        directory_offset += 32;
    }
}


// FAT filesystem - we delegate mostly to FatFS

// Nasty static reference to file, TODO, I can do this better
static disc_handle *current_fat_handle = NULL;

disc_handle *fat_create(disc_spec* spec)
{
    disc_handle *h = disc_create(spec);
    char         buf[1024];
    FRESULT      res;

    current_fat_handle = h;
    // Create a file system
    if ( (res = f_mkfs("1", (BYTE)spec->fat_format_flags, spec->cluster_size, buf, sizeof(buf), spec->number_of_fats, spec->directory_entries)) != FR_OK) {
        exit_log(1, "Cannot create FAT filesystem: %d\n",res);
    }

    // And now we need to mount it
    if ( (res = f_mount(&h->fatfs, "1", 1)) != FR_OK ) {
        exit_log(1, "Cannot mount newly create FAT filesystem: %d\n",res);
    }

    h->write_file = fat_write_file;
    return h;
}

void fat_mount(disc_handle *h)
{
    //char         buf[1024];
    FRESULT      res;

    current_fat_handle = h;
    // And now we need to mount it
    if ( (res = f_mount(&h->fatfs, "1", 1)) != FR_OK ) {
        exit_log(1, "Cannot mount newly create FAT filesystem: %d\n",res);
    }

    h->write_file = fat_write_file;
}

static void fat_write_file(disc_handle* h, char *filename, void* data, size_t len)
{
    FIL file={{0}};
    UINT written;

    if ( f_open(&file, filename, FA_WRITE|FA_CREATE_ALWAYS) != FR_OK ) {
        exit_log(1, "Cannot create file <%s> on FAT image", filename);
    }

    if ( f_write(&file, data, (UINT)len, &written) != FR_OK ) {
        exit_log(1, "Cannot write file contents to FAT image");
    }

    f_close(&file);
}


// FATFs interface

DSTATUS disk_status (
    BYTE pdrv        /* Physical drive number to identify the drive */
)
{
    return RES_OK;
}

DSTATUS disk_initialize (
    BYTE pdrv                /* Physical drive number to identify the drive */
)
{
    return RES_OK;
}


DRESULT disk_read (
    BYTE pdrv,        /* Physical drive number to identify the drive */
    BYTE *buff,        /* Data buffer to store read data */
    DWORD sector,    /* Start sector in LBA */
    UINT count        /* Number of sectors to read */
)
{
    disc_read_sector_lba(current_fat_handle, sector, count, buff);

    return RES_OK;
}


DRESULT disk_write (
    BYTE pdrv,            /* Physical drive number to identify the drive */
    const BYTE *buff,    /* Data to be written */
    DWORD sector,        /* Start sector in LBA */
    UINT count            /* Number of sectors to write */
)
{
    disc_write_sector_lba(current_fat_handle, sector, count, buff);

    return RES_OK;
}

DRESULT disk_ioctl (
    BYTE pdrv,        /* Physical drive number (0..) */
    BYTE cmd,        /* Control code */
    void *buff        /* Buffer to send/receive control data */
)
{
    int    val;
    switch ( cmd ) {
    case GET_SECTOR_COUNT:
        val = disc_get_sector_count(current_fat_handle);
        *(DWORD *)buff = val;
        break;

    case GET_SECTOR_SIZE:
    case GET_BLOCK_SIZE:
        val = disc_get_sector_size(current_fat_handle);
        *(WORD *)buff = val;
        break;
    }
    return RES_OK;
}
