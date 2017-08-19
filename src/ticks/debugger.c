
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "ticks.h"
#include "linenoise.h"

#define HISTORY_FILE ".ticks_history.txt"


typedef struct {
    char   *cmd;
    int   (*func)(int argc, char **argv);
    char   *help;
} command;



static void completion(const char *buf, linenoiseCompletions *lc);
static char **parse_words(char *line, int *argc);
static int cmd_step(int argc, char **argv);
static int cmd_continue(int argc, char **argv);
static int cmd_disassemble(int argc, char **argv);
static int cmd_registers(int argc, char **argv);




static command commands[] = {
    { "step",   cmd_step,           "Step the instruction" },
    { "cont",   cmd_continue,       "Continue execution" },
    { "dis",    cmd_disassemble,    "Disassemble current instruction" },
    { "reg",    cmd_registers,      "Display the registers" },
    { NULL, NULL, NULL }
};



static int debugger_active = 1;


void debugger_init()
{
    linenoiseSetCompletionCallback(completion);
    linenoiseHistoryLoad(HISTORY_FILE); /* Load the history at startup */
}


static void completion(const char *buf, linenoiseCompletions *lc) 
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
    char   prompt[100];
    char  *line;

    if ( debugger_active == 0 ) {
        /* Check breakpoints */
        return;
    }


    disassemble(mem + pc, pc);
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
        }
    }
}

static char **parse_words(char *line, int *argc)
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

static int cmd_step(int argc, char **argv)
{
    return 1;  /* We should exit the loop */
}

static int cmd_continue(int argc, char **argv)
{
    debugger_active = 0;
    return 1;
}

static int cmd_disassemble(int argc, char **argv)
{
    disassemble(mem + pc, pc);
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
