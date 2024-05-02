//-----------------------------------------------------------------------------
// z80asm - parser
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "assembler.h"
#include "parser.h"
#include "utils.h"
#include "xassert.h"
using namespace std;

#include "cpu/parse_code.h"

Parser::Parser() {
}

Parser::~Parser() {
    for (auto& expr : exprs_)
        delete expr;
}

bool Parser::parse(const string& filename) {
    if (!source_reader_.open(filename))
        return false;
    start_error_count_ = g_asm.error_count();
    parse();
    return start_error_count_ == g_asm.error_count();
}

void Parser::error(ErrCode err_code) {
    g_asm.error(err_code, lexer_.peek_text());
    lexer_.flush();
}

bool Parser::parse() {
    string line;
    while (source_reader_.getline(line)) {
        if (!lexer_.set_text(line))     // error scanning
            continue;
        if (lexer_.at_end())            // empty line
            continue;           
        parse_line();
    }
    return start_error_count_ == g_asm.error_count();
}

void Parser::parse_line() {
    switch (state_) {
    case ST_MAIN: parse_main(); break;
    default: xassert(0);
    }
}

void Parser::parse_main() {
    parse_label();
    while (true) {
        while (!lexer_.at_end() && match_eos()) {
        }
        if (lexer_.at_end())
            break;
        g_asm.add_asmpc_instr();
        if (!parse_directive() && !parse_opcode())
            error(ErrSyntax);
    }
}

void Parser::parse_label() {
    // label:
    if (lexer_.peek(0).code() == TK_IDENT &&
        lexer_.peek(1).code() == TK_COLON &&
        lexer_.peek(2).keyword() != KW_EQU) {
        g_asm.add_label(lexer_.peek(0).svalue());
        lexer_.next(2);
    }
    // .label
    else if (lexer_.peek(0).code() == TK_DOT &&
        lexer_.peek(1).code() == TK_IDENT &&
        lexer_.peek(2).keyword() != KW_EQU) {
        g_asm.add_label(lexer_.peek(1).svalue());
        lexer_.next(2);
    }
}

bool Parser::parse_directive() {
    return false;
}

bool Parser::parse_opcode() {
    int state = 0;
    while (true) {
        const Token& token = lexer_.peek();

        int accept = accept_stt[state];
        if (accept != 0) {
            parse_action(accept);
            return true;
        }

        int end_state = token_stt[state][TK_END];
        if (end_state != 0) {
            if (!match_eos())
                return false;           // syntax error
            state = end_state;
            continue;
        }

        int keyword = token.keyword();
        int next_state = keyword_stt[state][keyword];
        if (keyword != KW_NONE && next_state != 0) {
            lexer_.next();
            state = next_state;
            continue;
        }

        int code = token.code();
        next_state = token_stt[state][code];
        if (next_state != 0) {
            lexer_.next();
            state = next_state;
            continue;
        }

        next_state = expr_stt[state];
        if (next_state != 0) {
            if (!parse_expr())
                return false;           // syntax error
            state = next_state;
            continue;
        }

        next_state = const_expr_stt[state];
        if (next_state != 0) {
            if (!parse_const_expr())
                return false;           // syntax error
            state = next_state;
            continue;
        }

        if (code == TK_END)
            break;
    }
    return false;                       // syntax error
}

bool Parser::match_eos() {
    switch (lexer_.peek().code()) {
    case TK_COLON:
    case TK_BACKSLASH:
        lexer_.next();
        return true;
    case TK_END:
        return true;
    default:
        return false;
    }
}

bool Parser::parse_expr() {
    Expr expr;
    if (expr.parse_expr(&lexer_)) {
        exprs_.push_back(&expr);
        return true;
    }
    else
        return false;
}

bool Parser::parse_const_expr() {
    if (!parse_expr())
        return false;
    Expr* expr = exprs_.back();
    exprs_.pop_back();
    ExprResult res = expr->eval();
    if (!res.ok()) {
        delete expr;
        return false;
    }
    else {
        int value = res.value();
        const_exprs_.push_back(value);
        delete expr;
        return true;
    }
}

bool Parser::expr_in_parens() {
    if (exprs_.empty())
        return false;
    else
        return exprs_.front()->in_parens();
}

void Parser::warn_if_expr_in_parens() {
    if (expr_in_parens())
        g_asm.warning(ErrExprInParens);
}

void Parser::error_if_expr_not_in_parens() {
    if (!expr_in_parens())
        g_asm.error(ErrExprNotInParens);
}

void Parser::error_illegal_ident() {
    g_asm.error(ErrIllegalIdent);
}

void Parser::error_int_range(int value) {
    g_asm.error(ErrIntRange, int_to_hex(value, 2));
}

Instr* Parser::add_opcode(int opcode) {
    return g_asm.add_instr(opcode);
}

Instr* Parser::add_opcode(int opcode, range_t range, int delta) {
    xassert(!exprs_.empty());

    Instr* instr = g_asm.add_instr(opcode);

    Expr* expr = exprs_.front();
    exprs_.pop_front();

    // add delta if asked
    if (delta != 0) {
        Expr* expr1 = new Expr("+(" + expr->text() + ")+" + to_string(delta));
        delete expr;
        expr = expr1;
    }

    // create and add patch
    Patch* patch = new Patch(range, expr);
    instr->add_patch(patch);
    return instr;
}

Instr* Parser::add_opcode_n(int opcode, int delta) {
    return add_opcode(opcode, RANGE_BYTE_UNSIGNED, delta);
}

Instr* Parser::add_opcode_s(int opcode, int delta) {
    return add_opcode(opcode, RANGE_BYTE_SIGNED, delta);
}

Instr* Parser::add_opcode_h(int opcode, int delta) {
    return add_opcode(opcode, RANGE_HIGH_OFFSET, delta);
}

Instr* Parser::add_opcode_n_0(int opcode, int delta) {
    return add_opcode(opcode, RANGE_BYTE_TO_WORD_UNSIGNED, delta);
}

Instr* Parser::add_opcode_s_0(int opcode, int delta) {
    return add_opcode(opcode, RANGE_BYTE_TO_WORD_SIGNED, delta);
}

Instr* Parser::add_opcode_n_n(int opcode) {
    Instr* instr = add_opcode(opcode, RANGE_BYTE_UNSIGNED, 0);

    // add second expression patch
    xassert(!exprs_.empty());
    Expr* expr = exprs_.front();
    exprs_.pop_front();

    Patch* patch = new Patch(RANGE_BYTE_UNSIGNED, expr);
    instr->add_patch(patch);
    return instr;
}

Instr* Parser::add_opcode_nn(int opcode, int delta) {
    return add_opcode(opcode, RANGE_WORD, delta);
}

Instr* Parser::add_opcode_NN(int opcode, int delta) {
    return add_opcode(opcode, RANGE_WORD_BE, delta);
}

Instr* Parser::add_opcode_nnn(int opcode, int delta) {
    return add_opcode(opcode, RANGE_PTR24, delta);
}

Instr* Parser::add_opcode_nnnn(int opcode, int delta) {
    return add_opcode(opcode, RANGE_DWORD, delta);
}

Instr* Parser::add_opcode_idx(int opcode, int delta) {
    if ((opcode & 0xffff0000) == 0) {
        return add_opcode(opcode, RANGE_BYTE_SIGNED, delta);
    }
    else if ((opcode & 0xff000000) == 0) {
        Instr* instr = add_opcode(opcode >> 8, RANGE_BYTE_SIGNED, delta);
        instr->add_byte(opcode & 0xff);
        return instr;
    }
    else {
        xassert(0);
        return nullptr;
    }
}

void Parser::add_opcode_idx_idx1(int opcode1, int opcode2) {
    add_opcode_idx(opcode1, 0);
    add_opcode_idx(opcode2, 1);
}

Instr* Parser::add_opcode_idx_n(int opcode) {
    Instr* instr = add_opcode_idx(opcode);

    xassert(!exprs_.empty());
    Expr* expr = exprs_.front();
    exprs_.pop_front();

    // create and add patch
    Patch* patch = new Patch(RANGE_BYTE_UNSIGNED, expr);
    instr->add_patch(patch);
    return instr;
}

Instr* Parser::add_opcode_jr(int opcode) {
    return add_opcode(opcode, RANGE_JR_OFFSET);
}

Instr* Parser::add_opcode_jre(int opcode) {
    return add_opcode(opcode, RANGE_JRE_OFFSET);
}

Instr* Parser::add_call_function(const string& name) {
    g_asm.declare_extern(name);
    Expr* expr = new Expr(name);
    exprs_.push_front(expr);
    Instr* instr = add_opcode_nn(Z80_CALL);
    return instr;
}

Instr* Parser::add_call_function_n(const string& name) {
    xassert(!exprs_.empty());

    Instr* instr = add_call_function(name);

    Expr* expr = exprs_.front();
    exprs_.pop_front();

    Patch* patch = new Patch(RANGE_BYTE_UNSIGNED, expr);
    instr->add_patch(patch);
    return instr;
}

void Parser::add_restart(int arg) {
    if (arg > 0 && arg < 8)
        arg *= 8;
    switch (arg) {
    case 0x00: case 0x08: case 0x30:
        if (g_cpu == CPU_R2KA || g_cpu == CPU_R3K || g_cpu == CPU_R4K || g_cpu == CPU_R5K)
            add_opcode(0xCD0000 + (arg << 8));
        else
            add_opcode(0xC7 + arg);
        break;
    case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:
        add_opcode(0xC7 + arg); break;
    default: error_int_range(arg);
    }
}

Symbol* Parser::add_label(const string& name) {
    return g_asm.add_label(name);
}

string Parser::autolabel() {
    return g_asm.autolabel();
}
