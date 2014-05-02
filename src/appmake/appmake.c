/*
 *
 *   z88dk Application Generator (appmake)
 *
 *   This file contains the driver and routines used by multiple
 *   modules
 * 
 *   $Id: appmake.c,v 1.22 2014-05-02 09:46:24 stefano Exp $
 */

#define MAIN_C
#include "appmake.h"

#if (__GNUC__ || _BSD_SOURCE || _SVID_SOURCE || _XOPEN_SOURCE >= 500)
#define mktempfile(a) close(mkstemp(a))
#else
#define mktempfile(a) mktemp(a)
#endif


static char         chain_temp_filename[FILENAME_MAX+1];
static char        *program_name = NULL;

static void         main_usage(void);
static void         execute_command(char *target, int argc, char **argv, int chainmode);
static void         set_option_by_type(option_t *options, type_t type, char *value);
static int          option_parse(int argc, char *argv[], option_t *options);
static int          option_set(int pos, int max, char *argv[], option_t *opt);
static void         option_print(char *execname, char *ident, char *copyright, char *desc, char *longdesc, option_t *opts);
static void         get_temporary_filename(char *filen);


int main(int argc, char *argv[])
{
    int     i;
    int     ac;
    char  **av;
    char   *ptr;
    char   *target = NULL;
    
    chain_temp_filename[0] = 0;
    
    /* If we're called by the name of one of the subprograms, that's the one we are */
    i = 0;
    while (machines[i].execname ) {
        if ( ( ptr = strstr(argv[0],machines[i].execname )  ) &&
             ( *(ptr + strlen(machines[i].execname) ) == '.' || *(ptr + strlen(machines[i].execname) ) == '\0' ) ) {
            target = machines[i].ident;  
            execute_command(target, argc, argv, 0);
            exit(0);
        }
        i++;
    }

    /* So, let's check for + style execution */
    av = calloc(argc,sizeof(char*));
    ac = 0;
    
    for ( i = 0; i < argc; i++ ) {
        if ( argv[i][0] == '+' ) {
            if ( target != NULL ) {
                execute_command(target, ac, av, 1);
            }
            target = &argv[i][1];
            ac = 0;
        } else {
            av[ac] = argv[i];
            ac++;
        }
    }
    
    if ( target == NULL ) {
        main_usage();
    }
    
    execute_command(target, ac, av, 2);

    exit(0);
}

static void execute_command(char *target, int argc, char **argv, int chainmode)
{
    int   i;
    char  output_file[FILENAME_MAX+1];
    
    i = 0;
    while (machines[i].ident ) {
        if ( strcmp(target,machines[i].ident) == 0 ) {
            option_parse(argc,argv,machines[i].options);
            program_name = target;
            if ( chainmode ) {
                /* Chained command, if we had a previous output, that's our input file for this stage */
                if ( strlen(chain_temp_filename) ) {
                    set_option_by_type(machines[i].options, OPT_STR|OPT_INPUT, chain_temp_filename);
                }
                /* Now, let's create a new temporary output file (but not if last in chain) */
                if ( chainmode == 1 ) {
                    get_temporary_filename(output_file);
                    set_option_by_type(machines[i].options, OPT_STR|OPT_OUTPUT, output_file);
                }
            }
            
            if ( machines[i].exec(target, machines[i].ident) == -1 ) {
                if ( strlen(chain_temp_filename) ) {
                    remove(chain_temp_filename);
                }
                option_print(machines[i].execname, machines[i].ident,machines[i].copyright, machines[i].desc, machines[i].longdesc, machines[i].options);
                exit(1);
            }
            if ( strlen(chain_temp_filename) ) {
                printf("%d\n",remove(chain_temp_filename));
            }
            if ( chainmode == 1 ) {
                strcpy(chain_temp_filename, output_file);
            }
            program_name = NULL;
            return;            
        }
        i++;
    }

    fprintf(stderr,"Unknown machine target \"%s\"\n\n",target);
    main_usage();  /* Never returns */
}


/* Useful functions used by many targets */
void exit_log(int code, char *fmt, ...)
{
    va_list  ap;
    
    va_start(ap, fmt);
    if ( fmt != NULL ) {
        if ( program_name ) {
            fprintf(stderr, "%s: ", program_name);
        }
        vfprintf(stderr, fmt, ap);
    }
    va_end(ap);
    exit(code);
}


/* Search through debris from z80asm for some important parameters */
long parameter_search(char *filen, char *ext,char *target)
{
    char    name[FILENAME_MAX+1];
    char    buffer[LINEMAX+1];
    long    val=-1;
    FILE    *fp;

    if (filen == NULL) {
        myexit("CRT file name not specified (not z88dk compiled?)\n",1);
    }
    /* Create the filename very quickly */
    strcpy(name,filen);
    strcat(name,ext);
    if ( (fp=fopen(name,"r"))==NULL) {
        sprintf(name,"Cannot open %s%s\n",filen,ext);
        myexit(name,1);
    }
    
     /* Successfully opened the file so search through it.. */
    while ( fgets(buffer,LINEMAX,fp) != NULL ) {
        if      (strncmp(buffer,target,strlen(target)) == 0 ) {
            sscanf(buffer,"%s%s%lx",name,name,&val);
            break;
        }
    }
    fclose(fp);
    return(val);
}






/* Generic change suffix routine - make sure name is long enough to hold the suffix */
void suffix_change(char *name, char *suffix)
{
    int     j;
    j = strlen(name)+1;
    while ( j && name[j-1] != '.' ) 
        j--;

    if ( j)
        name[j-1]='\0';

    strcat(name,suffix);
}

/* Print the overall usage information */
void main_usage(void)
{
    int   i;

    fprintf(stderr,"appmake [+target] [options]\n\n");
    fprintf(stderr,"The z88dk application generator\n\n");
    fprintf(stderr,
            "This program is used to produce files which are suitable for use in\n"
            "emulators or on the real hardware. ");

    fprintf(stderr,"Supported targets are:\n\n");
    i = 0;
    while (machines[i].ident ) {
        fprintf(stderr,"+%-12s (%-8s) - %s\n",machines[i].ident,machines[i].execname,machines[i].copyright);
        i++;
    }
    fprintf(stderr,"\nFor more usage information use +[target] with no options\n");
  
    exit(1);
}


static void set_option_by_type(option_t *options, type_t type, char *value)
{
    char  *arr[2];
    
    arr[1] = value;
    
    do {
        if ( options->type == type ) {
            option_set(0, 2, arr, options);
            return;
        }
        options++;
    } while ( options->type != OPT_NONE );
    
    exit_log(1,"Cannot set option of type %s for chained command\n",type & OPT_INPUT ? "input" : "output");
}

/* Parse the options - NB. by this stage all options beginning with +
 *  have been parsed out
 */
int option_parse(int argc, char *argv[], option_t *options)
{
    int     i;
    option_t *opt;

    for ( i = 0 ; i < argc; i++ ) {
        if ( argv[i][1] && argv[i][0] == '-' ) {
            opt = options;
            do {
                if ( opt->sopt && argv[i][2] == 0 && argv[i][1] == opt->sopt ) {
                    i = option_set(i,argc,argv,opt);
                    break;
                } else if ( opt->lopt && argv[i][0] == '-' && argv[i][1] == '-' && strcmp(&argv[i][2],opt->lopt) == 0 ) {
                    i = option_set(i,argc,argv,opt);
                    break;   
                }                
                opt++;
            } while ( opt->type != OPT_NONE );
        }
    }    
    return 0;
}


static int option_set(int pos, int max, char *argv[], option_t *option)
{
    int     val;
    int     ret;

    switch ( option->type & OPT_BASE_MASK) {
    case OPT_BOOL:
        *(char *)(option->dest) = TRUE;
        ret = pos;
        break;
    case OPT_INT:
        if ( pos + 1 < max ) {
            val = atoi(argv[pos+1]);
            *(int *)(option->dest) = val;
            ret = pos + 1;
        }
        break;
    case OPT_STR:
        if ( pos + 1 < max ) {
            *(char **)(option->dest) = strdup(argv[pos+1]);
            ret = pos + 1;
        }
        break;
    case OPT_NONE:
        break;
    }
    return ret;
}


static void option_print(char *execname, char *ident, char *copyright, char *desc, char *longdesc, option_t *opts)
{
    option_t *opt = opts;
    char      optstr[4];

    fprintf(stderr,"appmake +%s (%s)\n\n%s\n",ident,execname,copyright);

    if ( desc && strlen(desc) )
        fprintf(stderr,"\n%s\n",desc);
        
    if ( longdesc && strlen(longdesc) )
        fprintf(stderr,"\n%s",longdesc);
        
    fprintf(stderr,"\nOptions:\n\n");
    while ( opt->type != OPT_NONE ) {
        if ( opt->sopt ) {
            sprintf(optstr,"-%c",opt->sopt);
        } else {
            sprintf(optstr,"  ");
        }
        switch ( opt->type & OPT_BASE_MASK ) {
        case OPT_BOOL:
            fprintf(stderr,"%s   --%-15s (bool)    %s\n",optstr,opt->lopt,opt->desc);
            break;
        case OPT_INT:
            fprintf(stderr,"%s   --%-15s (integer) %s\n",optstr,opt->lopt,opt->desc);
            break;
        case OPT_STR:
            fprintf(stderr,"%s   --%-15s (string)  %s\n",optstr,opt->lopt,opt->desc);
            break;
        case OPT_NONE:
            break;
        }
        opt++;
    }
}


/* Writing routines */
void writebyte(unsigned char c, FILE *fp)
{
        fputc(c,fp);
}

void writeword(unsigned int i, FILE *fp)
{
    fputc(i%256,fp);
    fputc(i/256,fp);
}

void writestring(char *mystring, FILE *fp)
{
	int  c;
	
	for (c=0; c < strlen(mystring); c++) {
		writebyte(mystring[c],fp);
	}
}

void writelong(unsigned long i, FILE *fp)
{
    writeword(i%65536,fp);
    writeword(i/65536,fp);
}

void writeword_p(unsigned int i, FILE *fp,unsigned char *p)
{
    writebyte_p(i%256,fp,p);
    writebyte_p(i/256,fp,p);
}

/* Parity in kansas-city mode (Sorcerer Exidy) */
void writeword_pk(unsigned int i, FILE *fp,unsigned char *p)
{
    writebyte_pk(i%256,fp,p);
    writebyte_pk(i/256,fp,p);
}

/* Parity in checksum mode (Spectrum, Newbrain..) */
void writebyte_p(unsigned char c, FILE *fp,unsigned char *p)
{
    fputc(c,fp);
    *p^=c;
}

/* Parity in kansas-city mode (Sorcerer Exidy) */
void writebyte_pk(unsigned char c, FILE *fp,unsigned char *p)
{
	unsigned char a,b;
	
    fputc(c,fp);
    *p=0xff^(c-*p);
}

void writestring_p(char *mystring, FILE *fp,unsigned char *p)
{
    int  c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_p(mystring[c],fp,p);
    }
}

void writestring_pk(char *mystring, FILE *fp,unsigned char *p)
{
    int  c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_pk(mystring[c],fp,p);
    }
}

void writebyte_cksum(unsigned char c, FILE *fp, unsigned long *cksum)
{
    *cksum += (unsigned int) c;
    fputc(c,fp);
}

void writeword_cksum(unsigned int i, FILE *fp, unsigned long *cksum)
{
    writebyte_cksum(i%256,fp,cksum);
    writebyte_cksum(i/256,fp,cksum);
}

/* Add the WAV header to a 44100 Khz RAW sound file */
void raw2wav(char *wavfile)
{
	char    rawfilename[FILENAME_MAX+1];
	FILE    *fpin, *fpout;
	int		c;
	long	i, len;
	
	strcpy(rawfilename,wavfile);
	
	if ( (fpin=fopen(wavfile,"rb") ) == NULL ) {
		fprintf(stderr,"Can't open file %s for wave conversion\n",wavfile);
		myexit(NULL,1);
	}
	if (fseek(fpin,0,SEEK_END)) {
	   fclose(fpin);
	   myexit("Couldn't determine size of file\n",1);
	}
	len=ftell(fpin);
	fseek(fpin,0L,SEEK_SET);
	suffix_change(wavfile,".wav");
	if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
		fprintf(stderr,"Can't open output raw audio file %s\n",wavfile);
		myexit(NULL,1);
	}

	/* Now let's think at the WAV file */
	writestring("RIFF",fpout);

	writelong(len+63,fpout);

	writestring("WAVEfmt ",fpout);
	writelong(0x10,fpout);
	writeword(1,fpout);
	writeword(1,fpout);
	writelong(44100,fpout);
	writelong(44100,fpout);
	writeword(1,fpout);
	writeword(8,fpout);
	writestring("data",fpout);
	
	writelong(len,fpout);
	
	for (i=0; i<63;i++) {
	  fputc(0x20,fpout);
	}
	/*
	//writestring(wav_table,fpout);
	for (i=0; i<28;i++) {
	  fputc(0x20,fpout);
	}
	*/

	for (i=0; i<len;i++) {
	  c=getc(fpin);
	  fputc(c,fpout);
	}
	
	fclose(fpin);
	fclose(fpout);

	remove (rawfilename);
}

/* Pilot lenght in standard mode is about 2000 */
void zx_pilot(int pilot_len, FILE *fpout)
{
  int i,j;

  /* First a short gap.. */
  for (i=0; i < 200; i++)
    fputc (0x80,fpout);

  /* Then the beeeep */
  for (j=0; j<pilot_len; j++) {
    for (i=0; i < 27; i++)
	  fputc (0x20,fpout);
    for (i=0; i < 27; i++)
	  fputc (0xe0,fpout);
  }

  /* Sync */
  for (i=0; i < 8; i++)
	fputc (0x20,fpout);
  for (i=0; i < 8; i++)
	fputc (0xe0,fpout);
}

void zx_rawbit(FILE *fpout, int period)
{
  int i;

  for (i=0; i < period; i++)
	fputc (0x20,fpout);
  for (i=0; i < period; i++)
	fputc (0xe0,fpout);
}

void zx_rawout (FILE *fpout, unsigned char b, char fast)
{
  static unsigned char c[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
  int i,period;

  for (i=0; i < 8; i++)
  {
    if (b & c[i])
	  /* Experimental MIN limit is 17 */
	  if ( fast ) period = 19; else period = 22;
	  //period = 22;
    else
      /* Experimental MIN limit is 7 */
      if ( fast ) period = 9; else period = 11;
      //period = 11;

    zx_rawbit(fpout, period);
  }
}

int hexdigit(char digit) {
    if (digit >= 'A' && digit <= 'F') {
        return digit - 'A' + 10;
    } else if (digit >= 'a' && digit <= 'f') {
        return digit - 'a' + 10;
    } else if (digit >= '0' && digit <= '9') {
        return digit - '0';
    }

	fprintf(stderr,"\nError in patch string\n");
	myexit(NULL,1);
	return 0; /* Not reached */
}



static void get_temporary_filename(char *filen)
{
#ifdef _WIN32
    char           *ptr;

    /* Predefined in 32-bit MS Visual C/C++ and Borland Builder C/C++ */
    if (ptr = getenv("TEMP")) {    /* Under Windows 95 usually
                     * C:\WINDOWS\TEMP */
        strcpy(filen, ptr);    /* Directory is not guaranteed to
                     * exist */
        tmpnam(filen + strlen(filen));    /* Adds strings like
                         * "\s3vvrm3t.",
                         * "\s3vvrm3t.1",
                         * "\s3vvrm3t.2" */
    } else
        tmpnam(filen);
    if (ptr = strrchr(filen, '.'))
        *ptr = '_';
#elif defined(__MSDOS__) && defined(__TURBOC__)
    /* Both predefined by Borland's Turbo C/C++ and Borland C/C++ */

    if (ptr = getenv("TEMP")) {    /* From MS-DOS 5, C:\TEMP, C:\DOS,
                     * C:\WINDOWS\TEMP or whatever or
                     * nothing */
        strcpy(filen, ptr);    /* Directory is not guaranteed to
                     * exist */
        strcat(filen, "\\");
        tmpnam(filen + strlen(filen));    /* Adds strings like
                         * TMP1.$$$, TMP2.$$$ */
    }
     /* Allways starts at TMP1.$$$. Does not */ 
    else            /* check if file already exists. So is  */
        tmpnam(filen);    /* not suitable for executing zcc more  */
    if (ptr = strrchr(filen, '.'))    /* than once without cleaning out
                     * files. */
        *ptr = 0;    /* Don't want to risk too long filenames */

#else
    strcpy(filen, "/tmp/appmakechainXXXXXXXX");
    mktempfile(filen);
#endif
}

