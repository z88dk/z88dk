//-----------------------------------------------------------------------------
// z80asm
// Keywords
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "keyword.h"
#include "utils.h"
#include <unordered_map>
using namespace std;

string to_string(Keyword keyword) {
    static unordered_map<Keyword, string> keywords = {
        //@@BEGIN: keyword_text
        { Keyword::A, "a" },
        { Keyword::ASMPC, "asmpc" },
        { Keyword::ASSUME, "assume" },
        { Keyword::B, "b" },
        { Keyword::BINARY, "binary" },
        { Keyword::C, "c" },
        { Keyword::C_LINE, "c_line" },
        { Keyword::EQU, "equ" },
        { Keyword::INCBIN, "incbin" },
        { Keyword::INCLUDE, "include" },
        { Keyword::JR, "jr" },
        { Keyword::LD, "ld" },
        { Keyword::LINE, "line" },
        { Keyword::NC, "nc" },
        { Keyword::NONE, "" },
        { Keyword::NOP, "nop" },
        { Keyword::NZ, "nz" },
        { Keyword::Z, "z" },
        //@@END
    };

    auto it = keywords.find(keyword);
    if (it == keywords.end())
        return "";
    else
        return it->second;

}

Keyword lookup_keyword(const string& text) {
    static unordered_map<string, Keyword> keywords = {
        //@@BEGIN: keyword_lookup
        { "a", Keyword::A },
        { "asmpc", Keyword::ASMPC },
        { "assume", Keyword::ASSUME },
        { "b", Keyword::B },
        { "binary", Keyword::BINARY },
        { "c", Keyword::C },
        { "c_line", Keyword::C_LINE },
        { "equ", Keyword::EQU },
        { "incbin", Keyword::INCBIN },
        { "include", Keyword::INCLUDE },
        { "jr", Keyword::JR },
        { "ld", Keyword::LD },
        { "line", Keyword::LINE },
        { "nc", Keyword::NC },
        { "", Keyword::NONE },
        { "nop", Keyword::NOP },
        { "nz", Keyword::NZ },
        { "z", Keyword::Z },
        //@@END
    };

    auto it = keywords.find(str_to_lower(text));
    if (it == keywords.end())
        return Keyword::NONE;
    else
        return it->second;
}

