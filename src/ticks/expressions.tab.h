/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_EXPRESSIONS_TAB_H_INCLUDED
# define YY_YY_EXPRESSIONS_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    T_PRIMITIVE_VALUE = 258,       /* T_PRIMITIVE_VALUE  */
    T_STRING = 259,                /* T_STRING  */
    T_HISTORY_STRING = 260,        /* T_HISTORY_STRING  */
    T_ERROR = 261,                 /* T_ERROR  */
    T_PRIMITIVE_TYPE = 262,        /* T_PRIMITIVE_TYPE  */
    T_PLUS = 263,                  /* T_PLUS  */
    T_MINUS = 264,                 /* T_MINUS  */
    T_STAR = 265,                  /* T_STAR  */
    T_DIVIDE = 266,                /* T_DIVIDE  */
    T_LEFT = 267,                  /* T_LEFT  */
    T_RIGHT = 268,                 /* T_RIGHT  */
    T_LEFT_BRACKET = 269,          /* T_LEFT_BRACKET  */
    T_RIGHT_BRACKET = 270,         /* T_RIGHT_BRACKET  */
    T_AMPERSAND = 271,             /* T_AMPERSAND  */
    T_DOT = 272,                   /* T_DOT  */
    T_ARROW = 273,                 /* T_ARROW  */
    T_SLASH = 274                  /* T_SLASH  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 17 "expressions.y"

    struct expression_result_t val;
    type_record type;
    char cval[128];
    char errval[128];

#line 90 "expressions.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_EXPRESSIONS_TAB_H_INCLUDED  */
