/**
 *
 * @file        e4c.h
 *
 * exceptions4c header file
 *
 * @version     2.8
 * @author      Copyright (c) 2011 Guillermo Calvo
 *
 * @section e4c_h exceptions4c header file
 *
 * This header file needs to be included from in order to be able to use any of
 * the keywords of the the exception handling system:
 *
 * @li @c #try
 * @li @c #catch
 * @li @c #finally
 * @li @c #throw
 * @li @c #with
 * @li @c #using
 *
 * In order to stop defining these keywords, there exists a @c E4C_NOKEYWORDS
 * @e compile-time parameter. When the keywords are not defined, the next set of
 * alternative macros can be used to achieve the same functionality:
 *
 * @li @c E4C_TRY
 * @li @c E4C_CATCH
 * @li @c E4C_FINALLY
 * @li @c E4C_THROW
 * @li @c E4C_WITH
 * @li @c E4C_USING
 *
 * @section license License
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


# ifndef EXCEPTIONS4C
# define EXCEPTIONS4C


# define E4C_VERSION_(version)                  version(2, 8, 9)


# if !defined(E4C_THREADSAFE) && ( \
                defined(_THREAD_SAFE) \
        ||      defined(_REENTRANT) \
        ||      defined(PTHREAD_H) \
        ||      defined(PTHREAD_BARRIER_SERIAL_THREAD) \
        ||      defined(PTHREAD_CANCEL_ASYNCHRONOUS) \
        ||      defined(PTHREAD_CANCEL_ENABLE) \
        ||      defined(PTHREAD_CANCEL_DEFERRED) \
        ||      defined(PTHREAD_CANCEL_DISABLE) \
        ||      defined(PTHREAD_CANCELED) \
        ||      defined(PTHREAD_COND_INITIALIZER) \
        ||      defined(PTHREAD_CREATE_DETACHED) \
        ||      defined(PTHREAD_CREATE_JOINABLE) \
        ||      defined(PTHREAD_EXPLICIT_SCHED) \
        ||      defined(PTHREAD_INHERIT_SCHED) \
        ||      defined(PTHREAD_MUTEX_DEFAULT) \
        ||      defined(PTHREAD_MUTEX_ERRORCHECK) \
        ||      defined(PTHREAD_MUTEX_NORMAL) \
        ||      defined(PTHREAD_MUTEX_INITIALIZER) \
        ||      defined(PTHREAD_MUTEX_RECURSIVE) \
        ||      defined(PTHREAD_ONCE_INIT) \
        ||      defined(PTHREAD_PRIO_INHERIT) \
        ||      defined(PTHREAD_PRIO_NONE) \
        ||      defined(PTHREAD_PRIO_PROTECT) \
        ||      defined(PTHREAD_PROCESS_SHARED) \
        ||      defined(PTHREAD_PROCESS_PRIVATE) \
        ||      defined(PTHREAD_RWLOCK_INITIALIZER) \
        ||      defined(PTHREAD_SCOPE_PROCESS) \
        ||      defined(PTHREAD_SCOPE_SYSTEM) \
)
#       error "Please define E4C_THREADSAFE at compiler level " \
"in order to enable the multi-thread version of exceptions4c."
# endif


/*@-exportany@*/


/* C99 features */
# if defined(_ISOC99_SOURCE) \
        ||      defined(_GNU_SOURCE) \
        ||      ( defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L) )

#       ifndef HAVE_C99_STDBOOL
#               define HAVE_C99_STDBOOL
#       endif

#       ifndef HAVE_C99_VARIADIC_MACROS
#               define HAVE_C99_VARIADIC_MACROS
#       endif

#       ifndef HAVE_C99_FUNC
#               define HAVE_C99_FUNC
#       endif

#       ifndef HAVE_C99_VSNPRINTF
#               define HAVE_C99_VSNPRINTF
#       endif

#       ifndef HAVE_C99_SNPRINTF
#               define HAVE_C99_SNPRINTF
#       endif

# endif


/* POSIX features */
# if defined(_POSIX_C_SOURCE) \
        ||      defined(_POSIX_SOURCE) \
        ||      defined(_POSIX_VERSION) \
        ||      defined(_POSIX2_C_VERSION) \
        ||      defined(_XOPEN_SOURCE) \
        ||      defined(_XOPEN_VERSION) \
        ||      defined(_XOPEN_SOURCE_EXTENDED) \
        ||      defined(_GNU_SOURCE)

/*
 * POSIX.1 does not specify whether setjmp and longjmp save or restore the
 * current set of blocked signals. If a program employs signal handling it
 * should use POSIX's sigsetjmp/siglongjmp.
 */
#       ifndef HAVE_POSIX_SIGSETJMP
#               define HAVE_POSIX_SIGSETJMP
#       endif

# endif


# include <stdlib.h>
# include <setjmp.h>


# if defined(HAVE_C99_STDBOOL) || defined(HAVE_STDBOOL_H)
#       include <stdbool.h>
# endif

# if    defined(__bool_true_false_are_defined) \
        ||      defined(bool) \
        ||      defined(S_SPLINT_S)
#       define E4C_BOOL                                         bool
#       define E4C_FALSE                                        false
#       define E4C_TRUE                                         true
# else
#       define E4C_BOOL                                         int
#       define E4C_FALSE                                        0
#       define E4C_TRUE                                         1
# endif


/*
 * The E4C_FUNCTION_NAME_ compile-time parameter
 * could be defined in order to work with some specific compiler.
 */
# ifndef E4C_FUNCTION_NAME_

#       ifdef HAVE_C99_FUNC
#               define E4C_FUNCTION_NAME_               __func__

#       elif defined(__GNUC__)
#               if __GNUC__ >= 2
#                       define E4C_FUNCTION_NAME_       __extension__ __FUNCTION__
#               else
#                       define E4C_FUNCTION_NAME_       NULL
#               endif

#       else
#               define E4C_FUNCTION_NAME_               NULL
#       endif

# endif


/*
 * The E4C_INVALID_SIGNAL_NUMBER_ compile-time parameter
 * could be defined in order to work with some specific compiler.
 */
# ifndef E4C_INVALID_SIGNAL_NUMBER_

#       define E4C_INVALID_SIGNAL_NUMBER_       -1

# endif


/*
 * The E4C_NORETURN_ compile-time parameter
 * could be defined in order to work with some specific compiler.
 */
# ifndef E4C_NORETURN_

#       if defined(__GNUC__)
#               define E4C_NORETURN_                            __attribute__ ((noreturn))
#               define E4C_UNREACHABLE_RETURN_(_value_)

#       elif defined(S_SPLINT_S)
#               define E4C_NORETURN_
#               define E4C_UNREACHABLE_RETURN_(_value_)

#       else
#               define E4C_NORETURN_
#               define E4C_UNREACHABLE_RETURN_(_value_) return _value_
#       endif

# else

#       define E4C_UNREACHABLE_RETURN_(_value_)

# endif


# if defined(HAVE_POSIX_SIGSETJMP) || defined(HAVE_SIGSETJMP)
#       define E4C_CONTINUATION_BUFFER_         sigjmp_buf
#       define E4C_CONTINUATION_CREATE_(_continuation_) \
    (void)sigsetjmp(_continuation_->buffer, 1)
# else
#       define E4C_CONTINUATION_BUFFER_         jmp_buf
#       define E4C_CONTINUATION_CREATE_(_continuation_) \
    (void)setjmp(_continuation_->buffer)
# endif


# ifndef NDEBUG
#       define E4C_INFO_FILE_                           __FILE__
#       define E4C_INFO_LINE_                           __LINE__
#       define E4C_INFO_FUNC_                           E4C_FUNCTION_NAME_
#       define E4C_ASSERT(_condition_) ( \
        (_condition_) \
        ? (void)0 \
        : E4C_THROW(AssertionException, "Assertion failed: " #_condition_) \
                                       )
# else
#       define E4C_INFO_FILE_                           NULL
#       define E4C_INFO_LINE_                           0
#       define E4C_INFO_FUNC_                           NULL
#       define E4C_ASSERT(_ignore_)                     ( (void)0 )
# endif

# define E4C_INFO_ \
    E4C_INFO_FILE_, \
    E4C_INFO_LINE_, \
    E4C_INFO_FUNC_


# define E4C_PASTE_(_x_, _y_, _z_)              _x_ ## _ ## _y_ ## _ ## _z_
# define E4C_MANGLE_(_pre_, _id_, _post_) E4C_PASTE_(_pre_, _id_, _post_)
# define E4C_AUTO_(_id_)                                E4C_MANGLE_(_implicit, _id_, __LINE__)


# ifdef E4C_THREADSAFE
#       define E4C_VERSION_THREADSAFE_                  1
#       define E4C_VERSION_THREADSAFE_STRING_   " (multi-thread)"
# else
#       define E4C_VERSION_THREADSAFE_                  0
#       define E4C_VERSION_THREADSAFE_STRING_   " (single-thread)"
# endif


# define E4C_VERSION_STRING_(_major_, _minor_, _revision_) \
    #_major_ "." #_minor_ "." #_revision_ E4C_VERSION_THREADSAFE_STRING_
# define E4C_VERSION_NUMBER_(_major_, _minor_, _revision_) ( \
        ( (long)E4C_VERSION_THREADSAFE_ * 10000000L) +  \
        ( (long)_major_                                 * 1000000L) +   \
        ( (long)_minor_                                 * 1000L) +              \
        ( (long)_revision_                              * 1L)                   \
                                                           )
# define E4C_VERSION_MAJOR_(_major_, _minor_, _revision_) ( (int)_major_ )
# define E4C_VERSION_MINOR_(_major_, _minor_, _revision_) ( (int)_minor_ )
# define E4C_VERSION_REVISION_(_major_, _minor_, _revision_) ( (int)_revision_ )


/*
 * These undocumented macros hide implementation details from documentation.
 */

# define E4C_FRAME_LOOP_(_stage_) \
    E4C_CONTINUATION_CREATE_( e4c_frame_first_stage_(_stage_, E4C_INFO_) ); \
    while( e4c_frame_next_stage_() )

# define E4C_TRY \
    E4C_FRAME_LOOP_(e4c_acquiring_) \
    if( ( e4c_frame_get_stage_(E4C_INFO_) == e4c_trying_ ) \
            && e4c_frame_next_stage_() )
/* simple optimization: e4c_frame_next_stage_ will avoid disposing stage */

# define E4C_CATCH(_exception_type_) \
    else if( e4c_frame_catch_(&_exception_type_, E4C_INFO_) )

# define E4C_FINALLY \
    else if( e4c_frame_get_stage_(E4C_INFO_) == e4c_finalizing_ )

# define E4C_THROW(_exception_type_, _message_) \
    e4c_exception_throw_verbatim_(&_exception_type_, E4C_INFO_, _message_ )

# define E4C_WITH(_resource_, _dispose_) \
    E4C_FRAME_LOOP_(e4c_beginning_) \
    if( e4c_frame_get_stage_(E4C_INFO_) == e4c_disposing_ ){ \
        _dispose_( \
                   /*@-usedef@*/ (_resource_) /*@=usedef@*/, \
                   (e4c_get_status() == e4c_failed) \
                 ); \
    }else if( e4c_frame_get_stage_(E4C_INFO_) == e4c_acquiring_ ){
/*
 * Splint detects _resource_ being used before it is defined,
 * but we *really* do define it before using, so we need to
 * disable this check (usedef) for this specific parameter.
 */

# define E4C_USE \
    }else if( e4c_frame_get_stage_(E4C_INFO_) == e4c_trying_ )

# define E4C_USING(_type_, _resource_, _args_) \
    E4C_WITH( (_resource_), e4c_dispose_##_type_){ \
        (_resource_) = e4c_acquire_##_type_ _args_; \
    }E4C_USE

# define E4C_REUSING_CONTEXT(_status_, _on_failure_) \
    \
    volatile E4C_BOOL               E4C_AUTO_(BEGIN)        = !e4c_context_is_ready(); \
    volatile E4C_BOOL               E4C_AUTO_(DONE)         = E4C_FALSE; \
    \
    if( E4C_AUTO_(BEGIN) ){ \
        e4c_context_begin(E4C_FALSE, NULL); \
        E4C_TRY{ \
            goto E4C_AUTO_(PAYLOAD); \
            E4C_AUTO_(CLEANUP): \
                E4C_AUTO_(DONE) = E4C_TRUE; \
        }E4C_CATCH(RuntimeException){ \
            (_status_) = (_on_failure_); \
        } \
        e4c_context_end(); \
        E4C_AUTO_(DONE)         = E4C_TRUE; \
        E4C_AUTO_(BEGIN)        = E4C_FALSE; \
    } \
    \
    E4C_AUTO_(PAYLOAD): \
        for(; !E4C_AUTO_(DONE) || E4C_AUTO_(BEGIN); E4C_AUTO_(DONE) = E4C_TRUE) \
            if( E4C_AUTO_(DONE) ){ \
            goto E4C_AUTO_(CLEANUP); \
        }else

# define E4C_USING_CONTEXT(_handle_signals_, _uncaught_handler_) \
    \
    for( \
            e4c_context_begin( (_handle_signals_), (_uncaught_handler_) ); \
            e4c_context_is_ready(); \
            e4c_context_end() \
       )

# ifdef HAVE_C99_VARIADIC_MACROS
#       define E4C_THROWF(_exception_type_, _format_, ...) \
    e4c_exception_throw_format_( \
                                 &_exception_type_, E4C_INFO_, _format_, __VA_ARGS__ \
                               )
# endif

# define E4C_RETHROW(_message_) \
    e4c_exception_throw_verbatim_( \
                                   ( \
                                     e4c_get_exception() == NULL \
                                     ? &NullPointerException \
                                     : e4c_get_exception()->type \
                                   ), \
                                   E4C_INFO_, _message_ \
                                 )

# ifdef HAVE_C99_VARIADIC_MACROS
#       define E4C_RETHROWF(_format_, ...) \
    e4c_exception_throw_format_( \
                                 ( e4c_get_exception() == NULL ? NULL : e4c_get_exception()->type), \
                                 E4C_INFO_, _format_, __VA_ARGS__ \
                               )
# endif

# define E4C_RETRY(_max_retry_attempts_) \
    e4c_frame_repeat_(_max_retry_attempts_, e4c_acquiring_, E4C_INFO_)

# define E4C_REACQUIRE(_max_acquire_attempts_) \
    e4c_frame_repeat_(_max_acquire_attempts_, e4c_beginning_, E4C_INFO_)


/**
 * @name Exception handling keywords
 *
 * This set of keywords express the semantics of exception handling.
 *
 * @{
 */

/**
 * Introduces a block of code aware of exceptions
 *
 * @note
 * The exception context must be ready prior to using the keyword @c try.
 *
 * @see     catch
 * @see     finally
 */
# ifndef E4C_NOKEYWORDS
# define try E4C_TRY
# endif

/**
 * Introduces a block of code capable of handling a specific type of exceptions
 *
 * @param   _exception_type_
 *          The type of exceptions to be handled
 *
 * @c catch blocks are optional code blocks that must be preceded by @c try,
 * @c with/use or @c using blocks. Several @c catch blocks can be placed next to
 * one another.
 *
 * When an exception is thrown from a @c try block, the system looks for a
 * @c catch block to handle it. The first capable block (in order of appearance)
 * will be executed and the exception is said to be @e caught.
 *
 * The caught exception can be accessed through the function
 * @c e4c_get_exception.
 *
 * If a @c catch block handles (at @e compile-time) a generic type of
 * exceptions, the specific type of the actual exception can be determined (at
 * @e run-time) by comparing the @c type of the caught exception against the
 * type of another exceptions previously defined in the program.
 *
 * @code
 * try{
 *    ...
 * }catch(RuntimeException){
 *    const e4c_exception * exception = e4c_get_exception();
 *    if(exception->type == SignalException.type){
 *        ...
 *    }else if(exception->type == NotEnoughMemoryException.type){
 *        ...
 *    }
 * }
 * @endcode
 *
 * However, this check compares the exception against a specific type. So, if
 * the thrown exception was a @e subtype of the given exception type, this
 * comparison would then yield @c false. For example, in the previous example,
 * if the thrown exception was of type @c #BadPointerException: it would be
 * caught by the @c catch block, because an instance of a
 * @c #BadPointerException is also an instance of a @c #RuntimeException, but
 * the comparison:
 *
 * @code
 * (exception->type == &SignalException)
 * @endcode
 *
 * will yield @c false because the type of the thrown exception was not
 * <em>strictly speaking</em> @c #SignalException, but @c #BadPointerException.
 *
 * There is a more powerful way to find out if the thrown exception <strong>is
 * an instance of</strong> a given type of exception <em>or any subtype</em>.
 * The function @c #e4c_is_instance_of determines that:
 *
 * @code
 * try{
 *    ...
 * }catch(RuntimeException){
 *    const e4c_exception * exception = e4c_get_exception();
 *    if( e4c_is_instance_of(exception, &SignalException) ){
 *        ...
 *    }else if(exception->type == &NotEnoughMemoryException){
 *        ...
 *    }
 * }
 * @endcode
 *
 * In this example, the @c if condition would evaluate to @c true, because a
 * @c #BadPointerException <strong>is an instance of a</strong>
 * @c #RuntimeException.
 *
 * After the @c catch block completes, the @c finally block (if any) is
 * executed. Then the program continues with the next line following the set of
 * @c try/catch/finally blocks.
 *
 * However, if an exception is thrown in a @c catch block, then the @c finally
 * block will be executed right away and the system will look for an outter
 * @c catch block to handle it.
 *
 * Only one of all the @c catch blocks will be executed for each @c try block,
 * even though the executed @c catch block throws another exception. The only
 * possible way to execute more than one @c catch block would be by
 * <code>#retry</code>ing the entire @c try block.
 *
 * @see     e4c_exception_type
 * @see     e4c_get_exception
 */
# ifndef E4C_NOKEYWORDS
# define catch(_exception_type_) E4C_CATCH(_exception_type_)
# endif

/**
 * Introduces a block of code responsible for cleaning up the previous @c #try
 * block
 *
 * @c finally blocks are optional code blocks that must be preceded by @c #try,
 * @c with/use or @c using blocks. It is allowed to place, at most, one
 * @c finally block.
 *
 * The @c finally block can determine the completeness of the exception-aware
 * block through the function @c #e4c_get_status. The thrown exception (if any)
 * can also be accessed through the function @c e4c_get_exception.
 *
 * @code
 * try{
 *    ...
 * }finally{
 *    switch( e4c_get_status() ){
 *
 *        case e4c_succeeded:
 *            ...
 *            break;
 *
 *        case e4c_recovered:
 *            ...
 *            break;
 *
 *        case e4c_failed:
 *            ...
 *            break;
 *    }
 * }
 * @endcode
 *
 * The finally block will be executed only @b once. The only possible way to be
 * executed again would be by <code>#retry</code>ing the entire @c try block.
 *
 * @see     e4c_exception
 * @see     e4c_get_exception
 * @see     e4c_get_status
 * @see     e4c_status
 */
# ifndef E4C_NOKEYWORDS
# define finally E4C_FINALLY
# endif

/**
 * Repeats the previous @c try (or @c use) block entirely
 *
 * @param   _max_retry_attempts_
 *          The maximum number of attempts to retry
 *
 * This macro discards any thrown exception (if any) and repeats the previous
 * @c try or @c use block, up to a specified maximum number of attempts.
 *
 * This macro is intended to be used in @c catch or @c finally blocks as a quick
 * way to fix an error condition and <em>try again</em>.
 *
 * @code
 * const char * file_path = config_get_user_defined_file_path();
 * try{
 *     config = read_config(file_path);
 * }catch(ConfigException){
 *     file_path = config_get_default_file_path();
 *     retry(1);
 *     rethrow("Wrong defaults.");
 * }
 * @endcode
 *
 * @warning
 * If the specified maximum number of attempts is zero, then the block can
 * eventually be attempted an unlimited number of times. Care must be taken in
 * order not to create an <em>infinite loop</em>.
 *
 * This macro won't return control unless the block has already been attempted,
 * at least, the specified maximum number of times.
 *
 * @note
 * At a @c #catch block, the current exception is considered caught, whether the
 * @c retry takes place or not. If you want the exception to be propagated when
 * the maximum number of attempts has been reached, then you must @c #rethrow it
 * again.
 *
 * @code
 * int dividend = 100;
 * int divisor = 0;
 * int result = 0;
 * try{
 *     result = dividend / divisor;
 *     do_something(result);
 * }catch(RuntimeException){
 *     divisor = 1;
 *     retry(1);
 *     rethrow("Error (not a division by zero).");
 * }
 * @endcode
 *
 * @note
 * At a @c #finally block, the current exception (if any) will be propagated if
 * the @c retry does not take place, so you don't need to @c #rethrow it again.
 *
 * @code
 * int dividend = 100;
 * int divisor = 0;
 * int result = 0;
 * try{
 *     result = dividend / divisor;
 *     do_something(result);
 * }finally{
 *     if( e4c_get_status() == e4c_failed ){
 *         divisor = 1;
 *         retry(1);
 *         // when we get here, the exception will be propagated
 *     }
 * }
 * @endcode
 *
 * @see     reacquire
 * @see     try
 */
# ifndef E4C_NOKEYWORDS
#       define retry(_max_retry_attempts_) E4C_RETRY(_max_retry_attempts_)
# endif

/**
 * Signals an exceptional situation represented by an exception object
 *
 * @param   _exception_type_
 *          The type of exception to be thrown
 * @param   _message_
 *          The @e ad-hoc message describing the exception. If @c NULL, then the
 *          default message for the specified exception type will be used
 *
 * Creates a new instance of the specified type of exception and then throws it.
 * The provided message is copied into the thrown exception, so it can be freely
 * deallocated. If @c NULL is passed, then the default message for that type of
 * exception will be used.
 *
 * When an exception is thrown, the exception handling framework looks for the
 * appropriate @c catch block that can handle the exception. The system unwinds
 * the call chain of the program and executes the @c finally blocks it finds.
 *
 * When no @c catch block is able to handle an exception, the system eventually
 * gets to the main function of the program. This situation is called an
 * <strong><em>uncaught exception</em></strong>.
 *
 * @see     throwf
 * @see     rethrow
 * @see     e4c_exception_type
 * @see     e4c_exception
 * @see     e4c_uncaught_handler
 * @see     e4c_get_exception
 */
# ifndef E4C_NOKEYWORDS
# define throw(_exception_type_, _message_) \
    E4C_THROW(_exception_type_, _message_)
# endif

/**
 * Throws again the currently thrown exception, with a new message
 *
 * @param   _message_
 *          The new message describing the exception. It should be more specific
 *          than the current one
 *
 * This macro creates a new instance of the thrown exception, with a more
 * specific message.
 *
 * @c rethrow is intended to be used in a @c catch block and the purpose is to
 * refine the message of the currently caught exception. The previous exception
 * (and its message) will be stored as the @e cause of the newly thrown
 * exception.
 *
 * @code
 * try{
 *     image = read_file(file_path);
 * }catch(FileOpenException){
 *     rethrow("Image not found.");
 * }
 * @endcode
 *
 * The semantics of this macro are the same as for the @c #throw macro.
 *
 * @see     throw
 * @see     rethrowf
 */
# ifndef E4C_NOKEYWORDS
#       define rethrow(_message_) E4C_RETHROW(_message_)
# endif

/** @} */

/**
 * @name Dispose pattern keywords
 *
 * This set of keywords express the semantics of automatic resource acquisition
 * and disposal.
 *
 * @{
 */

/**
 * Opens a block of code with automatic disposal of a resource
 *
 * @param   _resource_
 *          The resource to be disposed
 * @param   _dispose_
 *          The name of the disposal function (or macro)
 *
 * The @c with keyword is used to encapsulate the <em>Dispose Pattern</em>. It
 * must be followed by the @c #use keyword.
 *
 * In addition, the @c use block can precede @c #catch and @c #finally blocks.
 *
 * @note
 * The exception context must be ready prior to using the keyword @c with.
 *
 * This pattern consists of two separate blocks and an implicit call to a
 * given function:
 *
 * <ol>
 *      <li>the @c with block is responsible for the resource acquisition</li>
 *      <li>the @c use block makes use of the resource</li>
 *      <li>the disposal function will be called implicitly</li>
 * </ol>
 *
 * The @c with keyword guarantees that the disposal function will be called
 * <strong>if and only if</strong> the acquisition block @e completed without an
 * error (i.e. no exception being thrown from the acquisition block).
 *
 * If the @c with block does not complete, then neither the disposal function
 * nor the @c use block will be ever executed.
 *
 * The disposal function is called right after the @c use block. If an exception
 * was thrown, the @c catch  or @c finally blocks (if any) will take place
 * @b after the disposal of the resource.
 *
 * When called, the disposal function will receive two arguments:
 *
 * @li The resource
 * @li A boolean flag indicating if the @c use block did not @e complete
 *
 * This way, different actions can be taken depending on the success or failure
 * of the block. For example, commiting or rolling back a @e transaction
 * resource.
 *
 * Legacy functions can be reused by defining macros. For example, a file
 * resource needs to be closed regardless of the errors. Since the function
 * @c fclose only takes one parameter, we could define the next macro:
 *
 * @code
 * # define e4c_dispose_file(_file_, _failed_) fclose(_file_)
 * @endcode
 *
 * The typical usage of a @c with block will be:
 *
 * @code
 * with(foo, e4c_dispose_foo){
 *     foo = e4c_acquire_foo(foobar);
 *     someAssertion(foo, bar);
 *     ...
 * }use{
 *     doSomething(foo);
 *     ...
 * }catch(FooAcquisitionFailed){
 *     recover1();
 *     ...
 * }catch(somethingElseFailed){
 *     recover2();
 *     ...
 * }finally{
 *     cleanup();
 *     ...
 * }
 * @endcode
 *
 * Nonetheless, one-liners fit nicely too:
 *
 * @code
 * with(foo, e4c_dispose_foo) foo = e4c_acquire_foo(bar, foobar); use doSomething(foo);
 * @endcode
 *
 * There is a way to lighten up even more this pattern by defining convenience
 * macros, customized for a specific kind of resources. For example,
 * @c #e4c_using_file or @c #e4c_using_memory.
 *
 * @see     use
 * @see     using
 * @see     e4c_using_if_not_null
 * @see     e4c_using_memory
 * @see     e4c_using_file
 */
# ifndef E4C_NOKEYWORDS
# define with(_resource_, _dispose_) E4C_WITH(_resource_, _dispose_)
# endif

/**
 * Closes a block of code with automatic disposal of a resource
 *
 * A @c use block must always be preceded by a @c with block. These two macros
 * are designed so the compiler will complain about @e dangling @c with or
 * @c use blocks.
 *
 * A code block introduced by the @c use keyword will only be executed when the
 * acquisition of the resource @e completes without any exception.
 *
 * Either if the @c use block completes or not, the disposal function will be
 * executed right away.
 *
 * @see     with
 */
# ifndef E4C_NOKEYWORDS
# define use E4C_USE
# endif

/**
 * Introduces a block of code with automatic acquisition and disposal of a
 * resource
 *
 * @param   _type_
 *          The type of the resource
 * @param   _resource_
 *          The resource to be acquired, used and then disposed
 * @param   _args_
 *          A list of arguments to be passed to the acquisition function
 *
 * The specified resource will be acquired, used and then disposed. The
 * automatic acquisition and disposal is achieved by calling the @e magic
 * functions:
 *
 * @li <code>_type_ e4c_acquire_<em>_type_</em>(_args_)</code>
 * @li <code>void e4c_dispose<em>_type_</em>(_resource_, _failed_)</code>
 *
 * The resource will be acquired implicitly by assigning to it the result of the
 * @e magic acquisition function <code>e4c_acquire_<em>_type_</em></code>.
 *
 * @note
 * The exception context must be ready prior to using the keyword @c #using.
 *
 * The semantics of the automatic acquisition and disposal are the same as for
 * blocks introduced by the keyword @c #with. For example, a @c using block
 * can also precede @c catch and @c finally blocks.
 *
 * @see     with
 * @see     e4c_using_if_not_null
 * @see     e4c_using_memory
 * @see     e4c_using_file
 */
# ifndef E4C_NOKEYWORDS
# define using(_type_, _resource_, _args_) E4C_USING(_type_, _resource_, _args_)
# endif

/**
 * Repeats the previous @c with block entirely
 *
 * @param   _max_acquire_attempts_
 *          The maximum number of attempts to reacquire
 *
 * This macro discards any thrown exception (if any) and repeats the previous
 * @c with block, up to a specified maximum number of attempts. If the
 * acquisition completes, then the @c use block will be executed.
 *
 * It is intended to be used in @c catch or @c finally blocks, next to a
 * @c #with... @c #use or @c #using block when the resource acquisition failed,
 * as a quick way to fix an error condition and try to acquire the resource
 * again.
 *
 * @code
 * image_type * image;
 * const char * image_path = image_get_user_avatar();
 * with(image, e4c_image_dispose){
 *     image = e4c_image_acquire(image_path);
 * }use{
 *     image_show(image);
 * }catch(ImageNotFoundException){
 *     image_path = image_get_default_avatar();
 *     reacquire(1);
 * }
 * @endcode
 *
 * @warning
 * If the specified maximum number of attempts is zero, then the @c with block
 * can eventually be attempted an unlimited number of times. Care must be taken
 * in order not to create an <em>infinite loop</em>.
 *
 * This macro won't return control unless the @c with block has already been
 * attempted, at least, the specified maximum number of times.
 *
 * @note
 * Once the resource has been acquired, the @c use block can also be repeated
 * @e alone through the @c #retry macro.
 *
 * @code
 * image_type * image;
 * const char * image_path = image_get_user_avatar();
 * display_type * display = display_get_user_screen();
 * with(image, e4c_image_dispose){
 *     image = e4c_image_acquire(image_path);
 * }use{
 *     image_show(image, display);
 * }catch(ImageNotFoundException){
 *     image_path = image_get_default_avatar();
 *     reacquire(1);
 * }catch(DisplayException){
 *     display = display_get_default_screen();
 *     retry(1);
 * }
 * @endcode
 *
 * @see     retry
 * @see     with
 * @see     use
 */
# ifndef E4C_NOKEYWORDS
#       define reacquire(_max_acquire_attempts_) \
    E4C_REACQUIRE(_max_acquire_attempts_)
# endif

/** @} */

/*
 * Binds the acquisition of memory to the standard function malloc
 */
# define e4c_acquire_memory malloc

/*
 * Binds the disposal of memory to the standard function malloc
 */
# define e4c_dispose_memory(_buffer_, _failed_) free(_buffer_)

/*
 * Binds the acquisition of file to the standard function fopen
 */
# define e4c_acquire_file fopen

/*
 * Binds the disposal of memory to the standard function fclose
 */
# define e4c_dispose_file(_file_, _failed_) fclose(_file_)

/**
 * @name Convenience macros for acquiring and disposing resources
 *
 * These macros let you acquire and dispose different kinds of resources
 * according to the <em>dispose pattern</em>.
 *
 * @{
 */

/**
 * Introduces a block of code with automatic acquisition and disposal of a
 * memory buffer
 *
 * @param   _buffer_
 *          The buffer to be acquired, used and then disposed
 * @param   _bytes_
 *          The amount of memory to be allocated (in bytes)
 *
 * This macro lets you acquire and dispose memory according to the
 * <em>dispose pattern</em>:
 *
 * @code
 * void * buffer;
 *
 * e4c_using_memory(buffer, 1024){
 *     // implicit: buffer = malloc(1024);
 *     memset(buffer, 0, 1024);
 *     // implicit: free(buffer);
 * }
 * @endcode
 *
 * If @c malloc returns @c NULL then the exception @c NotEnoughMemoryException
 * will be automatically thrown.
 *
 */
# define e4c_using_memory(_buffer_, _bytes_) \
    e4c_using_if_not_null(memory, _buffer_, (_bytes_), \
                          NotEnoughMemoryException, "Could not allocate memory for '" #_buffer_ "'.")

/**
 * Introduces a block of code with automatic acquisition and disposal of a
 * file stream
 *
 * @param   _file_
 *          The file to be acquired, used and then disposed
 * @param   _path_
 *          The path of the file to be opened
 * @param   _mode_
 *          The access mode for the file
 *
 * This macro lets you acquire and dispose (open and close) files according to
 * the <em>dispose pattern</em>:
 *
 * @code
 * FILE * file;
 *
 * e4c_using_file(file, "log.txt", "a"){
 *     // implicit: file = fopen("log.txt", "a");
 *     fputs("hello, world!\n", file);
 *     // implicit: fclose(file);
 * }
 * @endcode
 *
 * If @c fopen returns @c NULL then the exception @c #FileOpenException will be
 * automatically thrown.
 *
 * The specific cause of the error can be determined by checking the
 * @c error_number of the thrown exception (it captures the value of @c errno).
 *
 */
# define e4c_using_file(_file_, _path_, _mode_) \
    e4c_using_if_not_null( file, _file_, (_path_, _mode_), \
                           FileOpenException, "Could not open file: " #_path_)

/**
 * Introduces a block of code with automatic disposal of a resource and
 * acquisition, under certain condition
 *
 * @param   _type_
 *          The type of the resource
 * @param   _resource_
 *          The resource to be acquired, used and then disposed
 * @param   _args_
 *          A list of arguments to be passed to the acquisition function
 * @param   _cond_
 *          The condition which has to be satisfied in order to consider the
 *          acquisition @e complete
 * @param   _exception_
 *          The exception to be thrown if the acquisition function does not
 *          satisfy the specified condition
 * @param   _msg_
 *          The exception message
 *
 * This macro will attempt the acquisition of the resource and then will check
 * the given condition. If the condition evaluates to @c false, then the
 * specified exception will be thrown, and therefore, the disposal of the
 * resource will not take place.
 *
 * This is a convenience macro for reusing legacy C standard functions which
 * don't throw exceptions when the acquisition fails. For example:
 *
 * @code
 * # define e4c_acquire_memory malloc
 * # define e4c_dispose_memory(_memory_, _failed_) free(_memory_)
 * # define e4c_using_memory(_resource_, _bytes_) \
 *          e4c_using_if(memory, _resource_, ( _bytes_ ), _resource_ != NULL, \
 *          NotEnoughMemoryException )
 * @endcode
 *
 * @see     using
 */
# define e4c_using_if(_type_, _resource_, _args_, _cond_, _exception_, _msg_) \
    E4C_WITH(_resource_, e4c_dispose_##_type_){ \
        _resource_ = e4c_acquire_##_type_ _args_; \
        if( !(_cond_) ){ \
            E4C_THROW(_exception_, _msg_); \
        } \
    }E4C_USE

/**
 * Introduces a block of code with automatic disposal of a resource and
 * acquisition, preventing null pointers
 *
 * @param   _type_
 *          The type of the resource
 * @param   _resource_
 *          The resource to be acquired, used and then disposed
 * @param   _args_
 *          A list of arguments to be passed to the acquisition function
 * @param   _exception_
 *          The exception to be thrown if the acquisition function yields a
 *          @c NULL pointer
 * @param   _msg_
 *          The exception message
 *
 * @see     e4c_using_if
 */
# define e4c_using_if_not_null(_type_, _resource_, _args_, _exception_, _msg_) \
    e4c_using_if(_type_, _resource_, _args_, _resource_ != NULL, \
                 _exception_, _msg_)

/** @} */

/**
 * @name Integration macros
 *
 * These macros are designed to ease the integration of external libraries which
 * make use of the exception handling system.
 *
 * @{
 */

/**
 * Provides the library version number
 *
 * The library version number is a @c long value which expresses:
 *
 * @li library @e thread mode (either @e single-thread or @e multi-thread)
 * @li library @e major version number
 * @li library @e minor version number
 * @li library @e revision number
 *
 * The multi-thread (or @e thread-safe) mode can be obtained by compiling the
 * library with the @c E4C_THREADSAFE @e compile-time parameter.
 *
 * The formula to encode these version numbers into a single @c long value is:
 *
 * @code
 * THREADSAFE * 10000000 + MAJOR * 1000000 + MINOR * 1000 + REVISION
 * @endcode
 *
 * These numbers can be obtained separately through the next macros:
 *
 * @li @c #E4C_VERSION_THREADSAFE
 * @li @c #E4C_VERSION_MAJOR
 * @li @c #E4C_VERSION_MINOR
 * @li @c #E4C_VERSION_REVISION
 *
 * The library version number can be also obtained as a string literal in the
 * format "MAJOR.MINOR.REVISION (THREADSAFE)" through the @c #E4C_VERSION_STRING
 * macro.
 *
 * @note
 * This version number can be considered as the @e compile-time library version
 * number, as opposed to the @e run-time library version number (associated with
 * the actual, compiled library). This @e run-time version number can be
 * obtained through the @c #e4c_library_version function.
 *
 * @remark
 * The library must be compiled with the corresponding header (i.e. library
 * version number should be equal to header version number).
 *
 * @see     e4c_library_version
 * @see     E4C_VERSION_THREADSAFE
 * @see     E4C_VERSION_MAJOR
 * @see     E4C_VERSION_MINOR
 * @see     E4C_VERSION_REVISION
 * @see     E4C_VERSION_STRING
 */
# define E4C_VERSION_NUMBER \
    \
    E4C_VERSION_(E4C_VERSION_NUMBER_)

/**
 * Provides the library thread mode (either single-thread or multi-thread)
 *
 * When the library is compiled with the @c E4C_THREADSAFE @e compile-time
 * parameter, @c E4C_VERSION_THREADSAFE will yield the @c int value @c 1
 * (meaning @e multi-thread mode), otherwise it will yield the @c int value @c 0
 * (meaning @e single-thread mode).
 *
 * @see     E4C_VERSION_NUMBER
 */
# define E4C_VERSION_THREADSAFE \
    \
    E4C_VERSION_THREADSAFE_

/**
 * Provides the library major version number
 *
 * The library major version number is an @c int value which is incremented from
 * one release to another when there are significant changes in functionality.
 *
 * @see     E4C_VERSION_NUMBER
 */
# define E4C_VERSION_MAJOR \
    \
    E4C_VERSION_(E4C_VERSION_MAJOR_)

/**
 * Provides the library minor version number
 *
 * The library minor version number is an @c int value which is incremented from
 * one release to another when only minor features or significant fixes have
 * been added.
 *
 * @see     E4C_VERSION_NUMBER
 */
# define E4C_VERSION_MINOR \
    \
    E4C_VERSION_(E4C_VERSION_MINOR_)

/**
 * Provides the library revision number
 *
 * The library revision number is an @c int value which is incremented from one
 * release to another when minor bugs are fixed.
 *
 * @see     E4C_VERSION_NUMBER
 */
# define E4C_VERSION_REVISION \
    \
    E4C_VERSION_(E4C_VERSION_REVISION_)

/**
 * Provides the library version number as a string literal
 *
 * The format of the string literal is: "MAJOR.MINOR.REVISION (THREADSAFE)".
 *
 * @see     E4C_VERSION_NUMBER
 */
# define E4C_VERSION_STRING \
    \
    E4C_VERSION_(E4C_VERSION_STRING_)

/**
 * Provides the maximum length (in bytes) of an exception message
 */
# define E4C_EXCEPTION_MESSAGE_SIZE 128

/**
 * Reuses an existing exception context, otherwise, begins a new one and then
 * ends it.
 *
 * @param   _status_
 *          The name of a previously defined variable, or lvalue, which will be
 *          assigned the specified failure value
 * @param   _on_failure_
 *          A constant value or expression that will be assigned to the
 *          specified lvalue in case of failure
 *
 * This macro lets library developers use the exception framework, regardless of
 * whether the library clients are unaware of the exception handling system. In
 * a nutshell, function libraries can use @c #try, @c #catch, @c #throw, etc.
 * whether the client previously began an exception context or not.
 *
 * You <strong>must not use this macro</strong> unless you are implementing some
 * functionality which is to be called from another program, potentially unaware
 * of exceptions.
 *
 * A block introduced by @c e4c_reusing_context is guaranteed to take place
 * @e inside an execution context. When the block completes, the system returns
 * to its previous status (if it was required to open a new exception context,
 * then it will be automatically closed).
 *
 * This way, when an external functions encounters an error, it may either throw
 * an exception (when the caller is aware of the exception system), or otherwise
 * return an error code (when the caller did not open an exception context).
 *
 * @c e4c_reusing_context needs to be given a @c status variable (or @e lvalue)
 * that will be assigned a specified failure value when an exception is thrown
 * inside the block. The failure @e rvalue can be any expression assignable to
 * the specified status @e lvalue.
 *
 * @code
 * int library_public_function(void * pointer, int number){
 *
 *     // We don't know where this function is going to be called from, so:
 *     //   * We cannot use "try", "throw", etc. right here, because the
 *     //   exception context COULD be uninitialized at this very moment.
 *     //   * We cannot call "e4c_context_begin" either, because the
 *     //   exception context COULD be already initialized.
 *     // If we have to make use of the exception handling system, we need to
 *     // "reuse" the existing exception context or "use" a new one.
 *
 *     volatile int status = STATUS_OK;
 *
 *     e4c_reusing_context(status, STATUS_ERROR){
 *
 *         // Now we can safely use "try", "throw", etc.
 *         if(pointer == NULL){
 *             throw(NullPointerException);
 *         }
 *
 *         library_private_function(pointer, number);
 *     }
 *
 *     return(status);
 * }
 * @endcode
 *
 * The status will be left unmodified if the client (i.e. the function caller)
 * is exception-aware, or the block @e completes without an error (i.e. no
 * exception is thrown), so it must be properly initialized before returning it.
 *
 * Please note that the status needs not be just a dichotomy (success or
 * failure). It can be a fine-grained value describing what exactly went wrong.
 * You can pass any expression to @c e4c_reusing_context wich will be evaluated
 * if an exception is thrown.
 *
 * @code
 * int library_public_function(void * pointer, int number){
 *
 *     volatile int status = STATUS_OK;
 *     volatile bool flag = true;
 *
 *     e4c_reusing_context(status, (flag ? STATUS_NULL_POINTER : STATUS_ERROR)){
 *
 *         if(pointer == NULL){
 *             throw(NullPointerException);
 *         }
 *
 *         flag = false;
 *
 *         library_private_function(pointer, number);
 *     }
 *
 *     return(status);
 * }
 * @endcode
 *
 * However, Most of the times you probably want to yield a different status
 * value depending on the specific exception being thrown. This can be easily
 * accomplished by making use of the macro @c E4C_ON_FAILURE.
 *
 * Next, the semantics of @c e4c_reusing_context are explained, step by step.
 *
 * <ul>
 *   <li>
 *   If there is an exception context at the time the block starts:
 *   <ol>
 *     <li>The existing exception context will be reused.</li>
 *     <li>The code block will take place.</li>
 *     <li>
 *       If any exception is thrown during the execution of the block:
 *       <ul>
 *       <li>It will be @b propagated upwards to the caller.</li>
 *       <li>The control will be transferred to the nearest surrounding block of
 *         code which is able to handle that exception.</li>
 *       </ul>
 *     </li>
 *   </ol>
 *   </li>
 *   <li>
 *   If there is no exception context at the time the block starts:
 *   <ol>
 *     <li>A new exception context will be begun; note that the signal handling
 *       system <strong>will NOT be set up.</strong>.</li>
 *     <li>The code block will take place.</li>
 *     <li>
 *       If any exception is thrown during the execution of the block:
 *       <ul>
 *           <li>It will be @b caught.</li>
 *           <li>@c status will be asigned the value of the expression
 *             @c on_failure.</li>
 *       </ul>
 *     </li>
 *   </ol>
 *   </li>
 * </ul>
 *
 * If you need to perform any cleanup, you should place it @e inside a
 * @c #finally block, for example:
 *
 * @code
 * ...
 * e4c_reusing_context(status, STATUS_ERROR){
 *
 *     void * buffer = NULL;
 *     try{
 *         buffer = malloc(1024);
 *         ...
 *     }finally{
 *         free(buffer);
 *     }
 * }
 * ...
 * @endcode
 *
 * If you need to rely on the signal handling system, you may call
 * @c #e4c_context_set_signal_mappings explicitly. You must take into account
 * that you could be @e hijacking your client's original signal mappings, so you
 * should also call @c #e4c_context_get_signal_mappings in order to restore the
 * previous signal mappings when you are done.
 *
 * @code
 * const e4c_signal_mapping new_mappings[] = {
 *     E4C_SIGNAL_MAPPING(SIGABRT, Exception1),
 *     E4C_SIGNAL_MAPPING(SIGINT, Exception2),
 *     E4C_IGNORE_SIGNAL(SIGTERM),
 *     ...
 *     E4C_NULL_SIGNAL_MAPPING
 * };
 * ...
 * e4c_reusing_context(status, STATUS_ERROR){
 *
 *     const e4c_signal_mapping * old_mappings = e4c_context_get_signal_mappings();
 *
 *     e4c_context_set_signal_mappings(new_mappings);
 *
 *     try{
 *         ...
 *     }finally{
 *         e4c_context_set_signal_mappings(old_mappings);
 *     }
 * }
 * ...
 * @endcode
 *
 * This macro only begins a new exception context <strong>if there is no one,
 * already begun, to be used</strong> whereas @c #e4c_using_context always
 * attempts to begin a new one.
 *
 * @warning
 * A block introduced by @c e4c_reusing_context @b cannot be @e broken, through
 * @c goto, @c return nor @c break.
 *
 * @see     e4c_context_begin
 * @see     e4c_context_end
 * @see     e4c_context_is_ready
 * @see     e4c_using_context
 * @see     e4c_exception
 * @see     E4C_ON_FAILURE
 */
# define e4c_reusing_context(_status_, _on_failure_) \
    E4C_REUSING_CONTEXT(_status_, _on_failure_)

/**
 * Provides a means of parsing an exception to obtain a status value
 *
 * @param   _handler_
 *          The name of the parser function to be called
 *
 * This is a handy way to call a function when a @e4c_reusing_context block
 * fails. This function will be passed the current thrown exception; it is
 * expected to parse it and return a proper status value.
 *
 * @code
 * static int parse_exception(const e4c_exception * exception){
 *
 *     if(exception->type == &NotEnoughMemoryException){
 *         return(STATUS_MEMORY_ERROR);
 *     }else if( is_instance_of(exception, &MyException) ){
 *         return(STATUS_MY_ERROR);
 *     }
 *
 *     return(STATUS_ERROR);
 * }
 *
 * int library_public_function(void * pointer, int number){
 *
 *     volatile int status = STATUS_OK;
 *
 *     e4c_reusing_context(status, E4C_ON_FAILURE(parse_exception)){
 *
 *         if(pointer == NULL){
 *             throw(NullPointerException);
 *         }
 *
 *         library_private_function(pointer, number);
 *     }
 *
 *     return(status);
 * }
 * @endcode
 *
 * @see     e4c_reusing_context
 * @see     e4c_get_exception
 * @see     e4c_exception
 */
# define E4C_ON_FAILURE(_handler_) _handler_( e4c_get_exception() )

/**
 * Marks a function which never returns
 *
 * This macro helps both developer and compiler to assume that the marked
 * function will not return the control to its caller (unless by throwing an
 * exception).
 *
 * @note
 * It does not make sense for these functions to have a return type other than
 * @c void.
 *
 * For example, a function @c f1 that @b always throws an exception, could be
 * marked with this macro:
 *
 * @code
 * void f1(int foo) E4C_NORETURN;
 * // ...
 * void f1(int foo){
 *     if(foo == 1){
 *         throw(MyException1, "foo is one.");
 *     }else{
 *         throw(MyException2, "foo is not one.");
 *     }
 * }
 * @endcode
 *
 * Then, if another function tested a condition and then called @c f1, it
 * wouldn't need to return anything witnin the @c if branch, nor consider the
 * @c else branch of the test.
 *
 * @code
 * int f2(int bar, int foo){
 *
 *     if(bar == 0){
 *         f1(foo);
 *         // return(-1);
 *     }// else
 *
 *     return(123);
 *
 * }
 * @endcode
 *
 * If the compiler supports this macro, it could optimize the program and avoid
 * spurious warnings of uninitialized variables.
 *
 * @see     E4C_UNREACHABLE_RETURN
 */
# define E4C_NORETURN \
    \
    E4C_NORETURN_

/**
 * Simulates a function return
 *
 * @param   _value_
 *          The value that would be returned if the statement took place.
 *
 * This macro ensures portability on compilers which don't support functions
 * that never return.
 *
 * It must be used after calling a function marked as @c E4C_NORETURN, so that
 * the compiler will not complain about <em>control reaching end of non-void
 * function</em>. For example:
 *
 * @code
 * void f1(int foo) E4C_NORETURN;
 *
 * int f3(int bar, int foo){
 *
 *     if(bar != 0){
 *         return(123);
 *     }
 *
 *     f1(123);
 *
 *     E4C_UNREACHABLE_RETURN(-1);
 * }
 * @endcode
 *
 * This macro will become an actual @c return statement if the compiler does not
 * support @c E4C_NORETURN, even though it will never be reached (because the
 * called function will never return control).
 *
 * @see     E4C_NORETURN
 */
# define E4C_UNREACHABLE_RETURN(_value_) \
    \
    E4C_UNREACHABLE_RETURN_(_value_)

/** @} */

/**
 * @name Other convenience macros
 *
 * These macros provide a handy way to: begin (and end) implicitly a new
 * exception context, express @e assertions, define and declare exceptions, and
 * define arrays of signal mappings.
 *
 * @{
 */

/**
 * Introduces a block of code which will use a new exception context.
 *
 * @param   _handle_signals_
 *          If @c true, the signal handling system will be set up with the
 *          default mapping.
 * @param   _uncaught_handler_ If not @c NULL, this function will be called in
 *          the event of an uncaught exception.
 *
 * This macro begins a new exception context to be used by the code block right
 * next to it. When the code completes, @c #e4c_context_end will be called
 * implicitly.
 *
 * This macro is very convenient when the beginning and the ending of the
 * current exception context are next to each other. For example, there is no
 * semantic difference between this two blocks of code:
 *
 * @code
 *
 * // block 1
 * e4c_context_begin (E4C_TRUE, NULL);
 * // ...
 * e4c_context_end();
 *
 * // block 2
 * e4c_using_context(E4C_TRUE, NULL){
 *     // ...
 * }
 * @endcode
 *
 * This macro @b always attempts to begin a new exception context, whereas
 * @c #e4c_reusing_context only does if there is no exception context, already
 * begun, to be used.
 *
 * This macro <strong>should be used whenever possible</strong>, rather than
 * doing the explicit, manual calls to @c #e4c_context_begin and
 * @c #e4c_context_end, because it is less prone to errors.
 *
 * @warning
 * A block introduced by @c e4c_using_context @b cannot be @e broken, through
 * @c goto, @c return nor @c break.
 *
 * @see     e4c_context_begin
 * @see     e4c_context_end
 * @see     e4c_reusing_context
 */
# define e4c_using_context(_handle_signals_, _uncaught_handler_) \
    E4C_USING_CONTEXT(_handle_signals_, _uncaught_handler_)

/**
 * Expresses a program assertion
 *
 * @param   _condition_
 *          A predicate that must evaluate to @c true
 *
 * An assertion is a mechanism to express that the developer @e thinks that a
 * specific condition is always met at some point of the program.
 *
 * @c assert is a convenient way to insert debugging assertions into a
 * program. The @c NDEBUG @e compile-time parameter determines whether the
 * assumptions will be actually verified by the program at @e run-time.
 *
 * In presence of @c NDEBUG, the assertion statements will be ignored and
 * therefore will have no effect on the program, not even evaluating the
 * condition. Therefore expressions passed to @c assert must not contain
 * @e side-effects, since they will not take place when debugging is disabled.
 *
 * In absence of @c NDEBUG, the assertion statements will verify that the
 * condition is met every time the program reaches that point of the program.
 *
 * If the assertion does not hold at any time, then an @c AssertionException
 * will be thrown to indicate the programming error. This exception cannot be
 * caught whatsoever. The program (or current thread) will be terminated.
 *
 * The main advantage of using this assertion mechanism (as opposed to the
 * macros provided by the standard header file <code>assert.h</code>) is that
 * before actually exiting the program or thread, all of the pending @c #finally
 * blocks will be executed.
 *
 * @see     AssertionException
 */
# ifndef E4C_NOKEYWORDS
# ifdef assert
/* macro assert is already defined (probably assert.h was included) */
#       error "Please define E4C_NOKEYWORDS at compiler level " \
"in order to prevent exceptions4c from defining the assert macro."
# endif
/*@notfunction@*/
#       define assert(_condition_) \
    E4C_ASSERT(_condition_)
# endif

/**
 * Throws an exception with a formatted message
 *
 * @param   _exception_type_
 *          The type of exception to be thrown
 * @param   _format_
 *          The string containing the specifications that determine the output
 *          format for the variadic arguments
 * @param   ...
 *          The variadic arguments that will be formatted according to the
 *          format control
 *
 * This is a handy way to compose a formatted message and throw an exception
 * <em>on the fly</em>:
 *
 * @code
 * int bytes = 1024;
 * void * buffer = malloc(bytes);
 * if(buffer == NULL){
 *     throwf(NotEnoughMemoryException, "Could not allocate %d bytes.", bytes);
 * }
 * @endcode
 *
 * This macro relies on two features that were introduced in the
 * <strong>ISO/IEC 9899:1999</strong> (also known as @e C99) revision of the C
 * programming language standard in 1999:
 *
 * @li Variadic macros
 * @li Buffer-safe function @c vsnprintf
 *
 * In order not to create compatibility issues, this macro will only be defined
 * when the @c __STDC_VERSION__ @e compile-time parameter is defined as a
 * @c long value <em>greater than or equal to</em> @c 199901L, or when
 * @c HAVE_C99_VARIADIC_MACROS is defined.
 *
 * The semantics of this macro are the same as for the @c #throw macro.
 *
 * @pre         At least one argument must be passed right after the format string.
 *          The message will be composed through the function @c vsnprintf with
 *          the specified format and variadic arguments. For further information
 *          on the formatting rules, you may look up the specifications for the
 *          function @c vsnprintf.
 *
 * @see     throw
 * @see     rethrowf
 */
# if !defined(E4C_NOKEYWORDS) && defined(HAVE_C99_VARIADIC_MACROS)
#       define throwf(_exception_type_, _format_, ...) \
    \
    E4C_THROWF( (_exception_type_), (_format_), __VA_ARGS__ )
# endif

/**
 * Throws again the currently thrown exception, with a new, formatted message
 *
 * @param   _format_
 *          The string containing the specifications that determine the output
 *          format for the variadic arguments.
 * @param   ...
 *          The variadic arguments that will be formatted according to the
 *          format control.
 *
 * This is a handy way to create (and then @c #throw) a new instance of the
 * currently thrown exception, with a more specific, formatted message.
 *
 * @code
 * try{
 *     image = read_file(file_path);
 * }catch(FileOpenException){
 *     rethrowf("Image '%s' not found.", title);
 * }
 * @endcode
 *
 * This macro relies on two features that were introduced in the
 * <strong>ISO/IEC 9899:1999</strong> (also known as @c C99) revision of the C
 * programming language standard in 1999:
 *
 * @li Variadic macros
 * @li Buffer-safe function @c vsnprintf
 *
 * In order not to create compatibility issues, this macro will only be defined
 * when the @c __STDC_VERSION__ @e compile-time parameter is defined as a
 * @c long value <em>greater than or equal to</em> @c 199901L, or when
 * @c HAVE_C99_VARIADIC_MACROS is defined.
 *
 * The semantics of this macro are the same as for the @c #throw macro.
 *
 * @pre         At least one argument must be passed right after the format string.
 *          The message will be composed through the function @c vsnprintf with
 *          the specified format and variadic arguments. For further information
 *          on the formatting rules, you may look up the specifications for the
 *          function @c vsnprintf.
 *
 * @see     rethrow
 * @see     throwf
 */
# if !defined(E4C_NOKEYWORDS) && defined(HAVE_C99_VARIADIC_MACROS)
#       define rethrowf(_format_, ...) \
    \
    E4C_RETHROWF( (_format_), __VA_ARGS__ )
# endif


/**
 * Declares an exception
 *
 * @param   _name_
 *          Name of the new exception
 *
 * This macro introduces the name of an @c extern, @c const exception which will
 * be available to be thrown or caught. It is only a @e declaration (i.e. the
 * exception has to be @e defined somewhere else). This macro is intended to be
 * used inside header files.
 *
 * @see     e4c_exception_type
 * @see     E4C_DEFINE_EXCEPTION
 */
# define E4C_DECLARE_EXCEPTION(_name_) \
    \
    extern const e4c_exception_type _name_

/**
 * Defines an exception
 *
 * @param   _name_
 *          Name of the new exception
 * @param   _message_
 *          Default message of the new exception
 * @param   _super_
 *          Supertype of the new exception
 *
 * This macro allocates a new, @c const exception.
 *
 * @see     e4c_exception_type
 * @see     RuntimeException
 * @see     E4C_DECLARE_EXCEPTION
 */
# define E4C_DEFINE_EXCEPTION(_name_, _message_, _super_) \
    \
    const e4c_exception_type _name_ = { \
                                        #_name_, \
                                        _message_, \
                                        &_super_ \
                                      }

/**
 * Maps a specific signal number to a given exception type
 *
 * @param   _signal_number_
 *          Numeric value of the signal to be converted
 * @param   _exception_type_
 *          Exception type representing the signal
 *
 * This macro represents a signal mapping literal. It comes in handy for
 * initializing arrays of @c e4c_signal_mapping.
 *
 * @see     e4c_signal_mapping
 * @see     e4c_context_set_signal_mappings
 * @see     e4c_context_get_signal_mappings
 * @see     E4C_IGNORE_SIGNAL
 * @see     E4C_NULL_SIGNAL_MAPPING
 * @see     E4C_DECLARE_EXCEPTION
 */
# define E4C_SIGNAL_MAPPING(_signal_number_, _exception_type_) \
    \
    {_signal_number_, &_exception_type_}

/**
 * Ignores a specific signal number
 *
 * @param   _signal_number_
 *          Numeric value of the signal to be ignored
 *
 * This macro represents a signal mapping literal. It comes in handy for
 * initializing arrays of @c e4c_signal_mapping.
 *
 * @see     e4c_signal_mapping
 * @see     e4c_context_set_signal_mappings
 * @see     e4c_context_get_signal_mappings
 * @see     E4C_SIGNAL_MAPPING
 * @see     E4C_NULL_SIGNAL_MAPPING
 * @see     E4C_DECLARE_EXCEPTION
 */
# define E4C_IGNORE_SIGNAL(_signal_number_) \
    \
    {_signal_number_, NULL}

/**
 * Represents a null signal mapping literal
 *
 * This macro comes in handy for terminating arrays of @c e4c_signal_mapping.
 *
 * @see     e4c_signal_mapping
 * @see     e4c_context_set_signal_mappings
 * @see     e4c_context_get_signal_mappings
 * @see     E4C_SIGNAL_MAPPING
 * @see     E4C_IGNORE_SIGNAL
 * @see     E4C_DECLARE_EXCEPTION
 */
# define E4C_NULL_SIGNAL_MAPPING \
    \
    {E4C_INVALID_SIGNAL_NUMBER_, NULL}

/** @} */


/**
 * Represents an exception type in the exception handling system
 *
 * The types of the exceptions a program will use are defined through the macro
 * @c #E4C_DEFINE_EXCEPTION:
 *
 * @code
 * E4C_DEFINE_EXCEPTION(StackException, "Stack overflow", RuntimeException);
 * E4C_DEFINE_EXCEPTION(StackOverflowException, "Stack overflow", StackException);
 * E4C_DEFINE_EXCEPTION(StackUnderflowException, "Stack underflow", StackException);
 * @endcode
 *
 * When defining types of exceptions, they are given a name, a default message
 * and a supertype to organize them into a @e pseudo-hierarchy.
 *
 * Exceptions are usually defined as global objects. There is a set of
 * predefined exceptions built into the framework, and @c #RuntimeException is
 * the root of the exceptions @e pseudo-hierarchy:
 *
 * <ul>
 *     <li>@c #RuntimeException</li>
 *     <ul>
 *         <li>@c #NotEnoughMemoryException</li>
 *         <li>@c #IllegalArgumentException</li>
 *         <li>@c #FileOpenException</li>
 *         <li>@c #IllegalArgumentException</li>
 *         <li>@c #SignalException</li>
 *         <ul>
 *             <li>@c #SignalAlarmException</li>
 *             <li>@c #SignalChildException</li>
 *             <li>@c #SignalTrapException</li>
 *             <li>@c #ErrorSignalException</li>
 *             <ul>
 *                 <li>@c #IllegalInstructionException</li>
 *                 <li>@c #ArithmeticException</li>
 *                 <li>@c #BrokenPipeException</li>
 *                 <li>@c #BadPointerException</li>
 *                 <ul>
 *                     <li>@c #NullPointerException</li>
 *                 </ul>
 *             </ul>
 *             <li>@c #ControlSignalException</li>
 *             <ul>
 *                 <li>@c #StopException</li>
 *                 <li>@c #KillException</li>
 *                 <li>@c #HangUpException</li>
 *                 <li>@c #TerminationException</li>
 *                 <li>@c #AbortException</li>
 *                 <li>@c #CPUTimeException</li>
 *                 <li>@c #UserControlSignalException</li>
 *                 <ul>
 *                     <li>@c #UserQuitException</li>
 *                     <li>@c #UserInterruptionException</li>
 *                     <li>@c #UserBreakException</li>
 *                 </ul>
 *             </ul>
 *             <li>@c #ProgramSignalException</li>
 *             <ul>
 *                 <li>@c #ProgramSignal1Exception</li>
 *                 <li>@c #ProgramSignal2Exception</li>
 *             </ul>
 *         </ul>
 *     </ul>
 * </ul>
 *
 * @see     e4c_exception
 * @see     E4C_DEFINE_EXCEPTION
 * @see     E4C_DECLARE_EXCEPTION
 * @see     throw
 * @see     catch
 */
typedef struct e4c_exception_type_ e4c_exception_type;
struct e4c_exception_type_
{

    /** The name of this exception type */
    /*@observer@*/ /*@notnull@*/
    const char                                     *name;

    /** The default message of this exception type */
    /*@observer@*/
    const char                                              message[E4C_EXCEPTION_MESSAGE_SIZE];

    /** The supertype of this exception type */
    /*@shared@*/ /*@notnull@*/
    const e4c_exception_type               *super;
};

/**
 * Represents an instance of an exception type
 *
 * Exceptions are a means of breaking out of the normal flow of control of a
 * code block in order to handle errors or other exceptional conditions. An
 * exception should be thrown at the point where the error is detected; it may
 * be handled by the surrounding code block or by any code block that directly
 * or indirectly invoked the code block where the error occurred.
 *
 * Exceptions provide information regarding the exceptional situation, such as:
 *
 * @li The exception @e name and @ type
 * @li An @e ad-hoc message (as opposed to the @e default one)
 * @li The exact point of the program where it was thrown (source code file,
 *          line and function name, if available)
 * @li The value of the standard error code @c errno at the time the exception
 *          was thrown
 * @li The @e cause of the exception, which is the previous exception (if any),
 *          when the exception was thrown from a @c catch or @c finally block
 * @li The specific, @e run-time type of the exception, convenient when handling
 *          an abstract type of exceptions in a @c catch block
 *
 * @note
 * @b Any exception can be caught by a block introduced by
 * @c #catch( @c #RuntimeException ), <strong>except for
 * @c #AssertionException</strong>.
 *
 * @see     e4c_exception_type
 * @see     throw
 * @see     catch
 * @see     e4c_get_exception
 * @see     RuntimeException
 * @see     AssertionException
 */
typedef struct e4c_exception_ e4c_exception;
struct e4c_exception_
{

    /** The name of this exception */
    /*@observer@*/ /*@notnull@*/
    const char                                     *name;

    /** The message of this exception */
    /*@exposed@*/
    char                                                    message[E4C_EXCEPTION_MESSAGE_SIZE];

    /** The path of the source code file from which the exception was thrown */
    /*@observer@*/ /*@null@*/
    const char                                     *file;

    /** The number of line from which the exception was thrown */
    int                                                             line;

    /** The function from which the exception was thrown */
    /*@observer@*/ /*@null@*/
    const char                                     *function;

    /** The value of errno at the time the exception was thrown */
    int                                                             error_number;

    /** The type of this exception */
    /*@shared@*/ /*@notnull@*/
    const e4c_exception_type               *type;

    /** The cause of this exception */
    /*@only@*/ /*@null@*/
    e4c_exception                                  *cause;
};

/**
 * Represents a map between a signal and an exception
 *
 * A signal is an asynchronous notification sent by the operating system to a
 * process in order to notify it of an event that occurred. Most of the signals
 * will, by default, crash the program as soon as they are raised.
 * @c @b exceptions4c can convert signals to exceptions, so they can be easily
 * handled.
 *
 * For example, a @e suspicious or @e dangerous part of the program could be
 * wrapped up with @c #try blocks and then @c #catch segmentation faults or
 * divisions by zero. Then the program would clean up and continue normally:
 *
 * @code
 * e4c_using_context(true, e4c_print_exception){
 *     int * pointer = NULL;
 *     try{
 *         int oops = *pointer;
 *     }catch(BadPointerException){
 *         printf("No problem ;-)");
 *     }finally{
 *         // clean up...
 *     }
 * }
 * @endcode
 *
 * In order to perform the conversion, @c @b exceptions4c @e maps signals to
 * exceptions.
 *
 * The simplest way to get this working is by calling the function
 * @c e4c_context_begin. This function will set up the default mappings for the
 * available signals in the platform, when passed
 * @c handle_signals=true.
 *
 * If you need to be more specific about which signals get converted to
 * exceptions, you can define an array of signal mappings:
 *
 * @code
 * const e4c_signal_mapping my_signal_mappings[] = {
 *     E4C_SIGNAL_MAPPING(SIGABRT, Exception1),
 *     E4C_SIGNAL_MAPPING(SIGINT, Exception2),
 *     E4C_IGNORE_SIGNAL(SIGTERM),
 *     ...
 *     E4C_NULL_SIGNAL_MAPPING
 * }
 * @endcode
 *
 * An array of @c signal mappings is defined through the macros
 * @c E4C_SIGNAL_MAPPING, @c E4C_IGNORE_SIGNAL and @c E4C_NULL_SIGNAL_MAPPING.
 * Every @c e4c_signal_mapping array needs to be terminated by the <em>null
 * signal mapping</em> element, so the system finds out how many mappings there
 * are in a given array.
 *
 * Once the array is properly defined, it can be passed to the function
 * @c e4c_context_set_signal_mappings. This way, only the specified signals will
 * be handled as exceptions, and they will be converted to the specified
 * exceptions.
 *
 * Additionally, you can @e ignore specific signals by using
 * @c E4C_IGNORE_SIGNAL instead of @c E4C_SIGNAL_MAPPING. If the specified
 * signal is raised, the system won't convert it to an exception and the program
 * will continue (even if unmeaningful).
 *
 * These are some of the signals you can handle:
 *
 * @li @c SIGFPE when dividing by zero.
 * @li @c SIGSEGV when dereferencing an invalid pointer.
 * @li @c SIGINT when a user interrupts the process.
 * @li @c SIGTERM when a process is requested to be terminated.
 *
 * @see     e4c_context_begin
 * @see     e4c_context_set_signal_mappings
 * @see     e4c_context_get_signal_mappings
 * @see     E4C_SIGNAL_MAPPING
 * @see     E4C_IGNORE_SIGNAL
 * @see     e4c_default_signal_mappings
 */
typedef struct e4c_signal_mapping_ e4c_signal_mapping;
struct e4c_signal_mapping_
{

    /** The signal to be converted */
    int                                                                     signal_number;

    /** The exception representing the signal */
    /*@dependent@*/ /*@null@*/
    const e4c_exception_type *const        exception_type;

};

/**
 * Represents the completeness of a code block aware of exceptions
 *
 * The symbolic values representing the status of a block help to distinguish
 * between different possible situations inside a @c finally block. For example,
 * different cleanup actions can be taken, depending on the status of the block.
 *
 * @code
 * try{
 *    ...
 * }finally{
 *    switch( e4c_get_status() ){
 *
 *        case e4c_succeeded:
 *            ...
 *            break;
 *
 *        case e4c_recovered:
 *            ...
 *            break;
 *
 *        case e4c_failed:
 *            ...
 *            break;
 *    }
 * }
 * @endcode
 *
 * @see     e4c_get_status
 * @see     finally
 */
enum e4c_status_
{

    /** There was no exception */
    e4c_succeeded,

    /** There was an exception, but it was caught */
    e4c_recovered,

    /** There was an exception and it wasn't caught */
    e4c_failed
};
typedef enum e4c_status_ e4c_status;

/**
 * This is the signature of a function which will be executed in the event of an
 * uncaught exception
 *
 * @param   exception
 *          The uncaught exception
 *
 * @warning
 * These functions are not allowed to try and recover the current exception
 * context. Moreover, the program (or current thread) will terminate right after
 * the function returns.
 *
 * @see     e4c_context_begin
 */
typedef void ( *e4c_uncaught_handler )( const e4c_exception *exception )
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
*/
;

/*
 * Next types are undocumented on purpose, in order to hide implementation
 * details, subject to change.
 */
enum e4c_frame_stage_
{
    e4c_beginning_,
    e4c_acquiring_,
    e4c_trying_,
    e4c_disposing_,
    e4c_catching_,
    e4c_finalizing_,
    e4c_done_
};

struct e4c_continuation_
{
    /*@partial@*/ /*@dependent@*/
    E4C_CONTINUATION_BUFFER_                buffer;
};

/**
 * @name Predefined signal mappings
 *
 * There is a predefined set of signal mappings. Signal mappings are used to
 * convert signals into exceptions.
 *
 * Common signals are mapped to its corresponding exception, for example:
 *
 * @li @c SIGABRT is mapped to @c #AbortException
 * @li @c SIGFPE is mapped to @c #ArithmeticException
 * @li @c SIGSEGV is mapped to @c #BadPointerException
 * @li @c SIGTERM is mapped to @c #TerminationException
 * @li ...and so on
 *
 * @see     e4c_signal_mapping
 * @see     e4c_context_begin
 * @see     e4c_context_set_signal_mappings
 * @see     e4c_context_get_signal_mappings
 * @{
 */

/**
 * The array of predefined signal mappings.
 */
/*@unused@*/ /*@unchecked@*/ /*@notnull@*/
extern const e4c_signal_mapping *const e4c_default_signal_mappings;

/** @} */

/**
 * @name Predefined exceptions
 *
 * Built-in exceptions represent usual error conditions that might occur during
 * the course of any program.
 *
 * They are organized into a @e pseudo-hierarchy, being @c #RuntimeException
 * the common @e supertype of all exceptions.
 *
 * @{
 */

/**
 * This is the root of the exception pseudo-hierarchy
 *
 * @c RuntimeException is the common @e supertype of all exceptions.
 *
 * @par     Direct known subexceptions:
 *          #NotEnoughMemoryException,
 *          #FileOpenException,
 *          #IllegalArgumentException,
 *          #SignalException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( RuntimeException );

/**
 * This exception is thrown when the system runs out of memory
 *
 * @c NotEnoughMemoryException is thrown when there is not enough memory to
 * continue the execution of the program.
 *
 * @par     Extends:
 *          #RuntimeException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( NotEnoughMemoryException );

/**
 * This exception is thrown when a function is passed an illegal or
 * inappropriate argument
 *
 * @c IllegalArgumentException is thrown by a function when it detects that some
 * of the function parameters (passed by the caller) is unacceptable.
 *
 * @par     Extends:
 *          #RuntimeException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( IllegalArgumentException );

/**
 * This exception is thrown when an assertion does not hold
 *
 * @c AssertionException is part of the assertion facility of the library. It is
 * thrown when the @e compile-time parameter @c NDEBUG is present and the
 * conditon of an assertion evaluates to @c false.
 *
 * @remark
 * This exception cannot be caught whatsoever. The program (or current thread)
 * will be terminated, after the execution of all pending @c finally blocks.
 *
 * @see     assert
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( AssertionException );

/**
 * This exception is thrown when a file cannot be opened
 *
 * @c FileOpenException is thrown by @c #e4c_using_file when @c fopen returns
 * @c NULL for whatever reason.
 *
 * @note
 * The specific cause of the error can be determined by checking the
 * @c error_number of the exception; it captures the value of @c errno at the
 * time the exception was thrown (right after @c fopen).
 *
 * @par     Extends:
 *          #RuntimeException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( FileOpenException );

/**
 * This exception is the common supertype of all signal exceptions
 *
 * Signal exceptions are thrown when some signal is sent to the process.
 *
 * A signal can be generated by calling @c raise.
 *
 * @par     Extends:
 *          #RuntimeException
 *
 * @par     Direct known subexceptions:
 *          #SignalException,
 *          #SignalAlarmException,
 *          #SignalChildException,
 *          #SignalTrapException,
 *          #ErrorSignalException,
 *          #ControlSignalException,
 *          #ProgramSignalException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( SignalException );

/**
 * This exception is thrown when a time limit has elapsed
 *
 * @c SignalAlarmException represents @c SIGALRM, the signal sent to a process
 * when a time limit has elapsed.
 *
 * @par     Extends:
 *          #SignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( SignalAlarmException );

/**
 * This exception is thrown when a child process terminates
 *
 * @c SignalChildException represents @c SIGCHLD, the signal sent to a process
 * when a child process terminates.
 *
 * @par     Extends:
 *          #SignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( SignalChildException );

/**
 * This exception is thrown when a condition arises that a debugger has
 * requested to be informed of
 *
 * @c SignalTrapException represents @c SIGTRAP, the signal sent to a process
 * when a condition arises that a debugger has requested to be informed of.
 *
 * @par     Extends:
 *          #SignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( SignalTrapException );

/**
 * This exception is the common supertype of all error signal exceptions
 *
 * Error signal exceptions are thrown when some error prevents the program to
 * keep executing its normal flow.
 *
 * @par     Extends:
 *          #SignalException
 *
 * @par     Direct known subexceptions:
 *          #IllegalInstructionException,
 *          #BadPointerException,
 *          #ArithmeticException,
 *          #BrokenPipeException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( ErrorSignalException );

/**
 * This exception is thrown when the process attempts to execute an illegal
 * instruction
 *
 * @c IllegalInstructionException represents @c SIGILL, the signal sent to a
 * process when it attempts to execute a malformed, unknown, or privileged
 * instruction.
 *
 * @par     Extends:
 *          #ErrorSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( IllegalInstructionException );

/**
 * This exception is thrown when the process performs an erroneous arithmetic
 * operation
 *
 * @c ArithmeticException represents @c SIGFPE, the signal sent to a process
 * when it performs an erroneous arithmetic operation.
 *
 * @par     Extends:
 *          #ErrorSignalException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( ArithmeticException );

/**
 * This exception is thrown when the process attempts to write to a broken pipe
 *
 * @c BrokenPipeException represents @c SIGPIPE, the signal sent to a process
 * when it attempts to write to a pipe without a process connected to the other
 * end.
 *
 * @par     Extends:
 *          #ErrorSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( BrokenPipeException );

/**
 * This exception is thrown when the process tries to dereference an invalid
 * pointer
 *
 * @c BadPointerException represents @c SIGSEGV, the signal sent to a process
 * when it makes an invalid memory reference, or segmentation fault.
 *
 * @par     Extends:
 *          #ErrorSignalException
 *
 * @par     Direct known subexceptions:
 *          #NullPointerException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( BadPointerException );

/**
 * This exception is thrown when an unexpected null pointer is found
 *
 * @c NullPointerException is thrown when some part of the program gets a
 * pointer which was expected or required to contain a valid memory address.
 *
 * A @e null pointer exception is a special case of a @e bad pointer exception.
 * The difference between them is that @c #NullPointerException needs to be
 * thrown @e explicitly by some function, while @c #BadPointerException is
 * thrown @e implicitly by the signal handling system.
 *
 * @note
 * Sometimes, a null pointer exception can also be considered as a special case
 * of an <em>illegal argument</em> exception.
 *
 * @par     Extends:
 *          #BadPointerException
 *
 * @see     IllegalArgumentException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( NullPointerException );

/**
 * This exception is the common supertype of all control signal exceptions
 *
 * Control signal exceptions are thrown when the process needs to be controlled
 * by the user or some other process.
 *
 * @par     Extends:
 *          #SignalException
 *
 * @par     Direct known subexceptions:
 *          #StopException,
 *          #KillException,
 *          #HangUpException,
 *          #TerminationException,
 *          #AbortException,
 *          #CPUTimeException,
 *          #UserControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( ControlSignalException );

/**
 * This exception is thrown to stop the process for later resumption
 *
 * @c StopException represents @c SIGSTOP, the signal sent to a process to stop
 * it for later resumption.
 *
 * @remark
 * Since @c SIGSTOP is usually unblock-able, it won't be handled and converted
 * to this exception automatically on some platforms.
 *
 * @par     Extends:
 *          #ControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( StopException );

/**
 * This exception is thrown to terminate the process immediately
 *
 * @c KillException represents @c SIGKILL, the signal sent to a process to cause
 * it to terminate immediately.
 *
 * @remark
 * Since @c SIGKILL is usually unblock-able, it won't be handled and converted
 * to this exception automatically on some platforms.
 *
 * @par     Extends:
 *          #ControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( KillException );

/**
 * This exception is thrown when the process' terminal is closed
 *
 * @c HangUpException represents @c SIGHUP, the signal sent to a process when
 * its controlling terminal is closed.
 *
 * @par     Extends:
 *          #ControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( HangUpException );

/**
 * This exception is thrown to request the termination of the process
 *
 * @c TerminationException represents @c SIGTERM, the signal sent to a process
 * to request its termination.
 *
 * @par     Extends:
 *          #ControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( TerminationException );

/**
 * This exception is thrown to abort the process
 *
 * @c AbortException represents @c SIGABRT, the signal sent by computer programs
 * to abort the process.
 *
 * @par     Extends:
 *          #ControlSignalException
 */
/*@unused@*/ /*@unchecked@*/
E4C_DECLARE_EXCEPTION( AbortException );

/**
 * This exception is thrown when the process has used up the CPU for too long
 *
 * @c CPUTimeException represents @c SIGXCPU, the signal sent to a process when
 * it has used up the CPU for a duration that exceeds a certain predetermined
 * user-settable value.
 *
 * @par     Extends:
 *          #ControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( CPUTimeException );

/**
 * This exception is the common supertype of all control signal exceptions
 * caused by the user
 *
 * User control signal exceptions are thrown when the process needs to be
 * controlled by the user.
 *
 * @par     Extends:
 *          #ControlSignalException
 *
 * @par     Direct known subexceptions:
 *          #UserQuitException,
 *          #UserInterruptionException,
 *          #UserBreakException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( UserControlSignalException );

/**
 * This exception is thrown when the user requests to quit the process
 *
 * @c UserQuitException represents @c SIGQUIT, the signal sent to a process by
 * its controlling terminal when the user requests that the process dump core.
 *
 * @par     Extends:
 *          #UserControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( UserQuitException );

/**
 * This exception is thrown when the user requests to interrupt the process
 *
 * @c UserInterruptionException represents @c SIGINT, the signal sent to a
 * process by its controlling terminal when a user wishes to interrupt it.
 *
 * @par     Extends:
 *          #UserControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( UserInterruptionException );

/**
 * This exception is thrown when a user wishes to break the process
 *
 * @c UserBreakException represents @c SIGBREAK, the signal sent to a process by
 * its controlling terminal when a user wishes to break it.
 *
 * @par     Extends:
 *          #UserControlSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( UserBreakException );

/**
 * This exception is the common supertype of all user-defined signal exceptions
 *
 * User-defined signal exceptions are thrown to indicate user-defined
 * conditions.
 *
 * @par     Extends:
 *          #SignalException
 *
 * @par     Direct known subexceptions:
 *          #ProgramSignal1Exception,
 *          #ProgramSignal2Exception
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( ProgramSignalException );

/**
 * This exception is thrown when user-defined conditions occur
 *
 * @c ProgramSignal1Exception represents @c SIGUSR1, the signal sent to a
 * process to indicate user-defined conditions.
 *
 * @par     Extends:
 *          #ProgramSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( ProgramSignal1Exception );

/**
 * This exception is thrown when user-defined conditions occur
 *
 * @c ProgramSignal2Exception represents @c SIGUSR1, the signal sent to a
 * process to indicate user-defined conditions.
 *
 * @par     Extends:
 *          #ProgramSignalException
 */
/*@unused@*/
E4C_DECLARE_EXCEPTION( ProgramSignal2Exception );

/** @} */

/**
 * @name Exception context handling functions
 *
 * These functions enclose the scope of the exception handling system and
 * retrieve the current exception context.
 *
 * @{
 */

/**
 * Checks if the current exception context is ready
 *
 * @return  Whether the current exception context of the program (or current
 *          thread) is ready to be used.
 *
 * This function returns whether there is an actual exception context ready to
 * be used by the program or current thread.
 *
 * @see     e4c_context_begin
 * @see     e4c_context_end
 * @see     e4c_using_context
 * @see     e4c_reusing_context
 */
/*@unused@*/
extern
E4C_BOOL
e4c_context_is_ready(
    void
)
# ifdef E4C_THREADSAFE
/*@globals
        fileSystem,
        internalState
*/
/*@modifies
        fileSystem,
        internalState
*/
# else
/*@globals
        internalState
@*/
# endif
;

/**
 * Begins an exception context
 *
 * @param   handle_signals
 *          If @c true, the signal handling system will be set up with the
 *          default mapping.
 * @param   uncaught_handler
 *          If not @c NULL, this function will be called in the event of an
 *          uncaught exception.
 *
 * This function begins the current exception context to be used by the program
 * (or current thread), until @c #e4c_context_end is called.
 *
 * Calling @c e4c_context_begin @b twice is considered a programming error, and
 * therefore the program (or thread) will exit abruptly. Nevertheless,
 * @c e4c_context_begin can be called several times <em>if, and only if,</em>
 * @c #e4c_context_end is called in between.
 *
 * The signal handling system can be automatically initialized with the default
 * signal mapping via @c handle_signals parameter when calling
 * @c e4c_context_begin. This is equivalent to:
 *
 * @code
 * e4c_context_set_signal_mappings(e4c_default_signal_mappings);
 * @endcode
 *
 * @warning
 * Note that, on some specific platforms, the behavior of the standard @c signal
 * function might be undefined for a multithreaded program, so use the signal
 * handling system with caution.
 *
 * In addition, a handling function can be specified to be called in the event
 * of an uncaught exception. This function will be called before exiting the
 * program or thread.
 *
 * There exists a convenience function to be used as the default <em>uncaught
 * handler</em>, called @c #e4c_print_exception. This function simply prints
 * information regarding the exception to @c stderr, and then calls @c exit.
 *
 * @see     e4c_context_end
 * @see     e4c_context_is_ready
 * @see     e4c_using_context
 * @see     e4c_reusing_context
 * @see     e4c_uncaught_handler
 * @see     e4c_print_exception
 */
/*@unused@*/
extern
void
e4c_context_begin(
    E4C_BOOL                                        handle_signals,
    /*@shared@*/ /*@null@*/
    e4c_uncaught_handler            uncaught_handler
)
/*@globals
        fileSystem,
        internalState,

        e4c_default_signal_mappings,

        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/**
 * Ends the current exception context
 *
 * This function ends the current exception context.
 *
 * @pre     A program (or thread) @b must begin an exception context prior to
 *          calling @c e4c_context_end. Such programming error will lead to an
 *          abrupt exit of the program (or thread).
 * @see     e4c_context_begin
 * @see     e4c_context_is_ready
 * @see     e4c_using_context
 * @see     e4c_reusing_context
 */
/*@unused@*/
extern
void
e4c_context_end(
    void
)
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/**
 * Assigns the specified signal mappings to the exception context
 *
 * @param   mappings
 *          The array of mappings
 *
 * This function assigns an array of mappings between the signals to be handled
 * and the corresponding exception to be thrown.
 *
 * @warning
 * Note that, on some specific platforms, the behavior of the standard @c signal
 * function might be undefined for a multithreaded program, so use the signal
 * handling system with caution.
 *
 * @pre     A program (or thread) @b must begin an exception context prior to
 *          calling @c e4c_context_set_signal_mappings. Such programming error
 *          will lead to an abrupt exit of the program (or thread).
 * @pre     @c mappings must be terminated by @c E4C_NULL_SIGNAL_MAPPING
 * @see     e4c_signal_mapping
 * @see     e4c_default_signal_mappings
 */
/*@unused@*/
extern
void
e4c_context_set_signal_mappings(
    /*@dependent@*/ /*@null@*/
    const e4c_signal_mapping       *mappings
)
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/**
 * Retrieves the signal mappings for the current exception context
 *
 * @return  The current array of mappings
 *
 * This function retrieves the current array of mappings between the signals to
 * be handled and the corresponding exception to be thrown.
 *
 * @pre     A program (or thread) @b must begin an exception context prior to
 *          calling @c e4c_context_get_signal_mappings. Such programming error
 *          will lead to an abrupt exit of the program (or thread).
 * @see     e4c_signal_mapping
 * @see     e4c_default_signal_mappings
 */
/*@unused@*/
extern
/*@observer@*/ /*@null@*/
const e4c_signal_mapping *
e4c_context_get_signal_mappings(
    void
)
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/**
 * Returns the completeness status of the executing code block
 *
 * @return  The completeness status of the executing code block
 *
 * Exception-aware code blocks have a completeness status regarding the
 * exception handling system. This status determines whether an exception was
 * actually thrown or not, and whether the exception was caught or not.
 *
 * The status of the current block can be obtained any time, provided that the
 * exception context has begun at the time of the function call. However, it is
 * sensible to call this function only during the execution of @c finally
 * blocks.
 *
 * @pre     A program (or thread) @b must begin an exception context prior to
 *          calling @c e4c_get_status. Such programming error will lead to an
 *          abrupt exit of the program (or thread).
 * @see     e4c_get_status
 * @see     finally
 */
/*@unused@*/
extern
e4c_status
e4c_get_status(
    void
)
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
@*/;

/**
 * Returns the exception that was thrown
 *
 * @return  The exception that was thrown in the current exception context (if
 *          any) otherwise @c NULL
 *
 * This function returns a pointer to the exception that was thrown in the
 * surrounding @c exception-aware block, if any; otherwise @c NULL.
 *
 * The function @c e4c_is_instance_of will determine if the thrown exception is
 * an instance of any of the defined exception types. The @c type of the thrown
 * exception can also be compared for an exact type match.
 *
 * @code
 * try{
 *    ...
 * }catch(RuntimeException){
 *    const e4c_exception * exception = e4c_get_exception();
 *    if( e4c_is_instance_of(exception, SignalException.type) ){
 *        ...
 *    }else if(exception->type == NotEnoughMemoryException.type){
 *        ...
 *    }
 * }
 * @endcode
 *
 * The thrown exception can be obtained any time, provided that the exception
 * context has begun at the time of the function call. However, it is sensible
 * to call this function only during the execution of @c #finally or @c #catch
 * blocks.
 *
 * Moreover, a pointer to the thrown exception obtained @e inside a @c finally
 * or @c catch block <strong>must not</strong> be used from the @e outside.
 *
 * The exception system objects are dinamically allocated and deallocated, as
 * the program enters or exits @c try/catch/finally blocks. While it is legal to
 * @b copy the thrown exception and access its name and message outside these
 * blocks, care must be taken in order not to dereference the @c cause of the
 * exception, unless it is a <strong>deep copy</strong> (as opposed to a
 * <strong>shallow copy</strong>).
 *
 * @pre     A program (or thread) @b must begin an exception context prior to
 *          calling @c e4c_get_exception. Such programming error will lead to an
 *          abrupt exit of the program (or thread).
 * @see     e4c_exception
 * @see     e4c_is_instance_of
 * @see     throw
 * @see     catch
 * @see     finally
 */
/*@unused@*/
extern
/*@observer@*/ /*@relnull@*/
const e4c_exception *
e4c_get_exception(
    void
)
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/** @} */

/**
 * @name Other integration and convenience functions
 *
 * @{
 */

/**
 * Gets the library version number
 *
 * @return  The version number associated with the library
 *
 * This function provides the same information as the @c E4C_VERSION_NUMBER
 * macro, but the returned version number is associated with the actual,
 * compiled library.
 *
 * @note
 * This version number can be considered as the @e run-time library version
 * number, as opposed to the @e compile-time library version number (specified
 * by the header file).
 *
 * @remark
 * The library must be compiled with the corresponding header (i.e. library
 * version number should be equal to header version number).
 *
 * @see     E4C_VERSION_NUMBER
 */
/*@unused@*/
extern
long
e4c_library_version(
    void
)
/*@*/
;

/**
 * Returns whether an exception instance is of a given type
 *
 * @param   instance
 *          The thrown exception
 * @param   exception_type
 *          A previously defined type of exceptions
 * @return  Whether the specified exception is an instance of the given type
 *
 * @c e4c_is_instance_of can be used to determine if a thrown exception
 * <strong>is an instance of a given type</strong> defined through
 * @c E4C_DEFINE_EXCEPTION and/or declared through @c E4C_DECLARE_EXCEPTION.
 *
 * This macro is intended to be used in a @c #catch block, or in a @c #finally
 * block provided that some exception was actually thrown (i.e.
 * @c e4c_get_status returned @c e4c_failed or @c e4c_recovered).
 *
 * @code
 * try{
 *    ...
 * }catch(RuntimeException){
 *    const e4c_exception * exception = e4c_get_exception();
 *    if( e4c_is_instance_of(exception, SignalException.type) ){
 *        ...
 *    }else if(exception->type == NotEnoughMemoryException.type){
 *        ...
 *    }
 * }
 * @endcode
 *
 * @pre     @c instance cannot be @c NULL
 * @pre     @c type cannot be @c NULL
 * @throws  NullPointerException
 *          If either @c instance or @c type is @c NULL
 * @see     e4c_exception
 * @see     e4c_exception_type
 * @see     e4c_get_exception
 */
/*@unused@*/
extern
E4C_BOOL
e4c_is_instance_of(
    /*@temp@*/ /*@notnull@*/
    const e4c_exception            *instance,
    /*@temp@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type
)
/*@globals
        fileSystem,
        internalState,

        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/**
 * Prints a fatal error message regarding the specified exception
 *
 * @param   exception
 *          The uncaught exception
 *
 * This is a convenience function for showing an error message through the
 * standard error output. It can be passed to @c #e4c_context_begin or
 * @c #e4c_using_context as the handler for uncaught exceptions.
 *
 * In absence of @c NDEBUG, this function prints as much information regarding
 * the exception as it is available, whereas in presence of @c NDEBUG, only the
 * name and message of the exception are printed.
 *
 * @pre     @c exception cannot be @c NULL
 * @throws  NullPointerException
 *          If @c exception is @c NULL
 */
/*@unused@*/
extern
void
e4c_print_exception(
    /*@temp@*/ /*@notnull@*/
    const e4c_exception            *exception
)
/*@globals
        fileSystem,
        internalState,

        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/**
 * Prints an ASCII graph representing an exception type's hierarchy
 *
 * @param   exception_type
 *          An exception type
 *
 * This is a convenience function for showing an ASCII graph representing an
 * exception type's hierarchy through the standard error output.
 *
 * For example, the output for @c #ProgramSignal2Exception would be:
 *
@verbatim

        Exception hierarchy
        ________________________________________________________________

            RuntimeException
             |
             +--SignalException
                 |
                 +--ProgramSignalException
                     |
                     +--ProgramSignal2Exception
        ________________________________________________________________

@endverbatim
 *
 * @pre     @c exception_type cannot be @c NULL
 * @throws  NullPointerException
 *          If @c exception_type is @c NULL
 */
/*@unused@*/
extern
void
e4c_print_exception_type(
    /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type
)
/*@globals
        fileSystem,
        internalState,

        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/** @} */

/*
 * Next functions are undocumented on purpose, because they shouldn't be used
 * directly (but through the 'keyword' macros).
 */

/*@unused@*/
extern
/*@notnull@*/ /*@temp@*/
struct e4c_continuation_ *
e4c_frame_first_stage_(
    enum e4c_frame_stage_           stage,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function
)
/*@globals
        fileSystem,
        internalState,

        NotEnoughMemoryException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/*@unused@*/
extern
E4C_BOOL
e4c_frame_next_stage_(
    void
)
/*@globals
        fileSystem,
        internalState,

        AssertionException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/*@unused@*/
extern
enum e4c_frame_stage_
e4c_frame_get_stage_(
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function
)
/*@globals
        fileSystem,
        internalState
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/*@unused@*/
extern
E4C_BOOL
e4c_frame_catch_(
    /*@temp@*/ /*@null@*/
    const e4c_exception_type       *exception_type,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function
)
/*@globals
        fileSystem,
        internalState,

        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/*@unused@*/ /*@maynotreturn@*/
extern
void
e4c_frame_repeat_(
    int                                                     max_repeat_attempts,
    enum e4c_frame_stage_           stage,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function
)
/*@globals
        fileSystem,
        internalState,

        AssertionException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
;

/*@unused@*/ /*@noreturn@*/
extern
void
e4c_exception_throw_verbatim_(
    /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function,
    /*@observer@*/ /*@temp@*/ /*@null@*/
    const char                             *message
)
/*@globals
        fileSystem,
        internalState,

        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
E4C_NORETURN;

# if defined(HAVE_C99_VSNPRINTF) || defined(HAVE_VSNPRINTF)

/*@unused@*/ /*@noreturn@*/ extern
void
e4c_exception_throw_format_(
    /*@shared@*/ /*@notnull@*/
    const e4c_exception_type       *exception_type,
    /*@observer@*/ /*@null@*/
    const char                             *file,
    int                                                     line,
    /*@observer@*/ /*@null@*/
    const char                             *function,
    /*@observer@*/ /*@temp@*/ /*@notnull@*/ /*@printflike@*/
    const char                             *format,
    ...
)
/*@globals
        fileSystem,
        internalState,

        NotEnoughMemoryException,
        NullPointerException
@*/
/*@modifies
        fileSystem,
        internalState
@*/
E4C_NORETURN;

# endif


/*@=exportany@*/


# endif

