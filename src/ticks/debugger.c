
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <signal.h>
#ifdef WIN32
#include <WinSock2.h>
#include <io.h>
#define F_OK 0
#define access _access
#else
#include <unistd.h>                         // For declarations of isatty()
#include <stdarg.h>
#endif

#include "debugger.h"
#include "utlist.h"

#include "disassembler.h"
#include "debug.h"
#include "backend.h"
#include "profiler.h"
#include "syms.h"
#include "linenoise.h"
#include "srcfile.h"
#include "exp_engine.h"
#include "breakpoints.h"
#include "../common/dirname.h"

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

static int last_evaluation_id = 0;

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
static int cmd_stack(int argc, char **argv);
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
static int cmd_profiler(int argc, char **argv);
static int cmd_list(int argc, char **argv);
static int cmd_del_break(int argc, char **argv);
static int cmd_restore(int argc, char **argv);
static int cmd_restore_pc(int argc, char **argv);
static int cmd_typeof(int argc, char **argv);
static int cmd_help(int argc, char **argv);
static int cmd_quit(int argc, char **argv);
static void print_hotspots(void);

static command commands[] = {
    { "si",        cmd_step,        "",  NULL },
    { "s",         cmd_step_source, "",  NULL },
    { "ni",        cmd_next,        "",  NULL },
    { "n",         cmd_next_source, "",  NULL },
    { "bt",        cmd_backtrace,   "",  NULL },
    { "p",         cmd_print,       "",  NULL },
    { "b",         cmd_break,       "",  NULL },
    { "d",         cmd_del_break,   "",  NULL },
    { "nexti",     cmd_next,        "",  "Step the instruction (over calls)" },
    { "next",      cmd_next_source, "",                     "Step one source line" },
    { "stepi",     cmd_step,        "",                     "Step the instruction (including into calls)" },
    { "step",      cmd_step_source, "",                     "Step one source line (including into calls)" },
    { "cont",      cmd_continue,    "",                     "Continue execution" },
    { "backtrace", cmd_backtrace,   "",                     "Show the execution stack" },
    { "stack",     cmd_stack,       "[<size>]",             "Examine stack" },
    { "frame",     cmd_frame,       "[<num>]",              "Set or see current frame" },
    { "up",        cmd_up,          "",                     "Go one frame up" },
    { "down",      cmd_down,        "",                     "Go one frame down" },
    { "print",     cmd_print,       "<expression>",         "Print an expression" },
    { "info",      cmd_info,        "locals,...",           "Get info request" },
    { "dis",       cmd_disassemble, "[<address>] [<size>]", "Disassemble from pc/<address> a block of <size>" },
    { "finish",    cmd_finish,      "",                     "Exit current function (and print result if any)" },
    { "reg",       cmd_registers,   "",                     "Display the registers" },
    { "break",     cmd_break,       "<address/label>",      "Handle breakpoints" },
    { "delete",    cmd_del_break,   "<breakpoint id>",      "Delete breakpoint(s)" },
    { "watch",     cmd_watch,       "<address/label>",      "Handle watchpoints" },
    { "x",         cmd_examine,     "<address>",            "Examine memory" },
    { "set",       cmd_set,         "<hl/h/l/...> <value>", "Set registers" },
    { "out",       cmd_out,         "<address> <value>",    "Send to IO bus"},
    { "trace",     cmd_trace,       "<on/off>",             "Disassemble every instruction"},
    { "hotspot",   cmd_hotspot,     "<on/off>",             "Track address counts and write to hotspots file"},
    { "profiler",  cmd_profiler,    "[-f fun][-i iter]",    "start/stop profiling (-f function limit, -i iteration limit)"},
    { "list",      cmd_list,        "[<address>]",          "List the source code at location given or pc"},
    { "help",      cmd_help,        "",                     "Display this help text" },
    { "whatis/rmt",cmd_typeof,      "",                     NULL },
    { "restore",   cmd_restore,     "<path> [<address>]",   "Upload binary into machine memory, keep PC intact"},
    { "restore_pc",cmd_restore_pc,  "<path> [<address>]",   "Upload binary into machine memory and set PC to that address"},
    { "quit",      cmd_quit,        "",   "Quit ticks"},
    { NULL, NULL, NULL }
};

static void print_breakpoints();
static void info_section_locals();
static void info_section_globals();

static struct {
    const char* name;
    const char* help;
    void (*cb)();
} cmd_info_sections[] = {
    {"breakpoints",     "show breakpoints",                     print_breakpoints},
    {"locals",          "show local variables",                 info_section_locals},
    {"variables",       "show static/global variables",         info_section_globals},
    {NULL, NULL}
};

       int debugger_active = 0;
       int debugger_break_requested = 0;
       int trace = 0;
       int trace_source = 0;
static int hotspot = 0;
static int max_hotspot_addr = 0;
static int last_hotspot_addr;
static int last_hotspot_st;
static int hotspots[65536];
static int hotspots_t[65536];
size_t current_frame = 0;
static int last_stacktrace_at = 0;
UT_string* pending_executable_binary = NULL;

static int interact_with_tty = 0;

void ctrl_c_handler(int signum) {
    bk.ctrl_c();
}

void debugger_init() {
#ifdef _WIN32
			struct WSAData wsa;
			int ret = WSAStartup(MAKEWORD(2, 2), &wsa);
			if (ret) {
				bk.debug("Socket initialization error: %d\n", ret);
			}
#endif

    signal(SIGINT, ctrl_c_handler);
    linenoiseSetCompletionCallback(completion, NULL);
    linenoiseHistoryLoad(HISTORY_FILE); /* Load the history at startup */
    atexit(print_hotspots);
    memset(hotspots, 0, sizeof(hotspots));
    interact_with_tty = isatty(fileno(stdin)) && isatty(fileno(stdout)); // Only colors with active tty
    exp_engine_init();
}

uint8_t debugger_read_symbol_file(char* symbol_file) {
    if (access(symbol_file, F_OK)) {
        return 1;
    }

    read_symbol_file(symbol_file);

    char* filename = zbasename(symbol_file);
    char* ext;
    if ((ext = strrchr(filename, '.'))) {
        int filename_w_ext_len = (int)(ext - filename);
        char* dir = zdirname(symbol_file);
        if (pending_executable_binary) {
            utstring_free(pending_executable_binary);
        }

        // test <path>/<file>.bin first
        utstring_new(pending_executable_binary);
        utstring_printf(pending_executable_binary, "%s/%.*s.bin", dir, filename_w_ext_len, filename);
        if (access(utstring_body(pending_executable_binary), F_OK)) {
            // test <path>/<file> first
            utstring_clear(pending_executable_binary);
            utstring_printf(pending_executable_binary, "%s/%.*s", dir, filename_w_ext_len, filename);
            if (access(utstring_body(pending_executable_binary), F_OK)) {
                // neither of those passed
                utstring_free(pending_executable_binary);
                pending_executable_binary = NULL;
            }
        }

        if (bk.is_remote_connected()) {
            debugger_restore_pending_binary_file();
        } else {
            bk.debug("debug file %s has a binary %s nearby, going to upload it after the connect\n",
                symbol_file, utstring_body(pending_executable_binary));
        }
    }
    return  0;
}

void debugger_restore_pending_binary_file()
{
    if (pending_executable_binary) {
        bk.debug("uploading pending binary %s right now...\n",
            utstring_body(pending_executable_binary));

        int address = get_restore_address(NULL);
        if (address == 0) {
            bk.debug("Warning: can not upload binary; restore address is unknown\n");
        } else {
            bk.restore(utstring_body(pending_executable_binary), address, 1);
        }

        utstring_free(pending_executable_binary);
        pending_executable_binary = NULL;
    }
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

static uint8_t confirm(const char* message);

void debugger_request_a_break() {
    if (bk.breakable) {
        debugger_break_requested = 1;
        bk.console("Requesting a break...\n");
        bk.break_(0);
    } else {
        if (confirm("Cannot request a break, would you like to quit instead?"))
        {
            exit(1);
        }
    }
}

int debugger_evaluate(char* line)
{
    int return_to_execution = 0;

    int argc;
    char** argv = parse_words(line, &argc);

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
            bk.console("The following commands could match, which one is ambiguous:\n");
            for (int i = 0; i < ambigious_commands_num; i++) {
                bk.console("    %s\n", ambiguous_commands[i]->cmd);
            }
        }
        free(argv);
    }
    return return_to_execution;
}

void debugger()
{
    static char *last_line = NULL;
    static char buf[2048];
    char prompt[300];
    char *line;

    if ( last_line == NULL ) {
        last_line = strdup("");
    }

    if ( trace ) {
        cmd_registers(0, NULL);
        disassemble2(bk.pc(), buf, sizeof(buf), 0);

        if (interact_with_tty)
            bk.console( "\n%s\n\n",buf);    // In case of active tty, double LF to improve layout in case of 'cont'
        else
            bk.console("%s\n",buf);         // Unchanged in case of non-active tty
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

    int dodebug = process_temp_breakpoints();

    if (dodebug) {
        trace_source = 1;
    }

    if ( bk.breakpoints_check() ) {
        if (profiler_check(bk.pc())) {
            // we've hit a profiler breakpoint
            bk.resume();
            debugger_active = 0;
        } else {
            int         i = 1;
            breakpoint *elem;
            LL_FOREACH(breakpoints, elem) {
                if ( elem->enabled == 0 ) {
                    continue;
                }

                if ( elem->type == BREAK_PC && elem->value == bk.pc() ) {
                    bk.console("Hit breakpoint %d: @%04x (%s)\n",i,bk.pc(),resolve_to_label(bk.pc()));
                    dodebug=1;
                    break;
                } else if ( elem->type == BREAK_CHECK8 && bk.get_memory(elem->lcheck_arg) == elem->lvalue ) {
                    bk.console("Hit breakpoint %d (%s = $%02x): @%04x (%s)\n",i,elem->text, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                    elem->enabled = 0;
                    dodebug=1;
                    break;
                } else if ( elem->type == BREAK_CHECK16 &&
                            bk.get_memory(elem->lcheck_arg) == elem->lvalue  &&
                            bk.get_memory(elem->hcheck_arg) == elem->hvalue  ) {
                    bk.console("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
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
                            bk.console("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                            elem->enabled = 0;
                            dodebug=1;
                            break;
                        }
                    } else if (r->high == NULL) {
                        if (*(r->low(&regs)) == elem->lvalue) {
                            bk.console("Hit breakpoint %d (%s = $%02x): @%04x (%s)\n",i,elem->text, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                            elem->enabled = 0;
                            dodebug=1;
                            break;
                        }
                    } else {
                        if (*(r->low(&regs)) == elem->lvalue && *(r->high(&regs)) == elem->hvalue)
                        {
                            bk.console("Hit breakpoint %d (%s = $%02x%02x): @%04x (%s)\n",i,elem->text, elem->hvalue, elem->lvalue,bk.pc(),resolve_to_label(bk.pc()));
                            elem->enabled = 0;
                            dodebug=1;
                            break;
                        }
                    }
                }
                i++;
            }
        }
    }

    if ((debugger_break_requested == 0) && (debugger_active == 0) && (dodebug == 0))
        return;

    // clear up the debugger_break_requested
    debugger_break_requested = 0;

    if (trace_source) {
        trace_source = 0;
        const char *filename;
        int   lineno;
        if ( debug_find_source_location(bk.pc(), &filename, &lineno) < 0 ) {
            disassemble2(bk.pc(), buf, sizeof(buf), 0);
            bk.console("%s\n",buf);
        } else {
            bk.console("%s:\n", filename);
            srcfile_display(filename, lineno - 1, 2, lineno);
        }
    } else if (trace == 0) { // Prevent two lines with the same information
        disassemble2(bk.pc(), buf, sizeof(buf), 0);
        bk.console("%s\n",buf);
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
        char freeline = 0;

        if ( line == NULL || line[0] == '\0') {
            line = strdup(last_line);
            freeline = 1;
        } else {
            free(last_line);
            last_line = strdup(line);
        }

        if (line[0] != '\0' && line[0] != '/') {
            linenoiseHistoryAdd(line); /* Add to the history. */
            linenoiseHistorySave(HISTORY_FILE); /* Save the history on disk. */
            int return_to_execution = debugger_evaluate(line);
            if ( freeline ) free(line);
            if ( return_to_execution ) {
                /* Out of the linenoise loop */
                break;
            }
        } else {
            /* Empty line is step */
            if ( freeline ) free(line);
            bk.break_(0);
            break;
        }
    }
}



static int cmd_next(int argc, char **argv)
{
    bk.next(1);
    return 1;  /* We should exit the loop */
}


static int cmd_next_source(int argc, char **argv)
{
    const char *filename;
    int   lineno;
    const unsigned short pc = bk.pc();
    if (debug_find_source_location(pc, &filename, &lineno) < 0) {
        bk.console("Warning: cannot obtain current source line.\n");
        return 0;
    }
    add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_NEXT_SOURCE_LINE, filename, lineno);
    bk.next(0);
    return 1;
}

static int cmd_step(int argc, char **argv)
{
    bk.step(1);
    return 1;  /* We should exit the loop */
}

static int cmd_step_source(int argc, char **argv)
{
    const char *filename;
    int   lineno;
    const unsigned short pc = bk.pc();
    if (debug_find_source_location(pc, &filename, &lineno) < 0) {
        bk.console("Warning: cannot obtain current source line.\n");
        return 0;
    }

    add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_STEP_SOURCE_LINE, filename, lineno);
    bk.step(0);
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
            UT_string* function_args;
            utstring_new(function_args);

            int buffer_offset = 0;
            int buffer_length = 255;
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
                    utstring_printf(function_args, ", ");
                }

                struct expression_result_t exp = {0};
                debug_get_symbol_value_expression(s, fp, &exp);

                if (is_expression_result_error(&exp)) {
                    utstring_printf(function_args, "<error>%s", s->symbol_name);
                } else {
                    UT_string* exp_type = expression_result_type_to_string(&exp.type, exp.type.first);
                    UT_string* exp_value = expression_result_value_to_string(&exp);

                    utstring_printf(function_args, "<%s>%s = %s", utstring_body(exp_type),
                        s->symbol_name, utstring_body(exp_value));

                    utstring_free(exp_type);
                    utstring_free(exp_value);
                }

                expression_result_free(&exp);

                first_arg = 0;
                arg = arg->next;
            }

            if (fp->offset == 0xFFFF) {
                bk.console("%sfunction %s+??? (unreliable offset, %s)\n       at %s\n", frame_marker,
                    fn->function_name, utstring_body(function_args), fp->filename);
            } else {
                bk.console("%sfunction %s+%d (%s)\n       at %s:%d\n", frame_marker,
                    fn->function_name, fp->offset, utstring_body(function_args),
                    fp->filename, fp->lineno);
            }

            utstring_free(function_args);
        } else {
            if (fp->offset == 0xFFFF) {
                bk.console("%s%s+??? (unreliable offset) at %s\n", frame_marker, sym->name, fp->filename);
            } else {
                bk.console("%s%s+%d at %s:%d\n", frame_marker, sym->name, fp->offset, fp->filename, fp->lineno);
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
            bk.console("%s%s+%d\n       at %s\n", frame_marker, sym->name, fp->offset, location);
        } else {
            bk.console("%s$%04x\n       at %s\n", frame_marker, fp->address, location);
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
        bk.console("frame %zu\n", current_frame);
        print_frame(frame_at, frame_at, stack);
    } else {
        bk.console("frame unknown.\n");
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

void debug_lookup_history(const char* history, struct expression_result_t* result) {
    zero_expression_result(result);
    struct history_expression_t *he;
    HASH_FIND_STR(history_expressions, history, he);
    if (he != NULL) {
        *result = he->result;
        result->type.first = copy_type_chain(he->result.type.first);
        return;
    }
    sprintf(result->as_error, "Cannot find item <%s> in history", history);
    set_expression_result_error(result);
}

void debug_lookup_symbol(struct lookup_t* lookup, struct expression_result_t* result) {
    zero_expression_result(result);
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
    debug_frame_pointer* fp = debug_stack_frames_at(first_frame_pointer, current_frame);

    if (fp != NULL) {
        debug_sym_function* fn = fp->function;
        if (fn != NULL) {
            debug_sym_function_argument* arg = fn->arguments;
            while (arg) {
                debug_sym_symbol* s = arg->symbol;
                if (strcmp(s->symbol_name, lookup->symbol_name) == 0) {
                    if (!debug_symbol_valid(s, initial_stack, fp)) {
                        arg = arg->next;
                        continue;
                    }
                    debug_get_symbol_value_expression(s, fp, result);
                    debug_stack_frames_free(first_frame_pointer);
                    return;
                }
                arg = arg->next;
            }

            // try static locals
            char sname[128];
            sprintf(sname, "st_%s_%s", fn->function_name, lookup->symbol_name);
            debug_sym_symbol *s = cdb_find_symbol(sname, fp->filename);
            if (s != NULL && s->address_space.address_space == 'E') {
                debug_get_symbol_value_expression(s, fp, result);
                debug_stack_frames_free(first_frame_pointer);
                return;
            }
        }
    }

    // try globals
    debug_sym_symbol* s = cdb_find_symbol(lookup->symbol_name, fp->filename);
    if (s != NULL && s->address_space.address_space == 'E') {
        debug_get_symbol_value_expression(s, fp, result);
        debug_stack_frames_free(first_frame_pointer);
        return;
    }

    // try prefixing it with "_"
    {
        UT_string prefixed;
        utstring_init(&prefixed);
        utstring_printf(&prefixed, "_%s", lookup->symbol_name);

        s = cdb_find_symbol(utstring_body(&prefixed), fp->filename);
        if (s != NULL && s->address_space.address_space == 'E') {
            debug_get_symbol_value_expression(s, fp, result);
            debug_stack_frames_free(first_frame_pointer);

            utstring_done(&prefixed);
            return;
        }

        utstring_done(&prefixed);
    }

    debug_stack_frames_free(first_frame_pointer);

    sprintf(result->as_error, "Cannot resolve symbol: %s", lookup->symbol_name);
    set_expression_result_error(result);
}

static int cmd_print(int argc, char **argv)
{
    if (argc < 2)
    {
        return 0;
    }

    char* call = malloc(255);
    strcpy(call, argv[1]);

    for (int i = 2; i < argc; i++)
    {
        strcat(call, " ");
        strcat(call, argv[i]);
    }

    if (getenv("YYDEBUG") != NULL) {
        extern int yydebug;
        yydebug = 1;
    }

    evaluate_expression_string(call);
    free(call);

    struct expression_result_t* result = get_expression_result();
    if (is_expression_result_error(result))
    {
        bk.console("Error: %s\n", result->as_error);
        return 0;
    }

    UT_string* type = expression_result_type_to_string(&result->type, result->type.first);
    UT_string* value = expression_result_value_to_string(result);

    char result_id[32];
    sprintf(result_id, "$%d", ++last_evaluation_id);
    bk.console("%s = <%s> %s\n", result_id, utstring_body(type), utstring_body(value));

    utstring_free(type);
    utstring_free(value);

    struct history_expression_t* he = calloc(1, sizeof(struct history_expression_t));
    strcpy(he->name, result_id);
    he->result = *get_expression_result();
    HASH_ADD_STR(history_expressions, name, he);

    return 0;
}

static void print_breakpoints() {
    breakpoint *elem;
    LL_FOREACH(breakpoints, elem) {
        if ( elem->type == BREAK_PC) {
            uint16_t offset = 0;
            symbol* sym = symbol_find_lower(elem->value, SYM_ADDRESS, &offset);
            if (sym) {
                bk.console("%d:\tPC = $%04x (%s+%d) %s\n", elem->number, elem->value, sym->name, offset, elem->enabled ? "" : " (disabled)");
            } else {
                bk.console("%d:\tPC = $%04x (%s) %s\n",  elem->number, elem->value, "<unknown>", elem->enabled ? "" : " (disabled)");
            }
        } else if ( elem->type == BREAK_CHECK8 ) {
            bk.console("%d\t%s = $%02x%s\n", elem->number, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
        } else if ( elem->type == BREAK_CHECK16 ) {
            bk.console("%d\t%s = $%04x%s\n", elem->number, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
        }  else if ( elem->type == BREAK_REGISTER ) {
            struct reg* r = &registers[elem->lcheck_arg];
            if (r->high == NULL && r->word == NULL) {
                bk.console("%d\t%s = $%02x%s\n", elem->number, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
            } else {
                bk.console("%d\t%s = $%04x%s\n", elem->number, elem->text, elem->value, elem->enabled ? "" : " (disabled)");
            }
        }
    }
}

static void info_section_locals() {
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
    debug_frame_pointer* fp = debug_stack_frames_at(first_frame_pointer, current_frame);

    debug_sym_function* fn = fp->function;
    if (fn != NULL) {
        debug_sym_function_argument* arg = fn->arguments;
        while (arg) {
            debug_sym_symbol* s = arg->symbol;
            if (debug_symbol_valid(s, initial_stack, fp)) {
                struct expression_result_t exp = {0};
                debug_get_symbol_value_expression(s, fp, &exp);
                if (is_expression_result_error(&exp)) {
                    bk.console("  %s = <error>\n", s->symbol_name);
                } else {
                    UT_string* exp_type = expression_result_type_to_string(&exp.type, exp.type.first);
                    UT_string* exp_value = expression_result_value_to_string(&exp);
                    bk.console("  <%s>%s = %s\n", utstring_body(exp_type), s->symbol_name, utstring_body(exp_value));
                    utstring_free(exp_value);
                    utstring_free(exp_type);
                }
                expression_result_free(&exp);
            } else {
                bk.console("  %s = <invalid>\n", s->symbol_name);
            }
            arg = arg->next;
        }
    }

    debug_stack_frames_free(first_frame_pointer);
}

static void info_section_globals() {
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
    debug_frame_pointer* fp = debug_stack_frames_at(first_frame_pointer, current_frame);

    // file-local symbols
    for (debug_sym_symbol *s = cdb_get_first_local_symbol(fp->filename); s != NULL; s = s->hh.next) {
        if (s->address_space.address_space != 'E') {
            continue;
        }
        if (s->type_record.first == NULL || (s->type_record.first->type_ == TYPE_FUNCTION)) {
            continue;
        }

        struct expression_result_t exp = {0};
        debug_get_symbol_value_expression(s, fp, &exp);

        if (is_expression_result_error(&exp)) {
            continue;
        }

        UT_string* exp_type = expression_result_type_to_string(&exp.type, exp.type.first);
        UT_string* exp_value = expression_result_value_to_string(&exp);
        bk.console("  <%s>%s = %s\n", utstring_body(exp_type), s->symbol_name, utstring_body(exp_value));
        utstring_free(exp_value);
        utstring_free(exp_type);
        expression_result_free(&exp);
    }

    // globals only
    for (debug_sym_symbol *s = cdb_get_first_global_symbol(); s != NULL; s = s->hh.next) {
        if (s->address_space.address_space != 'E') {
            continue;
        }
        if (s->type_record.first == NULL || (s->type_record.first->type_ == TYPE_FUNCTION)) {
            continue;
        }

        struct expression_result_t exp = {0};
        debug_get_symbol_value_expression(s, fp, &exp);

        if (is_expression_result_error(&exp)) {
            continue;
        }

        UT_string* exp_type = expression_result_type_to_string(&exp.type, exp.type.first);
        UT_string* exp_value = expression_result_value_to_string(&exp);
        bk.console("  <%s>%s = %s\n", utstring_body(exp_type), s->symbol_name, utstring_body(exp_value));
        utstring_free(exp_value);
        utstring_free(exp_type);
        expression_result_free(&exp);
    }

    debug_stack_frames_free(first_frame_pointer);
}

static int cmd_info(int argc, char **argv)
{
    int matches_total = 0;
    int matched_section = -1;

    if (argc >= 2) {
        for (int i = 0; cmd_info_sections[i].cb; i++) {
            if (strstr(cmd_info_sections[i].name, argv[1]) == cmd_info_sections[i].name) {
                matches_total++;
                matched_section = i;
            }
        }

        if (matches_total == 1) {
            cmd_info_sections[matched_section].cb();
            return 0;
        }

        if (matches_total > 1) {
            bk.console("Warning: ambiguous information section, please elaborate.\n");
            return 0;
        }
    }

    bk.console("Warning: cannot identify information section. Available sections are:\n");

    for (int i = 0; cmd_info_sections[i].cb; i++) {
        bk.console("  %s - %s\n", cmd_info_sections[i].name, cmd_info_sections[i].help);
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
            bk.console("Warning: no backtrace is available for symbol '%s'.\n", sym->name);
        } else {
            bk.console("Warning: current location is unknown.\n");
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

    if ( *str == '$' ) {
        base = 16;
        str++;
    }
    return strtol(str, end, base);
}

static int cmd_stack(int argc, char **argv)
{
    int stack_size = 8;

    if ( argc == 2 ) {
        char *end;
        stack_size = parse_number(argv[1], &end);
    }

    struct debugger_regs_t regs;
    bk.get_regs(&regs);
    uint16_t stack = regs.sp;

    bk.console("Examining stack (%d values) starting from $%04x:\n", stack_size, stack);

    bk.console("Values: ");
    uint16_t stack_summary = stack;
    for (int i = 0; i < stack_size; i++) {
        uint16_t value_at = (bk.get_memory((uint16_t)stack_summary + 1) << 8) + bk.get_memory((uint16_t)stack_summary);
        bk.console("%04x ", value_at);
        stack_summary += 2;
    }

    bk.console("\nDetail:\n");
    for (int i = 0; i < stack_size; i++) {
        uint16_t value_at = (bk.get_memory((uint16_t)stack + 1) << 8) + bk.get_memory((uint16_t)stack);
        bk.console("  $%04x (offset %d): %04x\n", stack, i * 2, value_at);

        uint16_t offset;
        symbol* sym = symbol_find_lower(value_at, SYM_ADDRESS, &offset);
        if (sym) {
            bk.console("    $%04x %s (+%d)\n", sym->address, sym->name, offset);
        } else {
            bk.console("    ?\n");
        }

        stack += 2;
    }

    return 0;
}


/* Parse an address operand.
 *
 * It may be one of:
 * 1. A number address
 * 2. A symbol
 * 3. A line expression
 */
int parse_address(char *arg, const char** corrected_source)
{
    char temp[1024];
    int  where;
    char *end;

    where = parse_number(arg, &end);
    if ( end == arg ) {
        where = symbol_resolve(arg, NULL);
        if ( where == -1 ) {
            snprintf(temp,sizeof(temp),"_%s",arg);
            where = symbol_resolve(temp, NULL);
            if ( where == -1 ) {
                // And now try to resolve a line expression
                where = debug_resolve_source(arg, corrected_source);
            }
        }
    }
    return where;
}

/* Map an address into a convenient label */
const char *resolve_to_label(int addr)
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
    static char buf[2048];
    int i = 0;
    int disassemble_size = 10;
    int where = -1;
    const unsigned short pc = bk.pc();

    if ( argc >= 2 ) {
        where = parse_address(argv[1], NULL);
    }

    if ( argc >= 3 ) {
        disassemble_size = atoi(argv[2]);
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
                bk.console("Showing disassembly at frame %zu ($%04x), current pc is at $%04x\n",
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

    while ( i < disassemble_size ) {
       where += disassemble2(where, buf, sizeof(buf), 0);
       bk.console("%s\n",buf);
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
        bk.console(
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
        bk.console("pc=%04X, [pc]=%02X,    bc=%04X,  de=%04X,  hl=%04X,  af=%04X, ix=%04X, iy=%04X\n"
               "sp=%04X, [sp]=%04X, bc'=%04X, de'=%04X, hl'=%04X, af'=%04X\n"
               "f: S=%d Z=%d H=%d P/V=%d N=%d C=%d\n",
               pc, bk.get_memory(pc), regs.c | regs.b << 8, regs.e | regs.d << 8, regs.l | regs.h << 8, bk.f() | regs.a << 8, regs.xl | regs.xh << 8, regs.yl | regs.yh << 8,
               sp, (bk.get_memory(sp+1) << 8 | bk.get_memory(sp)), regs.c_ | regs.b_ << 8, regs.e_ | regs.d_ << 8, regs.l_ | regs.h_ << 8, bk.f_() | regs.a_ << 8,
               (bk.f() & 0x80) ? 1 : 0, (bk.f() & 0x40) ? 1 : 0, (bk.f() & 0x10) ? 1 : 0, (bk.f() & 0x04) ? 1 : 0, (bk.f() & 0x02) ? 1 : 0, (bk.f() & 0x01) ? 1 : 0);
    }

    return 0;
}

static void breakpoint_deleted(breakpoint* b) {
    bk.console("Deleted breakpoint %d\n", b->number);
}

static void delete_breakpoint_by_number_and_log(int number){
    breakpoint* b = find_breakpoint(number);
    if (b == NULL)
    {
        bk.console("Warning: unknown breakpoint.\n");
        return;
    }

    delete_breakpoint(b);
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
                bk.console("%d:\t(read) @$%04x (%s) %s\n",i, elem->value,resolve_to_label(elem->value), elem->enabled ? "" : " (disabled)");
            } else if ( elem->type == BREAK_WRITE) {
                bk.console("%d:\t(write) @$%04x (%s) %s\n",i, elem->value,resolve_to_label(elem->value), elem->enabled ? "" : " (disabled)");
            }
            i++;
        }

    } else if ( argc == 3 && (strcmp(argv[1],"read") == 0 || (breakwrite=1,strcmp(argv[1],"write") == 0)) ) {
        breakpoint *elem;
        const char* corrected_source = argv[2];
        int value = parse_address(argv[2], &corrected_source);

        if ( value != -1 ) {
            elem = add_watchpoint(breakwrite ? BREAK_WRITE : BREAK_READ, value);
            bk.console("Adding %s watchpoint at '%s' $%04x (%s)\n",
                breakwrite ? "write" : "read", corrected_source, value,  resolve_to_label(value));
        } else {
            bk.console("Cannot set watchpoint on '%s'\n", corrected_source);
        }
    } else if ( argc == 3 && strcmp(argv[1],"delete") == 0 ) {
        breakpoint *elem = find_watchpoint(atoi(argv[2]));
        if (elem) {
            bk.console("Deleting watchpoint %d \n", atoi(argv[2]));
            delete_watchpoint(elem);
        } else {
            bk.console("Unknown watchpoint\n");
        }
    } else if ( argc == 3 && strcmp(argv[1],"disable") == 0 ) {
        breakpoint *elem = find_watchpoint(atoi(argv[2]));
        if (elem) {
            bk.console("Disabling watchpoint %d\n", atoi(argv[2]));
            elem->enabled = 0;
        } else {
            bk.console("Unknown watchpoint\n");
        }
    } else if ( argc == 3 && strcmp(argv[1],"enable") == 0 ) {
        breakpoint *elem = find_watchpoint(atoi(argv[2]));
        if (elem) {
            bk.console("Enabling watchpoint %d\n",atoi(argv[2]));
            elem->enabled = 1;
        } else {
            bk.console("Unknown watchpoint\n");
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

        temporary_breakpoint_t* tmp = add_temporary_internal_breakpoint(first_frame_pointer->return_address,
            TMP_REASON_FIN, NULL, 0);
        tmp->callee = first_frame_pointer->function;
        tmp->external = 1;
        bk.add_breakpoint(BK_BREAKPOINT_SOFTWARE, first_frame_pointer->return_address, 1);

        debug_stack_frames_free(first_frame_pointer);
        debugger_active = 0;
        trace_source = 1;
        bk.resume();
        return 1;
    } else {
        debug_stack_frames_free(first_frame_pointer);
        bk.console("Warning: return address is unknown, cannot fin.\n");
    }

    return 0;
}

static uint8_t confirm(const char* message) {
    while (1) {
        bk.console("%s (y/n)", message);
        fflush(stdout);
        char c;
        do {
            scanf("%c", &c);
        } while (!isalpha(c));
        if (c == 'y' || c == 'Y') {
            return 1;
        }
        if (c == 'n' || c == 'N') {
            return 0;
        }
    }
    return 0;
}

static int cmd_del_break(int argc, char **argv) {
    if (argc == 1) {
        if (confirm("Are you sure you want delete all breakpoints?")) {
            delete_all_breakpoints();
        }
    }
    if (argc == 2) {
        delete_breakpoint_by_number_and_log(atoi(argv[1]));
    }
    return 0;
}

static int cmd_break(int argc, char **argv)
{
    const unsigned short pc = bk.pc();

    if ( argc == 1 ) {
        /* Just show the breakpoints */
        print_breakpoints();
    } else if ( argc == 2 ) {
        breakpoint *elem;
        const char* corrected_source = argv[1];
        int value = parse_address(argv[1], &corrected_source);

        if ( value != -1 ) {
            elem = add_breakpoint(BREAK_PC, BK_BREAKPOINT_SOFTWARE, 1, value, NULL);
            bk.console("Adding breakpoint at '%s' $%04x (%s)\n", corrected_source, value,  resolve_to_label(value));
        } else {
            bk.console("Cannot break on '%s'\n", corrected_source);
        }
    } else if ( argc == 3 && strcmp(argv[1],"delete") == 0 ) {
        delete_breakpoint_by_number_and_log(atoi(argv[2]));
    } else if ( argc == 3 && strcmp(argv[1],"disable") == 0 ) {
        int num = atoi(argv[2]);
        breakpoint *elem;
        LL_FOREACH(breakpoints, elem) {
            num--;
            if ( num == 0 ) {
                bk.console("Disabling breakpoint %d\n",atoi(argv[2]));
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
                bk.console("Enabling breakpoint %d\n",atoi(argv[2]));
                bk.enable_breakpoint(BK_BREAKPOINT_SOFTWARE, elem->value, 1);
                elem->enabled = 1;
                break;
            }
        }
    } else if ( argc == 5 && strcmp(argv[1], "memory8") == 0 ) {
        // break memory8 <addr> = <value>
        char  *end;
        int value = parse_address(argv[2], NULL);

        if ( value != -1 ) {
            breakpoint *elem = add_breakpoint(BREAK_CHECK8, BK_BREAKPOINT_WATCHPOINT, 1, value, strdup(argv[2]));
            elem->lvalue = parse_number(argv[4], &end);
            bk.console("Adding breakpoint for %s = $%02x\n", elem->text, elem->lvalue);
        }
    } else if ( argc == 5 && strcmp(argv[1], "memory16") == 0 ) {
        char *end;
        int addr = parse_address(argv[2], NULL);

        if ( addr != -1 ) {
            int value = parse_number(argv[4],&end);
            breakpoint *elem = add_breakpoint(BREAK_CHECK16, BK_BREAKPOINT_WATCHPOINT, 2, 0, strdup(argv[2]));
            elem->lcheck_arg = addr;
            elem->lvalue = value % 256;
            elem->hcheck_arg = addr+1;
            elem->hvalue = (value % 65536 ) /    256;
            bk.console("Adding breakpoint for %s = $%02x%02x\n", elem->text, elem->hvalue, elem->lvalue);
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
            breakpoint *elem = add_breakpoint(BREAK_REGISTER, BK_BREAKPOINT_REGISTER, 1, search_idx, strdup(argv[2]));
            elem->lcheck_arg = search_idx;
            elem->lvalue = (value % 256);
            elem->hvalue = (value % 65536) / 256;
            if ( elem->type == BREAK_CHECK8 ) {
                bk.console("Adding breakpoint for %s = $%02x\n", elem->text, elem->lvalue);
            } else {
                bk.console("Adding breakpoint for %s = $%02x%02x\n", elem->text, elem->hvalue, elem->lvalue);
            }
        } else {
            bk.console("No such register %s\n",argv[2]);
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
        addr = parse_address(argv[1], NULL);
    }

    if ( addr == -1 ) addr = pc;


    abuf[16] = 0;                                       // Zero terminated string
    addr %= 0x10000;                                    // First address with overflow correction

    for ( i = 0; i < 128; i++ ) {
        uint8_t b = bk.get_memory(addr);
        abuf[i % 16] = isprint(b) ? ((char) b) : '.';   // Prepare end of dump in ASCII format

        if ( i % 16 == 0 ) {                            // Handle line prefix
            if (interact_with_tty) {
                bk.console(FNT_CLR"%04X"FNT_RST":   ", addr);
            } else {
                bk.console("%04X:   ", addr);               // Non-color output for non-active tty
            }
        }

        bk.console("%02X ", b);                             // Hex dump of actual byte

        if (i % 16 == 15) bk.console("   %s\n", abuf);      // Suffix line with ASCII dump

        addr = (addr + 1) % 0x10000;                    // Next address with overflow correction
    }
    return 0;
}

static int cmd_typeof(int argc, char **argv)
{
    if (argc < 2)
    {
        bk.console("Warning: variable is not specified\n");
        return 0;
    }

    evaluate_expression_string(argv[1]);

    struct expression_result_t* result = get_expression_result();
    if (is_expression_result_error(result))
    {
        bk.console("Error: %s\n", result->as_error);
        return 0;
    }

    UT_string* type = expression_result_type_to_string(&result->type, result->type.first);
    bk.console("type = %s\n", utstring_body(type));
    utstring_free(type);

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
        bk.console("Incorrect number of arguments\n");
    }

    return 0;
}



static int cmd_out(int argc, char **argv)
{
    if ( argc == 3 ) {
        char *end;
        int port = parse_number(argv[1], &end);
        int value = parse_number(argv[2], &end);

        bk.console("Writing IO: out(%d),%d\n",port,value);
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
        bk.console("Tracing is %s\n", trace ? "on" : "off");
    }
    return 0;
}

static int cmd_profiler(int argc, char **argv)
{
    if (profiler_enabled) {
        profiler_stop();
        return 0;
    }

    const char* function_only = NULL;
    int limit = 0;

    for (int i = 1; i < argc; i++) {
        const char* arg = argv[i];
        if (strcmp(arg, "-i") == 0) {
            limit = atoi(argv[++i]);
        } else if (strcmp(arg, "-f") == 0) {
            function_only = argv[++i];
        }
    }

    profiler_start(function_only, limit);

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
        bk.console("Hotspots are %s\n", hotspot ? "on" : "off");
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
                    bk.console(FNT_CLR"%-10s\t%-20s"FNT_RST"\t%s\n", cmd->cmd, cmd->options, cmd->help);
                else // Original output for non-active tty
                    bk.console("%-10s\t%-20s\t%s\n", cmd->cmd, cmd->options, cmd->help);
            }
            cmd++;
        }
    } else if ( strcmp(argv[1],"break") == 0 ) {
        bk.console("break [address/label]             - Break at address\n");
        bk.console("break delete [index]              - Delete breakpoint\n");
        bk.console("break disable [index]             - Disable breakpoint\n");
        bk.console("break enable [index]              - Enabled breakpoint\n");
        bk.console("break memory8 [address] [value]   - Break when [address/label] is value\n");
        bk.console("break memory16 [address] [value]  - Break when [address/label] is value\n");
        bk.console("break register [register] [value] - Break when [register] is value\n");
    } else if ( strcmp(argv[1],"watch") == 0 ) {
        bk.console("watch delete [index]              - Delete breakpoint\n");
        bk.console("watch disable [index]             - Disable breakpoint\n");
        bk.console("watch enable [index]              - Enabled breakpoint\n");
        bk.console("watch read [address]              - Break when [address] is read\n");
        bk.console("watch write [address]             - Break when [address] is written\n");
    }
     return 0;
}

static int cmd_quit(int argc, char **argv)
{
    if (bk.confirm_detach_w_breakpoints) {
        breakpoint* elem;
        int count;
        LL_COUNT(breakpoints, elem, count);
        if (count > 0) {
            if (confirm("You have breakpoint(s) set. Would you like to remove them before you detach?")) {
                delete_all_breakpoints();
            }
        }
    }
    bk.detach();
    exit(0);
}

int get_restore_address(char* address_text)
{
    if (address_text) {
        return parse_address(address_text, NULL);
    } else {
        int address = symbol_resolve("__head", NULL);
        if (address == -1) {
            bk.debug("Warning: could not resolve starting address and no address is provided.\n");
            return 0;
        }
        return address;
    }
}

static int cmd_restore(int argc, char **argv)
{
    int address = get_restore_address(argc == 3 ? argv[2] : NULL);
    if (address == 0) {
        return 0;
    }

    if (bk.restore(argv[1], address, 0)) {
        return 0;
    }

    return 1;
}

static int cmd_restore_pc(int argc, char **argv)
{
    int address = get_restore_address(argc == 3 ? argv[2] : NULL);
    if (address == 0) {
        return 0;
    }

    if (bk.restore(argv[1], address, 0))
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
        int a2 = parse_address(argv[1], NULL);

        if ( a2 != -1 ) {
            addr = a2;
        }
    }

    if (offset == 0xFFFF) {
        bk.console("Warning: offset is unreliable, call could have happened from anywhere of this function.\n");
    }

    if ( debug_find_source_location(addr, &filename, &lineno) < 0 ) {
        bk.console("No mapping found for $%04x\n", addr);
        return 0;
    }
    srcfile_display(filename, lineno - 5, 10, lineno);

    return 0;
}


static void print_hotspots(void)
{
    static char buf[2048];
    int i;
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

void stdout_log(const char *fmt, ...)
{
    va_list args;
    va_list args2;
    int len;

    /* Initialize a variable argument list */
    va_start(args, fmt);
    va_copy(args2, args);

    /* Get length of format including arguments */
    len = vsnprintf(NULL, 0, fmt, args2);

    /* End using variable argument list */
    va_end(args2);

    if (len < 0) {
        /* vsnprintf failed */
        return;
    } else {
        /* Declare a character buffer for the formatted string */
        UT_string* formatted;
        utstring_new(formatted);

        /* Initialize a variable argument list */
        va_start(args, fmt);

        /* Write the formatted output */
        utstring_printf_va(formatted, fmt, args);

        /* End using variable argument list */
        va_end(args);

        /* Call the wrapped function using the formatted output and return */
        printf("%s", utstring_body(formatted));
        utstring_free(formatted);
    }
}
