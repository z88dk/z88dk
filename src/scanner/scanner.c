
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define NAMESIZE 256

static char buf[65536];

static char filename[FILENAME_MAX+1];
static int  lineno = 0;
static int  sccz80_mode = 0;


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

void first_word_only(char *ptr)
{
    while (!isspace(*ptr))
        ++ptr;
    *ptr = 0;
}

/*
 * Dump some text into the zcc_opt.def, this allows us to define some
 * things that the startup code might need
 */

void write_pragma_string(char *ptr)
{
    char *text;
    FILE *fp;

    ptr = skip_ws(ptr);
    strip_nl(ptr);
    text = strchr(ptr,' ');
    if ( text == NULL ) text = strchr(ptr,'\t');

    if ( text != NULL ) {
        *text = 0;
        text++;
        if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
            fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
            exit(1);
        }
        text = skip_ws(text);
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


void write_defined(char *sname, int32_t value, int export)
{
    FILE *fp;

    if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    strip_nl(sname);

    fprintf(fp,"\nIF !DEFINED_%s\n",sname);
    fprintf(fp,"\tdefc\tDEFINED_%s = 1\n",sname);
	if (export) fprintf(fp, "\tPUBLIC\t%s\n", sname);
    fprintf(fp,"\tdefc %s = %0#x\n",sname,value);
    fprintf(fp,"\tIFNDEF %s\n\tENDIF\n",sname);
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

void write_redirect(char *sname, char *value)
{
    FILE *fp;

    strip_nl(sname);
    value = skip_ws(value);
    first_word_only(value);
    if ( (fp=fopen("zcc_opt.def","a")) == NULL ) {
        fprintf(stderr,"%s:%d Cannot open zcc_opt.def file\n", filename, lineno);
        exit(1);
    }
    fprintf(fp,"\nIF !DEFINED_%s\n",sname);
    fprintf(fp,"\tPUBLIC %s\n",sname);
    fprintf(fp,"\tEXTERN %s\n",value);
    fprintf(fp,"\tdefc\tDEFINED_%s = 1\n",sname);
    fprintf(fp,"\tdefc %s = %s\n",sname,value);
    fprintf(fp,"ENDIF\n\n");
    fclose(fp);
}

struct printf_format_s {
    char fmt;
    char complex;
    uint32_t val;
    uint32_t lval;
} printf_formats[] = {
    { 'd', 1, 0x01, 0x1000 },
    { 'u', 1, 0x02, 0x2000 },
    { 'x', 2, 0x04, 0x4000 },
    { 'X', 2, 0x08, 0x8000 },
    { 'o', 2, 0x10, 0x10000 },
    { 'n', 2, 0x20, 0x20000 },
    { 'i', 2, 0x40, 0x40000 },
    { 'p', 2, 0x80, 0x80000 },
    { 'B', 2, 0x100, 0x100000 },
    { 's', 1, 0x200, 0x0 },
    { 'c', 1, 0x400, 0x0 },
    { 'a', 0, 0x400000, 0x0 },
    { 'A', 0, 0x800000, 0x0 },
    { 'e', 3, 0x1000000, 0x1000000 },
    { 'E', 3, 0x2000000, 0x2000000 },
    { 'f', 3, 0x4000000, 0x4000000 },
    { 'F', 3, 0x8000000, 0x8000000 },
    { 'g', 3, 0x10000000, 0x10000000 },
    { 'G', 3, 0x20000000, 0x20000000 },
    { 0, 0, 0, 0 }
};

static int32_t parse_format_string(char *arg)
{
    char c;
    int complex, islong;
    int32_t format_option = 0;
    struct printf_format_s* fmt;

    complex = 1; /* mini printf */
    while ((c = *arg++)) {
        if (c != '%')
            continue;

        if (*arg == '-' || *arg == '0' || *arg == '+' || *arg == ' ' || *arg == '*' || *arg == '.') {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (!isalpha(*arg))
                arg++;
        } else if (isdigit(*arg)) {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (isdigit(*arg) || *arg == '.') {
                arg++;
            }
        }

        islong = 0;
        if (*arg == 'l') {
            if (complex < 2)
                complex = 2;
            arg++;
            islong = 1;
        }
        fmt = &printf_formats[0];
        while (fmt->fmt) {
            if (fmt->fmt == *arg) {
                if (complex < fmt->complex)
                    complex = fmt->complex;
                format_option |= islong ? fmt->lval : fmt->val;
                break;
            }
            fmt++;
        }
    }
    return format_option;
}

int main(int argc, char **argv)
{
    char   *ptr;

    if ( argc == 2 && strcmp(argv[1],"-sccz80") == 0 ) {
         sccz80_mode = 1;
    }

    strcpy(filename,"<stdin>");
    lineno = 0;

    while ( fgets(buf, sizeof(buf) - 1, stdin) != NULL ) {
        lineno++;
        ptr = skip_ws(buf);
        if ( strncmp(ptr,"#pragma", 7) == 0 ) {
            int  ol = 1;
            ptr = skip_ws(ptr + 7);
         
            if ( ( strncmp(ptr, "output",6) == 0 ) || ( strncmp(ptr, "define",6) == 0 ) || ( strncmp(ptr, "export",6) == 0 ) ) {
                char *offs;
                int   value = 0;
				int   exp = strncmp(ptr, "export", 6) == 0;
                ptr = skip_ws(ptr+6);
                if ( (offs = strchr(ptr+1,'=') ) != NULL  ) {
                    value = (int)strtol(offs+1,NULL,0);
                    *offs = 0;
                }
                write_defined(ptr,value,exp);
            } else if ( strncmp(ptr, "redirect",8) == 0 ) {
                char *offs;
                char *value = "0";
                ptr = skip_ws(ptr+8);
                if ( (offs = strchr(ptr+1,'=') ) != NULL  ) {
                    value = offs + 1;
                    *offs = 0;
                }
                write_redirect(ptr,value);
            } else if ( strncmp(ptr,"printf", 6) == 0 ) {
                int32_t value = parse_format_string(ptr + 6);
                write_defined("CLIB_OPT_PRINTF", value, 0);
            } else if ( strncmp(ptr,"scanf", 5) == 0 ) {
                int32_t value = parse_format_string(ptr + 5);
                write_defined("CLIB_OPT_SCANF", value, 0);
            } else if ( strncmp(ptr,"string",6) == 0 ) {
                write_pragma_string(ptr + 6);
            } else if ( strncmp(ptr, "data", 4) == 0 ) {
                write_bytes(ptr + 4, 1);
            } else if ( strncmp(ptr, "byte", 4) == 0 ) {
                write_bytes(ptr + 4, 0);
            } else if ( sccz80_mode == 0 && strncmp(ptr, "asm", 3) == 0 ) {
                fputs("__asm\n",stdout);
                ol = 0;
            } else if ( sccz80_mode == 0 && strncmp(ptr, "endasm", 6) == 0 ) {
                fputs("__endasm;\n",stdout);
                ol = 0;
            } else if (strncmp(ptr, "-zorg=", 6) == 0 ) {
                /* It's an option, this may tweak something */
                write_defined("CRT_ORG_CODE", atoi(ptr+6), 0);
            } else if ( strncmp(ptr, "-reqpag=", 8) == 0 ) {
                write_defined("CRT_Z88_BADPAGES", atoi(ptr+8), 0);
            } else if ( strncmp(ptr, "-defvars=", 8) == 0 ) {
                write_defined("defvarsaddr", atoi(ptr+8), 0);
            } else if ( strncmp(ptr, "-safedata=", 10) == 0 ) {
                write_defined("CRT_Z88_SAFEDATA", atoi(ptr+9), 0);
            } else if ( strncmp(ptr, "-startup=", 9) == 0 ) {
                write_defined("startup", atoi(ptr+9), 0);
            } else if ( strncmp(ptr, "-farheap=", 9) == 0 ) {
                write_defined("farheapsz", atoi(ptr+9), 0);
            } else if ( strncmp(ptr, "-expandz88", 9) == 0 ) {
                write_defined("CRT_Z88_EXPANDED", 1, 0);
            } else if ( strncmp(ptr, "-no-expandz88", 9) == 0 ) {
                write_defined("CRT_Z88_EXPANDED", 0, 0);
            } else {
                printf("%s\n",buf);
            }
            if ( ol ) {
                fputs("\n",stdout);
            }
        } else if ( sccz80_mode == 0 && strncmp(ptr, "#asm", 4) == 0 ) {
            fputs("__asm\n",stdout);
        } else if ( sccz80_mode == 0 && strncmp(ptr, "#endasm", 7) == 0 ) {
            fputs("__endasm;\n",stdout);
        } else if ( sccz80_mode == 1 && strncmp(ptr, "__asm", 5) == 0 ) {
            fputs("#asm\n",stdout);
        } else if ( sccz80_mode == 1 && strncmp(ptr, "__endasm", 8) == 0 ) {
            fputs("#endasm;\n",stdout);
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
