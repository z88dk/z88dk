/*
 *
 *   z88dk Application Generator (appmake)
 *
 *   This file contains the driver and routines used by multiple
 *   modules
 * 
 *   $Id: appmake.c,v 1.7 2010-05-18 07:11:59 stefano Exp $
 */

#define MAIN_C
#include "appmake.h"


static void         main_usage(void);

static int          option_parse(int argc, char *argv[], option_t *options);
static int          option_set(int pos, int max, char *argv[], option_t *opt);
static void         option_print(char *execname, char *ident, char *copyright, char *desc,option_t *opts);


int main(int argc, char *argv[])
{
    int     i;
    int     ac;
    char  **av;
    char   *ptr;
    char   *target = NULL;
    char    targethelp;


    av = calloc(argc,sizeof(char*));
    ac = 0;

    /* Run through the arguments, looking for the last machine target */
    for ( i = 0; i < argc; i++ ) {
        if ( argv[i][0] == '+' ) {
            target = &argv[i][1];
        } else {
            if ( strcmp(argv[i],"-h") == 0 )
                targethelp = 1;
            av[ac] = argv[i];
            ac++;
        }
    }

    /* Now, search through for argv[0] calling convention */
    for ( i = 0; i < APPMAKE_TARGETS; i++ ) {
        if ( ( ptr = strstr(argv[0],machines[i].execname )  ) &&
             ( *(ptr + strlen(machines[i].execname) ) == '.' || *(ptr + strlen(machines[i].execname) ) == '\0' ) ) {
            target = machines[i].ident;     /* Ick, but there we go */
            break;
        }
    }


    if ( target == NULL ) {
        main_usage();
    }


    for ( i = 0; i < APPMAKE_TARGETS; i++ ) {
        if ( strcmp(target,machines[i].ident) == 0 ) {
            option_parse(ac,av,machines[i].options);
            switch ( machines[i].exec(target,machines[i].ident) ) {
            case -1:
                option_print(machines[i].execname, machines[i].ident,machines[i].copyright, machines[i].desc, machines[i].options);
                myexit(NULL,1);
            default:
                myexit(NULL,0);
            }            
        }
    }

    fprintf(stderr,"Unknown machine target \"%s\"\n\n",target);
    main_usage();

    return 0;
}





/* Useful functions used by many targets */

int myexit(char *str,int code)
{
        if ( str != NULL )
            fputs(str,stderr);
        exit(code);
}



/* Search through debris from z80asm for some important parameters */
long parameter_search(char *filen, char *ext,char *target)
{
    char    name[FILENAME_MAX+1];
    char    buffer[LINEMAX+1];
    long    val=-1;
    FILE    *fp;

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
    for ( i = 0; i < APPMAKE_TARGETS; i++ ) {
        fprintf(stderr,"+%-12s (%-8s) - %s\n",machines[i].ident,machines[i].execname,machines[i].copyright);
    }
    fprintf(stderr,"\nFor more usage information use +[target] with no options\n");
  
    myexit(NULL,1);
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

    switch ( option->type ) {
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


static void option_print(char *execname, char *ident, char *copyright, char *desc, option_t *opts)
{
    option_t *opt = opts;
    char      optstr[4];

    fprintf(stderr,"appmake +%s (%s)\n\n%s\n",ident,execname,copyright);

    if ( desc && strlen(desc) )
        fprintf(stderr,"\n%s\n",desc);

    fprintf(stderr,"\nOptions:\n\n");
    while ( opt->type != OPT_NONE ) {
        if ( opt->sopt ) {
            sprintf(optstr,"-%c",opt->sopt);
        } else {
            sprintf(optstr,"  ");
        }
        switch ( opt->type ) {
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


void writebyte_p(unsigned char c, FILE *fp,unsigned char *p)
{
    fputc(c,fp);
    *p^=c;
}

void writestring_p(char *mystring, FILE *fp,unsigned char *p)
{
    int  c;

    for (c=0; c < strlen(mystring); c++) {
        writebyte_p(mystring[c],fp,p);
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
