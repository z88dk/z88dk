/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Expression parser based on the shunting-yard algoritm, 
see http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.c,v 1.9 2014-04-12 15:18:03 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "array.h"
#include "expr.h"
#include "errors.h"
#include "init.h"
#include "strhash.h"
#include "strpool.h"
#include <assert.h>

static void init_operator_hash(void);
static void fini_operator_hash(void);

/*-----------------------------------------------------------------------------
*	Initialization
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	init_operator_hash();
}

DEFINE_fini()
{
	fini_operator_hash();
}

/*-----------------------------------------------------------------------------
*	Calculation functions that need to check arguments
*----------------------------------------------------------------------------*/
static long _calc_divide(long a, long b)
{
	if ( b == 0 )
	{
		error_divide_by_zero();	/* BUG_0040 */
		return 0;
	}

	return a / b;
}

static long _calc_mod(long a, long b)
{
	if ( b == 0 )
	{
		error_divide_by_zero();	/* BUG_0040 */
		return 0;
	}

	return a % b;
}

/* exponentiation by squaring */
static long _calc_power(long base, long exp)
{
    long result = 1;

	if (exp < 0)
		return 0;	/* BUG_0041 */

    while (exp)
    {
        if (exp & 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }

    return result;
}

/*-----------------------------------------------------------------------------
*	Calculation functions for all operators, template:
*	long calc_<symbol> (long a [, long b [, long c ] ] );
*----------------------------------------------------------------------------*/
#define OPERATOR(_operation, _tok, _type, _prec, _assoc, _args, _calc)	\
	long calc_##_operation _args { return _calc; }
#include "expr_def.h"

/*-----------------------------------------------------------------------------
*	Operator descriptors
*----------------------------------------------------------------------------*/

/* hash of (tok,op_type) to Operator* */
static StrHash *operator_hash;

/* compute hash key */
static char *operator_hash_key( tokid_t tok, op_type_t op_type )
{
	char key[3];		/* byte 1 = tok; byte 2 = op_type; byte 3 = '\0' */

	/* assert we can map symbol and type in a string */
	assert( tok     > 0 && tok     < 256 );
	assert( op_type > 0 && op_type < 256 );
	key[0] = (char) tok; key[1] = (char) op_type; key[2] = '\0';

	return strpool_add(key);
}

/* init operator_hash - create one Operator for each, add to hash table */
static void init_operator_hash(void)
{
	char *key;

#define OPERATOR(_operation, _tok, _type, _prec, _assoc, _args, _calc)		\
	{																		\
		static Operator op_##_operation;									\
																			\
		/* init static operator structure */								\
		op_##_operation.tok			= _tok;									\
		op_##_operation.op_type		= _type;								\
		op_##_operation.prec		= _prec;								\
		op_##_operation.assoc		= _assoc;								\
		/* cast into unary type, cannot decide union path at compile time */ \
		op_##_operation.calc.unary	= (long(*)(long))calc_##_operation;		\
																			\
		key = operator_hash_key( _tok, _type );								\
		StrHash_set( &operator_hash, key, & op_##_operation );				\
	}
#include "expr_def.h"
}

/* fini operator_hash */
static void fini_operator_hash(void)
{
	StrHash_remove_all( operator_hash );
}


/* get the operator descriptor for the given (tok, op_type) */
Operator *Operator_get( tokid_t tok, op_type_t op_type )
{
	char *key;

	init();
	key = operator_hash_key( tok, op_type );
	return (Operator *) StrHash_get( operator_hash, key );
}

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
static longArray *calc_stack;

void Calc_push( long value )
{
	long *top;

	INIT_OBJ(longArray, &calc_stack);		/* freed by class */

	top = longArray_push(calc_stack);
	*top = value;
}

long Calc_pop( void )
{
	long *top, value;

	INIT_OBJ(longArray, &calc_stack);		/* freed by class */

	top = longArray_top(calc_stack);
	assert( top != NULL );
	value = *top;

	longArray_pop(calc_stack);
	return value;
}

void Calc_compute_unary( long (*calc)(long a) )
{
	long a = Calc_pop();
	long x = calc(a);
	Calc_push(x);
}

void Calc_compute_binary( long (*calc)(long a, long b) )
{
	long b = Calc_pop();
	long a = Calc_pop();
	long x = calc(a,b);
	Calc_push(x);
}

void Calc_compute_ternary( long (*calc)(long a, long b, long c) )
{
	long c = Calc_pop();
	long b = Calc_pop();
	long a = Calc_pop();
	long x = calc(a,b,c);
	Calc_push(x);
}

/*-----------------------------------------------------------------------------
*	Expression operations
*----------------------------------------------------------------------------*/
DEF_ARRAY( ExprOp );

/* init each type of ExprOp */
void ExprOp_init_number( ExprOp *self, long value )
{
	self->op_type	= NUMBER_OP;
	self->d.value	= value;
}

void ExprOp_init_name( ExprOp *self, char *name, byte_t sym_type )
{
	self->op_type 			= NAME_OP;
	self->d.ident.name		= strpool_add(name);
	self->d.ident.sym_type	= sym_type;
}

extern void ExprOp_init_const_expr( ExprOp *self )
{
	self->op_type = CONST_EXPR_OP;
}

void ExprOp_init_operator( ExprOp *self, tokid_t tok, op_type_t op_type )
{
	Operator *op;

	op = Operator_get( tok, op_type ); assert( op != NULL );

	self->op_type	= op_type;
	self->d.op		= op;
}

/* compute ExprOp using Calc_xxx functions */
void ExprOp_compute( ExprOp *self, struct expr *pfixlist )
{
    Symbol *symptr;

	switch (self->op_type)
	{
	case NAME_OP:
		/* symbol was not defined and not declared */
		if ( ( self->d.ident.sym_type & ~ SYM_TOUCHED ) != SYM_NOTDEFINED )
		{
			/* if all bits are set to zero */
			if ( self->d.ident.sym_type & SYM_LOCAL )
			{
				symptr = find_local_symbol( self->d.ident.name );

				/* copy appropriate type bits */
				pfixlist->expr_type |= ( symptr->sym_type & SYM_TYPE );

				Calc_push( symptr->value );
			}
			else
			{
				symptr = find_global_symbol( self->d.ident.name );

				if ( symptr != NULL )
				{
					/* copy appropriate type bits */
					pfixlist->expr_type |= ( symptr->sym_type & SYM_TYPE );

					if ( symptr->sym_type & SYM_DEFINED )
					{
						Calc_push( symptr->value );
					}
					else
					{
						pfixlist->expr_type |= NOT_EVALUABLE;
						Calc_push( 0 );
					}
				}
				else
				{
					pfixlist->expr_type |= NOT_EVALUABLE;
					Calc_push( 0 );
				}
			}
		}
		else
		{
			/* try to find symbol now as either declared local or global */
			symptr = get_used_symbol( self->d.ident.name );

			/* copy appropriate type bits */
			pfixlist->expr_type |= ( symptr->sym_type & SYM_TYPE );

			if ( symptr->sym_type & SYM_DEFINED )
			{
				Calc_push( symptr->value );
			}
			else
			{
				pfixlist->expr_type |= NOT_EVALUABLE;
				Calc_push( 0 );
			}
		}
		break;
		
	case CONST_EXPR_OP:
		pfixlist->expr_type &= ~ EXPR_ADDR;		/* convert to constant expression */
		break;
		
	case NUMBER_OP:	Calc_push( self->d.value ); break;		
	case UNARY_OP:	Calc_compute_unary( self->d.op->calc.unary ); break;
	case BINARY_OP:	Calc_compute_binary( self->d.op->calc.binary ); break;
	case TERNARY_OP:Calc_compute_ternary( self->d.op->calc.ternary ); break;
	
	default:
		assert(0);
	}
}



#if 0



/*-----------------------------------------------------------------------------
*	Stack of values used for expression computation
*----------------------------------------------------------------------------*/
DEF_ARRAY( long );

/*-----------------------------------------------------------------------------
*	Class to hold one parsed expression
*----------------------------------------------------------------------------*/
DEF_CLASS( Expr )

void Expr_init (Expr *self) 
{ 
	
}

void Expr_copy (Expr *self, Expr *other)
{
	
}

void Expr_fini (Expr *self)
{ 
	
}
#endif

/*
* $Log: expr.c,v $
* Revision 1.9  2014-04-12 15:18:03  pauloscustodio
* Add intArray and longArray to array.c
*
* Revision 1.8  2014/03/15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.7  2014/03/04 11:49:47  pauloscustodio
* Expression parser and expression evaluator use a look-up table of all
* supported unary, binary and ternary oprators, instead of a big switch
* statement to select the operation.
* Expression operations are stored in a contiguous array instead of
* a liked list to reduce administrative overhead of adding / iterating.
*
* Revision 1.6  2014/03/03 13:43:50  pauloscustodio
* Renamed symbol and expression type attributes
*
* Revision 1.5  2014/03/03 02:44:15  pauloscustodio
* Division by zero error was causing memory leaks - made non-fatal.
* Moved calculator stack to expr.c, made it singleton and based on array.h - no
* need to allocate on every expression computed, elements are stored in
* a vector instead of being allocated individually.
*
* Revision 1.4  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.3  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.2  2014/02/18 22:59:06  pauloscustodio
* BUG_0040: Detect and report division by zero instead of crashing
* BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
*
* Revision 1.1  2014/02/17 23:36:07  pauloscustodio
* Embryo of new expression parser
*
*
*/
