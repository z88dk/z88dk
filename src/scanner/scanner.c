
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define NAMESIZE 256

static char buf[65536];

static char filename[FILENAME_MAX+1];
static int  lineno = 0;


char *skip_ws(char *ptr)
{
    while ( isspace(*ptr) ) {
        ptr++;
    }
    return ptr;
}

void strip_nl(char *ptr)
{
    char *nl;
    if ( ( nl = strchr(ptr,'\n') ) != NULL || (nl = strchr(ptr,'\r')) != NULL ) {
        *nl = 0;
    }
}

/*
 * Dump some text into the zcc_opt.def, this allows us to define some
 * things that the startup code might need
 */

void write_pragma_string(char *ptr)
{
    char *text;
    FILE *fp;

    text = strchr(ptr,' ');
    if ( text == NULL ) text = strchr(ptr,'\t');

    if ( text != NULL ) {
        *text = 0;
        text++;
        if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
            fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
            exit(1);
        }
        fprintf(fp,"\nIF NEED_%s\n",ptr);
        fprintf(fp,"\tdefm\t\"%s\"\n",text);
		fprintf(fp,"\tdefc DEFINED_NEED_%s = 1\n",ptr);
        fprintf(fp,"ENDIF\n\n");
        fclose(fp);
    }
}

/* Dump some bytes into the zcc_opt.def file */

void write_bytes(char *line, int flag)
{
    FILE   *fp;
    char    sname[NAMESIZE+1];
    char   *ptr;
    long value;
    int     count;

    ptr = sname;
    while ( isalpha(*line) && ( ptr - sname) < NAMESIZE ) {
        *ptr++ = *line++;
    }
    *ptr = 0;

    if ( strlen(sname) ) {
        if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
            fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
            exit(1);
        }
        fprintf(fp,"\nIF NEED_%s\n",sname);
        if ( flag ) {
            fprintf(fp,"\tdefc DEFINED_NEED_%s = 1\n",sname);
        }

        /* Now, do the numbers */
        count=0;
        ptr = skip_ws(line);

        while ( *line != ';' ) {
            char *end;

            if ( count == 0 ) {
                fprintf(fp,"\n\tdefb\t");
            } else {
                fprintf(fp,",");
            }

            value = strtol(line, &end, 0);

            if ( end != line ) {
                fprintf(fp,"%ld",value);
            } else {
                fprintf(stderr, "%s:%d Invalid number format %.10s\n",filename, lineno, line);
                break;
            }
            line = skip_ws(end);

            if ( *line == ';' ) {
                break;
            } else if ( *line != ',' ) {
                fprintf(stderr, "%s:%d Invalid syntax for #pragma line\n", filename, lineno);
                break;
            }
            line = skip_ws(line);
            count++;
            if ( count == 9 ) count=0;
        }
        fprintf(fp,"\nENDIF\n");
        fclose(fp);
    }
}	


void write_defined(char *sname, int value)
{
    FILE *fp;

    if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    strip_nl(sname);

    fprintf(fp,"\nIF !DEFINED_%s\n",sname);
    fprintf(fp,"\tdefc\tDEFINED_%s = 1\n",sname);
    fprintf(fp,"\tdefc %s = %d\n",sname,value);
    fprintf(fp,"ENDIF\n\n");
    fclose(fp);
}

void write_need(char *sname, int value)
{
    FILE *fp;

    if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    fprintf(fp,"\nIF !NEED_%s\n",sname);
    fprintf(fp,"\tdefc\tNEED_%s = %d\n",sname, value);
    fprintf(fp,"ENDIF\n\n");
    fclose(fp);
}



int main()
{
    char   *ptr;

    strcpy(filename,"<stdin>");
    lineno = 0;

    while ( fgets(buf, sizeof(buf) - 1, stdin) != NULL ) {
        lineno++;
        ptr = skip_ws(buf);

        if ( strncmp(ptr,"#pragma", 7) == 0 ) {
            int  ol = 1;
            ptr = skip_ws(ptr + 7);
         
            if ( strncmp(ptr, "output",6) == 0 ) {
                char *offs;
                int   value = 0;
                ptr = skip_ws(ptr+6);
                if ( (offs = strchr(ptr+1,'=') ) != NULL  ) {
                    value = atoi(offs+1);
                    *offs = 0;
                }
                write_defined(ptr,value);
            } else if ( strncmp(ptr,"string",6) == 0 ) {
                write_pragma_string(ptr + 6);
            } else if ( strncmp(ptr, "data", 4) == 0 ) {
                write_bytes(ptr + 4, 1);
            } else if ( strncmp(ptr, "byte", 4) == 0 ) {
                write_bytes(ptr + 4, 0);
            } else if ( strncmp(ptr, "asm", 3) == 0 ) {
                fputs("__asm\n",stdout);
                ol = 0;
            } else if ( strncmp(ptr, "endasm", 6) == 0 ) {
                fputs("__endasm;\n",stdout);
                ol = 0;
            } else if (strncmp(ptr, "-zorg=", 6) == 0 ) {
                /* It's an option, this may tweak something */
                write_defined("myzorg", atoi(ptr+6));
            } else if ( strncmp(ptr, "-reqpag=", 8) == 0 ) {
                write_defined("reqpag", atoi(ptr+8));
            } else if ( strncmp(ptr, "-defvars=", 8) == 0 ) {
                write_defined("defvarsaddr", atoi(ptr+8));
            } else if ( strncmp(ptr, "-safedata=", 10) == 0 ) {
                write_defined("safedata", atoi(ptr+9));
            } else if ( strncmp(ptr, "-startup=", 9) == 0 ) {
                write_defined("startup", atoi(ptr+9));
            } else if ( strncmp(ptr, "-farheap=", 9) == 0 ) {
                write_defined("farheapsz", atoi(ptr+9));
            } else if ( strncmp(ptr, "-intuition", 9) == 0 ) {
                write_defined("intuition", 1);
            } else if ( strncmp(ptr, "-expandz88", 9) == 0 ) {
                write_need("expanded", 1);
            } else if ( strncmp(ptr, "-no-expandz88", 9) == 0 ) {
                write_need("expanded", 0);
            }
            if ( ol ) {
                fputs("\n",stdout);
            }
        } else if ( strncmp(ptr, "#asm", 4) == 0 ) {
            fputs("__asm\n",stdout);
        } else if ( strncmp(ptr, "#endasm", 7) == 0 ) {
            fputs("__endasm;\n",stdout);
        } else {
            int skip = 0;
            if ( (skip=2, strncmp(ptr,"# ",2) == 0)  || ( skip=5, strncmp(ptr,"#line",5) == 0) ) {
                int     num=0;
                char    tmp[FILENAME_MAX+1];

                ptr = skip_ws(ptr + skip);

                tmp[0]=0;
                sscanf(ptr,"%d %s",&num,tmp);
                if   (num) lineno=--num;
                if      (strlen(tmp)) strcpy(filename,tmp);
            }

            fputs(buf,stdout);
        }
    }
}
