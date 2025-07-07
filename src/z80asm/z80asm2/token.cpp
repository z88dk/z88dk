//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "options.h"
#include "token.h"
#include "utils.h"
#include <cassert>
#include <cmath>
using namespace std;

//-----------------------------------------------------------------------------
string to_string(TType ttype) {
    static unordered_map<TType, string> ttypes = {
        //@@BEGIN: ttype_text
        { TType::ASMPC, "$" },
        { TType::ASSIGN_LIST, "" },
        { TType::BACKSLASH, "\\" },
        { TType::BYTE_LIST, "" },
        { TType::COLON, ":" },
        { TType::COMMA, "," },
        { TType::CONST_ASSIGN_LIST, "" },
        { TType::CONST_EXPR, "" },
        { TType::CONST_EXPR_IF, "" },
        { TType::DHASH, "##" },
        { TType::DOT, "." },
        { TType::END, "" },
        { TType::EXPR, "" },
        { TType::EXPR_LIST, "" },
        { TType::FLOAT, "" },
        { TType::HASH, "#" },
        { TType::IDENT, "" },
        { TType::IDENT_LIST, "" },
        { TType::INT, "" },
        { TType::LBRACE, "{" },
        { TType::LPAREN, "(" },
        { TType::LSQUARE, "[" },
        { TType::NEWLINE, "\n" },
        { TType::OPERATOR, "" },
        { TType::QUEST, "?" },
        { TType::RAW_STR, "" },
        { TType::RBRACE, "}" },
        { TType::RPAREN, ")" },
        { TType::RSQUARE, "]" },
        { TType::STR, "" },
        //@@END
    };

    auto it = ttypes.find(ttype);
    if (it == ttypes.end())
        return "";
    else
        return it->second;
}

//-----------------------------------------------------------------------------
string to_string(Keyword keyword) {
    static unordered_map<Keyword, string> keywords = {
        //@@BEGIN: keyword_text
        { Keyword::A, "a" },
        { Keyword::ACOS, "acos" },
        { Keyword::AF, "af" },
        { Keyword::AF1, "af'" },
        { Keyword::AIX, "aix" },
        { Keyword::AIY, "aiy" },
        { Keyword::ALIGN, "align" },
        { Keyword::ASIN, "asin" },
        { Keyword::ASMPC, "asmpc" },
        { Keyword::ASSERT, "assert" },
        { Keyword::ASSUME, "assume" },
        { Keyword::ATAN, "atan" },
        { Keyword::ATAN2, "atan2" },
        { Keyword::B, "b" },
        { Keyword::BINARY, "binary" },
        { Keyword::BYTE, "byte" },
        { Keyword::C, "c" },
        { Keyword::CALL_OZ, "call_oz" },
        { Keyword::CALL_PKG, "call_pkg" },
        { Keyword::CEIL, "ceil" },
        { Keyword::CMD, "cmd" },
        { Keyword::COS, "cos" },
        { Keyword::COSH, "cosh" },
        { Keyword::CU, "cu" },
        { Keyword::C_LINE, "c_line" },
        { Keyword::DB, "db" },
        { Keyword::DC, "dc" },
        { Keyword::DDB, "ddb" },
        { Keyword::DEFB, "defb" },
        { Keyword::DEFC, "defc" },
        { Keyword::DEFDB, "defdb" },
        { Keyword::DEFGROUP, "defgroup" },
        { Keyword::DEFINE, "define" },
        { Keyword::DEFM, "defm" },
        { Keyword::DEFP, "defp" },
        { Keyword::DEFQ, "defq" },
        { Keyword::DEFS, "defs" },
        { Keyword::DEFVARS, "defvars" },
        { Keyword::DEFW, "defw" },
        { Keyword::DM, "dm" },
        { Keyword::DMA, "dma" },
        { Keyword::DP, "dp" },
        { Keyword::DQ, "dq" },
        { Keyword::DS, "ds" },
        { Keyword::DW, "dw" },
        { Keyword::DWORD, "dword" },
        { Keyword::EQU, "equ" },
        { Keyword::EXP, "exp" },
        { Keyword::EXTERN, "extern" },
        { Keyword::FABS, "fabs" },
        { Keyword::FLOOR, "floor" },
        { Keyword::FMOD, "fmod" },
        { Keyword::GLOBAL, "global" },
        { Keyword::INCBIN, "incbin" },
        { Keyword::INCLUDE, "include" },
        { Keyword::IX, "ix" },
        { Keyword::IXH, "ixh" },
        { Keyword::IXL, "ixl" },
        { Keyword::IY, "iy" },
        { Keyword::IYH, "iyh" },
        { Keyword::IYL, "iyl" },
        { Keyword::JP, "jp" },
        { Keyword::JR, "jr" },
        { Keyword::LD, "ld" },
        { Keyword::LIB, "lib" },
        { Keyword::LINE, "line" },
        { Keyword::LOG, "log" },
        { Keyword::LOG10, "log10" },
        { Keyword::MOVE, "move" },
        { Keyword::NC, "nc" },
        { Keyword::NONE, "" },
        { Keyword::NOP, "nop" },
        { Keyword::NZ, "nz" },
        { Keyword::ORG, "org" },
        { Keyword::P, "p" },
        { Keyword::POW, "pow" },
        { Keyword::PTR, "ptr" },
        { Keyword::PUBLIC, "public" },
        { Keyword::Q, "q" },
        { Keyword::ROUND, "round" },
        { Keyword::SECTION, "section" },
        { Keyword::SIN, "sin" },
        { Keyword::SINH, "sinh" },
        { Keyword::SQRT, "sqrt" },
        { Keyword::STOP, "stop" },
        { Keyword::TAN, "tan" },
        { Keyword::TANH, "tanh" },
        { Keyword::TRUNC, "trunc" },
        { Keyword::W, "w" },
        { Keyword::WAIT, "wait" },
        { Keyword::WORD, "word" },
        { Keyword::WR0, "wr0" },
        { Keyword::WR1, "wr1" },
        { Keyword::WR2, "wr2" },
        { Keyword::WR3, "wr3" },
        { Keyword::WR4, "wr4" },
        { Keyword::WR5, "wr5" },
        { Keyword::WR6, "wr6" },
        { Keyword::XDEF, "xdef" },
        { Keyword::XIX, "xix" },
        { Keyword::XLIB, "xlib" },
        { Keyword::XREF, "xref" },
        { Keyword::YIY, "yiy" },
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
        { "acos", Keyword::ACOS },
        { "af", Keyword::AF },
        { "af'", Keyword::AF1 },
        { "aix", Keyword::AIX },
        { "aiy", Keyword::AIY },
        { "align", Keyword::ALIGN },
        { "asin", Keyword::ASIN },
        { "asmpc", Keyword::ASMPC },
        { "assert", Keyword::ASSERT },
        { "assume", Keyword::ASSUME },
        { "atan", Keyword::ATAN },
        { "atan2", Keyword::ATAN2 },
        { "b", Keyword::B },
        { "binary", Keyword::BINARY },
        { "byte", Keyword::BYTE },
        { "c", Keyword::C },
        { "call_oz", Keyword::CALL_OZ },
        { "call_pkg", Keyword::CALL_PKG },
        { "ceil", Keyword::CEIL },
        { "cmd", Keyword::CMD },
        { "cos", Keyword::COS },
        { "cosh", Keyword::COSH },
        { "cu", Keyword::CU },
        { "c_line", Keyword::C_LINE },
        { "db", Keyword::DB },
        { "dc", Keyword::DC },
        { "ddb", Keyword::DDB },
        { "defb", Keyword::DEFB },
        { "defc", Keyword::DEFC },
        { "defdb", Keyword::DEFDB },
        { "defgroup", Keyword::DEFGROUP },
        { "define", Keyword::DEFINE },
        { "defm", Keyword::DEFM },
        { "defp", Keyword::DEFP },
        { "defq", Keyword::DEFQ },
        { "defs", Keyword::DEFS },
        { "defvars", Keyword::DEFVARS },
        { "defw", Keyword::DEFW },
        { "dm", Keyword::DM },
        { "dma", Keyword::DMA },
        { "dp", Keyword::DP },
        { "dq", Keyword::DQ },
        { "ds", Keyword::DS },
        { "dw", Keyword::DW },
        { "dword", Keyword::DWORD },
        { "equ", Keyword::EQU },
        { "exp", Keyword::EXP },
        { "extern", Keyword::EXTERN },
        { "fabs", Keyword::FABS },
        { "floor", Keyword::FLOOR },
        { "fmod", Keyword::FMOD },
        { "global", Keyword::GLOBAL },
        { "incbin", Keyword::INCBIN },
        { "include", Keyword::INCLUDE },
        { "ix", Keyword::IX },
        { "ixh", Keyword::IXH },
        { "ixl", Keyword::IXL },
        { "iy", Keyword::IY },
        { "iyh", Keyword::IYH },
        { "iyl", Keyword::IYL },
        { "jp", Keyword::JP },
        { "jr", Keyword::JR },
        { "ld", Keyword::LD },
        { "lib", Keyword::LIB },
        { "line", Keyword::LINE },
        { "log", Keyword::LOG },
        { "log10", Keyword::LOG10 },
        { "move", Keyword::MOVE },
        { "nc", Keyword::NC },
        { "", Keyword::NONE },
        { "nop", Keyword::NOP },
        { "nz", Keyword::NZ },
        { "org", Keyword::ORG },
        { "p", Keyword::P },
        { "pow", Keyword::POW },
        { "ptr", Keyword::PTR },
        { "public", Keyword::PUBLIC },
        { "q", Keyword::Q },
        { "round", Keyword::ROUND },
        { "section", Keyword::SECTION },
        { "sin", Keyword::SIN },
        { "sinh", Keyword::SINH },
        { "sqrt", Keyword::SQRT },
        { "stop", Keyword::STOP },
        { "tan", Keyword::TAN },
        { "tanh", Keyword::TANH },
        { "trunc", Keyword::TRUNC },
        { "w", Keyword::W },
        { "wait", Keyword::WAIT },
        { "word", Keyword::WORD },
        { "wr0", Keyword::WR0 },
        { "wr1", Keyword::WR1 },
        { "wr2", Keyword::WR2 },
        { "wr3", Keyword::WR3 },
        { "wr4", Keyword::WR4 },
        { "wr5", Keyword::WR5 },
        { "wr6", Keyword::WR6 },
        { "xdef", Keyword::XDEF },
        { "xix", Keyword::XIX },
        { "xlib", Keyword::XLIB },
        { "xref", Keyword::XREF },
        { "yiy", Keyword::YIY },
        { "z", Keyword::Z },
        //@@END
    };

    auto it = keywords.find(str_to_lower(text));
    if (it == keywords.end())
        return Keyword::NONE;
    else
        return it->second;
}

//-----------------------------------------------------------------------------
const unordered_map<Operator, OperatorInfo> OperatorTable::table = {
    //@@BEGIN: operator_info
    { Operator::BIN_AND, { 7, Associativity::Left, Arity::Binary } },
    { Operator::BIN_NOT, { 13, Associativity::Right, Arity::Unary } },
    { Operator::BIN_OR, { 5, Associativity::Left, Arity::Binary } },
    { Operator::BIN_XOR, { 6, Associativity::Left, Arity::Binary } },
    { Operator::DIV, { 12, Associativity::Left, Arity::Binary } },
    { Operator::EQ, { 8, Associativity::Left, Arity::Binary } },
    { Operator::GE, { 9, Associativity::Left, Arity::Binary } },
    { Operator::GT, { 9, Associativity::Left, Arity::Binary } },
    { Operator::LE, { 9, Associativity::Left, Arity::Binary } },
    { Operator::LOG_AND, { 4, Associativity::Left, Arity::Binary } },
    { Operator::LOG_NOT, { 13, Associativity::Right, Arity::Unary } },
    { Operator::LOG_OR, { 2, Associativity::Left, Arity::Binary } },
    { Operator::LOG_XOR, { 3, Associativity::Left, Arity::Binary } },
    { Operator::LSHIFT, { 10, Associativity::Left, Arity::Binary } },
    { Operator::LT, { 9, Associativity::Left, Arity::Binary } },
    { Operator::MINUS, { 11, Associativity::Left, Arity::Binary } },
    { Operator::MOD, { 12, Associativity::Left, Arity::Binary } },
    { Operator::MULT, { 12, Associativity::Left, Arity::Binary } },
    { Operator::NE, { 8, Associativity::Left, Arity::Binary } },
    { Operator::NONE, { 0, Associativity::Left, Arity::Unary } },
    { Operator::PLUS, { 11, Associativity::Left, Arity::Binary } },
    { Operator::POWER, { 14, Associativity::Right, Arity::Binary } },
    { Operator::RSHIFT, { 10, Associativity::Left, Arity::Binary } },
    { Operator::TERNARY, { 1, Associativity::Right, Arity::Ternary } },
    { Operator::UNARY_MINUS, { 13, Associativity::Right, Arity::Unary } },
    { Operator::UNARY_PLUS, { 13, Associativity::Right, Arity::Unary } },
    //@@END
};

void do_operator(Operator op, stack<int>& operands) {
    const OperatorInfo* op_info = OperatorTable::get_info(op);
    int i1 = 0, i2 = 0, i3 = 0;

    switch (op_info->arity) {
    case Arity::Unary:
        if (operands.size() < 1) {
            g_error->error_insufficient_operands(to_string(op));
            return;
        }
        i1 = operands.top(); operands.pop();
        break;
    case Arity::Binary:
        if (operands.size() < 2) {
            g_error->error_insufficient_operands(to_string(op));
            return;
        }
        i2 = operands.top(); operands.pop();
        i1 = operands.top(); operands.pop();
        break;
    case Arity::Ternary:
        if (operands.size() < 3) {
            g_error->error_insufficient_operands(to_string(op));
            return;
        }
        i3 = operands.top(); operands.pop();
        i2 = operands.top(); operands.pop();
        i1 = operands.top(); operands.pop();
        break;
    default:
        assert(false && "Unknown operator arity");
    }

    switch (op) {
    case Operator::POWER: operands.push(ipow(i1, i2)); break;
    case Operator::UNARY_PLUS: operands.push(i1); break;
    case Operator::UNARY_MINUS: operands.push(-i1); break;
    case Operator::LOG_NOT: operands.push(i1 ? 0 : 1); break;
    case Operator::BIN_NOT: operands.push(~i1); break;
    case Operator::MULT: operands.push(i1 * i2); break;
    case Operator::PLUS: operands.push(i1 + i2); break;
    case Operator::MINUS: operands.push(i1 - i2); break;
    case Operator::LSHIFT: operands.push(i1 << i2); break;
    case Operator::RSHIFT: operands.push(i1 >> i2); break;
    case Operator::LT: operands.push(i1 < i2); break;
    case Operator::LE: operands.push(i1 <= i2); break;
    case Operator::GT: operands.push(i1 > i2); break;
    case Operator::GE: operands.push(i1 >= i2); break;
    case Operator::EQ: operands.push(i1 == i2); break;
    case Operator::NE: operands.push(i1 != i2); break;
    case Operator::BIN_AND: operands.push(i1 & i2); break;
    case Operator::BIN_OR: operands.push(i1 | i2); break;
    case Operator::BIN_XOR: operands.push(i1 ^ i2); break;
    case Operator::LOG_AND: operands.push((i1 && i2) ? 1 : 0); break;
    case Operator::LOG_OR: operands.push((i1 || i2) ? 1 : 0); break;
    case Operator::LOG_XOR: operands.push((i1 == i2) ? 0 : 1); break;
    case Operator::TERNARY: operands.push(i1 ? i2 : i3); break;
    case Operator::DIV:
        if (i2 == 0) {
            g_error->error_division_by_zero();
            operands.push(0);
        }
        else {
            operands.push(i1 / i2);
        }
        break;
    case Operator::MOD:
        if (i2 == 0) {
            g_error->error_division_by_zero();
            operands.push(0);
        }
        else {
            operands.push(i1 % i2);
        }
        break;
    default:
        assert(false && "Unknown operator");
    }
}

void do_operator(Operator op, stack<double>& operands) {
    const OperatorInfo* info = OperatorTable::get_info(op);
    double f1 = 0.0, f2 = 0.0, f3 = 0.0;

    switch (info->arity) {
    case Arity::Unary:
        if (operands.size() < 1) {
            g_error->error_insufficient_operands(to_string(op));
            return;
        }
        f1 = operands.top(); operands.pop();
        break;
    case Arity::Binary:
        if (operands.size() < 2) {
            g_error->error_insufficient_operands(to_string(op));
            return;
        }
        f2 = operands.top(); operands.pop();
        f1 = operands.top(); operands.pop();
        break;
    case Arity::Ternary:
        if (operands.size() < 3) {
            g_error->error_insufficient_operands(to_string(op));
            return;
        }
        f3 = operands.top(); operands.pop();
        f2 = operands.top(); operands.pop();
        f1 = operands.top(); operands.pop();
        break;
    default:
        assert(false && "Unknown operator arity");
    }

    switch (op) {
    case Operator::UNARY_MINUS: operands.push(-f1); break;
    case Operator::UNARY_PLUS: operands.push(+f1); break;
    case Operator::LOG_NOT: operands.push((f1 > 1e-9) ? 0 : 1); break;
    case Operator::BIN_NOT: operands.push(~static_cast<int>(f1)); break;
    case Operator::PLUS: operands.push(f1 + f2); break;
    case Operator::MINUS: operands.push(f1 - f2); break;
    case Operator::MULT: operands.push(f1 * f2); break;
    case Operator::DIV:
        if (f2 < 1e-9) {
            g_error->error_division_by_zero();
            operands.push(0);
        }
        else {
            operands.push(f1 / f2);
        }
        break;
    case Operator::MOD:
        if (f2 < 1e-9) {
            g_error->error_division_by_zero();
            operands.push(0);
        }
        else {
            operands.push(fmod(f1, f2));
        }
        break;
    case Operator::POWER: operands.push(pow(f1, f2)); break;
    case Operator::LT: operands.push(f1 < f2); break;
    case Operator::LE: operands.push(f1 <= f2); break;
    case Operator::GT: operands.push(f1 > f2); break;
    case Operator::GE: operands.push(f1 >= f2); break;
    case Operator::EQ: operands.push(f1 == f2); break;
    case Operator::NE: operands.push(f1 != f2); break;
    case Operator::LOG_AND: operands.push((f1 && f2) ? 1 : 0); break;
    case Operator::LOG_OR: operands.push((f1 || f2) ? 1 : 0); break;
    case Operator::LOG_XOR: operands.push((f1 != f2) ? 1 : 0); break;
    case Operator::BIN_AND: operands.push(static_cast<int>(f1) & static_cast<int>(f2)); break;
    case Operator::BIN_OR: operands.push(static_cast<int>(f1) | static_cast<int>(f2)); break;
    case Operator::BIN_XOR: operands.push(static_cast<int>(f1) ^ static_cast<int>(f2)); break;
    case Operator::LSHIFT: operands.push(static_cast<int>(f1) << static_cast<int>(f2)); break;
    case Operator::RSHIFT: operands.push(static_cast<int>(f1) >> static_cast<int>(f2)); break;
    case Operator::TERNARY: operands.push(f1 ? f2 : f3); break;
    default:
        assert(false && "Unknown operator");
    }
}

string to_string(Operator op) {
    static unordered_map<Operator, string> operators = {
        //@@BEGIN: operator_text
        { Operator::BIN_AND, "&" },
        { Operator::BIN_NOT, "~" },
        { Operator::BIN_OR, "|" },
        { Operator::BIN_XOR, "^" },
        { Operator::DIV, "/" },
        { Operator::EQ, "=" },
        { Operator::GE, ">=" },
        { Operator::GT, ">" },
        { Operator::LE, "<=" },
        { Operator::LOG_AND, "&&" },
        { Operator::LOG_NOT, "!" },
        { Operator::LOG_OR, "||" },
        { Operator::LOG_XOR, "^^" },
        { Operator::LSHIFT, "<<" },
        { Operator::LT, "<" },
        { Operator::MINUS, "-" },
        { Operator::MOD, "%" },
        { Operator::MULT, "*" },
        { Operator::NE, "<>" },
        { Operator::NONE, "" },
        { Operator::PLUS, "+" },
        { Operator::POWER, "**" },
        { Operator::RSHIFT, ">>" },
        { Operator::TERNARY, "?:" },
        { Operator::UNARY_MINUS, "-" },
        { Operator::UNARY_PLUS, "+" },
        //@@END
    };

    auto it = operators.find(op);
    if (it == operators.end())
        return "";
    else
        return it->second;
}

const OperatorInfo* OperatorTable::get_info(Operator op) {
    auto it = table.find(op);
    if (it == table.end())
        assert(false && "Unknown operator");
    return &it->second;
}

static double dummy_unary(double a) { return a; }
static double dummy_binary(double a, double b) { return a + b; }

const unordered_map<Keyword, FunctionInfo> FunctionTable::table = {
    { Keyword::SIN, { Arity::Unary, sin, dummy_binary }},
    { Keyword::COS, { Arity::Unary, cos, dummy_binary }},
    { Keyword::TAN, { Arity::Unary, tan, dummy_binary }},
    { Keyword::ASIN, { Arity::Unary, asin, dummy_binary }},
    { Keyword::ACOS, { Arity::Unary, acos, dummy_binary }},
    { Keyword::ATAN, { Arity::Unary, atan, dummy_binary }},
    { Keyword::SINH, { Arity::Unary, sinh, dummy_binary }},
    { Keyword::COSH, { Arity::Unary, cosh, dummy_binary }},
    { Keyword::TANH, { Arity::Unary, tanh, dummy_binary }},
    { Keyword::EXP, { Arity::Unary, exp, dummy_binary }},
    { Keyword::LOG, { Arity::Unary, log, dummy_binary }},
    { Keyword::LOG10, { Arity::Unary, log10, dummy_binary }},
    { Keyword::SQRT, { Arity::Unary, sqrt, dummy_binary }},
    { Keyword::CEIL, { Arity::Unary, ceil, dummy_binary }},
    { Keyword::FLOOR, { Arity::Unary, floor, dummy_binary }},
    { Keyword::FABS, { Arity::Unary, fabs, dummy_binary }},
    { Keyword::ROUND, { Arity::Unary, round, dummy_binary }},
    { Keyword::TRUNC, { Arity::Unary, trunc, dummy_binary }},
    { Keyword::POW, { Arity::Binary, dummy_unary, pow }},
    { Keyword::ATAN2, { Arity::Binary, dummy_unary, atan2 }},
    { Keyword::FMOD, { Arity::Binary, dummy_unary, fmod }},
};

const FunctionInfo* FunctionTable::get_info(Keyword keyword) {
    auto it = table.find(keyword);
    if (it == table.end())
        return nullptr;
    else
        return &it->second;
}

void do_function(Keyword keyword, stack<double>& operands) {
    const FunctionInfo* info = FunctionTable::get_info(keyword);
    assert(info != nullptr && "Unknown function");
    double f1 = 0.0, f2 = 0.0;

    switch (info->arity) {
    case Arity::Unary:
        if (operands.size() < 1) {
            g_error->error_insufficient_operands(to_string(keyword));
            return;
        }
        f1 = operands.top(); operands.pop();
        operands.push(info->unary_func(f1));
        break;
    case Arity::Binary:
        if (operands.size() < 2) {
            g_error->error_insufficient_operands(to_string(keyword));
            return;
        }
        f2 = operands.top(); operands.pop();
        f1 = operands.top(); operands.pop();
        operands.push(info->binary_func(f1, f2));
        break;
    default:
        assert(false && "Unknown function arity");
    }
}

//-----------------------------------------------------------------------------
Token::Token(TType ttype, bool blank_before)
    : m_ttype(ttype), m_blank_before(blank_before) {
}

void Token::set_keyword(const string& text) {
    m_keyword = ::lookup_keyword(text);
    m_svalue = text;
	
	// check SwapIXIY
	if (g_options->swap_ixiy() != SwapIXIY::NO_SWAP) {
		switch (m_keyword) {
		case Keyword::AIX:
		case Keyword::AIY:
		case Keyword::IX:
		case Keyword::IXH:
		case Keyword::IXL:
		case Keyword::IY:
		case Keyword::IYH:
		case Keyword::IYL:
		case Keyword::XIX:
		case Keyword::YIY:
			m_svalue = swap_x_y(m_svalue);
			m_keyword = ::lookup_keyword(m_svalue);
            break;
		default:;
		}
	}
}

bool Token::is_end() const {
    return is(TType::END) || is(TType::NEWLINE) || is(TType::COLON) || is(TType::BACKSLASH);
}

string Token::to_string() const {
    switch (m_ttype) {
    case TType::IDENT:
		// check SwapIXIY
		if (g_options->swap_ixiy() != SwapIXIY::NO_SWAP) {
			string str;
			switch (m_keyword) {
			case Keyword::AIX:
			case Keyword::AIY:
			case Keyword::IX:
			case Keyword::IXH:
			case Keyword::IXL:
			case Keyword::IY:
			case Keyword::IYH:
			case Keyword::IYL:
			case Keyword::XIX:
			case Keyword::YIY:
				str = swap_x_y(m_svalue);
				return str;
			default:;
				// fall through
			}
		}
        return m_svalue;
    case TType::INT:
        return std::to_string(m_ivalue);
    case TType::FLOAT:
        return std::to_string(m_fvalue);
    case TType::STR:
        return binary_to_c_string(reinterpret_cast<const unsigned char*>(m_svalue.c_str()), m_svalue.size());
    case TType::RAW_STR:
        return "\"" + m_svalue + "\"";		// syntax error in a later stage if string contains '"'
    case TType::OPERATOR:
        return ::to_string(m_operator);
    default:
        return ::to_string(m_ttype);
    }
}

string Token::concat(const string& s1, const string& s2) {
    if (s1.empty() || s2.empty())
        return s1 + s2;
    else if (str_ends_with(s1, "##"))   // cpp-style concatenation
        return s1.substr(0, s1.length() - 2) + s2;
    else if (isspace(s1.back()) || isspace(s2.front()))
        return s1 + s2;
    else if (is_ident(s1.back()) && is_ident(s2.front()))
        return s1 + " " + s2;
    else if (s1.back() == '$' && isxdigit(s2.front()))
        return s1 + " " + s2;
    else if ((s1.back() == '%' || s1.back() == '@') &&
        (isdigit(s2.front()) || s2.front() == '"'))
        return s1 + " " + s2;
    else if ((s1.back() == '&' && s2.front() == '&') ||
        (s1.back() == '|' && s2.front() == '|') ||
        (s1.back() == '^' && s2.front() == '^') ||
        (s1.back() == '*' && s2.front() == '*') ||
        (s1.back() == '<' && (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
        (s1.back() == '>' && (s2.front() == '=' || s2.front() == '>')) ||
        (s1.back() == '=' && s2.front() == '=') ||
        (s1.back() == '!' && s2.front() == '=') ||
        (s1.back() == '#' && s2.front() == '#'))
        return s1 + " " + s2;
    else
        return s1 + s2;
}

string Token::swap_x_y(string str) {
    // replace IX<->IY, IXH<->IYH, AIX<->AIY, XIX<->YIY
    for (auto& c : str) {
        switch (c) {
        case 'x': c = 'y'; break;
        case 'X': c = 'Y'; break;
        case 'y': c = 'x'; break;
        case 'Y': c = 'X'; break;
        default:;
        }
    }
    return str;
}

