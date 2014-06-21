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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.c,v 1.20 2014-06-21 02:15:43 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "array.h"
#include "codearea.h"
#include "expr.h"
#include "errors.h"
#include "init.h"
#include "model.h"
#include "strhash.h"
#include "strpool.h"
#include "sym.h"
#include "symtab.h"
#include <assert.h>

/*-----------------------------------------------------------------------------
*	Expression operations
*----------------------------------------------------------------------------*/

/* init each type of ExprOp */
static void ExprOp_init_number(     ExprOp *self, long value );
static void ExprOp_init_name(       ExprOp *self, char *name, Byte sym_type );
static void ExprOp_init_const_expr( ExprOp *self );
static void ExprOp_init_operator(   ExprOp *self, tokid_t tok, op_type_t op_type );

/*-----------------------------------------------------------------------------
*	Initialization
*----------------------------------------------------------------------------*/
static void init_operator_hash(void);
static void fini_operator_hash(void);

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
	static long calc_##_operation _args { return _calc; }
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

void ExprOp_init_name( ExprOp *self, char *name, Byte sym_type )
{
	self->op_type 			= NAME_OP;
	self->d.ident.name		= strpool_add(name);
	self->d.ident.sym_type	= sym_type;
}

void ExprOp_init_const_expr( ExprOp *self )
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
void ExprOp_compute( ExprOp *self, Expr *expr )
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
				expr->expr_type |= ( symptr->sym_type & SYM_TYPE );

				Calc_push( symptr->value );
			}
			else
			{
				symptr = find_global_symbol( self->d.ident.name );

				if ( symptr != NULL )
				{
					/* copy appropriate type bits */
					expr->expr_type |= ( symptr->sym_type & SYM_TYPE );

					if ( symptr->sym_type & SYM_DEFINED )
					{
						Calc_push( symptr->value );
					}
					else
					{
						expr->expr_type |= NOT_EVALUABLE;
						Calc_push( 0 );
					}
				}
				else
				{
					expr->expr_type |= NOT_EVALUABLE;
					Calc_push( 0 );
				}
			}
		}
		else
		{
			/* try to find symbol now as either declared local or global */
			symptr = get_used_symbol( self->d.ident.name );

			/* copy appropriate type bits */
			expr->expr_type |= ( symptr->sym_type & SYM_TYPE );

			if ( symptr->sym_type & SYM_DEFINED )
			{
				Calc_push( symptr->value );
			}
			else
			{
				expr->expr_type |= NOT_EVALUABLE;
				Calc_push( 0 );
			}
		}
		break;
		
	case CONST_EXPR_OP:
		expr->expr_type &= ~ EXPR_ADDR;		/* convert to constant expression */
		break;
		
	case NUMBER_OP:	Calc_push( self->d.value ); break;		
	case UNARY_OP:	Calc_compute_unary( self->d.op->calc.unary ); break;
	case BINARY_OP:	Calc_compute_binary( self->d.op->calc.binary ); break;
	case TERNARY_OP:Calc_compute_ternary( self->d.op->calc.ternary ); break;
	
	default:
		assert(0);
	}
}


/*-----------------------------------------------------------------------------
*	Class to hold one parsed expression
*----------------------------------------------------------------------------*/
DEF_CLASS( Expr );
DEF_CLASS_LIST( Expr );

void Expr_init (Expr *self) 
{ 
    self->rpn_ops = OBJ_NEW( ExprOpArray );
	OBJ_AUTODELETE( self->rpn_ops ) = FALSE;

    self->text = OBJ_NEW( Str );
	OBJ_AUTODELETE( self->text ) = FALSE;

    self->expr_type = 0;

	self->section	= CURRENTSECTION;
    self->asmpc		= get_PC();					/* BUG_0048 */
    self->code_pos	= get_cur_module_size();	/* BUG_0015 */

	self->filename	= src_filename();
	self->line_nr	= src_line_nr();
	self->listpos	= -1;
}

void Expr_copy (Expr *self, Expr *other)
{
	self->rpn_ops	= ExprOpArray_clone( other->rpn_ops );
	self->text		= Str_clone( other->text );
}

void Expr_fini (Expr *self)
{ 
	OBJ_DELETE( self->rpn_ops );
	OBJ_DELETE( self->text );
}

/*-----------------------------------------------------------------------------
*	Expression parser
*----------------------------------------------------------------------------*/
static Bool Expr_parse_ternary_cond( Expr *expr );

#define DEFINE_PARSER( name, prev_name, condition )			\
	static Bool name( Expr *self )							\
	{														\
		tokid_t op = TK_NIL;								\
															\
		if ( ! prev_name(self) )							\
			return FALSE;									\
															\
		while ( condition )									\
		{													\
			op = tok;										\
			Str_append(self->text, tok_text);				\
			GetSym();										\
			if ( ! prev_name(self) )						\
				return FALSE;								\
															\
			ExprOp_init_operator(							\
				ExprOpArray_push( self->rpn_ops ),			\
				op, BINARY_OP );							\
		}													\
															\
		return TRUE;										\
	}

/* parse value */
static Bool Expr_parse_factor( Expr *self )
{
    Symbol  *symptr;
	UInt	 asmpc;

    switch ( tok )
    {
	case TK_ASMPC:				/* BUG_0047 */
		asmpc = get_PC();
		ExprOp_init_number( ExprOpArray_push( self->rpn_ops ),
							asmpc );
		self->expr_type |= SYM_ADDR;

		Str_append(self->text, tok_text);
		
		GetSym();
		break;

    case TK_NAME:
		symptr = get_used_symbol( tok_name );

        if ( symptr->sym_type & SYM_DEFINED )
        {
            /* copy appropriate type bits */
            self->expr_type |= ( symptr->sym_type & SYM_TYPE );
			ExprOp_init_number( ExprOpArray_push( self->rpn_ops ),
								symptr->value );
        }
        else
        {
            /* copy appropriate declaration bits */
            self->expr_type |= ( symptr->sym_type & SYM_TYPE ) | NOT_EVALUABLE;

            /* symbol only declared, store symbol name */
			ExprOp_init_name( ExprOpArray_push( self->rpn_ops ),
							  tok_name, symptr->sym_type );
        }

        Str_append(self->text, tok_name);		/* add identifier to infix expr */

        GetSym();
        break;

	case TK_NUMBER:
		Str_append_sprintf(self->text, "%ld", tok_number);
		ExprOp_init_number( ExprOpArray_push( self->rpn_ops ),
							tok_number );
        GetSym();
        break;

    default:
        return 0;
    }

    return 1;                   /* syntax OK */
}

/* parse unary operators */
static Bool Expr_parse_unary( Expr *self )
{
    tokid_t open_paren;

	switch (tok) 
	{
    case TK_MINUS:
        Str_append(self->text, tok_text);
        GetSym();
		if ( ! Expr_parse_unary( self ) )		/* right-associative, recurse */
			return FALSE;

		ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
							  TK_MINUS, UNARY_OP );
		return TRUE;

    case TK_PLUS:
        GetSym();
        return Expr_parse_unary( self );

    case TK_BIN_NOT:
        Str_append(self->text, tok_text);
        GetSym();
		if ( ! Expr_parse_unary( self ) )		/* right-associative, recurse */
			return FALSE;

		ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
							  TK_BIN_NOT, UNARY_OP );
		return TRUE;

    case TK_LOG_NOT:
        Str_append(self->text, tok_text);
        GetSym();

        if ( ! Expr_parse_unary( self ) )		/* right-associative, recurse */
			return FALSE;

		ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
							  TK_LOG_NOT, UNARY_OP );
		return TRUE;

    case TK_LPAREN:
    case TK_LSQUARE:
        Str_append(self->text, tok_text);
        open_paren = tok;
        GetSym();

        if ( ! Expr_parse_ternary_cond( self ) )
			return FALSE;

		/* chack parentheses balance */
        if ( ( open_paren == TK_LPAREN  && tok != TK_RPAREN ) ||
             ( open_paren == TK_LSQUARE && tok != TK_RSQUARE ) )
			return FALSE;

        Str_append(self->text, tok_text);
        GetSym();
		return TRUE;

	default:
		return Expr_parse_factor( self );
	}
}

/* parse A ** B */
static Bool Expr_parse_power( Expr *self )
{
    if ( ! Expr_parse_unary( self ) )
        return FALSE;

    while ( tok == TK_POWER )
    {
        Str_append(self->text, tok_text);
        GetSym();
		if ( ! Expr_parse_power( self ) )		/* right-associative, recurse */
			return FALSE;

		ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
							  TK_POWER, BINARY_OP );
    }

    return TRUE;
}

/* parse A * B, A / B, A % B */
DEFINE_PARSER( Expr_parse_multiplication, Expr_parse_power, 
			   tok == TK_MULTIPLY || tok == TK_DIVIDE || tok == TK_MOD )

/* parse A + B, A - B */
DEFINE_PARSER( Expr_parse_addition, Expr_parse_multiplication,
			   tok == TK_PLUS || tok == TK_MINUS )

/* parse A << B, A >> B */
DEFINE_PARSER( Expr_parse_binary_shift, Expr_parse_addition,
			   tok == TK_LEFT_SHIFT || tok == TK_RIGHT_SHIFT )

/* parse A == B, A < B, A <= B, A > B, A >= B, A != B */
DEFINE_PARSER( Expr_parse_condition, Expr_parse_binary_shift, 
			   tok == TK_LESS	|| tok == TK_LESS_EQ ||
			   tok == TK_EQUAL	|| tok == TK_NOT_EQ  ||
			   tok == TK_GREATER|| tok == TK_GREATER_EQ )

/* parse A & B */
DEFINE_PARSER( Expr_parse_binary_and, Expr_parse_condition, 
			   tok == TK_BIN_AND )

/* parse A | B, A ^ B */
DEFINE_PARSER( Expr_parse_binary_or, Expr_parse_binary_and, 
			   tok == TK_BIN_OR || tok == TK_BIN_XOR )

/* parse A && B */
DEFINE_PARSER( Expr_parse_logical_and, Expr_parse_binary_or, 
			   tok == TK_LOG_AND )

/* parse A || B */
DEFINE_PARSER( Expr_parse_logical_or, Expr_parse_logical_and, 
			   tok == TK_LOG_OR )

/* parse cond ? true : false */
static Bool Expr_parse_ternary_cond( Expr *self )
{
	if ( ! Expr_parse_logical_or(self) )		/* get cond or expression */
		return FALSE;

	if ( tok != TK_QUESTION )
		return TRUE;

	/* ternary construct found */
    Str_append_char(self->text, '?');
	GetSym();						/* consume '?' */
		
	if ( ! Expr_parse_ternary_cond(self) )	/* get true */
		return FALSE;

	if ( tok != TK_COLON )
		return FALSE;
    Str_append_char(self->text, ':');
	GetSym();						/* consume ':' */

	if ( ! Expr_parse_ternary_cond(self) )	/* get false */
		return FALSE;

	ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
						  TK_TERN_COND, TERNARY_OP );
	return TRUE;
}

/* parse expression at current input, return new Expr object;
   return NULL and issue syntax error on error */
Expr *expr_parse( void )
{
	Expr *self = OBJ_NEW( Expr );
    Bool is_const_expr = FALSE;

    if ( tok == TK_CONST_EXPR )		/* leading '#' : ignore relocatable address expression */
    {
		Str_append(self->text, tok_text);

		GetSym();               
        is_const_expr = TRUE;
    }

    if ( Expr_parse_ternary_cond( self ) )
    {
        /* convert to constant expression */
        if ( is_const_expr )
			ExprOp_init_const_expr( ExprOpArray_push( self->rpn_ops ) );
    }
    else		
    {
		/* syntax error in expression */
		OBJ_DELETE( self );
		self = NULL;

		error_syntax_expr();
	}

    return self;
}

/*-----------------------------------------------------------------------------
*	evaluate expression if possible, set NOT_EVALUABLE if failed
*   e.g. symbol not defined
*----------------------------------------------------------------------------*/
long Expr_eval( Expr *self )
{
	size_t i;

	self->expr_type &= ~ NOT_EVALUABLE;		/* prefix expression as evaluated */

	for ( i = 0; i < ExprOpArray_size( self->rpn_ops ); i++ )
	{
		ExprOp *expr_op = ExprOpArray_item( self->rpn_ops, i );

		ExprOp_compute( expr_op, self );
	}

    return Calc_pop();
}

/*-----------------------------------------------------------------------------
*	parse and eval an expression, return FALSE on NOT_EVALUABLE
*----------------------------------------------------------------------------*/
static Bool _expr_parse_eval( long *presult, Bool not_defined_error )
{
	Expr *expr;
	Bool  failed;

	*presult = 0;

	expr = expr_parse();
	if ( expr == NULL )
		return FALSE;				/* error output by expr_parse() */

	/* eval and discard expression */
	*presult = Expr_eval( expr );
	failed   = (expr->expr_type & NOT_EVALUABLE);
	OBJ_DELETE( expr );

	/* check errors */
	if ( failed )
	{
		if ( not_defined_error )
			error_not_defined();	/* error unless evaluating IF, 
									   where symbol not defined == 0 */
		return FALSE;
	}

	return TRUE;
}

Bool expr_parse_eval( long *presult )
{
	return _expr_parse_eval( presult, TRUE );
}

long expr_parse_eval_if( void )
{
	long result = 0;
	_expr_parse_eval( &result, FALSE );
	return result;
}
