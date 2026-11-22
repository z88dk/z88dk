/*
 *      PC-8801 application packager
 *      
 *      $Id: pc88.c - Stefano $
 */


#include "appmake.h"
#include "fcntl.h"

/* Binding to functions in nec.c */
extern void nec_rawout (FILE *fpout, unsigned char b);
extern void nec_bit (FILE *fpout, unsigned char bit);
extern char nec_fast;
extern char nec_22;

static char             *binname      = NULL;
static char             *crtfile      = NULL;
static char             *outfile      = NULL;
static int               origin       = -1;
static char              audio        = 0;
static char              dumb         = 0;
static char              help         = 0;

static long              elapsed;


/* Options that are available for this module */
option_t pc88_options[] = {
    { 'h', "help",     "Display this help",          OPT_BOOL,  &help},
    { 'b', "binfile",  "Linked binary file",         OPT_STR,   &binname },
    { 'c', "crt0file", "crt0 file used in linking",  OPT_STR,   &crtfile },
    { 'o', "output",   "Name of output file",        OPT_STR,   &outfile },
    {  0,  "audio",    "Create also a WAV file",     OPT_BOOL,  &audio },
    {  0,  "fast",     "Create a fast loading WAV",  OPT_BOOL,  &nec_fast },
    {  0,  "22",       "22050hz bitrate option",     OPT_BOOL,  &nec_22 },
    {  0,  "dumb",     "Just convert to WAV a tape file",  OPT_BOOL,  &dumb },
    {  0 , "org",      "Origin of the binary",       OPT_INT,   &origin },
    {  0,  NULL,       NULL,                         OPT_NONE,  NULL }
};




void pc88_write_tick(long tick, FILE* fpout)
{
	writelong(elapsed, fpout);	
	writelong(tick, fpout);
	
	elapsed += tick;	
}


void pc88_write_data_tag(int datlen, FILE* fpout)
{
	writeword(0x101, fpout);		/* Data block TAG ID */
	writeword(12 + datlen, fpout);	/* Whole TAG len */
	/* 1200 baud: actual data number of bytes × 44 
	    600 baud: actual data number of bytes × 88 */
	pc88_write_tick(44 * datlen, fpout);
	writeword(datlen, fpout);
	
	writeword(0x01cc, fpout);		/*  00CCH (600baud) or 01CCH (1200baud). */
}



long getlong (FILE *fpin)
{
	return (fgetc(fpin)+256*fgetc(fpin)+65536*fgetc(fpin)+16777216*fgetc(fpin));
}


/*
 * Execution starts here
 */

int pc88_exec(char* target)
{
    char filename[FILENAME_MAX + 1];
    char wavfile[FILENAME_MAX+1];
    char name[10];
    char buf[25];
    FILE* fpin;
    FILE* fpout;
    int len, len2;
    long pos;
    unsigned long checksum, ticks;
    int i, j;

    if (help)
        return -1;

    if (binname == NULL || (!dumb && (crtfile == NULL && origin == -1))) {
        return -1;
    }

	
	/* Creating the ".T88" file */
	
    if (dumb)
        strcpy(filename, binname);
	
	else {
		
        if (outfile == NULL) {
            strcpy(filename, binname);
                suffix_change(filename, ".t88");
        } else {
            strcpy(filename, outfile);
        }

        if (strcmp(binname, filename) == 0) {
            exit_log(1,"Input and output file names must be different\n");
        }

        if (origin != -1) {
            pos = origin;
        } else {
            if ((pos = get_org_addr(crtfile)) == -1) {
                exit_log(1,"Could not find parameter ZORG (not z88dk compiled?)\n");
            }
        }

        if ((fpin = fopen_bin(binname, crtfile)) == NULL) {
            exit_log(1, "Can't open input file %s\n", binname);
        }

        if (fseek(fpin, 0, SEEK_END)) {
            fclose(fpin);
            exit_log(1, "Couldn't determine size of file\n");
        }

        len = ftell(fpin);

        fseek(fpin, 0L, SEEK_SET);

        if ((fpout = fopen(filename, "wb")) == NULL) {
            fclose(fpin);
            exit_log(1,"Can't open output file\n");
        }
		
		
		elapsed=0;

        /* T88 FILE HEADER */
        writestring("PC-8801 Tape Image(T88)", fpout);
		writebyte(0, fpout);		/* String termination */
		
        /* Version TAG */
		writeword(1, fpout);		/* TAG ID for version */
		writeword(2, fpout);		/* TAG len */
		writeword(0x100, fpout);	/* V.0100 */

        /* Blank space */
		//writeword(0x100, fpout);	/* TAG ID for blank */
		//writeword(8, fpout);		/* TAG len */
		//pc88_write_tick(10000, fpout);
		
        /* LEADER */
		writeword(0x102, fpout);	/* TAG ID for space */
		writeword(8, fpout);		/* TAG len */
		pc88_write_tick(7928, fpout);
		
		/* Filename block leading tone */
		writeword(0x103, fpout);	/* TAG ID for mark */
		writeword(8, fpout);		/* TAG len */
		pc88_write_tick(1320, fpout);

		/* Deal with the filename */
		strcpy(name, "$$$      ");
		for (i = 0; (i < 6) && (isalnum(filename[i])); i++)
			name[i+3] = toupper(filename[i]);
		
		pc88_write_data_tag(9, fpout);
		for (i = 0; i < 9; i++)
			writebyte(name[i], fpout);

		/* Data block leading tone */
		writeword(0x103, fpout);	/* TAG ID for mark */
		writeword(8, fpout);		/* TAG len */
		pc88_write_tick(330, fpout);


		/* Binary block */
		pc88_write_data_tag(len + 7 + 3 * ((len+127)/128), fpout);		/* Total length */
		
		/* Data block with ORG position */
		checksum = 0;
		writebyte(0x3a, fpout);
		writebyte_cksum((unsigned char)(pos >> 8), fpout, &checksum);    // MSB
		writebyte_cksum((unsigned char)(pos & 0xff), fpout, &checksum);  // LSB
		writebyte((0x100 - (checksum & 0xff)) & 0xff, fpout);
		
		len2=128;
		for (i=0; i<len; i+=len2) {
			if ((len-i)<128) len2=len-i;
			writebyte(0x3a, fpout);
			checksum = 0;
			writebyte_cksum(len2, fpout, &checksum);
			for (j = 0; j < len2; j++) {
				writebyte_cksum(getc(fpin),fpout, &checksum);
			}
			writebyte((0x100 - (checksum & 0xff)) & 0xff, fpout);
		}

		writebyte(0x3a, fpout);
		writebyte(0x00, fpout);
		writebyte(0x3a, fpout);	// end

		/* Tail */
		writeword(0x103, fpout);	/* TAG ID for mark */
		writeword(8, fpout);		/* TAG len */
		pc88_write_tick(3966, fpout);
		
		writeword(0x102, fpout);	/* TAG ID for space */
		writeword(8, fpout);		/* TAG len */
		pc88_write_tick(9252, fpout);

		/* End TAG */
		writeword(0, fpout);		/* TAG ID for END */
		writeword(0, fpout);		/* TAG body (no content) */


        fclose(fpin);
        fclose(fpout);
	}

	/* ***************************************** */
	/*  Now, if requested, create the audio file */
	/* ***************************************** */
    if ((audio) || (nec_fast) || (nec_22)) {
		if ( (fpin=fopen(filename,"rb") ) == NULL ) {
			exit_log(1,"Can't open file %s for wave conversion\n",filename);
		}
		
		for (i=0; i<23; i++)
			buf[i]=fgetc(fpin);
		if (strncmp(buf,"PC-8801 Tape Image(T88)",23)) {
            fclose(fpin);
            exit_log(1,"The file to be converted is not in T88 format.\n");
		}
		fgetc(fpin);
		
        strcpy(wavfile,filename);

			suffix_change(wavfile,".RAW");

		if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
			exit_log(1,"Can't open output raw audio file %s\n",wavfile);
		}
		
		while (i!=0) {
			i=fgetc(fpin)+256*fgetc(fpin);
			switch (i)
			{
				case 1:
					fgetc(fpin); fgetc(fpin);
					if (dumb) {
						printf ("T88 file version: ");
						printf ("%X\n",fgetc(fpin)+256*fgetc(fpin));
					} else {
						fgetc(fpin); fgetc(fpin);
					}
					break;
				case 0x100:
					if (dumb)
						printf ("  -Blank- : ");
					fgetc(fpin); fgetc(fpin);	/* TAG length */
					ticks=getlong(fpin);
					if (dumb)
						printf (" elapsed=%0.2f sec., ",(float) ticks / 4800);
					ticks=getlong(fpin);
					if (dumb)
						printf (" ticks=%0.2f sec.\n",(float) ticks / 4800);

					for (i = 0; (i < (int)ticks); i++)	/* duration approximated */
						fputc(0x80, fpout);
					
					break;
				case 0x102:
					if (dumb)
						printf ("  SPACE tone : ");  /* 1200 */
					fgetc(fpin); fgetc(fpin);	/* TAG length */
					ticks=getlong(fpin);
					if (dumb)
						printf (" elapsed=%0.2f sec., ",(float) ticks / 4800);
					ticks=getlong(fpin);
					if (dumb)
						printf (" ticks=%0.2f sec.\n",(float) ticks / 4800);
					
					for (i = 0; (i < ((int)ticks/4)); i++)	/* duration approximated */
						nec_bit(fpout, 0);
					
					break;
				case 0x103:
					if (dumb)
						printf ("  MARK tone : ");	/* 2400 */
					fgetc(fpin); fgetc(fpin);	/* TAG length */
					ticks=getlong(fpin);
					if (dumb)
						printf (" elapsed=%0.2f sec., ",(float) ticks / 4800);
					ticks=getlong(fpin);
					if (dumb)
						printf (" ticks=%0.2f sec.\n",(float) ticks / 4800);
					
					for (i = 0; (i < ((int)ticks/4)); i++)	/* duration approximated */
						nec_bit(fpout, 1);
					
					break;
				case 0x101:
					if (dumb)
						printf ("    Data block : ");
					i=fgetc(fpin)+256*fgetc(fpin);
					if (dumb)
						printf ("TAG length: %d\n",i);
					for (j=1; j<=10; j++) fgetc(fpin);
					j=fgetc(fpin)+256*fgetc(fpin);
					switch (j) {
					case 0x00cc:
						printf ("      600 baud.   WARNING: data will be saved at 1200 bps\n");
						break;
					case 0x01cc:
						if (dumb)
							printf ("      1200 baud\n");
						break;
					default:
						printf ("   WARNING: unexpected value for 'baud rate': 0x%X\n",j);
						break;
					}
					i-=12;
					for (j=1; j<=i; j++)
						nec_rawout(fpout,fgetc(fpin));
					break;
				default:
					if (dumb)
						printf ("TAG type: %X\n",i);
					i=fgetc(fpin)+256*fgetc(fpin);
					if (dumb)
						printf ("TAG len: %X\n",i);
					for (j=1; j<=i; j++) fgetc(fpin);
					break;
			}
		}
        fclose(fpin);
        fclose(fpout);

		/* Now complete with the WAV header */
		if (nec_22)
			raw2wav_22k(wavfile,2);
		else
			raw2wav(wavfile);
	}

    return 0;
}
