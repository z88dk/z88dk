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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.c,v 1.25 2014-12-13 00:49:45 pauloscustodio Exp $
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
static void ExprOp_init_asmpc(      ExprOp *self );
static void ExprOp_init_number(     ExprOp *self, long value );
static void ExprOp_init_symbol(     ExprOp *self, Symbol *symbol );
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
void ExprOp_init_asmpc( ExprOp *self )
{
	self->op_type	= ASMPC_OP;
}

void ExprOp_init_number( ExprOp *self, long value )
{
	self->op_type	= NUMBER_OP;
	self->d.value	= value;
}

void ExprOp_init_symbol( ExprOp *self, Symbol *symbol )
{
	self->op_type	= SYMBOL_OP;
	self->d.symbol	= symbol;
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
	switch (self->op_type)
	{
	case SYMBOL_OP:
		/* symbol was not defined */
        if ( ! (self->d.symbol->sym_type_mask & SYM_DEFINED) )
        {
			expr->result.not_evaluable = TRUE;

			if ( self->d.symbol->sym_type == TYPE_UNKNOWN )
				expr->result.undefined_symbol = TRUE;

			if ( self->d.symbol->sym_type_mask & SYM_EXTERN )
				expr->result.extern_symbol = TRUE;

			Calc_push( 0 );
        }
		else
		{
			Calc_push( self->d.symbol->value );
		}

		/* copy appropriate type bits */
		expr->expr_type_mask |= ( self->d.symbol->sym_type_mask & SYM_TYPE );
		expr->sym_type = MAX( expr->sym_type, self->d.symbol->sym_type );

		/* check if symbol is computable and was computed */
		if ( self->d.symbol->sym_type == TYPE_COMPUTED && ! self->d.symbol->computed )
			expr->computed = FALSE;

		break;
		
	case CONST_EXPR_OP:
		expr->sym_type = TYPE_CONSTANT;		/* convert to constant expression */
		break;
		
	case ASMPC_OP:
		expr->sym_type = MAX( expr->sym_type, TYPE_ADDRESS );
		Calc_push( get_PC() ); 
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
*	Expression range
*----------------------------------------------------------------------------*/

/* return size in bytes of value of given range */
int range_size( range_t range )
{
	switch ( range )
	{
	case RANGE_JR_OFFSET:		return 1;
	case RANGE_BYTE_UNSIGNED:	return 1;
	case RANGE_BYTE_SIGNED:		return 1;
	case RANGE_WORD:			return 2;
	case RANGE_DWORD:			return 4;
	default: assert(0);
	}

	assert(0);
	return -1;	/* not reached */
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

	self->sym_type	= TYPE_UNKNOWN;
    self->expr_type_mask = 0;
	
	self->target_name = NULL;

	self->module	= CURRENTMODULE;
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
			op = sym.tok;									\
			Str_append(self->text, sym.text);				\
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

    switch ( sym.tok )
    {
	case TK_ASMPC:				/* BUG_0047 */
		ExprOp_init_asmpc( ExprOpArray_push( self->rpn_ops ) );
		self->sym_type = MAX( self->sym_type, TYPE_ADDRESS );

		Str_append(self->text, sym.text);
		
		GetSym();
		break;

    case TK_NAME:
		symptr = get_used_symbol( sym.string );
		
		ExprOp_init_symbol( ExprOpArray_push( self->rpn_ops ),
							symptr );

		/* copy appropriate type bits */
		self->sym_type = MAX( self->sym_type, symptr->sym_type );
        self->expr_type_mask |= ( symptr->sym_type_mask & SYM_TYPE );

        if ( ! (symptr->sym_type_mask & SYM_DEFINED) )
        {
			self->result.not_evaluable		= TRUE;
        }

        Str_append(self->text, sym.string);		/* add identifier to infix expr */

        GetSym();
        break;

	case TK_NUMBER:
		Str_append_sprintf(self->text, "%ld", sym.number);
		ExprOp_init_number( ExprOpArray_push( self->rpn_ops ),
							sym.number );
		self->sym_type = MAX( self->sym_type, TYPE_CONSTANT );
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

	switch (sym.tok) 
	{
    case TK_MINUS:
        Str_append(self->text, sym.text);
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
        Str_append(self->text, sym.text);
        GetSym();
		if ( ! Expr_parse_unary( self ) )		/* right-associative, recurse */
			return FALSE;

		ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
							  TK_BIN_NOT, UNARY_OP );
		return TRUE;

    case TK_LOG_NOT:
        Str_append(self->text, sym.text);
        GetSym();

        if ( ! Expr_parse_unary( self ) )		/* right-associative, recurse */
			return FALSE;

		ExprOp_init_operator( ExprOpArray_push( self->rpn_ops ),
							  TK_LOG_NOT, UNARY_OP );
		return TRUE;

    case TK_LPAREN:
    case TK_LSQUARE:
        Str_append(self->text, sym.text);
        open_paren = sym.tok;
        GetSym();

        if ( ! Expr_parse_ternary_cond( self ) )
			return FALSE;

		/* chack parentheses balance */
        if ( ( open_paren == TK_LPAREN  && sym.tok != TK_RPAREN ) ||
             ( open_paren == TK_LSQUARE && sym.tok != TK_RSQUARE ) )
			return FALSE;

        Str_append(self->text, sym.text);
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

    while ( sym.tok == TK_POWER )
    {
        Str_append(self->text, sym.text);
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
			   sym.tok == TK_MULTIPLY || sym.tok == TK_DIVIDE || sym.tok == TK_MOD )

/* parse A + B, A - B */
DEFINE_PARSER( Expr_parse_addition, Expr_parse_multiplication,
			   sym.tok == TK_PLUS || sym.tok == TK_MINUS )

/* parse A << B, A >> B */
DEFINE_PARSER( Expr_parse_binary_shift, Expr_parse_addition,
			   sym.tok == TK_LEFT_SHIFT || sym.tok == TK_RIGHT_SHIFT )

/* parse A == B, A < B, A <= B, A > B, A >= B, A != B */
DEFINE_PARSER( Expr_parse_condition, Expr_parse_binary_shift, 
			   sym.tok == TK_LESS	|| sym.tok == TK_LESS_EQ ||
			   sym.tok == TK_EQUAL	|| sym.tok == TK_NOT_EQ  ||
			   sym.tok == TK_GREATER|| sym.tok == TK_GREATER_EQ )

/* parse A & B */
DEFINE_PARSER( Expr_parse_binary_and, Expr_parse_condition, 
			   sym.tok == TK_BIN_AND )

/* parse A | B, A ^ B */
DEFINE_PARSER( Expr_parse_binary_or, Expr_parse_binary_and, 
			   sym.tok == TK_BIN_OR || sym.tok == TK_BIN_XOR )

/* parse A && B */
DEFINE_PARSER( Expr_parse_logical_and, Expr_parse_binary_or, 
			   sym.tok == TK_LOG_AND )

/* parse A || B */
DEFINE_PARSER( Expr_parse_logical_or, Expr_parse_logical_and, 
			   sym.tok == TK_LOG_OR )

/* parse cond ? true : false */
static Bool Expr_parse_ternary_cond( Expr *self )
{
	if ( ! Expr_parse_logical_or(self) )		/* get cond or expression */
		return FALSE;

	if ( sym.tok != TK_QUESTION )
		return TRUE;

	/* ternary construct found */
    Str_append_char(self->text, '?');
	GetSym();						/* consume '?' */
		
	if ( ! Expr_parse_ternary_cond(self) )	/* get true */
		return FALSE;

	if ( sym.tok != TK_COLON )
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

    if ( sym.tok == TK_CONST_EXPR )		/* leading '#' : ignore relocatable address expression */
    {
		Str_append(self->text, sym.text);

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
*	evaluate expression if possible, set result.not_evaluable if failed
*   e.g. symbol not defined
*----------------------------------------------------------------------------*/
long Expr_eval( Expr *self )
{
	size_t i;

	self->result.not_evaluable		= FALSE;
	self->result.undefined_symbol	= FALSE;
	self->result.extern_symbol		= FALSE;

	self->computed = TRUE;

	for ( i = 0; i < ExprOpArray_size( self->rpn_ops ); i++ )
	{
		ExprOp *expr_op = ExprOpArray_item( self->rpn_ops, i );

		ExprOp_compute( expr_op, self );
	}

	/* need to downgrade from COMPUTED if already computed */
	if ( self->sym_type == TYPE_COMPUTED && self->computed )
	{
		sym_type_t sym_type = TYPE_CONSTANT;

		for ( i = 0; i < ExprOpArray_size( self->rpn_ops ); i++ )
		{
			ExprOp *expr_op = ExprOpArray_item( self->rpn_ops, i );

			switch (expr_op->op_type)
			{
			case SYMBOL_OP:		sym_type = MAX( sym_type, expr_op->d.symbol->sym_type ); break;
			case CONST_EXPR_OP:	sym_type = MAX( sym_type, TYPE_CONSTANT ); break;
			case ASMPC_OP:		sym_type = MAX( sym_type, TYPE_ADDRESS ); break;
			default:			; /* no change */
			}
		}
		assert( sym_type != TYPE_COMPUTED );
		self->sym_type = sym_type;
	}

    return Calc_pop();
}

/*-----------------------------------------------------------------------------
*	parse and eval an expression, return FALSE on result.not_evaluable
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
	failed   = (expr->result.not_evaluable);
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
