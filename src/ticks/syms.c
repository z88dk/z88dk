#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "ticks.h"

static symbol  *symbols = NULL;
static int      symbols_num = 0;


static cfile   *cfiles = NULL;

static void demangle_filename(const char *input, char *buf, size_t buflen, int *lineno)
{
    char *start = buf;
    char *ptr;

    *lineno = -1;
    input += strlen("__CFILE___33");

    while ( *input ) {
        char   c = *input++;
        if ( c != '_' ) {
            *buf++ = c;
        } else {
            unsigned char d;

            c = *input++;
            d = (c >= 'A' ? c - 'A' + 10 : c - '0' ) << 4;
            c = *input++;
            d |= (c >= 'A' ? c - 'A' + 10 : c-'0');
            *buf++ = d;
        }
    }
    *buf = 0;

    /* Line number is at end after quotes (random sccz80 thing, to be fixed) */
    ptr = strrchr(start, '"');
    if ( ptr != NULL ) {
        *ptr = 0;
        ptr++;
        *lineno = atoi(ptr+1);
    }
}


static int symbol_compare(const void *p1, const void *p2)
{
    const symbol *s1 = p1, *s2 = p2;

    return s2->address - s1->address;
}

void read_symbol_file(char *filename)
{
    char  buf[256];
    FILE *fp = fopen(filename,"r");

    if ( fp != NULL ) {
        while ( fgets(buf, sizeof(buf), fp) != NULL ) {
            int argc;
            char **argv = parse_words(buf,&argc);

            // Ignore
            if ( argc < 9 ) {
                free(argv);
                continue;
            }
            if ( strncmp(argv[0], "__CLINE__",9) ) {
                symbols = realloc(symbols, (symbols_num + 1) * sizeof(symbols[0]));
                symbols[symbols_num].name = strdup(argv[0]);
                symbols[symbols_num].file = strdup(argv[8]);
                symbols[symbols_num].section = strdup(argv[8]); // TODO, comma
                symbols[symbols_num].islocal = 0;
                if ( strcmp(argv[5], "local,")) {
                    symbols[symbols_num].islocal = 1;
                }
                symbols[symbols_num].symtype = SYM_ADDRESS;
                if ( strcmp(argv[4],"const,") == 0 ) {
                    symbols[symbols_num].symtype = SYM_CONST;
                }
                symbols[symbols_num].address = strtol(argv[2] + 1, NULL, 16);
                symbols_num++;
            } else {
                /* It's a cline symbol */
                char   filename[FILENAME_MAX+1];
                int    lineno;
                cfile *cf;
                cline *cl;

                demangle_filename(argv[0], filename, sizeof(filename),&lineno);

                HASH_FIND_STR(cfiles, filename, cf);

                if ( cf == NULL ) {
                    cf = calloc(1,sizeof(*cf));
                    cf->file = strdup(filename);
                    cf->lines = NULL;
                    HASH_ADD_KEYPTR(hh, cfiles, cf->file, strlen(cf->file), cf);
                }

                cl = calloc(1,sizeof(*cl));
                cl->line = lineno;
                cl->address = strtol(argv[2] + 1, NULL, 16);
                HASH_ADD_INT(cf->lines, line, cl);
                //printf("C source code line %s:%d at %04x\n",cf->file, cl->line, cl->address);
            }
            free(argv);
        }
    }
    qsort(symbols, symbols_num, sizeof(symbols[0]),symbol_compare);
}

static int bsearch_find_byaddress(const void *key, const void *elem)
{
     int val = *(int *)key;
     const symbol *sym = elem;

     return sym->address - val;
}

symbol *find_symbol_byname(const char *name)
{
    int i;

    for ( i = 0; i < symbols_num; i++ ) {
        if ( strcmp(symbols[i].name,name) == 0 ) {
            return &symbols[i];
        }
    }
    return NULL;
}

int symbol_resolve(char *name)
{
    symbol *sym = find_symbol_byname(name);
    char   *ptr;

    if ( sym != NULL ) {
        return sym->address;
    }

    /* Check for it being a file */
    if ( ( ptr = strchr(name, ':') ) != NULL ) {
        char filename[FILENAME_MAX+1];
        int  line;
        cfile *cf;

        snprintf(filename, sizeof(filename),"%.*s", (int)(ptr - name), name);
        line = atoi(ptr+1);

        HASH_FIND_STR(cfiles, filename, cf);

        if ( cf != NULL ) {
            cline *cl;

            HASH_FIND_INT(cf->lines, &line, cl);

            if ( cl != NULL ) {
                return cl->address;
            }
        }
    }
    return -1;
}

const char *find_symbol(int addr)
{
    symbol *sym = bsearch(&addr, symbols, symbols_num, sizeof(symbols[0]), bsearch_find_byaddress);
    return sym ? sym->name : NULL;
}

char **parse_words(char *line, int *argc)
{
    int                 i = 0, j = 0 , n = 0;
    int                 len = strlen(line);
    int                 in_single_quotes = 0, in_double_quotes = 0;
    char              **args;

    while ( isspace(line[i] ) ) {
        i++;
    }

    for ( ; i <= len; i++) {
        switch (line[i]) {
        case '"':
            if (in_single_quotes) {
                line[j++] = line[i];
                break;
            }
            in_double_quotes = !in_double_quotes;
            break;
        case '\'':
            if (in_double_quotes) {
                line[j++] = line[i];
                break;
            }
            in_single_quotes = !in_single_quotes;
            break;
        case ' ':
        case '\t':
        case '\r':
        case '\n':
        case 0:
            if (!in_single_quotes && !in_double_quotes) {
                line[j++] = 0;
                n++;
                i++;
                /* Try to find the start of the next word */
                while (i <= len && (line[i] == 0 || isspace(line[i])) ) {
                    i++;
                }
                i--;
                break;
            }
            line[j++] = line[i];
            break;
        case '\\':
            switch (line[i + 1]) {
            case '"':
            case '\'':
            case '\\':
                line[j++] = line[i + 1];
                break;
            case ' ':
                if (in_single_quotes || in_double_quotes) {
                    line[j++] = line[i];
                }
                line[j++] = line[i + 1];
                break;
            default:
                line[j++] = line[i];
                line[j++] = line[i + 1];
                break;
            }
            i++;
            break;
        default:
            line[j++] = line[i];
            break;
        }
    }

    args = (char **)malloc(sizeof(char *) * (n + 1) );
    n = 0;
    args[n++] = line;
    j--;

    for (i = 0; i < j; i++) {
        if (line[i] == 0) {
            args[n++] = line + i + 1;
        }
    }

    *argc = n;

    return args;
}
