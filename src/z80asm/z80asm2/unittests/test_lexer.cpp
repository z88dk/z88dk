//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "catch_amalgamated.hpp"
#include "../lexer.h"
#include "../token.h"
#include <sstream>
#include <string>

TEST_CASE("to_upper converts strings to uppercase", "[to_upper]") {
    REQUIRE(to_upper("abc") == "ABC");
    REQUIRE(to_upper("AbC123") == "ABC123");
    REQUIRE(to_upper("already UPPER") == "ALREADY UPPER");
    REQUIRE(to_upper("") == "");
    REQUIRE(to_upper("!@#") == "!@#");
}

TEST_CASE("ltrim removes leading whitespace", "[ltrim]") {
    REQUIRE(ltrim("   abc") == "abc");
    REQUIRE(ltrim("\t\txyz") == "xyz");
    REQUIRE(ltrim("  \t  test  ") == "test  ");
    REQUIRE(ltrim("") == "");
    REQUIRE(ltrim("nochange") == "nochange");
}

TEST_CASE("rtrim removes trailing whitespace", "[rtrim]") {
    REQUIRE(rtrim("abc   ") == "abc");
    REQUIRE(rtrim("xyz\t\t") == "xyz");
    REQUIRE(rtrim("  test  \t  ") == "  test");
    REQUIRE(rtrim("") == "");
    REQUIRE(rtrim("nochange") == "nochange");
}

TEST_CASE("to_keyword converts strings to Keyword enum", "[to_keyword]") {
    REQUIRE(to_keyword("LD") == Keyword::LD);
    REQUIRE(to_keyword("ld") == Keyword::LD);
    REQUIRE(to_keyword("Ld") == Keyword::LD);
    REQUIRE(to_keyword("AF") == Keyword::AF);
    REQUIRE(to_keyword("af") == Keyword::AF);
    REQUIRE(to_keyword("Af") == Keyword::AF);
    REQUIRE(to_keyword("AF'") == Keyword::AF_);
    REQUIRE(to_keyword("af'") == Keyword::AF_);
    REQUIRE(to_keyword("Af'") == Keyword::AF_);
    REQUIRE(to_keyword("NONEXISTENT") == Keyword::None);
    REQUIRE(to_keyword("") == Keyword::None);
}

TEST_CASE("scan_identifier extracts valid identifiers", "[read_identifier]") {
    std::string out;

    SECTION("Simple identifier") {
        std::istringstream is("foo");
        REQUIRE(scan_identifier(is, out));
        CHECK(out == "foo");
        CHECK(is.peek() == EOF);
    }

    SECTION("Identifier with quote") {
        std::istringstream is("af'");
        REQUIRE(scan_identifier(is, out));
        CHECK(out == "af'");
        CHECK(is.peek() == EOF);
    }

    SECTION("Identifier without quote") {
        std::istringstream is("define'");
        REQUIRE(scan_identifier(is, out));
        CHECK(out == "define");
        CHECK(is.peek() == '\'');
    }

    SECTION("Identifier with digits and underscores") {
        std::istringstream is("_bar123 rest");
        REQUIRE(scan_identifier(is, out));
        CHECK(out == "_bar123");
        char next = static_cast<char>(is.get());
        CHECK(next == ' ');
    }

    SECTION("Identifier at start of stream") {
        std::istringstream is("abc123");
        REQUIRE(scan_identifier(is, out));
        CHECK(out == "abc123");
    }

    SECTION("No identifier at start") {
        std::istringstream is(" 123abc");
        REQUIRE_FALSE(scan_identifier(is, out));
    }

    SECTION("Empty input") {
        std::istringstream is("");
        REQUIRE_FALSE(scan_identifier(is, out));
    }

    SECTION("Identifier followed by punctuation") {
        std::istringstream is("foo_bar;next");
        REQUIRE(scan_identifier(is, out));
        CHECK(out == "foo_bar");
        char next = static_cast<char>(is.get());
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
    CHECK(tokens[2].type == MacroTokenType::CharLiteral);
    CHECK(tokens[2].text == "'a'");
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
