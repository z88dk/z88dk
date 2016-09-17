/*
 *        Quick 'n' dirty mym to tap converter
 *
 *        Usage: bin2tap [binfile] [tapfile]
 *
 *        Dominic Morris  - 08/02/2000 - tapmaker
 *        Stefano Bodrato - 03/12/2000 - bin2tap
 *        Stefano Bodrato - 29/05/2001 - ORG parameter added
 *        Dominic Morris  - 10/03/2003 - integrated into appmake & options
 *        Stefano Bodrato - 19/07/2007 - BASIC block 'merge' feature
 *        Stefano Bodrato - 2010,2011  - AUDIO options and single BASIC block mode
 *        Stefano Bodrato - 01/02/2013 - Turbo tape option
 *        Stefano Bodrato - 13/02/2013 - Extreme turbo tape option
 *
 *        Creates a new TAP file (overwriting if necessary) just ready to run.
 *        You can use tapmaker to customize your work.
 * 
 *        If zorg=23760 the code is embedded in the BASIC program.
 *        (take care of the BASIC extension, 
 *              I.E. zorg=23813 if Interface 1 is activated).
 *        To know the exact location after the insertion of your disk interface,
 *        activate it (CLS #, CAT, RUN or similar), then type:
 *            PRINT PEEK 23635+256*PEEK 23636+5
 *        Advanced users can also see bin2bas-rem in the 'support/zx' directory
 *        and take benefit of the self-relocating code.
 * 
 *        The turbo tape option produces valid WAV files only.
 * 
 *        It can be combined with the '--fast' flag to achieve extra speed and
 *        with the '--screen' option to add a title screen.
 * 
 *        The '.tap' file is left for advanced users for hand-editing which
 *        can take benefit od the 'dumb' mode and 'patch' options
 *        (i.e. the extra compile options:
 *              -Cz--patchpos -Cz18 -Cz--patchdata -Czcd69ff
 *         ..will make the turbo loader ready to load an intermediate block
 *        (by default a title screen but it can be changed with a longer patch),
 *        then some more sound editing will be necessary to add the picture
 *        taken from a previously prepared audio file using the dumb/turbo options).
 * 
 *
 *        $Id: zx.c,v 1.27 2016-09-17 05:09:40 aralbrec Exp $
 */

#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static char             *blockname    = NULL;
static char             *merge        = NULL;
static int               origin       = -1;
static int               patchpos     = -1;
static char             *patchdata    = NULL;
static char             *screen       = NULL;
static char              help         = 0;
static char              audio        = 0;
static char              ts2068       = 0;
static char              turbo        = 0;
static char              extreme      = 0;
static char              fast         = 0;
static char              dumb         = 0;
static char              noloader     = 0;
static char              noheader     = 0;
static unsigned char     parity = 0;


// These values are set accordingly with the turbo loader timing and should not be changed
#define	tperiod0	5
#define	tperiod1	10
#define	tperiod2	16

unsigned char* loader;


/* Options that are available for this module */
option_t zx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "ts2068",   "TS2068 BASIC relocation (if possible)",  OPT_BOOL,  &ts2068 },
    {  0,  "turbo",    "Turbo tape loader",          OPT_BOOL,  &turbo },
    {  0,  "extreme",  "Extremely fast save (RLE)",      OPT_BOOL,  &extreme },
    {  0,  "patchpos", "Turbo tape patch position",  OPT_INT,   &patchpos },
    {  0,  "patchdata", "Turbo tape patch (i.e. cd7fff..)",  OPT_STR,   &patchdata },
    {  0,  "screen",    "Title screen file name",    OPT_STR,   &screen },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "noloader",  "Don't create the loader block",  OPT_BOOL,  &noloader },
    {  0,  "noheader",  "Don't create the header", OPT_BOOL, &noheader },
    {  0 , "merge",    "Merge a custom loader from external TAP file",  OPT_STR,   &merge },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0 , "blockname", "Name of the code block in tap file", OPT_STR, &blockname},
    {  0 ,  NULL,       NULL,                        OPT_NONE,  NULL }
};


// turbo Loader
static unsigned char turbo_loader[] = { 
0x60, 0x69,	    //  ld h,b / ld l,c
17,52,0,        //	ld	de,52 (offset)
0x19,           //	add	hl,de
17,0x69,0xff,   //	ld	de,65385
1,150,0,        //	ld	bc,150
0xed, 0xb0,     //	ldir
221,33,0,64,    //	ld	ix,16384 (position [14])
// length is not checked, we load all the data we find
0,0,0,          //	placeholder for: call	65385
221,33,0,64,    //	ld	ix,16384
// length is not checked, we load all the data we find
0,0,0,          //	placeholder for: call	65385
221,33,0,64,    //	ld	ix,16384
// length is not checked, we load all the data we find
0,0,0,          //	placeholder for: call	65385
221,33,0,128,   //	ld	ix,loc	(pos 37/38)
// length is not checked, we load all the data we find
205,0x69,0xff,  //	call	65385
0x3a, 0x48, 0x5c, // ld a,(23624)	; Restore border color
0x1f, 0x1f, 0x1f, // rra (3 times)
0xd3, 254,        // out (254),a
0xfb, 0xc9,     //  ei / ret

0xF3, 0xDB, 0xFE, 0x1F, 0xE6, 0x20, 0x4F, 0xBF, 0x06, 0x9C, 0xCD, 0xDC, 0xFF, 0x30, 0xF8, 0x3E,
0xC6, 0xB8, 0x30, 0xF4, 0x24, 0x20, 0xF1, 0x06, 0xC9, 0xCD, 0xE0, 0xFF, 0x30, 0xE9, 0x78, 0xFE,
0xD4, 0x30, 0xF4, 0xCD, 0xE0, 0xFF, 0xD0, 0x79, 0xEE, 0x03, 0x4F, 0x06, 0xD0, 0x18, 0x07, 0xDD,
0x75, 0x00, 0xDD, 0x23, 0x06, 0xD1, 0x2E, 0x01, 0xCD, 0xDC, 0xFF, 0xD0, 0x78, 0xFE, 0xDE, 0xD2,
0xB8, 0xFF, 0xFE, 0xD5, 0x3F, 0xCB, 0x15, 0x06, 0xD0, 0xD2, 0xA1, 0xFF, 0xC3, 0x98, 0xFF, 0x2D,
0x06, 0xD1, 0xCD, 0xDC, 0xFF, 0xD0, 0x3E, 0xD7, 0xB8, 0xDA, 0xB5, 0xFF, 0xDD, 0x6E, 0xFF, 0x06,
0xD1, 0xCD, 0xDC, 0xFF, 0xD0, 0x3E, 0xD5, 0xB8, 0xDA, 0xB5, 0xFF, 0xDD, 0x75, 0x00, 0xDD, 0x23,
0xC3, 0xC8, 0xFF, 0xCD, 0xE0, 0xFF, 0xD0, 0x3E, 0x0D, 0x3D, 0x20, 0xFD, 0xA7, 0x04, 0xC8, 0x3E,
0x7F, 0xDB, 0xFE, 0x1F, 0xA9, 0xE6, 0x20, 0x28, 0xF4, 0x79, 0x2F, 0x4F, 0x78, 0x00, 0xE6, 0x07,
0xF6, 0x08, 0xD3, 0xFE, 0x37, 0xC9, 0x37, 0xC9

};


static unsigned char ts_loader[] = { 
//basic hdr
19,0
,0x00,0x00,'2','0','6','8',' ','r','e','l','o','c',0x3A,0x00,0x05,0x00,0x3A,0x00,0x5e
//basic data
,60,0
,0xFF,0x00,0x05,0x13,0x00,0xFA,0xBE,0xB0,0x22,0x37,0x35,0x22,0xC9,0xB0,0x22,0x32
,0x32,0x35,0x22,0xCB,0xEF,0x22,0x22,0x0D,0x00,0x0A,0x1F,0x00,0xEF,0x22,0x22,0xAF
,0x3A,0xF9,0xC0,0xB0,0x22,0x33,0x32,0x37,0x36,0x38,0x22,0x3A,0xDF,0xB0,0x22,0x32
,0x35,0x35,0x22,0x2C,0xC3,0xA7,0x3A,0xEF,0x22,0x22,0x0D,0x53

//lm hdr
,19,0
,0x00,0x03,'v','i','d','.','b','i','n',' ',' ',' ',0x32,0x00,0x00,0x80,0x00,0x00,0xA1
//lm data
,52,0
,0xFF,0x3E,0x06,0x21,0x8E,0x0E,0xF5,0xCD,0x1F,0x80,0xF1,0xFE,0x80,0x20,0x03,0x32
,0xC2,0x5C,0x3A,0x1E,0x80,0xD3,0xF4,0xDB,0xFF,0xCB,0xBF,0xD3,0xFF,0xFB,0xC9,0x00
,0xF3,0xF5,0xDB,0xFF,0xCB,0xFF,0xD3,0xFF,0xDB,0xF4,0x32,0x1E,0x80,0x3E,0x01,0xD3
,0xF4,0xF1,0xE9,0xB5
};


void turbo_one(FILE *fpout)
{
  int i;

  for (i=0; i < tperiod1; i++)
    fputc (0x20,fpout);
  for (i=0; i < tperiod0; i++)
    fputc (0xe0,fpout);
}


void turbo_rawout (FILE *fpout, unsigned char b)
{
  static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
  int i;

  if (!b && (extreme)) {
      /* if byte is zero then we shortcut to a single bit ! */
      // Experimental min limit is 14
      //zx_rawbit(fpout, tperiod2);
      zx_rawbit(fpout, tperiod1);
      //zx_rawbit(fpout, tperiod1);
      turbo_one(fpout);
  } else {
      for (i=0; i < 8; i++)
      {
        if (b & c[i])
          // Experimental min limit is 7
          //zx_rawbit(fpout, tperiod1);
          turbo_one(fpout);
        else
          zx_rawbit(fpout, tperiod0);
      }
  }
}



int zx_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    char    name[11];
    char    mybuf[20];
    FILE    *fpin, *fpout, *fpmerge;
    long    pos;
    int     c,d;
    int     warping;
    int     i,j,blocklen;
    int     len, mlen;
    int		blockcount;

    
    unsigned char * loader;
    int		loader_len;

        
    if ( help )
        return -1;

    if ( binname == NULL || (!dumb && ( crtfile == NULL && origin == -1 )) ) {
        return -1;
    }

    loader = turbo_loader;
    loader_len = sizeof(turbo_loader);

    if (extreme)  {
        //loader = xtreme_loader;
        //loader_len = sizeof(xtreme_loader);
        turbo=TRUE;
        //fast=TRUE;
    }

    if (turbo)  {
        audio = TRUE;
        fprintf(stderr,"WARNING: 'tap' file in turbo mode is inconsistent, use the WAV audio file.\n");
    }


    if ((patchpos >=0) && (patchpos < loader_len) && (patchdata != NULL)) {
        i=0;
        fprintf(stderr,"Patching the turbo loader at position %u: ",patchpos);
        while (patchdata[i]) {
            if (i&1) {
                c+=hexdigit(patchdata[i]);
                loader[patchpos]=(unsigned char)c;
                fprintf(stderr,"$%x ",c);
                patchpos++;
            } else {
                c=16*hexdigit(patchdata[i]);
            }
            i++;
        }
        fprintf(stderr," (%i bytes)\n",i/2);
        
    }

    if (dumb) {
        strcpy(filename,binname);
        if (turbo) fprintf(stderr,"WARNING: turbo option in dumb mode requires extra editing of the wav file.\n");
        
    } else {
        if ( outfile == NULL ) {
            strcpy(filename,binname);
            suffix_change(filename,".tap");
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


    /*
     *        Now we try to determine the size of the file
     *        to be converted
     */
        if ( fseek(fpin,0,SEEK_END) ) {
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

        if (ts2068) {
            if (pos<33000) 
                printf("\nInfo: Position %u is too low, not relocating TS2068 BASIC.", (int)pos);
            else
                for (i=0; (i < sizeof(ts_loader)); i++)
                    fputc(ts_loader[i],fpout);
        }

        if ((pos>23700)&&(pos<24000)) {
            if (turbo) fprintf(stderr,"WARNING: turbo has no effect in single BASIC block mode.\n");
            /* All in a BASIC line */
            /* Write out the BASIC header file */
                writeword_p(19,fpout,&parity);         /* Header len */
                writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */
                parity=0;
                writebyte_p(0,fpout,&parity);          /* Filetype (Basic) */

            /* Deal with the filename */
                if (strlen(blockname) >= 10 ) {
                    strncpy(name,blockname,10);
                } else {
                    strcpy(name,blockname);
                    strncat(name,"          ",10-strlen(blockname));
                }
                for        (i=0;i<=9;i++)
                    writebyte_p(name[i],fpout,&parity);
                writeword_p(21 +len,fpout,&parity);    /* length */
                writeword_p(10,fpout,&parity);         /* line for auto-start */
                writeword_p(21 + len,fpout,&parity);   /* length (?) */
                writebyte_p(parity,fpout,&parity);

            /* Write out the 'BASIC' program */
                writeword_p(23 + len,fpout,&parity);         /* block lenght */
                parity=0;
                writebyte_p(255,fpout,&parity);        /* Data is a type 255 block */

                writebyte_p(0,fpout,&parity);          /* MSB of BASIC line number */
                writebyte_p(1,fpout,&parity);          /* LSB... */
                writeword_p(2+len,fpout,&parity);      /* BASIC line length */
                writebyte_p(0xea,fpout,&parity);       /* REM */
                for (i=0; i<len;i++) {
                    c=getc(fpin);
                    writebyte_p(c,fpout,&parity);
                }
                writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */

                writebyte_p(0,fpout,&parity);          /* MSB of BASIC line number */
                writebyte_p(10,fpout,&parity);         /* LSB... */
                writeword_p(11,fpout,&parity);         /* BASIC line length */
                writebyte_p(0xf9,fpout,&parity);       /* RANDOMIZE */
                writebyte_p(0xc0,fpout,&parity);       /* USR */
                writebyte_p(0xb0,fpout,&parity);       /* VAL */
                sprintf(mybuf,"\"%i\"",(int)pos);      /* Location for USR */
                writestring_p(mybuf,fpout,&parity);
                writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */
                writebyte_p(parity,fpout,&parity);
            } else {
            /* ===============
                Loader block
               =============== */

           mlen=0;
           if ( !noloader ) {
                /* If requested, merge an external loader */
                if ( merge != NULL ) {
                    if (turbo) {
                        fprintf(stderr,"ERROR: turbo mode conflicts with the 'merge' option.\n");
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL,1);
                    }

                    if ( (fpmerge=fopen(merge,"rb") ) == NULL ) {
                        fprintf(stderr,"File for 'merge' not found: %s\n",merge);
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL,1);
                    }
                    /* check the header type (first block must be BASIC) */
                    fseek(fpmerge,3,SEEK_SET);
                    c=getc(fpmerge);
                    if ( c != 0 ) {
                        fprintf(stderr,"BASIC block not found in file %s\n",merge);
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL,1);
                    }

                    fseek(fpmerge,21,SEEK_SET);
                    mlen=getc(fpmerge)+256*getc(fpmerge);  /* get block length */

                    fseek(fpmerge,0,SEEK_SET);
                    blocklen=getc(fpmerge)+256*getc(fpmerge);  /* get block length */
                    if ( blocklen != 19 ) {
                        fprintf(stderr,"Error locating the external loader header in file %s\n",merge);
                        fclose(fpin);
                        fclose(fpout);
                        myexit(NULL,1);
                    }
                    fseek(fpmerge,0,SEEK_SET);
                    /* Total ext. loader size (headerblock + data block) */
                    blocklen+=mlen+4;
                    /* Now import the external BASIC loader */
                    for (i=0; (i < blocklen); i++) {
                        c=getc(fpmerge);
                        writebyte_p(c,fpout,&parity);
                    }
                    fclose (fpmerge);

                } else {


                /* BASIC loader */
                
                    if (turbo) {
                        mlen+=22+loader_len+32;	/* extra BASIC size for REM line + turbo block + turbo caller code */
                        loader[37] = pos%256;
                        loader[38] = pos/256;
                        if (screen) {
                            turbo_loader[18] = 0xcd;		/* activate the extra screen block loading */
                            turbo_loader[19] = 0x69;
                            turbo_loader[20] = 0xff;
                        }
                    }

                    if (screen && !turbo)  mlen+=5;			/* Add the space count for -- LOAD "" SCREEN$: */

                /* Write out the BASIC header file */
                    writeword_p(19,fpout,&parity);         /* Header len */
                    writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */

                    parity=0;
                    writebyte_p(0,fpout,&parity);             /* Filetype (Basic) */
                    writestring_p("Loader    ",fpout,&parity);
                    writeword_p(0x1e + mlen,fpout,&parity);   /* length */
                    writeword_p(10,fpout,&parity);            /* line for auto-start */
                    writeword_p(0x1e + mlen,fpout,&parity);   /* length (?) */
                    writebyte_p(parity,fpout,&parity);

                /* Write out the BASIC loader program */
                    writeword_p(32 + mlen,fpout,&parity);         /* block lenght */
                    parity=0;
                    writebyte_p(255,fpout,&parity);        /* Data is a type 255 block */

                    /* REM line is <compiled program length> + 22 bytes long */
                    if (turbo) {
                        writebyte_p(0,fpout,&parity);         /* MSB of BASIC line number for REM */
                        writebyte_p(1,fpout,&parity);         /* LSB... */
                        writeword_p(18+loader_len,fpout,&parity);         /* BASIC line length */
                        writebyte_p(0x10,fpout,&parity);         /* Cosmetics (ink) */
                        writebyte_p(7,fpout,&parity);          /* Cosmetics (white) */
                        writebyte_p(0xea,fpout,&parity);       /* REM */
                        writebyte_p(0x11,fpout,&parity);         /* Cosmetics (paper) */
                        writebyte_p(0,fpout,&parity);          /* Cosmetics (black) */
                        writestring_p(" Z88DK C+ ",fpout,&parity);
                        writebyte_p(0x11,fpout,&parity);         /* Cosmetics (paper) */
                        writebyte_p(7,fpout,&parity);          /* Cosmetics (white) */
                        for (i=0; (i < loader_len); i++)
                            writebyte_p(loader[i],fpout,&parity); 
                        writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */
                    }

                    writebyte_p(0,fpout,&parity);          /* MSB of BASIC line number */
                    writebyte_p(10,fpout,&parity);         /* LSB... */
                    if (!turbo)
                        if (screen)
                            writeword_p(26+5,fpout,&parity);         /* BASIC line length */
                        else
                            writeword_p(26,fpout,&parity);         /* BASIC line length */
                    else
                        writeword_p(26+32,fpout,&parity);         /* BASIC line length */
                    writebyte_p(0xfd,fpout,&parity);       /* CLEAR */
                    writebyte_p(0xb0,fpout,&parity);       /* VAL */
                    sprintf(mybuf,"\"%i\":",(int)pos-1);        /* location for CLEAR */
                    writestring_p(mybuf,fpout,&parity);
                    if (turbo) {
                        /* 36 bytes, which means 32 extra bytes */
                        writebyte_p(0xf9,fpout,&parity);       /* RANDOMIZE */
                        writebyte_p(0xc0,fpout,&parity);       /* USR */
                        writebyte_p('(',fpout,&parity);
                        writebyte_p(0xbe,fpout,&parity);       /* PEEK */
                        writebyte_p(0xb0,fpout,&parity);       /* VAL */
                        writestring_p("\"23635\"+",fpout,&parity);
                        writebyte_p(0xb0,fpout,&parity);       /* VAL */
                        writestring_p("\"256\"*",fpout,&parity);
                        writebyte_p(0xbe,fpout,&parity);       /* PEEK */
                        writebyte_p(0xb0,fpout,&parity);       /* VAL */
                        writestring_p("\"23636\"+",fpout,&parity);
                        writebyte_p(0xb0,fpout,&parity);       /* VAL */
                        writestring_p("\"21\"",fpout,&parity);
                        writebyte_p(')',fpout,&parity);
                    } else {
                        if (screen && !turbo) {
                            writebyte_p(0xef,fpout,&parity);       /* LOAD */
                            writebyte_p('"',fpout,&parity);
                            writebyte_p('"',fpout,&parity);
                            writebyte_p(0xaa,fpout,&parity);       /* SCREEN$ */
                            writebyte_p(':',fpout,&parity);
                        }
                        writebyte_p(0xef,fpout,&parity);       /* LOAD */
                        writebyte_p('"',fpout,&parity);
                        writebyte_p('"',fpout,&parity);
                        writebyte_p(0xaf,fpout,&parity);       /* CODE */
                    }
                    writebyte_p(':',fpout,&parity);
                    writebyte_p(0xf9,fpout,&parity);       /* RANDOMIZE */
                    writebyte_p(0xc0,fpout,&parity);       /* USR */
                    writebyte_p(0xb0,fpout,&parity);       /* VAL */
                    sprintf(mybuf,"\"%i\"",(int)pos);           /* Location for USR */
                    writestring_p(mybuf,fpout,&parity);
                    writebyte_p(0x0d,fpout,&parity);       /* ENTER (end of BASIC line) */
                    writebyte_p(parity,fpout,&parity);
                }
            }

        /* Title screen */
            if ( screen != NULL ) {
                
                if ( (fpmerge=fopen(screen,"rb") ) == NULL ) {
                    fprintf(stderr,"Title screen file not found: %s\n",screen);
                    fclose(fpin);
                    fclose(fpout);
                    myexit(NULL,1);
                }

                if ( fseek(fpmerge,0,SEEK_END) ) {
                    fprintf(stderr,"Couldn't determine size of file\n");
                    fclose(fpin);
                    fclose(fpout);
                    fclose(fpmerge);
                    myexit(NULL,1);
                }

                mlen=ftell(fpmerge);
                if (((mlen < 6912) || (mlen >=7000)) && (mlen != 6144) && (mlen != 2048)) {
                    fprintf(stderr,"ERROR: Title screen size not recognized: %u\n",mlen);
                    fclose(fpin);
                    fclose(fpout);
                    fclose(fpmerge);
                    myexit(NULL,1);
                }
                
                if (mlen <= 6912) {
                    fseek (fpmerge,0,SEEK_SET);
                    j=mlen;
                } else {
                    fseek (fpmerge,mlen-6913,SEEK_SET);
                    j=6912;
                }
    
                writeword_p(19,fpout,&parity);         /* Header len */
                writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */
                parity=0;
                writebyte_p(3,fpout,&parity);          /* Filetype (Code) */
            /* Deal with the filename */
                if (strlen(blockname) >= 10 ) {
                    strncpy(name,blockname,10);
                } else {
                    strcpy(name,blockname);
                    strncat(name,"$         ",10-strlen(blockname));
                }
                for  (i=0;i<=9;i++)
                    writebyte_p(name[i],fpout,&parity);
                
                writeword_p(j,fpout,&parity);
                writeword_p(16384,fpout,&parity);        /* load address */
                writeword_p(0,fpout,&parity);          /* offset */
                writebyte_p(parity,fpout,&parity);

            /* Now onto the data bit */
                writeword_p(j+2,fpout,&parity);      /* Length of next block */
                
                parity=0;
                writebyte_p(255,fpout,&parity);        /* Data is a type 255 block */
                for (i=0; i<j;i++) {
                    c=getc(fpmerge);
                    writebyte_p(c,fpout,&parity);
                }
                writebyte_p(parity,fpout,&parity);

                fclose (fpmerge);
            }
        
        /* M/C program */

        if (!noheader) {
            /* Write out the code header file */
            writeword_p(19,fpout,&parity);         /* Header len */
            writebyte_p(0,fpout,&parity);          /* Header is a type 0 block */
            parity=0;
            writebyte_p(3,fpout,&parity);          /* Filetype (Code) */

            /* Deal with the filename */
            if (strlen(blockname) >= 10 ) {
                strncpy(name,blockname,10);
            } else {
                strcpy(name,blockname);
                strncat(name,"          ",10-strlen(blockname));
            }
            for (i=0;i<=9;i++)
                writebyte_p(name[i],fpout,&parity);
            writeword_p(len,fpout,&parity);
            writeword_p(pos,fpout,&parity);        /* load address */
            writeword_p(0,fpout,&parity);          /* offset */
            writebyte_p(parity,fpout,&parity);
        }

        /* Now onto the data bit */
            writeword_p(len+2,fpout,&parity);      /* Length of next block */
                
            parity=0;
            writebyte_p(255,fpout,&parity);        /* Data is a type 255 block */
            for (i=0; i<len;i++) {
                c=getc(fpin);
                writebyte_p(c,fpout,&parity);
            }
            writebyte_p(parity,fpout,&parity);
        }
        fclose(fpin);
        fclose(fpout);
    }

    /* ***************************************** */
    /*  Now, if requested, create the audio file */
    /* ***************************************** */
    if ( audio ) {
        if ( (fpin=fopen(filename,"rb") ) == NULL ) {
            fprintf(stderr,"Can't open file %s for wave conversion\n",filename);
            myexit(NULL,1);
        }

        if (fseek(fpin,0,SEEK_END)) {
           fclose(fpin);
           myexit("Couldn't determine size of file\n",1);
        }
        len=ftell(fpin);
        fseek(fpin,0L,SEEK_SET);

        strcpy(wavfile,filename);
        suffix_change(wavfile,".RAW");
        if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
            fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
            myexit(NULL,1);
        }

        blockcount = 0;
        if (noloader) blockcount = 2;
        
        if ((ts2068) && (pos >= 33000))
            blockcount-=4;

        /* leading silence */
        for (i=0; i < 0x500; i++)
            fputc(0x80, fpout);

            /* Data blocks */
        while (ftell(fpin) < len) {
          blockcount++;
          blocklen = (getc(fpin) + 256 * getc(fpin));
          if (dumb) {
            if (blocklen==19)
                printf("\n  Header found: ");
            else
                printf("\n  Block found, length: %d Byte(s) ",blocklen);
          }

          if (dumb || !turbo || ((blockcount != 3) && (blockcount != 5))) {        /* byte block headers must be ignored in turbo mode */

              if (turbo && (dumb || (blockcount==4) || (blockcount==6))) {             /* get rid of the first byte in the data block if in turbo mode */
                    c=getc(fpin);
                    blocklen-=2; 	/* and of the parity byte too ! */
                    }

              if (turbo && ((blockcount == 4) || (blockcount == 6)))
                zx_pilot(500,fpout);
              else
                zx_pilot(2500,fpout);

              c=-1;
              warping=FALSE;

              for (i=0; (i < blocklen); i++) {
                d=c;
                c=getc(fpin);

                if ( (dumb) && (blocklen==19) && (c>=32) && (c<=126) && (i>1) && (i<12) )
                    printf("%c",c);

                if (turbo && (dumb || (blockcount==4) || (blockcount==6))) {
                    if (extreme) {
                        if (d==c) {
                            if (!warping) {
                                warping = TRUE;
                                //zx_rawbit(fpout, tperiod2);
                                zx_rawbit(fpout, tperiod1);
                                zx_rawbit(fpout, tperiod0);
                            } else
                                zx_rawbit(fpout, tperiod0);
                        } else {
                            if (warping) {
                                //zx_rawbit(fpout, tperiod1);
                                turbo_one(fpout);
                                warping = FALSE;
                            }
                            turbo_rawout(fpout,c);
                        }
                    } else
                        turbo_rawout(fpout,c);
                } else
                    zx_rawout(fpout,c,fast);
            }
          } else
              for (i=0; (i < blocklen); i++)		/* Skip the block we're excluding */
                c=getc(fpin);

          if ((turbo && (blockcount == 4) || (blockcount == 6) ) || (turbo && dumb)) {
                //zx_rawout(fpout,1,fast);
                zx_rawbit(fpout, tperiod0);
                zx_rawbit(fpout, 75);
                c=getc(fpin);	/* parity byte must go away */
            }

          if (dumb) printf("\n");
        }

        /* trailing silence */
        for (i=0; i < 0x500; i++)
            fputc(0x80, fpout);

        fclose(fpin);
        fclose(fpout);
        
        /* Now let's think at the WAV format */
        raw2wav(wavfile);
    }

    return 0;
}

