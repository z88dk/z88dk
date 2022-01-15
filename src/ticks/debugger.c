
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <signal.h>
#ifdef WIN32
#include <io.h>
#else
#include <unistd.h>                         // For declarations of isatty()
#endif

#include "debugger.h"
#include "utlist.h"

#include "disassembler.h"
#include "debug.h"
#include "backend.h"
#include "syms.h"
#include "linenoise.h"
#include "srcfile.h"


#define HISTORY_FILE ".ticks_history.txt"

#define FNT_CLR "\x1B[34m"              // Color (blue on black)
#define FNT_BLD "\x1B[34;1m"            // Bold color (bright blue on black)
#define FNT_BCK "\x1B[34;7m"            // Reverse color (white on blue)
#define FNT_RST "\x1B[0m"               // Reset colors to default value (gray on black)

#define CLR_REG
#define CLR_ADDR

struct reg {
    char    *name;
    uint8_t* (*low)(struct debugger_regs_t* regs);
    uint8_t* (*high)(struct debugger_regs_t* regs);
    uint16_t* (*word)(struct debugger_regs_t* regs);
};

static uint8_t* a(struct debugger_regs_t* regs) { return &regs->a; }
static uint8_t* b(struct debugger_regs_t* regs) { return &regs->b; }
static uint8_t* c(struct debugger_regs_t* regs) { return &regs->c; }
static uint8_t* d(struct debugger_regs_t* regs) { return &regs->d; }
static uint8_t* e(struct debugger_regs_t* regs) { return &regs->e; }
static uint8_t* h(struct debugger_regs_t* regs) { return &regs->h; }
static uint8_t* l(struct debugger_regs_t* regs) { return &regs->l; }

static uint8_t* a_(struct debugger_regs_t* regs) { return &regs->a_; }
static uint8_t* b_(struct debugger_regs_t* regs) { return &regs->b_; }
static uint8_t* c_(struct debugger_regs_t* regs) { return &regs->c_; }
static uint8_t* d_(struct debugger_regs_t* regs) { return &regs->d_; }
static uint8_t* e_(struct debugger_regs_t* regs) { return &regs->e_; }
static uint8_t* h_(struct debugger_regs_t* regs) { return &regs->h_; }
static uint8_t* l_(struct debugger_regs_t* regs) { return &regs->l_; }

static uint8_t* xh(struct debugger_regs_t* regs) { return &regs->xh; }
static uint8_t* xl(struct debugger_regs_t* regs) { return &regs->xl; }
static uint8_t* yh(struct debugger_regs_t* regs) { return &regs->yh; }
static uint8_t* yl(struct debugger_regs_t* regs) { return &regs->yl; }

static uint16_t* sp(struct debugger_regs_t* regs) { return &regs->sp; }
static uint16_t* pc(struct debugger_regs_t* regs) { return &regs->pc; }

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
static int cmd_next_source(int argc, char **argv);
static int cmd_step(int argc, char **argv);
static int cmd_step_source(int argc, char **argv);
static int cmd_continue(int argc, char **argv);
static int cmd_frame(int argc, char **argv);
static int cmd_up(int argc, char **argv);
static int cmd_down(int argc, char **argv);
static int cmd_print(int argc, char **argv);
static int cmd_info(int argc, char **argv);
static int cmd_backtrace(int argc, char **argv);
static int cmd_disassemble(int argc, char **argv);
static int cmd_finish(int argc, char **argv);
static int cmd_registers(int argc, char **argv);
static int cmd_break(int argc, char **argv);
static int cmd_watch(int argc, char **argv);
static int cmd_examine(int argc, char **argv);
static int cmd_set(int argc, char **argv);
static int cmd_out(int argc, char **argv);
static int cmd_trace(int argc, char **argv);
static int cmd_hotspot(int argc, char **argv);
static int cmd_list(int argc, char **argv);
static int cmd_restore(int argc, char **argv);
static int cmd_help(int argc, char **argv);
static int cmd_quit(int argc, char **argv);
static void print_hotspots();
static const char *resolve_to_label(int addr);

static command commands[] = {
    { "si",        cmd_step,        "",  NULL },
    { "s",         cmd_step_source, "",  NULL },
    { "ni",        cmd_next,        "",  NULL },
    { "n",         cmd_next_source, "",  NULL },
    { "bt",        cmd_backtrace,   "",  NULL },
    { "p",         cmd_print,       "",  NULL },
    { "b",         cmd_break,       "",  NULL },
    { "nexti",     cmd_next,        "",  "Step the instruction (over calls)" },
    { "next",      cmd_next_source, "",                     "Step one source line" },
    { "stepi",     cmd_step,        "",                     "Step the instruction (including into calls)" },
    { "step",      cmd_step_source, "",                     "Step one source line (including into calls)" },
    { "cont",      cmd_continue,    "",                     "Continue execution" },
    { "backtrace", cmd_backtrace,   "",                     "Show the execution stack" },
    { "frame",     cmd_frame,       "[<num>]",              "Set or see current frame" },
    { "up",        cmd_up,          "",                     "Go one frame up" },
    { "down",      cmd_down,        "",                     "Go one frame down" },
    { "print",     cmd_print,       "<expression>",         "Print an expression" },
    { "info",      cmd_info,        "locals,...",           "Get info request" },
    { "dis",       cmd_disassemble, "[<address>]",          "Disassemble from pc/<address>" },
    { "finish",    cmd_finish,      "",                     "Exit current function (and print result if any)" },
    { "reg",       cmd_registers,   "",                     "Display the registers" },
    { "break",     cmd_break,       "<address/label>",      "Handle breakpoints" },
    { "watch",     cmd_watch,       "<address/label>",      "Handle watchpoints" },
    { "x",         cmd_examine,     "<address>",            "Examine memory" },
    { "set",       cmd_set,         "<hl/h/l/...> <value>", "Set registers" },
    { "out",       cmd_out,         "<address> <value>",    "Send to IO bus"},
    { "trace",     cmd_trace,       "<on/off>",             "Disassemble every instruction"},
    { "hotspot",   cmd_hotspot,     "<on/off>",             "Track address counts and write to hotspots file"},
    { "list",      cmd_list,        "[<address>]",          "List the source code at location given or pc"},
    { "help",      cmd_help,        "",                     "Display this help text" },
    { "restore",   cmd_restore,     "<path> [<address>]",   "Upload binary into machine memory"},
    { "quit",      cmd_quit,        "",   "Quit ticks"},
    { NULL, NULL, NULL }
};


breakpoint *breakpoints;
breakpoint *watchpoints;

       int debugger_active = 0;
       int break_required = 0;
       int next_address = -1;
       int trace = 0;
       int trace_source = 0;
static int hotspot = 0;
static int max_hotspot_addr = 0;
static int last_hotspot_addr;
static int last_hotspot_st;
static int hotspots[65536];
static int hotspots_t[65536];
static size_t current_frame = 0;
static int last_stacktrace_at = 0;

typedef enum {
    TMP_REASON_UNKNOWN = 0,
    TMP_REASON_FIN,
    TMP_REASON_STEP_SOURCE_LINE,
    TMP_REASON_NEXT_SOURCE_LINE,
} temporary_breakpoint_reason_t;

typedef struct temporary_breakpoint_t {
    temporary_breakpoint_reason_t   reason;
    uint32_t                        at;
    debug_sym_function*             callee;
    const char*                     source_file;
    int                             source_line;
    uint8_t                         external;
    struct temporary_breakpoint_t*  next;
} temporary_breakpoint_t;

// temporary breakpoints live to the point one of them is hit. in that case all of them has to be removed
static temporary_breakpoint_t* temporary_breakpoints = NULL;

static int interact_with_tty = 0;

void ctrl_c_handler(int dummy) {
    break_required = 1;
}

void debugger_init()
{
    signal(SIGINT, ctrl_c_handler);
    linenoiseSetCompletionCallback(completion, NULL);
    linenoiseHistoryLoad(HISTORY_FILE); /* Load the history at startup */
    atexit(print_hotspots);
    memset(hotspots, 0, sizeof(hotspots));
    interact_with_tty = isatty(fileno(stdin)) && isatty(fileno(stdout)); // Only colors with active tty
}

void unwrap_reg(uint16_t data, uint8_t* h, uint8_t* l)
{
#ifdef __BIG_ENDIAN__
    *l = *(((uint8_t *)&data) + 1);
    *h = *((uint8_t *)&data);
#else
    *h = *(((uint8_t *)&data) + 1);
    *l = *((uint8_t *)&data);
#endif
}

uint16_t wrap_reg(uint8_t h, uint8_t l)
{
    uint16_t data;
#ifdef __BIG_ENDIAN__
    *(((uint8_t *)&data) + 1) = l;
    *((uint8_t *)&data) = h;
#else
    *(((uint8_t *)&data) + 1) = h;
    *((uint8_t *)&data) = l;
#endif
    return data;
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

void debugger_process_signals()
{
    if (break_required)
    {
        printf("Requesting a break...\n");
        bk.break_();
        break_required = 0;
        return;
    }
}

static void add_temporary_internal_breakpoint(uint32_t address, temporary_breakpoint_reason_t reason,
    const char *source_filename, int source_lineno)
{
    temporary_breakpoint_t* tmp_step = malloc(sizeof(temporary_breakpoint_t));
    tmp_step->at = address;
    tmp_step->callee = NULL;
    tmp_step->external = 0;
    tmp_step->source_file = source_filename;
    tmp_step->source_line = source_lineno;
    tmp_step->reason = reason;
    LL_APPEND(temporary_breakpoints, tmp_step);
}

static void remove_temp_breakpoints()
{
    next_address = -1;

    // regardless of the reason we've stopped, all temp breakpoints have to be removed
    while (temporary_breakpoints) {
        if (temporary_breakpoints->external) {
            bk.remove_breakpoint(BK_BREAKPOINT_SOFTWARE, temporary_breakpoints->at, 1);
        }
        temporary_breakpoint_t* next = temporary_breakpoints->next;
        free(temporary_breakpoints);
        temporary_breakpoints = next;
    }
}

void debugger()
{
    static char *last_line = NULL;
    char   buf[256];
    char   prompt[300];
    char  *line;

    if ( last_line == NULL ) {
        last_line = strdup("");
    }

    if ( trace ) {
        cmd_registers(0, NULL);
        disassemble2(bk.pc(), buf, sizeof(buf), 0);

        if (interact_with_tty)
            printf( "\n%s\n\n",buf);    // In case of active tty, double LF to improve layout in case of 'cont'
        else
            printf("%s\n",buf);         // Unchanged in case of non-active tty
    }

    if ( hotspot ) {
        const unsigned short pc = bk.pc();
        const long long st = bk.st();

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

    int dodebug = 0;

    {
        temporary_breakpoint_t *temp_br;
        LL_FOREACH(temporary_breakpoints, temp_br) {
            if ((temp_br->at == 0xFFFFFFFF) || (bk.pc() == temp_br->at)) {
                dodebug = 1;
                temporary_breakpoint_reason_t reason = temp_br->reason;
                switch (reason) {
                    case TMP_REASON_FIN: {
                        struct debugger_regs_t regs;
                        bk.get_regs(&regs);
                        uint16_t hl = wrap_reg(regs.h, regs.l);
                        uint16_t de = wrap_reg(regs.d, regs.e);
                        uint32_t return_value = ((uint32_t)de << 16) | hl;
                        if (temp_br->callee) {
                            type_chain *ttt = temp_br->callee->type_record.first;
                            if (ttt->type_ == TYPE_FUNCTION) {
                                // skip DF
                                ttt = ttt->next;
                            }
                            if (ttt == NULL) {
                                printf("Warning: unknown callee return type, DEHL returned %08x.\n", return_value);
                            } else {
                                if (ttt->type_ != TYPE_VOID) {
                                    char resolved_result[128];
                                    debug_print_element(ttt, temp_br->callee->type_record.signed_,
                                        RESOLVE_BY_VALUE, return_value, resolved_result, 128);
                                    printf("function %s returned: %s\n", temp_br->callee->function_name,
                                        resolved_result);
                                }
                            }
                        } else {
                            printf("Warning: returned from a function without frame pointer.\n");
                        }
                        break;
                    }
                    case TMP_REASON_STEP_SOURCE_LINE:
                    case TMP_REASON_NEXT_SOURCE_LINE: {
                        const char *filename;
                        int   lineno;
                        const unsigned short pc = bk.pc();
                        if (debug_find_source_location(pc, &filename, &lineno) < 0) {
                            // don't know where we are, keep going
                            if (reason == TMP_REASON_STEP_SOURCE_LINE) {
                                bk.step();
                            } else {
                                bk.next();
                            }
                            return;
                        }
                        // we're still on the same source line
                        if ((strcmp(filename, temp_br->source_file) == 0) && (lineno == temp_br->source_line)) {
                            remove_temp_breakpoints();
                            if (reason == TMP_REASON_STEP_SOURCE_LINE) {
                                add_temporary_internal_breakpoint(0xFFFFFFFF, reason, filename, lineno);
                                bk.step();
                            } else {
                                char  b[100];
                                int len = disassemble2(pc, b, sizeof(b), 0);
                                add_temporary_internal_breakpoint(pc + len, reason, filename, lineno);
                                bk.next();
                            }
                            return;
                        } else {
                            trace_source = 1;
                        }
                        break;
                    }
                    default: {
                        printf("Warning: unknown reason why we stopped on temporary breakpoint.\n");
                        break;
                    }
                }
            }
        }

        if (dodebug) {
            remove_temp_breakpoints();
        }
    }

    if ( bk.breakpoints_check() ) {
        int         i = 1;
        breakpoint *elem;
        LL_FOREACH(breakpoints, elem) {
            if ( elem->enabled == 0 ) {
                continue;
            }

            if ( elem->type == BREAK_PC && elem->value == bk.pc() ) {
                printf("Hit breakpoint %d: @%04x (%s)\n",i,bk.pc(),resolve_to_label(bk.pc()));
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_CHECK8 && bk.get_memory(elem->lcheck_arg) == elem->lvalue ) {
                printf("Hit breakpoint %d (%s = $%02x): @%04x (%s)\n",i,elem->text, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                elem->enabled = 0;
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_CHECK16 &&
                bk.get_memory(elem->lcheck_arg) == elem->lvalue  &&
                bk.get_memory(elem->hcheck_arg) == elem->hvalue  ) {
                printf("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                elem->enabled = 0;
                dodebug=1;
                break;
            } else if ( elem->type == BREAK_REGISTER) {
                struct reg* r = &registers[elem->lcheck_arg];
                struct debugger_regs_t regs;
                bk.get_regs(&regs);

                if (r->word) {
                    uint8_t* lc;
                    uint8_t* hc;
#ifdef __BIG_ENDIAN__
                    lc = ((uint8_t *)search->word(&regs)) + 1;
                    hc = ((uint8_t *)search->word(&regs));
#else
                    hc = ((uint8_t *)r->word(&regs)) + 1;
                    lc = ((uint8_t *)r->word(&regs));
#endif
                    if (*lc == elem->lvalue && *hc == elem->hvalue) {
                        printf("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                        elem->enabled = 0;
                        dodebug=1;
                        break;
                    }
                } else if (r->high == NULL) {
                    if (*(r->low(&regs)) == elem->lvalue) {
                        printf("Hit breakpoint %d (%s = $%02x): @%04x (%s)\n",i,elem->text, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                        elem->enabled = 0;
                        dodebug=1;
                        break;
                    }
                } else {
                    if (*(r->low(&regs)) == elem->lvalue && *(r->high(&regs)) == elem->hvalue)
                    {
                        printf("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                        elem->enabled = 0;
                        dodebug=1;
                        break;
                    }
                }
            }
            i++;
        }
    }

    if (debugger_active == 0)
    {
        if ( bk.pc() == next_address ) {
            next_address = -1;
            dodebug = 1;
        }
        /* Check breakpoints */
        if ( dodebug == 0 ) return;
    }

    if (trace_source) {
        trace_source = 0;
        const char *filename;
        int   lineno;
        if ( debug_find_source_location(bk.pc(), &filename, &lineno) < 0 ) {
            disassemble2(bk.pc(), buf, sizeof(buf), 0);
            printf("%s\n",buf);
        } else {
            printf("%s:\n", filename);
            srcfile_display(filename, lineno - 1, 2, lineno);
        }
    } else if (trace == 0) { // Prevent two lines with the same information
        disassemble2(bk.pc(), buf, sizeof(buf), 0);
        printf("%s\n",buf);
    }

    /* In the debugger, loop continuously for commands */

    uint16_t sym_offset;
    symbol* sym = symbol_find_lower(bk.pc(), SYM_ADDRESS, &sym_offset);
    if (sym == NULL) {
        buf[0] = 0;
    } else {
        snprintf(buf,sizeof(buf),"%s+%d", sym->name, sym_offset);
    }

    if (interact_with_tty)
        snprintf(prompt,sizeof(prompt), "\n" FNT_BCK "    $%04x    (%s)>" FNT_RST " ", bk.pc(), buf);
    else                                                                                // Original output for non-active tty
        snprintf(prompt,sizeof(prompt), " %04x (%s)>", bk.pc(), buf);

    if (last_stacktrace_at != bk.pc()) {
        last_stacktrace_at = bk.pc();
        current_frame = 0;
    }

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
                command* ambiguous_commands[16] = {0};
                int ambigious_commands_num = 0;
                while ( cmd->cmd ) {
                    if ( strcmp(argv[0], cmd->cmd) == 0 ) {
                        return_to_execution = cmd->func(argc, argv);
                        ambigious_commands_num = 0;
                        break;
                    }
                    if ( strstr(cmd->cmd, argv[0]) == cmd->cmd) {
                        if (ambigious_commands_num < 16) {
                            ambiguous_commands[ambigious_commands_num++] = cmd;
                        }
                    }
                    cmd++;
                }
                if (ambigious_commands_num == 1)
                {
                    return_to_execution = ambiguous_commands[0]->func(argc, argv);
                } else if (ambigious_commands_num > 1) {
                    printf("The following commands could match, which one is ambiguous:\n");
                    for (int i = 0; i < ambigious_commands_num; i++) {
                        printf("    %s\n", ambiguous_commands[i]->cmd);
                    }
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
            bk.break_();
            break;
        }
    }
}



static int cmd_next(int argc, char **argv)
{
    bk.next();
    return 1;  /* We should exit the loop */
}


static int cmd_next_source(int argc, char **argv)
{
    const char *filename;
    int   lineno;
    const unsigned short pc = bk.pc();
    if (debug_find_source_location(pc, &filename, &lineno) < 0) {
        printf("Warning: cannot obtain current source line.\n");
        return 0;
    }
    uint16_t break_at;
    {
        char  buf[100];
        int len = disassemble2(pc, buf, sizeof(buf), 0);
        break_at = pc + len;
    }
    add_temporary_internal_breakpoint(break_at, TMP_REASON_NEXT_SOURCE_LINE, filename, lineno);
    bk.next();
    return 1;
}

static int cmd_step(int argc, char **argv)
{
    bk.step();
    return 1;  /* We should exit the loop */
}

static int cmd_step_source(int argc, char **argv)
{
    const char *filename;
    int   lineno;
    const unsigned short pc = bk.pc();
    if (debug_find_source_location(pc, &filename, &lineno) < 0) {
        printf("Warning: cannot obtain current source line.\n");
        return 0;
    }

    add_temporary_internal_breakpoint(0xFFFFFFFF, TMP_REASON_STEP_SOURCE_LINE, filename, lineno);
    bk.step();
    return 1;
}

static int cmd_continue(int argc, char **argv)
{
    bk.resume();
    debugger_active = 0;
    return 1;
}

static void print_frame(debug_frame_pointer *fp, debug_frame_pointer *current, uint16_t initial_stack)
{
    symbol* sym = fp->symbol;

    const char* frame_marker = fp == current ? " * " : "   ";

    if (sym && fp->filename && fp->function) {
        debug_sym_function* fn = fp->function;
        if (fn != NULL) {
            char function_args[255] = {0};
            debug_sym_function_argument* arg = fn->arguments;
            uint8_t first_arg = 1;
            while (arg) {
                debug_sym_symbol* s = arg->symbol;

                if (!debug_symbol_valid(s, initial_stack, fp)) {
                    arg = arg->next;
                    // those vars do not exist yet
                    continue;
                }

                if (!first_arg) {
                    strcat(function_args, ", ");
                }
                char arg_text[64];
                char arg_value[20];
                if (debug_get_symbol_value(s, fp, arg_value, sizeof(arg_value))) {
                    strcpy(arg_value, "unknown");
                }
                sprintf(arg_text, "%s=%s", s->symbol_name, arg_value);
                strcat(function_args, arg_text);
                first_arg = 0;
                arg = arg->next;
            }

            if (fp->offset == 0xFFFF) {
                printf("%sfunction %s+??? (unreliable offset, %s)\n       at %s\n", frame_marker,
                    fn->function_name, function_args, fp->filename);
            } else {
                printf("%sfunction %s+%d (%s)\n       at %s:%d\n", frame_marker,
                    fn->function_name, fp->offset, function_args,
                    fp->filename, fp->lineno);
            }
        } else {
            if (fp->offset == 0xFFFF) {
                printf("%s%s+??? (unreliable offset) at %s\n", frame_marker, sym->name, fp->filename);
            } else {
                printf("%s%s+%d at %s:%d\n", frame_marker, sym->name, fp->offset, fp->filename, fp->lineno);
            }
        }

    } else {
        char location[FILENAME_MAX + 4];
        if (fp->filename) {
            if (fp->lineno) {
                sprintf(location, "%s:%d", fp->filename, fp->lineno);
            } else {
                sprintf(location, "%s", fp->filename);
            }
        } else {
            if (fp->symbol && fp->symbol->file) {
                sprintf(location, "%s", fp->symbol->file);
            } else {
                sprintf(location, "%s", "unknown location");
            }
        }
        if (sym) {
            printf("%s%s+%d\n       at %s\n", frame_marker, sym->name, fp->offset, location);
        } else {
            printf("%s$%04x\n       at %s\n", frame_marker, fp->address, location);
        }
    }
}

static int cmd_frame(int argc, char **argv)
{
    struct debugger_regs_t regs;
    bk.get_regs(&regs);
    uint16_t stack = regs.sp;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
    size_t frames_count = debug_stack_frames_count(first_frame_pointer);

    if (argc > 1)
    {
        current_frame = strtol(argv[1], NULL, 10);
    }

    if (current_frame >= frames_count)
    {
        current_frame = frames_count - 1;
    }

    debug_frame_pointer* frame_at = debug_stack_frames_at(first_frame_pointer, current_frame);
    if (frame_at != NULL) {
        printf("frame %zu\n", current_frame);
        print_frame(frame_at, frame_at, stack);
    } else {
        printf("frame unknown.\n");
    }

    debug_stack_frames_free(first_frame_pointer);
    return 0;
}

static int cmd_up(int argc, char **argv)
{
    current_frame++;
    return cmd_frame(0, NULL);
}

static int cmd_down(int argc, char **argv)
{
    if (current_frame > 0)
    {
        current_frame--;
    }
    return cmd_frame(0, NULL);
}

static int cmd_print(int argc, char **argv)
{
    return 0;
}

static int cmd_info(int argc, char **argv)
{
    if (argc < 2) {
        return 0;
    }

    if (strcmp(argv[1], "locals") == 0) {
        struct debugger_regs_t regs;
        bk.get_regs(&regs);

        uint16_t stack = regs.sp;
        uint16_t initial_stack = stack;
        uint16_t at = bk.pc();

        debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
        debug_frame_pointer* fp = debug_stack_frames_at(first_frame_pointer, current_frame);

        debug_sym_function* fn = fp->function;
        if (fn != NULL) {
            char function_args[255] = {0};
            debug_sym_function_argument* arg = fn->arguments;
            while (arg) {
                debug_sym_symbol* s = arg->symbol;

                char arg_text[128];
                char arg_value[128];

                if (!debug_symbol_valid(s, initial_stack, fp)) {
                    strcpy(arg_value, "<invalid>");
                } else if (debug_get_symbol_value(s, fp, arg_value, sizeof(arg_value))) {
                    strcpy(arg_value, "<unknown>");
                }
                printf("  %s=%s\n", s->symbol_name, arg_value);
                arg = arg->next;
            }
        }

        debug_stack_frames_free(first_frame_pointer);
    }

    return 0;
}

static int cmd_backtrace(int argc, char **argv)
{
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
    if (first_frame_pointer == NULL) {
        uint16_t offset;
        symbol* sym = symbol_find_lower(at, SYM_ADDRESS, &offset);
        if (sym != NULL) {
            printf("Warning: no backtrace is available for symbol '%s'.\n", sym->name);
        } else {
            printf("Warning: current location is unknown.\n");
            return 0;
        }
    }

    debug_frame_pointer* fp = first_frame_pointer;
    debug_frame_pointer* current = debug_stack_frames_at(first_frame_pointer, current_frame);

    while (fp) {
        print_frame(fp, current, initial_stack);
        fp = fp->next;
    }

    debug_stack_frames_free(first_frame_pointer);
    return 0;
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

    uint16_t offset;
    symbol* s = symbol_find_lower(addr, SYM_ADDRESS, &offset);
    if (s == NULL) {
        return "<unknown>";
    }

    snprintf(tbuf,sizeof(tbuf),"%s+%d", s->name, offset);
    return tbuf;
}



static int cmd_disassemble(int argc, char **argv)
{
    char buf[256];
    int i = 0;
    int where = -1;
    const unsigned short pc = bk.pc();

    if ( argc == 2 ) {
        where = parse_address(argv[1]);
    }

    if ( where == -1 )
    {
        struct debugger_regs_t regs;
        bk.get_regs(&regs);
        uint16_t stack = regs.sp;

        debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(pc, stack, &regs, 0);
        debug_frame_pointer* frame_at = debug_stack_frames_at(first_frame_pointer, current_frame);
        if (frame_at)
        {
            if (current_frame) {
                printf("Showing disassembly at frame %zu ($%04x), current pc is at $%04x\n",
                    current_frame, frame_at->address, pc);
            }
            where = frame_at->address;
        }
        else
        {
            where = pc;
        }

        debug_stack_frames_free(first_frame_pointer);
    }

    while ( i < 10 ) {
       where += disassemble2(where, buf, sizeof(buf), 0);
       printf("%s\n",buf);
       i++;
    }
    return 0;
}



static int cmd_registers(int argc, char **argv) 
{
    bk.invalidate();
    const unsigned short pc = bk.pc();
    const unsigned short sp = bk.sp();

    struct debugger_regs_t regs;
    bk.get_regs(&regs);

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

            bk.f()  | regs.a << 8,  regs.c  | regs.b  << 8, regs.e  | regs.d  << 8, regs.l  | regs.h  << 8, regs.xl | regs.xh << 8,
            (bk.f()  & 0x80) ? 1 : 0, (bk.f()  & 0x40) ? 1 : 0, (bk.f()  & 0x10) ? 1 : 0, (bk.f()  & 0x04) ? 1 : 0, (bk.f()  & 0x02) ? 1 : 0, (bk.f()  & 0x01) ? 1 : 0,

            bk.f_() | regs.a_ << 8, regs.c_ | regs.b_ << 8, regs.e_ | regs.d_ << 8, regs.l_ | regs.h_ << 8, regs.yl | regs.yh << 8,

            pc, bk.get_memory(pc), sp, (bk.get_memory(sp+1) << 8 | bk.get_memory(sp))
            );
    } else {  // Original output for non-active tty
        printf("pc=%04X, [pc]=%02X,    bc=%04X,  de=%04X,  hl=%04X,  af=%04X, ix=%04X, iy=%04X\n"
               "sp=%04X, [sp]=%04X, bc'=%04X, de'=%04X, hl'=%04X, af'=%04X\n"
               "f: S=%d Z=%d H=%d P/V=%d N=%d C=%d\n",
               pc, bk.get_memory(pc), regs.c | regs.b << 8, regs.e | regs.d << 8, regs.l | regs.h << 8, bk.f() | regs.a << 8, regs.xl | regs.xh << 8, regs.yl | regs.yh << 8,
               sp, (bk.get_memory(sp+1) << 8 | bk.get_memory(sp)), regs.c_ | regs.b_ << 8, regs.e_ | regs.d_ << 8, regs.l_ | regs.h_ << 8, bk.f_() | regs.a_ << 8,
               (bk.f() & 0x80) ? 1 : 0, (bk.f() & 0x40) ? 1 : 0, (bk.f() & 0x10) ? 1 : 0, (bk.f() & 0x04) ? 1 : 0, (bk.f() & 0x02) ? 1 : 0, (bk.f() & 0x01) ? 1 : 0);
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

static int cmd_finish(int argc, char **argv)
{
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 1);

    if (first_frame_pointer && first_frame_pointer->return_address) {

        temporary_breakpoint_t* tmp = malloc(sizeof(temporary_breakpoint_t));
        tmp->at = first_frame_pointer->return_address;
        tmp->callee = first_frame_pointer->function;
        tmp->external = 1;
        tmp->reason = TMP_REASON_FIN;
        LL_APPEND(temporary_breakpoints, tmp);

        bk.add_breakpoint(BK_BREAKPOINT_SOFTWARE, first_frame_pointer->return_address, 1);
        debug_stack_frames_free(first_frame_pointer);
        debugger_active = 0;
        trace_source = 1;
        bk.resume();
        return 1;
    } else {
        debug_stack_frames_free(first_frame_pointer);
        printf("Warning: return address is unknown, cannot fin.\n");
    }

    return 0;
}

static int cmd_break(int argc, char **argv)
{
    const unsigned short pc = bk.pc();

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
            }  else if ( elem->type == BREAK_REGISTER ) {
                struct reg* r = &registers[elem->lcheck_arg];
                if (r->high == NULL && r->word == NULL) {
                    printf("%d\t%s = $%02x%s\n",i, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
                } else {
                    printf("%d\t%s = $%04x%s\n",i, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
                }
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
            bk.add_breakpoint(BK_BREAKPOINT_SOFTWARE, value, 1);
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
                bk.remove_breakpoint(BK_BREAKPOINT_SOFTWARE, elem->value, 1);
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
                bk.disable_breakpoint(BK_BREAKPOINT_SOFTWARE, elem->value, 1);
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
                bk.enable_breakpoint(BK_BREAKPOINT_SOFTWARE, elem->value, 1);
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
            memset(elem, 0, sizeof(breakpoint));
            elem->type = BREAK_CHECK8;
            elem->lcheck_arg = value;
            elem->lvalue = parse_number(argv[4], &end);
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
            printf("Adding breakpoint for %s = $%02x\n", elem->text, elem->lvalue);
            bk.add_breakpoint(BK_BREAKPOINT_WATCHPOINT, elem->value, 1);
        }
    } else if ( argc == 5 && strcmp(argv[1], "memory16") == 0 ) {
        char *end;
        int addr = parse_address(argv[2]);

        if ( addr != -1 ) {
            int value = parse_number(argv[4],&end);
            breakpoint *elem = malloc(sizeof(*elem));
            memset(elem, 0, sizeof(breakpoint));
            elem->type = BREAK_CHECK16;
            elem->lcheck_arg = addr;
            elem->lvalue = value % 256;
            elem->hcheck_arg = addr+1;
            elem->hvalue = (value % 65536 ) /    256;
            elem->enabled = 1;
            elem->text = strdup(argv[2]);
            LL_APPEND(breakpoints, elem);
            printf("Adding breakpoint for %s = $%02x%02x\n", elem->text, elem->hvalue, elem->lvalue);
            bk.add_breakpoint(BK_BREAKPOINT_WATCHPOINT, elem->value, 2);
        }
    } else if ( argc == 5 && strncmp(argv[1], "register",3) == 0 ) {
        struct reg *search = &registers[0];

        uint8_t search_idx = 0;
        while ( search->name != NULL  ) {
            if ( strcmp(search->name, argv[2]) == 0 ) {
                break;
            }
            search++;
            search_idx++;
        }

        if ( search->name != NULL ) {
            int value = atoi(argv[4]);
            breakpoint *elem = malloc(sizeof(*elem));
            memset(elem, 0, sizeof(breakpoint));
            elem->type = BREAK_REGISTER;
            elem->lcheck_arg = search_idx;
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
            bk.add_breakpoint(BK_BREAKPOINT_REGISTER, search_idx, 1);

        } else {
            printf("No such register %s\n",argv[2]);
        }

    }
    return 0;
}



static int cmd_examine(int argc, char **argv)
{
    const unsigned short pc = bk.pc();

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
        uint8_t b = bk.get_memory(addr);
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

        struct debugger_regs_t regs;

        if ( end != NULL ) {
            bk.get_regs(&regs);

            while ( search->name != NULL ) {
                if ( strcmp(argv[1], search->name) == 0 ) {
                    if ( search->word ) {
                        *search->word(&regs) = val % 65536;
                    } else {
                        *search->low(&regs) = val % 256;
                        if ( search->high != NULL ) {
                            *search->high(&regs) = (val % 65536) / 256;
                        }
                    }
                    break;
                }
                search++;
            }

            bk.set_regs(&regs);
        }


    } else {
        printf("Incorrect number of arguments\n");
    }
    return 1;
}



static int cmd_out(int argc, char **argv)
{
    if ( argc == 3 ) {
        char *end;
        int port = parse_number(argv[1], &end);
        int value = parse_number(argv[2], &end);

        printf("Writing IO: out(%d),%d\n",port,value);
        bk.out(port,value);
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
            if (cmd->help != NULL) {
                if (interact_with_tty)
                    printf(FNT_CLR"%-10s\t%-20s"FNT_RST"\t%s\n", cmd->cmd, cmd->options, cmd->help);
                else // Original output for non-active tty
                    printf("%-10s\t%-20s\t%s\n", cmd->cmd, cmd->options, cmd->help);
            }
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
    bk.detach();
    exit(0);
}

static int cmd_restore(int argc, char **argv)
{
    int address;
    if ( argc == 3 ) {
        address = parse_address(argv[2]);
    } else {
        address = symbol_resolve("__head");
        if (address == -1) {
            printf("Warning: could not resolve starting address and no address is provided.\n");
            return 0;
        }
    }

    if (bk.restore(argv[1], address))
    {
        return 0;
    }

    return 1;
}

static int cmd_list(int argc, char **argv)
{
    int addr;
    int offset;

    {
        struct debugger_regs_t regs;
        bk.get_regs(&regs);
        uint16_t stack = regs.sp;
        uint16_t at = bk.pc();

        debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
        debug_frame_pointer* frame_at = debug_stack_frames_at(first_frame_pointer, current_frame);
        if (frame_at)
        {
            addr = frame_at->address;
            offset = frame_at->offset;
        }
        else
        {
            addr = at;
            offset = 0;
        }

        debug_stack_frames_free(first_frame_pointer);
    }

    const char *filename;
    int   lineno;

    if ( argc == 2 ) {
        int a2 = parse_address(argv[1]);

        if ( a2 != -1 ) {
            addr = a2;
        }
    }

    if (offset == 0xFFFF) {
        printf("Warning: offset is unreliable, call could have happened from anywhere of this function.\n");
    }

    if ( debug_find_source_location(addr, &filename, &lineno) < 0 ) {
        printf("No mapping found for $%04x\n", addr);
        return 0;
    }
    srcfile_display(filename, lineno - 5, 10, lineno);
    
    return 0;
}


static void print_hotspots()
{
    char   buf[256];
    int    i;
    FILE  *fp;

    if ( hotspot == 0 ) return;
    bk.memory_reset_paging();
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
