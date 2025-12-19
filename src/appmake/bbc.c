/*
 *	BBC Micro disc generator
 *  Stefano Bodrato, December 2025
 *
 */

#include "appmake.h"


static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              torch        = 0;
static char              help         = 0;

unsigned char    *bbc_buf = NULL;
char             *bbc_allocated = NULL;
FILE             *bbc_fpin;
char             bbc_filename[20];


/* Options that are available for this module */
option_t bbc_options[] = {
    { 'h', "help",     "Display this help",           OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",          OPT_STR,   &binname },
    {  0 , "org",      "Origin of the binary",        OPT_INT,   &origin },
    { 'c', "crt0file", "crt0 file used in linking",   OPT_STR,   &crtfile },
    {  0 , "torch",    "Generate a Torch disk image", OPT_BOOL,  &torch},
    { 'o', "output",   "Name of output file",         OPT_STR,   &outfile },
    {  0 ,  NULL,       NULL,                         OPT_NONE,  NULL }
};


// **************************************************************************************
//                              Torch related functions
// **************************************************************************************
   
#define SECTOR_SIZE 256
#define IMG_SIZE    409600  // 400K

// Layout ranges
#define LOG_DIR_S1_START 0x0000
#define LOG_DIR_S1_END   0x0009
#define LOG_DIR_S2_START 0x0010
#define LOG_DIR_S2_END   0x0015
#define LOG_ALLOC_START  0x0016
#define LOG_ALLOC_END    0x0017
#define LOG_TEST_PATTERN 0x0018
#define LOG_OTHER_INFO   0x0019
#define LOG_DATA_START   0x0020

// max logical sector index (16 logical sectors per track, 80 tracks, 2 sides)
#define MAX_LOGICAL_SECTOR 2559  // 16*80*2 - 1


static void wr16le(uint8_t *p, uint16_t i)
{
    p[0] = (uint8_t)(i%256);
    p[1] = (uint8_t)(i/256);
}


// Logical -> physical offset. Returns -1 for non-existent logical sectors (A–F) or out of range.
static long logical_sector_to_offset(uint16_t logical_sector)
{
    int track  = logical_sector / 32;
    int rem    = logical_sector % 32;
    int side   = rem / 16;        // 0 or 1
    int sector = rem % 16;        // 0..15 (10..15 will be missing)

    if (track < 0 || track >= 80) return -1;  // capaciry overflow
    if (sector >= 10)             return -1;  // logical A–F -> no physical sector

    long real_linear_sector = (long)(track * 2 + side) * 10L + (long)sector;   // 10 physical sectors/track
    long off = real_linear_sector * SECTOR_SIZE;
    if (off < 0 || off >= IMG_SIZE) return -1;
    return off;
}

static int write_logical_sector(FILE *fp, uint16_t logical_sector, const uint8_t *local_buf)
{
    long off = logical_sector_to_offset(logical_sector);
    if (off < 0) return -1;
    if (fseek(fp, off, SEEK_SET) != 0) return -1;
    size_t wr = fwrite(local_buf, 1, SECTOR_SIZE, fp);
    return (wr == SECTOR_SIZE) ? 0 : -1;
}

// Track allocated logical sectors (we mark both valid and non-existent logical sectors)
static void mark_alloc(uint16_t logical_sector)
{
    if (logical_sector <= MAX_LOGICAL_SECTOR)
        bbc_allocated[logical_sector] = TRUE;
}

// Return next free, valid data logical sector starting at 'start' (>= LOG_DATA_START).
// Skips A–F (10..15) and already allocated sectors.
static int next_free_sector(uint16_t start)
{
    for (uint16_t s = start; s <= MAX_LOGICAL_SECTOR; ++s) {
        int rem    = s % 32;               // track  = s / 32
        int sector = rem % 16;
        if (sector >= 10) continue;        // A–F (non-existent)
        if (bbc_allocated[s]) continue;    // already reserved

        return s;                          // ok
    }
    return -1; // no sectors left
}

// Write a single directory sector image (first entry + end-of-dir) 
// and replicate across all dir sectors (quick and dirty)
static int write_directory(FILE *img, uint16_t block_word, uint16_t highest_rec, uint8_t user)
{
    // Set up a directory sector with 16 entries (the used one + directory end + nulls)
    uint8_t sector[SECTOR_SIZE];
    memset(sector, 0x00, sizeof(sector));

    // Entry 0
    wr16le(&sector[0],  block_word);
    wr16le(&sector[2],  highest_rec);
    sector[4] = user;

    // 8 char name + 3 char ext, bit7 = attributes (left to 0)
    for (int i = 0; i < 11; i++) sector[5 + i]  = (uint8_t)(bbc_filename[i] & 0x7F);
    // Bit7 in extension chars could be used for R/O, SYS, Execute-only flags; we leave them clear.

    // Entry 1: end of directory (&0000)
    wr16le(&sector[16 + 0], 0x0000);
    wr16le(&sector[16 + 2], 0x0000);
    sector[16 + 4] = 0x00;

    // Write all accessible directory sectors (&0000..&0009, &0010..&0015)
    for (uint16_t s = LOG_DIR_S1_START; s <= LOG_DIR_S1_END; ++s) {
        if (write_logical_sector(img, s, sector) == 0) mark_alloc(s);
    }
    for (uint16_t s = LOG_DIR_S2_START; s <= LOG_DIR_S2_END; ++s) {
        if (write_logical_sector(img, s, sector) == 0) mark_alloc(s);
    }
    return 0;
}

// Write Test Pattern (@0x0018) and Other Info (@0x0019)
static void write_misc(FILE *img)
{
    // Test pattern: D6..FF then 00..D5 (achieved by (0xD6 + i) mod 256 for i=0..255)
    uint8_t test[SECTOR_SIZE];
    for (int i = 0; i < 256; ++i) {
        test[i] = (uint8_t)((0xD6 + i) & 0xFF);
    }
    write_logical_sector(img, LOG_TEST_PATTERN, test);
    mark_alloc(LOG_TEST_PATTERN);

    // Other Info: zeros with byte FE set to non-zero
    uint8_t other[SECTOR_SIZE] = {0};
    other[0xFE] = 0x01; // valore non-zero
    write_logical_sector(img, LOG_OTHER_INFO, other);
    mark_alloc(LOG_OTHER_INFO);
}

// Write Allocation Map into 0x0016–0x0017 (256 words, 16 bits each)
static int write_allocation_map(FILE *img)
{
    // 256 words => 512 bytes in 2 sectors
    uint16_t map[256];
    memset(map, 0, sizeof(map));

    // For every word (block of 16 logical sectors), bits 10..15 (A–F) must be set
    for (int w = 0; w < 256; ++w) {
        map[w] |= 0xFC00; // bit 10..15 = 1
    }

    // Mark allocated logical sectors
    for (uint16_t s = 0; s <= MAX_LOGICAL_SECTOR; ++s) {
        if (!bbc_allocated[s]) continue;
        uint16_t widx = s / 16;
        uint16_t bit  = s % 16;
        if (widx < 256) {
            map[widx] |= (uint16_t)(1u << bit);
        }
    }

    // Serialize to two sectors (LE)
    for (int i = 0; i < 256; ++i) {
        wr16le(&bbc_buf[i * 2], map[i]);
    }

    // Write two sectors
    uint8_t sec0[SECTOR_SIZE], sec1[SECTOR_SIZE];
    memcpy(sec0, bbc_buf, SECTOR_SIZE);
    memcpy(sec1, bbc_buf + SECTOR_SIZE, SECTOR_SIZE);

    if (write_logical_sector(img, LOG_ALLOC_START, sec0) != 0) return -1;
    if (write_logical_sector(img, LOG_ALLOC_END,   sec1) != 0) return -1;
    mark_alloc(LOG_ALLOC_START);
    mark_alloc(LOG_ALLOC_END);
    return 0;
}

// Write file records into data sectors, populate L3/L2, and return:
// - directory's block_word
// - number of data sectors used (for reporting)
static int write_file_Lx(FILE *img,
                         uint16_t total_records,
                         uint16_t *out_block_word,
                         uint16_t *out_data_sectors)
{
    *out_data_sectors = 0;

    // Direct L3 if <= 256 records
    if (total_records <= 256) {
        int l3 = next_free_sector(LOG_DATA_START);
        if (l3 < 0) return -1;
        uint16_t l3_sec = (uint16_t)l3;
        uint8_t  l3buf[SECTOR_SIZE];
        memset(l3buf, 0, sizeof(l3buf));
        mark_alloc(l3_sec);

        uint16_t total_pairs = (total_records + 1) / 2;
        uint8_t  databuf[SECTOR_SIZE];

        // Read loop
        for (uint16_t p = 0; p < total_pairs; ++p) {
            // Determine whether the two records exist
            uint16_t rec_even = p * 2;
            uint16_t rec_odd  = rec_even + 1;
            char have_even = (rec_even < total_records);
            char have_odd  = (rec_odd  < total_records);

            // If at least one exists, allocate the data sector
            if (have_even || have_odd) {
                int dsec = next_free_sector((uint16_t)(l3_sec + 1));
                if (dsec < 0) return -1;
                uint16_t data_sec = (uint16_t)dsec;
                memset(databuf, 0, sizeof(databuf));

                // Read even record (first 128 bytes)
                if (have_even) {
                    size_t rd = fread(databuf, 1, 128, bbc_fpin);
                    if (rd < 128) memset(databuf + rd, 0, 128 - rd); // zero padding
                }

                // Read odd record (second 128 bytes)
                if (have_odd) {
                    size_t rd = fread(databuf + 128, 1, 128, bbc_fpin);
                    if (rd < 128) memset(databuf + 128 + rd, 0, 128 - rd);
                }

                // Write data sector
                if (write_logical_sector(img, data_sec, databuf) != 0) return -1;
                mark_alloc(data_sec);
                (*out_data_sectors)++;

                // Set up L3: b0-13 = sector, b14/b15 = flag record as written
                uint16_t w = (uint16_t)(data_sec & 0x3FFF);
                if (have_even) w |= 0x4000;
                if (have_odd)  w |= 0x8000;
                wr16le(&l3buf[p * 2], w);
            }
        }

        // Write L3
        if (write_logical_sector(img, l3_sec, l3buf) != 0) return -1;

        // Directory block_word: direct L3 (&0000 + n)
        *out_block_word = (uint16_t)(l3_sec & 0x3FFF);

        return 0;
    }

    // L2 + multiple L3 blocks
    int l2 = next_free_sector(LOG_DATA_START);
    if (l2 < 0) return -1;
    uint16_t l2_sec = (uint16_t)l2;
    uint8_t  l2buf[SECTOR_SIZE];
    memset(l2buf, 0, sizeof(l2buf));
    mark_alloc(l2_sec);

    uint16_t num_l3 = (total_records + 255) / 256;
    uint16_t total_pairs = (total_records + 1) / 2;

    uint16_t cursor = (uint16_t)(l2_sec + 1); // first location after L2

    // On any L3
    for (uint16_t g = 0; g < num_l3; ++g) {
        int l3 = next_free_sector(cursor);
        if (l3 < 0) return -1;
        uint16_t l3_sec = (uint16_t)l3;
        cursor = (uint16_t)(l3_sec + 1);
        mark_alloc(l3_sec);

        // Record L3 in L2
        wr16le(&l2buf[g * 2], l3_sec);

        // Set up L3
        uint8_t l3buf[SECTOR_SIZE];
        memset(l3buf, 0, sizeof(l3buf));

        // How many record couples in this group?
        uint16_t base_pair = g * 128;
        uint16_t pairs_here = (total_pairs > base_pair) ? (total_pairs - base_pair) : 0;
        if (pairs_here > 128) pairs_here = 128;

        // On any record couple
        for (uint16_t pi = 0; pi < pairs_here; ++pi) {
            uint16_t p = base_pair + pi;
            uint16_t rec_even = p * 2;
            uint16_t rec_odd  = rec_even + 1;
            char have_even = (rec_even < total_records);
            char have_odd  = (rec_odd  < total_records);

            if (have_even || have_odd) {
                int dsec = next_free_sector(cursor);
                if (dsec < 0) return -1;
                uint16_t data_sec = (uint16_t)dsec;
                cursor = (uint16_t)(data_sec + 1);

                uint8_t databuf[SECTOR_SIZE];
                memset(databuf, 0, sizeof(databuf));

                // Read the even record
                if (have_even) {
                    size_t rd = fread(databuf, 1, 128, bbc_fpin);
                    if (rd < 128) memset(databuf + rd, 0, 128 - rd);
                }
                // Read the odd record
                if (have_odd) {
                    size_t rd = fread(databuf + 128, 1, 128, bbc_fpin);
                    if (rd < 128) memset(databuf + 128 + rd, 0, 128 - rd);
                }

                if (write_logical_sector(img, data_sec, databuf) != 0) return -1;
                mark_alloc(data_sec);
                (*out_data_sectors)++;

                uint16_t w = (uint16_t)(data_sec & 0x3FFF);
                if (have_even) w |= 0x4000;
                if (have_odd)  w |= 0x8000;
                wr16le(&l3buf[pi * 2], w);
            }
        }

        // Write L3
        if (write_logical_sector(img, l3_sec, l3buf) != 0) return -1;
    }

    // Write L2
    if (write_logical_sector(img, l2_sec, l2buf) != 0) return -1;

    // Directory block_word: L2 (&8000 + n)
    *out_block_word = (uint16_t)(0x8000 | (l2_sec & 0x3FFF));

    return 0;
}

// **************************************************************************************



int bbc_exec(char *target)
{
    char     sector[512] = {0};
    char    filename[FILENAME_MAX+1];
    int     pos, length;

    if ( help )
        return -1;

    if ( binname == NULL ) {
        return -1;
    }

    strcpy(filename, binname);
    if ( ( bbc_fpin = fopen_bin(binname, crtfile) ) == NULL ) {
        exit_log(1,"Cannot open CRT file <%s>\n",binname);
    }

    if (fseek(bbc_fpin, 0, SEEK_END)) {
        fclose(bbc_fpin);
        exit_log(1,"Couldn't determine size of file\n");
    }

    length = ftell(bbc_fpin);
    fseek(bbc_fpin, 0L, SEEK_SET);

    if (origin != -1) {
        pos = origin;
    } else {
        if ((pos = get_org_addr(crtfile)) == -1) {
            exit_log(1,"Could not find parameter CRT_ORG_CODE (not z88dk compiled?)\n");
        }
    }

//                                Torch functions end
// **************************************************************************************


    if (torch) {

// **************************************************************************************
//                             Torch Z80 disk image type
// **************************************************************************************

	bbc_buf = must_malloc(SECTOR_SIZE * 2);
	bbc_allocated = must_malloc(2560);

    uint16_t total_records = ((length + 127) / 128);

    if (total_records == 0) {
        fclose(bbc_fpin);
        exit_log(1,"Input file is empty.\n");
    }

    // Create 400K image filled with zeros
	suffix_change(filename, ".dsd");
    FILE *img = fopen(filename, "wb+");
    if (!img) {
        fclose(bbc_fpin);
        exit_log(1,"Cannot create output_image");
    }

     uint8_t zero[SECTOR_SIZE] = {0};
     for (int i = 0; i < IMG_SIZE / SECTOR_SIZE; ++i) {
         fwrite(zero, 1, SECTOR_SIZE, img);
     }
     fflush(img);

    // Clean allocation map
    memset(bbc_allocated, 0, 2560);

    // Prepare uppercase, padded name/ext
    cpm_create_filename(binname, bbc_filename, 1, 0);

    // Write reserved sectors (test pattern & other info)
    write_misc(img);

    // Write file (data + L2/L3)
    uint16_t  block_word = 0;
    uint16_t  data_sectors = 0;
    if (write_file_Lx(img, total_records, &block_word, &data_sectors) != 0) {
        fclose(img);
        fclose(bbc_fpin);
        exit_log(1,"Error writing file contents.\n");
    }

    // highest_record = total_records - 1
    uint16_t highest_rec = (uint16_t)(total_records - 1);

    // Write directory sectors
    if (write_directory(img, block_word, highest_rec, 0) != 0) {
        fclose(img);
        fclose(bbc_fpin);
        exit_log(1,"Error writing directory.\n");
    }

    // Write allocation map (after all allocations are marked)
    if (write_allocation_map(img) != 0) {
        fclose(img);
        fclose(bbc_fpin);
        exit_log(1,"Error writing allocation map.\n");
    }

    fclose(img);
    fclose(bbc_fpin);

	free(bbc_allocated);
	

// **************************************************************************************

	} else {
	
// **************************************************************************************
//                         Acorn Z80 disk image type (default)
// **************************************************************************************

    disc_handle *h;

		//bbc_buf = must_malloc(((length/256)+1) * 256);

		//if (length != fread(bbc_buf, 1, length, bbc_fpin)) { fclose(bbc_fpin); exit_log(1, "Could not read required data from <%s>\n",binname); }

		fclose(bbc_fpin);

        if ((h = cpm_create_with_format("bbc")) == NULL)
        {
            free(bbc_buf);
            exit_log(1, "Cannot find disc specification\n");
        }

		// TODO: add a 400K file version
		// (in RAW mode it's just doubled in size, filled with filler_byte)
		suffix_change(filename, ".ssd");
        if (disc_write_raw(h, filename) < 0)
        {
            exit_log(1, "Can't write disc image");
        }
		
		//puts(bbc_filename);
		cpm_write_file_to_image("bbc", "raw", filename, binname, crtfile, NULL);

        //free(bbc_buf);

// **************************************************************************************
	}


    return 0;
}

