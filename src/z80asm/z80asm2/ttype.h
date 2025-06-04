//-----------------------------------------------------------------------------
// z80asm
// Token type
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

enum class TType {
    //@@BEGIN: ttype
    END,
    ASMPC,
    BACKSLASH,
    COLON,
    COMMA,
    CONST_EXPR,
    DHASH,
    DOT,
    EXPR,
    FLOAT,
    HASH,
    IDENT,
    INT,
    LBRACE,
    LPAREN,
    LSQUARE,
    NEWLINE,
    OPERATOR,
    QUEST,
    RAW_STR,
    RBRACE,
    RPAREN,
    RSQUARE,
    STR,
    //@@END
};

string to_string(TType ttype);

