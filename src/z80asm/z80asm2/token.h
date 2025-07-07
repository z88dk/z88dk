//-----------------------------------------------------------------------------
// z80asm
// Tokens returned from Scanner
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <stack>
#include <string>
#include <unordered_map>
using namespace std;

class Symbol;
class Instr;

//-----------------------------------------------------------------------------
enum class TType {
    //@@BEGIN: ttype
    END,
    ASMPC,
    ASSIGN_LIST,
    BACKSLASH,
    BYTE_LIST,
    COLON,
    COMMA,
    CONST_ASSIGN_LIST,
    CONST_EXPR,
    CONST_EXPR_IF,
    DHASH,
    DOT,
    EXPR,
    EXPR_LIST,
    FLOAT,
    HASH,
    IDENT,
    IDENT_LIST,
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

//-----------------------------------------------------------------------------
enum class Keyword {
    //@@BEGIN: keyword
    NONE,
    A,
    ACOS,
    AF,
    AF1,
    AIX,
    AIY,
    ALIGN,
    ASIN,
    ASMPC,
    ASSERT,
    ASSUME,
    ATAN,
    ATAN2,
    B,
    BINARY,
    BYTE,
    C,
    CALL_OZ,
    CALL_PKG,
    CEIL,
    CMD,
    COS,
    COSH,
    CU,
    C_LINE,
    DB,
    DC,
    DDB,
    DEFB,
    DEFC,
    DEFDB,
    DEFGROUP,
    DEFINE,
    DEFM,
    DEFP,
    DEFQ,
    DEFS,
    DEFVARS,
    DEFW,
    DM,
    DMA,
    DP,
    DQ,
    DS,
    DW,
    DWORD,
    EQU,
    EXP,
    EXTERN,
    FABS,
    FLOOR,
    FMOD,
    GLOBAL,
    INCBIN,
    INCLUDE,
    IX,
    IXH,
    IXL,
    IY,
    IYH,
    IYL,
    JP,
    JR,
    LD,
    LIB,
    LINE,
    LOG,
    LOG10,
    MOVE,
    NC,
    NOP,
    NZ,
    ORG,
    P,
    POW,
    PTR,
    PUBLIC,
    Q,
    ROUND,
    SECTION,
    SIN,
    SINH,
    SQRT,
    STOP,
    TAN,
    TANH,
    TRUNC,
    W,
    WAIT,
    WORD,
    WR0,
    WR1,
    WR2,
    WR3,
    WR4,
    WR5,
    WR6,
    XDEF,
    XIX,
    XLIB,
    XREF,
    YIY,
    Z,
    //@@END
};

string to_string(Keyword keyword);
Keyword lookup_keyword(const string& text);

//-----------------------------------------------------------------------------
enum class Operator {
    //@@BEGIN: operator
    NONE,
    BIN_AND,
    BIN_NOT,
    BIN_OR,
    BIN_XOR,
    DIV,
    EQ,
    GE,
    GT,
    LE,
    LOG_AND,
    LOG_NOT,
    LOG_OR,
    LOG_XOR,
    LSHIFT,
    LT,
    MINUS,
    MOD,
    MULT,
    NE,
    PLUS,
    POWER,
    RSHIFT,
    TERNARY,
    UNARY_MINUS,
    UNARY_PLUS,
    //@@END
};

enum class Associativity {
    Left,
    Right,
};

enum class Arity {
    Unary,
    Binary,
    Ternary,
};

struct OperatorInfo {
    int precedence;
    Associativity associativity;
    Arity arity;
};

class OperatorTable {
public:
    static const OperatorInfo* get_info(Operator op);

private:
    static const unordered_map<Operator, OperatorInfo> table;
};

void do_operator(Operator op, stack<int>& operands);
void do_operator(Operator op, stack<double>& operands);
string to_string(Operator op);

//-----------------------------------------------------------------------------
struct FunctionInfo {
    Arity arity;
    double (*unary_func)(double);
    double (*binary_func)(double, double);
};

class FunctionTable {
public:
    static const FunctionInfo* get_info(Keyword keyword);   // Returns nullptr if not found

private:
    static const unordered_map<Keyword, FunctionInfo> table;
};

void do_function(Keyword keyword, stack<double>& operands);

//-----------------------------------------------------------------------------
class Token {
public:
    Token() = default;
    Token(const Token& other) = default;
    Token& operator=(const Token& other) = default;
    Token(TType ttype, bool blank_before);

    TType ttype() const { return m_ttype; }
    bool blank_before() const { return m_blank_before; }

    int ivalue() const { return m_ivalue; }
    double fvalue() const { return m_fvalue; }
    const string& svalue() const { return m_svalue; }
    Keyword keyword() const { return m_keyword; }
    Operator op() const { return m_operator; }
    Symbol* symbol() const { return m_symbol; }

    void set_ivalue(int ivalue) { m_ivalue = ivalue; }
    void set_fvalue(double fvalue) { m_fvalue = fvalue; }
    void set_svalue(const string& svalue) { m_svalue = svalue; }
    void set_keyword(const string& text);
    void set_operator(Operator op) { m_operator = op; }
    void set_symbol(Symbol* symbol) { m_symbol = symbol; }

    bool is(TType ttype) const { return m_ttype == ttype; }
    bool is(Keyword keyword) const { return m_keyword == keyword; }
    bool is_end() const;

    string to_string() const;

    static string concat(const string& s1, const string& s2);

private:
    TType m_ttype{ TType::END };
    bool m_blank_before{ false };
    Keyword m_keyword{ Keyword::NONE };
    Operator m_operator{ Operator::NONE };
    Symbol* m_symbol{ nullptr };

    int m_ivalue{ 0 };
    double m_fvalue{ 0.0 };
    string m_svalue;
	
	static string swap_x_y(string str);
};

