/* MGT Disc Manager
 *
 * Cribbed a bit from mgtman.c
 */

#include "appmake.h"

static char             *c_binary_name       = NULL;
static char             *c_crt_filename      = NULL;
static char             *c_output_file       = NULL;
static char             *c_dos_file          = NULL;
static char             *c_default_dos_file  = NULL;
static char             *c_disc_container    = "raw";
static int               c_origin            = -1;
static char              c_zx_mode           = 0;
static char              c_executable        = 0;
static char              help         = 0;


/* Options that are available for this module */
option_t mgt_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR|OPT_INPUT,   &c_binary_name },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &c_crt_filename },
    { 'o', "output",   "Name of output file",        OPT_STR|OPT_OUTPUT,   &c_output_file },
    {  0,  "default-dosfile",  "Name of the default DOS file",       OPT_STR,   &c_default_dos_file },
    {  0,  "dosfile",  "Name of the DOS file",       OPT_STR,   &c_dos_file },
    {  0,  "container", "Type of container (raw,dsk)", OPT_STR, &c_disc_container },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &c_origin },
    {  0 , "zx",       "Create Spectrum +D discs",   OPT_BOOL,   &c_zx_mode },
    { 'x', "exec",     "Make the file executable",   OPT_BOOL,  &c_executable },
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
    FILE    *fpin, *bootstrap_fp;
    const char *container_extension;
    disc_handle *h;
    int i;
    disc_writer_func writer;
    int     origin;
    long    pos;


    if (help)
        return -1;

    if (c_binary_name == NULL) {
        return -1;
    }
    if (c_disc_container == NULL ) {
        return -1;
    }

    // Get the writer for function for the chosen disc container
    if ( (writer = disc_get_writer(c_disc_container, &container_extension)) == NULL ) {
        exit_log(1,"Cannot file disc container format <%s>\n",c_disc_container);
    }
    
    if ( c_dos_file == NULL ) {
        c_dos_file = c_default_dos_file;
    }


    if ( ( fpin = fopen_bin(c_binary_name, c_crt_filename) ) == NULL ) {
        exit_log(1,"Cannot open binary file <%s>\n",c_binary_name);
    }

    if ( c_origin != -1 ) {
       origin = c_origin;
    } else {
        if ( (origin = get_org_addr(c_crt_filename)) == -1 ) {
            exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
        }
    }
    pos = get_file_size(fpin);

    buf = must_malloc(pos + 512);
    if (pos != fread(buf, 1, pos, fpin)) { fclose(fpin); exit_log(1, "Could not read required data from <%s>\n",c_binary_name); }
    fclose(fpin);


    h = mgt_create();
    bootstrap_fp = NULL;
    if ( c_dos_file ) {
        if ( (bootstrap_fp = fopen(c_dos_file, "rb")) == NULL ) {
            exit_log(1, "Cannot open override DOS file <%s>\n",c_dos_file);
        }
    }

    if ( bootstrap_fp != NULL ) {
        long boot_len;
        unsigned char *boot;

        boot_len = get_file_size(bootstrap_fp);

        boot = must_malloc(boot_len + 512);
        if (boot_len != fread(boot, 1, boot_len, bootstrap_fp)) { fclose(bootstrap_fp); exit_log(1, "Could not read required data from <%s>\n",c_dos_file); }
        if ( c_zx_mode ) {
            mgt_writefile(h, "GDOS      ", MGT_CODE, 8192, 0, boot, boot_len);
        } else {
            mgt_writefile(h, "SAMDOS2   ", MGT_SAM_CODE, 32768, 0, boot, boot_len);
        }
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

    if ( c_zx_mode ) {
        mgt_writefile(h, mgt_filename, MGT_CODE,  origin, c_executable, buf, pos);    
    } else {
        // If the origin is 0, then it's allram mode, but we start executing at
        // 32768 when loaded
        if ( origin == 0 ) origin = 32768;
        mgt_writefile(h, c_executable ? "auto.bin  " : mgt_filename, MGT_SAM_CODE,  origin, c_executable, buf, pos);    
    }    

    if ( strcmp(c_disc_container,"raw") == 0 ) container_extension = ".mgt";

    suffix_change(filename, container_extension );
    writer(h, filename);

    return 0;
}

disc_handle *mgt_create(void) 
{
    return disc_create(&mgt_spec);
}

void mgt_writefile(disc_handle *h, char mgt_filename[11], mgt_filetype filetype, 
                    int org, int isexec, unsigned char *data, size_t len)
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



 

    /* SAMDOS Directory entry
     * 0    = file type
     * 1-10 = filename
     * 11 = msb number sectors used
     * 12 = lsb number sectors used
     * 13 = start track
     * 14 = start sector
     * 15-209 sector map
     * 210-219 = mgtpast and present (not used SAM)
     * 220 = flags (MGT)
     * 221-231 - filetype info
     * 232-235 - spare 4 bytes
     * 236 = start page number
     * 237-238 = pageoffset (8000-bffff)
     * 239 = numberof pages in length
     * 240-241 = module filelength (0-16383)
     * 242-244 = execution address
     * 245-253 = spare 8 bytes
     * 254-255 = reserved
     */

    /* Spectrum
     * 0    = file type
     * 1-10 = filename
     * 11 = msb number sectors used
     * 12 = lsb number sectors used
     * 13 = start track
     * 14 = start sector
     * 15-209 sector map

        BASIC (type 1)
        ---------------
        211      Always 0 (this is the id used in tape header)
        212-213  Length
        214-215  Memory start address ( PROG when loading - usually 23755)
        216-217  Length without variables
        218-219  Autostart line
        NOTE: These 9 bytes are also the first 9 bytes of the file.

        CODE FILE (type 4)
        ------------------
        211      Always 3 (this is the id used in tape header)
        212-213  Length
        214-215  Start address
        216-217  Not used
        218-219  Autorun address (0 if there is no autorun address)

        SCREEN$ (type 7)
        ----------------
        Same as type 4 with Start=16384 and Length=6912
    */

    // Prepare the directory entry
    memset(direntry, 0, sizeof(direntry));
    memset(sector, 0, sizeof(sector));
    direntry[0] = sector[0] = filetype; // SAM code (todo)
    memcpy(direntry+1, mgt_filename, 10);

    i = (len + 9) / 510;  // number of sectors used
    direntry[11] = i / 256;      // MSB sectors used
    direntry[12] = i % 256;      // LSB sectors used
    direntry[13] = 0;            // Start Track
    direntry[14] = 0;            // Start sector
    direntry[220] = 0;           // Flags not set


    /* Disc file header
     *
     * SAM:
     * 0 = file type
     * 1-2 = modulolength
     * 3-4 = offset start
     * 5-6 = unused
     * 7 = number of pages
     * 8 = starting page
     */
    switch (filetype) {
    case MGT_CODE:
    case MGT_SCREEN:
        /*
         *   211      Always 3 (this is the id used in tape header)
         *   212-213  Length
         *   214-315  Start address
         *   216-217  Not used
         *   218-219  Autorun address (0 if there is no autorun address)
         */
        direntry[211] = sector[0] = 3;
        direntry[212] = sector[1] = len % 256;
        direntry[213] = sector[2] = len / 256;
        direntry[214] = sector[3] = org / 256;
        direntry[215] = sector[4] = org / 256;
        if ( isexec ) {
            direntry[218] = sector[7] = org / 256;
            direntry[219] = sector[8] = org / 256;
        }
        break;

    case MGT_SAM_CODE:
        direntry[236] = sector[8] = 1;
        direntry[237] = sector[3] = org % 256;
        direntry[238] = sector[4] = org / 256;
        direntry[239] = sector[7] = len / 16384;
        direntry[240] = sector[1] = len % 256;
        direntry[241] = sector[2] = (len % 16384) / 256;
        if ( isexec ) {
            direntry[242] = 2; // Page
            direntry[243] = org % 256; // lsb
            direntry[244] = org / 256; // msb
        } else {
            direntry[242] = 0xff; // Page
            direntry[243] = 0xff; // lsb
            direntry[244] = 0xff; // msb
        }
        break;
    default:
        exit_log(1, "Unsupported MGT file type %d\n",filetype);
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
