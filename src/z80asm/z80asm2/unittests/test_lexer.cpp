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
