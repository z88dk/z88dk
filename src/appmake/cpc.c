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
static char     audio = 0;
static char     dumb = 0;
static char     loud = 0;
static char     noext = 0;
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
void putbit(FILE * f, unsigned char b, unsigned long int *filesize)
{
     int          i         , l;
     if (b == 0)
          l = W0;
     else
          l = W1;
     *filesize += l * 2;     /* Need the file size for the .wav header */
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
void putbyte(FILE * f, unsigned char b, unsigned long int *filesize)
{
     int          i;

     for (i = 0; i < 8; i++) {
          putbit(f, b & 128, filesize);
          b <<= 1;
     }

}

void putblock(FILE * f, unsigned char *block, unsigned int size, unsigned long int *filesize) 
{
     int          i;
     for (i = 0; i < size; i++)
          putbyte(f, block[i], filesize);
}

/* Creates the header for the .wav file */
void putWavHeader(FILE * f)
{

     /* Header for .wav files. Dumbly copied from an existent .wav file :) */
     /* (I haven't fully understood how it works :)))                      */

     /*
      * (03/09/97) Kev Thacker provided some help for these .wav files.
      * Thanks to him.
      */


     unsigned char     WavHeader[44] =
     {
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


void writesize(FILE * f, unsigned long int size)
{
     /*
      * This might cause problems on little-endian systems. If so, please
      * let me know.
      */

     unsigned long int s2;
     fseek(f, 40, SEEK_SET);
     fwrite(&size, 4, 1, f);
     fseek(f, 4, SEEK_SET);
     s2 = size + 36;          /* I think this is right. Not sure at all. :) */
     fwrite(&s2, 4, 1, f);
}

/*
 * Here are the CRC functions ... Note: I DIDN'T try to understand them ! :)
 */
void putCRC(FILE * f, unsigned int CRC, unsigned long int *filesize)
{
     unsigned char     c1, c2;
     c1 = (unsigned char)((CRC & 0xff00) >> 8);
     c2 = (unsigned char)CRC & 0xff;
     putbyte(f, c1, filesize);
     putbyte(f, c2, filesize);
}

unsigned int CRCupdate(unsigned int CRC, unsigned char new)
{
     unsigned int     aux = CRC ^ (new << 8);
     int          i;

     for (i = 0; i < 8; i++)
          if (aux & 0x8000) {
               aux <<= 1;
               aux ^= kCRCpoly;
          } else {
               aux <<= 1;
          }

     return (aux);
}


unsigned int calcCRC(unsigned char *buffer)
{

     int          j;
     unsigned int     CRC;


     CRC = 0xFFFF;
     for (j = 0; j < 256; j++)
          CRC = CRCupdate(CRC, buffer[j]);
     CRCupdate(CRC, 0);
     CRCupdate(CRC, 0);

     return ((~CRC) & 0xffff);
}


void writename(unsigned char *tape_hdr, unsigned char *disc_hdr)
{
     /* Processes the CPC file name.          */
     /* Mainly, to manage file extensions ... */
     int          i = 0,     j = 0;
     while ((disc_hdr[i + 1] != 32) && (i < 8)) {
          tape_hdr[i] = disc_hdr[i + 1];
          i++;
     }
     if (noext) {
          if (disc_hdr[9] != 32) {
               tape_hdr[i] = '.';
               i++;
          }          /* File extension present */
          while ((disc_hdr[9 + j] != 32) && (j < 3)) {
               tape_hdr[i] = disc_hdr[9 + j];
               i++;
               j++;
          }
     }
}

void putsilence(FILE * f, int length, unsigned long int *filesize)
{
     int          i;
     *filesize += length;
     for (i = 0; i < length; i++)
          fputc(128, f);
}


int cpc_exec(char *target)
{
     /* unsigned char header[128]; */
     char          filename  [FILENAME_MAX + 1];
     char          wavfile   [FILENAME_MAX + 1];
     FILE           *fpin, *fpout;
     long          pos;
     int          c;
     int          i;
     int          len;
     int          checksum;

     FILE           *f, *source;
     unsigned char     header[256];
     unsigned char     srchead[128];
     unsigned char     srcdata[2048];
     unsigned long int filesize = 0;
     unsigned int     size;
     unsigned int     blocks;
     unsigned int     currentblock = 1;
     int          j;
     int          nchunks;

     if (help)
          return -1;

     if (binname == NULL || (crtfile == NULL && origin == -1)) {
          return -1;
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

     if (dumb) {
          strcpy(filename, binname);
     } else {
          if (outfile == NULL) {
               strcpy(filename, binname);
               suffix_change(filename, ".cpc");
          } else {
               strcpy(filename, outfile);
          }


          if (origin != -1) {
               pos = origin;
          } else {
               if ( (pos = get_org_addr(crtfile)) == -1 ) {
                    myexit("Could not find parameter ZORG (not z88dk compiled?)\n", 1);
               }
          }

          if (exec == -1) {
               exec = pos;
          }

		  if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
               fprintf(stderr, "Can't open input file %s\n", binname);
               myexit(NULL, 1);
          }

          /*
           * Now we try to determine the size of the file to be
           * converted
           */
          if (fseek(fpin, 0, SEEK_END)) {
               fprintf(stderr, "Couldn't determine size of file\n");
               fclose(fpin);
               myexit(NULL, 1);
          }
          len = ftell(fpin);

          fseek(fpin, 0L, SEEK_SET);

          if ((fpout = fopen(filename, "wb")) == NULL) {
               fclose(fpin);
               myexit("Can't open output file\n", 1);
          }
          /* Setup an AMSDOS header */
          memset(header, 0, 128);

          header[0x01] = 'A';
          header[0x02] = ' ';
          header[0x03] = ' ';
          header[0x04] = ' ';
          header[0x05] = ' ';
          header[0x06] = ' ';
          header[0x07] = ' ';
          header[0x08] = ' ';

          if (blockname == NULL)
               blockname = binname;

          /* Deal with the block name */
          for (i = 0; (i <= 8) && (isalnum(blockname[i])); i++)
               header[i + 1] = toupper(blockname[i]);

          header[0x09] = 'C';
          header[0x0A] = 'O';
          header[0x0B] = 'M';

          header[0x12] = 2;     /* File type, 2 is binary apparently */
          header[0x15] = pos % 256;
          header[0x16] = pos / 256;

          header[0x18] = len % 256;
          header[0x19] = len / 256;

          header[0x1A] = exec % 256;
          header[0x1B] = exec / 256;

          header[0x40] = len % 256;
          header[0x41] = len / 256;


          checksum = cpc_checksum(header, 0x42);

          header[0x43] = checksum % 256;
          header[0x44] = checksum / 256;

          fwrite(header, 128, 1, fpout);

          for (i = 0; i < len; i++) {
               c = getc(fpin);
               fputc(c, fpout);
          }
          fclose(fpin);
          fclose(fpout);
     }

     /* ***************************************** */
     /* Now, if requested, create the audio file */
     /* ***************************************** */
     if ((audio) || (loud)) {
          if ((source = fopen(filename, "rb")) == NULL) {
               fprintf(stderr, "Can't open file %s for wave conversion\n", filename);
               myexit(NULL, 1);
          }
          /*
           * if (fseek(source,0,SEEK_END)) { fclose(source);
           * myexit("Couldn't determine size of file\n",1); }
           * len=ftell(source); fseek(source,0,SEEK_SET);
           */
          fread(srchead, 128, 1, source);
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
               fprintf(stderr, "Can't open output waw audio file %s\n", wavfile);
               myexit(NULL, 1);
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
               header[19] = 0;     /* Default block size: 2048 bytes */
               header[20] = 8;


               if (currentblock == blocks) {     /* Last block */
                    header[17] = 0xff;
                    if (size % 2048) {
                         header[20] = (size & 0x0700) >> 8;
                         header[19] = size & 0xff;
                    }
               }
               if (currentblock == 1)
                    header[23] = 0xff;     /* First Block */
               /*
                * AMSDOS won't load the file if this is not set to
                * 255 ! it will reply "Found FILE block n" ,
                * whatever the block number
                */
               if (dumb)
                    printf("Size of block:%d\n", header[19] + header[20] * 256);
               fread(srcdata, header[19] + header[20] * 256, 1, source);

               if (feof(source)) {
                    fprintf(stderr, "Fatal error: EOF met on input file.\nMaybe a non-CPC or ASCII file ?\n");
                    exit(2);
               }
               /* Actual header writing */
               for (i = 0; i < 256; i++)
                    putbyte(f, 0xff, &filesize);     /* leader */
               putbit(f, 0, &filesize);     /* Sync bit & byte. For
                                    * more details see */
               putbyte(f, 0x2c, &filesize);     /* AIFFdec's refrnce.txt
                                    * !               */
               putblock(f, header, 256, &filesize);
               putCRC(f, calcCRC(header), &filesize);
               for (i = 0; i < 4; i++)
                    putbyte(f, 255, &filesize);     /* trailer */
               /* putsilence(f,rate,&filesize); */
               for (i = 0; i < 256; i++)
                    putbyte(f, 255, &filesize);     /* leader */
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
                    putbyte(f, 255, &filesize);     /* trailer */
               if (currentblock != blocks)
                    putsilence(f, rate * 2, &filesize);
          }

          if (dumb)
               printf("Output file size:%ld\n", filesize);
          printf("Actual rate:%ld bits/sec\n", (long int)(((long int)(size * 8 * rate)) / filesize));
          writesize(f, filesize);

          fclose(source);
          fclose(f);

     }               /* END of WAV CONVERSION BLOCK */
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
