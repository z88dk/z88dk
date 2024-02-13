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

void disc_write_sector(disc_handle *h, int track, int sector, int head, const void *data)
{
    size_t offset;
    size_t track_length = h->spec.sectors_per_track * h->spec.sector_size;

    if ( h->spec.alternate_sides == 0 ) {
        offset = track_length * track + ((h->spec.inverted_sides ^ head) * track_length * h->spec.tracks);
    } else {
        offset = track_length * ( 2* track + (h->spec.inverted_sides ^ head));
    }

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
    size_t track_length = h->spec.sectors_per_track * h->spec.sector_size;

    if ( h->spec.alternate_sides == 0 ) {
        offset = track_length * track + ((h->spec.inverted_sides ^ head) * track_length * h->spec.tracks);
    } else {
        offset = track_length * ( 2* track + (h->spec.inverted_sides ^ head));
    }

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
    { "imd",        ".imd", "IMD (Imagedisk) format",      disc_write_imd },
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


// Write a raw disk, no headers for tracks etc
int disc_write_raw(disc_handle* h, const char* filename)
{
    size_t offs;
    FILE* fp;
    int i, j, s;
    int track_length = h->spec.sector_size * h->spec.sectors_per_track;

    if ((fp = fopen(filename, "wb")) == NULL) {
        return -1;
    }

    for (i = 0; i < h->spec.tracks; i++) {
        for (s = 0; s < h->spec.sides; s++) {
            if ( h->spec.alternate_sides == 0 ) {
                offs = track_length * i + ((h->spec.inverted_sides ^ s) * track_length * h->spec.tracks);
            } else {
                offs = track_length * ( 2* i + (h->spec.inverted_sides ^ s));
            }
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
    int track_length = h->spec.sector_size * h->spec.sectors_per_track;
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
    memcpy(header, "EXTENDED CPC DSK FILE\r\nDisk-Info\r\n", 34);
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

            if ( h->spec.alternate_sides == 0 ) {
                offs = track_length * i + ((h->spec.inverted_sides ^ s) * track_length * h->spec.tracks);
            } else {
                offs = track_length * ( 2* i + (h->spec.inverted_sides ^ s));
            }
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

            if ( h->spec.alternate_sides == 0 ) {
                offs = track_length * i + ((h->spec.inverted_sides ^ s) * track_length * h->spec.tracks);
            } else {
                offs = track_length * ( 2* i + (h->spec.inverted_sides ^ s));
            }

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
    int track_length = h->spec.sector_size * h->spec.sectors_per_track;


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

            if ( h->spec.alternate_sides == 0 ) {
                offs = track_length * i + ((h->spec.inverted_sides ^ s) * track_length * h->spec.tracks);
            } else {
                offs = track_length * ( 2* i + (h->spec.inverted_sides ^ s));
            }
            for (j = 0; j < h->spec.sectors_per_track; j++) {
                uint8_t header[8] = { 0 };

                // Track header:
                // physical cylinder
                // physical head
                // cylinder
                // head
                // secotr number
                // size code
                // length (little endian) word
                header[0] = i;
                header[1] = s;
                header[2] = i;
                header[3] = s;
				if ( (! h->spec.side2_sector_numbering) || (! s) )
					header[4] = skew_sector(h, j, i) + h->spec.first_sector_offset;
				else
					header[4] = skew_sector(h, j, i) + h->spec.first_sector_offset + h->spec.sectors_per_track ;
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
    int track_length = h->spec.sector_size * h->spec.sectors_per_track;
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
            // At the moment we use "spec.inverted_sides" to trigger an accurete skew map.

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
            if ( h->spec.alternate_sides == 0 ) {
                offs = track_length * i + ((h->spec.inverted_sides ^ s) * track_length * h->spec.tracks);
            } else {
                offs = track_length * ( 2* i + (h->spec.inverted_sides ^ s));
            }
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

static size_t find_first_free_directory_entry(disc_handle* h)
{
    size_t directory_offset = h->spec.offset ? h->spec.offset : (h->spec.boottracks * h->spec.sectors_per_track * h->spec.sector_size * 1);
    int i;

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
    size_t directory_offset = h->spec.offset ? h->spec.offset : (h->spec.boottracks * h->spec.sectors_per_track * h->spec.sector_size * 1);
    memset(h->image +directory_offset, 0xe5, 512);
    return h;
}


static void cpm_write_file(disc_handle* h, char *filename, void* data, size_t len)
{
    size_t num_extents = (len / h->spec.extent_size) + 1;
    size_t directory_offset;
    size_t offset;
    uint8_t direntry[32];
    int i, j, current_extent;
    int extents_per_entry = h->spec.byte_size_extents ? 16 : 8;

    directory_offset = find_first_free_directory_entry(h);
    // Now, write the directory entry, we can start from extent 1
    current_extent = first_free_extent(h);
    // We need to turn that extent into an offset into the disc
    if ( h->spec.offset ) {
        offset = h->spec.offset + (current_extent * h->spec.extent_size);
    } else {
        offset = (h->spec.boottracks * h->spec.sectors_per_track * h->spec.sector_size * 1) + (current_extent * h->spec.extent_size);
    }
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
	BYTE pdrv		/* Physical drive number to identify the drive */
)
{
    return RES_OK;
}

DSTATUS disk_initialize (
	BYTE pdrv				/* Physical drive number to identify the drive */
)
{
    return RES_OK;
}


DRESULT disk_read (
	BYTE pdrv,		/* Physical drive number to identify the drive */
	BYTE *buff,		/* Data buffer to store read data */
	DWORD sector,	/* Start sector in LBA */
	UINT count		/* Number of sectors to read */
)
{
    disc_read_sector_lba(current_fat_handle, sector, count, buff);

    return RES_OK;
}


DRESULT disk_write (
	BYTE pdrv,			/* Physical drive number to identify the drive */
	const BYTE *buff,	/* Data to be written */
	DWORD sector,		/* Start sector in LBA */
	UINT count			/* Number of sectors to write */
)
{
    disc_write_sector_lba(current_fat_handle, sector, count, buff);

    return RES_OK;
}

DRESULT disk_ioctl (
	BYTE pdrv,		/* Physical drive number (0..) */
	BYTE cmd,		/* Control code */
	void *buff		/* Buffer to send/receive control data */
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
