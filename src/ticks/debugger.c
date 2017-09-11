
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "utlist.h"

#include "ticks.h"
#include "linenoise.h"

#define HISTORY_FILE ".ticks_history.txt"



typedef enum {
    BREAK_PC,
    BREAK_CHECK8,
    BREAK_CHECK16
} breakpoint_type;

typedef struct breakpoint {
    breakpoint_type    type;
    int                value;
    void              *check_ptr;
    char               enabled;
    char              *text;
    struct breakpoint *next;
} breakpoint;

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
static int cmd_examine(int argc, char **argv);
static int cmd_set(int argc, char **argv);
static int cmd_trace(int argc, char **argv);
static int cmd_hotspot(int argc, char **argv);
static int cmd_help(int argc, char **argv);
static int cmd_quit(int argc, char **argv);
static void print_hotspots();



static command commands[] = {
    { "next",   cmd_next,          "",  "Step the instruction (over calls)" },
    { "step",   cmd_step,          "",  "Step the instruction (including into calls)" },
    { "cont",   cmd_continue,      "",  "Continue execution" },
    { "dis",    cmd_disassemble,   "[<address>]",  "Disassemble from pc/<address>" },
    { "reg",    cmd_registers,     "",  "Display the registers" },
    { "break",  cmd_break,         "<address/label>",  "Handle breakpoints" },
    { "x",      cmd_examine,       "<address>",   "Examine memory" },
    { "set",    cmd_set,           "<hl/h/l/...> <value>",  "Set registers" },
    { "trace",  cmd_trace,         "<on/off>", "Disassemble every instruction"},
    { "hotspot",cmd_hotspot,       "<on/off>", "Track address counts and write to hotspots file"},
    { "help",   cmd_help,          "",   "Display this help text" },
    { "quit",   cmd_quit,          "",   "Quit ticks"},
    { NULL, NULL, NULL }
};


static breakpoint *breakpoints;

static int debugger_active = 1;
static int next_address = -1;
static int trace = 0;
static int hotspot = 0;
static int max_hotspot_addr = 0;
static int hotspots[65536];


void debugger_init()
{
    linenoiseSetCompletionCallback(completion, NULL);
    linenoiseHistoryLoad(HISTORY_FILE); /* Load the history at startup */
    atexit(print_hotspots);
    memset(hotspots, 0, sizeof(hotspots));
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

void debugger()
{
    char   buf[256];
    char   prompt[100];
    char  *line;

    if ( trace ) {
        disassemble(pc, buf, sizeof(buf));
        printf("%s\n",buf);     
    }

    if ( hotspot ) {
        if ( pc > max_hotspot_addr) {
            max_hotspot_addr = pc;
        }
        hotspots[pc]++;
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
                printf("Hit breakpoint %d\n",i);
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_CHECK8 && *(uint8_t *)elem->check_ptr == elem->value ) {
                printf("Hit breakpoint %d\n",i);
                elem->enabled = 0;
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_CHECK16 && 
                        *(uint8_t *)elem->check_ptr == (elem->value % 256) &&
                         *(((uint8_t *)elem->check_ptr)+1) == (elem->value %65536) / 256 ) {
                printf("Hit breakpoint %d\n",i);
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


    disassemble(pc, buf, sizeof(buf));
    printf("%s\n",buf);
    /* In the debugger, loop continuously for commands */
    snprintf(prompt,sizeof(prompt)," %04x >", pc);  // TODO: Symbol address

    while ( (line = linenoise(prompt) ) != NULL ) {
        int argc;
        char **argv;
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
            if ( return_to_execution ) {
                /* Out of the linenoise loop */
                break;
            }
        } else {
            /* Empty line is step */
            debugger_active = 1;
            break;
        }
    }
}





static int cmd_next(int argc, char **argv)
{
    char  buf[100];
    int   len;
    uint8_t opcode = mem[pc];

    len = disassemble(pc, buf, sizeof(buf));

    // Set a breakpoint after the call
    printf("%02x %02x %02x\n",opcode,opcode & 0xc0, opcode & 0x07);
    switch ( opcode ) {
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

static int cmd_disassemble(int argc, char **argv)
{
    char  buf[256];
    int   i = 0;
    int   where = pc;

    if ( argc == 2 ) {
        char *end;
        where = strtol(argv[1], &end, 0);
    }

    while ( i < 10 ) {
       where += disassemble(where, buf, sizeof(buf));
       printf("%s\n",buf);
       i++;
    }
    return 0;
}

static int cmd_registers(int argc, char **argv) 
{
    printf("pc\t%04x\t\tsp\t%04x\n", pc,sp);
    
    printf("a\t%02x\t\ta'\t%02x\n",a,a_);
    printf("hl\t%02x%02x\t\thl'\t%02x%02x\n", h, l, h_, l_);
    printf("de\t%02x%02x\t\tde'\t%02x%02x\n", d, e, d_, e_);
    printf("bc\t%02x%02x\t\tbc'\t%02x%02x\n", b, c, b_, c_);
    printf("ix\t%02x%02x\t\tiy\t%02x%02x\n", xh, xl, yh, yl);
    
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
                printf("%d:\tPC = $%04x%s\n",i, elem->value,elem->enabled ? "" : " (disabled)");
            } else if ( elem->type == BREAK_CHECK8 ) {
                printf("%d\t%s = $%02x%s\n",i, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
            } else if ( elem->type == BREAK_CHECK16 ) {
                printf("%d\t%s = $%04x%s\n",i, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
            }
            i++;
        }
    } else if ( argc == 2 && strcmp(argv[2],"--help") == 0 ) {
        printf("Breakpoint help - to be written\n");
    } else if ( argc == 2 ) {
        char *end;
        const char *sym;
        breakpoint *elem;
        int value = strtol(argv[1], &end,0);

        if ( end != argv[1] ) {
            elem = malloc(sizeof(*elem));
            elem->type = BREAK_PC;
            elem->value = value;
            elem->enabled = 1;
            LL_APPEND(breakpoints, elem);
            sym = find_symbol(value);
            printf("Adding breakpoint at '%s' $%04x (%s)\n",argv[1], value,  sym ? sym : "<unknown>");
        } else {
            int value = symbol_resolve(argv[1]);

            if ( value != -1 ) {
                elem = malloc(sizeof(*elem));
                elem->type = BREAK_PC;
                elem->value = value;
                elem->enabled = 1;
                LL_APPEND(breakpoints, elem);
                sym = find_symbol(value);
                printf("Adding breakpoint at '%s', $%04x (%s)\n",argv[1], value, sym ? sym : "<unknown>");
            } else {
                printf("Cannot break on '%s'\n",argv[1]);
            }
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
        int value = strtol(argv[2], &end,0);
        
        if ( end == argv[2] ) {
            value =  symbol_resolve(argv[2]);
        }
       
        if ( value != -1 ) {
            breakpoint *elem = malloc(sizeof(*elem));
            elem->type = BREAK_CHECK8;
            elem->check_ptr = &mem[value % 65536];
            elem->value = atoi(argv[4]);
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
        }      
    } else if ( argc == 5 && strcmp(argv[1], "memory16") == 0 ) {
        char  *end;
        int value = strtol(argv[2], &end,0);
        
        if ( end == argv[2] ) {
            value =  symbol_resolve(argv[2]);
        }
       
        if ( value != -1 ) {
            breakpoint *elem = malloc(sizeof(*elem));
            elem->type = BREAK_CHECK16;
            elem->check_ptr = &mem[value % 65536];
            elem->value = atoi(argv[4]);
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
        }      
    } else if ( argc == 5 && strncmp(argv[1], "reg",3) == 0 ) {
        
    }
    return 0;
}

static int cmd_examine(int argc, char **argv)
{
    if ( argc == 2 ) {
        char *end;
        int addr = strtol(argv[1], &end, 0);

        if ( end != argv[1] ) {
            char  buf[100];
            char  abuf[17];
            size_t offs;
            int    i;

            abuf[16] = 0;
            addr %= 65536;

            offs = snprintf(buf,sizeof(buf),"%04x: ", addr);
            for ( i = 0; i < 128; i++ ) {
                uint8_t b = mem[ (addr + i) % 65536];
                offs += snprintf(buf + offs, sizeof(buf) - offs,"%02x ", b);
                abuf[i % 16] = isprint(b) ? b : '.';
                if ( i % 16 == 15  && i != 0 ) {
                    printf("%s  %s\n",buf,abuf);
                    offs = snprintf(buf,sizeof(buf),"%04x: ", (addr + i) % 65536);
                }
            }
        }
    }
    return 0;
}

struct reg {
    char    *name;
    uint8_t  *low;
    uint8_t  *high;
    uint16_t *word;
};

static int cmd_set(int argc, char **argv)
{
    struct reg registers[] = {
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
    struct reg *search = &registers[0];

    if ( argc == 3 ) {
        char *end;
        int val = strtol(argv[2], &end, 0);

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

     while ( cmd->cmd != NULL ) {
         printf("%-10s\t%-20s\t%s\n",cmd->cmd, cmd->options, cmd->help);
         cmd++;
     }
     return 0;
}

static int cmd_quit(int argc, char **argv)
{
    exit(0);
}

uint8_t get_memory(int pc)
{
    return mem[pc % 65536];
}


static void print_hotspots()
{
    char   buf[256];
    int    i;
    FILE  *fp;

    if ( hotspot == 0 ) return;
    if ( (fp = fopen("hotspots", "w")) != NULL ) {
        for ( i = 0; i < max_hotspot_addr; i++) {
            if ( hotspots[i] != 0 ) {
                disassemble(i, buf, sizeof(buf));
                fprintf(fp, "%d\t\t%s\n",hotspots[i],buf);
            }
        }
        fclose(fp);
    }
}