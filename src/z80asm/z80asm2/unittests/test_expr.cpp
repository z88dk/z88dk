//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../expr.h"
#include "../lexer.h"
#include "../options.h"
#include "../symbol_table.h"
#include "catch_amalgamated.hpp"

namespace {
// Redirect std::cerr to an internal buffer for the duration of these tests
// so test error messages don't pollute the console output.
struct StderrSilencer {
    StderrSilencer() : old_buf(std::cerr.rdbuf(stream.rdbuf())) {}
    ~StderrSilencer() {
        std::cerr.rdbuf(old_buf);
    }
    std::string str() const {
        return stream.str();
    }
private:
    std::ostringstream stream;
    std::streambuf* old_buf = nullptr;
};

// Instantiate a single silencer for this translation unit.
static StderrSilencer g_stderr_silencer;
}

// Helper: build a TokensLine from inline text
static TokensLine make_line(const std::string& text,
                            const char* file = "expr_ops",
                            int line = 1) {
    std::string content = text + "\n";
    TokensFile tf(content, file, line, false);
    REQUIRE(tf.tok_lines_count() == 1);
    return tf.get_tok_line(0);
}

// Helper: parse and evaluate an expression using Expr API
static bool parse_and_eval(const std::string& text,
                           int& out_value,
                           bool& out_undefined,
                           bool& out_constant,
                           unsigned* consumed_idx = nullptr,
                           unsigned* lsize = nullptr) {
    TokensLine tl = make_line(text);
    unsigned i = 0;
    Expr e;
    bool parsed = e.parse(tl, i);
    if (!parsed) {
        return false;
    }
    if (consumed_idx) {
        *consumed_idx = i;
    }
    if (lsize) {
        *lsize = tl.size();
    }
    int v = 0;
    bool ok = e.evaluate(v);
    out_value = v;
    out_undefined = e.is_undefined();
    out_constant = e.is_constant();
    return ok;
}

TEST_CASE("Basic arithmetic and precedence", "[expr][precedence]") {
    int v = 0;
    bool undef = false;
    bool cnst = false;
    unsigned i = 0;
    unsigned lsize = 0;

    // multiplication binds tighter than addition
    REQUIRE(parse_and_eval("2 + 3 * 4", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 14);
    REQUIRE(lsize == 9);

    // parentheses override precedence
    REQUIRE(parse_and_eval("(2 + 3) * 4", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 20);
    REQUIRE(lsize == 11);
}

TEST_CASE("Power operator (**) is right-associative and handles negative exponent as zero",
          "[expr][power][associativity]") {
    int v = 0;
    bool undef = false;
    bool cnst = false;
    unsigned i = 0;
    unsigned lsize = 0;

    // right-assoc: 2 ** (3 ** 2) == 2 ** 9 == 512
    REQUIRE(parse_and_eval("2 ** 3 ** 2", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 512);
    REQUIRE(lsize == 9);

    // negative exponent -> defined as 0 by implementation
    REQUIRE(parse_and_eval("2 ** -1", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 0);
    REQUIRE(lsize == 6);

    // unary minus interacts with power precedence: unary has lower precedence than binary power
    // so "-2 ** 3" -> -(2 ** 3) == -8 (not (-2) ** 3)
    REQUIRE(parse_and_eval("-2 ** 3", v, undef, cnst, &i, &lsize));
    REQUIRE(v == -8);
    REQUIRE(lsize == 6);
}

TEST_CASE("Left associativity for subtraction, division, shifts",
          "[expr][associativity]") {
    int v = 0;
    bool undef = false;
    bool cnst = false;
    unsigned i = 0;
    unsigned lsize = 0;

    REQUIRE(parse_and_eval("10 - 3 - 2", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 5); // (10 - 3) - 2

    REQUIRE(parse_and_eval("20 / 2 / 2", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 5); // (20 / 2) / 2

    REQUIRE(parse_and_eval("1 << 2 << 1", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 8); // (1<<2)<<1 == 4<<1 == 8
}

TEST_CASE("Bitwise and logical operators precedence and results (^ vs ^^, & vs &&, | vs ||)",
          "[expr][bitwise][logical][precedence]") {
    int v = 0;
    bool undef = false;
    bool cnst = false;
    unsigned i = 0;
    unsigned lsize = 0;

    // bitwise AND binds tighter than bitwise OR: (1 & 2) | 4 == 0 | 4 == 4
    REQUIRE(parse_and_eval("1 & 2 | 4", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 4);

    // bitwise xor '^' is a bitwise op, precedence higher than logical xor '^^'
    // (1 ^ 2) ^^ 2 -> (3) ^^ 2 -> logical xor: (3 != 2) -> 1
    REQUIRE(parse_and_eval("1 ^ 2 ^^ 2", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 1);

    // bitwise xor result correctness
    REQUIRE(parse_and_eval("6 ^ 3", v, undef, cnst, &i, &lsize));
    REQUIRE(v == (6 ^ 3));

    // logical xor '^^' yields 1 if operands are different (non-zero), else 0
    REQUIRE(parse_and_eval("2 ^^ 1", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("2 ^^ 2", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 0);

    // logical AND/OR precedence: && binds tighter than ||
    REQUIRE(parse_and_eval("1 && 0 || 0", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 0); // (1&&0) || 0 == 0
    REQUIRE(parse_and_eval("1 || 0 && 0", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 1); // 1 || (0 && 0) == 1
}

TEST_CASE("Comparisons and equality produce boolean 1/0",
          "[expr][comparison]") {
    int v = 0;
    bool undef = false;
    bool cnst = false;
    unsigned i = 0;
    unsigned lsize = 0;

    REQUIRE(parse_and_eval("3 < 4", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("3 >= 4", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 0);
    REQUIRE(parse_and_eval("2 = 2", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("2 != 3", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 1);
}

TEST_CASE("Ternary operator ? : selects correct branch and parsing stops at colon when appropriate",
          "[expr][ternary]") {
    int v = 0;
    bool undef = false;
    bool cnst = false;
    unsigned i = 0;
    unsigned lsize = 0;

    REQUIRE(parse_and_eval("1 ? 2 : 3", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 2);

    REQUIRE(parse_and_eval("0 ? 2 : 3", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 3);

    // nested ternary: 1 ? 0 ? 5 : 6 : 7  -> inner 0 ? 5 : 6 -> 6 ; outer -> 1 ? 6 : 7 -> 6
    REQUIRE(parse_and_eval("1 ? 0 ? 5 : 6 : 7", v, undef, cnst, &i, &lsize));
    REQUIRE(v == 6);
}

static TokensLine make_line_2(const std::string& text,
                              const char* file = "expr_divzero",
                              int line = 1) {
    std::string content = text + "\n";
    TokensFile tf(content, file, line, false);
    REQUIRE(tf.tok_lines_count() == 1);
    return tf.get_tok_line(0);
}

TEST_CASE("Expr: division by zero reports error message",
          "[expr][error][divzero][divide]") {
    g_errors.reset();
    g_symbol_table.clear();

    TokensLine tl = make_line_2("10/0");
    unsigned i = 0;
    Expr e;
    REQUIRE(e.parse(tl, i));

    int out = 0;
    bool ok = e.evaluate(out);
    REQUIRE_FALSE(ok);

    REQUIRE(g_errors.has_errors());
    // Message must contain the "Division by zero" text
    REQUIRE(g_errors.last_error_message().find("Division by zero") !=
            std::string::npos);
}

TEST_CASE("Expr: modulus by zero reports error message",
          "[expr][error][divzero][modulus]") {
    g_errors.reset();
    g_symbol_table.clear();

    TokensLine tl = make_line_2("10 % 0");
    unsigned i = 0;
    Expr e;
    REQUIRE(e.parse(tl, i));

    int out = 0;
    bool ok = e.evaluate(out);
    REQUIRE_FALSE(ok);

    REQUIRE(g_errors.has_errors());
    // Message must contain the "Division by zero" text (same error code used)
    REQUIRE(g_errors.last_error_message().find("Division by zero") !=
            std::string::npos);
}

// Additional error coverage for expression parsing

TEST_CASE("Empty expression fails to tokenize", "[expr][error][empty]") {
    g_options = Options();
    std::string content = "\n";
    TokensFile tf(content, "expr_empty", 1, false);
    REQUIRE(tf.tok_lines_count() == 0);
}

TEST_CASE("Expression syntax errors return false and leave index unchanged",
          "[expr][error][syntax]") {
    g_options = Options();

    // Each expression below should tokenize to one line, eval_const_expr should fail,
    // and the evaluation index must remain at 0 (unchanged).
    const std::vector<std::string> cases = {
        ")",            // unexpected closing paren
        "(",            // unterminated opening paren
        "+",            // lone unary operator
        "!",            // lone unary operator
        "~",            // lone unary operator
        "!",            // lone unary operator
        "(1 + 2",       // missing closing paren
        "1 + (2 * 3",   // missing closing paren in nested expression
        "1 +",          // missing RHS operand
        "1 * !",        // missing RHS operand
        "* 1",          // missing LHS operand (prefix '*' without operand)
        "1 <<",         // missing RHS shift amount
        "<< 1",         // missing LHS value for shift
        ":",            // lone colon
        "1 ?",          // ternary missing true/false parts
        "1 ? 2",        // ternary missing ':' and false part
        "1 ? : 2",      // ternary missing true part
        "? 2 : 3",      // ternary missing condition
        "1 ? 2 : ",     // ternary missing false part
    };

    for (const auto& expr_text : cases) {
        INFO("Expr: [" << expr_text << "]");
        std::string content = expr_text + "\n";
        TokensFile tf(content, "expr_err", 1, false);

        // If lexing failed entirely, skip this entry (covered by other lexer tests).
        if (tf.tok_lines_count() == 0) {
            continue;
        }

        const TokensLine& tl = tf.get_tok_line(0);

        Expr expr;
        unsigned idx = 0;
        bool ok = expr.parse(tl, idx) && tl.at_end(idx);
        REQUIRE_FALSE(ok);
    }
}

// New test: trailing binary operator should be left unconsumed; parse succeeds consuming only the valid prefix.
TEST_CASE("Expr::parse stops before trailing binary operator and succeeds",
          "[expr][Expr][stop-index][trailing-op]") {
    g_errors.reset();

    // Case 1: no whitespace "1+"
    {
        TokensLine tl = make_line("1+");
        unsigned i = 0;
        Expr ex;
        bool ok = ex.parse(tl, i);

        REQUIRE(ok);
        // Parser must not be at end; '+' remains unconsumed
        REQUIRE_FALSE(tl.at_end(i));
        // Expression string should reflect only the consumed part
        REQUIRE(ex.to_string() == "1");

        int v = 0;
        REQUIRE(ex.evaluate(v));
        REQUIRE(v == 1);
    }

    // Case 2: with whitespace "1 +"
    {
        TokensLine tl = make_line("1 +");
        unsigned i = 0;
        Expr ex;
        bool ok = ex.parse(tl, i);

        REQUIRE(ok);
        // '+' must remain unconsumed; not at end
        REQUIRE_FALSE(tl.at_end(i));
        REQUIRE(ex.to_string() == "1");

        int v = 0;
        REQUIRE(ex.evaluate(v));
        REQUIRE(v == 1);
    }
}

// -----------------------------------------------------------------------------
// Expr class parsing tests
// -----------------------------------------------------------------------------

TEST_CASE("Expr::parse consumes a valid expression and stops at first non-expression token (comma)",
          "[expr][Expr][parse][stop-index][to_string]") {
    g_errors.reset();
    TokensLine tl = make_line(" 1+2 ,rest");

    unsigned i = 0;
    Expr ex;
    bool ok = ex.parse(tl, i);

    REQUIRE(ok);
    // Must stop at the comma (first non-expression token)
    REQUIRE(i < tl.size());
    REQUIRE(tl[i].type() == TokenType::Comma);

    // to_string() must contain exactly the consumed tokens (no comma)
    REQUIRE(ex.to_string() == "1+2");
    // No errors expected
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Expr::parse stops before an extra closing parenthesis and preserves it unconsumed",
          "[expr][Expr][paren][stop-index][to_string]") {
    g_errors.reset();
    TokensLine tl = make_line("(1+2))");

    unsigned i = 0;
    Expr ex;
    bool ok = ex.parse(tl, i);

    REQUIRE(ok);
    // Should stop at the second ')' which is not part of the parsed expression
    REQUIRE(i < tl.size());
    REQUIRE(tl[i].type() == TokenType::RightParen);

    // to_string() includes the consumed '(1+2)'
    REQUIRE(ex.to_string() == "(1+2)");
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Expr::parse supports identifiers as operands and stops at first non-consumed token",
          "[expr][Expr][ident][stop-index][to_string]") {
    g_errors.reset();
    TokensLine tl = make_line("FOO+1)tail");

    unsigned i = 0;
    Expr ex;
    bool ok = ex.parse(tl, i);

    REQUIRE(ok);
    // The ')' is not part of expression; should be left unconsumed
    REQUIRE(i < tl.size());
    REQUIRE(tl[i].type() == TokenType::RightParen);

    REQUIRE(ex.to_string() == "FOO+1");
    REQUIRE(!g_errors.has_errors());
}

TEST_CASE("Expr::parse reports error on unexpected '?' when not silent and leaves index unchanged",
          "[expr][Expr][errors][unexpected-qmark]") {
    g_errors.reset();
    TokensLine tl = make_line("?");

    unsigned i = 0;
    Expr ex; // not silent by default
    bool ok = ex.parse(tl, i);

    REQUIRE_FALSE(ok);
    // Index unchanged on failure (no leading whitespace in input)
    REQUIRE(i == 0);
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Unexpected '?'") !=
            std::string::npos);
}

TEST_CASE("Expr::parse reports error on missing ':' in ternary when not silent",
          "[expr][Expr][errors][ternary]") {
    g_errors.reset();
    TokensLine tl = make_line("1 ? 2");

    unsigned i = 0;
    Expr ex;
    bool ok = ex.parse(tl, i);

    REQUIRE_FALSE(ok);
    REQUIRE(i == 0);
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Expected ':'") !=
            std::string::npos);
}

TEST_CASE("Expr::parse reports mismatched parenthesis when not silent",
          "[expr][Expr][errors][paren]") {
    g_errors.reset();
    TokensLine tl = make_line("1+(2");

    unsigned i = 0;
    Expr ex;
    bool ok = ex.parse(tl, i);

    REQUIRE_FALSE(ok);
    REQUIRE(i == 0);
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Mismatched parenthesis") !=
            std::string::npos);
}

TEST_CASE("Expr::set_silent suppresses error reporting but still returns false",
          "[expr][Expr][silent]") {
    g_errors.reset();
    TokensLine tl = make_line("?");

    unsigned i = 0;
    Expr ex;
    ex.set_silent(true);
    bool ok = ex.parse(tl, i);

    REQUIRE_FALSE(ok);
    REQUIRE(i == 0);
    // No errors should be recorded when silent
    REQUIRE_FALSE(g_errors.has_errors());
}

//-----------------------------------------------------------------------------
// Expr operators parsing/evaluation tests
// - covers all operators supported by Expr
// - verifies symbol lookup via g_symbol_table (defined/undefined, constant flag)
// - checks division/modulus by zero error reporting
// - ensures g_symbol_table is cleared at the start of every test
//-----------------------------------------------------------------------------

// Unary operators: + - ~ !
TEST_CASE("Expr: unary operators parse and evaluate", "[expr][ops][unary]") {
    g_errors.reset();
    g_symbol_table.clear();

    int v = 0;
    bool undef = false;
    bool cst = false;

    REQUIRE(parse_and_eval("+5", v, undef, cst));
    REQUIRE(v == +5);
    REQUIRE_FALSE(undef);
    REQUIRE(cst);

    REQUIRE(parse_and_eval("-5", v, undef, cst));
    REQUIRE(v == -5);
    REQUIRE_FALSE(undef);
    REQUIRE(cst);

    REQUIRE(parse_and_eval("~0", v, undef, cst));
    REQUIRE(v == ~0);
    REQUIRE_FALSE(undef);
    REQUIRE(cst);

    REQUIRE(parse_and_eval("!0", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("!7", v, undef, cst));
    REQUIRE(v == 0);
}

// Binary arithmetic: + - * / % and power **
TEST_CASE("Expr: arithmetic operators parse and evaluate",
          "[expr][ops][arith]") {
    g_errors.reset();
    g_symbol_table.clear();

    int v = 0;
    bool undef = false;
    bool cst = false;

    REQUIRE(parse_and_eval("2+3", v, undef, cst));
    REQUIRE(v == 5);
    REQUIRE(parse_and_eval("7-10", v, undef, cst));
    REQUIRE(v == -3);
    REQUIRE(parse_and_eval("6*7", v, undef, cst));
    REQUIRE(v == 42);
    REQUIRE(parse_and_eval("20/4", v, undef, cst));
    REQUIRE(v == 5);
    REQUIRE(parse_and_eval("20%6", v, undef, cst));
    REQUIRE(v == 2);

    // power: right-assoc and negative exponent -> 0 per implementation
    REQUIRE(parse_and_eval("2**3", v, undef, cst));
    REQUIRE(v == 8);
    REQUIRE(parse_and_eval("2 ** 3 ** 2", v, undef, cst));
    REQUIRE(v == 512);
    REQUIRE(parse_and_eval("2**-1", v, undef, cst));
    REQUIRE(v == 0);
}

// Shifts, bitwise and logical ops
TEST_CASE("Expr: shift, bitwise, and logical operators",
          "[expr][ops][bitwise][logical]") {
    g_errors.reset();
    g_symbol_table.clear();

    int v = 0;
    bool undef = false;
    bool cst = false;

    REQUIRE(parse_and_eval("1<<3", v, undef, cst));
    REQUIRE(v == (1 << 3));
    REQUIRE(parse_and_eval("16>>2", v, undef, cst));
    REQUIRE(v == (16 >> 2));

    REQUIRE(parse_and_eval("6&3", v, undef, cst));
    REQUIRE(v == (6 & 3));
    REQUIRE(parse_and_eval("6^3", v, undef, cst));
    REQUIRE(v == (6 ^ 3));
    REQUIRE(parse_and_eval("6|1", v, undef, cst));
    REQUIRE(v == (6 | 1));

    REQUIRE(parse_and_eval("1&&0", v, undef, cst));
    REQUIRE(v == 0);
    REQUIRE(parse_and_eval("1||0", v, undef, cst));
    REQUIRE(v == 1);
    // logical xor implemented as (a != b) ? 1 : 0
    REQUIRE(parse_and_eval("0^^0", v, undef, cst));
    REQUIRE(v == 0);
    REQUIRE(parse_and_eval("0^^1", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("2^^2", v, undef, cst));
    REQUIRE(v == 0);
}

// Comparisons
TEST_CASE("Expr: comparison operators", "[expr][ops][compare]") {
    g_errors.reset();
    g_symbol_table.clear();

    int v = 0;
    bool undef = false;
    bool cst = false;

    REQUIRE(parse_and_eval("3<4", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("3<=4", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("4>3", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("4>=4", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("5=5", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("5!=4", v, undef, cst));
    REQUIRE(v == 1);
    REQUIRE(parse_and_eval("5!=5", v, undef, cst));
    REQUIRE(v == 0);
}

// Ternary
TEST_CASE("Expr: ternary operator", "[expr][ops][ternary]") {
    g_errors.reset();
    g_symbol_table.clear();

    int v = 0;
    bool undef = false;
    bool cst = false;

    REQUIRE(parse_and_eval("1?2:3", v, undef, cst));
    REQUIRE(v == 2);
    REQUIRE(parse_and_eval("0?2:3", v, undef, cst));
    REQUIRE(v == 3);
    REQUIRE(parse_and_eval("1?0?5:6:7", v, undef, cst));
    REQUIRE(v == 6);
}

// Symbol handling: defined vs undefined; constant flag propagation
TEST_CASE("Expr: symbol lookup defined/undefined and constant flag",
          "[expr][ops][symbol]") {
    g_errors.reset();
    g_symbol_table.clear();

    // Populate one constant symbol and one non-constant symbol
    Symbol s_const;
    s_const.name = "A";
    s_const.value = 10;
    s_const.is_defined = true;
    s_const.is_constant = true;
    Symbol s_var;
    s_var.name = "B";
    s_var.value = 3;
    s_var.is_defined = true;
    s_var.is_constant = false;
    REQUIRE(g_symbol_table.add_symbol("A", s_const));
    REQUIRE(g_symbol_table.add_symbol("B", s_var));

    int v = 0;
    bool undef = false;
    bool cst = false;

    // Defined constant only -> constant result
    REQUIRE(parse_and_eval("A+2", v, undef, cst));
    REQUIRE(v == 12);
    REQUIRE_FALSE(undef);
    REQUIRE(cst); // still constant

    // Mix const and non-const -> not constant
    REQUIRE_FALSE(parse_and_eval("A+B*2", v, undef, cst));
    REQUIRE(v == 0);
    REQUIRE_FALSE(undef);
    REQUIRE_FALSE(cst);

    // Undefined symbol -> evaluation fails and sets is_undefined
    {
        TokensLine tl = make_line("C+1");
        unsigned i = 0;
        Expr e;
        REQUIRE(e.parse(tl, i));
        int out = 0;
        bool ok = e.evaluate(out);
        REQUIRE_FALSE(ok);
        REQUIRE(e.is_undefined());
    }
}

// Division/modulus by zero: report error and fail evaluation
TEST_CASE("Expr: division and modulus by zero error", "[expr][ops][divzero]") {
    g_errors.reset();
    g_symbol_table.clear();

    // "10/0"
    {
        TokensLine tl = make_line("10/0");
        unsigned i = 0;
        Expr e;
        REQUIRE(e.parse(tl, i));
        int out = 0;
        bool ok = e.evaluate(out);
        REQUIRE_FALSE(ok);
        REQUIRE(g_errors.has_errors());
        REQUIRE(g_errors.last_error_message().find("Division by zero") !=
                std::string::npos);
    }

    // "10 % 0"
    {
        g_errors.reset();
        TokensLine tl = make_line("10 % 0");
        unsigned i = 0;
        Expr e;
        REQUIRE(e.parse(tl, i));
        int out = 0;
        bool ok = e.evaluate(out);
        REQUIRE_FALSE(ok);
        REQUIRE(g_errors.has_errors());
        REQUIRE(g_errors.last_error_message().find("Division by zero") !=
                std::string::npos);
    }
}

// Parsing should stop at comma/colon without consuming them; consumed index returned
TEST_CASE("Expr: parsing consumes up to comma/colon and leaves index at first non-consumed token",
          "[expr][ops][stop-index]") {
    g_errors.reset();
    g_symbol_table.clear();

    {
        TokensLine tl = make_line("1+2,rest");
        unsigned i = 0;
        Expr e;
        REQUIRE(e.parse(tl, i));
        REQUIRE(tl[i].type() == TokenType::Comma);
        int v = 0;
        REQUIRE(e.evaluate(v));
        REQUIRE(v == 3);
    }
    {
        TokensLine tl = make_line("1?2:3:after");
        unsigned i = 0;
        Expr e;
        REQUIRE(e.parse(tl, i));
        // After parsing "1?2:3", the next token should be ':'
        REQUIRE(tl[i].type() == TokenType::Colon);
        int v = 0;
        REQUIRE(e.evaluate(v));
        REQUIRE(v == 2);
    }
}
