
#include "debugger_mi2.h"
#include "backend.h"
#include "breakpoints.h"
#include "syms.h"
#include "debug.h"
#include "debugger.h"
#include "debugger_gdb.h"
#include "disassembler.h"
#include "exp_engine.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <ctype.h>
#include <stdarg.h>
#include <utstring.h>

#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

typedef struct {
    char name[128];
    int frame;
    char expression[128];
    UT_hash_handle hh;
} mi2_var;

static mi2_var* mi2_vars = NULL;
static uint8_t report_connected = 0;
static uint8_t report_execution_stopped = 0;
static char connect_flow[64] = "";

typedef struct {
    char   *cmd;
    void   (*func)(const char* flow, int argc, char **argv);
} command;

static void cmd_exit(const char* flow, int argc, char **argv);
static void cmd_do_nothing(const char* flow, int argc, char **argv);
static void cmd_target_select(const char* flow, int argc, char **argv);
static void cmd_target_detach(const char* flow, int argc, char **argv);
static void cmd_show(const char* flow, int argc, char **argv);
static void cmd_info(const char* flow, int argc, char **argv);
static void cmd_maintenance(const char* flow, int argc, char **argv);
static void cmd_continue(const char* flow, int argc, char **argv);
static void cmd_file_exec_and_symbols(const char* flow, int argc, char **argv);
static void cmd_break(const char* flow, int argc, char **argv);
static void cmd_next(const char* flow, int argc, char **argv);
static void cmd_next_instruction(const char* flow, int argc, char **argv);
static void cmd_step(const char* flow, int argc, char **argv);
static void cmd_fin(const char* flow, int argc, char **argv);
static void cmd_break_insert(const char* flow, int argc, char **argv);
static void cmd_break_delete(const char* flow, int argc, char **argv);
static void cmd_thread_info(const char* flow, int argc, char **argv);
static void cmd_data_disassemble(const char* flow, int argc, char **argv);
static void cmd_plain_disassemble(const char* flow, int argc, char **argv);
static void cmd_stack_info_depth(const char* flow, int argc, char **argv);
static void cmd_stack_list_frames(const char* flow, int argc, char **argv);
static void cmd_stack_list_variables(const char* flow, int argc, char **argv);
static void cmd_interpreter_exec(const char* flow, int argc, char **argv);
static void cmd_evaluate_expression(const char* flow, int argc, char **argv);
static void cmd_var_create(const char* flow, int argc, char **argv);
static void cmd_var_delete(const char* flow, int argc, char **argv);
static void cmd_var_evaluate_expression(const char* flow, int argc, char **argv);
static void cmd_var_list_children(const char* flow, int argc, char **argv);
static void cmd_list_features(const char* flow, int argc, char **argv);
static void cmd_environment_directory(const char* flow, int argc, char **argv);

static command mi2_commands[] = {
    {"-gdb-exit",                   cmd_exit},
    {"q",                           cmd_exit},
    {"-gdb-set",                    cmd_do_nothing},
    {"-gdb-show",                   cmd_show},
    {"-enable-pretty-printing",     cmd_do_nothing},
    {"info",                        cmd_info},
    {"maintenance",                 cmd_maintenance},
    {"-exec-continue",              cmd_continue},
    {"-exec-interrupt",             cmd_break},
    {"-exec-next",                  cmd_next},
    {"-exec-step",                  cmd_step},
    {"-exec-next-instruction",      cmd_next_instruction},
    {"-exec-finish",                cmd_fin},
    {"-target-select",              cmd_target_select},
    {"-target-detach",              cmd_target_detach},
    {"-file-exec-and-symbols",      cmd_file_exec_and_symbols},
    {"-break-insert",               cmd_break_insert},
    {"-break-delete",               cmd_break_delete},
    {"-thread-info",                cmd_thread_info},
    {"-data-disassemble",           cmd_data_disassemble},
    {"disassemble",                 cmd_plain_disassemble},
    {"-stack-list-frames",          cmd_stack_list_frames},
    {"-stack-list-variables",       cmd_stack_list_variables},
    {"-stack-info-depth",           cmd_stack_info_depth},
    {"-interpreter-exec",           cmd_interpreter_exec},
    {"-data-evaluate-expression",   cmd_evaluate_expression},
    {"-var-create",                 cmd_var_create},
    {"-var-delete",                 cmd_var_delete},
    {"-var-evaluate-expression",    cmd_var_evaluate_expression},
    {"-var-list-children",          cmd_var_list_children},
    {"-list-features",              cmd_list_features},
    {"-environment-directory",      cmd_environment_directory},
    { NULL, NULL }
};

static char* escape(char* input) {
	int len = strlen(input);
	int count = 0;
	char* ptr = input;
	while ((ptr = strchr(ptr, '\\')) != NULL) {
		ptr++;
		count++;
	}

	char* res = malloc(len + count * 2);
	char* last = NULL;
	*res = '\0';
	count = 0;
	ptr = input;
	while ((ptr = strchr(ptr, '\\')) != NULL) {
		strncat(res, &input[strlen(res) - count], ptr - input - strlen(res) + count);
		strncat(res, "\\\\", 2);
		count++;
		ptr++;
		last = ptr;
	}

	if (last != NULL) {
		strcat(res, last);
	}

	return res;
}

static void report_continue() {
    debugger_active = 0;
    mi2_printf_async("running,thread-id=\"all\"")
}

static void cmd_exit(const char* flow, int argc, char **argv) {
    if (bk.is_remote_connected()) {
        delete_all_breakpoints();
    }

    mi2_printf_response(flow, "exit");
    exit(0);
}

static void cmd_list_features(const char* flow, int argc, char **argv) {
    // gdb supports:
    // "pending-breakpoints","thread-info","data-read-memory-bytes","breakpoint-notifications",
    // "ada-task-info","language-option","info-gdb-mi-command","undefined-command-error-code",
    // "exec-run-start-option","data-disassemble-a-option","python"

    mi2_printf_response(flow, "done,features=[\"pending-breakpoints\",\"thread-info\","
                              "\"data-read-memory-bytes\",\"breakpoint-notifications\","
                              "\"info-gdb-mi-command\",\"undefined-command-error-code\","
                              "\"exec-run-start-option\",\"data-disassemble-a-option\"]");
}

static void cmd_environment_directory(const char* flow, int argc, char **argv) {
    // we do that by default
    mi2_printf_response(flow, "done");
}

static void cmd_file_exec_and_symbols(const char* flow, int argc, char **argv) {
    if (argc < 2) {
        mi2_printf_error(flow, "No file specified");
        return;
    }

    char* symbol_file = argv[1];
    if (debugger_read_symbol_file(symbol_file)) {
        mi2_printf_error(flow, "File %s upload failed", symbol_file);
    }

    mi2_printf_response(flow, "done");
}

static void cmd_info(const char* flow, int argc, char **argv) {
    if (argc < 2) {
        mi2_printf_error(flow, "please specify section");
        return;
    }

    const char* section = argv[1];
    if (strcmp(section, "pretty-printer") == 0) {
        bk.debug("pretty-printing is not supported\n");
    } else {
        bk.debug("unknown info section: %s\n", section);
    }

    mi2_printf_response(flow, "done");
}

static void cmd_maintenance(const char* flow, int argc, char **argv) {
    if (argc < 3) {
        mi2_printf_error(flow, "please specify section");
        return;
    }

    const char* section = argv[2];
    if (strcmp(section, "sections") == 0) {
        bk.console("Exec file:");
        bk.console("    `program', file type z80.");
        bk.console(" [0]      0x000000000->0x00000FFFF at 0x00000000: .text ALLOC LOAD CODE HAS_CONTENTS");
    } else {
        bk.debug("unknown info section: %s\n", section);
    }

    mi2_printf_response(flow, "done");
}

static void cmd_thread_info(const char* flow, int argc, char **argv) {
    if (debugger_active == 0) {
        mi2_printf_error(flow, "A program is running.");
        return;
    }

    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    debug_frame_pointer* fp = debug_stack_frames_construct(regs.pc, regs.sp, &regs, 1);

    if (fp) {
        if (fp->symbol && fp->filename && fp->function) {
			char* escaped_filename = escape(fp->filename);
            mi2_printf_response(flow, 
                "done,threads=[{id=\"1\",target-id=\"Thread\","
                "frame={level=\"0\",addr=\"0x%08x\",func=\"%s\","
                "args=[],file=\"%s\","
                "fullname=\"%s\",line=\"%d\"},"
                "state=\"stopped\"}],current-thread-id=\"1\"",
                regs.pc, fp->function->name, escaped_filename, escaped_filename, fp->lineno);
			free(escaped_filename);
            debug_stack_frames_free(fp);
            return;
        }

        debug_stack_frames_free(fp);
    }

    uint16_t offset = 0;
    symbol* s = symbol_find_lower(regs.pc, SYM_ADDRESS, &offset);

    const char* filename;
    int lineno;
    if (s == NULL || debug_find_source_location(regs.pc, &filename, &lineno)) {
        mi2_printf_response(flow, 
            "done,threads=[{id=\"1\",target-id=\"Thread\","
            "frame={level=\"0\",addr=\"0x%08x\","
            "args=[]},"
            "state=\"stopped\"}],current-thread-id=\"1\"",
            regs.pc);
    } else {
		char* escaped_filename = escape(filename);
        mi2_printf_response(flow, 
            "done,threads=[{id=\"1\",target-id=\"Thread\","
            "frame={level=\"0\",addr=\"0x%08x\",func=\"%s\","
            "args=[],file=\"%s\","
            "fullname=\"%s\",line=\"%d\"},"
            "state=\"stopped\"}],current-thread-id=\"1\"",
            regs.pc, s->name, escaped_filename, escaped_filename, lineno);
		free(escaped_filename);
    }
}

static void cmd_stack_list_variables(const char* flow, int argc, char **argv) {
    if (debugger_active == 0) {
        mi2_printf_error(flow, "A program is running.");
        return;
    }

    uint8_t no_values = 0;

    for (int i = 1; i < argc; i++) {
        const char* arg = argv[i];
        if (strcmp(arg, "--frame") == 0) {
            current_frame = atoi(argv[++i]);
        } else if (strcmp(arg, "--no-values") == 0) {
            no_values = 1;
        }
    }

    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(at, stack, &regs, 0);
    debug_frame_pointer* fp = debug_stack_frames_at(first_frame_pointer, current_frame);

    UT_string* response;
    utstring_new(response);

    uint8_t first = 1;

    debug_sym_function* fn = fp->function;
    if (fn != NULL) {
        char function_args[255] = {0};
        debug_sym_function_argument* arg = fn->arguments;
        while (arg) {
            if (!first) {
                utstring_printf(response, ",");
            }
            debug_sym_symbol* s = arg->symbol;
            if (no_values) {
                utstring_printf(response, "{name=\"%s\"}", s->symbol_name);
            } else {
                if (debug_symbol_valid(s, initial_stack, fp)) {
                    struct expression_result_t exp = {0};
                    debug_get_symbol_value_expression(s, fp, &exp);
                    if (is_expression_result_error(&exp)) {
                        utstring_printf(response, "{name=\"%s\",value=\"<error>\"}", s->symbol_name);
                    } else {
                        UT_string* exp_type = expression_result_type_to_string(&exp.type, exp.type.first);
                        UT_string* exp_value = expression_result_value_to_string(&exp);

                        utstring_printf(response, "{name=\"%s\",type=\"%s\",value=\"%s\"}", s->symbol_name,
                            utstring_body(exp_type), utstring_body(exp_value));

                        utstring_free(exp_type);
                        utstring_free(exp_value);
                    }
                    expression_result_free(&exp);
                } else {
                    utstring_printf(response, "{name=\"%s\",value=\"<invalid>\"}", s->symbol_name);
                }
            }
            first = 0;
            arg = arg->next;
        }
    }

    debug_stack_frames_free(first_frame_pointer);
    mi2_printf_response(flow, "done,variables=[%s]", utstring_body(response));
    utstring_free(response);
}

static void cmd_interpreter_exec(const char* flow, int argc_, char **argv_) {
    char* interpreter = NULL;
    char* exec = NULL;

    for (int i = 1; i < argc_; i++) {
        char* arg = argv_[i];
        if (strcmp(arg, "--frame") == 0) {
            current_frame = atoi(argv_[++i]);
        } else if (strcmp(arg, "--thread") == 0) {
            // ignore next option
            i++;
        } else {
            if (interpreter == NULL) {
                interpreter = arg;
            } else if (exec == NULL) {
                exec = arg;
            }
        }
    }

    if (interpreter == NULL || exec == NULL) {
        mi2_printf_error(flow, "Interpreter or exec are not specified.");
        return;
    }

    if (strcmp(interpreter, "console") == 0) {
        debugger_evaluate(exec);
        mi2_printf_response(flow, "done");
    } else if (strcmp(interpreter, "mi2") == 0) {
        int argc;
        char **argv = parse_words(exec, &argc);

        if ( argc > 0 ) {
            const char* command_name = argv[0];
            command *cmd = &mi2_commands[0];
            uint8_t command_found = 0;

            while ( cmd->cmd ) {
                if ( strcmp(command_name, cmd->cmd) == 0 ) {
                    command_found = 1;
                    cmd->func("", argc, argv);
                    break;
                }
                cmd++;
            }

            free(argv);

            if (command_found == 0) {
                mi2_printf_error(flow, "Cannot evaluate command: %s", exec);
            } else {
                mi2_printf_response(flow, "done");
            }
        }
    } else {
        mi2_printf_error(flow, "Unsupported interpreter");
    }

}

static void cmd_var_create(const char* flow, int argc, char **argv)
{
    int frame = 0;
    char* name = NULL;
    char* kind = NULL;
    char* expr = NULL;

    for (int i = 1; i < argc; i++) {
        char* arg = argv[i];
        if (strcmp(arg, "--frame") == 0) {
            frame = atoi(argv[++i]);
        } else if (strcmp(arg, "--thread") == 0) {
            // ignore next option
            i++;
        }
        if (name == NULL) {
            name = arg;
        } else if (kind == NULL) {
            kind = arg;
        } else if (expr == NULL) {
            expr = arg;
        }
    }

    if (expr == NULL) {
        mi2_printf_error(flow, "expression is not specified");
        return;
    }

    mi2_var* var = calloc(1, sizeof(mi2_var));

    strcpy(var->name, name);
    var->frame = frame;
    strcpy(var->expression, expr);

    current_frame = frame;
    evaluate_expression_string(expr);

    struct expression_result_t* result = get_expression_result();
    if (is_expression_result_error(result))
    {
        mi2_printf_response(flow, "done,name=\"%s\",numchild=\"0\",thread-id=\"1\"", name);
        return;
    }

    UT_string* value = expression_result_value_to_string(result);
    UT_string* type = expression_result_type_to_string(&result->type, result->type.first);

    int num_members = expression_count_members(result);

    HASH_ADD_STR(mi2_vars, name, var);
    mi2_printf_response(flow, "done,name=\"%s\",numchild=\"%d\",type=\"%s\",value=\"%s\",thread-id=\"1\"",
        name, num_members, utstring_body(type), utstring_body(value));

    utstring_free(value);
    utstring_free(type);
}

static void cmd_var_delete(const char* flow, int argc, char **argv)
{
    if (argc < 2) {
        mi2_printf_error(flow, "Not enough arguments");
        return;
    }

    mi2_var* var = NULL;
    HASH_FIND_STR(mi2_vars, argv[1], var);

    if (var == NULL) {
        mi2_printf_error(flow, "Unknown variable");
        return;
    }

    HASH_DEL(mi2_vars, var);
    free(var);
    mi2_printf_response(flow, "done");
}

static void cmd_var_evaluate_expression(const char* flow, int argc, char **argv)
{
    if (argc < 2) {
        mi2_printf_error(flow, "Not enough arguments");
        return;
    }

    mi2_var* var = NULL;
    HASH_FIND_STR(mi2_vars, argv[1], var);

    if (var == NULL) {
        mi2_printf_error(flow, "Unknown variable");
        return;
    }

    current_frame = var->frame;
    evaluate_expression_string(var->expression);

    struct expression_result_t* result = get_expression_result();
    if (is_expression_result_error(result))
    {
        mi2_printf_response(flow, "done,value=\"%s\"", result->as_error);
        return;
    }

    UT_string* value = expression_result_value_to_string(result);
    mi2_printf_response(flow, "done,value=\"%s\"", utstring_body(value));
    utstring_free(value);
}

static UT_string* resolve_expression_result_to_child(
    const char* member, struct expression_result_t* result, int all_values)
{
    UT_string* buffer;
    utstring_new(buffer);

    if (is_expression_result_error(result)) {
        utstring_printf(buffer,
            "child={exp=\"%s\",type=\"<error>\",value=\"%s\"}", member, result->as_error);
    } else {
        UT_string* type = expression_result_type_to_string(&result->type, result->type.first);

        if (all_values) {
            UT_string* value = expression_result_value_to_string(result);
            utstring_printf(buffer,
                "child={exp=\"%s\",value=\"%s\",type=\"%s\"}", member, utstring_body(value), utstring_body(type));
            utstring_free(value);
        } else {
            utstring_printf(buffer,
                "child={exp=\"%s\",type=\"%s\"}", member, utstring_body(type));
        }

        utstring_free(type);
    }

    return buffer;
}

static void cmd_var_list_children(const char* flow, int argc, char **argv)
{
    int all_values = 0;
    char* name = NULL;

    for (int i = 1; i < argc; i++) {
        char* arg = argv[i];
        if (strcmp(arg, "--all-values") == 0) {
            all_values = 1;
        } else {
            if (name == NULL) {
                name = arg;
            }
        }
    }

    if (name == NULL) {
        mi2_printf_error(flow, "variable name is not specified");
        return;
    }

    mi2_var* var = NULL;
    HASH_FIND_STR(mi2_vars, name, var);

    if (var == NULL) {
        mi2_printf_error(flow, "Unknown variable %s", name);
        return;
    }

    current_frame = var->frame;
    evaluate_expression_string(var->expression);

    struct expression_result_t* result = get_expression_result();

    if (is_expression_result_error(result))
    {
        mi2_printf_error(flow, "%s", result->as_error);
        return;
    }

    char* members[64] = {0};
    int num_child = 0;

    struct expression_result_t* struct_ = NULL;
    struct expression_result_t* dereferenced = NULL;

    switch (result->type.first->type_)
    {
        case TYPE_CODE_POINTER:
        case TYPE_GENERIC_POINTER:
        {
            dereferenced = calloc(1, sizeof(struct expression_result_t));
            expression_dereference_pointer(result, dereferenced);
            struct_ = dereferenced;
            break;
        }
        case TYPE_STRUCTURE:
        {
            struct_ = result;
            break;
        }
        default:
        {
            mi2_printf_error(flow, "Do not know how to process this");
            break;
        }
    }

    expression_get_struct_members(struct_, &num_child, (char**)&members);

    UT_string* child_buffer;
    utstring_new(child_buffer);

    for (int i = 0; i < num_child; i++) {
        if (i) {
            utstring_printf(child_buffer, ",");
        }

        char* member = members[i];

        struct expression_result_t member_result = {0};
        expression_resolve_struct_member(struct_, member, &member_result);

        UT_string* child_resolved =
            resolve_expression_result_to_child(member, &member_result, all_values);
        utstring_printf(child_buffer, "%s", utstring_body(child_resolved));
        utstring_free(child_resolved);

        expression_result_free(&member_result);
    }

    mi2_printf_response(flow, "done,children=[%s]", utstring_body(child_buffer));
    utstring_free(child_buffer);

    if (dereferenced)
    {
        expression_result_free(dereferenced);
    }
}

static void cmd_evaluate_expression(const char* flow, int argc, char **argv) {
    UT_string* expression;
    utstring_new(expression);

    current_frame = 0;

    for (int i = 1; i < argc; i++) {
        char* arg = argv[i];
        if (strcmp(arg, "--frame") == 0) {
            current_frame = atoi(argv[++i]);
        } else if (strcmp(arg, "--thread") == 0) {
            // ignore next option
            i++;
        } else {
            if (utstring_len(expression) == 0) {
                utstring_printf(expression, "%s", arg);
            } else {
                utstring_printf(expression, " %s", arg);
            }
        }
    }

    if (utstring_len(expression) == 0) {
        mi2_printf_error(flow, "expression is not specified");
        utstring_free(expression);
        return;
    }

    if (bk.is_verbose()) {
        bk.debug("evaluating expression %s\n", utstring_body(expression));
    }
    evaluate_expression_string(utstring_body(expression));

    struct expression_result_t* result = get_expression_result();
    if (is_expression_result_error(result))
    {
        mi2_printf_response(flow, "done,value=\"<%s>\"", result->as_error);
        utstring_free(expression);
        return;
    }

    UT_string* evaluated_value = expression_result_value_to_string(result);
    mi2_printf_response(flow, "done,value=\"%s\"", utstring_body(evaluated_value));
    utstring_free(evaluated_value);
    utstring_free(expression);
}

static void sprintf_frame0(UT_string* ptr) {
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    debug_frame_pointer* fp = debug_stack_frames_construct(regs.pc, regs.sp, &regs, 1);

    if (fp) {
        if (fp->symbol && fp->filename && fp->function) {
			char* escaped_filename = escape(fp->filename);
            utstring_printf(ptr,
                "level=\"0\",addr=\"0x%08x\",func=\"%s\","
                "args=[],file=\"%s\","
                "fullname=\"%s\",line=\"%d\"",
                regs.pc, fp->function->name, escaped_filename, escaped_filename, fp->lineno);
			free(escaped_filename);
            goto done;
        }
    } else {
        uint16_t offset;
        symbol* sym = symbol_find_lower(regs.pc, SYM_ADDRESS, &offset);
        if (sym != NULL) {
            const char *filename;
            int lineno;
			char* escaped_filename = escape(sym->file);
            if (debug_find_source_location(regs.pc, &filename, &lineno)) {
				char* escaped_fullname = escape(filename);
                utstring_printf(ptr, "level=\"0\",addr=\"0x%08x\",func=\"%s\","
                                     "file=\"%s\","
                                     "fullname=\"%s\",line=\"%d\","
                                     "arch=\"z80\"", regs.pc, sym->name, escaped_filename, escaped_fullname, lineno);
				free(escaped_fullname);
            } else {
                utstring_printf(ptr, "level=\"0\",addr=\"0x%08x\",func=\"%s\","
                                     "file=\"%s\","
                                     "fullname=\"%s\","
                                     "arch=\"z80\"", regs.pc, sym->name, escaped_filename, escaped_filename);
            }
			free(escaped_filename);
        } else {
            utstring_printf(ptr, "level=\"0\",addr=\"0x%08x\"", regs.pc);
        }
    }

done:
    debug_stack_frames_free(fp);
}

static void cmd_stack_list_frames(const char* flow, int argc, char **argv) {
    if (debugger_active == 0) {
        mi2_printf_error(flow, "A program is running.");
        return;
    }

    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    UT_string* dump_buffer;
    utstring_new(dump_buffer);

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(regs.pc, regs.sp, &regs, 0);
    if (first_frame_pointer == NULL) {
        uint16_t offset;
        symbol* sym = symbol_find_lower(regs.pc, SYM_ADDRESS, &offset);
        if (sym != NULL) {

            const char *filename;
            int lineno;
			char* escaped_filename = escape(sym->file);
            if (debug_find_source_location(regs.pc, &filename, &lineno)) {
				char* escaped_fullname = escape(filename);
                utstring_printf(dump_buffer,
                    "frame={level=\"0\",addr=\"0x%08x\",func=\"%s\","
                    "file=\"%s\","
                    "fullname=\"%s\",line=\"%d\","
                    "arch=\"z80\"}", regs.pc, sym->name, escaped_filename, escaped_fullname, lineno);
				free(escaped_fullname);
            } else {
                utstring_printf(dump_buffer,
                    "frame={level=\"0\",addr=\"0x%08x\",func=\"%s\","
                    "file=\"%s\","
                    "fullname=\"%s\","
                    "arch=\"z80\"}", regs.pc, sym->name, escaped_filename, escaped_filename);
            }
			free(escaped_filename);
        } else {
            utstring_printf(dump_buffer,
                "frame={level=\"0\",addr=\"0x%08x\"}", regs.pc);
        }
    } else {
        debug_frame_pointer* fp = first_frame_pointer;
        int level = 0;

        while (fp) {
            if (level != 0) {
                utstring_printf(dump_buffer, ",");
            }

            if (fp->symbol && fp->filename && fp->function) {
				char* escaped_filename = escape(fp->filename);
                utstring_printf(dump_buffer,
                    "frame={level=\"%d\",addr=\"0x%08x\",func=\"%s\","
                    "file=\"%s\","
                    "fullname=\"%s\",line=\"%d\","
                    "arch=\"z80\"}", level, fp->address, fp->function->name,
                    escaped_filename, escaped_filename, fp->lineno);
				free(escaped_filename);
            } else {
                utstring_printf(dump_buffer,
                    "frame={level=\"%d\",addr=\"0x%08x\"}",
                    level, fp->address);
            }

            fp = fp->next;
            level++;
        }

        debug_stack_frames_free(first_frame_pointer);
    }

    mi2_printf_response(flow, "done,stack=[%s]", utstring_body(dump_buffer));
    utstring_free(dump_buffer);
}

static void cmd_stack_info_depth(const char* flow, int argc, char **argv) {
    if (debugger_active == 0) {
        mi2_printf_error(flow, "A program is running.");
        return;
    }

    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint16_t stack = regs.sp;
    uint16_t initial_stack = stack;
    uint16_t at = bk.pc();

    debug_frame_pointer* first_frame_pointer = debug_stack_frames_construct(regs.pc, regs.sp, &regs, 0);
    if (first_frame_pointer == NULL) {
        mi2_printf_response(flow, "done,depth=\"0\"");
        return;
    }

    int depth = 0;

    debug_frame_pointer* fp = first_frame_pointer;
    while (fp) {
        depth++;
        fp = fp->next;
    }

    mi2_printf_response(flow, "done,depth=\"%d\"", depth);
    debug_stack_frames_free(first_frame_pointer);
}

static void cmd_data_disassemble(const char* flow, int argc, char **argv) {
    if (debugger_active == 0) {
        mi2_printf_error(flow, "A program is running.");
        return;
    }

    const char* from = NULL;
    const char* to = NULL;
    const char* mode = NULL;

    for (int i = 0; i < argc; i++) {
        const char* arg = argv[i];
        if (strcmp(arg, "-s") == 0) {
            from = argv[++i];
        } else if (strcmp(arg, "-e") == 0) {
            to = argv[++i];
        } else if (strcmp(arg, "--") == 0) {
            mode = argv[++i];
        }
    }

    if (from == NULL || to == NULL) {
        mi2_printf_error(flow, "Range is not properly specified");
        return;
    }

    int mode_d;

    if (mode != NULL) {
        mode_d = atoi(mode);
        if (mode_d != 0 && mode_d != 2) {
            mi2_printf_error(flow, "Mode is not properly specified");
            return;
        }
    } else {
        mode_d = 2;
    }

    int from_d = 0;
    int to_d = 0;

    from += 2; // skip 0x
    if (sscanf(from, "%x", &from_d) != 1) {
        mi2_printf_error(flow, "Range 'from' is not properly specified");
        return;
    }

    to += 2; // skip 0x
    if (sscanf(to, "%x", &to_d) != 1) {
        mi2_printf_error(flow, "Range 'to' is not properly specified");
        return;
    }

    if (to_d <= from_d) {
        mi2_printf_error(flow, "Incorrect range");
        return;
    }

    int pc = from_d;

    uint16_t offset = 0;
    symbol* sym = symbol_find_lower(pc, SYM_ADDRESS, &offset);
    uint8_t first = 1;

    UT_string* dump_buffer;
    utstring_new(dump_buffer);

    while (pc <= to_d) {
        static char db[2048];
        int len = disassemble2(pc, db, sizeof(db), 2);

        if (!first) {
            utstring_printf(dump_buffer, ",");
        }

        if (mode_d == 2) {
            char* opcodes = strchr(db, ';');
            *opcodes = 0;
            opcodes++;
            if (sym) {
                utstring_printf(dump_buffer,
                    "{address=\"0x%08x\",func-name=\"%s\",offset=\"%d\",inst=\"%s\",opcodes=\"%s\"}",
                    pc, sym->name, offset, db, opcodes);
            } else {
                utstring_printf(dump_buffer,
                    "{address=\"0x%08x\",inst=\"%s\",opcodes=\"%s\"}", pc, db, opcodes);
            }
        } else {
            if (sym) {
                utstring_printf(dump_buffer,
                    "{address=\"0x%08x\",func-name=\"%s\",offset=\"%d\",inst=\"%s\"}",
                    pc, sym->name, offset, db);
            } else {
                utstring_printf(dump_buffer,
                    "{address=\"0x%08x\",inst=\"%s\"}", pc, db);
            }
        }

        offset += len;
        pc += len;
        first = 0;
    }

    mi2_printf_response(flow, "done,asm_insns=[%s]", utstring_body(dump_buffer));
    utstring_free(dump_buffer);
}

static void cmd_plain_disassemble(const char* flow, int argc, char **argv) {
    const char* address = NULL;
    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    uint8_t raw_bytes = 0;

    for (int i = 1; i < argc; i++) {
        const char* arg = argv[i];
        if (strcmp(arg, "/r") == 0) {
            raw_bytes = 1;
        } else {
            address = argv[i];
            break;
        }
    }

    int from_d = 0;
    int to_d = 0;
    int len_d = 0;

    address += 2;
    if (sscanf(address, "%x,+%d", &from_d, &len_d) != 2) {
        if (sscanf(address, "%x", &from_d) != 1) {
            mi2_printf_error(flow, "Range is not properly specified");
            return;
        } else {
            to_d = regs.pc + 256;
        }
    } else {
        to_d = from_d + len_d;
    }

    if (to_d > 0xFFFF) {
        to_d = 0xFFFF;
    }

    int pc = from_d;

    bk.console("Dump of assembler code from 0x%08x to 0x%08x:\n", from_d, to_d);

    while (pc <= to_d) {
        static char db[2048];
        int len = disassemble2(pc, db, sizeof(db), 2);

        const char* ppp = (pc == regs.pc) ? "=> " : "   ";

        if (raw_bytes) {
            char* opcodes = strchr(db, ';');
            if (opcodes) {
                *opcodes = 0;
                opcodes++;
                bk.console("%s0x%08x:\\t%s\\t%s\n", ppp, pc, opcodes, db);
            } else {
                bk.console("%s0x%08x:\\t%s\n", ppp, pc, db);
            }
        } else {
            bk.console("%s0x%08x:\\t%s\n", ppp, pc, db);
        }

        pc += len;
    }

    bk.console("End of assembler dump.\n");
    mi2_printf_response(flow, "done");
}

static void cmd_show(const char* flow, int argc, char **argv) {
    if (argc < 2) {
        mi2_printf_error(flow, "please specify variable");
        return;
    }

    const char* variable = argv[1];

    if (strcmp(variable, "mi-async") == 0) {
        mi2_printf_response(flow, "done,value=\"on\"");
        return;
    }

    mi2_printf_response(flow, "done,value=\"unknown\"");
}

static void cmd_continue(const char* flow, int argc, char **argv) {
    bk.resume();
    mi2_printf_response(flow, "running");
    report_continue();
}

static void cmd_break(const char* flow, int argc, char **argv) {
    bk.break_(0);
    mi2_printf_response(flow, "done");
}

static void cmd_next_instruction(const char* flow, int argc, char **argv) {
    bk.next(1);
    mi2_printf_response(flow, "done");
    report_continue();
}

static void cmd_fin(const char* flow, int argc, char **argv) {
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
        bk.resume();
        report_continue();
    } else {
        debug_stack_frames_free(first_frame_pointer);

        add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_FIN, NULL, 0);
        bk.step(0);
    }

    mi2_printf_response(flow, "done");
}

static void cmd_next(const char* flow, int argc, char **argv) {

    const char *filename;
    int   lineno;
    const unsigned short pc = bk.pc();
    if (debug_find_source_location(pc, &filename, &lineno) < 0) {
        add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_NEXT_SOURCE_LINE, NULL, 0);
        bk.next(0);
        report_continue();
        mi2_printf_response(flow, "done");
        return;
    }

    add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_NEXT_SOURCE_LINE, filename, lineno);
    bk.next(0);
    report_continue();
    mi2_printf_response(flow, "done");
}

static void cmd_step(const char* flow, int argc, char **argv) {

    const char *filename;
    int   lineno;
    const unsigned short pc = bk.pc();
    if (debug_find_source_location(pc, &filename, &lineno) < 0) {
        add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_STEP_SOURCE_LINE, NULL, 0);
        bk.step(0);
        report_continue();
        mi2_printf_response(flow, "done");
        return;
    }

    add_temporary_internal_breakpoint(TEMP_BREAKPOINT_ANYWHERE, TMP_REASON_STEP_SOURCE_LINE, filename, lineno);
    bk.step(0);
    report_continue();
    mi2_printf_response(flow, "done");
}

static void cmd_do_nothing(const char* flow, int argc, char **argv) {
    // we don't set anything
    mi2_printf_response(flow, "done");
}

static void cmd_target_select(const char* flow, int argc, char **argv) {
    if (argc < 3) {
        mi2_printf_error(flow, "target-select: requires 2 arguments");
        return;
    }

    if (strcmp(argv[1], "remote") != 0) {
        mi2_printf_error(flow, "target-select: unsupported %s", argv[1]);
        return;
    }

    char hostname[128];
    int port;

    {
        int scanf_res = sscanf(argv[2], "tcp:%[^:]:%d", hostname, &port);
        if (scanf_res != 2) {
            scanf_res = sscanf(argv[2], "%[^:]:%d", hostname, &port);
            if (scanf_res != 2) {
                mi2_printf_error(flow, "target-select: cannot process target address: %s", argv[2]);
                return;
            }
        }
    }

    bk.debug("Connecting to %s port %d...\n", hostname, port);
    strcpy(connect_flow, flow);

    if (bk.remote_connect(hostname, port) ) {
        mi2_printf_error(flow, "target-select: cannot connect hostname %s port %d", hostname, port);
        return;
    }

    bk.debug("Connected\n");
    report_connected = 1;
    report_execution_stopped = 1;
}

static void cmd_target_detach(const char* flow, int argc, char **argv)
{
    delete_all_breakpoints();
    bk.detach();
    mi2_printf_response(flow, "done");
}

static void cmd_break_insert(const char* flow, int argc, char **argv) {
    char* insert_path = NULL;

    for (int i = 1; i < argc; i++) {
        const char* arg = argv[i];

        if (strcmp(arg, "-f") == 0) {
            insert_path = argv[++i];
        }
    }

    if (insert_path) {
        const char *sym;
        breakpoint *elem;
        const char* corrected_source = insert_path;
        int value = parse_address(insert_path, &corrected_source);

        if ( value != -1 ) {
            elem = add_breakpoint(BREAK_PC, BK_BREAKPOINT_SOFTWARE, 1, value, NULL);

            uint16_t offset = 0;
            symbol* s = symbol_find_lower(value, SYM_ADDRESS, &offset);

            const char* filename;
            int lineno;
			char* escaped_filename = escape(s->file);
            if (debug_find_source_location(value, &filename, &lineno)) {
                mi2_printf_response(flow, 
                    "done,bkpt={number=\"%d\",type=\"breakpoint\",disp=\"keep\",enabled=\"y\","
                    "addr=\"0x%08x\",func=\"%s\",file=\"%s\","
                    "fullname=\"%s\",thread-groups=[\"i1\"],"
                    "times=\"0\"}", elem->number, value, s->name, escaped_filename, escaped_filename);
            } else {
                mi2_printf_response(flow, 
                    "done,bkpt={number=\"%d\",type=\"breakpoint\",disp=\"keep\",enabled=\"y\","
                    "addr=\"0x%08x\",func=\"%s\",file=\"%s\","
                    "fullname=\"%s\",line=\"%d\",thread-groups=[\"i1\"],"
                    "times=\"0\"}", elem->number, value, s->name, escaped_filename, escaped_filename, lineno);
            }
			free(escaped_filename);
        } else {
            mi2_printf_error(flow, "Cannot break on '%s'", corrected_source);
        }
    } else {
        mi2_printf_error(flow, "Cannot understand this");
    }
}

static void cmd_break_delete(const char* flow, int argc, char **argv) {
    char* insert_path = NULL;

    if (argc < 2) {
        mi2_printf_error(flow, "Specify breakpoint number");
        return;
    }

    breakpoint* b = find_breakpoint(atoi(argv[1]));

    if (b == NULL) {
        mi2_printf_error(flow, "unknown breakpoint");
        return;
    }

    delete_breakpoint(b);
    mi2_printf_response(flow, "done");
}

typedef struct mi2_command_execution {
    const char* flow;
    const char* command;
    command *cmd;
    char **argv;
    int argc;
} mi2_command_execution;

static void mi2_execution_stopped() {
    debugger_active = 1;

    struct debugger_regs_t regs;
    bk.get_regs(&regs);

    {
        breakpoint* elem;
        breakpoint* tmp;
        LL_FOREACH_SAFE(breakpoints, elem, tmp) {
            if (elem->pending_add) {
                elem->pending_add = 0;
                bk.add_breakpoint(BK_BREAKPOINT_SOFTWARE, elem->value, 1);
            }
            if (elem->pending_remove) {
                elem->pending_remove = 0;
                bk.remove_breakpoint(BK_BREAKPOINT_SOFTWARE, elem->value, 1);

                LL_DELETE(breakpoints, elem);
                if (elem->text) {
                    free(elem->text);
                    elem->text = NULL;
                }
                free(elem);
            }
        }
    }

    if (temporary_break)
    {
        temporary_break = 0;
        bk.resume();
        return;
    }

    static uint8_t report_thread = 1;

    if (report_thread) {
        report_thread = 0;
        mi2_printf_thread("thread-group-started,id=\"i1\",pid=\"1\"");
        mi2_printf_thread("thread-created,id=\"1\",group-id=\"i1\"");
    }

    breakpoint *breakpoint_hit = NULL;

    {
        breakpoint *elem;
        LL_FOREACH(breakpoints, elem) {
            if ( elem->enabled == 0 ) {
                continue;
            }
            switch (elem->type) {
                case BREAK_PC: {
                    if (elem->value == regs.pc) {
                        breakpoint_hit = elem;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
    }

    UT_string* frame;
    utstring_new(frame);
    sprintf_frame0(frame);

    if (breakpoint_hit) {
        bk.console("Hit a breakpoint\n");
        mi2_printf_async(
            "stopped,reason=\"breakpoint-hit\",disp=\"keep\",bkptno=\"%d\","
            "frame={%s},thread-id=\"1\",stopped-threads=\"all\"",
            breakpoint_hit->number, utstring_body(frame));
    } else {
        if (process_temp_breakpoints()) {
            mi2_printf_async(
                "stopped,reason=\"end-stepping-range\",frame={%s},thread-id=\"1\",stopped-threads=\"all\"",
                utstring_body(frame));
        } else {
            if (report_execution_stopped) {
                report_execution_stopped = 0;
                mi2_printf_async("stopped,frame={%s},thread-id=\"1\",stopped-threads=\"all\"", utstring_body(frame));
            }
        }
    }

    if (report_connected) {
        report_connected = 0;

        mi2_printf_response(connect_flow, "connected");
        mi2_printf_prompt();

        debugger_restore_pending_binary_file();
    }

    utstring_free(frame);
}

void execute_mi2_command_on_main_thread(const void* data, void* response) {
    const mi2_command_execution* exec = (const mi2_command_execution*)data;
    exec->cmd->func(exec->flow, exec->argc, exec->argv);
}

void execute_unknown_command(const void* data, void* response) {
    const mi2_command_execution* exec = (const mi2_command_execution*)data;
    bk.debug("warning: unknown command: %s\n", exec->command);
    mi2_printf_response(exec->flow, "done");
}

void execute_prompt(const void* data, void* response) {
    mi2_printf_prompt();
}

static void* debugger_mi2_console_loop(void* arg) {
    char *debugger_line = malloc(1024);
    size_t debugger_line_size = 1024;

    while (1) {
        execute_on_main_thread(execute_prompt, NULL, NULL);

        while (fgets(debugger_line, 1024, stdin) == 0) ;

        int argc;
        char **argv = parse_words(debugger_line, &argc);

        if ( argc > 0 ) {
            char* command_name = argv[0];
            char flow[32] = "";

            uint32_t flow_id;
            int end;
            if (sscanf(command_name, "%d-%n", &flow_id, &end) == 1) {
                // we have 'xxx-command' syntext, split it into 'xxx' and '-command'
                memset(flow, 0, sizeof(flow));
                memcpy(flow, command_name, end - 1);
                command_name += end - 1;
            }

            command *cmd = &mi2_commands[0];
            uint8_t command_found = 0;

            while ( cmd->cmd ) {
                if ( strcmp(command_name, cmd->cmd) == 0 ) {
                    command_found = 1;

                    mi2_command_execution exec;
                    exec.flow = flow;
                    exec.cmd = cmd;
                    exec.argv = argv;
                    exec.argc = argc;

                    execute_on_main_thread(execute_mi2_command_on_main_thread, &exec, NULL);

                    break;
                }
                cmd++;
            }

            if (command_found == 0) {
                mi2_command_execution exec;
                exec.flow = flow;
                exec.command = command_name;

                execute_on_main_thread(execute_unknown_command, &exec, NULL);
            }
        }

        free(argv);
    }

    free(debugger_line);

    return NULL;
}

static UT_string* slash(UT_string* formatted)
{
    /*
     * Find and replace '\n' (newline, 1 char) with '\\n' (two chars)
     * Find and replace '\t' (tab, 1 char) with '\\t' (two chars)
     */

    {
        char* newline;
        while ((newline = strchr(utstring_body(formatted), '\n')))
        {
            size_t left_side = newline - utstring_body(formatted);

            UT_string* new_string;
            utstring_new(new_string);
            if (left_side) {
                utstring_bincpy(new_string, utstring_body(formatted), left_side);
            }
            utstring_printf(new_string, "\\n");
            if (strlen(++newline)) {
                utstring_printf(new_string, "%s", newline);
            }

            utstring_free(formatted);
            formatted = new_string;
        }
    }

    {
        char* tab;
        while ((tab = strchr(utstring_body(formatted), '\t')))
        {
            size_t left_side = tab - utstring_body(formatted);

            UT_string* new_string;
            utstring_new(new_string);
            if (left_side) {
                utstring_bincpy(new_string, utstring_body(formatted), left_side);
            }
            utstring_printf(new_string, "\\t");
            if (strlen(++tab)) {
                utstring_printf(new_string, "%s", tab);
            }

            utstring_free(formatted);
            formatted = new_string;
        }
    }

    return formatted;
}

static void mi2_console_printf(const char *fmt, ...) {
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

        formatted = slash(formatted);

        /* Call the wrapped function using the formatted output and return */
        printf("~\"%s\"\n", utstring_body(formatted));
        utstring_free(formatted);
    }
}

static void mi2_internal_printf(const char *fmt, ...) {
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

        formatted = slash(formatted);

        /* Call the wrapped function using the formatted output and return */
        printf("&\"%s\"\n", utstring_body(formatted));
        utstring_free(formatted);
    }
}

static void mi2_break(uint8_t temporary)
{
    if (temporary == 0) {
        report_execution_stopped = 1;
    }

    debugger_gdb_break(temporary);
}

void debugger_mi2_init()
{
    // we need to disable buffering or the client won't be happy
    setbuf(stdout, NULL);

    bk.console = mi2_console_printf;
    bk.debug = mi2_internal_printf;
    bk.execution_stopped = mi2_execution_stopped;
    bk.break_ = mi2_break;

    {
        pthread_t id;
        pthread_create(&id, NULL, debugger_mi2_console_loop, NULL);
        pthread_detach(id);
    }
}
