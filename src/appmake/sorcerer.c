
/*
 *      Sorcerer Exidy and MicroBee audio cassette formats
 *      Kansas City Standard (DGOS variants)
 *      
 *      $Id: sorcerer.c,v 1.7 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static int               origin       = -1;
static char              audio        = 0;
static char              fast         = 0;
static char              bps300       = 0;
static char              bee          = 0;
static char              bee1200      = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              bit_state    = 0;
static char              h_lvl;
static char              l_lvl;
static char              sorcerer_h_lvl;
static char              sorcerer_l_lvl;

static unsigned char     parity;


/* Options that are available for this module */
option_t sorcerer_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Tweak the audio tones to run a bit faster",  OPT_BOOL,  &fast },
    {  0,  "300bps",   "300 baud mode instead than 1200",  OPT_BOOL,  &bps300 },
    {  0,  "bee",      "MicroBee type header",  OPT_BOOL,  &bee },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* two fast cycles for '0', two slow cycles for '1' */

void sorcerer_bit (FILE *fpout, unsigned char bit)
{
    int i, j, period0, period1;

	/* Most of the "fast" tricks wouldn't work on the Sorcerer (HW/clock driven tape interface) */
    if ( bps300 || bee ) {
        if ( fast && bee ) {
            period1 = 7;
            period0 = 16;
        } else {
            period1 = 9;
            period0 = 18;
        }
    } else {
            period1 = 18;
            period0 = 37;
    }

	/* phase inversion (Sorcerer only) */
    if (bit_state) {
        h_lvl=sorcerer_h_lvl;
        l_lvl=sorcerer_l_lvl;
    } else {
        h_lvl=sorcerer_l_lvl;
        l_lvl=sorcerer_h_lvl;
    }

    if (bit) {
        /* '1' */
        if ( bps300 ) {
          for (j=0; j < 8; j++) {
              for (i=0; i < period1; i++)
                fputc (h_lvl,fpout);
              for (i=0; i < period1; i++)
                fputc (l_lvl,fpout);
          }
        } else {
          if (bee) {
              for (j=0; j < 2; j++) {
                  for (i=0; i < period1; i++)
                    fputc (h_lvl,fpout);
                  for (i=0; i < period1; i++)
                    fputc (l_lvl,fpout);
              }
          } else {
              for (i=0; i < period1; i++)
                fputc (h_lvl,fpout);
              for (i=0; i < period1; i++)
                fputc (l_lvl,fpout);
		  }
        }
    } else {
        /* '0' */
        if ( bps300 ) {
          for (j=0; j < 4; j++) {
              for (i=0; i < period0; i++)
                fputc (h_lvl,fpout);
              for (i=0; i < period0; i++)
                fputc (l_lvl,fpout);
          }
        } else {
          if (bee) {
              for (i=0; i < period0; i++)
                fputc (h_lvl,fpout);
              for (i=0; i < period0; i++)
                fputc (l_lvl,fpout);
          } else {
            for (i=0; i < (period0); i++)
                fputc (h_lvl,fpout);
            /* toggle phase */
            bit_state = !bit_state;
          }
        }
    }
}


void sorcerer_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* Start bit */
  sorcerer_bit(fpout,0);

  /* byte */
  for (i=0; i < 8; i++)
        sorcerer_bit (fpout, (b & c[i]));

  /* Stop bits */
  sorcerer_bit(fpout,1);
  sorcerer_bit(fpout,1);
}

void sorcerer_tone (FILE *fpout)
{
    int i;

    if (fast) {
        for (i=0; (i < 1500); i++)      /* pre-leader short extra delay */
            sorcerer_bit(fpout,1);
    } else {            
        for (i=0; (i < 3500); i++)      /* pre-leader short extra delay */
            sorcerer_bit(fpout,1);
    }
}


/*
 * Execution starts here
 */

int sorcerer_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    name[7];
    FILE   *fpin;
    FILE   *fpout;
    int     len;
    long    pos;
    int     c,i,j;
    int        leadinlength;


    if ( help )
        return -1;

    if ( binname == NULL || (!dumb && ( crtfile == NULL && origin == -1 )) ) {
        return -1;
    }

    if (loud) {
        sorcerer_h_lvl = 0xFF;
        sorcerer_l_lvl = 0;
    } else {
        sorcerer_h_lvl = 0xe0;
        sorcerer_l_lvl = 0x20;
    }
    
    if ( bee )
        leadinlength=64;
    else
        leadinlength=100;

    if (dumb) {
        strcpy(filename,binname);

    } else {
        if ( outfile == NULL ) {
            strcpy(filename,binname);
              suffix_change(filename,".srr");
        } else {
            strcpy(filename,outfile);
        }

        if ( blockname == NULL )
            blockname = binname;
        
        if ( strcmp(binname,filename) == 0 ) {
            fprintf(stderr,"Input and output file names must be different\n");
            myexit(NULL,1);
        }

        if ( origin != -1 ) {
            pos = origin;
        } else {
            if ( (pos = get_org_addr(crtfile)) == -1 ) {
                myexit("Could not find parameter ZORG (not z88dk compiled?)\n",1);
            }
        }

        if ( (fpin=fopen_bin(binname, crtfile) ) == NULL ) {
            fprintf(stderr,"Can't open input file %s\n",binname);
            myexit(NULL,1);
        }

        if (fseek(fpin,0,SEEK_END)) {
            fprintf(stderr,"Couldn't determine size of file\n");
            fclose(fpin);
            myexit(NULL,1);
        }

        len=ftell(fpin);

        fseek(fpin,0L,SEEK_SET);

        if ( (fpout=fopen(filename,"wb") ) == NULL ) {
            fclose(fpin);
            myexit("Can't open output file\n",1);
        }

        /* HEADER */

        /* Leader (DGOS' standard padding sequence) */
        for (i=0; (i < leadinlength); i++)
            writebyte_pk(0,fpout,&parity);
        writebyte_pk(1,fpout,&parity);      /* leading SOH */
        parity=0;

        /* Deal with the filename */
        if (strlen(blockname) >= 6 ) {
            strncpy(name,blockname,6);
        } else {
            strcpy(name,blockname);
            strncat(name,"      ",6-strlen(blockname));
        }
        if ( bee ) {
            for (i=0;i<=5;i++)
                writebyte_pk(name[i],fpout,&parity);
            writebyte_pk('M',fpout,&parity);         /* File type (LOADM) */
        } else {
            for (i=0;i<=4;i++)
                writebyte_pk(name[i],fpout,&parity);
            writebyte_pk(0x55,fpout,&parity);      /* File Header Identification */
            writebyte_pk(0,fpout,&parity);         /* File type (bit 7 set = never autorun) */
        }

        writeword_pk(len,fpout,&parity);       /* Program File Length */
        writeword_pk(pos,fpout,&parity);       /* Program Location */
        writeword_pk(pos,fpout,&parity);       /* GO Address: pos for autorun when LOADG (Sorcerer) / or LOADM (MicroBee w/FL_EXEC set to 0xff) */
        
        if ( bee ) {
            if ( !bps300 ) {
                bee1200=1;            /* Speed (MicroBee at 1200 bps) */
                bps300=1;            /* MicroBee HEADER is always at 300 bps */
            }
            writebyte_pk(bee1200,fpout,&parity);       
            writebyte_pk(255,fpout,&parity);         /* Autostart (FL_EXEC) */
        } else {
            writebyte_pk(0,fpout,&parity);         /* Spare */
            writebyte_pk(0,fpout,&parity);         /* ... */
        }
        
        writebyte_pk(0,fpout,&parity);         /* Spare */

        writebyte_p(parity,fpout,&parity);        /* Checksum for header and middle blocks*/

        if ( !bee ) {
        /* (Sorcerer only) - Data block leader (DGOS' standard padding sequence) */
        for (j=0; (j < leadinlength); j++)
            writebyte_pk(0,fpout,&parity);
        writebyte_pk(1,fpout,&parity);      /* leading SOH */
        parity=0;
        }

        /* PROGRAM BLOCK */

        for ( i = 0; i < len; i++) {
            if (i>0 && (i%256 == 0))
                writebyte_p(parity,fpout,&parity);        /* Checksum for header and middle blocks*/
            c = getc(fpin);
            writebyte_pk(c,fpout,&parity);
        }

        if ((i-1)%256 != 0)
            writebyte_p(parity,fpout,&parity);        /* Checksum for header and middle blocks*/

        /* Trailing sequence (DGOS' standard padding sequence) */
        for (j=0; (j < leadinlength); j++)
            writebyte_pk(0,fpout,&parity);
        writebyte_pk(1,fpout,&parity);      /* byte tail */

        fclose(fpin);
        fclose(fpout);
    }

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if (( audio ) || ( bps300 ) || (loud)) {
        if ( (fpin=fopen(filename,"rb") ) == NULL ) {
            fprintf(stderr,"Can't open file %s for wave conversion\n",filename);
            myexit(NULL,1);
        }

        if (fseek(fpin,0,SEEK_END)) {
           fclose(fpin);
           myexit("Couldn't determine size of file\n",1);
        }
        len=ftell(fpin);
        fseek(fpin,0,SEEK_SET);

        strcpy(wavfile,filename);

        suffix_change(wavfile,".RAW");

        if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
            fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
            myexit(NULL,1);
        }

        /* leading silence and tone*/
        for (i=0; i < 0x1000; i++)
            fputc(0x80, fpout);
        sorcerer_tone(fpout);
            
        /* Copy the header */
        if (dumb) printf("\nInfo: Program Name found in header: ");
        for (i=0; (i < (leadinlength+18)); i++) {
            c=getc(fpin);
            if (dumb && i>leadinlength && i<(leadinlength+6)) printf("%c",c);
            if (dumb && i==(leadinlength+7)) printf("\nInfo: File type $%x",c);
            if (dumb && (i==(leadinlength+8) || i==(leadinlength+10) || i==(leadinlength+12))) j=c;
            if (dumb && i==(leadinlength+9)) printf("\nInfo: File Size $%x",c*256+j);
            if (dumb && i==(leadinlength+11)) printf("\nInfo: Start location $%x",c*256+j);
            if (dumb && i==(leadinlength+13)) printf("\nInfo: Go address $%x",c*256+j);
            sorcerer_rawout(fpout,c);
        }

        len=len-18-leadinlength;
        if ((bee)&&(bee1200))
            bps300=0;

        /* program block */
        if (len > 0) {
            for (i=0; i<len;i++) {
                if ((bee)&&(bee1200)&&(i==(len-leadinlength)))
                    bps300=1;
                c=getc(fpin);
                sorcerer_rawout(fpout,c);
            }
        }

        /* trailing tone and silence (probably not necessary) */
/*
        sorcerer_bit(fpout,0);
        sorcerer_tone(fpout);
        for (i=0; i < 0x1000; i++)
            fputc(0x80, fpout);
*/

        fclose(fpin);
        fclose(fpout);

        /* Now complete with the WAV header */
        raw2wav(wavfile);
            
    }  /* END of WAV CONVERSION BLOCK */
    
    return 0;
}
