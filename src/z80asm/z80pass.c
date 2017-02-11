/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm
*/

#include "limits.h"
#include "listfile.h"
#include "modlink.h"
#include "symbol.h"

/* external functions */

/* local functions */
void Z80pass2( void );

void
Z80pass2( void )
{
	ExprListElem *iter;
    Expr *expr, *expr2;
    long value;
	Bool do_patch, do_store;

	/* compute all dependent expressions */
	compute_equ_exprs( CURRENTMODULE->exprs, FALSE, TRUE );

	iter = ExprList_first( CURRENTMODULE->exprs );
	while ( iter != NULL )
	{
		expr = iter->obj;

        /* set error location */
		set_error_null();
        set_error_file( expr->filename );
        set_error_line( expr->line_nr );

		/* Define code location; BUG_0048 */
		set_cur_section( expr->section );
		set_PC( expr->asmpc );		

		/* try to evaluate expression to detect missing symbols */
		value = Expr_eval(expr, TRUE);

		/* check if expression is stored in object file or computed and patched */
		do_patch = TRUE;
		do_store = FALSE;

		if ( expr->result.undefined_symbol ) 
		{
			do_patch = FALSE;
		}
		else if ( expr->range == RANGE_JR_OFFSET )
		{
			if (expr->result.extern_symbol || expr->result.cross_section_addr)
			{
				error_jr_not_local();	/* JR must be local */
				do_patch = FALSE;
			}
		}
		else if ( ( (expr->type >= TYPE_ADDRESS) || expr->result.extern_symbol ) )
		{
			do_patch = FALSE;
			do_store = TRUE;            /* store expression in relocatable file */
		}
		else if ( expr->result.not_evaluable )
		{
			do_patch = FALSE;
		}

        if ( do_patch )
        {
            switch ( expr->range )
            {
            case RANGE_JR_OFFSET:
                value -= get_PC() + 2;		/* get module PC at JR instruction */

                if ( value >= -128 && value <= 127 )
                {
					patch_byte(expr->code_pos, (Byte)value);
                    /* opcode is stored, now store relative jump */
                }
                else
                {
                    error_int_range( value );
                }
                break;

			case RANGE_BYTE_UNSIGNED:
                if ( value < -128 || value > 255 )
                    warn_int_range( value );

				patch_byte(expr->code_pos, (Byte)value);
                break;

            case RANGE_BYTE_SIGNED:
                if ( value < -128 || value > 127 )
                    warn_int_range( value );

				patch_byte(expr->code_pos, (Byte)value);
                break;

            case RANGE_WORD:
                if ( value < -32768 || value > 65535 )
                    warn_int_range( value );

				patch_word(expr->code_pos, (int)value);
                break;

            case RANGE_DWORD:
                if ( value < LONG_MIN || value > LONG_MAX )
                    warn_int_range( value );

				patch_long(expr->code_pos, value);
                break;

			default:
				assert(0);
            }
        }

		if ( opts.list )
			list_patch_data( expr->listpos, value, range_size( expr->range ) );
			
		/* continue loop - delete expression unless needs to be stored in object file */
		if ( do_store )
			iter = ExprList_next( iter );
		else
		{
			/* remove current expression, advance iterator */
			expr2 = ExprList_remove( CURRENTMODULE->exprs, &iter );
			assert( expr == expr2 );

			OBJ_DELETE( expr );	
		}
    }

    /* clean error location */
    set_error_null();
    //set_error_module( CURRENTMODULE->modname );

	/* create object file */
	if ( ! get_num_errors() )
		write_obj_file( CURRENTMODULE->filename );

    if ( ! get_num_errors() && opts.symtable )
		write_sym_file(CURRENTMODULE);
}


Bool Pass2infoExpr(range_t range, Expr *expr)
{
	int list_offset;

	if (expr != NULL)
	{
		expr->range = range;
		expr->code_pos = get_cur_module_size();			/* update expression location */
		list_offset = expr->code_pos - get_PC();

		if (opts.cur_list)
			expr->listpos = list_patch_pos(list_offset);	/* now calculated as absolute file pointer */
		else
			expr->listpos = -1;

		ExprList_push(&CURRENTMODULE->exprs, expr);
	}

	/* reserve space */
	append_defs(range_size(range), 0);

	return expr == NULL ? FALSE : TRUE;
}

Bool Pass2info(range_t range)
{
	Expr *expr;
	
	/* Offset of (ix+d) should be optional; '+' or '-' are necessary */
	if (range == RANGE_BYTE_SIGNED)
	{
		switch (sym.tok)
		{
		case TK_RPAREN:
			append_byte(0);		/* offset zero */
			return TRUE;		/* OK, zero already stored */

		case TK_PLUS:
		case TK_MINUS:          /* + or - expected */
			break;				/* proceed to evaluate expression */

		default:                /* Syntax error, e.g. (ix 4) */
			error_syntax();
			return FALSE;		/* FAIL */
		}

	}

	expr = expr_parse();

	if (range == RANGE_BYTE_SIGNED && sym.tok != TK_RPAREN)
	{
		error_syntax();
		return FALSE;		/* FAIL */
	}

	return Pass2infoExpr(range, expr);
}
