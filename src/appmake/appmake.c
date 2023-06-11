/*
 *
 *   z88dk Application Generator (appmake)
 *
 *   This file contains the driver and routines used by multiple
 *   modules
 * 
 *   $Id: appmake.c,v 1.50 2016-08-26 05:35:33 aralbrec Exp $
 */



#define MAIN_C
#include "appmake.h"
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include "../config.h"

#ifndef _MSC_VER
   #include <inttypes.h>
#elif _MSC_VER >= 1900
   // vs2015 or higher
   #include <inttypes.h>
#endif

#if (__GNUC__ || _BSD_SOURCE || _SVID_SOURCE || _XOPEN_SOURCE >= 500)
#include <unistd.h>
#define mktempfile(a) close(mkstemp(a))
#else
#define mktempfile(a) mktemp(a)
#endif


char                c_install_dir[FILENAME_MAX + 1];

static char         chain_temp_filename[FILENAME_MAX+1];
static char        *program_name = NULL;

static void         main_usage(void);
static void         execute_command(char *target, int argc, char **argv, int chainmode);
static void         set_option_by_type(option_t *options, type_t type, char *value);
static int          option_parse(int argc, char *argv[], option_t *options);
static int          option_set(int pos, int max, char *argv[], option_t *opt);
static void         option_print(char *execname, char *ident, char *copyright, char *desc, char *longdesc, option_t *opts);
static void         get_temporary_filename(char *filen);
static void         cleanup_temporary_files(void);

static int          num_temp_files = 0;
static char       **temp_files = NULL;
#ifdef WIN32
static char         tmpnambuf[] = "apmXXXX";
#endif


int main(int argc, char *argv[])
{
    int     i;
    int     ac;
    char  **av;
    char   *ptr;
    char   *target = NULL;

#ifdef WIN32
    /* Randomize temporary filenames for windows */
    snprintf(tmpnambuf, sizeof(tmpnambuf), "apm%04X", ((unsigned int)time(NULL)) & 0xffff);
#endif

    if ((ptr = getenv("ZCCCFG")) != NULL) {
#ifdef WIN32
        snprintf(c_install_dir, sizeof(c_install_dir), "%s\\..\\..\\", ptr);
#else
        snprintf(c_install_dir, sizeof(c_install_dir), "%s/../../", ptr);
#endif
    }

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

    atexit(cleanup_temporary_files);

    /* So, let's check for + style execution */
    av = calloc(argc,sizeof(char*));
    ac = 0;
    
    for ( i = 0; i < argc; i++ ) {
        if ( argv[i][0] == '+' ) {
            if ( target != NULL ) {
                execute_command(target, ac, av, 1);
                ac = 0;
                memset(av, 0, argc * sizeof(char*));
            }
            target = &argv[i][1];
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
    int   i = 0;
    char  output_file[FILENAME_MAX+1];


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
                option_print(machines[i].execname, machines[i].ident,machines[i].copyright, machines[i].desc, machines[i].longdesc, machines[i].options);
                exit(1);
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
long parameter_search(const char *filen,const  char *ext,const char *target)
{
    char    name[FILENAME_MAX+1];
    char    buffer[LINEMAX+1];
    long    val=-1;
    FILE    *fp;

    if (filen == NULL)
        return(-1);

    /* Create the filename very quickly */
    strcpy(name,filen);
    strcat(name,ext);
    if ( (fp=fopen(name,"r"))==NULL) {
//        sprintf(name,"Cannot open %s%s\n",filen,ext);
//        myexit(name,1);
        return -1;
    }

     /* Successfully opened the file so search through it.. */
    while ( fgets(buffer,LINEMAX,fp) != NULL ) {
        if (strncmp(buffer,target,strlen(target)) == 0 && isspace(buffer[strlen(target)])) {
            sscanf(buffer,"%*s%*s%*[ $]%lx", (long unsigned int *) &val);
            break;
        }
    }
    fclose(fp);
    return(val);
}


long get_org_addr(char *crtfile)
{
    long    pos;

    if ((pos = parameter_search(crtfile, ".sym", "__crt_org_code")) == -1)
        if ((pos = parameter_search(crtfile, ".sym", "CRT_ORG_CODE")) == -1)
            if ((pos = parameter_search(crtfile, ".map", "__crt_org_code")) == -1)
                pos = parameter_search(crtfile, ".map", "CRT_ORG_CODE");

    return(pos);
}


/* Check for new c lib build and construct output binary
   Otherwise, try to open the "normal" file.
*/

FILE *fopen_bin(const char *fname,const  char *crtfile)
{
    FILE   *fcode = NULL, *fdata = NULL, *fin = NULL, *fhimem = NULL;
    char    name[FILENAME_MAX+1];
    char    tname[FILENAME_MAX+1];
    char    cmdline[FILENAME_MAX*2 + 128];
    struct  stat st_file1={0};
    struct  stat st_file2={0};
    int     crt_model;
    int     c;

    if (strlen(fname) == 0) return (NULL);

    // Warn if aligned sections are not aligned

    for (c = 0x100; c >= 0x2; c >>= 1)
    {
        int start;

        // data sections

        snprintf(cmdline, sizeof(cmdline), "__data_align_%d_size", c);
        if (parameter_search(crtfile, ".map", cmdline) > 0)
        {
            snprintf(cmdline, sizeof(cmdline), "__data_align_%d_head", c);
            if (((start = parameter_search(crtfile, ".map", cmdline)) & (c - 1)) != 0)
                fprintf(stderr, "Warning: SECTION %*s is not aligned with start address %#x\n", (int)strlen(cmdline) - 5, cmdline, start);
        }

        // bss sections

        snprintf(cmdline, sizeof(cmdline), "__bss_align_%d_size", c);
        if (parameter_search(crtfile, ".map", cmdline) > 0)
        {
            snprintf(cmdline, sizeof(cmdline), "__bss_align_%d_head", c);
            if (((start = parameter_search(crtfile, ".map", cmdline)) & (c - 1)) != 0)
                fprintf(stderr, "Warning: SECTION %*s is not aligned with start address %#x\n", (int)strlen(cmdline) - 5, cmdline, start);
        }
    }

    // Sort out the binary

    strcpy(name, fname);
    suffix_change(name, "_CODE.bin");

    if (stat(name, &st_file2) < 0)
    {
        strcpy(name, fname);
        suffix_change(name, "_COMMON0.bin");
    }

    stat(fname, &st_file1);
  
    if ((stat(name, &st_file2) < 0) || (st_file2.st_mtime < st_file1.st_mtime)) {
        /* classic library */
        fcode = fopen(fname, "rb");
        if ( fcode == NULL ) {
            exit_log(1, "ERROR: File %s not found\n", fname);            
        }
    } else {
        // new c lib compile

        if (st_file1.st_size > 0)
            fprintf(stderr, "WARNING: some code or data may not be assigned to sections.\n");

        fcode = fopen(name, "rb");
        if ( fcode == NULL ) {
            exit_log(1, "ERROR: File %s not found\n", name);            
        }
    }

    if ((crtfile == NULL) || ((crt_model = parameter_search(crtfile,".map", "__crt_model")) == -1))
        crt_model = 0;


    // 0: ram model, complete binary is "*_CODE.bin"

    //if (crt_model == 0) return fcode;

    // form complete binary

    get_temporary_filename(tname);

    if ((fin = fopen(tname, "w+b")) == NULL)
        exit_log(1, "ERROR: Unable to create temporary file in fopen_bin()\n");

    // code portion is copied into complete binary

    while ((c = fgetc(fcode)) != EOF)
        fputc(c, fin);
    fclose(fcode);

    // data portion is appended to complete binary

    strcpy(name, fname);
    suffix_change(name, "_DATA.bin");

    if (crt_model == 1) {
        
        // 1: rom model, complete binary is "*_CODE.bin" + "*_DATA.bin"

        if ((fdata = fopen(name, "rb")) == NULL)
            exit_log(1, "ERROR: File %s not found for a rom model compile\n", name);

    } else if ( crt_model == 2 ) {

        // 2: compressed zx7 rom model, complete binary is "*_CODE.bin" + zx7("*_DATA.bin")

        get_temporary_filename(tname);
        snprintf(cmdline, FILENAME_MAX*2 + 127, "z88dk-zx7 -f %s %s", name, tname);

        if (system(cmdline) != 0)
            exit_log(1, "ERROR: Unable to compress %s\n", name);

        if ((fdata = fopen(tname, "rb")) == NULL)
            exit_log(1, "ERROR: Unable to open compressed data file %s\n", tname);

    } else if ( crt_model == 3 ) {

        // 3: compressed zx0 rom model, complete binary is "*_CODE.bin" + zx0("*_DATA.bin")

        get_temporary_filename(tname);
        snprintf(cmdline, FILENAME_MAX*2 + 127, "z88dk-zx0 -f %s %s", name, tname);

        if (system(cmdline) != 0)
            exit_log(1, "ERROR: Unable to compress %s\n", name);

        if ((fdata = fopen(tname, "rb")) == NULL)
            exit_log(1, "ERROR: Unable to open compressed data file %s\n", tname);

    }

    if ( fdata != NULL ) {
        while ((c = fgetc(fdata)) != EOF)
            fputc(c, fin);
        fclose(fdata);
    }

    // If we have a HIMEM then append it as well
    strcpy(name, fname);
    suffix_change(name, "_HIMEM.bin");
    if ( ( fhimem = fopen(name, "rb")) != NULL ) {
        while ((c = fgetc(fhimem)) != EOF)
            fputc(c, fin);
        fclose(fhimem);
    }


    // return complete binary file

    rewind(fin);
    return fin;
}

int zcc_strrcspn(char *s, char *reject)
{
    int index, i;

    index = 0;

    for (i = 1; *s; ++i)
    {
        if (strchr(reject, *s++))
            index = i;
    }

    return index;
}

/* Generic change suffix routine - make sure name is long enough to hold the suffix */
void suffix_change(char *name, const char *suffix)
{
    int index;

    if ((index = zcc_strrcspn(name, "./\\")) && (name[index - 1] == '.'))
        name[index - 1] = 0;

    strcat(name, suffix);
}

/* Variant for the generic change suffix routine */
void any_suffix_change(char *name, const char *suffix, char suffix_delimiter)
{
    int index;

    static char delim[] = "./\\";

    delim[0] = suffix_delimiter;

    if ((index = zcc_strrcspn(name, delim)) && (name[index - 1] == delim[0]))
        name[index - 1] = 0;

    strcat(name, suffix);
}

void *must_malloc(size_t sz)
{
    void *p;

    if ((p = malloc(sz)) == NULL)
        exit_log(1, "Error: Out of memory\n");
    memset(p, 0, sz);
    
    return p;
}

void *must_realloc(void *p, size_t sz)
{
    void *r;

    if ((r = realloc(p, sz)) == NULL)
        exit_log(1, "Error: Out of memory\n");

    return r;
}

void *must_strdup(char *p)
{
    void *r;

    if ((r = strdup(p)) == NULL)
        exit_log(1, "Error: Out of memory\n");

    return r;
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

    arr[0] = NULL;
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
    int       i;
    char     *equal;
    option_t *opt;

    for ( i = 0 ; i < argc; i++ )
    {
        if ( argv[i][1] && argv[i][0] == '-' )
        {
            opt = options;
            do
            {
                if ( opt->sopt && argv[i][2] == 0 && argv[i][1] == opt->sopt )
                {
                    i = option_set(i,argc,argv,opt);
                    break;
                }
                else if (opt->lopt && (argv[i][0] == '-') && (argv[i][1] == '-'))
                {
                    equal = strchr(&argv[i][2], '=');
                    if ((equal && (strncmp(&argv[i][2], opt->lopt, strlen(opt->lopt)) == 0)) || (!equal && (strcmp(&argv[i][2], opt->lopt) == 0)))
                    {
                        i = option_set(i,argc,argv,opt);
                        break;   
                    }
                }                
                opt++;
            } while ( opt->type != OPT_NONE );
        }
    }    
    return 0;
}




static int option_set(int pos, int max, char *argv[], option_t *option)
{
    char   *param;
    int     ret;

    ret = pos;
    param = (argv[pos] == NULL) ? NULL : strchr(argv[pos], '=');

    if ((param == NULL) && ((pos + 1) < max))
    {
        param = argv[pos+1];
        ret = pos + 1;
    }
    else
    {
        ++param;
        ret = pos;
    }

    switch ( option->type & OPT_BASE_MASK)
    {
        case OPT_BOOL:
            *(char *)(option->dest) = TRUE;
            ret = pos;
            break;

        case OPT_INT:
            if (param)
                *(int *)(option->dest) = (int)strtol(param, NULL, 0);
            break;

        case OPT_STR:
            if (param)
                *(char **)(option->dest) = strdup(param);
            break;

        case OPT_FUNCTION:
            if (param) {
                option_cb func = (option_cb)option->dest;
                func(param);
            }
            break;

        case OPT_NONE:
            ret = pos;
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
        case OPT_FUNCTION:
            fprintf(stderr,"%s   --%-15s (complex) %s\n",optstr,opt->lopt,opt->desc);
            break;
        case OPT_NONE:
            break;
        }
        opt++;
    }
}


/* Number to BCD */
uint32_t num2bcd(uint32_t num)
{
    int i;
    uint32_t bcd;

    bcd = 0;
    for (i=0; i<32; i+=8)
    {
        bcd += ((num%100)/10*16 + (num%100)%10) << i;
        num /= 100;
    }

    return bcd;
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

void writeword_be(unsigned int i, FILE *fp)
{
    fputc(i/256,fp);
    fputc(i%256,fp);
}

void writestring(char *mystring, FILE *fp)
{
    size_t c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte(mystring[c],fp);
    }
}

void writelong(unsigned long i, FILE *fp)
{
    writeword(i%65536,fp);
    writeword(i/65536,fp);
}

void writebyte_b(unsigned char c, uint8_t **pptr)
{
   uint8_t *ptr = *pptr;
   *ptr++ = c;
   *pptr = ptr; 
}

void writeword_b(unsigned int i, uint8_t **pptr)
{
   uint8_t *ptr = *pptr;
   *ptr++ = i % 256;
   *ptr++ = i / 256;
   *pptr = ptr; 
}

void writestring_b(char *mystring, uint8_t **pptr)
{
    size_t c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_b(mystring[c],pptr);
    }
}

void writelong_b(unsigned long i, uint8_t **pptr)
{
    writeword_b(i%65536,pptr);
    writeword_b(i/65536,pptr);
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
    fputc(c,fp);
    *p=0xff^(c-*p);
}


void writestring_p(char *mystring, FILE *fp,unsigned char *p)
{
    size_t c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_p(mystring[c],fp,p);
    }
}



void writestring_pk(char *mystring, FILE *fp,unsigned char *p)
{
    size_t c;

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



void writestring_cksum(char *mystring, FILE *fp, unsigned long *cksum)
{
    size_t c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_cksum(mystring[c],fp,cksum);
    }
}



/* Add the WAV header to a 44100 Khz RAW sound file */
void raw2wav(char *wavfile)
{
    char    rawfilename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    int      c;
    long     i, len;

    strncpy(rawfilename,wavfile,FILENAME_MAX);

    if ( (fpin=fopen(wavfile,"rb") ) == NULL ) {
        exit_log(1,"Can't open file %s for wave conversion\n",wavfile);
    }

    if (fseek(fpin,0,SEEK_END)) {
       fclose(fpin);
       exit_log(1,"Couldn't determine size of file\n",1);
    }

    len=ftell(fpin);
    fseek(fpin,0L,SEEK_SET);
    suffix_change(wavfile,".wav");

    if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
        exit_log(1,"Can't open output raw audio file %s\n",wavfile);
    }

    /* Now let's think at the WAV file */
    writestring("RIFF",fpout);
	writelong(len+36,fpout);
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

    for (i=0; i<len;i++) {
		// Small alteration of the square wave to make it look analogue
		// It should be enough for all the emulators to accept it as a valid feed
		// still permitting a good compression rate to the LZ algorithms
      c=getc(fpin);
      fputc(c-(i&1),fpout);
    }

    fclose(fpin);
    fclose(fpout);

    if (unlink (rawfilename) != 0) fprintf(stderr, "Warning: Couldn't remove: %s\n",rawfilename);

}

/* Convert a 44100 Khz RAW sound file to a 22050 Khz WAV file */
void raw2wav_22k(char *wavfile, int mode)
{
    char    rawfilename[FILENAME_MAX+1];
    FILE    *fpin, *fpout;
    int      c;
    long     i, len;

    strncpy(rawfilename,wavfile,FILENAME_MAX);

    if ( (fpin=fopen(wavfile,"rb") ) == NULL ) {
        exit_log(1,"Can't open file %s for wave conversion\n",wavfile);
    }

    if (fseek(fpin,0,SEEK_END)) {
       fclose(fpin);
       exit_log(1,"Couldn't determine size of file\n");
    }

    len=ftell(fpin)/2;
    fseek(fpin,0L,SEEK_SET);
    suffix_change(wavfile,".wav");

    if ( (fpout=fopen(wavfile,"wb") ) == NULL ) {
        exit_log(1,"Can't open output raw audio file %s\n",wavfile);
    }

    /* Now let's think at the WAV file */
    writestring("RIFF",fpout);
    writelong(len+36,fpout);
    writestring("WAVEfmt ",fpout);
    writelong(0x10,fpout);
    writeword(1,fpout);
    writeword(1,fpout);
    writelong(22050,fpout);
    writelong(22050,fpout);
    writeword(1,fpout);
    writeword(8,fpout);
    writestring("data",fpout);
    writelong(len,fpout);

    for (i=0; i<len;i++) {

    switch (mode)
    {
        case 1:
			c=getc(fpin);
			getc(fpin);
            break;
        case 2:
			getc(fpin);
			c=getc(fpin);
            break;
		default:
			c=getc(fpin);
			c=(c+getc(fpin))/2;
	}
	// Small alteration of the square wave to make it look analogue
	// It should be enough for all the emulators to accept it as a valid feed
	// still permitting a good compression rate to the LZ algorithms
      fputc(c-(i&1),fpout);
    }

    fclose(fpin);
    fclose(fpout);
	
    if (unlink (rawfilename) != 0) fprintf(stderr, "Warning: Couldn't remove: %s\n",rawfilename);
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



int hexdigit(char digit) 
{
    if (digit >= 'A' && digit <= 'F') {
        return digit - 'A' + 10;
    } else if (digit >= 'a' && digit <= 'f') {
        return digit - 'a' + 10;
    } else if (digit >= '0' && digit <= '9') {
        return digit - '0';
    }

    exit_log(1,"\nError in patch string\n");
    return 0; /* Not reached */
}





/* iHEX format file conversion (+hex and others) */
static int checksum(const unsigned char *data, int size)
{
    int sum = 0;

    while ( size-- ) {
        sum += *data++;
        sum &= 0xff;
    }

    if (sum > 0) {
        sum = 0x100 - sum;
    }

    return(sum);    
}


// if eofrec == 0 do not write end-of-file record
// len is the max number of bytes to read from input file
int bin2hex(FILE *input, FILE *output, int address, uint32_t len, int recsize, int eofrec)
{
    unsigned char *outbuf;
    unsigned char *inbuf;
    int byte;
    int size;   
    int i;

    if (len == 0) return 0;

    if (recsize < 1)
        recsize = 16;
    else if (recsize > 255)
        recsize = 255;

    if ((outbuf = malloc((recsize + 6) * sizeof(*outbuf))) == NULL)
        exit_log(1, "Error bin2hex: out of memory\n");

    inbuf = outbuf + 5;
    outbuf[0] = ':';

    do
    {    
        size = 0;
        while (len && (size < recsize))
        {
            byte = fgetc(input);

            if ( byte == EOF )
                break;

            inbuf[size++] = byte;
            len--;
        }

        if (size == 0 && !eofrec)
            break;

        outbuf[1] = size;
        if (size > 0)
        {
            outbuf[2] = address >> 8;
            outbuf[3] = address & 0xff;
            outbuf[4] = 0;
        }
        else
        {
            outbuf[2] = 0;
            outbuf[3] = 0;
            outbuf[4] = 1;
        }
        outbuf[5 + size] = checksum(outbuf + 1, size + 4);
        fputc(outbuf[0], output);

        for (i=1; i<(size+6); i++)
            fprintf(output, "%02X", outbuf[i]);

        fprintf(output, "\n");
        address += size;        
    } while (!feof(input) || (size > 0));

    free(outbuf);
    return 0;
}


static void get_temporary_filename(char *filen)
{
#ifdef _WIN32
    char   *ptr;

    if ((ptr = _tempnam(".\\", tmpnambuf)) == NULL) {
        fprintf(stderr, "Failed to create temporary filename\n");
        exit(1);
    }
    strcpy(filen, ptr);
    free(ptr);
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
    num_temp_files++;
    temp_files = realloc(temp_files, num_temp_files * sizeof(temp_files[0]));
    temp_files[num_temp_files-1] = strdup(filen);
}



static void  cleanup_temporary_files(void)
{
    int   i;

    for ( i = 0; i < num_temp_files; i++ ) {
         remove(temp_files[i]);
    }
}


/* memory banks */

#define MBLINEMAX 1024
#define MBBUFFERMAX 4096

void mb_create_bankspace(struct banked_memory *memory, char *bank_id)
{
    memory->num++;
    memory->bankspace = must_realloc(memory->bankspace, memory->num * sizeof(*memory->bankspace));

    memset(&memory->bankspace[memory->num - 1], 0, sizeof(*memory->bankspace));
    memory->bankspace[memory->num - 1].bank_id = must_strdup(bank_id);
}

enum
{
    TYPE_HEAD = 1,
    TYPE_SIZE
};

void mb_enumerate_banks(FILE *fmap, const char *binname, struct banked_memory *memory, struct aligned_data *aligned)
{
    char* buffer = malloc(MBBUFFERMAX-6);           // Prevent sscanf of buffer overflowing symbol_name
    char* symbol_name = malloc(MBBUFFERMAX-5);      // Prevent 'snprintf(section_name,...' overflow warning
    long symbol_value;
    char section_name[MBLINEMAX-5];                 // Prevent 'snprintf(bfilename,...' overflow warning
    char* bfilename = malloc(MBBUFFERMAX);
    int  c,i;
    struct stat st;

    // organize output binaries into banks

    while (fgets(buffer, MBBUFFERMAX-7, fmap) != NULL)
    {
        // have one line of the map file
        // make sure the entire line is consumed

        if (buffer[strlen(buffer) - 1] != '\n')
            while (((c = fgetc(fmap)) != EOF) && (c != '\n'));

        // get symbol name and value

        if (sscanf(buffer, "%s = $%lx", symbol_name, (long unsigned int *) &symbol_value) == 2)
        {
            // find out if symbol corresponds to a section name

            int len = strlen(symbol_name);
            int type = 0;

            if ((len >= 6) && (symbol_name[0] == '_') && (symbol_name[1] == '_'))
            {
                if (strcmp(symbol_name + len - 5, "_head") == 0)
                    type = TYPE_HEAD;
                else if (strcmp(symbol_name + len - 5, "_size") == 0)
                    type = TYPE_SIZE;

                if (type)
                {
                    char *p;

                    // section found
                    // extract section name and form binary filename

                    if (len == 6)
                    {
                        // section name is empty
                        // classic can generate main bank binaries with empty section names

                        section_name[0] = 0;
                        snprintf(bfilename, MBBUFFERMAX, "%s.bin", binname);
                        if ((stat(bfilename, &st) < 0) || (S_IFREG != (st.st_mode & S_IFMT)))
                            suffix_change(bfilename, "");
                    }
                    else
                    {
                        // section name is present

                        snprintf(section_name, sizeof(section_name), "%s", &symbol_name[2]);
                        section_name[len - 7] = 0;
                        snprintf(bfilename, MBBUFFERMAX, "%s_%s.bin", binname, section_name);
                        if ( stat(bfilename, &st) < 0 ) {
                            char binname_buf[FILENAME_MAX+1];

                            snprintf(binname_buf,sizeof(binname_buf),"%s", binname);
                            suffix_change(binname_buf, "");

                            snprintf(bfilename, MBBUFFERMAX, "%s_%s.bin", binname_buf, section_name);
                        }
                    }

                    // if section head
                    // check if a corresponding binary output file exists

                    if ((type == TYPE_HEAD) && (stat(bfilename, &st) >= 0) && (S_IFREG == (st.st_mode & S_IFMT)) && (st.st_size > 0))
                    {
                        // found a section binary
                        // find out which memory bank it belongs to

                        struct memory_bank *mb = &memory->mainbank;

                        for (i = 0; i < memory->num; ++i)
                        {
                            if ((p = strstr(section_name, memory->bankspace[i].bank_id)) != NULL)
                            {
                                int banknum;

                                if (sscanf(p + strlen(memory->bankspace[i].bank_id), "_%d", &banknum) == 1)
                                {
                                    if ((banknum >= 0) && (banknum < MAXBANKS))
                                    {
                                        mb = &memory->bankspace[i].membank[banknum];
                                        break;
                                    }
                                    else
                                    {
                                        fprintf(stderr, "Warning: Bank number in %s is out of range\n(will likely end up in main bank)\n", section_name);
                                    }
                                }
                            }
                        }

                        // mb is the memory bank the section belongs to
                        // section duplicates cannot occur so simply add to list

                        mb->num++;
                        mb->secbin = must_realloc(mb->secbin, mb->num * sizeof(*mb->secbin));

                        // add new section information

                        struct section_bin *sb = &mb->secbin[mb->num - 1];
                        memset(sb, 0, sizeof(*sb));

                        sb->filename = must_strdup(bfilename);
                        sb->offset = 0;
                        sb->section_name = must_strdup(section_name);
                        sb->org = symbol_value;
                        sb->size = st.st_size;
                    }

                    // record an aligned section

                    int alignment;

                    if ((p = strstr(section_name, "_align_")) && (sscanf(p, "_align_%d", &alignment) == 1))
                    {
                        // look for an existing entry for the section

                        int index;

                        for (index = 0; index < aligned->num; ++index)
                            if (strcmp(section_name, aligned->array[index].section_name) == 0)
                                break;

                        if (index >= aligned->num)
                        {
                            // existing entry not found so make new entry

                            aligned->num++;
                            aligned->array = must_realloc(aligned->array, aligned->num * sizeof(*aligned->array));

                            memset(&aligned->array[index], 0, sizeof(aligned->array[index]));
                            aligned->array[index].section_name = must_strdup(section_name);
                            aligned->array[index].alignment = alignment;
                        }

                        // collect section information

                        if (type == TYPE_HEAD)
                            aligned->array[index].org = (int)symbol_value;
                        else
                            aligned->array[index].size = (int)symbol_value;
                    }
                }
            }
        }
        else
        {
            // map file line is wrong format
            // flag error if the line is not blank

            char *p;

            for (p = buffer; isspace(*p); ++p) ;

            if (*p)
                fprintf(stderr, "Warning: Unable to parse line from map file\n\t%s\n", buffer);
        }
    }

    // Remove the UNASSIGNED section

    if (mb_remove_section(memory, "UNASSIGNED", 0))
        printf("Warning: Non-empty UNASSIGNED section ignored -\n  this indicates that some code/data is not part of the memory map\n");

    free(buffer);
    free(symbol_name);
    free(bfilename);
}

int mb_find_bankspace(struct banked_memory *memory, char *bankspace_name)
{
    int i;

    for (i = 0; i < memory->num; ++i)
        if (strcmp(memory->bankspace[i].bank_id, bankspace_name) == 0)
            return i;

    return -1;
}

int mb_remove_bankspace(struct banked_memory *memory, char *bankspace_name)
{
    int index;

    if ((index = mb_find_bankspace(memory, bankspace_name)) >= 0)
    {
        // found the bank space by name

        int i;
        struct bank_space *bs = &memory->bankspace[index];

        // delete all memory banks in the bank space

        for (i = 0; i < MAXBANKS; ++i)
            mb_remove_bank(bs, i, 0);

        free(bs->bank_id);

        // remove the bank space from the memory model

        memcpy(&memory->bankspace[index], &memory->bankspace[index + 1], (memory->num - index - 1) * sizeof(*memory->bankspace));

        if (--memory->num > 0)
            memory->bankspace = must_realloc(memory->bankspace, memory->num * sizeof(*memory->bankspace));
        else
        {
            free(memory->bankspace);
            memory->bankspace = NULL;
        }

        return 1;
    }

    return 0;
}

int mb_remove_bank(struct bank_space *bs, unsigned int index, int clean)
{
    if (index < MAXBANKS)
    {
        struct memory_bank *mb = &bs->membank[index];

        if (mb->num > 0)
        {
            int i;

            for (i = 0; i < mb->num; ++i)
            {
                if (clean) remove(mb->secbin[i].filename);
                free(mb->secbin[i].filename);
                free(mb->secbin[i].section_name);
            }

            free(mb->secbin);

            mb->num = 0;
            mb->secbin = NULL;

            return 1;
        }
    }

    return 0;
}

void mb_remove_mainbank(struct memory_bank *mb, int clean)
{
    int i;

    for (i = 0; i < mb->num; ++i)
    {
        struct section_bin *sb = &mb->secbin[i];

        if (clean)
            remove(sb->filename);

        free(sb->filename);
        free(sb->section_name);
    }

    free(mb->secbin);

    mb->num = 0;
    mb->secbin = NULL;
}

int mb_find_section(struct banked_memory *memory, char *section_name, struct memory_bank **mb_r, int *secnum_r)
{
    // find the given section, return in mb_r & secnum_r
    // return of 0 indicates section not found

    int    i;
    char  *p;
    struct memory_bank *mb = &memory->mainbank;

    // first find out which memory bank the section belongs to

    for (i = 0; i < memory->num; ++i)
    {
        if ((p = strstr(section_name, memory->bankspace[i].bank_id)) != NULL)
        {
            int banknum;

            if (sscanf(p + strlen(memory->bankspace[i].bank_id), "_%d", &banknum) == 1)
            {
                if ((banknum >= 0) && (banknum < MAXBANKS))
                {
                    mb = &memory->bankspace[i].membank[banknum];
                    break;
                }
            }
        }
    }

    // memory bank to search is in mb
    // look for the specific section

    for (i = 0; i < mb->num; ++i)
    {
        if (strcmp(mb->secbin[i].section_name, section_name) == 0)
        {
            // section has been found

            *mb_r = mb;
            *secnum_r = i;

            return 1;
        }
    }

    // section not found

    *mb_r = NULL;
    *secnum_r = -1;

    return 0;
}

int mb_remove_section(struct banked_memory *memory, char *section_name, int clean)
{
    // remove a particular section from the bank enumeration

    int    secnum;
    struct memory_bank *mb = &memory->mainbank;

    if (mb_find_section(memory, section_name, &mb, &secnum))
    {
        // section has been found
        // free allocated memory, remove it from the section array

        if (clean) remove(mb->secbin[secnum].filename);

        free(mb->secbin[secnum].filename);
        free(mb->secbin[secnum].section_name);

        memcpy(&mb->secbin[secnum], &mb->secbin[secnum + 1], (mb->num - secnum - 1) * sizeof(*mb->secbin));

        if (--mb->num > 0)
            mb->secbin = must_realloc(mb->secbin, mb->num * sizeof(*mb->secbin));
        else
        {
            free(mb->secbin);
            mb->secbin = NULL;
        }

        return 1;
    }

    return 0;
}

int mb_user_remove_bank(struct banked_memory *memory, char *bankname)
{
    int i;
    int banknum;

    // first check if a bank space matches the name, if so remove the entire bank space (eg "BANK")
    // second check if the bank name is composed of a bank space and bank number, if so delete the bank (eg "BANK_5")

    // try to delete a bank space

    if (mb_remove_bankspace(memory, bankname))
        return 1;

    // try to delete an individual memory bank

    // find bank space that bankname belongs to

    for (i = 0; i < memory->num; ++i)
    {
        char *p;

        if ((p = strstr(bankname, memory->bankspace[i].bank_id)) != NULL)
        {
            if (sscanf(p + strlen(memory->bankspace[i].bank_id), "_%d", &banknum) == 1)
            {
                if ((banknum >= 0) && (banknum < MAXBANKS))
                    break;
            }
        }
    }

    // memory bank found in
    // bankspace i, memory bank banknum

    if ((i < memory->num) && mb_remove_bank(&memory->bankspace[i], banknum, 0))
        return 2;

    return 0;
}

int mb_compare_aligned(const void *va, const void *vb)
{
    const struct section_aligned *a = va;
    const struct section_aligned *b = vb;
    return strcmp(a->section_name, b->section_name);
}

int mb_check_alignment(struct aligned_data *aligned)
{
    int errors = 0;
    int i;

    qsort(aligned->array, aligned->num, sizeof(*aligned->array), mb_compare_aligned);

    for (i = 0; i < aligned->num; ++i)
    {
        if ((aligned->array[i].size > 0) && (aligned->array[i].org & (aligned->array[i].alignment - 1)))
        {
            errors++;
            fprintf(stderr, "Warning: Section %s at address 0x%04x is not properly aligned\n", aligned->array[i].section_name, aligned->array[i].org);
        }
    }

    return errors;
}

int mb_compare_banks(const void *va, const void *vb)
{
    const struct section_bin *a = va;
    const struct section_bin *b = vb;
    return a->org - b->org;
}

int mb_sort_banks_check(struct memory_bank *mb, int borg, int bsize)
{
    int errors = 0;
    int k;

    if (mb->num)
    {
        qsort(mb->secbin, mb->num, sizeof(*mb->secbin), mb_compare_banks);

        for (k = 0; k < mb->num; ++k)
        {
            // check if section exceeds 64k address space

            if (mb->secbin[k].org < 0)
            {
                errors++;
                fprintf(stderr, "Error: Section %s has negative org %d\n", mb->secbin[k].section_name, mb->secbin[k].org);
            }
            else if ((mb->secbin[k].org < 0x10000) && ((mb->secbin[k].org + mb->secbin[k].size) > 0x10000))
            {
                errors++;
                fprintf(stderr, "Error: Section %s exceeds 64k [0x%04x,0x%04x]\n", mb->secbin[k].section_name, mb->secbin[k].org, mb->secbin[k].org + mb->secbin[k].size - 1);
            }
            else if ((bsize > 0) && ((mb->secbin[k].org < borg) || ((mb->secbin[k].org - borg + mb->secbin[k].size) > bsize)))
            {
                errors++;
                fprintf(stderr, "Error: Section %s occupies [0x%04x,0x%04x] which exceeds fixed bank size [0x%04x,0x%04x]\n", mb->secbin[k].section_name, mb->secbin[k].org, mb->secbin[k].org + mb->secbin[k].size - 1, borg, borg + bsize - 1);
            }

            // check for section overlap

            if (k > 0)
            {
                if (mb->secbin[k].org < (mb->secbin[k - 1].org + mb->secbin[k - 1].size))
                {
                    errors++;
                    fprintf(stderr, "Error: Section %s overlaps section %s by %d bytes\n", mb->secbin[k - 1].section_name, mb->secbin[k].section_name, mb->secbin[k - 1].org + mb->secbin[k - 1].size - mb->secbin[k].org);
                }
            }
        }
    }

    return errors;
}

int mb_sort_banks(struct banked_memory *memory)
{
    int errors, i, j;

    // sort the main bank

    errors = mb_sort_banks_check(&memory->mainbank, 0, 0);

    // sort each bank space

    for (i = 0; i < memory->num; ++i)
    {
        struct bank_space *bs = &memory->bankspace[i];

        for (j = 0; j < MAXBANKS; ++j)
        {
            errors += mb_sort_banks_check(&bs->membank[j], bs->org, bs->size);
        }
    }

    return errors;
}

int mb_generate_output_binary(FILE *fbin, int filler, FILE *fhex, int ipad, int irecsz, struct memory_bank *mb, int borg, int bsize)
{
    // fhex may be NULL to indicate hex file not wanted
    // fbin should be opened in "wb+" mode
    // filler is fill byte for gaps between sections
    // ipad is non-zero if hex file should use filler in gaps
    // irecsz is intel hex record size

    FILE *fin;
    int   c, i, total, size;

    // iterate over all sections in memory bank

    total = 0;

    for (i = 0; i < mb->num; ++i)
    {
        // open section binary file

        if ((fin = fopen(mb->secbin[i].filename, "rb")) == NULL)
        {
            fprintf(stderr, "Error: Cannot read section binary %s\n", mb->secbin[i].filename);
            return 1;
        }

        if (fseek(fin, mb->secbin[i].offset, SEEK_SET) != 0)
        {
            fprintf(stderr, "Error: Cannot seek to %" PRIu32 " in file %s\n", mb->secbin[i].offset, mb->secbin[i].filename);
            fclose(fin);
            return 1;
        }

        // pad space between sections in memory bank

        c = 0;

        if ((i == 0) && (bsize > 0))
            c = mb->secbin[i].org - borg;
        else if (i > 0)
            c = mb->secbin[i].org - mb->secbin[i - 1].org - mb->secbin[i - 1].size;

        while (c-- > 0)
        {
            total++;
            fputc(filler, fbin);
        }

        // add section binary to memory bank

        for (size = mb->secbin[i].size; size && ((c = fgetc(fin)) != EOF); --size)
        {
            total++;
            fputc(c, fbin);
        }

        if (size != 0)
        {
            fprintf(stderr, "Error: Could not read %d bytes from offset %" PRIu32 " from file %s\n", mb->secbin[i].size, mb->secbin[i].offset, mb->secbin[i].filename);
            fclose(fin);
            return 1;
        }

        // generate into ihex file if padding is off

        if ((fhex != NULL) && !ipad)
        {
            fseek(fin, mb->secbin[i].offset, SEEK_SET);
            bin2hex(fin, fhex, mb->secbin[i].org, mb->secbin[i].size, irecsz, 0);
        }

        // close section binary file

        fclose(fin);
    }

    // pad section if bankspace has size set

    while (total++ < bsize)
        fputc(filler, fbin);

    // terminate ihex file

    if (fhex != NULL)
    {
        if (ipad)
        {
            // nothing has been written to the hex file yet
            // use the generated binary file as it contains filler bytes

            fflush(fbin);
            rewind(fbin);
            bin2hex(fbin, fhex, (bsize > 0) ? borg : mb->secbin[0].org, -1, irecsz, 1);
        }
        else
            fprintf(fhex, ":00000001FF\n");
    }

    return 0;
}

void mb_generate_output_binary_complete(char *binname, int ihex, int filler, int ipad, int irecsz, struct banked_memory *memory)
{
    char filename[MBLINEMAX];
    char ihexname[MBLINEMAX];
    FILE *fbin, *fhex;
    int   i, j, k, error;

    // generate output binaries

    if (memory->mainbank.num > 0)
    {
        int free_gap;

        // the main bank contains sections

        snprintf(filename, sizeof(filename), "%s__.bin", binname);
        strcpy(ihexname, filename);
        suffix_change(ihexname, ".ihx");

        fbin = fhex = NULL;

        if ((fbin = fopen(filename, "wb+")) == NULL)
            exit_log(1, "Error: Cannot create file %s\n", filename);

        if (ihex && ((fhex = fopen(ihexname, "w")) == NULL))
            exit_log(1, "Error: Cannot create file %s\n", ihexname);

        free_gap = 0;

        for (k = 1; k < memory->mainbank.num; ++k)
            free_gap += memory->mainbank.secbin[k].org - memory->mainbank.secbin[k - 1].org - memory->mainbank.secbin[k - 1].size;

        printf("Creating %s (org 0x%04x", filename, memory->mainbank.secbin[0].org);
        if (free_gap) printf(", %d gap bytes free", free_gap);
        printf(")\n");

        error = mb_generate_output_binary(fbin, filler, fhex, ipad, irecsz, &memory->mainbank, 0, 0);

        fclose(fbin);
        if (fhex != NULL) fclose(fhex);

        if (error)
            exit_log(1, "Aborting... section unavailable\n");
    }

    for (j = 0; j < memory->num; ++j)
    {
        struct bank_space *bs = &memory->bankspace[j];

        for (i = 0; i < MAXBANKS; ++i)
        {
            struct memory_bank *mb = &bs->membank[i];

            if (mb->num > 0)
            {
                int free_head, free_gap, free_tail;

                // the memory bank contains sections

                snprintf(filename, sizeof(filename), "%s__%s_%03d.bin", binname, memory->bankspace[j].bank_id, i);
                strcpy(ihexname, filename);
                suffix_change(ihexname, ".ihx");

                fbin = fhex = NULL;

                if ((fbin = fopen(filename, "wb+")) == NULL)
                    exit_log(1, "Error: Cannot create file %s\n", filename);

                if (ihex && ((fhex = fopen(ihexname, "w")) == NULL))
                    exit_log(1, "Error: Cannot create file %s\n", ihexname);

                // count free space in bank

                free_gap = 0;
                free_head = 0;
                free_tail = 0;

                for (k = 1; k < mb->num; ++k)
                    free_gap += mb->secbin[k].org - mb->secbin[k - 1].org - mb->secbin[k - 1].size;

                if (bs->size > 0)
                {
                    free_head = mb->secbin[0].org - bs->org;
                    free_tail = bs->org + bs->size - mb->secbin[mb->num - 1].org - mb->secbin[mb->num - 1].size;
                }

                // generate output binary

                printf("Creating %s (org 0x%04x", filename, (bs->size > 0) ? bs->org : mb->secbin[0].org);
                if (free_head) printf(", %d head bytes free", free_head);
                if (free_gap) printf(", %d gap bytes free", free_gap);
                if (free_tail) printf(", %d tail bytes free", free_tail);
                printf(")\n");

                error = mb_generate_output_binary(fbin, filler, fhex, ipad, irecsz, mb, bs->org, bs->size);

                fclose(fbin);
                if (fhex != NULL) fclose(fhex);

                if (error)
                    exit_log(1, "Aborting... section unavailable\n");
            }
        }
    }
}

int mb_output_section_binary(FILE *fbout, struct section_bin *sb)
{
    FILE *fin;
    int   c;
    int   size;

    // open section binary file

    if ((fin = fopen(sb->filename, "rb")) == NULL)
        return -1;

    if (fseek(fin, sb->offset, SEEK_SET) != 0)
    {
        fclose(fin);
        return -2;
    }

    // add section binary to output file

    for (size = sb->size; size && ((c = fgetc(fin)) != EOF); --size)
        fputc(c, fbout);

    fclose(fin);
    return size;
}

void mb_delete_source_binaries(struct banked_memory *memory)
{
    int  i,j,k;
    // remove main bank binaries

    for (i = 0; i < memory->mainbank.num; ++i)
        remove(memory->mainbank.secbin[i].filename);

    // remove binaries from all bank spaces

    for (i = 0; i < memory->num; ++i)
    {
        for (j = 0; j < MAXBANKS; ++j)
        {
            struct memory_bank *mb = &memory->bankspace[i].membank[j];

            for (k = 0; k < mb->num; ++k)
                remove(mb->secbin[k].filename);
        }
    }
}

void mb_cleanup_memory(struct banked_memory *memory)
{
    struct memory_bank *mb;
    int i,j,k;
    // does not free "memory"

    for (i = 0; i < memory->num; ++i)
    {
        struct bank_space *bs = &memory->bankspace[i];
        
        for (j = 0; j < MAXBANKS; ++j)
        {
            mb = &bs->membank[j];

            for (k = 0; k < mb->num; ++k)
            {
                struct section_bin *sb = &mb->secbin[k];

                free(sb->filename);
                free(sb->section_name);
            }

            free(mb->secbin);
        }

        free(bs->bank_id);
    }

    mb = &memory->mainbank;
    for (k = 0; k < mb->num; ++k)
    {
        struct section_bin *sb = &mb->secbin[k];

        free(sb->filename);
        free(sb->section_name);
    }

    free(memory->bankspace);

    memory->num = 0;
    memory->bankspace = NULL;

    free(memory->mainbank.secbin);

    memory->mainbank.num = 0;
    memory->mainbank.secbin = NULL;
}

void mb_cleanup_aligned(struct aligned_data *aligned)
{
    int  i;
    // does not free "aligned"

    for (i = 0; i < aligned->num; ++i)
    {
        struct section_aligned *sa = &aligned->array[i];

        free(sa->section_name);
    }

    free(aligned->array);

    aligned->num = 0;
    aligned->array = NULL;
}


/**
 * Display the information from a memory section.
 *
 * @param sb    Pointer to the section binary.
 **/
static void _mb_print_section_info(struct section_bin *sb)
{
    printf("bankname : %s\n", sb->section_name);
    printf("filename : %s\n", sb->filename);
    printf("offset   : 0x%04x\n", sb->offset);
    printf("org      : 0x%04x\n", sb->org);
    printf("size     : 0x%04x\n", sb->size);
    printf("================\n");
}

/**
 * Display memory bank information.
 *
 * @param memory    Pointer to banked_memory structure
 **/
int mb_print_info(struct banked_memory *memory)
{
    int bsnum;
    int bank, section;
    int banksFound = 0;

    for (bsnum = 0; bsnum < memory->num; bsnum++) {
        for (bank = 0; bank < MAXBANKS; ++bank) {
            struct memory_bank *mb = &memory->bankspace[bsnum].membank[bank];

            for (section = 0; section < mb->num; ++section) {
                _mb_print_section_info(&mb->secbin[section]);
                banksFound++;
            }
        }
    }
    return (banksFound);
}



// This bit of code is used (rather than stat), because we create a temporary file
// With all the sections included in it
long get_file_size(FILE *fp) 
{
    long len;

    fseek(fp, 0, SEEK_END);
    len = ftell(fp);
    fseek(fp, 0L, SEEK_SET);
    return len;
}

