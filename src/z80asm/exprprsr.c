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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/exprprsr.c,v 1.62 2014-03-03 13:43:50 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "codearea.h"
#include "config.h"
#include "errors.h"
#include "expr.h"
#include "fileutil.h"
#include "legacy.h"
#include "options.h"
#include "symbol.h"
#include "token.h"
#include "except.h"
#include "expr.h"
#include "expr_def.h"
#include "z80asm.h"
#include <assert.h>
#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* external functions */
tokid_t GetSym( void );
void Pass2info( struct expr *expression, char constrange, long lfileptr );
long GetConstant( char *evalerr );
int GetChar( FILE *fptr );

/* local functions */
void list_PfixExpr( struct expr *pfixlist );
void RemovePfixlist( struct expr *pfixexpr );
void NewPfixSymbol( struct expr *pfixexpr, long oprconst, tokid_t oprtype, char *symident, char symboltype );
void StoreExpr( struct expr *pfixexpr, char range );
int ExprSigned8( int listoffset );
int ExprUnsigned8( int listoffset );
int ExprAddress( int listoffset );
static BOOL TernaryCondition( struct expr *pfixexpr );

long EvalPfixExpr( struct expr *pfixexpr );
struct expr *ParseNumExpr( void );

/* global variables */
extern struct module *CURRENTMODULE;
extern tokid_t sym;
extern char ident[];
extern FILE *z80asmfile, *objfile;


#define DEFINE_PARSER( name, prev_name, condition )				\
	static BOOL name( struct expr *pfixexpr )					\
	{															\
		tokid_t op = TK_NIL;									\
																\
		if ( ! prev_name(pfixexpr) )							\
			return FALSE;										\
																\
		while ( condition )										\
		{														\
			op = sym;											\
			strcpy(pfixexpr->infixptr, token_string(sym));		\
			pfixexpr->infixptr += strlen(pfixexpr->infixptr);	\
			GetSym();											\
			if ( ! prev_name(pfixexpr) )						\
				return FALSE;									\
																\
			NewPfixSymbol( pfixexpr, 0, op, NULL, 0 );			\
		}														\
																\
		return TRUE;											\
	}

/* parse value */
static BOOL Factor( struct expr *pfixexpr )
{
    long constant;
    Symbol *symptr;
    char eval_err;

    switch ( sym )
    {
    case TK_NAME:
        symptr = get_used_symbol( ident );

        if ( symptr->type & SYM_DEFINED )
        {
            /* copy appropriate type bits */
            pfixexpr->expr_type |= ( symptr->type & SYM_TYPE );
            NewPfixSymbol( pfixexpr, symptr->value, TK_NUMBER, NULL, symptr->type );
        }
        else
        {
            /* copy appropriate declaration bits */
            pfixexpr->expr_type |= ( symptr->type & SYM_TYPE ) | NOT_EVALUABLE;

            /* symbol only declared, store symbol name */
            NewPfixSymbol( pfixexpr, 0, TK_NUMBER, ident, symptr->type );
        }

        strcpy( pfixexpr->infixptr, ident );    /* add identifier to infix expr */
        pfixexpr->infixptr += strlen( ident );  /* update pointer */

        GetSym();
        break;

    case TK_HEX_CONST:
    case TK_BIN_CONST:
    case TK_DEC_CONST:
        strcpy( pfixexpr->infixptr, ident );    /* add constant to infix expr */
        pfixexpr->infixptr += strlen( ident );  /* update pointer */
        constant = GetConstant( &eval_err );

        if ( eval_err == 1 )
        {
            return 0;           /* syntax error in expression */
        }
        else
        {
            NewPfixSymbol( pfixexpr, constant, TK_NUMBER, NULL, 0 );
        }

        GetSym();
        break;

    case TK_SQUOTE:
        *pfixexpr->infixptr++ = '\'';   /* store single quote in infix expr */

        if ( feof( z80asmfile ) )
        {
            error_syntax();
            return 0;
        }
        else
        {
            constant = GetChar( z80asmfile );

            if ( constant == EOF )
            {
                error_syntax();
                return 0;
            }
            else
            {
                *pfixexpr->infixptr++ = ( byte_t )constant;           /* store char in infix expr */

                if ( GetSym() == TK_SQUOTE )
                {
                    *pfixexpr->infixptr++ = '\'';
                    NewPfixSymbol( pfixexpr, constant, TK_NUMBER, NULL, 0 );
                }
                else
                {
                    return 0;
                }
            }
        }

        GetSym();
        break;

    default:
        return 0;
    }

    return 1;                   /* syntax OK */
}

/* parse unary operators */
static BOOL UnaryTerm( struct expr *pfixexpr )
{
    tokid_t open_paren;

	switch (sym) 
	{
    case TK_MINUS:
        strcpy(pfixexpr->infixptr, token_string(sym));
		pfixexpr->infixptr += strlen(pfixexpr->infixptr);
        GetSym();
		if ( ! UnaryTerm( pfixexpr ) )		/* right-associative, recurse */
			return FALSE;

		NewPfixSymbol( pfixexpr, 0, TK_NEGATE, NULL, 0 );
		return TRUE;

    case TK_PLUS:
        GetSym();
        return UnaryTerm( pfixexpr );

    case TK_BIN_NOT:
        strcpy(pfixexpr->infixptr, token_string(sym));
		pfixexpr->infixptr += strlen(pfixexpr->infixptr);
        GetSym();
		if ( ! UnaryTerm( pfixexpr ) )		/* right-associative, recurse */
			return FALSE;

		NewPfixSymbol( pfixexpr, 0, TK_BIN_NOT, NULL, 0 );
		return TRUE;

    case TK_LOG_NOT:
        strcpy(pfixexpr->infixptr, token_string(sym));
		pfixexpr->infixptr += strlen(pfixexpr->infixptr);
        GetSym();

        if ( ! UnaryTerm( pfixexpr ) )		/* right-associative, recurse */
			return FALSE;

		NewPfixSymbol( pfixexpr, 0, TK_LOG_NOT, NULL, 0 );
		return TRUE;

    case TK_LPAREN:
    case TK_LSQUARE:
        strcpy(pfixexpr->infixptr, token_string(sym));
		pfixexpr->infixptr += strlen(pfixexpr->infixptr);
        open_paren = sym;
        GetSym();

        if ( ! TernaryCondition( pfixexpr ) )
			return FALSE;

		/* chack parentheses balance */
        if ( ( open_paren == TK_LPAREN  && sym != TK_RPAREN ) ||
             ( open_paren == TK_LSQUARE && sym != TK_RSQUARE ) )
			return FALSE;

        strcpy(pfixexpr->infixptr, token_string(sym));
		pfixexpr->infixptr += strlen(pfixexpr->infixptr);
        GetSym();
		return TRUE;

	default:
		return Factor( pfixexpr );
	}
}

/* parse A ** B */
static BOOL PowerTerm( struct expr *pfixexpr )
{
    if ( ! UnaryTerm( pfixexpr ) )
        return FALSE;

    while ( sym == TK_POWER )
    {
        strcpy(pfixexpr->infixptr, token_string(sym));
		pfixexpr->infixptr += strlen(pfixexpr->infixptr);
        GetSym();
		if ( ! PowerTerm( pfixexpr ) )		/* right-associative, recurse */
			return FALSE;

		NewPfixSymbol( pfixexpr, 0, TK_POWER, NULL, 0 );
    }

    return TRUE;
}


/* parse A * B, A / B, A % B */
DEFINE_PARSER( Multiplication, PowerTerm, sym == TK_MULTIPLY || sym == TK_DIVIDE || sym == TK_MOD )

/* parse A + B, A - B */
DEFINE_PARSER( Addition, Multiplication, sym == TK_PLUS || sym == TK_MINUS )

/* parse A << B, A >> B */
DEFINE_PARSER( BinaryShift, Addition, sym == TK_LEFT_SHIFT || sym == TK_RIGHT_SHIFT )

/* parse A == B, A < B, A <= B, A > B, A >= B, A != B */
DEFINE_PARSER( Condition, BinaryShift, sym == TK_LESS	|| sym == TK_LESS_EQ ||
									   sym == TK_EQUAL	|| sym == TK_NOT_EQ  ||
									   sym == TK_GREATER|| sym == TK_GREATER_EQ )

/* parse A & B */
DEFINE_PARSER( BinaryAnd, Condition, sym == TK_BIN_AND )

/* parse A | B, A ^ B */
DEFINE_PARSER( BinaryOr, BinaryAnd, sym == TK_BIN_OR || sym == TK_BIN_XOR )

/* parse A && B */
DEFINE_PARSER( LogicalAnd, BinaryOr, sym == TK_LOG_AND )

/* parse A || B */
DEFINE_PARSER( LogicalOr, LogicalAnd, sym == TK_LOG_OR )

/* parse cond ? true : false */
static BOOL TernaryCondition( struct expr *pfixexpr )
{
	if ( ! LogicalOr(pfixexpr) )		/* get cond or expression */
		return FALSE;

	if ( sym != TK_QUESTION )
		return TRUE;

	/* ternary construct found */
    *pfixexpr->infixptr++ = '?';
	GetSym();						/* consume '?' */
		
	if ( ! TernaryCondition(pfixexpr) )	/* get true */
		return FALSE;

	if ( sym != TK_COLON )
		return FALSE;
    *pfixexpr->infixptr++ = ':';
	GetSym();						/* consume ':' */

	if ( ! TernaryCondition(pfixexpr) )	/* get false */
		return FALSE;

	NewPfixSymbol( pfixexpr, 0, TK_TERN_COND, NULL, 0 );    /* ?: */
	return TRUE;
}


struct expr *
ParseNumExpr( void )
{
    struct expr *pfixhdr;
    BOOL is_const_expr = FALSE;

    pfixhdr = xnew( struct expr );

    pfixhdr->firstnode = NULL;
    pfixhdr->currentnode = NULL;
    pfixhdr->expr_type = 0;
    pfixhdr->stored = OFF;
    pfixhdr->codepos = get_codeindex(); /* BUG_0015 */
    pfixhdr->infixexpr = NULL;
    pfixhdr->infixptr = NULL;

    pfixhdr->infixexpr = xnew_n( char, 128 );     /* TODO: make size a constant */

    pfixhdr->infixptr = pfixhdr->infixexpr;             /* initialise pointer to start of buffer */

    if ( sym == TK_CONST_EXPR )
    {
		strcpy(pfixhdr->infixptr, token_string(sym));
		pfixhdr->infixptr += strlen(pfixhdr->infixptr);

		GetSym();               /* leading '#' : ignore relocatable address expression */
        is_const_expr = TRUE;        /* convert to constant expression */
    }

    if ( TernaryCondition( pfixhdr ) )
    {
        /* parse expression... */
        if ( is_const_expr )
        {
            NewPfixSymbol( pfixhdr, 0, TK_CONST_EXPR, NULL, 0 );    /* convert to constant expression */
        }

        *pfixhdr->infixptr = '\0';                      /* terminate infix expression */
    }
    else
    {
        RemovePfixlist( pfixhdr );
        pfixhdr = NULL;         /* syntax error in expression or no room for postfix expression */
		error_syntax_expr();
	}

    return pfixhdr;
}



void
StoreExpr( struct expr *pfixexpr, char range )
{
    xfput_uint8(			objfile, range );				/* range of expression */
    xfput_uint16(			objfile, pfixexpr->codepos );	/* patchptr */
	xfput_count_byte_strz(	objfile, pfixexpr->infixexpr );	/* expression */
    xfput_uint8(			objfile, 0 );					/* nul-terminate expression */

    pfixexpr->stored = ON;
}



long
EvalPfixExpr( struct expr *pfixlist )
{
    struct postfixlist *pfixexpr;
    Symbol *symptr;

	pfixlist->expr_type &= ~ NOT_EVALUABLE;		/* prefix expression as evaluated */
	pfixexpr = pfixlist->firstnode;				/* initiate to first node */

	do
	{
		switch ( pfixexpr->operatortype )
		{
		case TK_NUMBER:
			if ( pfixexpr->id == NULL ) /* Is operand an identifier? */
			{
				Calc_push( pfixexpr->operandconst );
			}
			else
			{
				/* symbol was not defined and not declared */
				if ( ( pfixexpr->sym_type & ~ SYM_TOUCHED ) != SYM_NOTDEFINED )
				{
					/* if all bits are set to zero */
					if ( pfixexpr->sym_type & SYM_LOCAL )
					{
						symptr = find_local_symbol( pfixexpr->id );

						/* copy appropriate type bits */
						pfixlist->expr_type |= ( symptr->type & SYM_TYPE );

						Calc_push( symptr->value );
					}
					else
					{
						symptr = find_global_symbol( pfixexpr->id );

						if ( symptr != NULL )
						{
							/* copy appropriate type bits */
							pfixlist->expr_type |= ( symptr->type & SYM_TYPE );

							if ( symptr->type & SYM_DEFINED )
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
					symptr = get_used_symbol( pfixexpr->id );

					/* copy appropriate type bits */
					pfixlist->expr_type |= ( symptr->type & SYM_TYPE );

					if ( symptr->type & SYM_DEFINED )
					{
						Calc_push( symptr->value );
					}
					else
					{
						pfixlist->expr_type |= NOT_EVALUABLE;
						Calc_push( 0 );
					}
				}
			}

			break;

		case TK_CONST_EXPR:
			pfixlist->expr_type &= ~ EXPR_ADDR;		/* convert to constant expression */
			break;

		case TK_BIN_AND:	Calc_compute_binary( calc_bin_and 	); break;
		case TK_BIN_OR:		Calc_compute_binary( calc_bin_or	); break;
		case TK_LOG_AND:	Calc_compute_binary( calc_log_and	); break;
		case TK_LOG_OR:		Calc_compute_binary( calc_log_or	); break;
		case TK_BIN_XOR:	Calc_compute_binary( calc_bin_xor	); break;
		case TK_PLUS:		Calc_compute_binary( calc_plus		); break;
		case TK_MINUS:		Calc_compute_binary( calc_minus		); break;
		case TK_MULTIPLY:	Calc_compute_binary( calc_multiply	); break;
		case TK_DIVIDE:		Calc_compute_binary( calc_divide	); break;
		case TK_MOD:		Calc_compute_binary( calc_mod		); break;
		case TK_POWER:		Calc_compute_binary( calc_power		); break;
		case TK_EQUAL:		Calc_compute_binary( calc_equal		); break;
		case TK_LESS:		Calc_compute_binary( calc_less		); break;
		case TK_GREATER:	Calc_compute_binary( calc_greater	); break;
		case TK_LESS_EQ:	Calc_compute_binary( calc_less_eq	); break;
		case TK_GREATER_EQ:	Calc_compute_binary( calc_greater_eq); break;
		case TK_NOT_EQ:		Calc_compute_binary( calc_not_eq	); break;
		case TK_LEFT_SHIFT:	Calc_compute_binary( calc_left_shift); break;
		case TK_RIGHT_SHIFT:Calc_compute_binary( calc_right_shift);break;
		case TK_TERN_COND:	Calc_compute_ternary(calc_tern_cond	); break;
		case TK_NEGATE:		Calc_compute_unary(  calc_negate	); break;
		case TK_LOG_NOT:	Calc_compute_unary(  calc_log_not	); break;
		case TK_BIN_NOT:	Calc_compute_unary(  calc_bin_not	); break;

		default:
			assert(0);
			break;
		}

		pfixexpr = pfixexpr->nextoperand;             /* get next operand in postfix expression */
	}
	while ( pfixexpr != NULL );

    return Calc_pop();
}






void
RemovePfixlist( struct expr *pfixexpr )
{
    struct postfixlist *node, *tmpnode;

    if ( pfixexpr == NULL )
    {
        return;
    }

    node = pfixexpr->firstnode;

    while ( node != NULL )
    {
        tmpnode = node->nextoperand;

        if ( node->id != NULL )
        {
            xfree( node->id );    /* Remove symbol id, if defined */
        }

        xfree( node );
        node = tmpnode;
    }

    if ( pfixexpr->infixexpr != NULL )
    {
        xfree( pfixexpr->infixexpr );    /* release infix expr. string */
    }

    xfree( pfixexpr );           /* release header of postfix expression */
}




void
NewPfixSymbol( struct expr *pfixexpr,
               long oprconst,
               tokid_t oprtype,
               char *symident,
               char symboltype )
{
    struct postfixlist *newnode;

    newnode = xnew( struct postfixlist );

    newnode->operandconst = oprconst;
    newnode->operatortype = oprtype;
    newnode->nextoperand = NULL;
    newnode->sym_type = symboltype;

    if ( symident != NULL )
    {
        newnode->id = xstrdup( symident );    /* Allocate symbol */
    }
    else
    {
        newnode->id = NULL;
    }

    if ( pfixexpr->firstnode == NULL )
    {
        pfixexpr->firstnode = newnode;
        pfixexpr->currentnode = newnode;
    }
    else
    {
        pfixexpr->currentnode->nextoperand = newnode;
        pfixexpr->currentnode = newnode;
    }
}









int
ExprLong( int listoffset )
{

    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    uint_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->expr_type & EXPR_EXTERN ) || ( pfixexpr->expr_type & EXPR_ADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'L' );
        }

        if ( pfixexpr->expr_type & EXPR_EXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->expr_type & EXPR_ADDR ) && ! opts.cur_list )     /* expression contains address
                                                                           * label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->expr_type & NOT_EVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_32SIGN, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < LONG_MIN || constant > LONG_MAX )
                        warn_int_range( constant );

                    append_long( constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_long( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}



int
ExprAddress( int listoffset )
{
    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    uint_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->expr_type & EXPR_EXTERN ) || ( pfixexpr->expr_type & EXPR_ADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'C' );
        }

        if ( pfixexpr->expr_type & EXPR_EXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->expr_type & EXPR_ADDR ) && ! opts.cur_list )     /* expression contains address
                                                                           * label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->expr_type & NOT_EVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_16CONST, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < -32768 || constant > 65535 )
                        warn_int_range( constant );

                    append_word( constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_word( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}


int
ExprUnsigned8( int listoffset )
{
    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    uint_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->expr_type & EXPR_EXTERN ) || ( pfixexpr->expr_type & EXPR_ADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'U' );
        }

        if ( pfixexpr->expr_type & EXPR_EXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->expr_type & EXPR_ADDR ) && ! opts.cur_list )     /* expression contains address
                                                                           * label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->expr_type & NOT_EVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_8UNSIGN, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < -128 || constant > 255 )
                        warn_int_range( constant );

                    append_byte( ( byte_t ) constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_byte( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}



int
ExprSigned8( int listoffset )
{
    struct expr *pfixexpr;
    long constant;
    int flag = 1;
    uint_t exprptr = get_codeindex();     /* address of expression - BUG_0015 */

    /* BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary */
    switch ( sym )
    {
    case TK_RPAREN:
        append_byte( 0 );   /* offset zero */
        return 1;           /* OK, zero already stored */

    case TK_PLUS:
    case TK_MINUS:          /* + or - expected */
        break;              /* continue into parsing expression */

    default:                /* Syntax error, e.g. (ix 4) */
        error_syntax();
        return 0;           /* FAIL */
    }

    if ( ( pfixexpr = ParseNumExpr() ) != NULL )
    {
        /* parse numerical expression */
        if ( ( pfixexpr->expr_type & EXPR_EXTERN ) || ( pfixexpr->expr_type & EXPR_ADDR ) )
            /* expression contains external reference or address label, must be recalculated during linking */
        {
            StoreExpr( pfixexpr, 'S' );
        }

        if ( pfixexpr->expr_type & EXPR_EXTERN )
        {
            RemovePfixlist( pfixexpr );
        }
        else
        {
            if ( ( pfixexpr->expr_type & EXPR_ADDR ) && ! opts.cur_list ) /* expression contains address label */
            {
                RemovePfixlist( pfixexpr );    /* no listing - evaluate during linking... */
            }
            else
            {
                if ( pfixexpr->expr_type & NOT_EVALUABLE )
                {
                    Pass2info( pfixexpr, RANGE_8SIGN, listoffset );
                }
                else
                {
                    constant = EvalPfixExpr( pfixexpr );
                    RemovePfixlist( pfixexpr );

                    if ( constant < -128 || constant > 127 )
                        warn_int_range( constant );

                    append_byte( ( byte_t ) constant );
                }
            }
        }
    }
    else
    {
        flag = 0;
    }

    if ( get_codeindex() == exprptr )     /* BUG_0015 */
    {
        append_byte( 0 );    /* reserve space if not yet reserved */
    }

    return flag;
}


/*
* $Log: exprprsr.c,v $
* Revision 1.62  2014-03-03 13:43:50  pauloscustodio
* Renamed symbol and expression type attributes
*
* Revision 1.61  2014/03/03 13:27:07  pauloscustodio
* Rename symbol type constants
*
* Revision 1.60  2014/03/03 02:44:15  pauloscustodio
* Division by zero error was causing memory leaks - made non-fatal.
* Moved calculator stack to expr.c, made it singleton and based on array.h - no
* need to allocate on every expression computed, elements are stored in
* a vector instead of being allocated individually.
*
* Revision 1.59  2014/03/02 12:51:41  pauloscustodio
* Change token ids to TK_...
*
* Revision 1.58  2014/03/01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
*
* Revision 1.57  2014/02/25 22:39:34  pauloscustodio
* ws
*
* Revision 1.56  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.55  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.54  2014/02/19 23:59:26  pauloscustodio
* BUG_0041: 64-bit portability issues
* size_t changes to unsigned long in 64-bit. Usage of size_t * to
* retrieve unsigned integers from an open file by fileutil's xfget_uintxx()
* breaks on a 64-bit architecture. Make the functions return the value instead
* of being passed the pointer to the return value, so that the compiler
* takes care of size convertions.
* Create uint_t and ulong_t, use uint_t instead of size_t.
*
* Revision 1.53  2014/02/18 22:59:06  pauloscustodio
* BUG_0040: Detect and report division by zero instead of crashing
* BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
*
* Revision 1.52  2014/02/17 23:33:37  pauloscustodio
* Add assert() on impossible paths.
*
* Revision 1.51  2014/01/20 23:29:18  pauloscustodio
* Moved file.c to lib/fileutil.c
*
* Revision 1.50  2014/01/11 01:29:40  pauloscustodio
* Extend copyright to 2014.
* Move CVS log to bottom of file.
*
* Revision 1.49  2014/01/11 00:10:39  pauloscustodio
* Astyle - format C code
* Add -Wall option to CFLAGS, remove all warnings
*
* Revision 1.48  2013/12/15 13:18:33  pauloscustodio
* Move memory allocation routines to lib/xmalloc, instead of glib,
* introduce memory leak report on exit and memory fence check.
*
* Revision 1.47  2013/10/01 23:23:53  pauloscustodio
* Parse command line options via look-up tables:
* -l, --list
* -nl, --no-list
*
* Revision 1.46  2013/09/22 21:34:48  pauloscustodio
* Remove legacy xxx_err() interface
*
* Revision 1.45  2013/09/12 00:10:02  pauloscustodio
* Create xfree() macro that NULLs the pointer after free, required
* by z80asm to find out if a pointer was already freed.
*
* Revision 1.44  2013/09/08 08:29:21  pauloscustodio
* Replaced xmalloc et al with glib functions
*
* Revision 1.43  2013/09/08 00:43:59  pauloscustodio
* New error module with one error function per error, no need for the error
* constants. Allows compiler to type-check error message arguments.
* Included the errors module in the init() mechanism, no need to call
* error initialization from main(). Moved all error-testing scripts to
* one file errors.t.
*
* Revision 1.42  2013/09/01 12:00:07  pauloscustodio
* Cleanup compilation warnings
*
* Revision 1.41  2013/09/01 00:18:28  pauloscustodio
* - Replaced e4c exception mechanism by a much simpler one based on a few
*   macros. The former did not allow an exit(1) to be called within a
*   try-catch block.
*
* Revision 1.40  2013/08/30 21:50:43  pauloscustodio
* By suggestion of Philipp Klaus Krause: rename LEGACY to __LEGACY_Z80ASM_SYNTAX,
* as an identifier reserved by the C standard for implementation-defined behaviour
* starting with two underscores.
*
* Revision 1.39  2013/08/30 01:06:08  pauloscustodio
* New C-like expressions, defined when __LEGACY_Z80ASM_SYNTAX is not defined. Keeps old
* behaviour under -D__LEGACY_Z80ASM_SYNTAX (defined in legacy.h)
*
* BACKWARDS INCOMPATIBLE CHANGE, turned OFF by default (-D__LEGACY_Z80ASM_SYNTAX)
* - Expressions now use more standard C-like operators
* - Object and library files changed signature to
*   "Z80RMF02", "Z80LMF02", to avoid usage of old
*   object files with expressions inside in the old format
*
* Detail:
* - String concatenation in DEFM: changed from '&' to ',';  '&' will be AND
* - Power:                        changed from '^' to '**'; '^' will be XOR
* - XOR:                          changed from ':' to '^';
* - AND:                          changed from '~' to '&';  '~' will be NOT
* - NOT:                          '~' added as binary not
*
* Revision 1.38  2013/06/14 22:14:36  pauloscustodio
* find_local_symbol() and find_global_symbol() to encapsulate usage of get_global_tab()
*
* Revision 1.37  2013/06/10 23:11:33  pauloscustodio
* CH_0023 : Remove notdecl_tab
*
* Revision 1.36  2013/06/08 23:37:32  pauloscustodio
* Replace define_def_symbol() by one function for each symbol table type: define_static_def_sym(),
*  define_global_def_sym(), define_local_def_sym(), encapsulating the symbol table used.
* Define keywords for special symbols ASMPC, ASMSIZE, ASMTAIL
*
* Revision 1.35  2013/06/01 01:24:21  pauloscustodio
* CH_0022 : Replace avltree by hash table for symbol table
*
* Revision 1.34  2013/05/23 22:22:23  pauloscustodio
* Move symbol to sym.c, rename to Symbol
*
* Revision 1.33  2013/03/04 23:37:09  pauloscustodio
* Removed pass1 that was used to skip creating page references of created
* symbols in pass2. Modified add_symbol_ref() to ignore pages < 1,
* modified list_get_page_nr() to return -1 after the whole source is
* processed.
*
* Revision 1.32  2013/01/24 23:03:03  pauloscustodio
* Replaced (unsigned char) by (byte_t)
* Replaced (unisigned int) by (uint_t)
* Replaced (short) by (int)
*
* Revision 1.31  2013/01/20 13:18:10  pauloscustodio
* BUG_0024 : (ix+128) should show warning message
* Signed integer range was wrongly checked to -128..255 instead
* of -128..127
*
* Revision 1.30  2013/01/14 00:29:37  pauloscustodio
* CH_0015 : integer out of range error replaced by warning
*
* Revision 1.29  2012/11/03 17:39:35  pauloscustodio
* astyle, comments
*
* Revision 1.28  2012/05/26 18:51:10  pauloscustodio
* CH_0012 : wrappers on OS calls to raise fatal error
* CH_0013 : new errors interface to decouple calling code from errors.c
*
* Revision 1.27  2012/05/24 17:09:27  pauloscustodio
* Unify copyright header
*
* Revision 1.26  2012/05/24 16:20:52  pauloscustodio
* ERR_EXPR_SYNTAX renamed ERR_SYNTAX_EXPR (consistency)
*
* Revision 1.25  2012/05/20 06:39:27  pauloscustodio
* astyle
*
* Revision 1.24  2012/05/20 06:02:08  pauloscustodio
* Garbage collector
* Added automatic garbage collection on exit and simple fence mechanism
* to detect buffer underflow and overflow, to xmalloc functions.
* No longer needed to call init_malloc().
* No longer need to try/catch during creation of memory structures to
* free partially created data - all not freed data is freed atexit().
* Renamed xfree0() to xfree().
*
* Revision 1.23  2012/05/20 05:31:18  pauloscustodio
* Solve signed/unsigned mismatch warnings in symboltype, libtype: changed to char.
*
* Revision 1.22  2012/05/17 17:42:14  pauloscustodio
* define_symbol() defined as void, a fatal error is
* always raised on error.
*
* Revision 1.21  2012/05/11 19:29:49  pauloscustodio
* Format code with AStyle (http://astyle.sourceforge.net/) to unify brackets, spaces instead of tabs, 
* indenting style, space padding in parentheses and operators. Options written in the makefile, target astyle.
*         --mode=c
*         --lineend=linux
*         --indent=spaces=4
*         --style=ansi --add-brackets
*         --indent-switches --indent-classes
*         --indent-preprocessor --convert-tabs
*         --break-blocks
*         --pad-oper --pad-paren-in --pad-header --unpad-paren
*         --align-pointer=name
*
* Revision 1.20  2011/10/07 17:53:04  pauloscustodio
* BUG_0015 : Relocation issue - dubious addresses come out of linking
* (reported on Tue, Sep 27, 2011 at 8:09 PM by dom)
* - Introduced in version 1.1.8, when the CODESIZE and the codeptr were merged into the same entity.
* - This caused the problem because CODESIZE keeps track of the start offset of each module in the sequence they will appear in the object file, and codeptr is reset to the start of the codearea for each module.
* The effect was that all address calculations at link phase were considering
*  a start offset of zero for all modules.
* - Moreover, when linking modules from a libary, the modules are pulled in to the code area as they are needed, and not in the sequence they will be in the object file. The start offset was being ignored and the modules were being loaded in the incorrect order
* - Consequence of these two issues were all linked addresses wrong.
*
* Revision 1.19  2011/08/19 15:53:58  pauloscustodio
* BUG_0010 : heap corruption when reaching MAXCODESIZE
* - test for overflow of MAXCODESIZE is done before each instruction at parseline(); if only one byte is available in codearea, and a 2 byte instruction is assembled, the heap is corrupted before the exception is raised.
* - Factored all the codearea-accessing code into a new module, checking for MAXCODESIZE on every write.
*
* Revision 1.18  2011/08/18 23:27:54  pauloscustodio
* BUG_0009 : file read/write not tested for errors
* - In case of disk full file write fails, but assembler does not detect the error
*   and leaves back corruped object/binary files
* - Created new exception FileIOException and ERR_FILE_IO error.
* - Created new functions xfput_u8, xfget_u8, ... to raise the exception on error.
*
* Revision 1.17  2011/08/15 17:12:31  pauloscustodio
* Upgrade to Exceptions4c 2.8.9 to solve memory leak.
*
* Revision 1.16  2011/08/05 19:46:16  pauloscustodio
* CH_0004 : Exception mechanism to handle fatal errors
* Replaced all ERR_NO_MEMORY/return sequences by an exception, captured at main().
* Replaced all the memory allocation functions malloc, calloc, ... by corresponding
* macros xmalloc, xcalloc, ... that raise an exception if the memory cannot be allocated,
* removing all the test code after each memory allocation.
* Replaced all functions that allocated memory structures by the new xcalloc_struct().
* Replaced all free() by xfree0() macro which only frees if the pointer in non-null, and
* sets the poiter to NULL afterwards, to avoid any used of the freed memory.
* Created try/catch sequences to clean-up partially created memory structures and rethrow the
* exception, to cleanup memory leaks.
*
* Revision 1.15  2011/07/18 00:48:25  pauloscustodio
* Initialize MS Visual Studio DEBUG build to show memory leaks on exit
*
* Revision 1.14  2011/07/14 01:28:17  pauloscustodio
*     BUG_0006 : sub-expressions with unbalanced parentheses type accepted, e.g. (2+3] or [2+3)
*         - Raise ERR_UNBALANCED_PAREN instead
*     CH_0003 : Error messages should be more informative
*         - Added printf-args to error messages, added "Error:" prefix.
*
* Revision 1.13  2011/07/12 22:47:59  pauloscustodio
* - Moved all error variables and error reporting code to a separate module errors.c,
*   replaced all extern declarations of these variables by include errors.h,
*   created symbolic constants for error codes.
* - Added test scripts for error messages.
*
* Revision 1.12  2011/07/11 15:59:51  pauloscustodio
* Moved all option variables and option handling code to a separate module options.c,
* replaced all extern declarations of these variables by include options.h.
*
* Revision 1.11  2011/07/09 18:25:35  pauloscustodio
* Log keyword in checkin comment was expanded inside Log expansion... recursive
* Added Z80asm banner to all source files
*
* Revision 1.10  2011/07/09 17:36:09  pauloscustodio
* Copied cvs log into Log history
*
* Revision 1.9  2011/07/09 01:46:00  pauloscustodio
* Added Log keyword
*
* Revision 1.8  2011/07/09 01:19:18  pauloscustodio
* added casts to clean up warnings
* BUG_0004 : 8bit unsigned constants are not checked for out-of-range
*      Added the check to ExprUnsigned8() and Z80pass2().
* BUG_0005 : Offset of (ix+d) should be optional; '+' or '-' are necessary
*      ExprSigned8(): Accept (ix) and (iy), use offset zero.
*      Raise syntax error for (ix 4), was accepting as (ix+4).
* CH_0002 : Unary plus and unary minus added to Factor()
*      Accept unary minus and unary plus in factor to allow (ix+ -3) to be
*      parsed as (ix-3).
*
* Revision 1.7  2010/09/19 00:06:20  dom
* Tweaks for compiling code generated by sdcc - it generates XREF rather than
* LIB so treat XREF as a LIB (this possibly should be the default)
*
* Do some _ mapping magic when in sdcc so standard z88dk libs can be used
* (wrong _ convention chosen a long time ago...)
*
* Have -forcexlib flag which treats MODULE as XLIB.
*
* Revision 1.6  2010/04/16 17:34:37  dom
* Make line number an int - 32768 lines isn't big enough...
*
* Revision 1.5  2009/07/18 23:23:15  dom
* clean up the code a bit more (Formatting and a fewer magic numbers)
*
* Revision 1.4  2008/06/02 19:03:12  dom
* Handle < and > operators.
*
* I have no idea where they got to!
*
* Revision 1.3  2007/06/17 12:07:43  dom
* Commit the rabbit emulation code including rrd, rld
*
* Add a .vcproj for visual studio
*
* Revision 1.2  2003/10/11 15:41:04  dom
* changes from garry
*
* - support for defp -> defp addr,bank
* - square brackets can be used in expressions
* - comma can be used in defm
*
* Revision 1.1  2000/07/04 15:33:30  dom
* branches:  1.1.1;
* Initial revision
*
* Revision 1.1.1.1  2000/07/04 15:33:30  dom
* First import of z88dk into the sourceforge system <gulp>
*
*/

/* $History: EXPRPRSR.C $ */
/*  */
/* *****************  Version 15  ***************** */
/* User: Gbs          Date: 26-01-00   Time: 22:10 */
/* Updated in $/Z80asm */
/* Expression range validation removed from 8bit unsigned (redundant). */
/*  */
/* *****************  Version 13  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 20:05 */
/* Updated in $/Z80asm */
/* "PC" program counter changed to long (from unsigned short). */
/*  */
/* *****************  Version 11  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 12:12 */
/* Updated in $/Z80asm */
/* Added Ascii Art "Z80asm" at top of source file. */
/*  */
/* *****************  Version 9  ***************** */
/* User: Gbs          Date: 6-06-99    Time: 11:29 */
/* Updated in $/Z80asm */
/* "config.h" included before "symbol.h" */
/*  */
/* *****************  Version 8  ***************** */
/* User: Gbs          Date: 2-05-99    Time: 18:04 */
/* Updated in $/Z80asm */
/* General improvements on EvalPfixExpr(), due to changes in declaration */
/* rules of XDEF, XREF and LIB. */
/*  */
/* *****************  Version 6  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 5  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 14:24 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 7-03-99    Time: 13:13 */
/* Updated in $/Z80asm */
/* Minor changes to keep C compiler happy. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:06 */
/* Updated in $/Z80asm */
/* Improved handling of fgetc() character reading in relation to premature */
/* EOF handling (for character constants in expressions). */
