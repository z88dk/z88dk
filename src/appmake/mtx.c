/*
 *      Memotech MTX application packager
 *      
 *      $Id: mtx.c,v 1.13 2016-06-26 00:46:55 aralbrec Exp $
 */


#include "appmake.h"



static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              audio        = 0;
static char              fast         = 0;
static char              mtb          = 0;
static char              dumb         = 0;
static char              loud         = 0;
static char              help         = 0;

static char              mtx_h_lvl;
static char              mtx_l_lvl;


/* Options that are available for this module */
option_t mtx_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &fast },
    {  0,  "mtb",      "MTB output file mode",       OPT_BOOL,  &mtb },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0,  "loud",     "Louder audio volume",        OPT_BOOL,  &loud },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};


/* two fast cycles for '0', two slow cycles for '1' */

void mtx_bit (FILE *fpout, unsigned char bit)
{
	int i, period0, period1;

	if ( fast ) {
		period1 = 5;	/* Jim Willis says the speed limit is 3 */
		period0 = 16;	/* .. and 13 */
	} else {
		period1 = 9;
		period0 = 18;
	}

	if (bit) {
		/* '1' */
		  for (i=0; i < period0; i++)
			fputc (mtx_l_lvl,fpout);
		  for (i=0; i < period0; i++)
			fputc (mtx_h_lvl,fpout);
	} else {
		/* '0' */
		  for (i=0; i < (period1); i++)
			fputc (mtx_l_lvl,fpout);
		  for (i=0; i < (period1); i++)
			fputc (mtx_h_lvl,fpout);
	}
}


void mtx_rawout (FILE *fpout, unsigned char b)
{
  /* bit order is reversed ! */
  static unsigned char c[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
  int i;

  /* byte */
  for (i=0; i < 8; i++)
		mtx_bit (fpout, (b & c[i]));
}

void mtx_leader (FILE *fpout)
{
	int i;

	/* leader tone (bit 0 repeated 1500 times) */
	for (i=0; (i < 9); i++)      /* pre-leader short extra delay */
		fputc(mtx_l_lvl, fpout);
	for (i=0; i < 1500; i++)     /* leader tone */
		mtx_bit (fpout,0);
	for (i=0; (i < 9); i++)      /* close leader (invert phase) */
		fputc(mtx_l_lvl, fpout);
	for (i=0; (i < 27); i++)     /* GAP to switch to data mode */
		fputc(mtx_h_lvl, fpout);
}


/*
 * Execution starts here
 */

int mtx_exec(char *target)
{
    char    filename[FILENAME_MAX+1];
    char    wavfile[FILENAME_MAX+1];
    unsigned char    *sys_vars;
    char    name[16];
    char    mybuf[20];
    FILE   *fpin;
    FILE   *fpout;
    int     len, prglen, rampos;
    long    pos;
    int     c,i;

    unsigned int       stklim;
    unsigned int       varblklen,calcst,varnam,prgblklen;

    if ( help )
        return -1;

    if ( binname == NULL || (!dumb && ( crtfile == NULL && origin == -1) ) ) {
        return -1;
    }

	if (loud) {
		mtx_h_lvl = 0xFF;
		mtx_l_lvl = 0;
	} else {
		mtx_h_lvl = 0xe0;
		mtx_l_lvl = 0x20;
	}


	if (dumb) {
		strcpy(filename,binname);

	} else {
		if ( outfile == NULL ) {
			strcpy(filename,binname);
			if (mtb)
			  suffix_change(filename,".mtb");
			else
			  suffix_change(filename,"");
		} else {
			strcpy(filename,outfile);
		}
		
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
		writebyte(0xFF,fpout);

		/* Non-MTB FORMAT HEADER STYLE */
		if (!mtb) {

			/* Deal with the filename */
			strcpy(name,"               ");
			for (i=0;(i<=14)&&(isalnum(filename[i]));i++)
				name[i]=toupper(filename[i]);

			for (i=0;i<=14;i++)
				writebyte(name[i],fpout);
		}

		writeword(0xF8F2,fpout);
		
		/* MTB FORMAT Signature */
		if (mtb) {
			writeword(0x0259,fpout);
		}

		if (pos<0x8000)
			rampos=0x4000;
		else
			rampos=0x8000;

		prglen=len+20;


/* $0 ($F8F2)*/
		for	(i=1;i<=(353);i++)
			writebyte(0,fpout);

/* $161 ($FA53) */
		/* stklim */
		writeword(0xF8F2,fpout);
		writebyte(0x02,fpout);

		for (i=1;i<=7;i++)
			writebyte(0,fpout);

		writebyte(0x0A,fpout);
		writebyte(0xf9,fpout);
		writebyte(0x02,fpout);
		
		for (i=1;i<=7;i++)
			writebyte(0,fpout);

		writebyte(0x22,fpout);
		writebyte(0xf9,fpout);
		writebyte(0x02,fpout);

		for (i=1;i<=7;i++)
			writebyte(0,fpout);
		writebyte(0x3A,fpout);
		writebyte(0xf9,fpout);
		writebyte(0x02,fpout);

		for (i=1;i<=6;i++)
			writebyte(0,fpout);

		writebyte(0,fpout);			/* $FA7A - flag ? (1 or 0) */

/* $188 ($FA7A) */
		writeword(0xC000,fpout);	/* $FA7B - VARNAM */
		writeword(0xC001,fpout);
		writeword(0xC001,fpout);
		writeword(0xC001,fpout);	/* $FA81 - CALCST */

		writeword(0xFB4B,fpout);	/* $FA83 - points to stklim */
		
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0xc9,fpout);
		writebyte(0xc9,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(1,fpout);

		writebyte(0xFF,fpout);     /* $FA90 */
		writebyte(0x80,fpout);     /* $FA91 flag ? ($80 or $A0) */

		writeword(0xF8F2,fpout);   /* $FA92 - STKLIM */
		writeword(0xFB4F,fpout);   /* $FA94 - SYSTOP */
		writeword(0xFD48,fpout);   /* $FA96 */

		writebyte(0xc9,fpout);     /* $FA98 */
		writeword(0,fpout);
		writebyte(0xc9,fpout);     /* $FA9B */
		writeword(0,fpout);
		writebyte(0xc9,fpout);     /* $FA9E */
		writeword(0,fpout);
		writebyte(0xc9,fpout);     /* $FAA1 */
		writeword(0,fpout);

		writeword(rampos+prglen,fpout);   /* $FAA4 - Top of BASIC */
		writebyte(0,fpout);

		writeword(rampos+prglen,fpout);   /* $FAA7 - Top of Noddy  */
		writebyte(0,fpout);

		/* writeword(rampos,fpout); */          /* $FAAA - bottom of BASIC*/
		writeword(0x4000,fpout);          /* $FAAA - bottom of BASIC*/
		
		writeword(rampos+prglen,fpout);   /* $FAAC */

		for (i=1;i<=30;i++)
			writebyte(0,fpout);

/* $1da */
		writeword(prglen,fpout);	/* $FACC 0c 00 */
		writeword(0,fpout);			/* $FACE ?? 0c 00 <> 00 00 */
		writeword(rampos,fpout);	/* $FAD0 ?? 0c 00 <> 80 00 */

		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		
		writeword(rampos+prglen,fpout);   /* $FAD6 - Top of page */

/* (fad8) */
		for (i=1;i<=105;i++)
			writebyte(0,fpout);

/* $24f ($FB41) - 361*/
		writeword(0xFAD8,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writebyte(0,fpout);
		writeword(rampos,fpout);
		writebyte(0x80,fpout);
		
		
/* $257 ($fb49)*/
		writeword(0xfb52,fpout);	/* $FB49 - next position in program to be interpreted by BASIC */
									/* set to $fb52 if no autorun */


/* PROGRAM BLOCK */

		pos=rampos+19;
		
		writeword(14,fpout);
		writeword(10,fpout);       /* 10   */
		writebyte(0xAE, fpout);    /* RAND */
		writebyte(0xEB, fpout);    /* USR  */
			sprintf(mybuf,"(%i)",(int)pos);    /* Location for USR, should always be 5 digits long */
		for ( i = 0; i < 7; i++)
			writebyte(mybuf[i],fpout);
		writebyte(0xff,fpout);

		writeword(6+len,fpout);
		writeword(20,fpout);       /* 20   */
		writebyte(0x80, fpout);    /* REM  */
		for ( i = 0; i < len; i++) {
			c = getc(fpin);
			writebyte(c,fpout);
		}
		writebyte(0xff,fpout);


/* VARIABLES BLOCK */
		writebyte(0xff,fpout);

/*

A different loader scheme could rely on an extra block
(can be simply appended at the end)
The basic block must contain the following instructions:

:       LD HL,<location>
:       LD DE,<length>
:       XOR A
:       LD (FD67h),A
:       INC A
:       LD (FD68h),A
:       CALL 0AAEh
:		CALL/JP <location>

*/

		fclose(fpin);
		fclose(fpout);
	}

	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
	if (( audio ) || ( fast ) || (loud)) {
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

		c=getc(fpin);
		ungetc(c,fpin);
		if (!mtb && c!=0xff) {
			fprintf(stderr,"MTX file not valid for WAV conversion.\n");
			fclose(fpin);
			fclose(fpout);
			myexit(NULL,1);
		}

		/* leading silence */
		for (i=0; i < 0x10000; i++)
			fputc(0x80, fpout);

		/* HEADER */
		if (mtb) {
			/* If mtb format, set stklim and build the missing header */
			if (dumb) printf("\nInfo: building header for mtb.  Assigning Program Name: ");
			mtx_leader(fpout);
			mtx_rawout(fpout,0xFF);

			/* Deal with the filename */
			strcpy(name,"               ");
			for (i=0;(i<=14)&&(isalnum(filename[i]));i++)
				name[i]=toupper(filename[i]);
			for (i=0;i<=14;i++) {
				mtx_rawout(fpout,name[i]);
				if (dumb) printf("%c",name[i]);
			}
			if (dumb) printf("\n\n");
			/* pick stklim while copying to header */
			c=getc(fpin);
			mtx_rawout(fpout,c);
			stklim=c;
			c=getc(fpin);
			mtx_rawout(fpout,c);
			stklim+=c*256;
			c=getc(fpin)+256*getc(fpin);
			if (dumb) printf("Info: mtb extra word is $%x\n\n",c);
			len=len-4;

		} else {
			
			/* Copy the header */
			if (dumb) printf("\nInfo: Program Name found in header: ");
			mtx_leader(fpout);
			for (i=0; (i < 16); i++) {
				c=getc(fpin);
				if (dumb) printf("%c",c);
				mtx_rawout(fpout,c);
			}
			if (dumb) printf("\n\n");
			/* pick stklim while copying to header */
			c=getc(fpin);
			mtx_rawout(fpout,c);
			stklim=c;
			c=getc(fpin);
			mtx_rawout(fpout,c);
			stklim+=c*256;
			len=len-18;

		}
		
		/* Put two extra foo trailing bytes in header, as in the original BASIC routine */
		mtx_rawout(fpout,0);
		mtx_rawout(fpout,0);

		/* muted space */
		for (i=0; i < 0x4000; i++)
			fputc(0x20, fpout);	

		
		/* System Variables block */

		varblklen=0xfb4b-stklim;
		
		if (dumb) {
			printf("Stklim: $%x\n",stklim);
			printf("System Variables block length ........... %d byte(s)\n",varblklen);
		}
		sys_vars=malloc(varblklen+2);

		len-=varblklen;

		for (i=0; i<varblklen; i++) {
			if (i%16384 == 0) mtx_leader(fpout);
			c=getc(fpin);
			sys_vars[i]=c;
			mtx_rawout(fpout,c);
		}
		
		calcst=sys_vars[0xfa81-stklim]+256*sys_vars[0xfa82-stklim];
		varnam=sys_vars[0xfa7b-stklim]+256*sys_vars[0xfa7c-stklim];
		varblklen=calcst-varnam;
		len-=varblklen;
		prgblklen=sys_vars[0xfacc-stklim]+256*sys_vars[0xfacd-stklim];
		len-=prgblklen;
		if (dumb) {
			if ((0xf8f2+varblklen) > 0xfd65)
				printf("$FD65 (prg block position): $%x\n",sys_vars[0xfd65-stklim]+256*sys_vars[0xfd66-stklim]);
			printf("$FACC (prg block length) ................ %d byte(s)\n",prgblklen);
			printf("$FA81 (CALCST): $%x\n",calcst);
			printf("$FA7B (VARNAM): $%x\n",varnam);
			printf("Variables block length .................. %d byte(s)\n",varblklen);
			printf("Extra data: %d byte(s)",len);
			if (len>0) printf(", creating one more block");
			printf("\n");
		}

		/* program block */

		if (prgblklen > 0) {
			for (i=0; i<prgblklen;i++) {
				if (i%16384 == 0) mtx_leader(fpout);
				c=getc(fpin);
				mtx_rawout(fpout,c);
			}
			/* if (c != 0xff) printf("\nInfo: last byte prg block is not $FF\n\n"); */
		}

		if (varblklen > 0) {
			/* BASIC variables block */
			c=getc(fpin);
			ungetc(c,fpin);
			if (c != 0xff) printf("\nWarning: BASIC variables are not marked with $FF\n\n");
			for (i=0; i<varblklen;i++) {
				if (i%16384 == 0) mtx_leader(fpout);
				c=getc(fpin);
				mtx_rawout(fpout,c);
			}
		}

		if (len > 0) {
			/* muted space */
			for (i=0; i < 0x2000; i++)
				fputc(0x20, fpout);	

			/* Extra block */
			for (i=0; i<len;i++) {
				if (i%16384 == 0) mtx_leader(fpout);
				c=getc(fpin);
				mtx_rawout(fpout,c);
			}
		}

		/* trailing silence */
		for (i=0; i < 0x10000; i++)
			fputc(0x20, fpout);

		free(sys_vars);
        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		raw2wav(wavfile);
			
	}  /* END of WAV CONVERSION BLOCK */
	
    return 0;
}



