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
-?[0-9]+\.[0-9]+ 	{
    memset(&yylval.val.type, 0, sizeof(yylval.val.type));
    yylval.val.type.first = malloc_type(TYPE_FLOAT);
    yylval.val.as_float = atof(yytext);
    return T_PRIMITIVE_VALUE;
}
-?[0-9]+		    {
    memset(&yylval.val.type, 0, sizeof(yylval.val.type));
    yylval.val.type.first = malloc_type(TYPE_LONG);
    yylval.val.type.signed_ = 1;
    yylval.val.as_int = atoi(yytext);
    return T_PRIMITIVE_VALUE;
}
0x[0-9a-fA-F]+		{
    memset(&yylval.val.type, 0, sizeof(yylval.val.type));
    yylval.val.type.first = malloc_type(TYPE_LONG);
    yylval.val.type.signed_ = 1;
    sscanf(yytext + 2, "%x", &yylval.val.as_int);
    return T_PRIMITIVE_VALUE;
}
"&"		            { return T_AMPERSAND; }
{multiple_words}	{ return lookup_word(); }
{word}		        { return lookup_word(); }
"+"		            { return T_PLUS; }
"-"		            { return T_MINUS; }
"*"		            { return T_STAR; }
"/"		            { return T_SLASH; }
"("		            { return T_LEFT; }
")"		            { return T_RIGHT; }

%%

int lookup_word() {
    // it it a type?
    {
        type_record type = {};
        expression_string_get_type(yytext, &type);
        if (type.first->type_ != TYPE_UNKNOWN) {
            yylval.type = type;
            return T_PRIMITIVE_TYPE;
        }
        free_type(type.first);
    }

    struct expression_result_t result = {};
    struct lookup_t lookup;
    lookup.symbol_name = yytext;
    debug_lookup_symbol(&lookup, &result);
    if (is_expression_result_error(&result)) {
        strcpy(yylval.errval, result.as_error);
        return T_ERROR;
    }
    if (result.type.first == NULL) {
        yylval.val = result;
        return T_PRIMITIVE_VALUE;
    }
    switch (result.type.first->type_) {
        case TYPE_UNKNOWN: {
            strcpy(yylval.errval, "<unknown>");
            return T_ERROR;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            yylval.val = result;
            return T_POINTER;
        }
        default: {
            yylval.val = result;
            return T_PRIMITIVE_VALUE;
        }
    }

    return T_PRIMITIVE_VALUE;
}