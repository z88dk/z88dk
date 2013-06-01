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
Copyright (C) Paulo Custodio, 2011-2013

Define error codes and error messages
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/errors_def.h,v 1.13 2013-06-01 01:24:21 pauloscustodio Exp $ */
/* $Log: errors_def.h,v $
/* Revision 1.13  2013-06-01 01:24:21  pauloscustodio
/* CH_0022 : Replace avltree by hash table for symbol table
/*
/* Revision 1.12  2013/05/11 00:29:26  pauloscustodio
/* CH_0021 : Exceptions on file IO show file name
/* Keep a hash table of all opened file names, so that the file name
/* is shown on a fatal error.
/* Rename file IO funtions: f..._err to xf...
/*
/* Revision 1.11  2013/05/01 19:03:45  pauloscustodio
/* Simplified scanner and adapted to be used with a BISON generated parser.
/* Removed balanced struct checking and token ring.
/* Removed start condition to list assembly lines, as it was difficult to keep in sync across included
/* files; inserted an RS char in the input before each line to trigger listing.
/* Allow ".NAME" and "NAME:" to return a NAME token, so that ".LD" is recognized as a label and not the LD assembly statement.
/* Added Integer out of range warning to number scanning routine.
/* Allow input lines to be any size, as long as memory can be allocated.
/* Created a skeleton BISON parser.
/*
/* Revision 1.10  2013/04/07 23:34:19  pauloscustodio
/* CH_0020 : ERR_ORG_NOT_DEFINED if no ORG given
/* z80asm no longer asks for an ORG address from the standard input
/* if one is not given either by an ORG statement or a -r option;
/* it exists with an error message instead.
/* The old behaviour was causing wrong build scripts to hang waiting
/* for input.
/*
/* Revision 1.9  2013/03/29 23:53:08  pauloscustodio
/* Added GNU Flex-based scanner. Not yet integrated into assembler.
/*
/* Revision 1.8  2013/02/12 00:48:54  pauloscustodio
/* CH_0017 : Align with spaces, deprecate -t option
/*
/* Revision 1.7  2013/01/20 21:24:28  pauloscustodio
/* Updated copyright year to 2013
/*
/* Revision 1.6  2012/05/26 18:51:10  pauloscustodio
/* CH_0012 : wrappers on OS calls to raise fatal error
/* CH_0013 : new errors interface to decouple calling code from errors.c
/*
/* Revision 1.5  2012/05/24 17:09:27  pauloscustodio
/* Unify copyright header
/*
/* Revision 1.4  2012/05/24 16:20:52  pauloscustodio
/* ERR_EXPR_SYNTAX renamed ERR_SYNTAX_EXPR (consistency)
/*
/* Revision 1.3  2012/05/23 20:45:42  pauloscustodio
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

/* information */
DEF_MSG( ERR_OK,                    "OK" ) /* not used */
DEF_MSG( ERR_TOTALERRORS,           "%d errors occurred during assembly" )
DEF_MSG( ERR_OPTION_DEPRECATED,		"option '-%s' is deprecated" )

/* system errors */
DEF_MSG( ERR_NO_MEMORY,             "Not enough memory" )
DEF_MSG( ERR_RUNTIME,               "Run-time error" )

/* file errors */
DEF_MSG( ERR_FOPEN_READ,            "Cannot open file '%s' for reading" )
DEF_MSG( ERR_FOPEN_WRITE,           "Cannot open file '%s' for writing" )
DEF_MSG( ERR_FCLOSE,				"Cannot close file '%s'" )
DEF_MSG( ERR_FWRITE,				"Cannot write to file '%s'" )
DEF_MSG( ERR_FREAD,					"Unexpected EOF reading from file '%s'" )
DEF_MSG( ERR_FWRITE_STRING,			"String too long writing to file '%s'" )
DEF_MSG( ERR_FREAD_STRING,			"String too long reading from file '%s'" )

/* syntax errors */
DEF_MSG( ERR_SYNTAX,                "Syntax error" )
DEF_MSG( ERR_SYNTAX_EXPR,           "Syntax error in expression" )
DEF_MSG( ERR_EXPR,                  "Error in expression '%s'" )
DEF_MSG( ERR_UNCLOSED_STR,          "Unclosed string" )

DEF_MSG( ERR_INT_RANGE,             "Integer '%ld' out of range" )
DEF_MSG( ERR_INT_RANGE_EXPR,        "Integer '%ld' out of range in expression '%s'" )

DEF_MSG( ERR_NOT_DEFINED,           "Symbol not defined" )
DEF_MSG( ERR_NOT_DEFINED_EXPR,      "Symbol not defined in expression '%s'" )

DEF_MSG( ERR_UNBALANCED_PAREN,      "Unbalanced parenthesis" )
DEF_MSG( ERR_RANGE,                 "Out of range" )   /* not used */
DEF_MSG( ERR_NO_SRC_FILE,           "Source filename missing" )
DEF_MSG( ERR_ILLEGAL_OPTION,        "Illegal option '-%s'" )
DEF_MSG( ERR_UNKNOWN_IDENT,         "Unknown identifier" )
DEF_MSG( ERR_ILLEGAL_IDENT,         "Illegal identifier" )
DEF_MSG( ERR_MAX_CODESIZE,          "Max. code size of %ld bytes reached" )
DEF_MSG( ERR_SYMBOL_REDEFINED,      "Symbol '%s' already defined" )
DEF_MSG( ERR_SYMBOL_REDEFINED_MODULE,
									"Symbol '%s' redefined in module '%s'" )
DEF_MSG( ERR_MODULE_REDEFINED,      "Module name already defined" )
DEF_MSG( ERR_MODULE_NOT_DEFINED,    "Module name not defined" ) /* not used */
DEF_MSG( ERR_SYMBOL_DECL_LOCAL,     "Symbol '%s' already declared local" )
DEF_MSG( ERR_NO_CMD_ARGS,           "No command line arguments" )  /* not used */
DEF_MSG( ERR_ILLEGAL_SRC_FILENAME,  "Illegal source filename '%s'" )
DEF_MSG( ERR_SYMBOL_REDECL,         "Re-declaration of '%s' not allowed" )
DEF_MSG( ERR_ORG_REDEFINED,         "ORG already defined" ) /* not used */
DEF_MSG( ERR_ORG_NOT_DEFINED,       "ORG not defined" )
DEF_MSG( ERR_JR_NOT_LOCAL,          "Relative jump address must be local" )
DEF_MSG( ERR_NOT_OBJ_FILE,          "File '%s' not an object file" )
DEF_MSG( ERR_RESERVED_NAME,         "Reserved name" )  /* not used */
DEF_MSG( ERR_OPEN_LIB,              "Couldn't open library file '%s'" )
DEF_MSG( ERR_NOT_LIB_FILE,          "File '%s' not a library file" )
DEF_MSG( ERR_ENV_NOT_DEFINED,       "Environment variable '%s' not defined" )
DEF_MSG( ERR_INCLUDE_RECURSION,     "Cannot include file '%s' recursively" )
