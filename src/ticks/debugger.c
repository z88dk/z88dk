
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#ifdef WIN32
#include <io.h>
#else
#include <unistd.h>                         // For declarations of isatty()
#endif

#include "utlist.h"

#include "ticks.h"
#include "linenoise.h"

#define HISTORY_FILE ".ticks_history.txt"

#define FNT_CLR "\x1B[34m"              // Color (blue on black)
#define FNT_BLD "\x1B[34;1m"            // Bold color (bright blue on black)
#define FNT_BCK "\x1B[34;7m"            // Reverse color (white on blue)
#define FNT_RST "\x1B[0m"               // Reset colors to default value (gray on black)

#define CLR_REG
#define CLR_ADDR

typedef enum {
    BREAK_PC,
    BREAK_CHECK8,
    BREAK_CHECK16,
    BREAK_READ,
    BREAK_WRITE,
} breakpoint_type;

typedef struct breakpoint {
    breakpoint_type    type;
    int                value;
    unsigned char      lvalue;
    unsigned char     *lcheck_ptr;
    unsigned char       hvalue;
    unsigned char     *hcheck_ptr;
    char               enabled;
    char              *text;
    struct breakpoint *next;
} breakpoint;


struct reg {
    char    *name;
    uint8_t  *low;
    uint8_t  *high;
    uint16_t *word;
};

static struct reg registers[] = {
    { "hl",  &l,  &h },
    { "de",  &e,  &d },
    { "bc",  &c,  &b },
    { "hl'", &l_, &h_ },
    { "de'", &e_, &d_ },
    { "bc'", &c_, &b_ },
    { "ix'", &xl, &xh },
    { "iy'", &yl, &yh },
    { "sp",  NULL, NULL, &sp },
    { "pc",  NULL, NULL, &pc },
    { "a",   &a,   NULL },
    { "a'",  &a_,  NULL },
    { "b",   &b,   NULL },
    { "b'",  &b_,  NULL },
    { "c",   &c,   NULL },
    { "c'",  &c_,  NULL },
    { "d",   &d,   NULL },
    { "d'",  &d_,  NULL },
    { "e",   &e,   NULL },
    { "e'",  &e_,  NULL },
    { "h",   &h,   NULL },
    { "h'",  &h_,  NULL },
    { "l",   &l,   NULL },
    { "l'",  &l_,  NULL },
    { "ixh", &xh,  NULL },
    { "ixl", &xl,  NULL },
    { "iyh", &yh,  NULL },
    { "iyl", &yl,  NULL },
    { NULL, NULL, NULL },
};

typedef struct {
    char   *cmd;
    int   (*func)(int argc, char **argv);
    char   *options;
    char   *help;
} command;



static void completion(const char *buf, linenoiseCompletions *lc, void *ctx);
static int cmd_next(int argc, char **argv);
static int cmd_step(int argc, char **argv);
static int cmd_continue(int argc, char **argv);
static int cmd_disassemble(int argc, char **argv);
static int cmd_registers(int argc, char **argv);
static int cmd_break(int argc, char **argv);
static int cmd_watch(int argc, char **argv);
static int cmd_examine(int argc, char **argv);
static int cmd_set(int argc, char **argv);
static int cmd_out(int argc, char **argv);
static int cmd_trace(int argc, char **argv);
static int cmd_hotspot(int argc, char **argv);
static int cmd_list(int argc, char **argv);
static int cmd_help(int argc, char **argv);
static int cmd_quit(int argc, char **argv);
static void print_hotspots();
static const char *resolve_to_label(int addr);



static command commands[] = {
    { "next",   cmd_next,          "",  "Step the instruction (over calls)" },
    { "step",   cmd_step,          "",  "Step the instruction (including into calls)" },
    { "cont",   cmd_continue,      "",  "Continue execution" },
    { "dis",    cmd_disassemble,   "[<address>]",  "Disassemble from pc/<address>" },
    { "reg",    cmd_registers,     "",  "Display the registers" },
    { "break",  cmd_break,         "<address/label>",  "Handle breakpoints" },
    { "watch",  cmd_watch,         "<address/label>",  "Handle watchpoints" },
    { "x",      cmd_examine,       "<address>",   "Examine memory" },
    { "set",    cmd_set,           "<hl/h/l/...> <value>",  "Set registers" },
    { "out",    cmd_out,           "<address> <value>", "Send to IO bus"},
    { "trace",  cmd_trace,         "<on/off>", "Disassemble every instruction"},
    { "hotspot",cmd_hotspot,       "<on/off>", "Track address counts and write to hotspots file"},
    { "list",   cmd_list,          "<address>",   "List the source code at the given address"},
    { "help",   cmd_help,          "",   "Display this help text" },
    { "quit",   cmd_quit,          "",   "Quit ticks"},
    { NULL, NULL, NULL }
};


static breakpoint *breakpoints;
static breakpoint *watchpoints;

       int debugger_active = 0;
static int next_address = -1;
       int trace = 0;
static int hotspot = 0;
static int max_hotspot_addr = 0;
static int last_hotspot_addr;
static int last_hotspot_st;
static int hotspots[65536];
static int hotspots_t[65536];

static int interact_with_tty = 0;



void debugger_init()
{
    linenoiseSetCompletionCallback(completion, NULL);
    linenoiseHistoryLoad(HISTORY_FILE); /* Load the history at startup */
    atexit(print_hotspots);
    memset(hotspots, 0, sizeof(hotspots));
    interact_with_tty = isatty(fileno(stdin)) && isatty(fileno(stdout)); // Only colors with active tty
}



static void completion(const char *buf, linenoiseCompletions *lc, void *ctx)
{
    command *cmd= &commands[0];

    while ( cmd->cmd != NULL ) {
        if ( strncmp(buf, cmd->cmd, strlen(buf)) == 0 ) {
            linenoiseAddCompletion(lc, cmd->cmd);
        }
        cmd++;
    }
}

void debugger_write_memory(int addr, uint8_t val)
{
    breakpoint *elem;
    int         i;
    LL_FOREACH(watchpoints, elem) {
        if ( elem->enabled == 0 ) {
            continue;
        }
        if ( elem->type == BREAK_WRITE && elem->value == addr ) {
            printf("Hit watchpoint %d\n",i);
            debugger_active = 1;
            break;
        }
        i++;
    }
}

void debugger_read_memory(int addr)
{
    breakpoint *elem;
    int         i;

    LL_FOREACH(watchpoints, elem) {
        if ( elem->enabled == 0 ) {
            continue;
        }
        if ( elem->type == BREAK_READ && elem->value == addr ) {
            printf("Hit watchpoint %d\n",i);
            debugger_active = 1;
            break;
        }
        i++;
    }
}

void debugger()
{
    static char *last_line = NULL;
    char   buf[256];
    char   prompt[100];
    char  *line;

    if ( last_line == NULL ) {
        last_line = strdup("");
    }

    if ( trace ) {
        cmd_registers(0, NULL);
        disassemble2(pc, buf, sizeof(buf), 0);

        if (interact_with_tty)
            printf( "\n%s\n\n",buf);    // In case of active tty, double LF to improve layout in case of 'cont'
        else
            printf("%s\n",buf);         // Unchanged in case of non-active tty
    }

    if ( hotspot ) {
        if ( pc > max_hotspot_addr) {
            max_hotspot_addr = pc;
        }
        if ( last_hotspot_addr != -1 ) {
            hotspots_t[last_hotspot_addr] += st - last_hotspot_st;
        }
        hotspots[pc]++;
        last_hotspot_addr = pc;
        last_hotspot_st = st;
    }

    if ( debugger_active == 0 ) {
        breakpoint *elem;
        int         i = 1;
        int         dodebug = 0;
        LL_FOREACH(breakpoints, elem) {
            if ( elem->enabled == 0 ) {
                continue;
            }
            if ( elem->type == BREAK_PC && elem->value == pc ) {
                printf("Hit breakpoint %d: @%04x (%s)\n",i,pc,resolve_to_label(pc));
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_CHECK8 && *elem->lcheck_ptr == elem->lvalue ) {
                printf("Hit breakpoint %d (%s = $%02x): @%04x (%s)\n",i,elem->text, elem->lvalue,pc,resolve_to_label(pc));
                elem->enabled = 0;
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_CHECK16 &&
                        *elem->lcheck_ptr == elem->lvalue  &&
                         *elem->hcheck_ptr == elem->hvalue  ) {
                printf("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,pc,resolve_to_label(pc));
                elem->enabled = 0;
                dodebug=1;
                break;
            }
            i++;
        }
        if ( pc == next_address ) {
            next_address = -1;
            dodebug = 1;
        }
        /* Check breakpoints */
        if ( dodebug == 0 ) return;
    }


    if (trace ==0) { // Prevent two lines with the same information
        disassemble2(pc, buf, sizeof(buf), 0);
        printf("%s\n",buf);
    }

    /* In the debugger, loop continuously for commands */

    symbol_find_lower(pc,SYM_ADDRESS,buf,sizeof(buf));
    if (interact_with_tty)
        snprintf(prompt,sizeof(prompt), "\n" FNT_BCK "    $%04x    (%s)>" FNT_RST " ", pc, buf);
    else                                                                                // Original output for non-active tty
        snprintf(prompt,sizeof(prompt), " %04x (%s)>", pc, buf);

    while ( (line = linenoise(prompt) ) != NULL ) {
        int argc;
        char freeline = 0;
        char **argv;

        if ( line == NULL || line[0] == '\0') {
            line = strdup(last_line);
            freeline = 1;
        } else {
            free(last_line);
            last_line = strdup(line);
        }

        if (line[0] != '\0' && line[0] != '/') {
            int return_to_execution = 0;
            linenoiseHistoryAdd(line); /* Add to the history. */
            linenoiseHistorySave(HISTORY_FILE); /* Save the history on disk. */

            /* Lets chop the line up into words now */
            argv = parse_words(line, &argc);

            if ( argc > 0 ) {
                command *cmd = &commands[0];
                while ( cmd->cmd ) {
                    if ( strcmp(argv[0], cmd->cmd) == 0 ) {
                        return_to_execution = cmd->func(argc, argv);
                        break;
                    }
                    cmd++;
                }
                free(argv);
            }
            if ( freeline ) free(line);
            if ( return_to_execution ) {
                /* Out of the linenoise loop */
                break;
            }
        } else {
            /* Empty line is step */
            if ( freeline ) free(line);
            debugger_active = 1;
            break;
        }
    }
}



static int cmd_next(int argc, char **argv)
{
    char  buf[100];
    int   len;
    uint8_t opcode = get_memory(pc);

    len = disassemble2(pc, buf, sizeof(buf), 0);

    // Set a breakpoint after the call
    switch ( opcode ) {
    case 0xed: // ED prefix
    case 0xcb: // CB prefix
    case 0xc4:
    case 0xcc:
    case 0xcd:
    case 0xd4:
    case 0xdc:
    case 0xe4:
    case 0xec:
    case 0xf4:
        // It's a call
        debugger_active = 0;
        next_address = pc + len;
        return 1;
    }

    debugger_active = 1;
    return 1;  /* We should exit the loop */
}



static int cmd_step(int argc, char **argv)
{
    debugger_active = 1;
    return 1;  /* We should exit the loop */
}



static int cmd_continue(int argc, char **argv)
{
    debugger_active = 0;
    return 1;
}



static int parse_number(char *str, char **end)
{
    int   base = 0;
    int   ret;

    if ( *str == '$' ) {
        base = 16;
        str++;
    } 
    return strtol(str, end, base);
}

/* Parse an address operand. 
 *
 * It may be one of:
 * 1. A number address
 * 2. A symbol
 * 3. A line expression
 */
static int parse_address(char *arg)
{
    char temp[1024];
    int  where;
    char *end;

    where = parse_number(arg, &end);
    if ( end == arg ) {
        where = symbol_resolve(arg);
        if ( where == -1 ) {
            snprintf(temp,sizeof(temp),"_%s",arg);
            where = symbol_resolve(temp);
            if ( where == -1 ) {
                // And now try to resolve a line expression
                where = debug_resolve_source(arg);
            }
        }
    }
    return where;
}

/* Map an address into a convenient label */
static const char *resolve_to_label(int addr)
{
    static char tbuf[1024];
    const char *sym;
    
    if ( (sym = find_symbol(addr, SYM_ADDRESS) ) != NULL ) {
        return sym;
    }
    symbol_find_lower(addr,SYM_ADDRESS,tbuf,sizeof(tbuf));

    if ( tbuf[0] == 0) return "<unknown>";

    return tbuf;
}



static int cmd_disassemble(int argc, char **argv)
{
    char  buf[256];
    int   i = 0;
    static int  where = -1;

    if ( argc == 2 ) {
        where = parse_address(argv[1]);
    }

    if ( where == -1 ) where = pc;

    while ( i < 10 ) {
       where += disassemble2(where, buf, sizeof(buf), 0);
       printf("%s\n",buf);
       i++;
    }
    return 0;
}



static int cmd_registers(int argc, char **argv) 
{
    if (interact_with_tty) {
        printf(
            FNT_CLR "af " FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "bc " FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "de " FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "hl " FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "ix " FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "

            " S:"   FNT_BLD "%d" FNT_RST
            " Z:"   FNT_BLD "%d" FNT_RST
            " H:"   FNT_BLD "%d" FNT_RST
            " P/V:" FNT_BLD "%d" FNT_RST
            " N:"   FNT_BLD "%d" FNT_RST
            " C:"   FNT_BLD "%d" FNT_RST "\n"

            FNT_CLR "af'" FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "bc'" FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "de'" FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "hl'" FNT_RST "$" FNT_BLD "%04X" FNT_RST "   "
            FNT_CLR "iy " FNT_RST "$" FNT_BLD "%04X" FNT_RST "\n"

            FNT_CLR "pc "  FNT_RST "$" FNT_BLD "%04X"   FNT_RST "  "
            FNT_CLR "[pc]" FNT_RST "$" FNT_BLD "  %02X" FNT_RST "   "
            FNT_CLR "sp "  FNT_RST "$" FNT_BLD "%04X"   FNT_RST "  "
            FNT_CLR "[sp]" FNT_RST "$" FNT_BLD "%04X" FNT_RST "\n",

            f()  | a << 8,  c  | b  << 8, e  | d  << 8, l  | h  << 8, xl | xh << 8,
            (f()  & 0x80) ? 1 : 0, (f()  & 0x40) ? 1 : 0, (f()  & 0x10) ? 1 : 0, (f()  & 0x04) ? 1 : 0, (f()  & 0x02) ? 1 : 0, (f()  & 0x01) ? 1 : 0,

            f_() | a_ << 8, c_ | b_ << 8, e_ | d_ << 8, l_ | h_ << 8, yl | yh << 8,

            pc, get_memory(pc), sp, (get_memory(sp+1) << 8 | get_memory(sp))
            );
    } else {  // Original output for non-active tty
        printf("pc=%04X, [pc]=%02X,    bc=%04X,  de=%04X,  hl=%04X,  af=%04X, ix=%04X, iy=%04X\n"
               "sp=%04X, [sp]=%04X, bc'=%04X, de'=%04X, hl'=%04X, af'=%04X\n"
               "f: S=%d Z=%d H=%d P/V=%d N=%d C=%d\n",
               pc, get_memory(pc), c | b << 8, e | d << 8, l | h << 8, f() | a << 8, xl | xh << 8, yl | yh << 8,
               sp, (get_memory(sp+1) << 8 | get_memory(sp)), c_ | b_ << 8, e_ | d_ << 8, l_ | h_ << 8, f_() | a_ << 8,
               (f() & 0x80) ? 1 : 0, (f() & 0x40) ? 1 : 0, (f() & 0x10) ? 1 : 0, (f() & 0x04) ? 1 : 0, (f() & 0x02) ? 1 : 0, (f() & 0x01) ? 1 : 0);
    }

    return 0;
}


static int cmd_watch(int argc, char **argv)
{
    int breakwrite = 0;

    if ( argc == 1 ) {
        breakpoint *elem;
        int         i = 1;

        /* Just show the breakpoints */
        LL_FOREACH(watchpoints, elem) {
            if ( elem->type == BREAK_READ) {
                printf("%d:\t(read) @$%04x (%s) %s\n",i, elem->value,resolve_to_label(elem->value), elem->enabled ? "" : " (disabled)");
            } else if ( elem->type == BREAK_WRITE) {
                printf("%d:\t(write) @$%04x (%s) %s\n",i, elem->value,resolve_to_label(elem->value), elem->enabled ? "" : " (disabled)");
            } 
            i++;
        }

    } else if ( argc == 3 && (strcmp(argv[1],"read") == 0 || (breakwrite=1,strcmp(argv[1],"write") == 0)) ) {
        char *end;
        const char *sym;
        breakpoint *elem;
        int value = parse_address(argv[2]);

        if ( value != -1 ) {
            elem = malloc(sizeof(*elem));
            elem->type = breakwrite ? BREAK_WRITE : BREAK_READ;
            elem->value = value;
            elem->enabled = 1;
            LL_APPEND(watchpoints, elem);
            printf("Adding %s watchpoint at '%s' $%04x (%s)\n",breakwrite ? "write" : "read", argv[2], value,  resolve_to_label(value));
        } else {
            printf("Cannot set watchpoint on '%s'\n",argv[2]);
        }
    } else if ( argc == 3 && strcmp(argv[1],"delete") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(watchpoints, elem) {
            num--;
            if ( num == 0 ) {
                printf("Deleting watchpoint %d\n",atoi(argv[2]));
                LL_DELETE(breakpoints,elem); // TODO: Freeing
                break;
            }
        }
    } else if ( argc == 3 && strcmp(argv[1],"disable") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(watchpoints, elem) {
            num--;
            if ( num == 0 ) {
                printf("Disabling watchpoint %d\n",atoi(argv[2]));
                elem->enabled = 0;
                break;
            }
        }
    } else if ( argc == 3 && strcmp(argv[1],"enable") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(watchpoints, elem) {
            num--;
            if ( num == 0 ) {
                printf("Enabling watchpoint %d\n",atoi(argv[2]));
                elem->enabled = 1;
                break;
            }
        }
    } 
    return 0;
}

static int cmd_break(int argc, char **argv)
{
    if ( argc == 1 ) {
        breakpoint *elem;
        int         i = 1;

        /* Just show the breakpoints */
        LL_FOREACH(breakpoints, elem) {
            if ( elem->type == BREAK_PC) {
                const char *sym = find_symbol(elem->value, SYM_ADDRESS);
                printf("%d:\tPC = $%04x (%s) %s\n",i, elem->value,sym ? sym : "<unknown>", elem->enabled ? "" : " (disabled)");
            } else if ( elem->type == BREAK_CHECK8 ) {
                printf("%d\t%s = $%02x%s\n",i, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
            } else if ( elem->type == BREAK_CHECK16 ) {
                printf("%d\t%s = $%04x%s\n",i, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
            } 
            i++;
        }
    } else if ( argc == 2 ) {
        char *end;
        const char *sym;
        breakpoint *elem;
        int value = parse_address(argv[1]);

        if ( value != -1 ) {
            elem = malloc(sizeof(*elem));
            elem->type = BREAK_PC;
            elem->value = value;
            elem->enabled = 1;
            LL_APPEND(breakpoints, elem);
            printf("Adding breakpoint at '%s' $%04x (%s)\n",argv[1], value,  resolve_to_label(value));
        } else {
            printf("Cannot break on '%s'\n",argv[1]);
        }
    } else if ( argc == 3 && strcmp(argv[1],"delete") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(breakpoints, elem) {
            num--;
            if ( num == 0 ) {
                printf("Deleting breakpoint %d\n",atoi(argv[2]));
                LL_DELETE(breakpoints,elem); // TODO: Freeing
                break;
            }
        }
    } else if ( argc == 3 && strcmp(argv[1],"disable") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(breakpoints, elem) {
            num--;
            if ( num == 0 ) {
                printf("Disabling breakpoint %d\n",atoi(argv[2]));
                elem->enabled = 0;
                break;
            }
        }
   } else if ( argc == 3 && strcmp(argv[1],"enable") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(breakpoints, elem) {
            num--;
            if ( num == 0 ) {
                printf("Enabling breakpoint %d\n",atoi(argv[2]));
                elem->enabled = 1;
                break;
            }
        }
    } else if ( argc == 5 && strcmp(argv[1], "memory8") == 0 ) {
        // break memory8 <addr> = <value>
        char  *end;
        int value = parse_address(argv[2]);

        if ( value != -1 ) {
            breakpoint *elem = malloc(sizeof(*elem));
            elem->type = BREAK_CHECK8;
            elem->lcheck_ptr = get_memory_addr(value);
            elem->lvalue = parse_number(argv[4], &end);
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
            printf("Adding breakpoint for %s = $%02x\n", elem->text, elem->lvalue);
        }
    } else if ( argc == 5 && strcmp(argv[1], "memory16") == 0 ) {
        char *end;
        int addr = parse_address(argv[2]);

        if ( addr != -1 ) {
            int value = parse_number(argv[4],&end);
            breakpoint *elem = malloc(sizeof(*elem));
            elem->type = BREAK_CHECK16;
            elem->lcheck_ptr = get_memory_addr(addr);
            elem->lvalue = value % 256;
            elem->hcheck_ptr = get_memory_addr(addr+1);
            elem->hvalue = (value % 65536 ) /    256;
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
            printf("Adding breakpoint for %s = $%02x%02x\n", elem->text, elem->hvalue, elem->lvalue);
        }
    } else if ( argc == 5 && strncmp(argv[1], "register",3) == 0 ) {
        struct reg *search = &registers[0];

        while ( search->name != NULL  ) {
            if ( strcmp(search->name, argv[2]) == 0 ) {
                break;
            }
            search++;
        }

        if ( search->name != NULL ) {
            int value = atoi(argv[4]);
            breakpoint *elem = malloc(sizeof(*elem));
            elem->type = search->high == NULL && search->word == NULL ? BREAK_CHECK8 : BREAK_CHECK16;
            if  ( search->word != NULL ) {
#ifdef __BIG_ENDIAN__
                elem->lcheck_ptr = ((uint8_t *)search->word) + 1;
                elem->hcheck_ptr = ((uint8_t *)search->word);
#else
                elem->hcheck_ptr = ((uint8_t *)search->word) + 1;
                elem->lcheck_ptr = ((uint8_t *)search->word);
#endif
                printf("%p %p %p\n",elem->lcheck_ptr, elem->hcheck_ptr, &pc);
            } else {
                elem->lcheck_ptr = search->low;
                elem->hcheck_ptr = search->high;
            }
            elem->lvalue = (value % 256);
            elem->hvalue = (value % 65536) / 256;
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
            if ( elem->type == BREAK_CHECK8 ) {
                printf("Adding breakpoint for %s = $%02x\n", elem->text, elem->lvalue);
            } else {
                printf("Adding breakpoint for %s = $%02x%02x\n", elem->text, elem->hvalue, elem->lvalue);
            }
        } else {
            printf("No such register %s\n",argv[2]);
        }

    }
    return 0;
}



static int cmd_examine(int argc, char **argv)
{
    static int addr = -1;
    char  abuf[17];
    int    i;

    if ( argc == 2 ) {
        addr = parse_address(argv[1]);
    }

    if ( addr == -1 ) addr = pc;


    abuf[16] = 0;                                       // Zero terminated string
    addr %= 0x10000;                                    // First address with overflow correction

    for ( i = 0; i < 128; i++ ) {
        uint8_t b = get_memory(addr);
        abuf[i % 16] = isprint(b) ? ((char) b) : '.';   // Prepare end of dump in ASCII format

        if ( i % 16 == 0 ) {                            // Handle line prefix 
            if (interact_with_tty) {
                printf(FNT_CLR"%04X"FNT_RST":   ", addr);
            } else {
                printf("%04X:   ", addr);               // Non-color output for non-active tty
            }
        }

        printf("%02X ", b);                             // Hex dump of actual byte

        if (i % 16 == 15) printf("   %s\n", abuf);      // Suffix line with ASCII dump

        addr = (addr + 1) % 0x10000;                    // Next address with overflow correction
    }
    return 0;
}



static int cmd_set(int argc, char **argv)
{
    struct reg *search = &registers[0];

    if ( argc == 3 ) {
        char *end;
        int val = parse_number(argv[2], &end);

        if ( end != NULL ) {
            while ( search->name != NULL ) {
                if ( strcmp(argv[1], search->name) == 0 ) {
                    if ( search->word ) {
                        *search->word = val % 65536;
                    } else {
                        *search->low = val % 256;
                        if ( search->high != NULL ) {
                            *search->high = (val % 65536) / 256;
                        }
                    }
                    break;
                }
                search++;
            }
        }
    } else {
        printf("Incorrect number of arguments\n");
    }
    return 0;
}



static int cmd_out(int argc, char **argv)
{
    if ( argc == 3 ) {
        char *end;
        int port = parse_number(argv[1], &end);
        int value = parse_number(argv[2], &end);

        printf("Writing IO: out(%d),%d\n",port,value);
        out(port,value);
    }
    return 0;
}



static int cmd_trace(int argc, char **argv)
{
    if ( argc == 2 ) {
        if ( strcmp(argv[1], "on") == 0 ) {
            trace = 1;
        } else if ( strcmp(argv[1],"off") == 0 ) {
            trace = 0;
        }
        printf("Tracing is %s\n", trace ? "on" : "off");
    }
    return 0;
}



static int cmd_hotspot(int argc, char **argv)
{
    if ( argc == 2 ) {
        if ( strcmp(argv[1], "on") == 0 ) {
            hotspot = 1;
        } else if ( strcmp(argv[1],"off") == 0 ) {
            hotspot = 0;
        }
        printf("Hotspots are %s\n", hotspot ? "on" : "off");
    }
    return 0;
}



static int cmd_help(int argc, char **argv)
{
    command *cmd = &commands[0];


    if ( argc == 1 ) {
        while ( cmd->cmd != NULL ) {
            if (interact_with_tty)
                printf(FNT_CLR"%-7s\t%-20s"FNT_RST"\t%s\n",cmd->cmd, cmd->options, cmd->help);
            else // Original output for non-active tty
                printf("%-10s\t%-20s\t%s\n",cmd->cmd, cmd->options, cmd->help);

             cmd++;
         }
    } else if ( strcmp(argv[1],"break") == 0 ) {
        printf("break [address/label]             - Break at address\n");
        printf("break delete [index]              - Delete breakpoint\n");
        printf("break disable [index]             - Disable breakpoint\n");
        printf("break enable [index]              - Enabled breakpoint\n");
        printf("break memory8 [address] [value]   - Break when [address/label] is value\n");
        printf("break memory16 [address] [value]  - Break when [address/label] is value\n");
        printf("break register [register] [value] - Break when [register] is value\n");
    } else if ( strcmp(argv[1],"watch") == 0 ) {
        printf("watch delete [index]              - Delete breakpoint\n");
        printf("watch disable [index]             - Disable breakpoint\n");
        printf("watch enable [index]              - Enabled breakpoint\n");
        printf("watch read [address]              - Break when [address] is read\n");
        printf("watch write [address]             - Break when [address] is written\n");
    }
     return 0;
}



static int cmd_quit(int argc, char **argv)
{
    exit(0);
}



static int cmd_list(int argc, char **argv)
{
    int addr = pc;
    const char *filename;
    int   lineno;

    if ( debug_find_source_location(addr, &filename, &lineno) < 0 ) {
        printf("No mapping found for $%04x\n",pc);
    } else {
        srcfile_display(filename, lineno - 5, 10, lineno);
    }

    return 0;
}


static void print_hotspots()
{
    char   buf[256];
    int    i;
    FILE  *fp;

    if ( hotspot == 0 ) return;
    memory_reset_paging();
    if ( (fp = fopen("hotspots", "w")) != NULL ) {
        for ( i = 0; i < max_hotspot_addr; i++) {
            if ( hotspots[i] != 0 ) {
                disassemble2(i, buf, sizeof(buf), 1);
                fprintf(fp, "%d\t%d\t\t%s\n",hotspots[i],hotspots_t[i],buf);
            }
        }
        fclose(fp);
    }
}
