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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/errors_def.h,v 1.3 2012-05-23 20:45:42 pauloscustodio Exp $ */
/* $Log: errors_def.h,v $
/* Revision 1.3  2012-05-23 20:45:42  pauloscustodio
/* Replace ERR_FILE_OPEN by ERR_FOPEN_READ and ERR_FOPEN_WRITE.
/* Add tests.
/*
/* Revision 1.2  2012/05/20 05:38:19  pauloscustodio
/* ERR_SYMBOL_DECL_GLOBAL seams to be impossible to get. Added comment on this,
/* changed test error-18.t
/*
/* Revision 1.1  2012/05/17 20:31:45  pauloscustodio
/* New errors_def.h with error name and string together, for easier maintenance
/*
/*
/* */

DEF_MSG( ERR_OK,                    "OK" ) /* not used */
DEF_MSG( ERR_FOPEN_READ,            "Cannot open file '%s' for reading" )
DEF_MSG( ERR_FOPEN_WRITE,           "Cannot open file '%s' for writing" )

DEF_MSG( ERR_SYNTAX,                "Syntax error" )
DEF_MSG( ERR_NOT_DEFINED,           "Symbol not defined" )
DEF_MSG( ERR_NO_MEMORY,             "Not enough memory" )
DEF_MSG( ERR_INT_RANGE,             "Integer '%ld' out of range" )
DEF_MSG( ERR_EXPR_SYNTAX,           "Syntax error in expression" )
DEF_MSG( ERR_UNBALANCED_PAREN,      "Unbalanced parenthesis" )
DEF_MSG( ERR_RANGE,                 "Out of range" )   /* not used */
DEF_MSG( ERR_NO_SRC_FILE,           "Source filename missing" )
DEF_MSG( ERR_ILLEGAL_OPTION,        "Illegal option '-%s'" )
DEF_MSG( ERR_UNKNOWN_IDENT,         "Unknown identifier" )
DEF_MSG( ERR_ILLEGAL_IDENT,         "Illegal identifier" )
DEF_MSG( ERR_MAX_CODESIZE,          "Max. code size of %ld bytes reached" )
DEF_MSG( ERR_TOTALERRORS,           "%d errors occurred during assembly" )
DEF_MSG( ERR_SYMBOL_REDEFINED,      "Symbol '%s' already defined" )
DEF_MSG( ERR_MODULE_REDEFINED,      "Module name already defined" )
DEF_MSG( ERR_MODULE_NOT_DEFINED,    "Module name not defined" ) /* not used */
DEF_MSG( ERR_SYMBOL_DECL_LOCAL,     "Symbol '%s' already declared local" )
DEF_MSG( ERR_SYMBOL_DECL_GLOBAL,    "Symbol '%s' already declared global" ) /* not used? */
DEF_MSG( ERR_SYMBOL_DECL_EXTERN,    "Symbol '%s' already declared external" )  /* not used */
DEF_MSG( ERR_NO_CMD_ARGS,           "No command line arguments" )  /* not used */
DEF_MSG( ERR_ILLEGAL_SRC_FILENAME,  "Illegal source filename '%s'" )
DEF_MSG( ERR_SYMBOL_REDECL_GLOBAL,  "Symbol '%s' declared global in another module" )
DEF_MSG( ERR_SYMBOL_REDECL,         "Re-declaration of '%s' not allowed" )
DEF_MSG( ERR_ORG_REDEFINED,         "ORG already defined" ) /* not used */
DEF_MSG( ERR_JR_NOT_LOCAL,          "Relative jump address must be local" )
DEF_MSG( ERR_NOT_OBJ_FILE,          "File '%s' not an object file" )
DEF_MSG( ERR_RESERVED_NAME,         "Reserved name" )  /* not used */
DEF_MSG( ERR_OPEN_LIB,              "Couldn't open library file '%s'" )
DEF_MSG( ERR_NOT_LIB_FILE,          "File '%s' not a library file" )
DEF_MSG( ERR_ENV_NOT_DEFINED,       "Environment variable '%s' not defined" )
DEF_MSG( ERR_INCLUDE_RECURSION,     "Cannot include file '%s' recursively" )
DEF_MSG( ERR_FILE_IO,               "File I/O error" )
