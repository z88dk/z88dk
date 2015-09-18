/*
Z88DK Z80 Macro Assembler

Debug macros.

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)
*/

#pragma once

#include <stdio.h>
#include <errno.h>
#include <string.h>

/* show warning on stderr */
#define warn(message,...)	fprintf(stderr, message, ##__VA_ARGS__)

/* show error on stderr, exit 1 */
#define die( message,...)	( fprintf(stderr, message, ##__VA_ARGS__), exit(1) )

/* debug message for unit tests */
#ifdef NDEBUG
#define debug(message, ...)
#else
#define debug(message, ...) warn("[DEBUG] (%s:%d) " message "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#endif

/* show errno without allocating memory */
#define STRERROR_FORMAT_	"%s%s"
#define STRERROR_STR_1_		(errno == 0 ? "" : " errno: ")
#define STRERROR_STR_2_		(errno == 0 ? "" : strerror(errno))

/* show error, warning, info */
#define log_(type, message, ...) \
		( \
			warn("[" type  "] (%s:%d" STRERROR_FORMAT_ ") " message "\n", \
			     __FILE__, __LINE__, \
				 STRERROR_STR_1_, STRERROR_STR_2_, \
				 ##__VA_ARGS__), \
			(errno = 0) \
		)
#define log_err(message, ...)	log_("ERROR", message, ##__VA_ARGS__)
#define log_warn(message, ...)	log_("WARN ", message, ##__VA_ARGS__)
#define log_info(message, ...)	log_("INFO ", message, ##__VA_ARGS__)

/* check condition and goto error if false */
#define check(condition, message, ...) \
			do { \
				if ( ! (condition) ) { \
					log_err(message, ##__VA_ARGS__); \
					goto error; \
				} \
			} while (0)

/* check condition and die on error; can be used as expression to return value from condition,
   e.g. ptr = check_ptr_die( malloc(10), != NULL, "malloc failed" ); */
#define check_die_(type, condition, ok_check, message, ...) \
			( (	dbg_push_##type( (condition) ) ok_check ? \
					1 : \
					( log_err(message, ##__VA_ARGS__), \
					  exit(1) \
					) \
			  ), \
			  dbg_pop_##type() \
			)
#define check_int_die(condition, ok_check, message, ...)	\
		check_die_(int, condition, ok_check, message, ##__VA_ARGS__)

#define check_ptr_die(condition, ok_check, message, ...)	\
		check_die_(ptr, condition, ok_check, message, ##__VA_ARGS__)

/* sentinel: assert that line is not reached and goto error otherwise */
#define sentinel(message, ...)	check(0, message, ##__VA_ARGS__)
#define sentinel_die(message, ...)	check_int_die(0, , message, ##__VA_ARGS__)

/* check for not NULL */
#define check_node(node)		check( node != NULL, #node " is NULL" )
#define check_node_die(node)	check_ptr_die( node, != NULL, #node " is NULL" )

/* check for out of memory */
#define check_mem(ptr) 			check(        (ptr),          "Out of memory")
#define check_mem_die(ptr)		check_ptr_die((ptr), != NULL, "Out of memory")

/* check and show message unless NDEBUG */
#define check_debug(condition, message, ...) \
			do { \
				if ( ! (condition) ) { \
					debug(message, ##__VA_ARGS__); \
					errno = 0; \
					goto error; \
				} \
			} while (0)

/* x<FUNC>() macros to call <FUNC>() and die on error */
#define xatexit(func)	\
		check_int_die(atexit(func), == 0, "atexit failed")

#define xfopen(filename, mode)	\
		check_ptr_die(fopen((filename), (mode)), != NULL, "file open %s: failed", (filename))

#define xfclose(file)	\
		check_int_die(fclose(file), == 0, "file close failed")

#define xfputs(str,stream)	\
		check_int_die(fputs((str), (stream)), == 0, "fputs failed")

#define xremove(filename)	\
		check_int_die(remove(filename), == 0, \
					"remove %s failed", filename)

#define xsystem(command)	\
		check_int_die(system(command), == 0, \
					"command %s failed", command)

/* Small stack of int / void* to allow reentrant macros to be build; push returns pushed value */
extern int   dbg_push_int(int value);
extern void *dbg_push_ptr(void *ptr);
extern int   dbg_pop_int(void);
extern void *dbg_pop_ptr(void);
extern int   dbg_peek_int(void);
extern void *dbg_peek_ptr(void);
