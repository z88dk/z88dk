
/*
 * hdos.c — Appmake module to create 100K HDOS disk images
 *
 * Stefano Bodrato - 2026
 *
 * Disk format:
 *   - 40 tracks × 10 sectors × 256 B = 102400 B
 *   - HDOS expects sectors 0–8 = boot, and sector 9 = label (describing the logical disk deployment)
 *
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *disc_image   = NULL;
static char             *disc_container    = "h17";
static int               origin       = -1;
static char              dumb         = 0;
static char              help         = 0;



/* Options that are available for this module */
option_t hdos_options[] = {
    { 'h', "help",     "Display this help",           OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",          OPT_STR,   &binname },
    {  0,  "dumb",     "Do not add the ABS file header",  OPT_BOOL,  &dumb },
    {  0 , "org",      "Origin of the binary",        OPT_INT,   &origin },
    { 'c', "crt0file", "crt0 file used in linking",   OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",         OPT_STR,   &outfile },
    {  0,  "container", "Type of container (imd,dsk)", OPT_STR,  &disc_container },
    {  0,  "image",    "Custom .H8D base image",      OPT_STR,   &disc_image },
    {  0 ,  NULL,       NULL,                         OPT_NONE,  NULL }
};



#define SPT            10
#define SECTOR_SIZE    256
#define GROUP_SIZE     512     // SECTOR_SIZE * GROUP_FACTOR
#define DIR_ENTRY_LEN  23


/* NOTE: volume_ser is hardcoded to 0
  This same value is hardcoded in "disc_write_h17", in cpmdisk.c.
  TODO: workaround for disc_write_sector to accept volume_ser >0 in RAW mode */
static unsigned int   volume_ser   = 0;
static uint8_t        sec[SECTOR_SIZE];
static uint8_t        blk[GROUP_SIZE];

typedef struct {
    uint8_t ser;
    uint16_t ind, dis, grt, rgt, siz;
    uint8_t spg, vlt, ver, vfl, spt;
    char lab[61];
} HDOS_Label;

typedef struct {
    char name[9], ext[4];
    uint8_t project, version, cluster_factor, flags;
    uint8_t fgn, lgn, lsi;
    uint16_t crd, ald;
} HDOS_DirEntry;



/* HDOS 1.6 skeleton */

/* interleaved directory chain (byte approximation) */
static const uint8_t il_ptr1[] = {
    0xDC, 0xDE, 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC
};
static const uint8_t il_ptr2[] = {
    0xE0, 0xE2, 0xE4, 0xDC, 0xE8, 0xEA, 0xEC, 0x00, 0xE6
};

unsigned char hdos_16[]={

    // LABEL
    0x09,
    0x00, 0x4f, 0x14, 0xde, 0x00, 0xee, 0x00, 0x02, 0x01, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x5a, 0x38, 0x38, 0x44, 0x4b, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
    0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
    0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
    0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00, 0x20,
    0x20, 0x20, 0x20, 0x20, 0x0d, 0x0a, 0x53, 0x59, 0x53, 0x54, 0x45, 0x4d, 0x20, 0x43, 0x4f, 0x50,
    0x59, 0x52, 0x49, 0x47, 0x48, 0x54, 0x20, 0x48, 0x45, 0x41, 0x54, 0x48, 0x20, 0x43, 0x4f, 0x2e,
    0x2c, 0x20, 0x31, 0x30, 0x2f, 0x31, 0x39, 0x37, 0x37, 0x2c, 0x20, 0x37, 0x39, 0x2f, 0x34, 0x0d,
    0x0a, 0x20, 0x42, 0x59, 0x20, 0x4a, 0x47, 0x4c, 0x2c, 0x20, 0x31, 0x30, 0x2f, 0x31, 0x39, 0x37,
    0x37, 0x2f, 0x67, 0x63, 0x20, 0x28, 0x67, 0x68, 0x74, 0x20, 0x28, 0x43, 0x29, 0x20, 0x48, 0x45,
    0x41, 0x54, 0x48, 0x20, 0x43, 0x4f, 0x2e, 0x2c, 0x20, 0x31, 0x39, 0x37, 0x39, 0x0a, 0x20, 0x28,
    0x62, 0x79, 0x20, 0x47, 0x41, 0x43, 0x28, 0x69, 0x6e, 0x20, 0x72, 0x65, 0x6d, 0x65, 0x6d, 0x62,
    0x72, 0x61, 0x6e, 0x63, 0x65, 0x20, 0x6f, 0x66, 0x20, 0x4a, 0x47, 0x4c, 0x29, 0x29, 0x0a, 0x0a,
    0x04, 0x0a, 0x0a, 0x43, 0x6f, 0x70, 0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x20, 0x28, 0x43, 0x29,
    0x20, 0x48, 0x45, 0x41, 0x54, 0x48, 0x20, 0x43, 0x4f, 0x2e, 0x2c, 0x20, 0x31, 0x39, 0x37, 0x39,
    0x0a, 0x20, 0x28, 0x62, 0x79, 0x20, 0x47, 0x41, 0x43, 0x28, 0x69, 0x6e, 0x20, 0x72, 0x65, 0x6d,

    // DIRECTORY ENTRIES FOR: RGT.SYS, GRT.SYS, DIRECT.SYS
    0xe3,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x52, 0x47,
    0x54, 0x00, 0x00, 0x00, 0x00, 0x00, 0x53, 0x59, 0x53, 0x00, 0x00, 0x00, 0xf0, 0x00, 0x05, 0x05,
    0x01, 0x4f, 0x14, 0x4f, 0x14, 0x47, 0x52, 0x54, 0x00, 0x00, 0x00, 0x00, 0x00, 0x53, 0x59, 0x53,
    0x00, 0x00, 0x00, 0xf0, 0x00, 0x77, 0x77, 0x01, 0x4f, 0x14, 0x4f, 0x14, 0x44, 0x49, 0x52, 0x45,
    0x43, 0x54, 0x00, 0x00, 0x53, 0x59, 0x53, 0x00, 0x00, 0x00, 0xe0, 0x00, 0x6f, 0x75, 0x02, 0x4f,
    0x14, 0x4f, 0x14, 0xfe, 0x47, 0x41, 0x43, 0x20, 0x2f, 0x20, 0x48, 0x45, 0x41, 0x54, 0x48, 0x20,
    0x43, 0x4f, 0x2e, 0x72, 0x61, 0x6e, 0x63, 0x65, 0x20, 0x6f, 0x00, 0x17, 0xe2, 0x00, 0xdc, 0x00,

	// CHARMAP
    0xee,
    0x9a, 0x00, 0xff, 0xff, 0xff, 0x00, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
    0x11, 0x12, 0x13, 0x14, 0xc7, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20,
    0x21, 0x06, 0x23, 0x24, 0x25, 0x26, 0x15, 0x2d, 0x29, 0x2a, 0x2b, 0x2c, 0x22, 0x2e, 0xc4, 0x39,
    0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x9b, 0x3a, 0x27, 0x42, 0x3d, 0x3e, 0x3f, 0x40,
    0x41, 0x30, 0x43, 0xc2, 0x45, 0x46, 0x47, 0x48, 0xa6, 0x4a, 0x4b, 0xc3, 0x4d, 0xa7, 0x4f, 0x5a,
    0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x4c, 0xc6, 0x83, 0x5d, 0x5e, 0x5f, 0x60,
    0x61, 0x62, 0x63, 0xaf, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x78, 0x70, 0x71,
    0x72, 0x6e, 0x74, 0x75, 0x76, 0x00, 0x73, 0x00, 0x79, 0x7a, 0x7b, 0x5c, 0x7d, 0x7e, 0x7f, 0x80,
    0x81, 0x82, 0xbb, 0x4e, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0x90,
    0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x7c, 0x5b, 0x99, 0x28, 0x9d, 0x9e, 0x9f, 0xa0,
    0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0x84, 0x3c, 0x44, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0x9c, 0x50,
    0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xa8, 0x64, 0xbd, 0xbe, 0xbf, 0xc0,
    0xc1, 0xb0, 0x2f, 0x3b, 0xc5, 0xbc, 0x49, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
    
    // LIST TERMINATION
    0xff

    };


static uint16_t u16le(const uint8_t *p) { return p[0] | (p[1] << 8); }
static void w16le(uint8_t *p, uint16_t v) { p[0] = v & 0xFF; p[1] = v >> 8; }


/*
 * Encode date into 2-byte timestamp format:
 *
 *   Input constraints (not enforced):
 *     day   = 1..31
 *     month = 1..12
 *     year  = >= 1970
 *
 *   Encoding:
 *     B1 bits 0..4  -> day
 *     B1 bits 5..7  -> month low 3 bits
 *
 *     B2 bit 0      -> month high bit (month bit 3)
 *     B2 bits 1..7  -> (year - 1970)
 */

typedef struct {
    uint8_t B1;
    uint8_t B2;
} EncodedTimestamp;

EncodedTimestamp encode_timestamp(int day, int month, int year)
{
    EncodedTimestamp e;

    int year_offset = year - 1970;
    int month_low3  = month & 0x07;   // lower 3 bits of month
    int month_high1 = (month >> 3) & 0x01; // MSB of month (bit 3)

    e.B1 = (day & 0x1F) | (month_low3 << 5);
    e.B2 = (month_high1) | (year_offset << 1);

    return e;
}


static void write_sector(disc_handle *h, int lsn, const uint8_t *buf)
{
    int track = lsn / SPT;
    int sector = lsn % SPT;
    /* H-17 rule: track 0 (LSN 0..9) has header serial = 0; others use lab.ser */
    int hdr_serial = (lsn >= 10) ? volume_ser : 0;
    /* For H8D this 4th argument is ignored (no headers in file), but for IMD/H17
       writers it lets them compute the correct header+checksums. */
    disc_write_sector(h, track, sector, hdr_serial, buf);
}


static void read_sector(disc_handle *h, int lsn, uint8_t *buf)
{
    int track = lsn / SPT;
    int sector = lsn % SPT;
    disc_read_sector(h, track, sector, 0, buf);
}


// Insert file into disk image
static int insert_file(disc_handle *h, FILE *in, HDOS_Label lab, uint8_t *grt, const char *filename, int abs_addr, int len)
{

    int sectors_needed = (int)((len + SECTOR_SIZE - 1) / SECTOR_SIZE);
    int groups_needed  = (sectors_needed + lab.spg - 1) / lab.spg;

    // Collect free groups (from free chain head at grt[0])
    int free_groups[200], free_count = 0;
    int gcur = grt[0];
    while (gcur != 0 && free_count < 200) {
        free_groups[free_count++] = gcur;
        gcur = grt[gcur];
    }
    if (free_count < groups_needed) {
        fclose(in);
        exit_log(1,"Not enough space\n");
    }

    // Allocate: link the chosen groups together and terminate with 0
    int fgn = free_groups[0];
    int lgn = free_groups[groups_needed - 1];
    for (int i = 0; i < groups_needed - 1; ++i)
        grt[free_groups[i]] = (uint8_t)free_groups[i + 1];
    grt[free_groups[groups_needed - 1]] = 0;

    // Advance free chain head beyond the allocated run
    grt[0] = (free_count > groups_needed) ? (uint8_t)free_groups[groups_needed] : 0;

    // Write file data into allocated groups
    int written = 0;

    for (int g = 0; g < groups_needed; ++g) {
        int gnum = free_groups[g];  // actual group number we allocated
        for (int s = 0; s < lab.spg; ++s) {

            size_t r = 0;

            if ((!dumb) && g == 0 && s == 0) {
                // First sector: build ABS header + payload prefix
                // ABS header: 0xFF,0x00, then three big-endian words (load, length, entry)
                memset(sec, 0, sizeof(sec));
                sec[0] = 0xFF; sec[1] = 0x00;
                w16le(sec + 2, (uint16_t)abs_addr);
                w16le(sec + 4, (uint16_t)(len - 8));  // payload byte count (no header)
                w16le(sec + 6, (uint16_t)abs_addr);
                r = fread(sec + 8, 1, SECTOR_SIZE - 8, in);     // may be 0..(SECTOR_SIZE-8)
                // If r < SECTOR_SIZE-8, secfer tail is already zeroed by memset above
            } else {
                r = fread(sec, 1, SECTOR_SIZE, in);             // may be 0..SECTOR_SIZE
                if (r < SECTOR_SIZE) memset(sec + r, 0, SECTOR_SIZE - r);
            }

            // Always write this sector if it's part of the logical size we computed
            int sector_num = (gnum * lab.spg) + s; // group g -> sectors [g*spg .. g*spg+(spg-1)]
            write_sector(h, sector_num, sec);
            written++;

            // Stop once we've written all needed sectors (handles exact fit)
            if (written >= sectors_needed)
                break;
        }
        if (written >= sectors_needed)
            break;
    }

    // Update directory: first empty slot
    int next_sector = lab.dis;
    while (next_sector != 0) {
        read_sector(h, next_sector, blk);  
        read_sector(h, next_sector + 1, blk + 256);

        for (int i = 0; i < 22; ++i) {
            int off = i * 23;
            if (off + 23 > 506) break;

            if ((blk[off] == 0xFE)||(blk[off] == 0xFF)||(blk[off] == 0x00)) {
                // printf("Identified Directory slot at offset %u\n",off);
                // Prepare NAME.EXT in 8.3 uppercase
                memset(blk + off, 0, 23);
				// cpm_create_filename() could probably replace the next lines
				// --------------
                char name8[8] = {0}, ext3[3] = {0};
                const char *dot = strchr(filename, '.');
                if (dot) {
                    size_t base_len = (size_t)(dot - filename);
                    if (base_len > 8) base_len = 8;
                    memcpy(name8, filename, base_len);
                    memcpy(ext3, dot + 1, 3);
                } else {
                    memcpy(name8, filename, 8);
                }
				// --------------
                memcpy(blk + off,     name8, 8);
                memcpy(blk + off + 8, ext3,  3);

                // Uppercase name + ext (do not clobber outer loop index!)
                for (int j = 0; j < 11; ++j) {
                    blk[off + j] = (uint8_t)toupper((unsigned char)blk[off + j]);
                }
                
                // Optionally set flags/project/version/cluster_factor              
                blk[off + 13] = lab.spg+1;    // cluster factor (+1 as seen in the wild)
                blk[off + 14] = 0x00;         // flags, e.g. 0x20 = WR protect

                // Fill in chain info
                blk[off + 16] = (uint8_t)fgn;                           // first group
                blk[off + 17] = (uint8_t)lgn;                           // last group
                blk[off + 18] = (uint8_t)((sectors_needed - 1) % lab.spg); // last sector index in last group

                // Put z88dk signature in the file timestamp
                EncodedTimestamp ts = encode_timestamp(1, 1, 1988);
                blk[off + 19] = blk[off + 21] = ts.B1;
                blk[off + 20] = blk[off + 22] = ts.B2;

                write_sector(h, next_sector,     blk);
                write_sector(h, next_sector + 1, blk + 256);

                // Persist GRT
                write_sector(h, lab.grt, grt);

                // printf("Inserted %s (%d bytes)\n", filename, len);
                return 0;
            }
        }
        next_sector = u16le(blk + 510);
    }

    exit_log(1,"No free directory slot\n");
}




// ================================================================

/* Heath/Zenith HDOS */
int hdos_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    prgname[FILENAME_MAX+1];
    int     pos,len;
    FILE    *fp,*rfp;
	long rsize;
    int     i,j,k;
    disc_handle   *h;
    const char    *extension;
    uint8_t s[SECTOR_SIZE];
    HDOS_Label lab;


    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    disc_writer_func writer = disc_get_writer(disc_container, &extension);

    if (writer == NULL) {
        exit_log(1,"Invalid container specified <%s>\n",disc_container);
    }

    strcpy(filename, binname);
    if ( ( fp = fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Cannot open input binary file <%s>\n",binname);
    }
    

    if (fseek(fp, 0, SEEK_END)) {
        fclose(fp);
        exit_log(1,"Couldn't determine size of file\n");
    }
    len = ftell(fp);
    fseek(fp, 0L, SEEK_SET);
    
    if (!dumb) {
        len+=8;
        if (origin != -1) {
            pos = origin;
        } else {
            if ((pos = get_org_addr(crtfile)) == -1) {
                exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
            }
        }
    }

    if (outfile == NULL) {
        strcpy(prgname, binname);
    } else {
        strcpy(prgname, outfile);
    }
    if (!dumb)
        suffix_change(prgname, ".ABS");
    
    //uint8_t *img = (uint8_t*)must_malloc(IMAGE_SIZE);
    h = cpm_create_with_format("hz89");

    /* Hack the CP/M disk image to make it HDOS friendly */
    c_linear = 1;


	/***********************/
	/* 100K H8D disk image */
	/***********************/

    if (disc_image) {

		/* Load an external raw H8D image (40 tracks × 10 sectors × 256 B = 102400 B) */

		rfp = fopen(disc_image, "rb");
		if (!rfp) {
			exit_log(1, "Cannot open the reference disk image <%s>\n", disc_image);
		}

		if (fseek(rfp, 0, SEEK_END) != 0) {
			fclose(rfp);
			exit_log(1, "Couldn't determine size of reference image\n");
		}

		rsize = ftell(rfp);
		if (rsize != (long)(40 * SPT * SECTOR_SIZE)) {
			fclose(rfp);
			exit_log(1,
				"Invalid H8D size for <%s>: expected 102400 bytes, got %ld\n",
				disc_image, rsize);
		}

		fseek(rfp, 0, SEEK_SET);

		/* Ingest the raw sectors into our in-memory disc handle */
		for (int i = 0; i < (40 * SPT); ++i) {
			fread(sec, 1, SECTOR_SIZE, rfp);
			write_sector(h, i, sec);
		}
		fclose(rfp);

    } else {

		/* Generate a simplified HDOS 1.6 skeleton */

        k = 0;
        // By default we set up an empty, formatted disk in HDOS 1.6 style
        for (i = 0; i < 9; ++i) {
            memset(blk, 0x00, GROUP_SIZE);
            for (j = 0; j < GROUP_SIZE; j += DIR_ENTRY_LEN) {
              if (j >= GROUP_SIZE - 5) break;
              blk[j] = 0xFE + (i&1);   // even sectors use 0xFE, odd sectors have 0xff in the dump
            }
            // Footer (block trailer), 16-bit directory chain pointers from interleaving tables
            blk[GROUP_SIZE - 6] = 0x00;
            blk[GROUP_SIZE - 5] = 0x17;
            blk[GROUP_SIZE - 4] = il_ptr1[k];
            blk[GROUP_SIZE - 3] = 0x00;
            blk[GROUP_SIZE - 2] = il_ptr2[k];
            blk[GROUP_SIZE - 1] = 0x00;

            // Write the 2 sectors belonging to this 512-byte block
            write_sector(h, 0xdc + i * 2,  blk);        // first 256 bytes
            write_sector(h, 0xdd + i * 2,  blk + 256);  // second 256 bytes

            k = (k + 1) % 9;
        }

        // Get some of the HDOS 1.6 disk sectors from a preloaded list
        const uint8_t* p   = hdos_16;
        while (p < hdos_16 + sizeof(hdos_16)) {
            uint8_t lsn = *p++;            // 1-byte header = absolute LSN
            if (lsn == 0xFF) break;        // terminator ?  -> exit loop
            write_sector(h, (int)lsn, p);  // Write the 256-byte sector at the requested LSN
            p += SECTOR_SIZE;
        }

		// Generate "fingerprint" sector
        memset(sec, 1, sizeof(sec));
		memset(sec + 200, 0xFF, 56); 
		sec[0]=sec[1]=0;
		sec[2]=sec[3]=sec[4]=0xff;
		write_sector(h, 0x0a, sec);

    }


    /***********************************************************/
    /*  Now pick the label and get the HDOS format parameters  */
    /*  from the disk image we now have in memory              */
    /***********************************************************/

    read_sector(h,9,s);

    lab.ser = s[0];
    lab.ind = u16le(s+1);
    lab.dis = u16le(s+3);
    lab.grt = u16le(s+5);
    lab.spg = s[7];
    lab.vlt = s[8];
    lab.ver = s[9];
    lab.rgt = u16le(s+10);
    lab.siz = u16le(s+12);
    lab.vfl = s[16];
    memcpy(lab.lab, s+17, 60);
    lab.lab[60] = '\0';
    lab.spt = s[79];

    uint8_t grt_sector[SECTOR_SIZE];
    read_sector(h,lab.grt,grt_sector);


    /************************************/
    /* Disk structure parameters ready, */
    /* Time to add the new file         */
    /************************************/

    insert_file(h, fp, lab, grt_sector, prgname, pos, len);
    fclose (fp);

    /* Write disk image */
    if (strcmp(disc_container,"raw") == 0)
        suffix_change(filename, ".h8d");
    else
        suffix_change(filename, extension);

    if (writer(h, filename) < 0) {
        exit_log(1, "Can't write disc image\n");
    }

    return 0;
}

