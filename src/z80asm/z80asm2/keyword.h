//-----------------------------------------------------------------------------
// z80asm
// Keywords
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

enum class Keyword {
    //@@BEGIN: keyword
    NONE,
    A,
    ASMPC,
    ASSUME,
    B,
    BINARY,
    C,
    C_LINE,
    EQU,
    INCBIN,
    INCLUDE,
    JR,
    LD,
    LINE,
    NC,
    NOP,
    NZ,
    Z,
    //@@END
};

string to_string(Keyword keyword);
Keyword lookup_keyword(const string& text);

