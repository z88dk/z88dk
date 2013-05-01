/* A Bison parser, made by GNU Bison 2.4.2.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2006, 2009-2010 Free Software
   Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* "%code requires" blocks.  */



#include "memalloc.h"   /* before any other include */





/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IN = 258,
     LD = 259,
     NOP = 260,
     PUSH = 261,
     POP = 262,
     ADC = 263,
     JR = 264,
     JP = 265,
     B = 266,
     C = 267,
     D = 268,
     E = 269,
     H = 270,
     L = 271,
     A = 272,
     BC = 273,
     DE = 274,
     HL = 275,
     AF = 276,
     SP = 277,
     NC = 278,
     NZ = 279,
     Z = 280,
     PO = 281,
     PE = 282,
     P = 283,
     M = 284,
     NUMBER = 285,
     STRING = 286,
     NAME = 287,
     EQUAL_EQUAL = 288,
     LESS_GREATER = 289,
     NOT_EQUAL = 290,
     LESS_EQUAL = 291,
     GREATER_EQUAL = 292,
     DBL_VBAR = 293,
     DBL_AMPERSAND = 294,
     DBL_LESS = 295,
     DBL_GREATER = 296,
     DBL_ASTERISK = 297
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{


	long 	lval;
	char   *sval;



} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


/* "%code provides" blocks.  */



extern int  yyparse();
extern void yyerror(const char *s);




