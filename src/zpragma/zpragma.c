
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <inttypes.h>

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

typedef struct convspec_s {
    char fmt;
    char complex;
    uint32_t val;
    uint32_t lval;
    uint32_t llval;
} CONVSPEC;

CONVSPEC printf_formats[] = {
    { 'd', 1, 0x01, 0x1000, 0x01 },
    { 'u', 1, 0x02, 0x2000, 0x02 },
    { 'x', 2, 0x04, 0x4000, 0x04 },
    { 'X', 2, 0x08, 0x8000, 0x08 },
    { 'o', 2, 0x10, 0x10000, 0x10 },
    { 'n', 2, 0x20, 0x20000, 0 },
    { 'i', 2, 0x40, 0x40000, 0x40 },
    { 'p', 2, 0x80, 0x80000, 0 },
    { 'B', 2, 0x100, 0x100000, 0 },
    { 's', 1, 0x200, 0, 0 },
    { 'c', 1, 0x400, 0, 0 },
    { 'I', 0, 0x800, 0, 0 },
    { 'a', 0, 0x400000, 0x400000, 0 },
    { 'A', 0, 0x800000, 0x800000, 0 },
    { 'e', 3, 0x1000000, 0x1000000, 0 },
    { 'E', 3, 0x2000000, 0x2000000, 0 },
    { 'f', 3, 0x4000000, 0x4000000, 0 },
    { 'F', 3, 0x8000000, 0x8000000, 0 },
    { 'g', 3, 0x10000000, 0x10000000, 0 },
    { 'G', 3, 0x20000000, 0x20000000, 0 },
    { 0, 0, 0, 0 }
};

CONVSPEC scanf_formats[] = {
    { 'd', 1, 0x01, 0x1000, 0x01 },
    { 'u', 1, 0x02, 0x2000, 0x02 },
    { 'x', 2, 0x04, 0x4000, 0x04 },
    { 'X', 2, 0x08, 0x8000, 0x08 },
    { 'o', 2, 0x10, 0x10000, 0x10 },
    { 'n', 2, 0x20, 0x20000, 0 },
    { 'i', 2, 0x40, 0x40000, 0x40 },
    { 'p', 2, 0x80, 0x80000, 0 },
    { 'B', 2, 0x100, 0x100000, 0 },
    { 's', 1, 0x200, 0, 0 },
    { 'c', 1, 0x400, 0, 0 },
    { 'I', 0, 0x800, 0, 0 },
    { '[', 0, 0x200000, 0x200000, 0},
    { 'a', 0, 0x400000, 0x400000, 0 },
    { 'A', 0, 0x800000, 0x800000, 0 },
    { 'e', 3, 0x1000000, 0x1000000, 0 },
    { 'E', 3, 0x2000000, 0x2000000, 0 },
    { 'f', 3, 0x4000000, 0x4000000, 0 },
    { 'F', 3, 0x8000000, 0x8000000, 0 },
    { 'g', 3, 0x10000000, 0x10000000, 0 },
    { 'G', 3, 0x20000000, 0x20000000, 0 },
    { 0, 0, 0, 0 }
};

static uint64_t parse_format_string(char *arg, CONVSPEC *specifiers)
{
    char c;
    int complex, islong;
    uint64_t format_option = 0;
    CONVSPEC *fmt;

    for (complex = 1; c = *arg; ++arg)
    {
        if (c == '/')
            break;

        if ((c == '%') || isspace(c) || (c == '"') || (c == '='))
            continue;

        if (*arg == '-' || *arg == '0' || *arg == '+' || *arg == ' ' || *arg == '*' || *arg == '.')
        {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (!isalpha(*arg))
                arg++;
        }
        else if (isdigit(*arg))
        {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (isdigit(*arg) || *arg == '.')
                arg++;
        }

        islong = 0;
        if (*arg == 'l')
        {
            if (complex < 2)
                complex = 2;
            arg++;
            islong = 1;
            if (*arg == 'l')
            {
                arg++;
                islong = 2;
            }
        }

        fmt = specifiers;
        while (fmt->fmt)
        {
            if (fmt->fmt == *arg)
            {
                if (complex < fmt->complex)
                    complex = fmt->complex;
                switch (islong)
                {
                case 0:
                    format_option |= fmt->val;
                    break;
                case 1:
                    format_option |= fmt->lval;
                    break;
                default:
                    format_option |= (uint64_t)(fmt->llval) << 32;
                    break;
                }
                break;
            }
            fmt++;
        }
        if (fmt->fmt == 0)
            fprintf(stderr, "Ignoring unrecognized %s format specifier %%%c\n", (specifiers == printf_formats) ? "printf" : "scanf", *arg);
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
                uint64_t value = parse_format_string(ptr + 6, printf_formats);
                write_defined("CLIB_OPT_PRINTF", (int32_t)(value & 0xffffffff), 0);
                write_defined("CLIB_OPT_PRINTF_2", (int32_t)((value >> 32) & 0xffffffff), 0);
            } else if ( strncmp(ptr,"scanf", 5) == 0 ) {
                uint64_t value = parse_format_string(ptr + 5, scanf_formats);
                write_defined("CLIB_OPT_SCANF", (int32_t)(value & 0xffffffff), 0);
                write_defined("CLIB_OPT_SCANF_2", (int32_t)((value >> 32) & 0xffffffff), 0);
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
                write_defined("CRT_ORG_CODE", strtol(ptr+6, NULL, 0), 0);
            } else if ( strncmp(ptr, "-reqpag=", 8) == 0 ) {
                write_defined("CRT_Z88_BADPAGES", strtol(ptr+8, NULL, 0), 0);
            } else if ( strncmp(ptr, "-defvars=", 8) == 0 ) {
                write_defined("defvarsaddr", strtol(ptr+8, NULL, 0), 0);
            } else if ( strncmp(ptr, "-safedata=", 10) == 0 ) {
                write_defined("CRT_Z88_SAFEDATA", strtol(ptr+9, NULL, 0), 0);
            } else if ( strncmp(ptr, "-startup=", 9) == 0 ) {
                write_defined("startup", strtol(ptr+9, NULL, 0), 0);
            } else if ( strncmp(ptr, "-farheap=", 9) == 0 ) {
                write_defined("farheapsz", strtol(ptr+9, NULL, 0), 0);
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
