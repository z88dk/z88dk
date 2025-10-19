//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../expr.h"
#include "catch_amalgamated.hpp"

TEST_CASE("eval_const_expr: simple numbers and pointer advancement", "[expr]") {
    {
        std::string s = "42";
        const char* p = s.c_str();
        int v = 0;
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 42);
        CHECK(*p == '\0');
    }
    {
        std::string s = "   0x2A,rest";
        const char* p = s.c_str();
        int v = 0;
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 42);
        // pointer should stop at comma
        CHECK(*p == ',');
    }
    {
        std::string s = ""; // empty input -> fail
        const char* p = s.c_str();
        int v = 0;
        REQUIRE_FALSE(eval_const_expr(p, v));
    }
}

TEST_CASE("eval_const_expr: unary operators", "[expr][unary]") {
    int v;
    {
        std::string s = "-5";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == -5);
    }
    {
        std::string s = "+7";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 7);
    }
    {
        std::string s = "!0";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
    {
        std::string s = "!123";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 0);
    }
    {
        std::string s = "~0";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == -1);
    }
}

TEST_CASE("eval_const_expr: binary arithmetic and precedence",
          "[expr][arithmetic][precedence]") {
    int v;
    {
        std::string s = "1+2*3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 7); // multiplication before addition
    }
    {
        std::string s = "(1+2)*3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 9);
    }
    {
        std::string s = "10/3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 10 / 3);
    }
    {
        std::string s = "2+3-4";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
    {
        std::string s = "2*3%4";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == (2 * 3) % 4);
    }
}

TEST_CASE("eval_const_expr: shifts, comparisons, equality",
          "[expr][shift][cmp]") {
    int v;
    {
        std::string s = "1<<3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 8);
    }
    {
        std::string s = "8>>2";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 2);
    }
    {
        std::string s = "1<2";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
    {
        std::string s = "2<=2";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
    {
        std::string s = "3>4";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 0);
    }
    {
        std::string s = "5==5";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
    {
        std::string s = "5!=6";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
}

TEST_CASE("eval_const_expr: bitwise and logical operators",
          "[expr][bitwise][logical]") {
    int v;
    {
        std::string s = "6 & 3"; // 110 & 011 = 010 (2)
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 2);
    }
    {
        std::string s = "4 | 1"; // 100 | 001 = 101 (5)
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 5);
    }
    {
        std::string s = "7 ^ 2"; // 111 ^ 010 = 101 (5)
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 5);
    }
    {
        std::string s = "0 && 5";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 0);
    }
    {
        std::string s = "1 || 0";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
    {
        std::string s = "1 ^^ 1"; // XOR as '^^' -> false
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 0);
    }
    {
        std::string s = "1 ^^ 0";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
}

TEST_CASE("eval_const_expr: ternary operator", "[expr][ternary]") {
    int v;
    {
        std::string s = "1 ? 2 : 3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 2);
    }
    {
        std::string s = "0 ? 2 : 3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 3);
    }
    {
        std::string s = "1 ? 2 : 3 ? 4 : 5"; // 1 ? 2 : (3 ? 4 : 5) => 2
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 2);
    }
    {
        std::string s = "0 ? 2 : 3 ? 4 : 5"; // 0 ? 2 : (3 ? 4 : 5) => 4
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 4);
    }
}

TEST_CASE("eval_const_expr: exponentiation and associativity", "[expr][pow]") {
    int v;
    {
        std::string s = "2 ** 3";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 8);
    }
    {
        std::string s = "2 ** 3 ** 2"; // right-assoc: 2 ** (3 ** 2) = 2 ** 9 = 512
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 512);
    }
    {
        std::string s = "3 ** 0";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 1);
    }
}

TEST_CASE("eval_const_expr: pointer stops at invalid char and ignores trailing whitespace",
          "[expr][pointer]") {
    int v;
    {
        std::string s = "  1+2 ,foo";
        const char* p = s.c_str();
        REQUIRE(eval_const_expr(p, v));
        CHECK(v == 3);
        // should stop at space before comma (tokenizer stops at comma)
        // advance over any whitespace left by caller's expectations if needed; here we check current char
        while (isspace(static_cast<unsigned char>(*p))) {
            ++p;
        }
        CHECK(*p == ',');
    }
}

TEST_CASE("eval_const_expr: error cases (division by zero, incomplete expressions)",
          "[expr][error]") {
    int v;
    {
        std::string s = "1/0";
        const char* p = s.c_str();
        REQUIRE_FALSE(eval_const_expr(p, v)); // division by zero -> failure
    }
    {
        std::string s = "2 +";
        const char* p = s.c_str();
        REQUIRE_FALSE(eval_const_expr(p, v)); // incomplete expression
    }
    {
        std::string s = "(1+2";
        const char* p = s.c_str();
        REQUIRE_FALSE(eval_const_expr(p, v)); // mismatched parentheses
    }
    {
        std::string s = "foobar"; // not a number / operator
        const char* p = s.c_str();
        REQUIRE_FALSE(eval_const_expr(p, v));
    }
}

