#include "profiler.h"
#include "backend.h"
#include "debugger.h"

int profiler_enabled = 0;
static breakpoint* breakpoint_push_frame = NULL;
static breakpoint* breakpoint_pop_frame = NULL;
static struct profile_function_t* profiling_functions = NULL;
static int stack_level = 0;
const char* within_function_only = NULL;
static int profiling_iterations_limit = 0;

struct profile_function_call_t {
    uint32_t time;
    struct profile_function_call_t* next;
    struct profile_function_call_t* prev;
};

struct profile_function_t
{
    debug_sym_function* function;
    struct profile_function_call_t* calls;
    uint64_t total_time;

    UT_hash_handle hh;
};

static struct profile_function_t* lookup_function(debug_sym_function* function, uint8_t allocate) {

    struct profile_function_t* f = NULL;
    HASH_FIND(hh, profiling_functions, &function, sizeof(debug_sym_function*), f);
    if (f) {
        return f;
    }
    if (allocate == 0) {
        return NULL;
    }

    f = calloc(1, sizeof(struct profile_function_t));
    f->function = function;
    HASH_ADD_KEYPTR(hh, profiling_functions, &function, sizeof(debug_sym_function*), f);
    return f;
}

uint8_t profiler_check(uint16_t pc) {
    if (profiler_enabled == 0) {
        return 0;
    }

    if (breakpoint_push_frame->value == pc) {

        uint16_t stack = bk.sp();
        struct debugger_regs_t regs;
        bk.get_regs(&regs);
        debug_frame_pointer* fp = debug_stack_frames_construct(pc, stack, &regs, 2);
        if (fp == NULL) {
            return 1;
        }
        fp = fp->next;
        if (fp == NULL || fp->function == NULL) {
            return 1;
        }

        if ((stack_level == 0) && (within_function_only != NULL) && (strcmp(within_function_only, fp->function->function_name) != 0))
        {
            return 1;
        }

        // a new function has been called
        struct profile_function_t* f = lookup_function(fp->function, 1);

        struct profile_function_call_t* call = calloc(1, sizeof(struct profile_function_call_t));
        call->time = bk.time();
        DL_PREPEND(f->calls, call);

        debug_stack_frames_free(fp);
        stack_level++;

        return 1;
    } else if (breakpoint_pop_frame->value == pc) {

        if (stack_level) {
            if (--stack_level == 0) {
                // we've just reached an end of iteration
                if (profiling_iterations_limit) {
                    // we have a limit
                    if (--profiling_iterations_limit == 0) {
                        // it just completed
                        debugger_active = 1;
                        profiler_stop();
                        return 0;
                    }
                }
            }
        } else {
            // stack discrepancy, we don't care
            return 1;
        }

        uint16_t stack = bk.sp();
        struct debugger_regs_t regs;
        bk.get_regs(&regs);
        debug_frame_pointer* fp = debug_stack_frames_construct(pc, stack, &regs, 2);
        if (fp == NULL) {
            return 1;
        }
        fp = fp->next;
        if (fp == NULL || fp->function == NULL) {
            return 1;
        }

        // a function has exited
        struct profile_function_t* f = lookup_function(fp->function, 0);

        if (f) {
            struct profile_function_call_t* head = f->calls;
            if (head) {
                uint32_t spent = bk.time() - head->time;
                f->total_time += spent;
                DL_DELETE(f->calls, head);
                free(head);
            }
        }

        return 1;
    }

    return 0;
}

void profiler_start(const char* function, int iterations_limit) {
    if (profiler_enabled) {
        bk.console("Warning: profiler is already enabled.\n");
        return;
    }

    stack_level = 0;
    within_function_only = function;
    profiling_iterations_limit = iterations_limit;

    int push_frame = symbol_resolve("l_debug_push_frame", NULL);
    int pop_frame = symbol_resolve("l_debug_pop_frame", NULL);

    if (push_frame == -1 || pop_frame == -1) {
        bk.console("Could not start profiling: symbol l_debug_push_frame or l_debug_pop_frame is not known.\n");
        return;
    }

    breakpoint_push_frame = add_breakpoint(BREAK_PC, BK_BREAKPOINT_SOFTWARE, 1, push_frame, strdup("profiler push"));
    breakpoint_pop_frame = add_breakpoint(BREAK_PC, BK_BREAKPOINT_SOFTWARE, 1, pop_frame, strdup("profiler pop"));

    bk.console("Profiler enabled.\n");
    if (within_function_only) {
        bk.console(" (limited to function %s)\n", within_function_only);
    }
    if (iterations_limit) {
        bk.console(" (limited to %d iterations)\n", iterations_limit);
    }
    profiler_enabled = 1;
}

int sort_functions(struct profile_function_t *a, struct profile_function_t *b) {
    if (a->total_time < b->total_time) {
        return 1;
    }
    if (a->total_time > b->total_time) {
        return -1;
    }
    return 0;
}

void profiler_stop() {
    if (profiler_enabled == 0) {
        bk.console("Warning: profiler is not enabled.\n");
        return;
    }

    delete_breakpoint(breakpoint_push_frame);
    delete_breakpoint(breakpoint_pop_frame);

    breakpoint_push_frame = NULL;
    breakpoint_pop_frame = NULL;

    HASH_SORT(profiling_functions, sort_functions);

    uint64_t total_total_time = 0;

    struct profile_function_t* f = profiling_functions;
    while (f) {
        total_total_time += f->total_time;
        f = f->hh.next;
    }

    bk.console("Profiling results:\n");
    bk.console("----------------------------------\n");
    bk.console("    Time     Share    Function\n");
    bk.console("----------------------------------\n");

    f = profiling_functions;
    while (f) {
        double time_percent = (double)f->total_time / (double)total_total_time;
        int time_percent_int = (int)(time_percent * 100.0f);
        bk.console("%*d %*d%%    %s\n", 8, f->total_time, 8, time_percent_int, f->function->function_name);

        f = f->hh.next;
    }

    struct profile_function_t* tmp;
    HASH_ITER(hh, profiling_functions, f, tmp) {

        struct profile_function_call_t* el;
        struct profile_function_call_t* tmp2;
        DL_FOREACH_SAFE(f->calls, el, tmp2) {
            DL_DELETE(f->calls, el);
            free(el);
        }

        HASH_DEL(profiling_functions, f);
        free(f);
    }

    bk.console("----------------------------------\n");

    profiler_enabled = 0;
}