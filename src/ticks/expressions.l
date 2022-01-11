%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "exp_engine.h"
#include "expressions.tab.h"

int lookup_word();

%}

word [a-zA-Z_][a-zA-Z0-9_]*
multiple_words "unsigned char"|"unsigned short"|"unsigned int"|"unsigned long"

%%

[ \t]	; // ignore all whitespace
-?[0-9]+\.[0-9]+ 	{ yylval.val.type.type_ = TYPE_FLOAT; yylval.val.as_float = atof(yytext); return T_PRIMITIVE_VALUE; }
-?[0-9]+		    { yylval.val.type.type_ = TYPE_LONG; yylval.val.flags |= EXPRESSION_TYPE_SIGNED; yylval.val.as_int = atoi(yytext); return T_PRIMITIVE_VALUE; }
0x[0-9a-fA-F]+		{ yylval.val.type.type_ = TYPE_LONG; yylval.val.flags |= EXPRESSION_TYPE_SIGNED; sscanf(yytext + 2, "%x", &yylval.val.as_int); return T_PRIMITIVE_VALUE; }
"&"		            { return T_AMPERSAND; }
{multiple_words}	{ return lookup_word(); }
{word}		        { return lookup_word(); }
"+"		            {return T_PLUS;}
"-"		            {return T_MINUS;}
"*"		            {return T_STAR;}
"/"		            {return T_SLASH;}
"("		            {return T_LEFT;}
")"		            {return T_RIGHT;}

%%

int lookup_word() {
    // it it a type?
    {
        uint8_t is_signed = 0;
        type_chain type = expression_string_get_type(yytext, &is_signed);
        if (type.type_ != TYPE_UNKNOWN) {
            yylval.type.type = type;
            yylval.type.is_signed = is_signed;
            return T_PRIMITIVE_TYPE;
        }
    }

    struct expression_result_t result = {};
    struct lookup_t lookup;
    lookup.symbol_name = yytext;
    debug_lookup_symbol(&lookup, &result);

    if (is_expression_result_error(&result)) {
        strcpy(yylval.errval, result.as_error);
        return T_ERROR;
    }

    switch (result.type.type_)
    {
        case TYPE_UNKNOWN:
        {
            strcpy(yylval.errval, "<unknown>");
            return T_ERROR;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER:
        {
            yylval.val = result;
            return T_POINTER;
        }
        default:
        {
            yylval.val = result;
            return T_PRIMITIVE_VALUE;
        }
    }

    return T_PRIMITIVE_VALUE;
}