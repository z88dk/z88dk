/*
 * Program to prepend an AMSDOS header to a file so that it can be
 * Transferred onto a .DSK image using standard tools
 * 
 * Dominic Morris - 29/8/2003
 * 
 * Header information taken from cpcfs by Thierry Jouin
 * (http://perso.wanadoo.fr/thierry.jouin/Amstrad/cpcfs.htm)
 * 
 * The cassette format and wav handling code comes from cpc2tape v1.1, written
 * by Pierre Thevenet 27/12/1997
 * 
 */

#include "appmake.h"



static char    *binname = NULL;
static char    *crtfile = NULL;
static char    *outfile = NULL;
static char    *blockname = NULL;
static char    *banked_space = NULL;
static char     audio = 0;
static char     dumb = 0;
static char     loud = 0;
static char     noext = 0;
static char     disk = 0;
static int     origin = -1;
static int     exec = -1;
static char     help = 0;
static int     LOW = 64;
static int     HIGH = 192;
/* Higher values can give better transfer speed */
/* Too high values will give read errors */
static int     rate = 0;     /* Sampling rate of the output file (Hz) */


/* Options that are available for this module */
option_t     cpc_options[] = {
     {'h', "help", "Display this help", OPT_BOOL, &help},
     {'b', "binfile", "Linked binary file", OPT_STR, &binname},
     {'c', "crt0file", "crt0 file used in linking", OPT_STR, &crtfile},
     {'o', "output", "Name of output file", OPT_STR, &outfile},
     {0, "bankspace", "Create custom bank spaces", OPT_STR, &banked_space},
     {0, "disk", "Generate a .dsk image", OPT_BOOL, &disk},
     {0, "audio", "Create also a WAV file", OPT_BOOL, &audio},
     {0, "rate", "Rate/speed (8000, 11025..)", OPT_INT, &rate},
     {0, "dumb", "Just convert to WAV a tape file", OPT_BOOL, &dumb},
     {0, "loud", "Louder audio volume", OPT_BOOL, &loud},
     {0, "noext", "Remove the file extension", OPT_BOOL, &noext},
     {0, "exec", "Location to start execution", OPT_INT, &exec},
     {0, "org", "Origin of the binary", OPT_INT, &origin},
     {0, "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
     {0, NULL, NULL, OPT_NONE, NULL}
};


static int     cpc_checksum(unsigned char *buf, int len);

void          putbit    (FILE * f, unsigned char b, unsigned long int *filesize);
void          putbyte   (FILE * f, unsigned char b, unsigned long int *filesize);
void          putblock  (FILE * f, unsigned char *block, unsigned int size, unsigned long int *filesize);
void          putWavHeader(FILE * f);
void          writesize (FILE * f, unsigned long int size);
void          putCRC    (FILE * f, unsigned int CRC, unsigned long int *filesize);
void          writename (unsigned char *tape_hdr, unsigned char *disc_hdr);
void          putsilence(FILE * f, int length, unsigned long int *filesize);
unsigned int     calcCRC(unsigned char *buffer);
unsigned int     CRCupdate(unsigned int CRC, unsigned char new);


/* Widthes of 0 & 1 bits                                              */
/* I previously used that to control transfer speed, but modifying    */
/* sample rate is far more efficient                                  */

#define W0 1
#define W1 2

#define kCRCpoly  4129

/* Writes a single bit to the file */
void putbit(FILE* f, unsigned char b, unsigned long int* filesize)
{
    int i, l;
    if (b == 0)
        l = W0;
    else
        l = W1;
    *filesize += l * 2; /* Need the file size for the .wav header */
    for (i = 0; i < l; i++) {
        fputc(LOW, f);
    }
    /*
      * The "low" duration should be equal to the "high" one, so that it
      * works even if the wires are inverted.
      */
    for (i = 0; i < l; i++) {
        fputc(HIGH, f);
    }
}

/* Writes a byte to the .wav file */
void putbyte(FILE* f, unsigned char b, unsigned long int* filesize)
{
    int i;

    for (i = 0; i < 8; i++) {
        putbit(f, b & 128, filesize);
        b <<= 1;
    }
}

void putblock(FILE* f, unsigned char* block, unsigned int size, unsigned long int* filesize)
{
    int i;
    for (i = 0; i < size; i++)
        putbyte(f, block[i], filesize);
}

/* Creates the header for the .wav file */
void putWavHeader(FILE* f)
{

    /* Header for .wav files. Dumbly copied from an existent .wav file :) */
    /* (I haven't fully understood how it works :)))                      */

    /*
      * (03/09/97) Kev Thacker provided some help for these .wav files.
      * Thanks to him.
      */

    unsigned char WavHeader[44] = {
        0x52, 0x49, 0x46, 0x46, 0x72, 0xB8, 0x01, 0x00,
        0x57, 0x41, 0x56, 0x45, 0x66, 0x6D, 0x74, 0x20,
        0x10, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
        0x11, 0x2B, 0x00, 0x00, 0x11, 0x2B, 0x00, 0x00,
        0x01, 0x00, 0x08, 0x00, 0x64, 0x61, 0x74, 0x61,
        0x18, 0xB8, 0x01, 0x00
    };

    WavHeader[24] = rate & 0xff;
    WavHeader[25] = (rate >> 8) & 0xff;
    WavHeader[26] = (rate >> 16) & 0xff;
    WavHeader[27] = (rate >> 24) & 0xff;
    WavHeader[28] = rate & 0xff;
    WavHeader[29] = (rate >> 8) & 0xff;
    WavHeader[30] = (rate >> 16) & 0xff;
    WavHeader[31] = (rate >> 24) & 0xff;

    fwrite(WavHeader, 1, 44, f);
}

void writesize(FILE* f, unsigned long int size)
{
    /*
      * This might cause problems on little-endian systems. If so, please
      * let me know.
      */

    unsigned long int s2;
    fseek(f, 40, SEEK_SET);
    fwrite(&size, 4, 1, f);
    fseek(f, 4, SEEK_SET);
    s2 = size + 36; /* I think this is right. Not sure at all. :) */
    fwrite(&s2, 4, 1, f);
}

/*
 * Here are the CRC functions ... Note: I DIDN'T try to understand them ! :)
 */
void putCRC(FILE* f, unsigned int CRC, unsigned long int* filesize)
{
    unsigned char c1, c2;
    c1 = (unsigned char)((CRC & 0xff00) >> 8);
    c2 = (unsigned char)CRC & 0xff;
    putbyte(f, c1, filesize);
    putbyte(f, c2, filesize);
}

unsigned int CRCupdate(unsigned int CRC, unsigned char new)
{
    unsigned int aux = CRC ^ (new << 8);
    int i;

    for (i = 0; i < 8; i++)
        if (aux & 0x8000) {
            aux <<= 1;
            aux ^= kCRCpoly;
        } else {
            aux <<= 1;
        }

    return (aux);
}

unsigned int calcCRC(unsigned char* buffer)
{

    int j;
    unsigned int CRC;

    CRC = 0xFFFF;
    for (j = 0; j < 256; j++)
        CRC = CRCupdate(CRC, buffer[j]);
    CRCupdate(CRC, 0);
    CRCupdate(CRC, 0);

    return ((~CRC) & 0xffff);
}

void writename(unsigned char* tape_hdr, unsigned char* disc_hdr)
{
    /* Processes the CPC file name.          */
    /* Mainly, to manage file extensions ... */
    int i = 0, j = 0;
    while ((disc_hdr[i + 1] != 32) && (i < 8)) {
        tape_hdr[i] = disc_hdr[i + 1];
        i++;
    }
    if (noext) {
        if (disc_hdr[9] != 32) {
            tape_hdr[i] = '.';
            i++;
        } /* File extension present */
        while ((disc_hdr[9 + j] != 32) && (j < 3)) {
            tape_hdr[i] = disc_hdr[9 + j];
            i++;
            j++;
        }
    }
}

void putsilence(FILE* f, int length, unsigned long int* filesize)
{
    int i;
    *filesize += length;
    for (i = 0; i < length; i++)
        fputc(128, f);
}

void dumpSectionInfo(struct section_bin *sb)
{
    printf("bankname : %s\n", sb->section_name);
    printf("filename : %s\n", sb->filename);
    printf("offset   : 0x%04x\n", sb->offset);
    printf("org      : 0x%04x\n", sb->org);
    printf("size     : 0x%04x\n", sb->size);
    printf("================\n");
}

int dumpBankInfo(struct banked_memory *memory)
{
    int bsnum;
    int bank, section;
    int banksFound = 0;

    for (bsnum = 0; bsnum < memory->num; bsnum++)
    {
        for (bank = 0; bank < MAXBANKS; ++bank)
        {
            struct memory_bank *mb = &memory->bankspace[bsnum].membank[bank];

            for (section = 0; section < mb->num; ++section)
            {
                dumpSectionInfo(&mb->secbin[section]);
                banksFound++;
            }
        }
    }
    return (banksFound);
}

void checkBankLimits(struct banked_memory *memory)
{
    int bsnum;
    int bank, section;

    bsnum = mb_find_bankspace(memory, "BANK");

    if (bsnum >= 0)
    {
        for (bank = 0; bank < MAXBANKS; ++bank)
        {
            struct memory_bank *mb = &memory->bankspace[bsnum].membank[bank];

            for (section = 0; section < mb->num; ++section)
            {
                int p;
                struct section_bin *sb = &mb->secbin[section];

                p = sb->org & 0x3fff;

                if ((p + sb->size) > 0x4000)
                {
                    exit_log(1, "Section %s exceeds 16k boundary by %d bytes\n", sb->section_name, p + sb->size - 0x4000);
                }
            }
        }
    }
}

// Layout a cpc file
// \param inbuf The input buffer containing the file
// \param fileName File name for CPM header
// \param filelen Number of bytes to read
// \param file_type Spectrum file type
// \param total_len How long the returned block is
// \return Allocated buffer containing the whole file (should be freed)
uint8_t *cpc_layout_file(uint8_t *inbuf, char *fileName, size_t filelen, int start_address, int file_type, size_t *total_len_ptr)
{
    uint8_t *buf = must_malloc(filelen + 128);
    int cksum, i;
    size_t total_len = 0;

    // Setup an AMSDOS header
    memset(buf, 0, 128);

    // Add file name. Should be in CPM format
    for (i = 0; i < 11; i++)
        buf[i + 1] = toupper(fileName[i]);

    // 0:BASIC 1:Protected 2:Binary
    // ASCII files don't have headers but a fake header is built in
    // memory with the file type #16, "Unprotected ASCII v1")
    buf[0x12] = file_type;
    buf[0x15] = start_address % 256;
    buf[0x16] = start_address / 256;

    buf[0x18] = filelen % 256;
    buf[0x19] = filelen / 256;

    buf[0x1A] = start_address % 256;
    buf[0x1B] = start_address / 256;

    buf[0x40] = filelen % 256;
    buf[0x41] = filelen / 256;

    cksum = cpc_checksum(buf, 0x42);

    buf[0x43] = cksum % 256;
    buf[0x44] = cksum / 256;

    while (total_len < filelen)
    {
        buf[128 + total_len] = inbuf[total_len];
        total_len++;
    }

    // Add the length of the file header
    total_len += 128;

    *total_len_ptr = total_len;

    return buf;
}

int cpc_exec(char* target)
{
    struct banked_memory memory;
    struct aligned_data aligned;
    FILE *fmap;
    char crtname[FILENAME_MAX + 1];
    uint8_t *inFileBuff;
    uint8_t *outFileBuff;
    char cpm_filename[20];
    size_t file_len;
    char filename[FILENAME_MAX + 1];
    char wavfile[FILENAME_MAX + 1];
    FILE *fpin, *fpout;
    long pos;
    int i;
    FILE *f, *source;
    unsigned char header[256];
    unsigned char srchead[128];
    unsigned char srcdata[2048];
    unsigned long int filesize = 0;
    unsigned int size;
    unsigned int blocks;
    unsigned int currentblock = 1;
    int j, ret;
    size_t binary_length;
    int nchunks;

    ret = -1;

    if (help)
        return ret;

    if (binname == NULL)
    {
        return ret;
    }

    if (crtfile == NULL)
    {
        snprintf(crtname, sizeof(crtname) - 4, "%s", binname);
        suffix_change(crtname, "");
        crtfile = crtname;
    }

    memset(&aligned, 0, sizeof(aligned));
    memset(&memory, 0, sizeof(memory));
    mb_create_bankspace(&memory, "BANK"); // bank space 0

    if (banked_space != NULL)
    {
        char *s;

        for (s = strtok(banked_space, " \t\n"); s != NULL; s = strtok(NULL, " \t\n"))
        {
            printf("Creating bank space %s\n", s);
            mb_create_bankspace(&memory, s);
        }
    }

    snprintf(filename, sizeof(filename) - 4, "%s", crtfile);
    suffix_change(filename, ".map");

    if ((fmap = fopen(filename, "r")) != NULL)
    {
        mb_enumerate_banks(fmap, binname, &memory, &aligned);
        fclose(fmap);

//        dumpBankInfo(&memory);

        // Check if banks exceed 16KB limits
        checkBankLimits(&memory);

        // sort the memory banks and look for section overlaps
        if (mb_sort_banks(&memory))
            exit_log(1, "Aborting... one or more binaries overlap\n");
    }
    else
    {
        fprintf(stderr, "Failed to enumerate banks, could not open %s\n", filename);
    }

    if (dumb)
    {
        strcpy(filename, binname);
    }
    else
    {
        // If the ORG address has been specified use it.
        // Otherwise, search the map file for it.
        if (origin != -1)
        {
            pos = origin;
        }
        else
        {
            if ((pos = get_org_addr(crtfile)) == -1)
            {
                exit_log(1, "Could not find symbol CRT_ORG_CODE or __crt_org_code\n");
            }
        }

        // If the exec address was not specified, use the ORG address
        if (exec == -1)
        {
            exec = pos;
        }

        // If the block name was not specified, use the binary file name
        if (blockname == NULL)
            blockname = zbasename(binname);

        // If an output file was not specified, use the binary
        // file name but change the extension
        if (outfile == NULL)
        {
            strcpy(filename, binname);
            suffix_change(filename, ".cpc");
        }
        else
        {
            strcpy(filename, outfile);
        }

        if ((fpin = fopen_bin(binname, crtfile)) == NULL)
        {
            exit_log(1, "Can't open input file %s\n", binname);
        }

        // Now we try to determine the size of the file to be
        // converted
        if (fseek(fpin, 0, SEEK_END))
        {
            fclose(fpin);
            exit_log(1, "Couldn't determine size of file\n");
        }

        binary_length = ftell(fpin);
        fseek(fpin, 0L, SEEK_SET);

        inFileBuff = must_malloc(binary_length);
        if (binary_length != fread(inFileBuff, 1, binary_length, fpin))
        {
            fclose(fpin);
            exit_log(1, "Could not read required data from <%s>\n", binname);
        }
        fclose(fpin);

        cpm_create_filename(filename, cpm_filename, 0, 0);
        outFileBuff = cpc_layout_file(inFileBuff, cpm_filename, binary_length, pos, 2, &file_len);
        free(inFileBuff);

        if ((fpout = fopen(filename, "wb")) == NULL)
        {
            exit_log(1, "Can't open output file\n");
        }

        if ((fwrite(outFileBuff, 1, file_len, fpout)) != file_len)
        {
            fclose(fpout);
            free(outFileBuff);
            exit_log(1, "Could not write required data to <%s>\n", filename);
        }
        fclose(fpout);

        if (disk)
        {
            char disc_image_name[FILENAME_MAX + 1];
            int bsnum_bank;
            disc_handle *h;

            strcpy(disc_image_name, binname);
            suffix_change(disc_image_name, ".dsk");

            if ((h = cpm_create_with_format("cpcsystem")) == NULL)
            {
                free(outFileBuff);
                exit_log(1, "Cannot find disc specification\n");
            }

            disc_write_file(h, cpm_filename, outFileBuff, file_len);
            free(outFileBuff);

            // Write the banks
            bsnum_bank = mb_find_bankspace(&memory, "BANK");
            if (bsnum_bank >= 0)
            {
                for (i = 0; i < MAXBANKS; i++)
                {
                    struct memory_bank *mb = &memory.bankspace[bsnum_bank].membank[i];
                    if (mb->num > 0)
                    {
                        char numbuf[32];

                        if ((fpin = fopen(mb->secbin->filename, "rb")) == NULL)
                        {
                            exit_log(1, "Cannot open BANK file %s\n", mb->secbin->filename);
                        }

                        inFileBuff = must_malloc(mb->secbin->size);

                        if (mb->secbin->size != fread(inFileBuff, 1, mb->secbin->size, fpin))
                        {
                            fclose(fpin);
                            exit_log(1, "Could not read required data from <%s>\n", mb->secbin->filename);
                        }
                        fclose(fpin);

                        snprintf(numbuf, sizeof(numbuf), ".B%d", i);
                        suffix_change(filename, numbuf);

                        cpm_create_filename(filename, cpm_filename, 0, 0);
                        outFileBuff = cpc_layout_file(inFileBuff, cpm_filename, mb->secbin->size, mb->secbin->org, 2, &file_len);
                        disc_write_file(h, cpm_filename, outFileBuff, file_len);

                        free(inFileBuff);
                        free(outFileBuff);
                    }
                }
            }

            if (disc_write_edsk(h, disc_image_name) < 0)
            {
                exit_log(1, "Can't write disc image");
            }

            disc_free(h);
            mb_cleanup_memory(&memory);
            mb_cleanup_aligned(&aligned);
            return 0;
        }
        else
        {
            free(outFileBuff);
            mb_cleanup_memory(&memory);
            mb_cleanup_aligned(&aligned);
        }
    }

    /* low & high levels in the .wav file                               */
    /* LOW must be under 128 and HIGH above this value                  */
    /* The nearer 128, the less sound output is loud                    */
    /* Typically LOW and HIGH are centered around 128 but I don't think */
    /* this is requested.                                               */
    /* Note : of course, output .wav file is 8bit.                      */

    if (loud) {
        HIGH = 0xFd;
        LOW = 2;
    } else {
        HIGH = 0xe0;
        LOW = 0x20;
    }

    if (!rate)
        rate = 8000;

    /* ***************************************** */
    /* Now, if requested, create the audio file */
    /* ***************************************** */
    if ((audio) || (loud)) {
        if ((source = fopen(filename, "rb")) == NULL) {
            exit_log(1,"Can't open file %s for wave conversion\n", filename);
        }
        /*
           * if (fseek(source,0,SEEK_END)) { fclose(source);
           * exit_log(1,"Couldn't determine size of file\n"); }
           * len=ftell(source); fseek(source,0,SEEK_SET);
           */
        if (1 != fread(srchead, 128, 1, source)) { fclose(source); exit_log(1, "Could not read required data from <%s>\n",filename); }
        size = srchead[64] + srchead[65] * 256;
        if (dumb)
            printf("CPC file size (%s):%d bytes\n", filename, size);

        blocks = size >> 11;

        if (size & 2047)
            blocks++;
        if (dumb)
            printf("Need %d blocks.\n", blocks);

        strcpy(wavfile, filename);

        suffix_change(wavfile, ".wav");

        if ((f = fopen(wavfile, "wb")) == NULL) {
            exit_log(1, "Can't open output waw audio file %s\n", wavfile);
        }
        putWavHeader(f);

        for (i = 0; i < 256; i++)
            header[i] = 0;
        header[24] = srchead[64];
        header[25] = srchead[65];
        header[17] = 0;
        writename(header, srchead);
        for (i = 18; i < 28; i++)
            header[i] = srchead[i];
        if (dumb)
            printf("Total size : %4x\n", header[24] + header[25] * 256);
        if (dumb)
            printf("Entry point: %4x\n", header[26] + header[27] * 256);
        if (dumb)
            printf("Origin     : %4x\n", header[21] + header[22] * 256);

        putsilence(f, rate, &filesize);

        for (currentblock = 1; currentblock <= blocks; currentblock++) {
            if (dumb)
                printf("Processing file %s block %d ", header, currentblock);

            /* Filling in the tape header ... */
            header[16] = (unsigned char)currentblock;
            header[19] = 0; /* Default block size: 2048 bytes */
            header[20] = 8;

            if (currentblock == blocks) { /* Last block */
                header[17] = 0xff;
                if (size % 2048) {
                    header[20] = (size & 0x0700) >> 8;
                    header[19] = size & 0xff;
                }
            }
            if (currentblock == 1)
                header[23] = 0xff; /* First Block */
            /*
                * AMSDOS won't load the file if this is not set to
                * 255 ! it will reply "Found FILE block n" ,
                * whatever the block number
                */
            if (dumb)
                printf("Size of block:%d\n", header[19] + header[20] * 256);
            if (1 != fread(srcdata, header[19] + header[20] * 256, 1, source)) { fclose(source); exit_log(1, "Could not read required data from <%s>\n",filename); }

            if (feof(source)) {
                fprintf(stderr, "Fatal error: EOF met on input file.\nMaybe a non-CPC or ASCII file ?\n");
                exit(2);
            }
            /* Actual header writing */
            for (i = 0; i < 256; i++)
                putbyte(f, 0xff, &filesize); /* leader */
            putbit(f, 0, &filesize); /* Sync bit & byte. For
                                    * more details see */
            putbyte(f, 0x2c, &filesize); /* AIFFdec's refrnce.txt
                                    * !               */
            putblock(f, header, 256, &filesize);
            putCRC(f, calcCRC(header), &filesize);
            for (i = 0; i < 4; i++)
                putbyte(f, 255, &filesize); /* trailer */
            /* putsilence(f,rate,&filesize); */
            for (i = 0; i < 256; i++)
                putbyte(f, 255, &filesize); /* leader */
            putbit(f, 0, &filesize);
            putbyte(f, 0x16, &filesize);

            /* Block writing */

            nchunks = header[20];
            if (header[19] != 0)
                nchunks++;

            /*
                * Number of chunks is block size/256, +1 if there is
                * a remainder
                */
            for (j = 0; j < nchunks; j++) {
                putblock(f, srcdata + (j * 256), 256, &filesize);
                putCRC(f, calcCRC(srcdata + (j * 256)), &filesize);
            }
            for (i = 0; i < 4; i++)
                putbyte(f, 255, &filesize); /* trailer */
            if (currentblock != blocks)
                putsilence(f, rate * 2, &filesize);
        }

        if (dumb)
            printf("Output file size:%ld\n", filesize);
        printf("Actual rate:%ld bits/sec\n", (long int)(((long int)(size * 8 * rate)) / filesize));
        writesize(f, filesize);

        fclose(source);
        fclose(f);

    } /* END of WAV CONVERSION BLOCK */
    return 0;
}

static int cpc_checksum(unsigned char *buf, int len)
{
     int          i;
     int          cksum = 0;

     for (i = 0; i < len; i++) {
          cksum += buf[i];
     }

     return cksum;
}
