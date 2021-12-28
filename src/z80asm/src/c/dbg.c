/*
Z88DK Z80 Macro Assembler

Debug macros.

Based on Learn C the Hard Way book, by Zed. A. Shaw (http://c.learncodethehardway.org/book/)
*/

#include "dbg.h"
#include <stdlib.h>

/*-----------------------------------------------------------------------------
*	Small stack of int / void* to allow reentrant macros to be build
*----------------------------------------------------------------------------*/
#define STACK_SIZE	256
static union {
	int	  int_value;
	void *ptr_value;
} 
stack [ STACK_SIZE ];
static int sp = -1;

/* check over- and underflow; cannot use check() as check() uses this stack */
#define PUSH(elem, value) \
			do { \
				if ( sp+1 >= STACK_SIZE ) { \
					log_err("stack overflow"); \
					exit(1); \
				} \
				return (stack[ ++sp ].elem = value);	/* assign and return */ \
			} while (0)				
 
#define POP(elem) \
			do { \
				if ( sp <  0 ) { \
					log_err("stack underflow"); \
					exit(1); \
				} \
				return stack[ sp-- ].elem; \
			} while (0)				
 
#define PEEK(elem) \
			do { \
				if ( sp <  0 ) { \
					log_err("stack underflow"); \
					exit(1); \
				} \
				return stack[ sp ].elem; \
			} while (0)				
 
int   dbg_push_int(int value)	{ PUSH(int_value, value); }
void *dbg_push_ptr(void *ptr)	{ PUSH(ptr_value, ptr);	  }
int   dbg_pop_int(void)			{ POP(int_value);		  }
void *dbg_pop_ptr(void)			{ POP(ptr_value);		  }
int   dbg_peek_int(void)		{ PEEK(int_value);		  }
void *dbg_peek_ptr(void)		{ PEEK(ptr_value);		  }
