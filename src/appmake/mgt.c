/* MGT Disc Manager
 *
 * Cribbed a bit from mgtman.c
 */

#include "appmake.h"

static char             *c_binary_name       = NULL;
static char             *c_crt_filename      = NULL;
static char             *c_output_file       = NULL;
static char             *c_boot_filename     = NULL;
static char             *c_disc_container    = "raw";
static char              help         = 0;

static void mgt_writefile(disc_handle *h, char *filename, int exec, unsigned char *data, size_t len);


/* Options that are available for this module */
option_t mgt_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &c_binary_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &c_crt_filename },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &c_output_file },
    { 's', "bootfile", "Name of the boot file",      OPT_STR,   &c_boot_filename },
    {  0,  "container", "Type of container (raw,dsk)", OPT_STR, &c_disc_container },
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};

static disc_spec mgt_spec  = {
    .name = "MGT",
    .sectors_per_track = 10,
    .tracks = 80,
    .sides = 2,
    .sector_size = 512,
    .gap3_length = 0x2a,
    .filler_byte = 0x00,
    .boottracks = 0,
    .alternate_sides = 0,
    .first_sector_offset = 1	// Required for .dsk
};


int mgt_exec(char *target)
{
    unsigned char   *buf;
    char    mgt_filename[11];
    char   *ptr;
    char    filename[FILENAME_MAX+1];
    char    bootname[FILENAME_MAX+1];
    FILE    *fpin, *bootstrap_fp;
    disc_handle *h;
    int i;
    long    pos;


    if (help)
        return -1;

    if (c_binary_name == NULL) {
        return -1;
    }
    if (c_disc_container == NULL ) {
        return -1;
    }

    if ( ( fpin = fopen_bin(c_binary_name, c_crt_filename) ) == NULL ) {
        exit_log(1,"Cannot open binary file <%s>\n",c_binary_name);
    }

    if (fseek(fpin, 0, SEEK_END)) {
        fclose(fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    pos = ftell(fpin);
    fseek(fpin, 0L, SEEK_SET);
    buf = must_malloc(pos);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",c_binary_name); }
    fclose(fpin);


    h = disc_create(&mgt_spec);

    // Allow DOS discs to be created - write the autoboot file
    if ( c_boot_filename ) {
        long boot_len;
        unsigned char *boot;

        bootstrap_fp = fopen(c_boot_filename, "r");
        fseek(bootstrap_fp, 0, SEEK_END);
        boot_len = ftell(bootstrap_fp);
        fseek(bootstrap_fp, 0L, SEEK_SET);

        boot = must_malloc(boot_len);
        if (boot_len != fread(boot, 1, boot_len, bootstrap_fp)) { fclose(bootstrap_fp); exit_log(1, "Could not read required data from <%s>\n",c_boot_filename); }
        mgt_writefile(h, "auto.bin  ", 1, boot, boot_len);
        free(boot);
    }


    strcpy(filename, c_binary_name);
    ptr = zbasename(filename);
    // Make mgt_filename from filename to 10 chars with spaces
    for (i = 0; i <= 9; i++) {
        if (i < strlen(ptr)) {
            mgt_filename[i] = ptr[i];
        } else {
            mgt_filename[i] = ' ';
        }
    }
    mgt_filename[10] = 0;

    mgt_writefile(h, mgt_filename, 0, buf, pos);

    suffix_change(filename, ".mgt");
    disc_write_raw(h, filename);

    return 0;
}

static void mgt_writefile(disc_handle *h, char mgt_filename[11], int isexec, unsigned char *data, size_t len)
{
    unsigned char sector[512];
    unsigned char direntry[256];

    unsigned char sectmap[195], usedmap[195];
    int maxdtrack, s, t, e, i, m, a, offs, exists, firstslot;



    // Read in the directory to assemble the bitmap
    exists = 0;
    firstslot = -1;
    disc_read_sector(h, 0, 0, 0, &sector);

    // Get number of directory tracks to scan
    if (sector[255] == 255) {
        maxdtrack = 4;
    } else {
        maxdtrack = 4 + sector[255];
    }

    for (t = 0; t < maxdtrack; t++) {
        for (s = 0; s < 10; s++) {
            disc_read_sector(h, t, s, 0, &sector);
            /* Two directory entries per sector */
            for ( e = 0; e < 2; e++ ) {
                unsigned char *entry = sector + e * 256;
                for (i = 0; i < 195; i++) { // Pre-populate sector map
                    sectmap[i] |= entry[i + 15];
                }
                if ( entry[0] != 0 ) {  /* File not deleted */
                    if ( strncasecmp(mgt_filename,(char *)entry+1,10) == 0  ) {
                        exists = 1;
                    }
                } else if ( firstslot == -1 ) {
                    firstslot = t * 20 + s * 2 + e;
                }
            }
        }
    }

    if ( exists ) {
        exit_log(1, "File <%s> already exists on disc\n",mgt_filename);
    }

    // Mark the directory sectors as allocated
    if (maxdtrack > 4) {
        sectmap[0] &= 254;
        sectmap[1] &= 3;

        if (maxdtrack > 5) {
            a = 1;
            m = 4;

            for (i = 0; i < 10 * (maxdtrack - 4); i++) {
                sectmap[a] &= m;
                m *= 2;
                if (m == 256) {
                    a++;
                    m = 1;
                }
            };
        }
    }

    // Find free space on disc
    int freesectors = 0;
    for ( i = 0; i < 195; i++ ) {
        for ( m = 1; m < 256; m *= 2 ) {
            freesectors += !(sectmap[i] & m);
        }
    }

    if ( len + 9  > (510 * freesectors) ) {
        exit_log(1, "Not enough free space on disc to write file\n");
    }

    // Prepare the directory entry
    memset(direntry, 0, sizeof(direntry));
    memset(sector, 0, sizeof(sector));
    direntry[0] = sector[0] = 19; // SAM code (todo)
    memcpy(direntry+1, mgt_filename, 10);

    i = (len + 9) / 510;  // number of sectors used
    direntry[11] = i / 256;      // MSB sectors used
    direntry[12] = i % 256;      // LSB sectors used
    direntry[13] = 0;            // Start Track
    direntry[14] = 0;            // Start sector
    direntry[220] = 0;           // Flags not set
    
    // Prepare the file header 
    direntry[236] = sector[8] = 1;
    direntry[237] = sector[3] = 0;
    direntry[238] = sector[4] = 128;
    direntry[239] = sector[7] = len / 16384;
    direntry[240] = sector[1] = len % 256;
    direntry[241] = sector[2] = (len % 16384) / 256;

    if (isexec ) {
        direntry[242] = 2; // Page
        direntry[243] = 0; // lsb
        direntry[244] = 128; // msb
    } else {
        direntry[242] = 0xff; // Page
        direntry[243] = 0xff; // lsb
        direntry[244] = 0xff; // msb
    }
    // Clear the map used for this file
    memset(usedmap, 0, 195);

    a = 0;  // Start place in bitmap
    m = 1;  // Bit in bitmap
    t = 4;
    s = 1;
    for ( i = 0,offs = 0; i < ((len + 9) / 510) + 1; i++ ) {
        int t2, s2;
        // Determine next sector (into t2/s2)
        t2 = t;
        s2 = s;

        while ((sectmap[a] & m)) {
            m *= 2;
            if (m == 256) {
                m = 1;
                a++;
            }

            s++;
            if (s == 11) {
                s = 1;
                t++;

                if (t == 80)
                    t = 128;
            }
        }
        usedmap[a] |= m;
        sectmap[a] |= m;

        if ( i != 0 ) {
            // Chain the sectors along
            sector[510] = t;
            sector[511] = s;
            disc_write_sector(h, t2 & 0x7f, s2 - 1, t2 & 0x80, sector);
            memcpy(sector, data + offs, 510);
            offs += 510;
        } else {
            direntry[13] = t;
            direntry[14] = s;
            memcpy(sector + 9, data, 510 - 9);
            offs += 510 - 9;
        }
        sector[510] = sector[511] = 0;
    }
    // Write out the last sector fo the file
    disc_write_sector(h, t & 0x7f, s - 1, t & 0x80, sector);
    // Copy the used sector map into the directory entry
    memcpy(direntry + 15, usedmap, sizeof(usedmap));
    
    // And write the directory entry
    disc_read_sector(h, firstslot / 20, (firstslot/2) % 10,0, sector);
    memcpy(&sector[256 * (firstslot & 1)], direntry, 256);
    disc_write_sector(h, firstslot / 20, (firstslot/2) % 10, 0, sector);
}
