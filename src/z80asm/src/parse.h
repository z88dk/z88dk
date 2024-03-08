//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "scan.h"
#include <string>
using namespace std;

struct Parser {
    Parser();
    void clear();
    void parse();

private:
    enum State { ST_MAIN };
    State state{ ST_MAIN };                 // state of parser
    Lexer lexer;                            // lexer with input string

    void error(ErrCode err_code);           // syntax error and flush lexer
    void parse_line();                      // switch to each state-parser
    void parse_main();                      // main state
    void parse_label();                     // label, if any
    void parse_opcode();                    // opcode or directive
    bool match_eos();                       // match and consume ':', '\\', END
    void parse_eos();                       // match_eos() or error
};
