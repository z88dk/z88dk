//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../keywords.h"
#include "../lexer.h"
#include "../token.h"
#include "catch_amalgamated.hpp"
#include <sstream>
#include <string>

TEST_CASE("scan_identifier extracts valid identifiers", "[read_identifier]") {
    std::string out;

    SECTION("Simple identifier") {
        const char* p = "foo";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "foo");
        CHECK(*p == '\0');
    }

    SECTION("Identifier with quote") {
        const char* p = "af'";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "af'");
        CHECK(*p == '\0');
    }

    SECTION("Identifier without quote") {
        const char* p = "define'";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "define");
        CHECK(*p == '\'');
    }

    SECTION("Identifier with digits and underscores") {
        const char* p = "_bar123 rest";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "_bar123");
        char next = *p;
        CHECK(next == ' ');
    }

    SECTION("Identifier at start of stream") {
        const char* p = "abc123";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "abc123");
    }

    SECTION("No identifier at start") {
        const char* p = " 123abc";
        REQUIRE_FALSE(scan_identifier(p, out));
    }

    SECTION("Empty input") {
        const char* p = "";
        REQUIRE_FALSE(scan_identifier(p, out));
    }

    SECTION("Identifier followed by punctuation") {
        const char* p = "foo_bar;next";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "foo_bar");
        char next = *p;
        CHECK(next == ';');
    }
}

TEST_CASE("tokenize_macro_body splits identifiers, numbers, and operators",
          "[tokenize_macro_body]") {
    auto tokens = tokenize_macro_body("foo 123 + bar");
    REQUIRE(tokens.size() == 7);
    CHECK(tokens[0].type == MacroTokenType::Identifier);
    CHECK(tokens[0].text == "foo");
    CHECK(tokens[1].type == MacroTokenType::Punctuator);
    CHECK(tokens[1].text == " ");
    CHECK(tokens[2].type == MacroTokenType::Number);
    CHECK(tokens[2].text == "123");
    CHECK(tokens[3].type == MacroTokenType::Punctuator);
    CHECK(tokens[3].text == " ");
    CHECK(tokens[4].type == MacroTokenType::Punctuator);
    CHECK(tokens[4].text == "+");
    CHECK(tokens[5].type == MacroTokenType::Punctuator);
    CHECK(tokens[5].text == " ");
    CHECK(tokens[6].type == MacroTokenType::Identifier);
    CHECK(tokens[6].text == "bar");
}

TEST_CASE("tokenize_macro_body handles string and char literals",
          "[tokenize_macro_body]") {
    auto tokens = tokenize_macro_body("\"hello\" 'a'");
    REQUIRE(tokens.size() == 3);
    CHECK(tokens[0].type == MacroTokenType::StringLiteral);
    CHECK(tokens[0].text == "\"hello\"");
    CHECK(tokens[1].type == MacroTokenType::Punctuator);
    CHECK(tokens[1].text == " ");
    CHECK(tokens[2].type == MacroTokenType::Number);
    CHECK(tokens[2].text == "97");
}

TEST_CASE("tokenize_macro_body handles punctuators", "[tokenize_macro_body]") {
    auto tokens = tokenize_macro_body("(foo,bar);");
    REQUIRE(tokens.size() >= 6);
    CHECK(tokens[0].type == MacroTokenType::Punctuator);
    CHECK(tokens[0].text == "(");
    CHECK(tokens[1].type == MacroTokenType::Identifier);
    CHECK(tokens[1].text == "foo");
    CHECK(tokens[2].type == MacroTokenType::Punctuator);
    CHECK(tokens[2].text == ",");
    CHECK(tokens[3].type == MacroTokenType::Identifier);
    CHECK(tokens[3].text == "bar");
    CHECK(tokens[4].type == MacroTokenType::Punctuator);
    CHECK(tokens[4].text == ")");
    CHECK(tokens[5].type == MacroTokenType::Punctuator);
    CHECK(tokens[5].text == ";");
}

TEST_CASE("tokenize_macro_body returns empty for empty input",
          "[tokenize_macro_body]") {
    auto tokens = tokenize_macro_body("");
    CHECK(tokens.empty());
}

TEST_CASE("scan_whitespace detects and skips whitespace", "[scan_whitespace]") {
    SECTION("No whitespace at start") {
        const char* p = "abc";
        REQUIRE_FALSE(scan_whitespace(p));
        CHECK(*p == 'a');
    }
    SECTION("Single space") {
        const char* p = " abc";
        REQUIRE(scan_whitespace(p));
        CHECK(*p == 'a');
    }
    SECTION("Multiple spaces and tabs") {
        const char* p = " \t  \txyz";
        REQUIRE(scan_whitespace(p));
        CHECK(*p == 'x');
    }
    SECTION("Whitespace only") {
        const char* p = "   \t\n";
        REQUIRE(scan_whitespace(p));
        CHECK(*p == '\0');
    }
    SECTION("Empty string") {
        const char* p = "";
        REQUIRE_FALSE(scan_whitespace(p));
        CHECK(*p == '\0');
    }
}

TEST_CASE("skip_whitespace always skips whitespace if present",
          "[skip_whitespace]") {
    SECTION("No whitespace at start") {
        const char* p = "foo";
        skip_whitespace(p);
        CHECK(*p == 'f');
    }
    SECTION("Whitespace at start") {
        const char* p = "   bar";
        skip_whitespace(p);
        CHECK(*p == 'b');
    }
    SECTION("Whitespace only") {
        const char* p = "   \t\n";
        skip_whitespace(p);
        CHECK(*p == '\0');
    }
    SECTION("Empty string") {
        const char* p = "";
        skip_whitespace(p);
        CHECK(*p == '\0');
    }
}

TEST_CASE("scan_identifier (C-string version) extracts valid identifiers",
          "[scan_identifier_cstr]") {
    std::string out;

    SECTION("Simple identifier") {
        const char* p = "foo";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "foo");
        CHECK(*p == '\0');
    }

    SECTION("Identifier with quote and keyword") {
        const char* p = "af'";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "af'");
        CHECK(*p == '\0');
    }

    SECTION("Identifier with quote but not keyword") {
        const char* p = "define'";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "define");
        CHECK(*p == '\'');
    }

    SECTION("Identifier with digits and underscores") {
        const char* p = "_bar123 rest";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "_bar123");
        CHECK(*p == ' ');
    }

    SECTION("Identifier at start of string") {
        const char* p = "abc123";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "abc123");
        CHECK(*p == '\0');
    }

    SECTION("No identifier at start (digit)") {
        const char* p = " 123abc";
        REQUIRE_FALSE(scan_identifier(p, out));
        CHECK(*p == ' ');
    }

    SECTION("No identifier at start (punctuation)") {
        const char* p = ";foo";
        REQUIRE_FALSE(scan_identifier(p, out));
        CHECK(*p == ';');
    }

    SECTION("Empty input") {
        const char* p = "";
        REQUIRE_FALSE(scan_identifier(p, out));
        CHECK(*p == '\0');
    }

    SECTION("Identifier with leading whitespace") {
        const char* p = "   foo";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "foo");
        CHECK(*p == '\0');
    }

    SECTION("Identifier followed by punctuation") {
        const char* p = "foo_bar;next";
        REQUIRE(scan_identifier(p, out));
        CHECK(out == "foo_bar");
        CHECK(*p == ';');
    }
}

TEST_CASE("scan_integer parses all supported number formats",
          "[scan_integer]") {
    int out;

    SECTION("Hexadecimal: 0x/0X prefix") {
        const char* p = "0x1A3f";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0x1A3F);
        CHECK(*p == '\0');

        p = "0Xdead_beef";
        REQUIRE(scan_integer(p, out));
        CHECK(out == static_cast<int>(0xDEADBEEF));
        CHECK(*p == '\0');
    }

    SECTION("Hexadecimal: $ prefix") {
        const char* p = "$1A3f";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0x1A3F);
        CHECK(*p == '\0');

        p = "$dead_beef";
        REQUIRE(scan_integer(p, out));
        CHECK(out == static_cast<int>(0xDEADBEEF));
        CHECK(*p == '\0');
    }

    SECTION("Hexadecimal: h/H suffix") {
        const char* p = "1A3Fh";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0x1A3F);
        CHECK(*p == '\0');

        p = "0dead_beefH";
        REQUIRE(scan_integer(p, out));
        CHECK(out == static_cast<int>(0xDEADBEEF));
        CHECK(*p == '\0');
    }

    SECTION("Binary: % prefix") {
        const char* p = "%1010_1100";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b10101100);
        CHECK(*p == '\0');
    }

    SECTION("Binary: @ prefix") {
        const char* p = "@1101_0011";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b11010011);
        CHECK(*p == '\0');
    }

    SECTION("Binary: 0b/0B prefix") {
        const char* p = "0b1010_1100";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b10101100);
        CHECK(*p == '\0');

        p = "0B1101_0011";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b11010011);
        CHECK(*p == '\0');

        p = "0b";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0);
        CHECK(*p == '\0');
    }

    SECTION("Binary: b/B suffix") {
        const char* p = "1010_1100b";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b10101100);
        CHECK(*p == '\0');

        p = "1101_0011B";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b11010011);
        CHECK(*p == '\0');
    }

    SECTION("Binary: graphical bitmask %\"-#-#\"") {
        const char* p = "%\"-#-#\"";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b0101);
        CHECK(*p == '\0');

        p = "%\"##--_#-\""; // invalid char '_'
        REQUIRE_FALSE(scan_integer(p, out));

        p = "%\"#-#-#-#-\"";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b10101010);
        CHECK(*p == '\0');

        p = "@\"#--#\"";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0b1001);
        CHECK(*p == '\0');
    }

    SECTION("Decimal: plain digits") {
        const char* p = "123456";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 123456);
        CHECK(*p == '\0');

        p = "1_234_567";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 1234567);
        CHECK(*p == '\0');
    }

    SECTION("Decimal: d/D suffix") {
        const char* p = "123456d";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 123456);
        CHECK(*p == '\0');

        p = "1_234_567D";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 1234567);
        CHECK(*p == '\0');
    }

    SECTION("Invalid formats") {
        const char* p = "0x";
        REQUIRE_FALSE(scan_integer(p, out));

        p = "$";
        REQUIRE_FALSE(scan_integer(p, out));

        p = "%";
        REQUIRE_FALSE(scan_integer(p, out));

        p = "@";
        REQUIRE_FALSE(scan_integer(p, out));

        p = "0b2";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0);

        p = "0b_";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0);

        p = "%\"\"";
        REQUIRE_FALSE(scan_integer(p, out));

        p = "%\"-#-#";
        REQUIRE_FALSE(scan_integer(p, out));
    }
}

TEST_CASE("scan_float parses all supported floating-point formats",
          "[scan_float]") {
    double out;

    SECTION("Simple decimal with dot") {
        const char* p = "123.456";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(123.456));
        CHECK(*p == '\0');
    }

    SECTION("Leading dot") {
        const char* p = ".789";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(0.789));
        CHECK(*p == '\0');
    }

    SECTION("Trailing dot") {
        const char* p = "42.";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(42.0));
        CHECK(*p == '\0');
    }

    SECTION("With exponent, no dot") {
        const char* p = "1e3";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(1000.0));
        CHECK(*p == '\0');

        p = "7E-2";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(0.07));
        CHECK(*p == '\0');
    }

    SECTION("With dot and exponent") {
        const char* p = "3.14e2";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(314.0));
        CHECK(*p == '\0');

        p = ".5E1";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(5.0));
        CHECK(*p == '\0');
    }

    SECTION("With exponent and sign") {
        const char* p = "2.5e+2";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(250.0));
        CHECK(*p == '\0');

        p = "2.5e-2";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(0.025));
        CHECK(*p == '\0');
    }

    SECTION("With leading/trailing whitespace") {
        const char* p = "   6.022e23";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(6.022e23));
        CHECK(*p == '\0');

        p = "1.0e-10   ";
        REQUIRE(scan_float(p, out));
        CHECK(out == Catch::Approx(1.0e-10));
        CHECK(*p == ' ');
    }

    SECTION("No dot or exponent (should fail)") {
        const char* p = "12345";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == '1');
    }

    SECTION("No digits (should fail)") {
        const char* p = ".";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == '.');

        p = "e10";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == 'e');
    }

    SECTION("Exponent with no digits (should fail)") {
        const char* p = "1e";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == '1');
    }

    SECTION("Exponent with no digits after sign (should fail)") {
        const char* p = "1e+";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == '1');
    }

    SECTION("Negative numbers (should fail, no sign allowed)") {
        const char* p = "-1.23";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == '-');
    }

    SECTION("Plus sign (should fail, no sign allowed)") {
        const char* p = "+4.56";
        REQUIRE_FALSE(scan_float(p, out));
        CHECK(*p == '+');
    }
}

TEST_CASE("scan_integer parses single-quoted character literals as integers",
          "[scan_integer][char_literal]") {
    int out;

    SECTION("Empty quoted string (should fail)") {
        const char* p = "''";
        REQUIRE_FALSE(scan_integer(p, out));
        CHECK(*p == '\'');
    }

    SECTION("More than one character (should fail)") {
        const char* p = "'ab'";
        REQUIRE_FALSE(scan_integer(p, out));
        CHECK(*p == '\'');
    }

    SECTION("Single ASCII character") {
        const char* p = "'A'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 65);
        CHECK(*p == '\0');

        p = "' '";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 32);
        CHECK(*p == '\0');
    }

    SECTION("C escape: \\n") {
        const char* p = "'\\n'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 10);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\r") {
        const char* p = "'\\r'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 13);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\t") {
        const char* p = "'\\t'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 9);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\b") {
        const char* p = "'\\b'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 8);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\f") {
        const char* p = "'\\f'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 12);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\a") {
        const char* p = "'\\a'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 7);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\v") {
        const char* p = "'\\v'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 11);
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\\\'") {
        const char* p = "'\\''";
        REQUIRE(scan_integer(p, out));
        CHECK(out == '\'');
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\\"") {
        const char* p = "'\\\"'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == '\"');
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\\\") {
        const char* p = "'\\\\'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == '\\');
        CHECK(*p == '\0');
    }
    SECTION("C escape: \\e (escape char)") {
        const char* p = "'\\e'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0x1B);
        CHECK(*p == '\0');
    }
    SECTION("Octal escape: \\0") {
        const char* p = "'\\0'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 0);
        CHECK(*p == '\0');
    }
    SECTION("Octal escape: \\101 (A)") {
        const char* p = "'\\101'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 65);
        CHECK(*p == '\0');
    }
    SECTION("Hex escape: \\x41 (A)") {
        const char* p = "'\\x41'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 65);
        CHECK(*p == '\0');
    }
    SECTION("Hex escape: \\x0a (newline)") {
        const char* p = "'\\x0a'";
        REQUIRE(scan_integer(p, out));
        CHECK(out == 10);
        CHECK(*p == '\0');
    }
}

TEST_CASE("scan_string_literal parses double-quoted strings with C-escapes and \\e",
          "[scan_string_literal]") {
    std::string out;

    SECTION("Simple string") {
        const char* p = "\"hello\"";
        REQUIRE(scan_string_literal(p, out));
        CHECK(out == "\"hello\"");
        CHECK(*p == '\0');
    }

    SECTION("String with C-escapes") {
        const char* p = "\"line1\\nline2\\tend\"";
        REQUIRE(scan_string_literal(p, out));
        CHECK(out == "\"line1\\nline2\\tend\"");
        CHECK(*p == '\0');
    }

    SECTION("String with \\e escape") {
        const char* p = "\"escape\\echar\"";
        REQUIRE(scan_string_literal(p, out));
        CHECK(out == "\"escape\\echar\"");
        CHECK(*p == '\0');
    }

    SECTION("String with hex and octal escapes") {
        const char* p = "\"hex\\x41 octal\\101\"";
        REQUIRE(scan_string_literal(p, out));
        CHECK(out == "\"hex\\x41 octal\\101\"");
        CHECK(*p == '\0');
    }

    SECTION("String with escaped quote and backslash") {
        const char* p = "\"\\\"quoted\\\" and \\\\backslash\"";
        REQUIRE(scan_string_literal(p, out));
        CHECK(out == "\"\\\"quoted\\\" and \\\\backslash\"");
        CHECK(*p == '\0');
    }

    SECTION("Unterminated string (should fail)") {
        const char* p = "\"unterminated";
        REQUIRE_FALSE(scan_string_literal(p, out));
        CHECK(*p == '\"');
    }

    SECTION("Empty string") {
        const char* p = "\"\"";
        REQUIRE(scan_string_literal(p, out));
        CHECK(out == "\"\"");
        CHECK(*p == '\0');
    }
}

TEST_CASE("scan_operator parses C operators, punctuators, ^^ and **",
          "[scan_operator]") {
    std::string out;

    // 2-char operators
    SECTION("Double char operators") {
        const char* p = "&&";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "&&");
        CHECK(*p == '\0');

        p = "||";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "||");
        CHECK(*p == '\0');

        p = "^^";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "^^");
        CHECK(*p == '\0');

        p = "<=";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "<=");
        CHECK(*p == '\0');

        p = ">=";
        REQUIRE(scan_operator(p, out));
        CHECK(out == ">=");
        CHECK(*p == '\0');

        p = "==";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "==");
        CHECK(*p == '\0');

        p = "!=";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "!=");
        CHECK(*p == '\0');

        p = "<>";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "<>");
        CHECK(*p == '\0');

        p = "##";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "##");
        CHECK(*p == '\0');

        p = "**";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "**");
        CHECK(*p == '\0');
    }

    // 1-char operators and punctuators
    SECTION("Single char operators and punctuators") {
        const char* p = "+";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "+");
        CHECK(*p == '\0');

        p = "-";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "-");
        CHECK(*p == '\0');

        p = "*";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "*");
        CHECK(*p == '\0');

        p = "/";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "/");
        CHECK(*p == '\0');

        p = "%";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "%");
        CHECK(*p == '\0');

        p = "&";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "&");
        CHECK(*p == '\0');

        p = "|";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "|");
        CHECK(*p == '\0');

        p = "^";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "^");
        CHECK(*p == '\0');

        p = "!";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "!");
        CHECK(*p == '\0');

        p = "~";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "~");
        CHECK(*p == '\0');

        p = "=";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "=");
        CHECK(*p == '\0');

        p = "<";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "<");
        CHECK(*p == '\0');

        p = ">";
        REQUIRE(scan_operator(p, out));
        CHECK(out == ">");
        CHECK(*p == '\0');

        p = "?";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "?");
        CHECK(*p == '\0');

        p = ":";
        REQUIRE(scan_operator(p, out));
        CHECK(out == ":");
        CHECK(*p == '\0');

        p = ",";
        REQUIRE(scan_operator(p, out));
        CHECK(out == ",");
        CHECK(*p == '\0');

        p = ".";
        REQUIRE(scan_operator(p, out));
        CHECK(out == ".");
        CHECK(*p == '\0');

        p = "(";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "(");
        CHECK(*p == '\0');

        p = ")";
        REQUIRE(scan_operator(p, out));
        CHECK(out == ")");
        CHECK(*p == '\0');

        p = "{";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "{");
        CHECK(*p == '\0');

        p = "}";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "}");
        CHECK(*p == '\0');

        p = "[";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "[");
        CHECK(*p == '\0');

        p = "]";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "]");
        CHECK(*p == '\0');

        p = "#";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "#");
        CHECK(*p == '\0');
    }

    SECTION("Operator with trailing text") {
        const char* p = "&&foo";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "&&");
        CHECK(std::string(p) == "foo");

        p = "+bar";
        REQUIRE(scan_operator(p, out));
        CHECK(out == "+");
        CHECK(std::string(p) == "bar");
    }

    SECTION("No operator at start") {
        const char* p = "abc";
        REQUIRE_FALSE(scan_operator(p, out));
        CHECK(out.empty());
        CHECK(std::string(p) == "abc");

        p = "";
        REQUIRE_FALSE(scan_operator(p, out));
        CHECK(out.empty());
        CHECK(std::string(p) == "");
    }
}

// Additional tests for unescape_string
TEST_CASE("unescape_string: quoted and unquoted strings, C-style escapes, octal and hex",
          "[unescape_string]") {
    SECTION("Empty input") {
        CHECK(unescape_string("") == "");
    }

    SECTION("Quoted empty string") {
        CHECK(unescape_string("\"\"") == "");
    }

    SECTION("Unquoted simple string remains unchanged") {
        CHECK(unescape_string("hello") == "hello");
    }

    SECTION("Quoted simple string strips quotes") {
        CHECK(unescape_string("\"hello\"") == "hello");
    }

    SECTION("C escapes inside quoted string (newline and tab)") {
        std::string out = unescape_string("\"line1\\nline2\\tend\"");
        CHECK(out == std::string("line1\nline2\tend"));
    }

    SECTION("C escapes inside unquoted string are processed too") {
        std::string out = unescape_string("line1\\nline2\\tend");
        CHECK(out == std::string("line1\nline2\tend"));
    }

    SECTION("Escaped quote and backslash in quoted string") {
        std::string out = unescape_string("\"\\\"quoted\\\" and \\\\backslash\"");
        CHECK(out == std::string("\"quoted\" and \\backslash"));
    }

    SECTION("Escape for ESC (\\e)") {
        std::string out = unescape_string("\"escape\\echar\"");
        REQUIRE(out.size() >= 1);
        CHECK((static_cast<unsigned char>(out[0]) == 0x1B ||
               out.find(static_cast<char>(0x1B)) != std::string::npos));
        // trailing text present
        CHECK(out.find("char") != std::string::npos);
    }

    SECTION("Octal escapes: single, multi-digit and full examples") {
        // \0 -> NUL
        std::string o1 = unescape_string("\"\\0\"");
        CHECK(o1.size() == 1);
        CHECK(static_cast<unsigned char>(o1[0]) == 0);

        // \101 -> 'A' (65)
        std::string o2 = unescape_string("\"\\101\"");
        CHECK(o2.size() == 1);
        CHECK(static_cast<unsigned char>(o2[0]) == 65);

        // mixed text + octal
        std::string o3 = unescape_string("\"X\\101Y\"");
        CHECK(o3.size() == 3);
        CHECK(o3 == std::string("XAY"));
    }

    SECTION("Hex escapes: \\xNN and single hex digit") {
        std::string h1 = unescape_string("\"\\x41\"");
        CHECK(h1.size() == 1);
        CHECK(static_cast<unsigned char>(h1[0]) == 0x41); // 'A'

        std::string h2 = unescape_string("\"\\x0a\"");
        CHECK(h2.size() == 1);
        CHECK(static_cast<unsigned char>(h2[0]) == 0x0a); // newline

        // single hex digit (treated as value 0x4)
        std::string h3 = unescape_string("\"\\x4\"");
        CHECK(h3.size() == 1);
        CHECK(static_cast<unsigned char>(h3[0]) == 0x04);
    }

    SECTION("Unknown escape sequence treated as literal escaped char") {
        CHECK(unescape_string("\"\\q\"") == std::string("q"));
        CHECK(unescape_string("\\q") == std::string("q"));
    }

    SECTION("Trailing backslash in unquoted input is retained as a backslash") {
        std::string s = "abc\\";
        std::string out = unescape_string(s);
        REQUIRE(out.size() == 4);
        CHECK(out.substr(0, 3) == "abc");
        CHECK(out[3] == '\\');
    }

    SECTION("Quoted string with escaped backslash before closing quote") {
        // C++ literal: "\"endslash\\\""
        std::string in = "\"endslash\\\\\"\""; // represents "endslash\""
        // This is a tricky case; ensure function handles escapes and quotes correctly.
        // Build simpler: a quoted string containing a trailing backslash character before closing
        std::string in2 = "\"endslash\\\\\"";
        std::string out2 = unescape_string(in2);
        // out2 should be: endslash\  (single backslash at end)
        REQUIRE(!out2.empty());
        CHECK(out2.size() == 9);
        CHECK(out2.substr(0, 8) == "endslash");
        CHECK(out2.back() == '\\');
    }

    SECTION("Mixed content: unquoted plus hex and octal together") {
        std::string out = unescape_string("A\\x41\\101B");
        // A \x41 -> A A ; \101 -> 'A' ; so result "AAA B"? Let's inspect:
        // "A" + 0x41('A') + octal 101 ('A') + 'B' => "AAAB"
        CHECK(out == std::string("AAAB"));
    }
}

// Additional tests for scan_label
TEST_CASE("scan_label extracts labels with various forms and leaves pointer correctly",
          "[scan_label]") {
    std::string out;

    SECTION("Simple identifier label") {
        const char* p = "start";
        REQUIRE(scan_label(p, out));
        CHECK(out == "start");
        CHECK(*p == '\0');
    }

    SECTION("Identifier followed by colon leaves pointer at colon") {
        const char* p = "start: LD A,1";
        REQUIRE(scan_label(p, out));
        CHECK(out == "start");
        CHECK(*p == ':'); // caller can detect ':' delim and split later
    }

    SECTION("Label with leading @ prefix") {
        const char* p = "@global";
        REQUIRE(scan_label(p, out));
        CHECK(out == "@global");
        CHECK(*p == '\0');
    }

    SECTION("Label with @ and intervening whitespace") {
        const char* p = "@ global";
        REQUIRE(scan_label(p, out));
        CHECK(out == "@global");
        CHECK(*p == '\0');
    }

    SECTION("Qualified label name with '@' in middle (module@label)") {
        const char* p = "mod@lab rest";
        REQUIRE(scan_label(p, out));
        CHECK(out == "mod@lab");
        CHECK(*p == ' '); // pointer should stop at the separator before next token
    }

    SECTION("Dangling '@' after identifier reverts and leaves pointer at '@'") {
        const char* p = "foo@";
        REQUIRE(scan_label(p, out));
        CHECK(out == "foo");
        CHECK(*p == '@'); // scan_label rewinds to start2 when second ident is missing
    }

    SECTION("Non-identifier at start fails and does not advance pointer") {
        const char* p = "123abc";
        const char* before = p;
        REQUIRE_FALSE(scan_label(p, out));
        CHECK(p == before);
        CHECK(*p == '1');
    }

    SECTION("Identifier containing trailing quote and qualified with '@'") {
        const char* p = "af'@inner";
        REQUIRE(scan_label(p, out));
        CHECK(out == "af'@inner");
        CHECK(*p == '\0');
    }

    SECTION("Identifier with surrounding whitespace is accepted") {
        const char* p = "   lbl123   ";
        REQUIRE(scan_label(p, out));
        CHECK(out == "lbl123");
        // After parsing label, pointer will point at terminating NUL (since input only had spaces)
        // but scan_label does not skip trailing whitespace after the identifier, so it's okay if pointer
        // points at whitespace; check that next non-space is '\0'
        const char* q = p;
        while (*q && std::isspace(static_cast<unsigned char>(*q))) {
            ++q;
        }
        // q now at 'l'
        // Advance past label using original scan logic to confirm behavior
        const char* pp = "   lbl123   ";
        REQUIRE(scan_label(pp, out));
        // After parsing, pp points at the whitespace after the identifier
        CHECK(std::isspace(static_cast<unsigned char>(*pp)));
    }
}
