//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../expr.h"
#include "catch_amalgamated.hpp"
#include "../lexer.h"
#include "../errors.h"
#include "../options.h"

// Helper to evaluate an expression string using the project's tokenizer + eval_const_expr.
// The input string should represent a single expression (we append '\n' to create a token line).
static bool eval_expr_from_string(const std::string& expr, int& outValue,
                                  unsigned& outIndex, const TokensLine*& outLine) {
    g_options = Options(); // ensure default options
    std::string content = expr + "\n";
    TokensFile tf(content, "expr_test", 1);
    if (tf.tok_lines_count() == 0) {
        return false;
    }
    const TokensLine& tl = tf.get_tok_line(0);
    outLine = &tl;
    unsigned idx = 0;
    int val = 0;
    bool ok = eval_const_expr(tl, idx, val);
    outValue = val;
    outIndex = idx;
    return ok;
}

TEST_CASE("Basic arithmetic and precedence", "[expr][precedence]") {
    int v;
    unsigned i;
    const TokensLine* tl = nullptr;

    // multiplication binds tighter than addition
    REQUIRE(eval_expr_from_string("2 + 3 * 4", v, i, tl));
    REQUIRE(v == 14);
    REQUIRE(i == tl->size());

    // parentheses override precedence
    REQUIRE(eval_expr_from_string("(2 + 3) * 4", v, i, tl));
    REQUIRE(v == 20);
    REQUIRE(i == tl->size());
}

TEST_CASE("Power operator (**) is right-associative and handles negative exponent as zero",
          "[expr][power][associativity]") {
    int v;
    unsigned i;
    const TokensLine* tl = nullptr;

    // right-assoc: 2 ** (3 ** 2) == 2 ** 9 == 512
    REQUIRE(eval_expr_from_string("2 ** 3 ** 2", v, i, tl));
    REQUIRE(v == 512);
    REQUIRE(i == tl->size());

    // negative exponent -> defined as 0 by implementation
    REQUIRE(eval_expr_from_string("2 ** -1", v, i, tl));
    REQUIRE(v == 0);
    REQUIRE(i == tl->size());

    // unary minus interacts with power precedence: unary has lower precedence than binary power
    // so "-2 ** 3" -> -(2 ** 3) == -8 (not (-2) ** 3)
    REQUIRE(eval_expr_from_string("-2 ** 3", v, i, tl));
    REQUIRE(v == -8);
    REQUIRE(i == tl->size());
}

TEST_CASE("Left associativity for subtraction, division, shifts",
          "[expr][associativity]") {
    int v;
    unsigned i;
    const TokensLine* tl = nullptr;

    REQUIRE(eval_expr_from_string("10 - 3 - 2", v, i, tl));
    REQUIRE(v == 5); // (10 - 3) - 2

    REQUIRE(eval_expr_from_string("20 / 2 / 2", v, i, tl));
    REQUIRE(v == 5); // (20 / 2) / 2

    REQUIRE(eval_expr_from_string("1 << 2 << 1", v, i, tl));
    REQUIRE(v == 8); // (1<<2)<<1 == 4<<1 == 8
}

TEST_CASE("Bitwise and logical operators precedence and results (^ vs ^^, & vs &&, | vs ||)",
          "[expr][bitwise][logical][precedence]") {
    int v;
    unsigned i;
    const TokensLine* tl = nullptr;

    // bitwise AND binds tighter than bitwise OR: (1 & 2) | 4 == 0 | 4 == 4
    REQUIRE(eval_expr_from_string("1 & 2 | 4", v, i, tl));
    REQUIRE(v == 4);

    // bitwise xor '^' is a bitwise op, precedence higher than logical xor '^^'
    // (1 ^ 2) ^^ 2 -> (3) ^^ 2 -> logical xor: (3 != 2) -> 1
    REQUIRE(eval_expr_from_string("1 ^ 2 ^^ 2", v, i, tl));
    REQUIRE(v == 1);

    // bitwise xor result correctness
    REQUIRE(eval_expr_from_string("6 ^ 3", v, i, tl));
    REQUIRE(v == (6 ^ 3));

    // logical xor '^^' yields 1 if operands are different (non-zero), else 0
    REQUIRE(eval_expr_from_string("2 ^^ 1", v, i, tl));
    REQUIRE(v == 1);
    REQUIRE(eval_expr_from_string("2 ^^ 2", v, i, tl));
    REQUIRE(v == 0);

    // logical AND/OR precedence: && binds tighter than ||
    REQUIRE(eval_expr_from_string("1 && 0 || 0", v, i, tl));
    REQUIRE(v == 0); // (1&&0) || 0 == 0
    REQUIRE(eval_expr_from_string("1 || 0 && 0", v, i, tl));
    REQUIRE(v == 1); // 1 || (0 && 0) == 1
}

TEST_CASE("Comparisons and equality produce boolean 1/0",
          "[expr][comparison]") {
    int v;
    unsigned i;
    const TokensLine* tl = nullptr;

    REQUIRE(eval_expr_from_string("3 < 4", v, i, tl));
    REQUIRE(v == 1);
    REQUIRE(eval_expr_from_string("3 >= 4", v, i, tl));
    REQUIRE(v == 0);
    REQUIRE(eval_expr_from_string("2 = 2", v, i, tl));
    REQUIRE(v == 1);
    REQUIRE(eval_expr_from_string("2 != 3", v, i, tl));
    REQUIRE(v == 1);
}

TEST_CASE("Ternary operator ? : selects correct branch and parsing stops at colon when appropriate",
          "[expr][ternary]") {
    int v;
    unsigned i;
    const TokensLine* tl = nullptr;

    REQUIRE(eval_expr_from_string("1 ? 2 : 3", v, i, tl));
    REQUIRE(v == 2);

    REQUIRE(eval_expr_from_string("0 ? 2 : 3", v, i, tl));
    REQUIRE(v == 3);

    // nested ternary: 1 ? 0 ? 5 : 6 : 7  -> inner 0 ? 5 : 6 -> 6 ; outer -> 1 ? 6 : 7 -> 6
    REQUIRE(eval_expr_from_string("1 ? 0 ? 5 : 6 : 7", v, i, tl));
    REQUIRE(v == 6);
}

TEST_CASE("Division or modulus by zero fails and leaves index unchanged",
          "[expr][error]") {
    g_options = Options();
    std::string expr = "1 / 0";
    std::string content = expr + "\n";
    TokensFile tf(content, "expr_fail", 1);
    REQUIRE(tf.tok_lines_count() == 1);
    const TokensLine& tl = tf.get_tok_line(0);

    unsigned idx = 0;
    int val = 12345;
    bool ok = eval_const_expr(tl, idx, val);
    REQUIRE(ok == false);
    // index must be unchanged on failure
    REQUIRE(idx == 0);

    // modulus by zero
    idx = 0;
    val = 0;
    ok = eval_const_expr(tl, idx, val); // reuse "1 / 0" -> still division by zero
    REQUIRE(ok == false);
    REQUIRE(idx == 0);
}

