//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "file_reader.h"
#include "model.h"
#include "parse.h"
#include <cassert>
using namespace std;

Parser::Parser() {
    clear();
}

void Parser::clear() {
    state = ST_MAIN;
    lexer.clear();
}

void Parser::parse() {
    string line;
    while (g_source_reader.getline(line)) {
        lexer.set_text(line);
        if (!lexer.at_end())
            parse_line();
    }
}

void Parser::error(ErrCode err_code) {
    g_errors.error(err_code, lexer.peek_text());
    lexer.flush();
}

void Parser::parse_line() {
    switch (state) {
    case ST_MAIN: parse_main(); break;
    default: assert(0);
    }
}

void Parser::parse_main() {
    parse_label();
    while (true) {
        while (!lexer.at_end() && match_eos()) {
        }
        if (lexer.at_end())
            break;
        g_asm.add_asmpc_instr();
        parse_opcode();
    }
}

void Parser::parse_label() {
    // label:
    if (lexer.peek(0).code == TK_IDENT && lexer.peek(1).code == TK_COLON && lexer.peek(2).keyword != KW_EQU) {
        g_asm.add_label(lexer.peek(0).svalue);
        lexer.next(2);
    }
    // .label
    else if (lexer.peek(0).code == TK_DOT && lexer.peek(1).code == TK_IDENT && lexer.peek(2).keyword != KW_EQU) {
        g_asm.add_label(lexer.peek(1).svalue);
        lexer.next(2);
    }
}

void Parser::parse_opcode() {
    if (lexer.peek(0).keyword == KW_NOP) {
        g_asm.add_instr(0x00);
        lexer.next(1);
        parse_eos();
    }
    else 
        error(ErrSyntax);
}

bool Parser::match_eos() {
    switch (lexer.peek().code) {
    case TK_COLON:
    case TK_BACKSLASH:
        lexer.next();
        return true;
    case TK_END:
        return true;
    default:
        return false;
    }
}

void Parser::parse_eos() {
    if (!match_eos()) 
        error(ErrEosExpected);
}
