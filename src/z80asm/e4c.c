/*
 *
 * @file        e4c.c
 *
 * exceptions4c source code file
 *
 * @version     2.4
 * @author      Copyright (c) 2011 Guillermo Calvo
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

/*
 * e4c.c is undocumented on purpose (everything is documented in e4c.h)
 */


# include <stdio.h>
# include <signal.h>
# include <errno.h>
# include <stdarg.h>
# include "e4c.h"


# ifdef __NO_INLINE__
#   define E4C_INLINE
# elif defined(_ISOC99_SOURCE) \
    || defined(_GNU_SOURCE) \
    || ( defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) )
#   define E4C_INLINE inline
# elif ( defined(__GNUC__) && (__GNUC__ >= 2) )
#   define E4C_INLINE __extension__ inline
# else
#   define E4C_INLINE
# endif

# define IS_TOP_FRAME(frame)            ( frame->previous == NULL )

# define CONTEXT_IS_READY               (E4C_CONTEXT != NULL)

# define INITIALIZE_ONCE                if(!is_initialized) _e4c_initialize()

# define RETURN_VOID

# define FATAL_ERROR(exception, function, message, file, line, unreachable_return_value) \
    _e4c_fatal_error(&exception, message, file, line, function, errno, NULL); \
    E4C_UNREACHABLE_RETURN(unreachable_return_value); \

# define CHECK_FATAL_ERROR(condition, exception, function, message, file, line, unreachable_return_value) \
    if(condition) { \
        FATAL_ERROR(exception, function, message, file, line, unreachable_return_value) \
    }

# define PREVENT(condition, exception, function, message, unreachable_return_value) \
    CHECK_FATAL_ERROR(condition, exception, function, message, __FILE__, __LINE__, unreachable_return_value)

# define PREVENT_MISUSE CHECK_FATAL_ERROR

# define EXCEPTION_LITERAL(_name_, _message_, _super_, _file_, _line_, _function_, _error_number_, _type_, _cause_) \
    { _name_, _message_, _super_, _file_, _line_, _function_, _error_number_, _type_, _cause_ }

# define NULL_EXCEPTION_LITERAL \
    EXCEPTION_LITERAL(NULL, { '\0' }, NULL, NULL, 0, NULL, 0, NULL, NULL)

# define EXCEPTION_TYPE_LITERAL(_name_, _message_, _super_) \
    EXCEPTION_LITERAL(#_name_, _message_, _super_, _E4C_FILE_INFO, _E4C_LINE_INFO, NULL, 0, &_name_, NULL)

# define DEFINE_RAW_EXCEPTION(_name_, _message_, _super_) \
    const e4c_exception _name_ = EXCEPTION_TYPE_LITERAL(_name_, _message_, _super_)

# define DESC_MALLOC_FRAME          "Could not create a new exception frame."
# define DESC_MALLOC_CONTEXT        "Could not create a new exception context."
# define DESC_CATCH_NULL            "A NULL argument was passed to E4C_CATCH."
# define DESC_CANNOT_REACQUIRE      "There is no E4C_WITH block to reacquire."
# define DESC_CANNOT_RETRY          "There is no E4C_TRY block to retry."
# define DESC_CANNOT_REPEAT         "The specified stage can't be repeated."
# define DESC_TOO_MANY_FRAMES       "There are too many exception frames. Probably some try{...} block was exited through 'return' or 'break'."
# define DESC_NO_FRAMES_LEFT        "There are no exception frames left."
# define DESC_INVALID_FRAME         "The exception context has an invalid frame."
# define DESC_INVALID_CONTEXT       "The exception context is invalid."
# define DESC_NO_MAPPING            "There is no exception mapping for the received signal."

# ifdef E4C_THREADSAFE
#   include <pthread.h>
#   define E4C_CONTEXT              _e4c_get_context()
#   define DESC_INVALID_STATE       "The exception context for this thread is in an invalid state."
#   define DESC_ALREADY_BEGUN       "The exception context for this thread has already begun."
#   define DESC_NOT_BEGUN_YET       "The exception context for this thread has not begun yet."
#   define DESC_NOT_ENDED           "There is at least one thread that did not end its exception context properly."
#   define MSG_FATAL_ERROR          "\n\nThis is an unrecoverable programming error; the thread will be terminated\nimmediately.\n"
#   define MSG_AT_EXIT_ERROR        "\n\nThe program will now yield a failure exit code due to exception system errors.\n"
#   define THREAD_TYPE              pthread_t
#   define THREAD_CURRENT           pthread_self()
#   define THREAD_SAME              pthread_equal
#   define THREAD_EXIT              pthread_exit
#   define MUTEX_DEFINE(mutex)      static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
#   define MUTEX_LOCK(mutex)        pthread_mutex_lock(&mutex)
#   define MUTEX_UNLOCK(mutex)      pthread_mutex_unlock(&mutex)
#   define STOP_EXECUTION           THREAD_EXIT(PTHREAD_CANCELED)
#   define DANGLING_CONTEXT         (environment_collection != NULL)
# else
#   define E4C_CONTEXT              current_context
#   define DESC_INVALID_STATE       "The exception context for this program is in an invalid state."
#   define DESC_ALREADY_BEGUN       "The exception context for this program has already begun."
#   define DESC_NOT_BEGUN_YET       "The exception context for this program has not begun yet."
#   define DESC_NOT_ENDED           "The program did not end its exception context properly."
#   define MSG_FATAL_ERROR          "\n\nThis is an unrecoverable programming error; the application will be terminated\nimmediately.\n"
#   define MSG_AT_EXIT_ERROR        "\n\nIf this application is making use of threads, please recompile exceptions4c\nwith thread support (by defining the macro E4C_THREADSAFE).\n\n\nThe program will now yield a failure exit code due to exception system errors.\n"
#   define MUTEX_DEFINE(mutex)
#   define MUTEX_LOCK(mutex)
#   define MUTEX_UNLOCK(mutex)
#   define STOP_EXECUTION           exit(EXIT_FAILURE)
#   define DANGLING_CONTEXT         (current_context != NULL)
# endif

# ifndef NDEBUG
#   define DEBUG_PREVENT(condition, function, message, unreachable_return_value) \
        PREVENT(condition, ExceptionSystemFatalError, function, message, unreachable_return_value)
# else
#   define DEBUG_PREVENT(condition, function, message, unreachable_return_value)
# endif

static const char * signal_name_UNKNOWN     = "{unknown signal}";
static const char * signal_name_SIGABRT     = "SIGABRT";
static const char * signal_name_SIGFPE      = "SIGFPE";
static const char * signal_name_SIGILL      = "SIGILL";
static const char * signal_name_SIGSEGV     = "SIGSEGV";
static const char * signal_name_SIGTERM     = "SIGTERM";
static const char * signal_name_SIGINT      = "SIGINT";

# define WHEN_SIGNAL(signal_id) \
    case signal_id: signal_name = signal_name_##signal_id;  break;

# ifdef SIGALRM
    static const char * signal_name_SIGALRM     = "SIGALRM";
#   define WHEN_SIGNAL_SIGALRM                  WHEN_SIGNAL(SIGALRM)
#   define E4C_SIGNAL_MAPPING_SIGALRM           E4C_SIGNAL_MAPPING(SIGALRM,     SignalAlarmException),
# else
#   define WHEN_SIGNAL_SIGALRM
#   define E4C_SIGNAL_MAPPING_SIGALRM
# endif

# ifdef SIGCHLD
    static const char * signal_name_SIGCHLD     = "SIGCHLD";
#   define WHEN_SIGNAL_SIGCHLD                  WHEN_SIGNAL(SIGCHLD)
#   define E4C_SIGNAL_MAPPING_SIGCHLD           E4C_SIGNAL_MAPPING(SIGCHLD,     SignalChildException),
# else
#   define WHEN_SIGNAL_SIGCHLD
#   define E4C_SIGNAL_MAPPING_SIGCHLD
# endif

# ifdef SIGTRAP
    static const char * signal_name_SIGTRAP     = "SIGTRAP";
#   define WHEN_SIGNAL_SIGTRAP                  WHEN_SIGNAL(SIGTRAP)
#   define E4C_SIGNAL_MAPPING_SIGTRAP           E4C_SIGNAL_MAPPING(SIGTRAP,     SignalTrapException),
# else
#   define WHEN_SIGNAL_SIGTRAP
#   define E4C_SIGNAL_MAPPING_SIGTRAP
# endif

# ifdef SIGPIPE
    static const char * signal_name_SIGPIPE     = "SIGPIPE";
#   define WHEN_SIGNAL_SIGPIPE                  WHEN_SIGNAL(SIGPIPE)
#   define E4C_SIGNAL_MAPPING_SIGPIPE           E4C_SIGNAL_MAPPING(SIGPIPE,     BrokenPipeException),
# else
#   define WHEN_SIGNAL_SIGPIPE
#   define E4C_SIGNAL_MAPPING_SIGPIPE
# endif

# ifdef SIGSTOP
    static const char * signal_name_SIGSTOP     = "SIGSTOP";
#   define WHEN_SIGNAL_SIGSTOP                  WHEN_SIGNAL(SIGSTOP)
#   define E4C_SIGNAL_MAPPING_SIGSTOP           E4C_SIGNAL_MAPPING(SIGSTOP,     StopException),
# else
#   define WHEN_SIGNAL_SIGSTOP
#   define E4C_SIGNAL_MAPPING_SIGSTOP
# endif

# ifdef SIGKILL
    static const char * signal_name_SIGKILL     = "SIGKILL";
#   define WHEN_SIGNAL_SIGKILL                  WHEN_SIGNAL(SIGKILL)
#   define E4C_SIGNAL_MAPPING_SIGKILL           E4C_SIGNAL_MAPPING(SIGKILL,     KillException),
# else
#   define WHEN_SIGNAL_SIGKILL
#   define E4C_SIGNAL_MAPPING_SIGKILL
# endif

# ifdef SIGHUP
    static const char * signal_name_SIGHUP      = "SIGHUP";
#   define WHEN_SIGNAL_SIGHUP                   WHEN_SIGNAL(SIGHUP)
#   define E4C_SIGNAL_MAPPING_SIGHUP            E4C_SIGNAL_MAPPING(SIGHUP,      HangUpException),
# else
#   define WHEN_SIGNAL_SIGHUP
#   define E4C_SIGNAL_MAPPING_SIGHUP
# endif

# ifdef SIGXCPU
    static const char * signal_name_SIGXCPU     = "SIGXCPU";
#   define WHEN_SIGNAL_SIGXCPU                  WHEN_SIGNAL(SIGXCPU)
#   define E4C_SIGNAL_MAPPING_SIGXCPU           E4C_SIGNAL_MAPPING(SIGXCPU,     CPUTimeException),
# else
#   define WHEN_SIGNAL_SIGXCPU
#   define E4C_SIGNAL_MAPPING_SIGXCPU
# endif

# ifdef SIGQUIT
    static const char * signal_name_SIGQUIT     = "SIGQUIT";
#   define WHEN_SIGNAL_SIGQUIT                  WHEN_SIGNAL(SIGQUIT)
#   define E4C_SIGNAL_MAPPING_SIGQUIT           E4C_SIGNAL_MAPPING(SIGQUIT,     UserQuitException),
# else
#   define WHEN_SIGNAL_SIGQUIT
#   define E4C_SIGNAL_MAPPING_SIGQUIT
# endif

# ifdef SIGBREAK
    static const char * signal_name_SIGBREAK    = "SIGBREA";
#   define WHEN_SIGNAL_SIGBREAK                 WHEN_SIGNAL(SIGBREAK)
#   define E4C_SIGNAL_MAPPING_SIGBREAK          E4C_SIGNAL_MAPPING(SIGBREAK,    UserBreakException),
# else
#   define WHEN_SIGNAL_SIGBREAK
#   define E4C_SIGNAL_MAPPING_SIGBREAK
# endif

# ifdef SIGUSR1
    static const char * signal_name_SIGUSR1     = "SIGUSR1";
#   define WHEN_SIGNAL_SIGUSR1                  WHEN_SIGNAL(SIGUSR1)
#   define E4C_SIGNAL_MAPPING_SIGUSR1           E4C_SIGNAL_MAPPING(SIGUSR1,     ProgramSignal1Exception),
# else
#   define WHEN_SIGNAL_SIGUSR1
#   define E4C_SIGNAL_MAPPING_SIGUSR1
# endif

# ifdef SIGUSR2
    static const char * signal_name_SIGUSR2     = "SIGUSR2";
#   define WHEN_SIGNAL_SIGUSR2                  WHEN_SIGNAL(SIGUSR2)
#   define E4C_SIGNAL_MAPPING_SIGUSR2           E4C_SIGNAL_MAPPING(SIGUSR2,     ProgramSignal2Exception),
# else
#   define WHEN_SIGNAL_SIGUSR2
#   define E4C_SIGNAL_MAPPING_SIGUSR2
# endif




typedef enum _e4c_frame_stage e4c_stage;

typedef struct _e4c_frame e4c_frame;
struct _e4c_frame{
    e4c_frame *                         previous;
    volatile e4c_stage                  stage;
    volatile e4c_bool                   thrown;
    volatile e4c_bool                   uncaught;
    volatile e4c_exception              thrown_exception;
    volatile int                        retry_attempts;
    volatile int                        reacquire_attempts;
    _E4C_JMP_BUF                        address;
};

typedef struct _e4c_context e4c_context;
struct _e4c_context{
    e4c_frame *                         current_frame;
    const e4c_signal_mapping *          signal_mappings;
    e4c_uncaught_handler                uncaught_handler;
};

# ifdef E4C_THREADSAFE
typedef struct _e4c_environment e4c_environment;
struct _e4c_environment{
    THREAD_TYPE                         self;
    e4c_environment *                   next;
    e4c_context                         context;
};
# endif




static E4C_INLINE e4c_exception         _e4c_new_exception(const e4c_exception * prototype, const char * message, const char * file, int line, const char * function, int error_number, const e4c_exception * cause);
static E4C_INLINE e4c_frame             _e4c_new_frame(e4c_frame * previous, e4c_stage stage);
static E4C_INLINE void                  _e4c_delete_frame(e4c_frame * frame);
static E4C_INLINE void                  _e4c_fatal_error(const e4c_exception * prototype, const char * message, const char * file, int line, const char * function, int error_number, const e4c_exception * cause);
static E4C_INLINE e4c_bool              _e4c_extends(const e4c_exception * child, const e4c_exception * parent);
static void                             _e4c_propagate(e4c_context * context, const e4c_exception * exception) E4C_NORETURN;
static void                             _e4c_at_uncaught_exception(e4c_context * context);
static void                             _e4c_set_signal_handlers(e4c_context * context, const e4c_signal_mapping * mappings);
static void                             _e4c_initialize();
static void                             e4c_handle_signal(int signal_number);
static void                             e4c_at_exit();

# ifndef NDEBUG
    static E4C_INLINE void              _e4c_print_exception_hierarchy(const e4c_exception * exception);
# endif

# ifdef E4C_THREADSAFE
    static void                         _e4c_add_environment(e4c_environment * environment);
    static e4c_environment *            _e4c_remove_environment();
    static e4c_environment *            _e4c_get_environment();
    static E4C_INLINE e4c_context *     _e4c_get_context();
# endif




static volatile e4c_bool    fatal_error_flag    = e4c_false;
static e4c_bool             is_initialized      = e4c_false;

MUTEX_DEFINE(is_initialized_mutex)
MUTEX_DEFINE(environment_collection_mutex)

# ifdef E4C_THREADSAFE
    static e4c_environment * environment_collection = NULL;
# else
    static e4c_context mainContext;
    static e4c_context * current_context = NULL;
# endif

static const e4c_signal_mapping e4c_default_signal_mappings_array[] = {
    E4C_SIGNAL_MAPPING(SIGABRT,     AbortException),
    E4C_SIGNAL_MAPPING(SIGFPE,      ArithmeticException),
    E4C_SIGNAL_MAPPING(SIGILL,      IllegalInstructionException),
    E4C_SIGNAL_MAPPING(SIGSEGV,     BadPointerException),
    E4C_SIGNAL_MAPPING(SIGTERM,     TerminationException),
    E4C_SIGNAL_MAPPING(SIGINT,      UserInterruptionException),
    E4C_SIGNAL_MAPPING_SIGALRM
    E4C_SIGNAL_MAPPING_SIGCHLD
    E4C_SIGNAL_MAPPING_SIGTRAP
    E4C_SIGNAL_MAPPING_SIGPIPE
    E4C_SIGNAL_MAPPING_SIGSTOP
    E4C_SIGNAL_MAPPING_SIGKILL
    E4C_SIGNAL_MAPPING_SIGHUP
    E4C_SIGNAL_MAPPING_SIGXCPU
    E4C_SIGNAL_MAPPING_SIGQUIT
    E4C_SIGNAL_MAPPING_SIGBREAK
    E4C_SIGNAL_MAPPING_SIGUSR1
    E4C_SIGNAL_MAPPING_SIGUSR2
    E4C_NULL_SIGNAL_MAPPING
};

const e4c_signal_mapping * e4c_default_signal_mappings = &e4c_default_signal_mappings_array[0];

static
DEFINE_RAW_EXCEPTION(ExceptionSystemFatalError,         DESC_INVALID_STATE,                 NULL);
static
E4C_DEFINE_EXCEPTION(ContextAlreadyBegun,               DESC_ALREADY_BEGUN,                 ExceptionSystemFatalError);
static
E4C_DEFINE_EXCEPTION(ContextHasNotBegunYet,             DESC_NOT_BEGUN_YET,                 ExceptionSystemFatalError);
static
E4C_DEFINE_EXCEPTION(ContextNotEnded,                   DESC_NOT_ENDED,                     ExceptionSystemFatalError);

DEFINE_RAW_EXCEPTION(AssertionException,                "Assertion failed.",                NULL);

E4C_DEFINE_EXCEPTION(RuntimeException,                  "Runtime exception.",               RuntimeException);
E4C_DEFINE_EXCEPTION(NotEnoughMemoryException,          "Not enough memory.",               RuntimeException);
E4C_DEFINE_EXCEPTION(FileOpenException,                 "Couldn't open file.",              RuntimeException);
E4C_DEFINE_EXCEPTION(IllegalArgumentException,          "Illegal argument.",                RuntimeException);

E4C_DEFINE_EXCEPTION(SignalException,                   "Signal received.",                 RuntimeException);
E4C_DEFINE_EXCEPTION(SignalAlarmException,              "Alarm clock signal received.",     SignalException);
E4C_DEFINE_EXCEPTION(SignalChildException,              "Child process signal received.",   SignalException);
E4C_DEFINE_EXCEPTION(SignalTrapException,               "Trace trap.",                      SignalException);
E4C_DEFINE_EXCEPTION(ErrorSignalException,              "Error signal received.",           SignalException);
E4C_DEFINE_EXCEPTION(IllegalInstructionException,       "Illegal instruction.",             ErrorSignalException);
E4C_DEFINE_EXCEPTION(ArithmeticException,               "Erroneous arithmetic operation.",  ErrorSignalException);
E4C_DEFINE_EXCEPTION(BrokenPipeException,               "Broken pipe.",                     ErrorSignalException);
E4C_DEFINE_EXCEPTION(BadPointerException,               "Segmentation violation.",          ErrorSignalException);
E4C_DEFINE_EXCEPTION(NullPointerException,              "Null pointer.",                    BadPointerException);
E4C_DEFINE_EXCEPTION(ControlSignalException,            "Control signal received.",         SignalException);
E4C_DEFINE_EXCEPTION(StopException,                     "Stop signal received.",            ControlSignalException);
E4C_DEFINE_EXCEPTION(KillException,                     "Kill signal received.",            ControlSignalException);
E4C_DEFINE_EXCEPTION(HangUpException,                   "Hang up signal received.",         ControlSignalException);
E4C_DEFINE_EXCEPTION(TerminationException,              "Termination signal received.",     ControlSignalException);
E4C_DEFINE_EXCEPTION(AbortException,                    "Abort signal received.",           ControlSignalException);
E4C_DEFINE_EXCEPTION(CPUTimeException,                  "Exceeded CPU time.",               ControlSignalException);
E4C_DEFINE_EXCEPTION(UserControlSignalException,        "User control signal received.",    ControlSignalException);
E4C_DEFINE_EXCEPTION(UserQuitException,                 "Quit signal received.",            UserControlSignalException);
E4C_DEFINE_EXCEPTION(UserInterruptionException,         "Interrupt signal received.",       UserControlSignalException);
E4C_DEFINE_EXCEPTION(UserBreakException,                "Break signal received.",           UserControlSignalException);
E4C_DEFINE_EXCEPTION(ProgramSignalException,            "User-defined signal received.",    SignalException);
E4C_DEFINE_EXCEPTION(ProgramSignal1Exception,           "User-defined signal 1 received.",  ProgramSignalException);
E4C_DEFINE_EXCEPTION(ProgramSignal2Exception,           "User-defined signal 2 received.",  ProgramSignalException);




long e4c_library_version(void){

    return(E4C_VERSION_NUMBER);
}

e4c_bool e4c_context_is_ready(void){

    return(CONTEXT_IS_READY);
}

e4c_bool e4c_is_instance_of(const e4c_exception * instance, const e4c_exception * type){

    if(instance == NULL || type == NULL){
        if(instance != type){
            if(instance == NULL){
                /* the instance is NULL: maybe no exception was thrown */
                e4c_throw_exception(NullPointerException.type, _E4C_FILE_INFO, _E4C_LINE_INFO, "e4c_is_instance_of", e4c_true, "Null exception instance.");
            }
            /* the type is NULL: this is actually strange */
            e4c_throw_exception(NullPointerException.type, _E4C_FILE_INFO, _E4C_LINE_INFO, "e4c_is_instance_of", e4c_true, "Null exception type.");
        }
        /* both of the parameters are NULL: now this would be really weird */
        e4c_throw_exception(NullPointerException.type, _E4C_FILE_INFO, _E4C_LINE_INFO, "e4c_is_instance_of", e4c_true, "Null exception instance and type.");
    }

    if(instance->type == type)  return(e4c_true);

    if(instance->super == NULL || instance->super == instance){
        /* If instance is an actual thrown exception, then the instance will
        never be equal to an instance's supertpe, but just in case... */
        return(e4c_false);
    }

    return( _e4c_extends(instance->super, type) );
}

e4c_status e4c_get_status(void){

    e4c_context *   context;
    e4c_frame *     frame;

    context = E4C_CONTEXT;
    /* check if 'e4c_get_status' was called before calling e4c_context_begin */
    PREVENT(context == NULL, ContextHasNotBegunYet, "e4c_get_status", NULL, e4c_failed);

    frame = context->current_frame;
    /* check if the current frame is NULL (very unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_get_status", DESC_INVALID_FRAME, e4c_failed);

    if(!frame->thrown) return(e4c_succeeded);

    if(frame->uncaught) return(e4c_failed);

    return(e4c_recovered);
}

_E4C_JMP_BUF * e4c_frame_init(e4c_stage stage, const char * file, int line, const char * function){

    e4c_context *   context;
    e4c_frame *     current_frame;
    e4c_frame *     new_frame;

    context = E4C_CONTEXT;

    /* check if 'try' was used before calling e4c_context_begin */
    PREVENT_MISUSE(context == NULL, ContextHasNotBegunYet, function, "e4c_frame_init: " DESC_NOT_BEGUN_YET, file, line, NULL);

    current_frame = context->current_frame;

    /* check if the current frame is NULL (very unlikely) */
    DEBUG_PREVENT(current_frame == NULL, "e4c_frame_init", DESC_INVALID_FRAME, NULL);

    /* create a new frame */
    new_frame = malloc( sizeof(*new_frame) );

    /* check if there wasn't enough memory */
    PREVENT(new_frame == NULL, NotEnoughMemoryException, "e4c_frame_init", DESC_MALLOC_FRAME, NULL);

    *new_frame = _e4c_new_frame(current_frame, stage);

    /* make it the new current frame */
    context->current_frame  = new_frame;

    return( &(new_frame->address) );
}

e4c_bool e4c_frame_hook(e4c_stage stage, const e4c_exception * catch_exception, const char * file, int line, const char * function){

    e4c_context *   context;
    e4c_frame *     frame;

    context = E4C_CONTEXT;
    /* check if the current exception context is NULL (unlikely) */
    DEBUG_PREVENT(context == NULL, "e4c_frame_hook", DESC_NOT_BEGUN_YET, e4c_false);

    frame = context->current_frame;
    /* check if the current frame is NULL (very unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_frame_hook", DESC_INVALID_FRAME, e4c_false);

    if(frame->stage != stage) return(e4c_false);

    if(stage == _e4c_catching){

        /* passing NULL to a catch block is considered a fatal error */
        PREVENT_MISUSE(catch_exception == NULL, NullPointerException, function, DESC_CATCH_NULL, file, line, e4c_false);

        /* does this block catch current exception? */
        /* assert: thrown_exception->super != NULL (otherwise we would have skipped the "catching" stage in e4c_frame_step) */
        if( frame->thrown_exception.type != catch_exception && !_e4c_extends(frame->thrown_exception.type, catch_exception) ){
            /* nay, keep looking for an exception handler */
            return(e4c_false);
        }
        /* yay, catch current exception by executing the handler */
        frame->uncaught = e4c_false;
    }

    return(e4c_true);
}

e4c_bool e4c_frame_step(void){

    e4c_context *   context;
    e4c_frame *     frame;
    e4c_frame       tmp;

    context = E4C_CONTEXT;
    /* check if the current exception context is NULL (unlikely) */
    DEBUG_PREVENT(context == NULL, "e4c_frame_step", DESC_NOT_BEGUN_YET, e4c_false);

    frame = context->current_frame;
    /* check if the current frame is NULL (very unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_frame_step", DESC_INVALID_FRAME, e4c_false);

    frame->stage++;

    /* simple optimization */
    if( frame->stage == _e4c_catching && (!frame->uncaught || frame->thrown_exception.super == NULL) ){
        /* if no exception was thrown, or if the thrown exception cannot be
            caught, we don't need to go through the "catching" stage */
        frame->stage++;
    }

    /* keep looping until we reach the "done" stage */
    if(frame->stage < _e4c_done) return(e4c_true);

    /* the exception loop is finished; let's capture temporarily the information */
    /* of the current frame, so we can propagate an exception (if it was thrown) */
    tmp = *frame;

    /* delete the current frame */
    free(frame);

    /* promote the previous frame to the current one */
    context->current_frame = frame = tmp.previous;

    /* check if the current frame is NULL (unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_frame_step", DESC_INVALID_FRAME, e4c_false);

    /* if the current frame has an uncaught exception, then we will propagate it */
    if(tmp.uncaught){
        _e4c_propagate(context, (const e4c_exception *)&tmp.thrown_exception);
    }
    /* otherwise, we're free to go */

    /* get out of the exception loop */
    return(e4c_false);
}

void e4c_frame_repeat(int max_repeat_attempts, enum _e4c_frame_stage stage, const char * file, int line, const char * function){

    e4c_context *       context;
    e4c_frame *         frame;
    e4c_exception       null_exception = NULL_EXCEPTION_LITERAL;

    /* get the current context */
    context = E4C_CONTEXT;

    /* check if 'e4c_frame_repeat' was used before calling e4c_context_begin */
    PREVENT_MISUSE(context == NULL, ContextHasNotBegunYet, function, "e4c_frame_repeat: " DESC_NOT_BEGUN_YET, file, line, RETURN_VOID);

    /* get the current frame */
    frame = context->current_frame;

    /* check if the current frame is NULL (unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_frame_repeat", DESC_INVALID_FRAME, RETURN_VOID);

    /* check if 'e4c_frame_repeat' was used before 'try' or 'use' */
    PREVENT_MISUSE(IS_TOP_FRAME(frame), ExceptionSystemFatalError, function, ( stage == _e4c_beginning ? "e4c_frame_repeat: " DESC_CANNOT_REACQUIRE : "e4c_frame_repeat: " DESC_CANNOT_RETRY ), file, line, RETURN_VOID);

    /* check if "uncatchable" exception */
    if(frame->uncaught && frame->thrown_exception.super == NULL){
        return;
    }

    /* check if maximum number of attempts reached and update the number of attempts */
    if(stage == _e4c_acquiring){
        /* retry */
        if(frame->retry_attempts >= max_repeat_attempts){
            return;
        }
        frame->retry_attempts++;
    }else if(stage == _e4c_beginning){
        /* reacquire */
        if(frame->reacquire_attempts >= max_repeat_attempts){
            return;
        }
        frame->reacquire_attempts++;
    }else{
        FATAL_ERROR(ExceptionSystemFatalError, function, "e4c_frame_repeat: " DESC_CANNOT_REPEAT, file, line, RETURN_VOID);
    }

    /* reset the exception information */
    frame->thrown           = e4c_false;
    frame->uncaught         = e4c_false;
    frame->thrown_exception = null_exception;
    frame->stage            = stage;

    /* keep looping */
    _E4C_LONGJMP(frame->address);
}

void e4c_throw_exception(const e4c_exception * exception, const char * file, int line, const char * function, e4c_bool verbatim, const char * message, ...){

# if defined(HAVE_C99_VSNPRINTF) || defined(HAVE_VSNPRINTF)
    /* we will only format the message if we can rely on vsnprintf */
    char                formatted_message[E4C_EXCEPTION_MESSAGE_SIZE];
# endif

    int                 error_number;
    e4c_context *       context;
    e4c_frame *         frame;
    e4c_exception *     cause;
    e4c_exception       new_exception;

    /* store the current error number up front */
    error_number = errno;

    /* get the current context */
    context = E4C_CONTEXT;

    /* check if 'throw' was used before calling e4c_context_begin */
    PREVENT_MISUSE(context == NULL, ContextHasNotBegunYet, function, "e4c_throw_exception: " DESC_NOT_BEGUN_YET, file, line, RETURN_VOID);

    /* get the current frame */
    frame = context->current_frame;

    /* check if the current frame is NULL (unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_throw_exception", DESC_INVALID_FRAME, RETURN_VOID);

    /* get the cause of this exception */
    cause = ( frame->thrown ? malloc( sizeof(*cause) ) : NULL );
    /* (if there wasn't enough memory the cause will be lost) */

    /* copy the previous thrown exception in the newly allocated buffer */
    if(cause != NULL){
        *cause = frame->thrown_exception;
    }

    /* convert NULL exceptions to NPE */
    if(exception == NULL){
        exception = &NullPointerException;
    }

    if(!verbatim){
# if defined(HAVE_C99_VSNPRINTF) || defined(HAVE_VSNPRINTF)
        va_list     arguments_list;
        int         printed;
        va_start(arguments_list, message);
        printed = vsnprintf(formatted_message, E4C_EXCEPTION_MESSAGE_SIZE, message, arguments_list);
        va_end(arguments_list);
        if(printed > 0) message = formatted_message;
# else
        /* if vsnprintf is absent, the message will be copied verbatim anyway */
        (void)0;
# endif
    }

    /* "instantiate" the specified exception */
    new_exception = _e4c_new_exception(exception, message, file, line, function, error_number, cause);

    _e4c_propagate(context, &new_exception);
}

void e4c_print_exception(const e4c_exception * exception){

# ifndef NDEBUG
    const e4c_exception * cause;
# endif

    if(exception == NULL){
        e4c_throw_exception(NullPointerException.type, _E4C_FILE_INFO, _E4C_LINE_INFO, "e4c_print_exception", e4c_true, "Null exception.");
    }

# ifndef NDEBUG

    fprintf(stderr, "\n\nUncaught %s: %s\n\n", exception->name, exception->message);

    if(exception->file != NULL){
        if(exception->function != NULL){
            fprintf(stderr, "    thrown at %s (%s:%d)\n\n", exception->function, exception->file, exception->line);
        }else{
            fprintf(stderr, "    thrown at %s:%d\n\n", exception->file, exception->line);
        }
    }

    cause = exception->cause;
    while(cause != NULL){
        fprintf(stderr, "Caused by %s: %s\n\n", cause->name, cause->message);
        if(cause->file != NULL){
            if(cause->function != NULL){
                fprintf(stderr, "    thrown at %s (%s:%d)\n\n", cause->function, cause->file, cause->line);
            }else{
                fprintf(stderr, "    thrown at %s:%d\n\n", cause->file, cause->line);
            }
        }
        cause = cause->cause;
    }

    fprintf(stderr, "The value of errno was %d.\n\n", exception->error_number);

    if(exception->super != NULL){
        _e4c_print_exception_hierarchy(exception);
    }

# else

    fprintf(stderr, "\n\nFatal Error: %s (%s)\n\n", exception->name, exception->message);

# endif

}

void e4c_context_set_signal_mappings(const e4c_signal_mapping * mappings){

    e4c_context * context;

    context = E4C_CONTEXT;

    /* check if e4c_context_set_signal_mappings was called before calling e4c_context_begin */
    PREVENT(context == NULL, ContextHasNotBegunYet, "e4c_context_set_signal_mappings", NULL, RETURN_VOID);

    _e4c_set_signal_handlers(context, mappings);
}

const e4c_signal_mapping * e4c_context_get_signal_mappings(void){

    e4c_context * context;

    context = E4C_CONTEXT;

    /* check if e4c_context_get_signal_mappings was called before calling e4c_context_begin */
    PREVENT(context == NULL, ContextHasNotBegunYet, "e4c_context_get_signal_mappings", NULL, NULL);

    return(context->signal_mappings);
}

const e4c_exception * e4c_get_exception(void){

    e4c_context *   context;
    e4c_frame *     frame;

    context = E4C_CONTEXT;

    /* check if 'e4c_get_exception' was called before calling e4c_context_begin */
    PREVENT(context == NULL, ContextHasNotBegunYet, "e4c_get_exception", NULL, NULL);

    frame = context->current_frame;

    /* check if the current frame is NULL (very unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_get_exception", DESC_INVALID_FRAME, NULL);

    return(frame->thrown ? (const e4c_exception *)&frame->thrown_exception : NULL);
}

void e4c_context_begin(e4c_bool handle_signals, e4c_uncaught_handler uncaught_handler){

    e4c_context *       context;
    e4c_frame *         new_frame;

# ifdef E4C_THREADSAFE

    e4c_environment *   environment;

    INITIALIZE_ONCE;

    /* get the current environment */
    environment = _e4c_get_environment();

    /* check if e4c_context_begin was called twice for this thread */
    PREVENT(environment != NULL, ContextAlreadyBegun, "e4c_context_begin", NULL, RETURN_VOID);

    /* allocate memory for the new frame */
    environment = malloc( sizeof(*environment) );

    /* check if there wasn't enough memory */
    PREVENT(environment == NULL, NotEnoughMemoryException, "e4c_context_begin", DESC_MALLOC_CONTEXT, RETURN_VOID);

    /* allocate memory for the new frame */
    new_frame = malloc( sizeof(*new_frame) );

    /* check if there wasn't enough memory */
    if(new_frame == NULL){
        free(environment);
        FATAL_ERROR(NotEnoughMemoryException, "e4c_context_begin", DESC_MALLOC_FRAME, __FILE__, __LINE__, RETURN_VOID);
    }

    /* add the new environment to the collection */
    _e4c_add_environment(environment);

    /* bound the new environment to the current thread */
    environment->self = THREAD_CURRENT;;

    /* update local variable */
    context = &environment->context;

# else

    INITIALIZE_ONCE;

    /* get the current context */
    context = current_context;

    /* check if e4c_context_begin was called twice for this program */
    /* this can also happen when the program uses threads but E4C_THREADSAFE is not defined */
    PREVENT(context != NULL, ContextAlreadyBegun, "e4c_context_begin", NULL, RETURN_VOID);

    /* update local and global variable */
    context = current_context = &mainContext;

    /* allocate memory for the new frame */
    new_frame = malloc( sizeof(*new_frame) );

    /* check if there wasn't enough memory */
    PREVENT(new_frame == NULL, NotEnoughMemoryException, "e4c_context_begin", DESC_MALLOC_FRAME, RETURN_VOID);

# endif

    context->uncaught_handler   = uncaught_handler;
    context->signal_mappings    = NULL;
    context->current_frame      = new_frame;

    *new_frame = _e4c_new_frame(NULL, _e4c_done);

    if(handle_signals) _e4c_set_signal_handlers(context, e4c_default_signal_mappings);
}

void e4c_context_end(void){

    e4c_context *       context;
    e4c_frame *         frame;

# ifdef E4C_THREADSAFE

    e4c_environment *   environment;

    /* remove (and get) the current context */
    environment = _e4c_remove_environment();

    /* check if e4c_context_end was called before calling e4c_context_begin */
    PREVENT(environment == NULL, ContextHasNotBegunYet, "e4c_context_end", NULL, RETURN_VOID);

    /* update local variable */
    context = &environment->context;

    /* check if the current context is NULL (unlikely) */
    DEBUG_PREVENT(context == NULL, "e4c_context_end", DESC_INVALID_CONTEXT, RETURN_VOID);

# else

    /* get the current context */
    context = current_context;

    /* check if e4c_context_end was called before calling e4c_context_begin */
    PREVENT(context == NULL, ContextHasNotBegunYet, "e4c_context_end", NULL, RETURN_VOID);

# endif

    /* get the current frame */
    frame = context->current_frame;

    /* check if there are no frames left (unlikely) */
    DEBUG_PREVENT(frame == NULL, "e4c_context_end", DESC_NO_FRAMES_LEFT, RETURN_VOID);

    /* check if there are too many frames left (breaking out of a try block) */
    PREVENT(!IS_TOP_FRAME(frame), ExceptionSystemFatalError, "e4c_context_end", DESC_TOO_MANY_FRAMES, RETURN_VOID);

    /* deallocate the current, top frame */
    _e4c_delete_frame(frame);

    /* reset all signal handlers */
    _e4c_set_signal_handlers(context, NULL);

# ifdef E4C_THREADSAFE

    /* deallocate the thread environment */
    free(environment);

# else

    /* deactivate the current context */
    current_context             = NULL;

    /* deactivate the top frame (for sanity) */
    mainContext.current_frame   = NULL;

# endif

}



# ifndef NDEBUG
static E4C_INLINE void _e4c_print_exception_hierarchy(const e4c_exception * exception){

    const char *            separator   = "________________________________________________________________";
    int                     deep        = 0;
    const e4c_exception *   super;

    /* assert: exception != NULL */
    /* assert: exception->super != NULL */

    fprintf(stderr, "Exception hierarchy\n%s\n\n   %s\n", separator, exception->name);

    super = exception->super;

    while(super != NULL && exception->name != super->name){
        fprintf(stderr, "    %*s |\n    %*s +-- %s\n", deep * 6, "", deep * 6, "", super->name);
        deep++;
        exception   = super;
        super       = (exception->super == NULL ? NULL : exception->super);
    }
    fprintf(stderr, "%s\n", separator);
}
# endif

static E4C_INLINE void _e4c_fatal_error(const e4c_exception * prototype, const char * message, const char * file, int line, const char * function, int error_number, const e4c_exception * cause){

    const e4c_exception exception = _e4c_new_exception(prototype, message, file, line, function, error_number, cause);

    INITIALIZE_ONCE;

    fatal_error_flag = e4c_true;

    e4c_print_exception(&exception);

    fprintf(stderr, MSG_FATAL_ERROR);

    STOP_EXECUTION;
}

static E4C_INLINE e4c_frame _e4c_new_frame(e4c_frame * previous, e4c_stage stage){

    e4c_frame               frame;
    const e4c_exception     null_exception = NULL_EXCEPTION_LITERAL;

    frame.previous              = previous;
    frame.stage                 = stage;
    frame.thrown                = e4c_false;
    frame.uncaught              = e4c_false;
    frame.reacquire_attempts    = 0;
    frame.retry_attempts        = 0;
    frame.thrown_exception      = null_exception;

    /* frame.address is an implementation-defined type */

    return(frame);
}

static E4C_INLINE void _e4c_delete_frame(e4c_frame * frame){

    const e4c_exception * cause;

    /* delete the dynamically-allocated causes of the thrown exception (if any) */
    cause = frame->thrown_exception.cause;
    while(cause != NULL){
        const e4c_exception * next = cause->cause;
        free( (e4c_exception *)cause );
        cause = next;
    }

    free(frame);
}

static E4C_INLINE e4c_exception _e4c_new_exception(const e4c_exception * prototype, const char * message, const char * file, int line, const char * function, int error_number, const e4c_exception * cause){

    /* assert: prototype != NULL */

    e4c_exception exception;

    exception.name          = prototype->name;

    (void)sprintf(exception.message, "%.*s", (int)sizeof(exception.message) - 1, message != NULL ? message : prototype->message);

    exception.super         = prototype->super;
    exception.file          = file;
    exception.line          = line;
    exception.function      = function;
    exception.error_number  = error_number;
    exception.type          = prototype->type;
    exception.cause         = cause;

    return(exception);
}

static void _e4c_at_uncaught_exception(e4c_context * context){

    /*assert: context != NULL */

    e4c_uncaught_handler handler;

    handler = context->uncaught_handler;

    if(handler != NULL){
        handler( (const e4c_exception *)&context->current_frame->thrown_exception);
    }

    e4c_context_end();

    STOP_EXECUTION;
}

static void _e4c_propagate(e4c_context * context, const e4c_exception * exception){

    /* assert: exception != NULL */
    /* assert: context != NULL */
    /* assert: context->current_frame != NULL */

    e4c_frame * frame;

    frame = context->current_frame;

    /* update the frame with the exception information */
    frame->thrown           = e4c_true;
    frame->uncaught         = e4c_true;
    frame->thrown_exception = *exception;

    /* if this is the upper frame, then this is an uncaught exception */
    if( IS_TOP_FRAME(frame) ) _e4c_at_uncaught_exception(context);

    /* otherwise, we will jump to the upper frame */

    /* simple optimization */
    if(frame->stage == _e4c_acquiring){
        /* if we are in the middle of an acquisition, we don't need to dispose the resource */
        frame->stage = _e4c_disposing;
        /* (that actually jumps over the "disposing" stage) */
    }

    /* keep looping */
    _E4C_LONGJMP(frame->address);
}

static void e4c_handle_signal(int signal_number){

    e4c_context *               context;
    const e4c_signal_mapping *  mapping;
    e4c_exception               new_exception;

    context = E4C_CONTEXT;

    /* check if 'handleSignal' was called before e4c_context_begin or after e4c_context_end (very unlikely) */
    DEBUG_PREVENT(context == NULL, "e4c_handle_signal", DESC_INVALID_CONTEXT, RETURN_VOID);

    /* check if the current frame is NULL (very unlikely) */
    DEBUG_PREVENT(context->current_frame == NULL, "e4c_handle_signal", DESC_INVALID_FRAME, RETURN_VOID);

    if(context->signal_mappings != NULL){
        /* try to find a mapping for this signal */
        mapping = context->signal_mappings;
        /* loop until we find the NULL terminator */
        while(mapping->exception != NULL){
            if(signal_number == mapping->signal_number){
                const char * signal_name;
                switch(signal_number){
                    WHEN_SIGNAL(SIGABRT)
                    WHEN_SIGNAL(SIGFPE)
                    WHEN_SIGNAL(SIGILL)
                    WHEN_SIGNAL(SIGSEGV)
                    WHEN_SIGNAL(SIGTERM)
                    WHEN_SIGNAL(SIGINT)
                    WHEN_SIGNAL_SIGALRM
                    WHEN_SIGNAL_SIGCHLD
                    WHEN_SIGNAL_SIGTRAP
                    WHEN_SIGNAL_SIGPIPE
                    WHEN_SIGNAL_SIGSTOP
                    WHEN_SIGNAL_SIGKILL
                    WHEN_SIGNAL_SIGHUP
                    WHEN_SIGNAL_SIGXCPU
                    WHEN_SIGNAL_SIGQUIT
                    WHEN_SIGNAL_SIGBREAK
                    WHEN_SIGNAL_SIGUSR1
                    WHEN_SIGNAL_SIGUSR2
                    default:
                        signal_name = signal_name_UNKNOWN;
                        break;
                }
                /* reset the handler for this signal */
                signal(signal_number, e4c_handle_signal);

                /* throw the appropriate exception to the current context */

                new_exception = _e4c_new_exception(mapping->exception, NULL, signal_name, signal_number, "e4c_handle_signal", errno, NULL);
                _e4c_propagate(context, &new_exception);
            }
            mapping++;
        }
    }
    /* this should never happen, but anyway... */
    /* we were unable to find the exception that represents the received signal number */
    new_exception = _e4c_new_exception(&ExceptionSystemFatalError, "e4c_handle_signal: " DESC_NO_MAPPING, _E4C_FILE_INFO, _E4C_LINE_INFO, "e4c_handle_signal", errno, NULL);
    _e4c_propagate(context, &new_exception);
}

static void _e4c_set_signal_handlers(e4c_context * context, const e4c_signal_mapping * mappings){

    /* assert: context != NULL */

    const e4c_signal_mapping * next_mapping;

    if(context->signal_mappings != NULL){
        next_mapping = context->signal_mappings;
        /* reset all the previously set signal handlers */
        while(next_mapping->exception != NULL){
            signal(next_mapping->signal_number, SIG_DFL);
            next_mapping++;
        }
    }

    if(mappings == NULL){
        /* disable signal handling */
        context->signal_mappings = NULL;
        return;
    }

    /* set up signal mapping */
    context->signal_mappings = next_mapping = mappings;

    while(next_mapping->exception != NULL){
        signal(next_mapping->signal_number, e4c_handle_signal);
        next_mapping++;
    }

}

static E4C_INLINE e4c_bool _e4c_extends(const e4c_exception * child, const e4c_exception * parent){

    /* assert: child != NULL */
    /* assert: parent != NULL */

    if(child == parent){
        return(e4c_true);
    }

    /* If the exception is "its own parent" (the root of the hierarchy) or if it
        has "no parent" whatsoever, then we can determine that it does not
        extend the specified "parent"
    */
    if(child->super == child || child->super == NULL){
        return(e4c_false);
    }

    /* otherwise, we will keep looking for a common ancestor */
    return( _e4c_extends(child->super, parent) );
}

static void e4c_at_exit(void){

    if(DANGLING_CONTEXT){
        const e4c_exception exception = _e4c_new_exception(&ContextNotEnded, DESC_NOT_ENDED, _E4C_FILE_INFO, _E4C_LINE_INFO, "e4c_at_exit", errno, NULL);
        e4c_print_exception(&exception);
        fatal_error_flag = e4c_true;
    }

    if(fatal_error_flag){
        fprintf(stderr, MSG_AT_EXIT_ERROR);
        /* force failure exit status */
        exit(EXIT_FAILURE);
    }

}

static void _e4c_initialize(void){

    MUTEX_LOCK(is_initialized_mutex);

        if(!is_initialized){
            is_initialized = (atexit(e4c_at_exit) == 0 ? e4c_true : e4c_false);
        }

    MUTEX_UNLOCK(is_initialized_mutex);
}

# ifdef E4C_THREADSAFE

static void _e4c_add_environment(e4c_environment * environment){

    /* assert: environment != NULL */

    MUTEX_LOCK(environment_collection_mutex);

        environment->next       = environment_collection;
        environment_collection  = environment;

    MUTEX_UNLOCK(environment_collection_mutex);
}

static e4c_environment * _e4c_remove_environment(void){

    THREAD_TYPE         self        = THREAD_CURRENT;
    e4c_bool            found       = e4c_false;
    e4c_environment *   previous    = NULL;
    e4c_environment *   environment;

    MUTEX_LOCK(environment_collection_mutex);

        environment = environment_collection;

        while(environment != NULL){
            if( THREAD_SAME(self, environment->self) ){
                found = e4c_true;
                break;
            }
            previous    = environment;
            environment = environment->next;
        }

        if(found){
            if(previous == NULL)    environment_collection  = environment->next;
            else                    previous->next          = environment->next;
        }

    MUTEX_UNLOCK(environment_collection_mutex);

    return(found ? environment : NULL);
}

static e4c_environment * _e4c_get_environment(void){

    THREAD_TYPE         self        = THREAD_CURRENT;
    e4c_bool            found       = e4c_false;
    e4c_environment *   environment;

    MUTEX_LOCK(environment_collection_mutex);

        environment = environment_collection;

        while(environment != NULL){
            if( THREAD_SAME(self, environment->self) ){
                found = e4c_true;
                break;
            }
            environment = environment->next;
        }

    MUTEX_UNLOCK(environment_collection_mutex);

    return(found ? environment : NULL);
}

static E4C_INLINE e4c_context * _e4c_get_context(void){

    e4c_environment * environment = _e4c_get_environment();

    return(environment == NULL ? NULL : &environment->context);
}

# endif
