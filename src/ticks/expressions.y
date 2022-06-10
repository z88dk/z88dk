%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "exp_engine.h"

extern int yylex();
extern int yyparse();
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string (const char * yystr);
extern void yy_delete_buffer (YY_BUFFER_STATE  b );

void yyerror(const char* s);
%}

%union {
    struct expression_result_t val;
    type_record type;
    char cval[128];
    char errval[128];
}

%token<val> T_PRIMITIVE_VALUE
%token<cval> T_STRING
%token<cval> T_HISTORY_STRING

%token<errval> T_ERROR
%token T_PRIMITIVE_TYPE
%token T_PLUS T_MINUS T_STAR T_DIVIDE T_LEFT T_RIGHT T_LEFT_BRACKET T_RIGHT_BRACKET
%token T_AMPERSAND T_DOT T_ARROW
%left T_PLUS T_MINUS
%left T_STAR T_SLASH
%left T_AMPERSAND

%type<val> value_expression
%type<type> type_expression
%type<errval> error_expression

%destructor { expression_result_free(&$$); } T_PRIMITIVE_VALUE
%destructor { expression_result_free(&$$); } value_expression
%destructor { free_type($$.first); } type_expression

%start calculation

%%

calculation:
	| value_expression 							{ *get_expression_result() = $1; }
	| error_expression 							{ set_expression_result_error_str(get_expression_result(), $1); }
;

type_expression: T_PRIMITIVE_TYPE
;

value_expression: T_PRIMITIVE_VALUE
	| T_STRING								{
    		zero_expression_result(&$$);
    		struct lookup_t lookup = {0};
    		lookup.symbol_name = $1;
    		debug_lookup_symbol(&lookup, &$$);
	}
	| T_HISTORY_STRING							{
    		zero_expression_result(&$$);
    		debug_lookup_history($1, &$$);
	}
	| value_expression T_DOT T_STRING					{ expression_resolve_struct_member(&$1, $3, &$$); expression_result_free(&$1); }
	| value_expression T_ARROW T_STRING					{ expression_resolve_struct_member_ptr(&$1, $3, &$$); expression_result_free(&$1); }
	| T_STAR value_expression						{ expression_dereference_pointer(&$2, &$$); expression_result_free(&$2); }
	| T_LEFT type_expression T_RIGHT value_expression			{ convert_expression(&$4, &$$, &$2); free_type($2.first); expression_result_free(&$4); }
	| T_LEFT value_expression T_RIGHT					{ $$ = $2; }
	| value_expression T_PLUS value_expression				{ expression_math_add(&$1, &$3, &$$); expression_result_free(&$1); expression_result_free(&$3); }
	| value_expression T_MINUS value_expression				{ expression_math_sub(&$1, &$3, &$$); expression_result_free(&$1); expression_result_free(&$3); }
	| value_expression T_SLASH value_expression				{ expression_math_div(&$1, &$3, &$$); expression_result_free(&$1); expression_result_free(&$3); }
	| value_expression T_STAR value_expression				{ expression_math_mul(&$1, &$3, &$$); expression_result_free(&$1); expression_result_free(&$3); }
	| value_expression T_LEFT_BRACKET value_expression T_RIGHT_BRACKET    {
		if (is_type_a_pointer($1.type.first)) {
			if ($3.type.first == NULL) {
				$$.flags |= EXPRESSION_ERROR;
				sprintf($$.as_error, "Cannot do math with void");
			} else {
				if (is_primitive_integer_type($3.type.first)) {
					$1.as_pointer.ptr += $3.as_int * get_type_memory_size($1.type.first->next);
					expression_dereference_pointer(&$1, &$$);
					expression_result_free(&$1);
					expression_result_free(&$3);
				} else {
					$$.flags |= EXPRESSION_ERROR;
					sprintf($$.as_error, "Cannot index pointer by non-integer");
				}
			}
		} else {
			$$.flags |= EXPRESSION_ERROR;
			sprintf($$.as_error, "Cannot index non-pointer");
		}
	}
	| T_AMPERSAND value_expression						{
		$$.type = $2.type;
		$$.type.first = malloc_type(TYPE_GENERIC_POINTER);
		$$.type.first->next = copy_type_chain($2.type.first);
		$$.as_pointer.ptr = $2.memory_location;
		expression_result_free(&$2);
	 }
	| T_LEFT type_expression T_STAR T_RIGHT value_expression		{ expression_value_to_pointer(&$5, &$$, &$2); free_type($2.first); expression_result_free(&$5); }
	| T_STRING T_LEFT value_expression T_RIGHT 				{ expression_primitive_func_call_1($1, &$3, &$$); expression_result_free(&$3); }

error_expression: T_ERROR							{ strcpy($$, $1); }
;

%%

void evaluate_expression_string(const char* expr)
{
    YY_BUFFER_STATE st = yy_scan_string (expr);
    yyparse();
    yy_delete_buffer(st);
}

void yyerror(const char* s)
{
    if (!is_expression_result_error(get_expression_result()))
    {
    	set_expression_result_error_str(get_expression_result(), s);
    }
}
