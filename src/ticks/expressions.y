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
    struct {
    	type_chain type;
    	uint8_t is_signed;
    } type;
    char cval[128];
    char errval[128];
}

%token<val> T_PRIMITIVE_VALUE
%token<ptr> T_POINTER
%token<cval> T_STRING

%token<errval> T_ERROR
%token T_PRIMITIVE_TYPE
%token T_PLUS T_MINUS T_STAR T_DIVIDE T_LEFT T_RIGHT
%token T_AMPERSAND
%left T_PLUS T_MINUS
%left T_STAR T_SLASH
%left T_AMPERSAND

%type<val> value_expression
%type<type> type_expression
%type<val> pointer_expression
%type<errval> error_expression

%destructor {
	expression_result_free_typechain(&$$);
} value_expression pointer_expression

%start calculation

%%

calculation:
	| value_expression 							{ *get_expression_result() = $1; }
	| pointer_expression 							{ *get_expression_result() = $1; }
	| error_expression 							{ set_expression_result_error(get_expression_result(), $1); }
;

pointer_expression: T_POINTER
	| T_AMPERSAND value_expression						{
		$$.type.type_ = TYPE_GENERIC_POINTER;
		$$.as_pointer.ptr = $2.memory_location;
		$$.as_pointer.element_size = $2.memory_size;
		$$.type.next = copy_type_chain(&$2.type);
		set_expression_signed(&$$, is_expression_signed(&$2));
	 }
	| T_LEFT type_expression T_STAR T_RIGHT pointer_expression		{ expression_value_to_pointer(&$5, &$$, &$2.type, $2.is_signed); }
	| T_LEFT type_expression T_STAR T_RIGHT value_expression		{ expression_value_to_pointer(&$5, &$$, &$2.type, $2.is_signed); }
	| T_LEFT pointer_expression T_RIGHT					{ $$ = $2; }
	| pointer_expression T_PLUS value_expression				{
		$$ = $1;
		if (is_primitive_integer_type(&$3)) {
			$$.as_pointer.ptr += $3.as_int * $$.as_pointer.element_size;
		} else {
			$$.flags |= EXPRESSION_ERROR;
			sprintf($$.as_error, "Cannot do math with non-integer");
		}
	 }
	 | pointer_expression T_MINUS value_expression				{
		$$ = $1;
		if (is_primitive_integer_type(&$3)) {
			$$.as_pointer.ptr -= $3.as_int * $$.as_pointer.element_size;
		} else {
			$$.flags |= EXPRESSION_ERROR;
			sprintf($$.as_error, "Cannot do math with non-integer");
		}
	 }
;

type_expression: T_PRIMITIVE_TYPE
;

value_expression: T_PRIMITIVE_VALUE
	| T_STAR pointer_expression						{ expression_dereference_pointer(&$2, &$$); }
	| T_LEFT type_expression T_RIGHT value_expression			{ convert_expression(&$4, &$$, $2.type.type_, $2.is_signed); }
	| T_LEFT value_expression T_RIGHT					{ $$ = $2; }
	| value_expression T_PLUS value_expression				{ expression_math_add(&$1, &$3, &$$); }
	| value_expression T_MINUS value_expression				{ expression_math_sub(&$1, &$3, &$$); }
	| value_expression T_SLASH value_expression				{ expression_math_div(&$1, &$3, &$$); }
	| value_expression T_STAR value_expression				{ expression_math_mul(&$1, &$3, &$$); }

error_expression: T_ERROR							{ strcpy($$, $1); }
;

%%

void evaluate_expression_string(const char* expr)
{
    reset_expression_result(get_expression_result());
    YY_BUFFER_STATE st = yy_scan_string (expr);
    yyparse();
    yy_delete_buffer(st);
}

void yyerror(const char* s)
{
    if (!is_expression_result_error(get_expression_result()))
    {
    	set_expression_result_error(get_expression_result(), s);
    }
}