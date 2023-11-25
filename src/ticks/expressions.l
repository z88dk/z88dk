%option noyywrap never-interactive

%top{
#include <stdint.h>
}

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "exp_engine.h"
#include "expressions.tab.h"

int lookup_word();

%}

history_expr $[a-zA-Z0-9_]+
word [a-zA-Z_][a-zA-Z0-9_]*
struct_word "struct "[a-zA-Z_][a-zA-Z0-9_]*
multiple_words "unsigned char"|"unsigned short"|"unsigned int"|"unsigned long"

%%

[ \t]	; // ignore all whitespace
-?[0-9]+\.[0-9]+ 	{
    zero_expression_result(&yylval.val);
    yylval.val.type.first = malloc_type(TYPE_FLOAT);
    yylval.val.as_float = (float)atof(yytext);
    return T_PRIMITIVE_VALUE;
}
-?[0-9]+		    {
    zero_expression_result(&yylval.val);
    yylval.val.type.first = malloc_type(TYPE_LONG);
    yylval.val.type.signed_ = 1;
    yylval.val.as_int = atoi(yytext);
    return T_PRIMITIVE_VALUE;
}
0x[0-9a-fA-F]+		{
    zero_expression_result(&yylval.val);
    yylval.val.type.first = malloc_type(TYPE_LONG);
    yylval.val.type.signed_ = 1;
    sscanf(yytext + 2, "%x", &yylval.val.as_int);
    return T_PRIMITIVE_VALUE;
}
"&"		            { return T_AMPERSAND; }
"."		            { return T_DOT; }
"->"		        { return T_ARROW; }
{history_expr}		{ strcpy(yylval.cval, yytext); return T_HISTORY_STRING; }
{multiple_words}	{ return lookup_word(); }
{word}		        { return lookup_word(); }
{struct_word}       { return lookup_word(); }
"+"		            { return T_PLUS; }
"-"		            { return T_MINUS; }
"*"		            { return T_STAR; }
"/"		            { return T_SLASH; }
"("		            { return T_LEFT; }
")"		            { return T_RIGHT; }
"["		            { return T_LEFT_BRACKET; }
"]"		            { return T_RIGHT_BRACKET; }

%%

int lookup_word() {
    // it it a type?
    {
        type_record type = {0};
        expression_string_get_type(yytext, &type);
        if (type.first->type_ != TYPE_UNKNOWN) {
            yylval.type = type;
            return T_PRIMITIVE_TYPE;
        }
        free_type(type.first);
    }

    strcpy(yylval.cval, yytext);
    return T_STRING;
}
