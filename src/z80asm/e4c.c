/*
 *
 * @file                e4c.c
 *
 * exceptions4c source code file
 *
 * @version             2.8
 * @author              Copyright (c) 2011 Guillermo Calvo
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
#       define E4C_INLINE
# elif defined(_ISOC99_SOURCE) \
        || defined(_GNU_SOURCE) \
        || ( defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) )
#       define E4C_INLINE inline
# elif ( defined(__GNUC__) && (__GNUC__ >= 2) )
#       define E4C_INLINE __extension__ inline
# else
#       define E4C_INLINE
# endif

# if defined(HAVE_POSIX_SIGSETJMP) || defined(HAVE_SIGSETJMP)
#       define E4C_CONTINUE(continuation)       siglongjmp(continuation.buffer, 1)
# else
#       define E4C_CONTINUE(continuation)       longjmp(continuation.buffer, 1)
# endif

# define IS_TOP_FRAME(frame)                    ( frame->previous == NULL )

# define IS_UNCATCHABLE(exception)              (exception->type == NULL || exception->type == &AssertionException)

# define INITIALIZE_ONCE                                if(!is_initialized){ _e4c_library_initialize(); }

# define FOREACH(element, list)                 for(element = list.first; element != NULL; element = element->next)

# if    defined(HAVE_C99_SNPRINTF) \
        ||      defined(HAVE_SNPRINTF) \
        ||      defined(S_SPLINT_S)
#       define VERBATIM_COPY(dst, src) (void)snprintf(dst, (size_t)E4C_EXCEPTION_MESSAGE_SIZE, "%s", src)
# else
#       define VERBATIM_COPY(dst, src) (void)sprintf(dst, "%.*s", (int)E4C_EXCEPTION_MESSAGE_SIZE - 1, src)
# endif

# define DESC_MALLOC_EXCEPTION          "Could not create a new exception."
# define DESC_MALLOC_FRAME                      "Could not create a new exception frame."
# define DESC_MALLOC_CONTEXT            "Could not create a new exception context."
# define DESC_CATCH_NULL                        "A NULL argument was passed."
# define DESC_CANNOT_REACQUIRE          "There is no E4C_WITH block to reacquire."
# define DESC_CANNOT_RETRY                      "There is no E4C_TRY block to retry."
# define DESC_CANNOT_REPEAT                     "The specified stage can't be repeated."
# define DESC_TOO_MANY_FRAMES           "There are too many exception frames. Probably some try{...} block was exited through 'return' or 'break'."
# define DESC_NO_FRAMES_LEFT            "There are no exception frames left."
# define DESC_INVALID_FRAME                     "The exception context has an invalid frame."
# define DESC_INVALID_CONTEXT           "The exception context is invalid."
# define DESC_NO_MAPPING                        "There is no exception mapping for the received signal."
# define DESC_SIGERR_HANDLE                     "Could not register the signal handling procedure."
# define DESC_SIGERR_DEFAULT            "Could not reset the default signal handling."
# define DESC_SIGERR_IGNORE                     "Could not ignore the signal."

# ifdef E4C_THREADSAFE
#       include <pthread.h>
#       define E4C_CONTEXT                              _e4c_context_get_current()
#       define DESC_INVALID_STATE               "The exception context for this thread is in an invalid state."
#       define DESC_ALREADY_BEGUN               "The exception context for this thread has already begun."
#       define DESC_NOT_BEGUN_YET               "The exception context for this thread has not begun yet."
#       define DESC_NOT_ENDED                   "There is at least one thread that did not end its exception context properly."
#       define DESC_LOCK_ERROR                  "Synchronization error (could not acquire lock)."
#       define DESC_UNLOCK_ERROR                "Synchronization error (could not release lock)."
#       define MSG_FATAL_ERROR                  "\n\nThis is an unrecoverable programming error; the thread will be terminated\nimmediately.\n"
#       define MSG_AT_EXIT_ERROR                "\n\nThe program will now yield a failure exit code due to exception system errors.\n"
#       define THREAD_TYPE                              pthread_t
#       define THREAD_CURRENT                   pthread_self()
#       define THREAD_SAME(t1, t2)              ( pthread_equal(t1, t2) != 0 )
#       define THREAD_EXIT                              pthread_exit
#       define MUTEX_DEFINE(mutex)              static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
#       define MUTEX_LOCK(mutex, function) \
    if(pthread_mutex_lock(&mutex) != 0){ \
        _e4c_library_fatal_error(&ExceptionSystemFatalError, DESC_LOCK_ERROR, __FILE__, __LINE__, function, errno); \
    }
#       define MUTEX_UNLOCK(mutex, function) \
    if(pthread_mutex_unlock(&mutex) != 0){ \
        _e4c_library_fatal_error(&ExceptionSystemFatalError, DESC_UNLOCK_ERROR, __FILE__, __LINE__, function, errno); \
    }
#       define STOP_EXECUTION                   THREAD_EXIT(PTHREAD_CANCELED)
#       define DANGLING_CONTEXT                 (environment_collection.first != NULL)
# else
#       define E4C_CONTEXT                              current_context
#       define DESC_INVALID_STATE               "The exception context for this program is in an invalid state."
#       define DESC_ALREADY_BEGUN               "The exception context for this program has already begun."
#       define DESC_NOT_BEGUN_YET               "The exception context for this program has not begun yet."
#       define DESC_NOT_ENDED                   "The program did not end its exception context properly."
#       define MSG_FATAL_ERROR                  "\n\nThis is an unrecoverable programming error; the application will be terminated\nimmediately.\n"
#       define MSG_AT_EXIT_ERROR                "\n\nIf this application is making use of threads, please recompile exceptions4c\nwith thread support (by defining the macro E4C_THREADSAFE).\n\n\nThe program will now yield a failure exit code due to exception system errors.\n"
#       define MUTEX_DEFINE(mutex)
#       define MUTEX_LOCK(mutex, function)
#       define MUTEX_UNLOCK(mutex, function)
#       define STOP_EXECUTION                   exit(EXIT_FAILURE)
#       define DANGLING_CONTEXT                 (current_context != NULL)
# endif

# define MISUSE_ERROR(exception, message, file, line, function) \
    _e4c_library_fatal_error(&exception, message, file, line, function, errno);

# define INTERNAL_ERROR(message, function) \
    _e4c_library_fatal_error(&ExceptionSystemFatalError, message, __FILE__, __LINE__, function, errno);

# define MEMORY_ERROR(message, line, function) \
    _e4c_library_fatal_error(&NotEnoughMemoryException, message, __FILE__, line, function, errno);

# ifndef NDEBUG
#       define PREVENT_FUNC(condition, message, function, unreachable_return_value) \
    if(condition){ \
        INTERNAL_ERROR(message, function); \
        E4C_UNREACHABLE_RETURN(unreachable_return_value); \
    }
#       define PREVENT_PROC(condition, message, function) \
    if(condition){ \
        INTERNAL_ERROR(message, function); \
    }
# else
#       define PREVENT_FUNC(condition, message, function, unreachable_return_value)
#       define PREVENT_PROC(condition, message, function)
# endif

# define WHEN_SIGNAL(signal_id) \
    case signal_id: \
    signal_name = signal_name_##signal_id; \
    /*@switchbreak@*/ break;

# define DEFINE_SIGNAL_NAME(signal_id) \
    /*@unchecked@*/ /*@observer@*/ \
    static const char * signal_name_##signal_id = #signal_id

# ifdef SIGALRM
#       define DEFINE_SIGNAL_NAME_SIGALRM                       DEFINE_SIGNAL_NAME(SIGALRM);
#       define WHEN_SIGNAL_SIGALRM                                      WHEN_SIGNAL(SIGALRM)
#       define E4C_SIGNAL_MAPPING_SIGALRM                       E4C_SIGNAL_MAPPING(SIGALRM,             SignalAlarmException),
# else
#       define DEFINE_SIGNAL_NAME_SIGALRM
#       define WHEN_SIGNAL_SIGALRM
#       define E4C_SIGNAL_MAPPING_SIGALRM
# endif

# ifdef SIGCHLD
#       define DEFINE_SIGNAL_NAME_SIGCHLD                       DEFINE_SIGNAL_NAME(SIGCHLD);
#       define WHEN_SIGNAL_SIGCHLD                                      WHEN_SIGNAL(SIGCHLD)
#       define E4C_SIGNAL_MAPPING_SIGCHLD                       E4C_SIGNAL_MAPPING(SIGCHLD,             SignalChildException),
# else
#       define DEFINE_SIGNAL_NAME_SIGCHLD
#       define WHEN_SIGNAL_SIGCHLD
#       define E4C_SIGNAL_MAPPING_SIGCHLD
# endif

# ifdef SIGTRAP
#       define DEFINE_SIGNAL_NAME_SIGTRAP                       DEFINE_SIGNAL_NAME(SIGTRAP);
#       define WHEN_SIGNAL_SIGTRAP                                      WHEN_SIGNAL(SIGTRAP)
#       define E4C_SIGNAL_MAPPING_SIGTRAP                       E4C_SIGNAL_MAPPING(SIGTRAP,             SignalTrapException),
# else
#       define DEFINE_SIGNAL_NAME_SIGTRAP
#       define WHEN_SIGNAL_SIGTRAP
#       define E4C_SIGNAL_MAPPING_SIGTRAP
# endif

# ifdef SIGPIPE
#       define DEFINE_SIGNAL_NAME_SIGPIPE                       DEFINE_SIGNAL_NAME(SIGPIPE);
#       define WHEN_SIGNAL_SIGPIPE                                      WHEN_SIGNAL(SIGPIPE)
#       define E4C_SIGNAL_MAPPING_SIGPIPE                       E4C_SIGNAL_MAPPING(SIGPIPE,             BrokenPipeException),
# else
#       define DEFINE_SIGNAL_NAME_SIGPIPE
#       define WHEN_SIGNAL_SIGPIPE
#       define E4C_SIGNAL_MAPPING_SIGPIPE
# endif

/* unless otherwise stated, SIGSTOP and SIGKILL cannot be caught or ignored */

/*
 * The E4C_CAN_HANDLE_SIGSTOP compile-time parameter
 * could be defined in order to try to map signal SIGSTOP to StopException.
 */
# ifdef SIGSTOP
#       define DEFINE_SIGNAL_NAME_SIGSTOP                       DEFINE_SIGNAL_NAME(SIGSTOP);
#       define WHEN_SIGNAL_SIGSTOP                                      WHEN_SIGNAL(SIGSTOP)
#       ifdef E4C_CAN_HANDLE_SIGSTOP
#               define E4C_SIGNAL_MAPPING_SIGSTOP               E4C_SIGNAL_MAPPING(SIGSTOP,             StopException),
#       else
#               define E4C_SIGNAL_MAPPING_SIGSTOP
#       endif
# else
#       define DEFINE_SIGNAL_NAME_SIGSTOP
#       define WHEN_SIGNAL_SIGSTOP
#       define E4C_SIGNAL_MAPPING_SIGSTOP
# endif

/*
 * The E4C_CAN_HANDLE_SIGKILL compile-time parameter
 * could be defined in order to try to map signal SIGKILL to KillException.
 */
# ifdef SIGKILL
#       define DEFINE_SIGNAL_NAME_SIGKILL                       DEFINE_SIGNAL_NAME(SIGKILL);
#       define WHEN_SIGNAL_SIGKILL                                      WHEN_SIGNAL(SIGKILL)
#       ifdef E4C_CAN_HANDLE_SIGKILL
#               define E4C_SIGNAL_MAPPING_SIGKILL               E4C_SIGNAL_MAPPING(SIGKILL,             KillException),
#       else
#               define E4C_SIGNAL_MAPPING_SIGKILL
#       endif
# else
#       define DEFINE_SIGNAL_NAME_SIGKILL
#       define WHEN_SIGNAL_SIGKILL
#       define E4C_SIGNAL_MAPPING_SIGKILL
# endif

# ifdef SIGHUP
#       define DEFINE_SIGNAL_NAME_SIGHUP                        DEFINE_SIGNAL_NAME(SIGHUP);
#       define WHEN_SIGNAL_SIGHUP                                       WHEN_SIGNAL(SIGHUP)
#       define E4C_SIGNAL_MAPPING_SIGHUP                        E4C_SIGNAL_MAPPING(SIGHUP,              HangUpException),
# else
#       define DEFINE_SIGNAL_NAME_SIGHUP
#       define WHEN_SIGNAL_SIGHUP
#       define E4C_SIGNAL_MAPPING_SIGHUP
# endif

# ifdef SIGXCPU
#       define DEFINE_SIGNAL_NAME_SIGXCPU                       DEFINE_SIGNAL_NAME(SIGXCPU);
#       define WHEN_SIGNAL_SIGXCPU                                      WHEN_SIGNAL(SIGXCPU)
#       define E4C_SIGNAL_MAPPING_SIGXCPU                       E4C_SIGNAL_MAPPING(SIGXCPU,             CPUTimeException),
# else
#       define DEFINE_SIGNAL_NAME_SIGXCPU
#       define WHEN_SIGNAL_SIGXCPU
#       define E4C_SIGNAL_MAPPING_SIGXCPU
# endif

# ifdef SIGQUIT
#       define DEFINE_SIGNAL_NAME_SIGQUIT                       DEFINE_SIGNAL_NAME(SIGQUIT);
#       define WHEN_SIGNAL_SIGQUIT                                      WHEN_SIGNAL(SIGQUIT)
#       define E4C_SIGNAL_MAPPING_SIGQUIT                       E4C_SIGNAL_MAPPING(SIGQUIT,             UserQuitException),
# else
#       define DEFINE_SIGNAL_NAME_SIGQUIT
#       define WHEN_SIGNAL_SIGQUIT
#       define E4C_SIGNAL_MAPPING_SIGQUIT
# endif

# ifdef SIGBREAK
#       define DEFINE_SIGNAL_NAME_SIGBREAK                      DEFINE_SIGNAL_NAME(SIGBREAK);
#       define WHEN_SIGNAL_SIGBREAK                                     WHEN_SIGNAL(SIGBREAK)
#       define E4C_SIGNAL_MAPPING_SIGBREAK                      E4C_SIGNAL_MAPPING(SIGBREAK,    UserBreakException),
# else
#       define DEFINE_SIGNAL_NAME_SIGBREAK
#       define WHEN_SIGNAL_SIGBREAK
#       define E4C_SIGNAL_MAPPING_SIGBREAK
# endif

# ifdef SIGUSR1
#       define DEFINE_SIGNAL_NAME_SIGUSR1                       DEFINE_SIGNAL_NAME(SIGUSR1);
#       define WHEN_SIGNAL_SIGUSR1                                      WHEN_SIGNAL(SIGUSR1)
#       define E4C_SIGNAL_MAPPING_SIGUSR1                       E4C_SIGNAL_MAPPING(SIGUSR1,             ProgramSignal1Exception),
# else
#       define DEFINE_SIGNAL_NAME_SIGUSR1
#       define WHEN_SIGNAL_SIGUSR1
#       define E4C_SIGNAL_MAPPING_SIGUSR1
# endif

# ifdef SIGUSR2
#       define DEFINE_SIGNAL_NAME_SIGUSR2                       DEFINE_SIGNAL_NAME(SIGUSR2);
#       define WHEN_SIGNAL_SIGUSR2                                      WHEN_SIGNAL(SIGUSR2)
#       define E4C_SIGNAL_MAPPING_SIGUSR2                       E4C_SIGNAL_MAPPING(SIGUSR2,             ProgramSignal2Exception),
# else
#       define DEFINE_SIGNAL_NAME_SIGUSR2
#       define WHEN_SIGNAL_SIGUSR2
#       define E4C_SIGNAL_MAPPING_SIGUSR2
# endif




typedef void ( *signal_handler )( int );

typedef enum e4c_frame_stage_ e4c_frame_stage;

typedef struct e4c_continuation_ e4c_continuation;

typedef struct e4c_frame_ e4c_frame;
struct e4c_frame_
{
    /*@only@*/ /*@null@*/
    e4c_frame                                      *previous;
    e4c_frame_stage                         stage;
    E4C_BOOL                                        uncaught;
    /*@only@*/ /*@null@*/
    e4c_exception                          *thrown_exception;
    int                                                     retry_attempts;
    int                                                     reacquire_attempts;
    e4c_continuation                        continuation;
};

typedef struct e4c_context_ e4c_context;
struct e4c_context_
{
    /*@only@*/ /*@null@*/
    e4c_frame                                      *current_frame;
    /*@dependent@*/ /*@null@*/
    const e4c_signal_mapping       *signal_mappings;
    /*@shared@*/ /*@null@*/
    e4c_uncaught_handler            uncaught_handler;
};

# ifdef E4C_THREADSAFE

typedef struct e4c_environment_ e4c_environment;
struct e4c_environment_
{
    THREAD_TYPE                                     self;
    /*@owned@*/ /*@null@*/
    e4c_environment                        *next;
    e4c_context                                     context;
};

typedef struct e4c_environment_collection_ e4c_environment_collection;
struct e4c_environment_collection_
{
    /*@owned@*/ /*@null@*/
    e4c_environment                        *first;
};

# endif




/** flag to signal a critical error in the exception system */
static volatile
E4C_BOOL
fatal_error_flag = E4C_FALSE;

/** flag to determine if the exception system is initialized */
static volatile
E4C_BOOL
is_initialized = E4C_FALSE;

# ifdef E4C_THREADSAFE

/** collection of environments (one per thread) */
static
e4c_environment_collection
environment_collection = { NULL };

/** mutex to control access to global variable is_initialized */
MUTEX_DEFINE( is_initialized_mutex )

/** mutex to control access to global variable environment_collection */
MUTEX_DEFINE( environment_collection_mutex )

# else

/** main exception context of the program */
static
e4c_context
main_context = {NULL, NULL, NULL};

/** pointer to the current exception context */
static
/*@null@*/
e4c_context *
current_context = NULL;

# endif

/** symbolic signal names */
static
/*@unchecked@*/ /*@observer@*/
const char *
signal_name_UNKNOWN = "{unknown signal}";
DEFINE_SIGNAL_NAME( SIGABRT );
DEFINE_SIGNAL_NAME( SIGFPE );
DEFINE_SIGNAL_NAME( SIGILL );
DEFINE_SIGNAL_NAME( SIGSEGV );
DEFINE_SIGNAL_NAME( SIGTERM );
DEFINE_SIGNAL_NAME( SIGINT );
DEFINE_SIGNAL_NAME_SIGALRM
DEFINE_SIGNAL_NAME_SIGCHLD
DEFINE_SIGNAL_NAME_SIGTRAP
DEFINE_SIGNAL_NAME_SIGPIPE
DEFINE_SIGNAL_NAME_SIGSTOP
DEFINE_SIGNAL_NAME_SIGKILL
DEFINE_SIGNAL_NAME_SIGHUP
DEFINE_SIGNAL_NAME_SIGXCPU
DEFINE_SIGNAL_NAME_SIGQUIT
DEFINE_SIGNAL_NAME_SIGBREAK
DEFINE_SIGNAL_NAME_SIGUSR1
DEFINE_SIGNAL_NAME_SIGUSR2

/** default signal mapping */
static const e4c_signal_mapping e4c_default_signal_mappings_array[] =
{
    E4C_SIGNAL_MAPPING( SIGABRT,             AbortException ),
    E4C_SIGNAL_MAPPING( SIGFPE,              ArithmeticException ),
    E4C_SIGNAL_MAPPING( SIGILL,              IllegalInstructionException ),
    E4C_SIGNAL_MAPPING( SIGSEGV,             BadPointerException ),
    E4C_SIGNAL_MAPPING( SIGTERM,             TerminationException ),
    E4C_SIGNAL_MAPPING( SIGINT,              UserInterruptionException ),
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

/** pointer to the default signal mapping */
const e4c_signal_mapping *const e4c_default_signal_mappings = &e4c_default_signal_mappings_array[0];

E4C_DEFINE_EXCEPTION( AssertionException,                                "Assertion failed.",                            AssertionException );

E4C_DEFINE_EXCEPTION( RuntimeException,                                  "Runtime exception.",                           RuntimeException );
E4C_DEFINE_EXCEPTION( NotEnoughMemoryException,                  "Not enough memory.",                           RuntimeException );
E4C_DEFINE_EXCEPTION( FileOpenException,                                 "Couldn't open file.",                          RuntimeException );
E4C_DEFINE_EXCEPTION( IllegalArgumentException,                  "Illegal argument.",                            RuntimeException );

E4C_DEFINE_EXCEPTION( SignalException,                                   "Signal received.",                                     RuntimeException );
E4C_DEFINE_EXCEPTION( SignalAlarmException,                              "Alarm clock signal received.",         SignalException );
E4C_DEFINE_EXCEPTION( SignalChildException,                              "Child process signal received.",       SignalException );
E4C_DEFINE_EXCEPTION( SignalTrapException,                               "Trace trap.",                                          SignalException );
E4C_DEFINE_EXCEPTION( ErrorSignalException,                              "Error signal received.",                       SignalException );
E4C_DEFINE_EXCEPTION( IllegalInstructionException,               "Illegal instruction.",                         ErrorSignalException );
E4C_DEFINE_EXCEPTION( ArithmeticException,                               "Erroneous arithmetic operation.",      ErrorSignalException );
E4C_DEFINE_EXCEPTION( BrokenPipeException,                               "Broken pipe.",                                         ErrorSignalException );
E4C_DEFINE_EXCEPTION( BadPointerException,                               "Segmentation violation.",                      ErrorSignalException );
E4C_DEFINE_EXCEPTION( NullPointerException,                              "Null pointer.",                                        BadPointerException );
E4C_DEFINE_EXCEPTION( ControlSignalException,                    "Control signal received.",                     SignalException );
E4C_DEFINE_EXCEPTION( StopException,                                             "Stop signal received.",                        ControlSignalException );
E4C_DEFINE_EXCEPTION( KillException,                                             "Kill signal received.",                        ControlSignalException );
E4C_DEFINE_EXCEPTION( HangUpException,                                   "Hang up signal received.",                     ControlSignalException );
E4C_DEFINE_EXCEPTION( TerminationException,                              "Termination signal received.",         ControlSignalException );
E4C_DEFINE_EXCEPTION( AbortException,                                    "Abort signal received.",                       ControlSignalException );
E4C_DEFINE_EXCEPTION( CPUTimeException,                                  "Exceeded CPU time.",                           ControlSignalException );
E4C_DEFINE_EXCEPTION( UserControlSignalException,                "User control signal received.",        ControlSignalException );
E4C_DEFINE_EXCEPTION( UserQuitException,                                 "Quit signal received.",                        UserControlSignalException );
E4C_DEFINE_EXCEPTION( UserInterruptionException,                 "Interrupt signal received.",           UserControlSignalException );
E4C_DEFINE_EXCEPTION( UserBreakException,                                "Break signal received.",                       UserControlSignalException );
E4C_DEFINE_EXCEPTION( ProgramSignalException,                    "User-defined signal received.",        SignalException );
E4C_DEFINE_EXCEPTION( ProgramSignal1Exception,                   "User-defined signal 1 received.",      ProgramSignalException );
E4C_DEFINE_EXCEPTION( ProgramSignal2Exception,                   "User-defined signal 2 received.",      ProgramSignalException );

static
E4C_DEFINE_EXCEPTION( ExceptionSystemFatalError,                 DESC_INVALID_STATE,                                     RuntimeException );

static
E4C_DEFINE_EXCEPTION( ContextAlreadyBegun,                               DESC_ALREADY_BEGUN,                                     ExceptionSystemFatalError );

static
E4C_DEFINE_EXCEPTION( ContextHasNotBegunYet,                             DESC_NOT_BEGUN_YET,                                     ExceptionSystemFatalError );

static
E4C_DEFINE_EXCEPTION( ContextNotEnded,                                   DESC_NOT_ENDED,                                         ExceptionSystemFatalError );



/*
 * LIBRARY
 *
 *     PUBLIC
 *         e4c_library_version
 *
 *     PRIVATE
 *         _e4c_library_initialize
 *         _e4c_library_finalize
 *         _e4c_library_handle_signal
 *         _e4c_library_fatal_error
 *
 */

/*@-redecl@*/
long
e4c_library_version(
    void
)
/*@*/
;
/*@=redecl@*/

static
void
_e4c_library_initialize(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        internalState,

        is_initialized
@*/
/*@modifies
        internalState,

        is_initialized
@*/
# endif
;

static /*@maynotreturn@*/
void
_e4c_library_finalize(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        fatal_error_flag,

        ContextNotEnded
@*/
/*@modifies
        fileSystem,

        fatal_error_flag
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,

        ContextNotEnded
@*/
/*@modifies
        fileSystem,

        fatal_error_flag
@*/
# endif
;

static
void
_e4c_library_handle_signal(
    int                                                     signal_number
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError,
        ContextHasNotBegunYet,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
# else
/*@globals
        fileSystem,
        internalState,

        current_context,
        fatal_error_flag,
        is_initialized,

        ExceptionSystemFatalError,
        ContextHasNotBegunYet,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        current_context->current_frame
@*/
# endif
;

static /*@noreturn@*/ E4C_INLINE
void
_e4c_library_fatal_error(
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    /*@observer@*/ /*@temp@*/ /*@null@*/
    const char                             *message,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function,
    int                                                     error_number
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized

@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized
@*/
# endif
;

# ifdef E4C_THREADSAFE

/*
 * ENVIRONMENT
 *
 *     PRIVATE
 *         _e4c_environment_allocate
 *         _e4c_environment_deallocate
 *         _e4c_environment_initialize
 *         _e4c_environment_add
 *         _e4c_environment_remove
 *         _e4c_environment_get_current
 *
 */

static E4C_INLINE
/*@out@*/
e4c_environment *
_e4c_environment_allocate(
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@notnull@*/
    const char                             *function
)
/*@globals
        fileSystem,
        internalState,

        is_initialized,
        is_initialized_mutex,
        fatal_error_flag,

        NotEnoughMemoryException,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
;

static E4C_INLINE
void
_e4c_environment_deallocate(
    /*@only@*/ /*@null@*/
    e4c_environment                        *environment
)
/*@releases
        environment
@*/
/*@modifies
        environment
@*/
;

static E4C_INLINE
void
_e4c_environment_initialize(
    /*@notnull@*/ /*@out@*/
    e4c_environment                        *environment,
    /*@shared@*/ /*@null@*/
    e4c_uncaught_handler            uncaught_handler
)
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        environment
@*/
;

static E4C_INLINE
void
_e4c_environment_add(
    /*@notnull@*/ /*@keep@*/
    e4c_environment                        *environment
)
/*@requires isnull environment->next @*/
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        environment,
        environment->next
@*/
;

static
/*@null@*/ /*@only@*/
e4c_environment *
_e4c_environment_remove(
    void
)
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
;

static
/*@dependent@*/ /*@null@*/
e4c_environment *
_e4c_environment_get_current(
    void
)
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
;

# endif

/*
 * CONTEXT
 *
 *     PUBLIC
 *         e4c_context_begin
 *         e4c_context_end
 *         e4c_context_is_ready
 *         e4c_context_get_signal_mappings
 *         e4c_context_set_signal_mappings
 *
 *     PRIVATE
 *         _e4c_context_initialize
 *         _e4c_context_set_signal_handlers
 *         _e4c_context_at_uncaught_exception
 *         _e4c_context_propagate
 *         _e4c_context_get_current (multi-thread only)
 *
 */

/*@-redecl@*/
void
e4c_context_begin(
    E4C_BOOL                                        handle_signals,
    /*@shared@*/ /*@null@*/
    e4c_uncaught_handler            uncaught_handler
)
# ifdef E4C_THREADSAFE
/*@globals
        e4c_default_signal_mappings,
        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextAlreadyBegun,
        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        environment_collection,
        environment_collection_mutex,
        is_initialized,
        is_initialized_mutex,
        fatal_error_flag
@*/
# else
/*@globals
        current_context,
        e4c_default_signal_mappings,
        fatal_error_flag,
        is_initialized,
        main_context,

        ContextAlreadyBegun,
        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        current_context,
        fatal_error_flag,
        is_initialized,
        main_context
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
void
e4c_context_end(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
E4C_BOOL
e4c_context_is_ready(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        current_context
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
/*@observer@*/ /*@null@*/
const e4c_signal_mapping *
e4c_context_get_signal_mappings(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet
@*/
/*@modifies
        fileSystem,

        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
void
e4c_context_set_signal_mappings(
    /*@in@*/ /*@dependent@*/ /*@null@*/
    const e4c_signal_mapping       *mappings
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        current_context->signal_mappings,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

static E4C_INLINE
void
_e4c_context_initialize(
    /*@out@*/ /*@notnull@*/
    e4c_context                            *context,
    /*@shared@*/ /*@null@*/
    e4c_uncaught_handler            uncaught_handler
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        context
@*/
# else
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        context
@*/
# endif
;

static
void
_e4c_context_set_signal_handlers(
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    e4c_context                            *context,
    /*@in@*/ /*@dependent@*/ /*@null@*/
    const e4c_signal_mapping       *mappings
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        context->signal_mappings
@*/
# else
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        context->signal_mappings
@*/
# endif
;

static
void
_e4c_context_at_uncaught_exception(
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    e4c_context                            *context
)
/*@requires notnull context->current_frame@*/
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,
        internalState,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        current_context,
        fatal_error_flag,
        is_initialized
@*/
# endif
;

static /*@noreturn@*/
void
_e4c_context_propagate(
    /*@in@*/ /*@notnull@*/
    e4c_context                            *context,
    /*@in@*/ /*@only@*/ /*@notnull@*/
    e4c_exception                          *exception
)
/*@requires notnull context->current_frame@*/
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        context->current_frame,
        context->current_frame->thrown_exception
@*/
# else
/*@globals
        fileSystem,
        internalState,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        context->current_frame,
        context->current_frame->thrown_exception
@*/
# endif
E4C_NORETURN;

# ifdef E4C_THREADSAFE

static E4C_INLINE
/*@dependent@*/ /*@null@*/
e4c_context *
_e4c_context_get_current(
    void
)
/*@globals
        fileSystem,
        internalState,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,
        internalState,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
;

# endif

/*
 * FRAME
 *
 *     PUBLIC
 *         e4c_get_status
 *
 *     PROTECTED
 *         e4c_frame_first_stage_
 *         e4c_frame_next_stage_
 *         e4c_frame_get_stage_
 *         e4c_frame_catch_
 *         e4c_frame_repeat_
 *
 *     PRIVATE
 *         _e4c_frame_allocate
 *         _e4c_frame_deallocate
 *         _e4c_frame_initialize
 *
 */

/*@-redecl@*/
e4c_status
e4c_get_status(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
/*@notnull@*/ /*@temp@*/
e4c_continuation *
e4c_frame_first_stage_(
    enum e4c_frame_stage_           stage,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,

        current_context->current_frame,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
E4C_BOOL
e4c_frame_next_stage_(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        AssertionException,
        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        current_context,
        fatal_error_flag,
        is_initialized,

        AssertionException,
        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        current_context->current_frame,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
e4c_frame_stage
e4c_frame_get_stage_(
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
E4C_BOOL
e4c_frame_catch_(
    /*@in@*/ /*@temp@*/ /*@null@*/
    const e4c_exception_type       *exception_type,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        current_context->current_frame,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
/*@maynotreturn@*/
void
e4c_frame_repeat_(
    int                                                     max_repeat_attempts,
    enum e4c_frame_stage_           stage,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function
)
# ifdef E4C_THREADSAFE
/*@globals
        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        AssertionException,
        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        current_context,
        fatal_error_flag,
        is_initialized,

        AssertionException,
        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        current_context->current_frame,
        is_initialized,
        fatal_error_flag
@*/
# endif
;
/*@=redecl@*/

static E4C_INLINE
/*@out@*/
e4c_frame *
_e4c_frame_allocate(
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@notnull@*/
    const char                             *function
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized
@*/
# endif
;

static E4C_INLINE
void
_e4c_frame_deallocate(
    /*@only@*/ /*@null@*/
    e4c_frame                                      *frame
)
/*@releases
        frame
@*/
/*@modifies
        frame
@*/
;

static E4C_INLINE
void
_e4c_frame_initialize(
    /*@out@*/ /*@notnull@*/
    e4c_frame                                      *frame,
    /*@only@*/ /*@in@*/ /*@null@*/
    e4c_frame                                      *previous,
    e4c_frame_stage                         stage
)
/*@ensures isnull frame->thrown_exception@*/
/*@modifies
        frame
@*/
;

/*
 * EXCEPTION TYPE
 *
 *     PUBLIC
 *         e4c_print_exception_type
 *         e4c_is_instance_of
 *
 *     PRIVATE
 *         _e4c_print_exception_type
 *         _e4c_print_exception_type_node
 *         _e4c_exception_type_extends
 *
 */

/*@-redecl@*/
void
e4c_print_exception_type(
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        current_context->current_frame
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
E4C_BOOL
e4c_is_instance_of(
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    const e4c_exception            *instance,
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        environment_collection_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        current_context->current_frame
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
static E4C_INLINE
void
_e4c_print_exception_type(
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type
)
/*@globals
        fileSystem
@*/
/*@modifies
        fileSystem
@*/
;
/*@=redecl@*/

static E4C_INLINE
int
_e4c_print_exception_type_node(
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type
)
/*@globals
        fileSystem
@*/
/*@modifies
        fileSystem
@*/
;

static E4C_INLINE
E4C_BOOL
_e4c_exception_type_extends(
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    const e4c_exception_type       *child,
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    const e4c_exception_type       *parent
)
/*@*/
;

/*
 * EXCEPTION
 *
 *     PUBLIC
 *         e4c_print_exception
 *         e4c_get_exception
 *
 *     PROTECTED
 *         e4c_exception_throw_verbatim_
 *         e4c_exception_throw_format_
 *
 *     PRIVATE
 *         _e4c_exception_allocate
 *         _e4c_exception_deallocate
 *         _e4c_exception_initialize
 *         _e4c_exception_set_cause
 *         _e4c_exception_throw
 *         _e4c_print_exception
 *
 */

/*@-redecl@*/
void
e4c_print_exception(
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    const e4c_exception            *exception
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
/*@observer@*/ /*@relnull@*/
const e4c_exception *
e4c_get_exception(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError
@*/
/*@modifies
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized
@*/
# endif
;
/*@=redecl@*/

/*@-redecl@*/
/*@noreturn@*/
void
e4c_exception_throw_verbatim_(
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function,
    /*@in@*/ /*@observer@*/ /*@temp@*/ /*@null@*/
    const char                             *message
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        current_context,
        current_context->current_frame,
        fatal_error_flag,
        is_initialized
@*/
# endif
E4C_NORETURN;
/*@=redecl@*/

# if defined(HAVE_C99_VSNPRINTF) || defined(HAVE_VSNPRINTF)

/*@-redecl@*/
/*@noreturn@*/
void
e4c_exception_throw_format_(
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function,
    /*@in@*/ /*@observer@*/ /*@temp@*/ /*@notnull@*/ /*@printflike@*/
    const char                             *format,
    ...
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        environment_collection,
        environment_collection_mutex,
        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,

        current_context,
        fatal_error_flag,
        is_initialized,

        ContextHasNotBegunYet,
        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,

        current_context,
        current_context->current_frame,
        fatal_error_flag,
        is_initialized
@*/
# endif
E4C_NORETURN;
/*@=redecl@*/

# endif

static E4C_INLINE
/*@out@*/
e4c_exception *
_e4c_exception_allocate(
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@notnull@*/
    const char                             *function
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError,
        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex
@*/
# else
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized
@*/
# endif
;

static E4C_INLINE
void
_e4c_exception_deallocate(
    /*@only@*/ /*@null@*/
    e4c_exception                          *exception
)
/*@releases
        exception
@*/
/*@modifies
        exception
@*/
;

static E4C_INLINE
void
_e4c_exception_initialize(
    /*@out@*/ /*@notnull@*/
    e4c_exception                          *exception,
    /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    E4C_BOOL                                        set_message,
    /*@observer@*/ /*@temp@*/ /*@null@*/
    const char                             *message,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function,
    int                                                     error_number
)
/*@ensures isnull exception->cause@*/
/*@modifies
        exception
@*/
;

static E4C_INLINE
void
_e4c_exception_set_cause(
    /*@notnull@*/
    e4c_exception                          *exception,
    /*@owned@*/ /*@notnull@*/
    e4c_exception                          *cause
)
/*@requires isnull exception->cause@*/
/*@ensures notnull exception->cause@*/
/*@modifies
        exception->cause
@*/
;

static E4C_INLINE
/*@only@*/ e4c_exception *
_e4c_exception_throw(
    /*@in@*/ /*@notnull@*/
    e4c_frame                                      *frame,
    /*@in@*/ /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@in@*/ /*@observer@*/ /*@null@*/
    const char                             *function,
    int                                                     error_number,
    E4C_BOOL                                        set_message,
    /*@in@*/ /*@observer@*/ /*@temp@*/ /*@null@*/
    const char                             *message
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        ExceptionSystemFatalError,
        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,
        is_initialized_mutex,

        frame->thrown_exception
@*/
# else
/*@globals
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState,

        fatal_error_flag,
        is_initialized,

        frame->thrown_exception
@*/
# endif
;

static E4C_INLINE
void
_e4c_print_exception(
    /*@in@*/ /*@temp@*/ /*@notnull@*/
    const e4c_exception            *exception
)
/*@globals
        fileSystem
@*/
/*@modifies
        fileSystem
@*/
;




/* LIBRARY
 ================================================================ */

static void _e4c_library_initialize( void )
{

    MUTEX_LOCK( is_initialized_mutex, "_e4c_library_initialize" )

    if ( !is_initialized )
    {

        /* registers the function _e4c_library_finalize to be called when the program exits */
        is_initialized = ( atexit( _e4c_library_finalize ) == 0 );
    }

    MUTEX_UNLOCK( is_initialized_mutex, "_e4c_library_initialize" )
}

static void _e4c_library_finalize( void )
{

    /* check for dangling context */
    if ( !fatal_error_flag && DANGLING_CONTEXT )
    {

        e4c_exception exception;

        /* create temporary exception to be printed out */
        _e4c_exception_initialize( &exception, &ContextNotEnded, E4C_TRUE, DESC_NOT_ENDED, E4C_INFO_FILE_, E4C_INFO_LINE_, "_e4c_library_finalize", errno );
        _e4c_print_exception( &exception );

        fatal_error_flag = E4C_TRUE;
    }

    /* check for critical error */
    if ( fatal_error_flag )
    {

        fprintf( stderr, MSG_AT_EXIT_ERROR );
        /* force failure exit status */
        exit( EXIT_FAILURE );
    }
}

static void _e4c_library_handle_signal( int signal_number )
{

    e4c_context                            *context;
    const e4c_signal_mapping       *mapping;
    e4c_exception                          *new_exception;
    signal_handler                          previous_handler;

    context = E4C_CONTEXT;

    /* check if `handleSignal` was called before `e4c_context_begin` or after `e4c_context_end` (very unlikely) */
    PREVENT_PROC( context == NULL, DESC_INVALID_CONTEXT, "_e4c_library_handle_signal" );

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_PROC( context->current_frame == NULL, DESC_INVALID_FRAME, "_e4c_library_handle_signal" );

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_PROC( context->signal_mappings == NULL, DESC_INVALID_STATE, "_e4c_library_handle_signal" );

    /* try to find a mapping for this signal */
    mapping = context->signal_mappings;

    /* loop until we find the NULL terminator */
    while ( mapping->signal_number != E4C_INVALID_SIGNAL_NUMBER_ )
    {

        if ( signal_number == mapping->signal_number )
        {

            const char *signal_name;

            switch ( signal_number )
            {
                    WHEN_SIGNAL( SIGABRT )
                    WHEN_SIGNAL( SIGFPE )
                    WHEN_SIGNAL( SIGILL )
                    WHEN_SIGNAL( SIGSEGV )
                    WHEN_SIGNAL( SIGTERM )
                    WHEN_SIGNAL( SIGINT )
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
                    /*@switchbreak@*/
                    break;
            }

            /* check if we were supposed to ignore this signal (very unlikely) */
            PREVENT_PROC( mapping->exception_type == NULL, DESC_INVALID_STATE, "_e4c_library_handle_signal" );

            /* reset the handler for this signal */
            previous_handler = signal( signal_number, _e4c_library_handle_signal );

            if ( previous_handler == SIG_ERR )
            {
                /* we were unable to register the signal handling procedure again */
                INTERNAL_ERROR( DESC_SIGERR_HANDLE, "_e4c_library_handle_signal" );
            }

            /* throw the appropriate exception to the current context */
            new_exception = _e4c_exception_allocate( __LINE__, "_e4c_library_handle_signal" );
            _e4c_exception_initialize( new_exception, mapping->exception_type, E4C_TRUE, NULL, signal_name, signal_number, "_e4c_library_handle_signal", errno );
            _e4c_context_propagate( context, new_exception );
        }

        /* proceed to the next mapping */
        mapping++;
    }

    /* this should never happen, but anyway... */
    /* we were unable to find the exception that represents the received signal number */
    INTERNAL_ERROR( DESC_NO_MAPPING, "_e4c_library_handle_signal" );
}

static E4C_INLINE void _e4c_library_fatal_error( const e4c_exception_type *exception_type, const char *message, const char *file, int line, const char *function, int error_number )
{

    e4c_exception exception;

    _e4c_exception_initialize( &exception, exception_type, E4C_TRUE, message, file, line, function, error_number );

    /* ensures library initialization so that _e4c_library_finalize will be called */
    INITIALIZE_ONCE;

    /* prints this specific exception */
    _e4c_print_exception( &exception );

    /* prints error message */
    fprintf( stderr, MSG_FATAL_ERROR );

    /* records critical error so that MSG_AT_EXIT_ERROR will be printed too */
    fatal_error_flag = E4C_TRUE;

    STOP_EXECUTION;
}

long e4c_library_version( void )
{

    return( ( long )E4C_VERSION_NUMBER );
}

# ifdef E4C_THREADSAFE

/* ENVIRONMENT
 ================================================================ */

static e4c_environment *_e4c_environment_get_current( void )
{

    THREAD_TYPE                     self            = THREAD_CURRENT;
    /*@dependent@*/
    e4c_environment        *environment     = NULL;

    MUTEX_LOCK( environment_collection_mutex, "_e4c_environment_get_current" )

    FOREACH( environment, environment_collection )
    {

        if ( THREAD_SAME( self, environment->self ) )
        {
            break;
        }
    }

    MUTEX_UNLOCK( environment_collection_mutex, "_e4c_environment_get_current" )

    return( environment );
}

static E4C_INLINE e4c_environment *_e4c_environment_allocate( int line, const char *function )
{

    e4c_environment *environment;

    environment = malloc( sizeof( *environment ) );

    if ( environment == NULL )
    {
        MEMORY_ERROR( DESC_MALLOC_CONTEXT, line, function );
        E4C_UNREACHABLE_RETURN( NULL );
    }

    return( environment );
}

static E4C_INLINE void _e4c_environment_deallocate( e4c_environment *environment )
{

    if ( environment != NULL )
    {

        _e4c_environment_deallocate( environment->next );
        environment->next = NULL;

        _e4c_frame_deallocate( environment->context.current_frame );
        environment->context.current_frame = NULL;

        free( environment );
    }
}

static void _e4c_environment_initialize( e4c_environment *environment, e4c_uncaught_handler uncaught_handler )
{

    /* assert: environment != NULL */

    /* bound the new environment to the current thread */
    environment->self = THREAD_CURRENT;

    _e4c_context_initialize( &environment->context, uncaught_handler );
}

static E4C_INLINE void _e4c_environment_add( e4c_environment *environment )
{

    /* assert: environment != NULL */

    MUTEX_LOCK( environment_collection_mutex, "_e4c_environment_add" )

    environment->next                               = environment_collection.first;
    environment_collection.first    = environment;

    MUTEX_UNLOCK( environment_collection_mutex, "_e4c_environment_add" )
}

static e4c_environment *_e4c_environment_remove( void )
{

    THREAD_TYPE                     self            = THREAD_CURRENT;
    e4c_environment        *previous        = NULL;
    e4c_environment        *current;
    e4c_environment        *found           = NULL;

    MUTEX_LOCK( environment_collection_mutex, "_e4c_environment_remove" )

    FOREACH( current, environment_collection )
    {

        if ( THREAD_SAME( self, current->self ) )
        {
            if ( previous == NULL )
            {
                found                                                   = environment_collection.first /* (equals current) */;
                environment_collection.first    = current->next;
            }
            else
            {
                found                                                   = previous->next  /* (equals current) */;
                previous->next                                  = current->next;
            }

            break;
        }

        /* keep track of the previous environment */
        previous = current;
    }

    MUTEX_UNLOCK( environment_collection_mutex, "_e4c_environment_remove" )

    return( found );
}

# endif

/* CONTEXT
 ================================================================ */

static E4C_INLINE void _e4c_context_initialize( e4c_context *context, e4c_uncaught_handler uncaught_handler )
{

    context->uncaught_handler       = uncaught_handler;
    context->signal_mappings        = NULL;
    context->current_frame          = _e4c_frame_allocate( __LINE__, "_e4c_context_initialize" );

    _e4c_frame_initialize( context->current_frame, NULL, e4c_done_ );
}

static void _e4c_context_propagate( e4c_context *context, e4c_exception *exception )
{

    /* assert: exception != NULL */
    /* assert: context != NULL */
    /* assert: context->current_frame != NULL */

    e4c_frame *frame;

    frame = context->current_frame;

    /* update the frame with the exception information */
    frame->uncaught                 = E4C_TRUE;

    /* deallocate previously thrown exception */
    _e4c_exception_deallocate( frame->thrown_exception );

    /* update current thrown exception */
    frame->thrown_exception = exception;

    /* if this is the upper frame, then this is an uncaught exception */
    if ( IS_TOP_FRAME( frame ) )
    {
        _e4c_context_at_uncaught_exception( context );
    }

    /* otherwise, we will jump to the upper frame */

    /* simple optimization */
    if ( frame->stage == e4c_acquiring_ )
    {
        /* if we are in the middle of an acquisition, we don't need to dispose the resource */
        frame->stage = e4c_disposing_;
        /* (that actually jumps over the "disposing" stage) */
    }

    /* keep looping */
    E4C_CONTINUE( frame->continuation );
}

# ifdef E4C_THREADSAFE

static E4C_INLINE e4c_context *_e4c_context_get_current( void )
{

    e4c_environment *environment = _e4c_environment_get_current();

    return( environment == NULL ? NULL : &environment->context );
}

/* e4c_context_begin (multi-thread) */
void e4c_context_begin( E4C_BOOL handle_signals, e4c_uncaught_handler uncaught_handler )
{

    e4c_environment *environment;

    INITIALIZE_ONCE;

    /* get the current environment */
    environment = _e4c_environment_get_current();

    /* check if e4c_context_begin was called twice for this thread */
    if ( environment != NULL )
    {
        MISUSE_ERROR( ContextAlreadyBegun, "e4c_context_begin: " DESC_ALREADY_BEGUN, NULL, 0, NULL );
    }

    /* allocate memory for the new environment */
    environment     = _e4c_environment_allocate( __LINE__, "e4c_context_begin" );

    /* initialize the new environment */
    _e4c_environment_initialize( environment, uncaught_handler );

    /* add the new environment to the collection */
    _e4c_environment_add( environment );

    if ( handle_signals )
    {
        _e4c_context_set_signal_handlers( &environment->context, e4c_default_signal_mappings );
    }
}

/* e4c_context_end (multi-thread) */
void e4c_context_end( void )
{

    e4c_context            *context;
    e4c_frame                      *frame;
    e4c_environment        *environment;

    /* remove (and get) the current context */
    environment = _e4c_environment_remove();

    /* check if `e4c_context_end` was called before calling `e4c_context_begin` */
    if ( environment == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_context_end: " DESC_NOT_BEGUN_YET, NULL, 0, NULL );
    }

    /* update local variable */
    context = &environment->context;

    /* check if the current context is NULL (unlikely) */
    PREVENT_PROC( context == NULL, DESC_INVALID_CONTEXT, "e4c_context_end" );

    /* get the current frame */
    frame = context->current_frame;

    /* check if there are no frames left (unlikely) */
    PREVENT_PROC( frame == NULL, DESC_NO_FRAMES_LEFT, "e4c_context_end" );

    /* check if there are too many frames left (breaking out of a try block) */
    if ( !IS_TOP_FRAME( frame ) )
    {
        INTERNAL_ERROR( DESC_TOO_MANY_FRAMES, "e4c_context_end" );
    }

    /* reset all signal handlers */
    _e4c_context_set_signal_handlers( context, NULL );

    /* deallocate the thread environment */
    _e4c_environment_deallocate( environment );
}

# else

/* e4c_context_begin (single-thread) */
void e4c_context_begin( E4C_BOOL handle_signals, e4c_uncaught_handler uncaught_handler )
{

    INITIALIZE_ONCE;

    /* check if e4c_context_begin was called twice for this program */
    /* this can also happen when the program uses threads but E4C_THREADSAFE is not defined */
    if ( current_context != NULL )
    {
        MISUSE_ERROR( ContextAlreadyBegun, "e4c_context_begin: " DESC_ALREADY_BEGUN, NULL, 0, NULL );
    }

    /* check if the current frame is NOT NULL (unlikely) */
    PREVENT_PROC( main_context.current_frame != NULL, DESC_INVALID_STATE, "e4c_context_begin" );

    /* initialize context, register uncaught handler */
    _e4c_context_initialize( &main_context, uncaught_handler );

    if ( handle_signals )
    {
        _e4c_context_set_signal_handlers( &main_context, e4c_default_signal_mappings );
    }

    /* update global variable */
    current_context = &main_context;
}

/* e4c_context_end (single-thread) */
void e4c_context_end( void )
{

    e4c_context            *context;
    e4c_frame                      *frame;

    /* get the current context */
    context = current_context;

    /* check if `e4c_context_end` was called before calling `e4c_context_begin` */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_context_end: " DESC_NOT_BEGUN_YET, NULL, 0, NULL );
    }

    /* get the current frame */
    frame = context->current_frame;

    /* check if there are no frames left (unlikely) */
    PREVENT_PROC( frame == NULL, DESC_NO_FRAMES_LEFT, "e4c_context_end" );

    /* check if there are too many frames left (breaking out of a try block) */
    if ( !IS_TOP_FRAME( frame ) )
    {
        INTERNAL_ERROR( DESC_TOO_MANY_FRAMES, "e4c_context_end" );
    }

    /* reset all signal handlers */
    _e4c_context_set_signal_handlers( context, NULL );

    /* deallocate the current, top frame */
    _e4c_frame_deallocate( frame );

    /* deactivate the top frame (for sanity) */
    current_context->current_frame = NULL;

    /* deactivate the current context */
    current_context = NULL;
}

# endif

static void _e4c_context_set_signal_handlers( e4c_context *context, const e4c_signal_mapping *mappings )
{

    /* assert: context != NULL */

    const e4c_signal_mapping       *next_mapping;
    signal_handler                          previous_handler;

    if ( context->signal_mappings != NULL )
    {
        next_mapping = context->signal_mappings;

        /* reset all the previously set signal handlers */
        while ( next_mapping->signal_number != E4C_INVALID_SIGNAL_NUMBER_ )
        {
            previous_handler = signal( next_mapping->signal_number, SIG_DFL );

            if ( previous_handler == SIG_ERR )
            {
                /* we were unable to reset to the default action */
                INTERNAL_ERROR( DESC_SIGERR_DEFAULT, "e4c_set_signal_handlers" );
            }

            next_mapping++;
        }
    }

    if ( mappings == NULL )
    {
        /* disable signal handling */
        context->signal_mappings = NULL;
        return;
    }

    /* set up signal mapping */
    context->signal_mappings = next_mapping = mappings;

    while ( next_mapping->signal_number != E4C_INVALID_SIGNAL_NUMBER_ )
    {

        signal_handler  handler;
        const char     *error_message;

        if ( next_mapping->exception_type != NULL )
        {
            /* map this signal to this exception */
            handler                 = _e4c_library_handle_signal;
            error_message   = DESC_SIGERR_HANDLE;
        }
        else
        {
            /* ignore this signal */
            handler                 = SIG_IGN;
            error_message   = DESC_SIGERR_IGNORE;
        }

        previous_handler = signal( next_mapping->signal_number, handler );

        if ( previous_handler == SIG_ERR )
        {
            INTERNAL_ERROR( error_message, "e4c_set_signal_handlers" );
        }

        next_mapping++;
    }
}

static void _e4c_context_at_uncaught_exception( e4c_context *context )
{

    /* assert: context != NULL */

    e4c_uncaught_handler handler;

    handler = context->uncaught_handler;

    if ( handler != NULL )
    {
        /* TODO: find the proper way to make Splint happy */
        /*@-noeffectuncon@*/
        handler( context->current_frame->thrown_exception );
        /*@=noeffectuncon@*/
    }

    e4c_context_end();

    STOP_EXECUTION;
}

void e4c_context_set_signal_mappings( const e4c_signal_mapping *mappings )
{

    e4c_context *context;

    context = E4C_CONTEXT;

    /* check if `e4c_context_set_signal_mappings` was called before calling `e4c_context_begin` */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_context_set_signal_mappings: " DESC_NOT_BEGUN_YET, NULL, 0, NULL );
    }

    _e4c_context_set_signal_handlers( context, mappings );
}

const e4c_signal_mapping *e4c_context_get_signal_mappings( void )
{

    e4c_context *context;

    context = E4C_CONTEXT;

    /* check if `e4c_context_get_signal_mappings` was called before calling `e4c_context_begin` */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_context_get_signal_mappings: " DESC_NOT_BEGUN_YET, NULL, 0, NULL );
        E4C_UNREACHABLE_RETURN( NULL );
    }

    return( context->signal_mappings );
}

E4C_BOOL e4c_context_is_ready( void )
{

    return( E4C_CONTEXT != NULL );
}

/* FRAME
 ================================================================ */

e4c_continuation *e4c_frame_first_stage_( e4c_frame_stage stage, const char *file, int line, const char *function )
{

    e4c_context    *context;
    e4c_frame              *current_frame;
    e4c_frame              *new_frame;

    context = E4C_CONTEXT;

    /* check if 'try' was used before calling e4c_context_begin */
    if ( context == NULL )
    {
        if ( stage == e4c_beginning_ )
        {
            MISUSE_ERROR( ContextHasNotBegunYet, "E4C_WITH: " DESC_NOT_BEGUN_YET, file, line, function );
        }

        MISUSE_ERROR( ContextHasNotBegunYet, "E4C_TRY: " DESC_NOT_BEGUN_YET, file, line, function );
        E4C_UNREACHABLE_RETURN( NULL );
    }

    current_frame = context->current_frame;

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_FUNC( current_frame == NULL, DESC_INVALID_FRAME, "e4c_frame_first_stage_", NULL );

    /* create a new frame */
    new_frame = _e4c_frame_allocate( __LINE__, "e4c_frame_first_stage_" );

    _e4c_frame_initialize( new_frame, current_frame, stage );

    /* make it the new current frame */
    context->current_frame = new_frame;

    return( &( new_frame->continuation ) );
}

static E4C_INLINE void _e4c_frame_initialize( e4c_frame *frame, e4c_frame *previous, e4c_frame_stage stage )
{

    frame->previous                         = previous;
    frame->stage                            = stage;
    frame->uncaught                         = E4C_FALSE;
    frame->reacquire_attempts       = 0;
    frame->retry_attempts           = 0;
    frame->thrown_exception         = NULL;

    /* jmp_buf is an implementation-defined type */
}

static E4C_INLINE e4c_frame *_e4c_frame_allocate( int line, const char *function )
{

    e4c_frame *frame;

    /* (using calloc instead of malloc so that jmp_buf is initialized to zero) */
    frame = calloc( ( size_t )1, sizeof( *frame ) );

    if ( frame == NULL )
    {
        MEMORY_ERROR( DESC_MALLOC_FRAME, line, function );
        E4C_UNREACHABLE_RETURN( NULL );
    }

    return( frame );
}

static E4C_INLINE void _e4c_frame_deallocate( e4c_frame *frame )
{

    if ( frame != NULL )
    {

        /* delete previous frame */
        _e4c_frame_deallocate( frame->previous );
        frame->previous = NULL;

        /* delete thrown exception */
        _e4c_exception_deallocate( frame->thrown_exception );
        frame->thrown_exception = NULL;

        free( frame );
    }
}

e4c_frame_stage e4c_frame_get_stage_( const char *file, int line, const char *function )
{

    e4c_context *context;

    context = E4C_CONTEXT;

    /* check if 'e4c_frame_get_stage_' was used before calling e4c_context_begin */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_frame_get_stage_: " DESC_NOT_BEGUN_YET, file, line, function );
    }

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_FUNC( context->current_frame == NULL, DESC_INVALID_FRAME, "e4c_frame_get_stage_", E4C_FALSE );

    return( context->current_frame->stage );
}

E4C_BOOL e4c_frame_catch_( const e4c_exception_type *exception_type, const char *file, int line, const char *function )
{

    e4c_context    *context;
    e4c_frame              *frame;

    context = E4C_CONTEXT;

    /* check if 'e4c_frame_catch_' was used before calling e4c_context_begin */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_frame_catch_: " DESC_NOT_BEGUN_YET, file, line, function );
    }

    frame = context->current_frame;

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_FUNC( frame == NULL, DESC_INVALID_FRAME, "e4c_frame_catch_", E4C_FALSE );

    if ( frame->stage != e4c_catching_ )
    {
        return( E4C_FALSE );
    }

    /* passing NULL to a catch block is considered a fatal error */
    if ( exception_type == NULL )
    {
        MISUSE_ERROR( NullPointerException, "E4C_CATCH: " DESC_CATCH_NULL, file, line, function );
        E4C_UNREACHABLE_RETURN( E4C_FALSE );
    }

    /* check if the thrown exception is NULL (very unlikely) */
    PREVENT_FUNC( frame->thrown_exception == NULL, DESC_INVALID_STATE, "e4c_frame_catch_", E4C_FALSE );

    /* check if the exception type is NULL (very unlikely) */
    PREVENT_FUNC( frame->thrown_exception->type == NULL, DESC_INVALID_STATE, "e4c_frame_catch_", E4C_FALSE );

    /* assert: thrown_exception is catchable (otherwise we would have skipped the "catching" stage in e4c_frame_next_stage_) */

    /* does this block catch current exception? */
    if ( frame->thrown_exception->type != exception_type && !_e4c_exception_type_extends( frame->thrown_exception->type, exception_type ) )
    {
        /* nay, keep looking for an exception handler */
        return( E4C_FALSE );
    }

    /* yay, catch current exception by executing the handler */
    frame->uncaught = E4C_FALSE;

    return( E4C_TRUE );
}

E4C_BOOL e4c_frame_next_stage_( void )
{

    e4c_context    *context;
    e4c_frame              *frame;
    e4c_frame              *previous;
    e4c_exception *thrown_exception;

    context = E4C_CONTEXT;

    /* check if the current exception context is NULL (unlikely) */
    PREVENT_FUNC( context == NULL, DESC_NOT_BEGUN_YET, "e4c_frame_next_stage_", E4C_FALSE );

    frame = context->current_frame;

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_FUNC( frame == NULL, DESC_INVALID_FRAME, "e4c_frame_next_stage_", E4C_FALSE );

    frame->stage++;

    /* simple optimization */
    if ( frame->stage == e4c_catching_  && ( !frame->uncaught || ( frame->thrown_exception == NULL ) || IS_UNCATCHABLE( frame->thrown_exception ) ) )
    {
        /* if no exception was thrown, or if the thrown exception cannot be
                caught, we don't need to go through the "catching" stage */
        frame->stage++;
    }

    /* keep looping until we reach the "done" stage */
    if ( frame->stage < e4c_done_ )
    {
        return( E4C_TRUE );
    }

    /* check if the previous frame is NULL (unlikely) */
    PREVENT_FUNC( frame->previous == NULL, DESC_INVALID_FRAME, "e4c_frame_next_stage_", E4C_FALSE );

    /* the exception loop is finished */

    /* deallocate caught exception */
    if ( frame->thrown_exception != NULL && !frame->uncaught )
    {
        _e4c_exception_deallocate( frame->thrown_exception );
        frame->thrown_exception = NULL;
    }

    /* capture temporarily the information of the current frame */
    /* so we can propagate an exception (if it was thrown) */
    previous                        = frame->previous;
    thrown_exception        = frame->thrown_exception;

    /* modify the current frame so that previous and thrown_exception don't get deallocated */
    frame->previous                 = NULL;
    frame->thrown_exception = NULL;

    /* delete the current frame */
    _e4c_frame_deallocate( frame );

    /* promote the previous frame to the current one */
    context->current_frame = previous;

    /* if the current frame has an uncaught exception, then we will propagate it */
    if ( thrown_exception != NULL )
    {
        _e4c_context_propagate( context, thrown_exception );
    }

    /* otherwise, we're free to go */

    /* get out of the exception loop */
    return( E4C_FALSE );
}

void e4c_frame_repeat_( int max_repeat_attempts, e4c_frame_stage stage, const char *file, int line, const char *function )
{

    e4c_context            *context;
    e4c_frame                      *frame;

    /* get the current context */
    context = E4C_CONTEXT;

    /* check if 'e4c_frame_repeat_' was used before calling e4c_context_begin */
    if ( context == NULL )
    {
        if ( stage == e4c_beginning_ )
        {
            MISUSE_ERROR( ContextHasNotBegunYet, "E4C_REACQUIRE: " DESC_NOT_BEGUN_YET, file, line, function );
        }

        MISUSE_ERROR( ContextHasNotBegunYet, "E4C_RETRY: " DESC_NOT_BEGUN_YET, file, line, function );
    }

    /* get the current frame */
    frame = context->current_frame;

    /* check if the current frame is NULL (unlikely) */
    PREVENT_PROC( frame == NULL, DESC_INVALID_FRAME, "e4c_frame_repeat_" );

    /* check if 'e4c_frame_repeat_' was used before 'try' or 'use' */
    if ( IS_TOP_FRAME( frame ) )
    {
        if ( stage == e4c_beginning_ )
        {
            MISUSE_ERROR( ExceptionSystemFatalError, "E4C_REACQUIRE: " DESC_CANNOT_REACQUIRE, file, line, function );
        }

        MISUSE_ERROR( ExceptionSystemFatalError, "E4C_RETRY: " DESC_CANNOT_RETRY, file, line, function );
    }

    /* check if "uncatchable" exception */
    if ( frame->uncaught && ( frame->thrown_exception != NULL ) && IS_UNCATCHABLE( frame->thrown_exception ) )
    {
        return;
    }

    /* check if maximum number of attempts reached and update the number of attempts */
    switch ( stage )
    {

        case e4c_beginning_:

            /* reacquire */
            if ( frame->reacquire_attempts >= max_repeat_attempts )
            {
                return;
            }

            frame->reacquire_attempts++;
            /*@switchbreak@*/
            break;

        case e4c_acquiring_:

            /* retry */
            if ( frame->retry_attempts >= max_repeat_attempts )
            {
                return;
            }

            frame->retry_attempts++;
            /*@switchbreak@*/
            break;

        case e4c_trying_:
        case e4c_disposing_:
        case e4c_catching_:
        case e4c_finalizing_:
        case e4c_done_:
        default:
            MISUSE_ERROR( ExceptionSystemFatalError, "e4c_frame_repeat: " DESC_CANNOT_REPEAT, file, line, function );
    }

    /* deallocate previously thrown exception */
    _e4c_exception_deallocate( frame->thrown_exception );

    /* reset exception information */
    frame->thrown_exception = NULL;
    frame->uncaught                 = E4C_FALSE;
    frame->stage                    = stage;

    /* keep looping */
    E4C_CONTINUE( frame->continuation );
}

e4c_status e4c_get_status( void )
{

    e4c_context    *context;
    e4c_frame              *frame;

    context = E4C_CONTEXT;

    /* check if `e4c_get_status` was called before calling `e4c_context_begin` */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_get_status: " DESC_NOT_BEGUN_YET, NULL, 0, NULL );
        E4C_UNREACHABLE_RETURN( e4c_failed );
    }

    frame = context->current_frame;

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_FUNC( frame == NULL, DESC_INVALID_FRAME, "e4c_get_status", e4c_failed );

    if ( frame->thrown_exception == NULL )
    {
        return( e4c_succeeded );
    }

    if ( frame->uncaught )
    {
        return( e4c_failed );
    }

    return( e4c_recovered );
}

/* EXCEPTION TYPE
 ================================================================ */

static E4C_INLINE E4C_BOOL _e4c_exception_type_extends( const e4c_exception_type *child, const e4c_exception_type *parent )
{

    /* assert: child != NULL */
    /* assert: parent != NULL */

    if ( child == parent )
    {
        return( E4C_TRUE );
    }

    /* If the exception is "its own parent" (the root of the hierarchy) or if it
            has "no parent" whatsoever, then we can determine that it does not
            extend the specified "parent"
    */
    if ( child->super == child || child->super == NULL )
    {
        return( E4C_FALSE );
    }

    /* otherwise, we will keep looking for a common ancestor */
    return( _e4c_exception_type_extends( child->super, parent ) );
}

E4C_BOOL e4c_is_instance_of( const e4c_exception *instance, const e4c_exception_type *exception_type )
{

    if ( instance == NULL )
    {
        /* the instance is NULL: maybe no exception was thrown */
        e4c_exception_throw_verbatim_( &NullPointerException, E4C_INFO_FILE_, E4C_INFO_LINE_, "e4c_is_instance_of", "Null exception instance." );
    }
    else if ( exception_type == NULL )
    {
        /* the type is NULL */
        e4c_exception_throw_verbatim_( &NullPointerException, E4C_INFO_FILE_, E4C_INFO_LINE_, "e4c_is_instance_of", "Null exception type." );
    }

    if ( instance->type == exception_type )
    {
        return( E4C_TRUE );
    }

    if ( instance->type->super == NULL || instance->type->super == instance->type )
    {
        /* if this exception has no other super type... */
        return( E4C_FALSE );
    }

    return( _e4c_exception_type_extends( instance->type->super, exception_type ) );
}

static E4C_INLINE int _e4c_print_exception_type_node( const e4c_exception_type *exception_type )
{

    int deep = -1;

    if ( exception_type->super == NULL || exception_type->super == exception_type )
    {

        fprintf( stderr, "    %s\n", exception_type->name );

    }
    else
    {

        deep = _e4c_print_exception_type_node( exception_type->super );

        fprintf( stderr, "    %*s |\n    %*s +--%s\n", deep * 4, "", deep * 4, "", exception_type->name );
    }

    return( deep + 1 );
}

static E4C_INLINE void _e4c_print_exception_type( const e4c_exception_type *exception_type )
{

    const char     *separator       = "________________________________________________________________";

    fprintf( stderr, "Exception hierarchy\n%s\n\n", separator );

    ( void )_e4c_print_exception_type_node( exception_type );

    fprintf( stderr, "%s\n", separator );
}

void e4c_print_exception_type( const e4c_exception_type *exception_type )
{

    if ( exception_type == NULL )
    {
        e4c_exception_throw_verbatim_( &NullPointerException, E4C_INFO_FILE_, E4C_INFO_LINE_, "e4c_print_exception_type", "Null exception type." );
    }

    _e4c_print_exception_type( exception_type );
}

/* EXCEPTION
 ================================================================ */

const e4c_exception *e4c_get_exception( void )
{

    e4c_context    *context;

    context = E4C_CONTEXT;

    /* check if `e4c_get_exception` was called before calling `e4c_context_begin` */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_get_exception: " DESC_NOT_BEGUN_YET, NULL, 0, NULL );
        E4C_UNREACHABLE_RETURN( NULL );
    }

    /* check if the current frame is NULL (very unlikely) */
    PREVENT_FUNC( context->current_frame == NULL, DESC_INVALID_FRAME, "e4c_get_exception", NULL );

    return( context->current_frame->thrown_exception );
}

static E4C_INLINE e4c_exception *_e4c_exception_throw( e4c_frame *frame, const e4c_exception_type *exception_type, const char *file, int line, const char *function, int error_number, E4C_BOOL set_message, const char *message )
{

    e4c_exception          *cause;
    e4c_exception          *new_exception;

    /* capture the cause of this exception */
    cause = frame->thrown_exception;
    frame->thrown_exception = NULL;

    /* convert NULL exception type to NPE */
    if ( exception_type == NULL )
    {
        /*
         * Splint does not seem to like the next statement:
         *
         *     exception_type = &NullPointerException;
         *
         * "Clauses exit with exception_type referencing local
         * storage in true branch, shared storage in continuation"
         *
         * That's why we are using a temporary variable (npe_type)
         */
        /*@shared@*/ /*@notnull@*/
        const e4c_exception_type *npe_type = &NullPointerException;
        exception_type = npe_type;
    }

    new_exception = _e4c_exception_allocate( __LINE__, "_e4c_exception_throw" );

    /* "instantiate" the specified exception */
    _e4c_exception_initialize( new_exception, exception_type, set_message, message, file, line, function, error_number );

    if ( cause != NULL )
    {
        _e4c_exception_set_cause( new_exception, cause );
    }

    return( new_exception );
}

void e4c_exception_throw_verbatim_( const e4c_exception_type *exception_type, const char *file, int line, const char *function, const char *message )
{

    int                                     error_number;
    e4c_context            *context;
    e4c_frame                      *frame;
    e4c_exception          *new_exception;

    /* store the current error number up front */
    error_number = errno;

    /* get the current context */
    context = E4C_CONTEXT;

    /* check if 'throw' was used before calling e4c_context_begin */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_exception_throw_verbatim_: " DESC_NOT_BEGUN_YET, file, line, function );
    }

    /* get the current frame */
    frame = context->current_frame;

    /* check if the current frame is NULL (unlikely) */
    PREVENT_PROC( frame == NULL, DESC_INVALID_FRAME, "e4c_exception_throw_verbatim_" );

    /* check context and frame; initialize exception and cause */
    new_exception = _e4c_exception_throw( frame, exception_type, file, line, function, error_number, E4C_TRUE, message );

    /* propagate the exception up the call stack */
    _e4c_context_propagate( context, new_exception );
}

# if defined(HAVE_C99_VSNPRINTF) || defined(HAVE_VSNPRINTF)

void e4c_exception_throw_format_( const e4c_exception_type *exception_type, const char *file, int line, const char *function, const char *format, ... )
{

    int                                     error_number;
    e4c_context            *context;
    e4c_frame                      *frame;
    e4c_exception          *new_exception;

    /* store the current error number up front */
    error_number = errno;

    /* get the current context */
    context = E4C_CONTEXT;

    /* check if 'throwf' was used before calling e4c_context_begin */
    if ( context == NULL )
    {
        MISUSE_ERROR( ContextHasNotBegunYet, "e4c_exception_throw_format_: " DESC_NOT_BEGUN_YET, file, line, function );
    }

    /* get the current frame */
    frame = context->current_frame;

    /* check if the current frame is NULL (unlikely) */
    PREVENT_PROC( frame == NULL, DESC_INVALID_FRAME, "e4c_exception_throw_format_" );

    /* check context and frame; initialize exception and cause */
    new_exception = _e4c_exception_throw( frame, exception_type, file, line, function, error_number, ( format == NULL ), NULL );

    /* format the message (only if feasible) */
    if ( format != NULL )
    {
        va_list arguments_list;
        va_start( arguments_list, format );
        ( void )vsnprintf( new_exception->message, ( size_t )E4C_EXCEPTION_MESSAGE_SIZE, format, arguments_list );
        va_end( arguments_list );
    }

    /* propagate the exception up the call stack */
    _e4c_context_propagate( context, new_exception );
}

# endif

static E4C_INLINE void _e4c_exception_initialize( e4c_exception *exception, const e4c_exception_type *exception_type, E4C_BOOL set_message, const char *message, const char *file, int line, const char *function, int error_number )
{

    /* assert: exception != NULL */
    /* assert: exception_type != NULL */

    exception->name                 = exception_type->name;
    exception->file                 = file;
    exception->line                 = line;
    exception->function             = function;
    exception->error_number = error_number;
    exception->type                 = exception_type;
    exception->cause                = NULL;

    if ( set_message )
    {
        /* initialize the message of this exception */
        if ( message != NULL )
        {
            /* copy the given message */
            VERBATIM_COPY( exception->message, message );
        }
        else
        {
            /* copy the default message for this type of exception */
            VERBATIM_COPY( exception->message, exception_type->message );
        }
    }

    /*
     * since the exception is allocated and then zero-initialized,
     * there's no need to truncate the message when !set_message.
     */
}

static E4C_INLINE e4c_exception *_e4c_exception_allocate( int line, const char *function )
{

    e4c_exception *exception;

    /* (using calloc instead of malloc so that the message is initialized to zero) */
    exception = calloc( ( size_t )1, sizeof( *exception ) );

    if ( exception == NULL )
    {
        MEMORY_ERROR( DESC_MALLOC_EXCEPTION, line, function );
        E4C_UNREACHABLE_RETURN( NULL );
    }

    return( exception );
}

static E4C_INLINE void _e4c_exception_deallocate( e4c_exception *exception )
{

    if ( exception != NULL )
    {

        _e4c_exception_deallocate( exception->cause );
        exception->cause = NULL;

        free( exception );
    }
}

static E4C_INLINE void _e4c_exception_set_cause( e4c_exception *exception, e4c_exception *cause )
{

    /* assert: exception != NULL */
    /* assert: cause != NULL */

    exception->cause                = cause;
}

static void _e4c_print_exception( const e4c_exception *exception )
{

# ifdef NDEBUG

    fprintf( stderr, "\n\nFatal Error: %s (%s)\n\n", exception->name, exception->message );

# else

    const e4c_exception *cause;

    fprintf( stderr, "\n\nUncaught %s: %s\n\n", exception->name, exception->message );

    if ( exception->file != NULL )
    {
        if ( exception->function != NULL )
        {
            fprintf( stderr, "    thrown at %s (%s:%d)\n\n", exception->function, exception->file, exception->line );
        }
        else
        {
            fprintf( stderr, "    thrown at %s:%d\n\n", exception->file, exception->line );
        }
    }

    cause = exception->cause;

    while ( cause != NULL )
    {
        fprintf( stderr, "Caused by %s: %s\n\n", cause->name, cause->message );

        if ( cause->file != NULL )
        {
            if ( cause->function != NULL )
            {
                fprintf( stderr, "    thrown at %s (%s:%d)\n\n", cause->function, cause->file, cause->line );
            }
            else
            {
                fprintf( stderr, "    thrown at %s:%d\n\n", cause->file, cause->line );
            }
        }

        cause = cause->cause;
    }

    fprintf( stderr, "The value of errno was %d.\n\n", exception->error_number );

    if ( exception->type != NULL )
    {
        _e4c_print_exception_type( exception->type );
    }

# endif

}

void e4c_print_exception( const e4c_exception *exception )
{

    if ( exception == NULL )
    {
        e4c_exception_throw_verbatim_( &NullPointerException, E4C_INFO_FILE_, E4C_INFO_LINE_, "e4c_print_exception", "Null exception." );
    }

    _e4c_print_exception( exception );
}

