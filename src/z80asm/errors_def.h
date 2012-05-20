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
Copyright (C) Paulo Custodio, 2011

Define error codes and error messages
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/errors_def.h,v 1.2 2012-05-20 05:38:19 pauloscustodio Exp $ */
/* $Log: errors_def.h,v $
/* Revision 1.2  2012-05-20 05:38:19  pauloscustodio
/* ERR_SYMBOL_DECL_GLOBAL seams to be impossible to get. Added comment on this,
/* changed test error-18.t
/*
/* Revision 1.1  2012/05/17 20:31:45  pauloscustodio
/* New errors_def.h with error name and string together, for easier maintenance
/*
/*
/* */

/* 0  */ DEF_MSG( ERR_FILE_OPEN,              "File '%s' open error" )
/* 1  */ DEF_MSG( ERR_SYNTAX,                 "Syntax error" )
/* 2  */ DEF_MSG( ERR_NOT_DEFINED,            "Symbol not defined" )
/* 3  */ DEF_MSG( ERR_NO_MEMORY,              "Not enough memory" )
/* 4  */ DEF_MSG( ERR_INT_RANGE,              "Integer '%ld' out of range" )
/* 5  */ DEF_MSG( ERR_EXPR_SYNTAX,            "Syntax error in expression" )
/* 6  */ DEF_MSG( ERR_UNBALANCED_PAREN,       "Unbalanced parenthesis" )
/* 7  */ DEF_MSG( ERR_RANGE,                  "Out of range" )   /* not used */
/* 8  */ DEF_MSG( ERR_NO_SRC_FILE,            "Source filename missing" )
/* 9  */ DEF_MSG( ERR_ILLEGAL_OPTION,         "Illegal option '-%s'" )
/* 10 */ DEF_MSG( ERR_UNKNOWN_IDENT,          "Unknown identifier" )
/* 11 */ DEF_MSG( ERR_ILLEGAL_IDENT,          "Illegal identifier" )
/* 12 */ DEF_MSG( ERR_MAX_CODESIZE,           "Max. code size of %ld bytes reached" )
/* 13 */ DEF_MSG( ERR_TOTALERRORS,            "%d errors occurred during assembly" )
/* 14 */ DEF_MSG( ERR_SYMBOL_REDEFINED,       "Symbol '%s' already defined" )
/* 15 */ DEF_MSG( ERR_MODULE_REDEFINED,       "Module name already defined" )
/* 16 */ DEF_MSG( ERR_MODULE_NOT_DEFINED,     "Module name not defined" ) /* not used */
/* 17 */ DEF_MSG( ERR_SYMBOL_DECL_LOCAL,      "Symbol '%s' already declared local" )
/* 18 */ DEF_MSG( ERR_SYMBOL_DECL_GLOBAL,     "Symbol '%s' already declared global" ) /* not used? */
/* 19 */ DEF_MSG( ERR_SYMBOL_DECL_EXTERN,     "Symbol '%s' already declared external" )  /* not used */
/* 20 */ DEF_MSG( ERR_NO_CMD_ARGS,            "No command line arguments" )  /* not used */
/* 21 */ DEF_MSG( ERR_ILLEGAL_SRC_FILENAME,   "Illegal source filename '%s'" )
/* 22 */ DEF_MSG( ERR_SYMBOL_REDECL_GLOBAL,   "Symbol '%s' declared global in another module" )
/* 23 */ DEF_MSG( ERR_SYMBOL_REDECL,          "Re-declaration of '%s' not allowed" )
/* 24 */ DEF_MSG( ERR_ORG_REDEFINED,          "ORG already defined" ) /* not used */
/* 25 */ DEF_MSG( ERR_JR_NOT_LOCAL,           "Relative jump address must be local" )
/* 26 */ DEF_MSG( ERR_NOT_OBJ_FILE,           "File '%s' not an object file" )
/* 27 */ DEF_MSG( ERR_RESERVED_NAME,          "Reserved name" )  /* not used */
/* 28 */ DEF_MSG( ERR_OPEN_LIB,               "Couldn't open library file '%s'" )
/* 29 */ DEF_MSG( ERR_NOT_LIB_FILE,           "File '%s' not a library file" )
/* 30 */ DEF_MSG( ERR_ENV_NOT_DEFINED,        "Environment variable '%s' not defined" )
/* 31 */ DEF_MSG( ERR_INCLUDE_RECURSION,      "Cannot include file '%s' recursively" )
/* 32 */ DEF_MSG( ERR_FILE_IO,                "File I/O error" )
