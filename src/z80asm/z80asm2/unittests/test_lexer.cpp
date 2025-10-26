//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../keywords.h"
#include "../lexer.h"
#include "catch_amalgamated.hpp"
#include <string>

TEST_CASE("TokensLine basic operations", "[lexer]") {
    TokensLine line;
    REQUIRE(line.empty());

    line.push_back(Token(TokenType::Identifier, "foo"));
    line.push_back(Token(TokenType::Integer, "123"));

    REQUIRE_FALSE(line.empty());
    REQUIRE(line.size() == 2);

    const auto& toks = line.tokens();
    REQUIRE(toks.size() == 2);
    REQUIRE(toks[0].text() == "foo");
    REQUIRE(toks[1].text() == "123");

    // to_string concatenates original token texts
    REQUIRE(line.to_string() == "foo123");

    const Token& last = line.back();
    REQUIRE(last.text() == "123");
}

TEST_CASE("TokensFile from string, counts and bounds", "[lexer]") {
    const std::string content = "one\ntwo\n\nthree";
    TokensFile tf(content, "virtual", 10);

    // text line splitting
    REQUIRE(tf.line_count() == 4);
    REQUIRE(tf.get_line(0) == "one");
    REQUIRE(tf.get_line(1) == "two");
    REQUIRE(tf.get_line(2) == "");
    REQUIRE(tf.get_line(3) == "three");
    REQUIRE(tf.get_line(99) == ""); // out-of-range returns empty string

    // virtual file constructor should disable line number increments
    REQUIRE(tf.filename() == "virtual");
    REQUIRE(tf.first_line_num() == 10);
    REQUIRE(tf.inc_line_nums() == false);

    // tok_lines_count should count only non-empty tokenized lines
    REQUIRE(tf.tok_lines_count() == 3);

    // get_tok_line bounds
    REQUIRE(tf.get_tok_line(-1).empty());
    REQUIRE(tf.get_tok_line(999).empty());

    // each non-empty tokenized line should have a location set to first_line_num (virtual file)
    for (int i = 0; i < tf.tok_lines_count(); ++i) {
        const TokensLine& tl = tf.get_tok_line(i);
        REQUIRE(tl.location().line_num() == 10);
        REQUIRE(!tl.empty());
        const auto& tks = tl.tokens();
        REQUIRE(tks.size() >= 1);
    }
}

TEST_CASE("split_lines handles CRLF and LF mixed endings", "[lexer]") {
    const std::string content = "a\r\nb\nc\r\n";
    TokensFile tf(content, "virtual2", 1);
    REQUIRE(tf.line_count() == 3);
    REQUIRE(tf.get_line(0) == "a");
    REQUIRE(tf.get_line(1) == "b");
    REQUIRE(tf.get_line(2) == "c");
}

TEST_CASE("empty content produces no token lines", "[lexer]") {
    const std::string content = "\n\r\n\n"; // only empty lines
    TokensFile tf(content, "empty", 1);
    REQUIRE(tf.line_count() == 3);
    REQUIRE(tf.tok_lines_count() == 0);
}

