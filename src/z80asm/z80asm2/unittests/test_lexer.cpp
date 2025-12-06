//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../keywords.h"
#include "../lexer.h"
#include "../options.h"
#include "catch_amalgamated.hpp"
#include <algorithm>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <set>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

// test_lexer.cpp helpers
std::string create_temp_file(const std::string& name,
                             const std::string& content) {
    auto temp_dir = std::filesystem::temp_directory_path();
    auto file_path = temp_dir / name;

    std::ofstream out(file_path);
    out << content;
    out.close();

    return file_path.string();
}

void write_file(const std::string& path, const std::string& content) {
    std::ofstream out(path);
    out << content;
}

TEST_CASE("TokenLine basic operations", "[lexer]") {
    g_options = Options();

    TokenLine line;
    REQUIRE(line.tokens().empty());

    line.tokens().push_back(Token(TokenType::Identifier, "foo", false));
    line.tokens().push_back(Token(TokenType::Integer, "123", false));

    REQUIRE_FALSE(line.tokens().empty());
    REQUIRE(line.tokens().size() == 2);

    const auto& toks = line.tokens();
    REQUIRE(toks.size() == 2);
    REQUIRE(toks[0].text() == "foo");
    REQUIRE(toks[1].text() == "123");

    // to_string concatenates original token texts, inseritng spaces where needed
    REQUIRE(line.to_string() == "foo 123");

    const Token& last = line.tokens().back();
    REQUIRE(last.text() == "123");
}

// New test: verify that creating an Identifier token sets the keyword attribute
TEST_CASE("Token constructor sets keyword for identifiers",
          "[lexer][token][keyword]") {
    g_options = Options();

    // Known keyword should map to corresponding Keyword enum (DEFINE)
    Token t_define(TokenType::Identifier, "DEFINE", false);
    REQUIRE(t_define.is(Keyword::DEFINE));
    REQUIRE(t_define.keyword() == Keyword::DEFINE);

    Token t_define2(TokenType::Identifier, "define", false);
    REQUIRE(t_define2.is(Keyword::DEFINE));
    REQUIRE(t_define2.keyword() == Keyword::DEFINE);

    // Non-keyword identifier should map to Keyword::None
    Token t_custom(TokenType::Identifier, "myIdentifier", false);
    REQUIRE(t_custom.is(Keyword::None));
    REQUIRE(t_custom.keyword() == Keyword::None);

    // Case-insensitive mapping: when options cause uppercasing, keyword mapping still works.
    g_options = Options();
    g_options.ucase_labels = true;
    Token t_ucase(TokenType::Identifier, "define", false); // lowercase input
    REQUIRE(t_ucase.keyword() == Keyword::DEFINE);
    // restore options
    g_options = Options();
}

TEST_CASE("TokensFile from string, counts and bounds", "[lexer]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("virtual", "one\ntwo\n\nthree");
    tfr.set_fixed_line_number(10);

    REQUIRE(tfr.filename() == "virtual");
    REQUIRE(tfr.line_number() == 10);

    // each non-empty tokenized line should have a location set to first_line_num (virtual file)
    TokenLine tl;
    int count_lines = 0;
    while (tfr.next_token_line(tl)) {
        REQUIRE(tl.location().line_num() == 10);
        REQUIRE(!tl.tokens().empty());
        const auto& tks = tl.tokens();
        REQUIRE(tks.size() >= 1);
        ++count_lines;
    }
    REQUIRE(count_lines == 3); // 3 non-empty lines
}

TEST_CASE("split_lines handles CRLF and LF mixed endings", "[lexer]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("virtual2", "a\r\nb\nc\r\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].text() == "a");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].text() == "b");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].text() == "c");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("empty content produces no token lines", "[lexer]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("empty", "\n\r\n\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("TokensFile tokenizes all TokenType values", "[lexer][token_types]") {
    g_options = Options();

    // Build a single line that contains examples of each token type (except EndOfLine).
    // Note: backslash is included as a standalone token; whitespace is produced between tokens.

    TokenFileReader tfr;
    tfr.inject("types_test", "id 123 1.23 \"str\" + , . ( ) [ ] { }\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    // Collect seen token types
    std::set<TokenType> seen;
    for (const auto& t : toks) {
        seen.insert(t.type());
    }

    // Expected token types (exclude EndOfLine)
    std::vector<TokenType> expected = {
        TokenType::Identifier,
        TokenType::Integer,
        TokenType::Float,
        TokenType::String,
        TokenType::Comma,
        TokenType::Dot,
        TokenType::LeftParen,
        TokenType::RightParen,
        TokenType::LeftBracket,
        TokenType::RightBracket,
        TokenType::LeftBrace,
        TokenType::RightBrace,
    };

    for (auto et : expected) {
        REQUIRE(seen.count(et) > 0);
    }

    // Additional spot checks
    bool foundStr = false;
    bool foundInt = false;
    bool foundFloat = false;
    for (const auto& t : toks) {
        if (t.is(TokenType::String) && t.string_value() == "str") {
            foundStr = true;
        }
        if (t.is(TokenType::Integer) && t.int_value() == 123) {
            foundInt = true;
        }
        if (t.is(TokenType::Float) && t.float_value() != 0.0) {
            foundFloat = true;
        }
    }
    REQUIRE(foundStr);
    REQUIRE(foundInt);
    REQUIRE(foundFloat);

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("TokensFile tokenizes all TokenType values",
          "[lexer][operator_types]") {
    g_options = Options();

    // Construct one line that includes representative symbols for operator tokens.
    // Some operator tokens are multi-character and must be contiguous (e.g. '!=', '<<', '^^', '**', '##').
    TokenFileReader tfr;
    tfr.inject("op_test",
               "! != ~ ^ ^^ & && * ** / % + - << >> < <= > >= = ? # ## | ||\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    // Collect operator token TokenType values in the order they appear.
    std::vector<TokenType> seen;
    for (const auto& t : toks) {
        seen.push_back(t.type());
    }

    std::vector<TokenType> expected = {
        TokenType::LogicalNot,   // "!"
        TokenType::NE,           // "!="
        TokenType::BitwiseNot,   // "~"
        TokenType::BitwiseXor,   // "^" (single)
        TokenType::LogicalXor,   // "^^"
        TokenType::BitwiseAnd,   // "&"
        TokenType::LogicalAnd,   // "&&"
        TokenType::Multiply,     // "*"
        TokenType::Power,        // "**"
        TokenType::Divide,       // "/"
        TokenType::Modulo,       // "%"
        TokenType::Plus,         // "+"
        TokenType::Minus,        // "-"
        TokenType::LeftShift,    // "<<"
        TokenType::RightShift,   // ">>"
        TokenType::LT,           // "<"
        TokenType::LE,           // "<="
        TokenType::GT,           // ">"
        TokenType::GE,           // ">="
        TokenType::EQ,           // "="
        TokenType::Question,     // "?"
        TokenType::Hash,         // "#"
        TokenType::DoubleHash,   // "##"
        TokenType::BitwiseOr,    // "|"
        TokenType::LogicalOr     // "||"
    };

    REQUIRE(seen.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(seen[i] == expected[i]);
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

//
// New tests: verify comment removal for ';', '//' and '/* */'
//

TEST_CASE("Lexer removes semicolon comments (';') from input",
          "[lexer][comments]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("comment_semicolon", "mov a, b ; this is a comment\nnext\n");
    tfr.set_fixed_line_number(1);

    // Two non-empty tokenized lines: first with "mov a, b", second with "next"
    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "mov a, b");

    // Second line should contain 'next'
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "next");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Lexer removes double-slash comments ('//') from input",
          "[lexer][comments]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("comment_double_slash", "ld bc, 0 // set bc to zero\nnext\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "ld bc, 0");

    // Second line should contain 'next'
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "next");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Lexer removes C-style multi-line comments ('/* */') across lines",
          "[lexer][comments]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("comment_c_style", "ld a, /* multi\nline\ncomment */ b\nnext\n");
    tfr.set_fixed_line_number(1);

    // The tokenizer removes the comment; resulting token line should contain 'a' and 'b'
    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "ld a, b");

    // Second line should contain 'next'
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "next");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

//
// New test: verify integer literal formats accepted by scan.re are parsed correctly
//

TEST_CASE("TokensFile parses all integer literal formats",
          "[lexer][integers]") {
    g_options = Options();

    // Include examples of all integer formats handled by the lexer:
    // - decimal: 123
    // - decimal with trailing 'd': 123d
    // - hex with trailing 'h': 1Ah
    // - hex with '$' prefix: $FF
    // - hex with '0x' prefix: 0xAB
    // - binary with trailing 'b': 1011b
    // - binary with '%' prefix: %1011
    // - binary with '@' prefix: @1011
    // - binary with '0b' prefix: 0b1011
    TokenFileReader tfr;
    tfr.inject("int_formats",
               "123 123d 1Ah 1aH $FF 0xAB 1011b %1011 @1011 0b1011\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    std::vector<int> found;
    for (const auto& t : toks) {
        REQUIRE(t.type() == TokenType::Integer);
        found.push_back(t.int_value());
    }

    std::vector<int> expected = {
        123,      // "123"
        123,      // "123d"
        0x1A,     // "1Ah"
        0x1A,     // "1aH"
        0xFF,     // "$FF"
        0xAB,     // "0xAB"
        11,       // "1011b"
        11,       // "%1011"
        11,       // "@1011"
        11        // "0b1011"
    };

    REQUIRE(found.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(found[i] == expected[i]);
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Single-quoted characters returned as Integer", "[lexer][char]") {
    g_options = Options();

    // Lines:
    // 'A'    -> ASCII 65
    // '\n'   -> newline (10)
    // '\t'   -> tab (9)

    TokenFileReader tfr;
    tfr.inject("char_test", "'A'\n'\\n'\n'\\t'\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].is(TokenType::Integer));
    REQUIRE(tl.tokens()[0].int_value() == static_cast<int>('A'));
    REQUIRE(tl.tokens()[0].text() == "'A'");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].is(TokenType::Integer));
    REQUIRE(tl.tokens()[0].int_value() == static_cast<int>('\n'));
    REQUIRE(tl.tokens()[0].text() == "'\\n'");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].is(TokenType::Integer));
    REQUIRE(tl.tokens()[0].int_value() == static_cast<int>('\t'));
    REQUIRE(tl.tokens()[0].text() == "'\\t'");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

//
// New tests: verify invalid single-quoted character forms produce errors
//

TEST_CASE("Single-quoted empty and multi-character literals produce Invalid quoted character error",
          "[lexer][char][error]") {
    g_options = Options();

    SuppressErrors suppress;

    // Empty quoted character: ''  -> should trigger Invalid quoted character
    TokenFileReader tfr;
    tfr.inject("char_err_empty", "''\n");
    tfr.set_line_number(1);

    // Tokenization should fail and produce no token lines
    TokenLine tl;
    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
    REQUIRE(g_errors.has_errors());
    {
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid quoted character") != std::string::npos);
        REQUIRE(msg.find("''") != std::string::npos);
        REQUIRE(msg.find("char_err_empty:1:") != std::string::npos);
    }

    // Reset errors before next case
    SuppressErrors suppress2;

    // Multi-character quoted literal: 'AB' -> should trigger Invalid quoted character
    tfr.inject("char_err_multi", "'AB'\n");
    tfr.set_line_number(1);

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
    REQUIRE(g_errors.has_errors());
    {
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid quoted character") != std::string::npos);
        REQUIRE(msg.find("'AB'") != std::string::npos);
        REQUIRE(msg.find("char_err_multi:1:") != std::string::npos);
    }
}

//
// New tests: verify keywords with trailing quote and quoted-char-after-keyword behavior
//

TEST_CASE("Keyword token that includes a trailing quote is recognized as keyword",
          "[lexer][keywords][quote]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("kw_quote_test", "AF'\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 1);

    // Should produce a single identifier token which maps to Keyword::AF_
    REQUIRE(tl.tokens().size() == 1);
    REQUIRE(tl.tokens()[0].is(TokenType::Identifier));
    REQUIRE(tl.tokens()[0].is(Keyword::AF_));
    REQUIRE(tl.tokens()[0].text() == "AF'");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Trailing quote after a keyword starts a character constant (DEFINE'a')",
          "[lexer][keywords][quote_char]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("kw_then_char", "DEFINE'a'\n");

    tfr.set_fixed_line_number(1);

    // One tokenized line
    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    // Expect two tokens: the keyword DEFINE (no trailing quote) and the character constant as Integer
    REQUIRE(tl.tokens().size() == 2);

    // First token: keyword DEFINE
    REQUIRE(tl.tokens()[0].is(TokenType::Identifier));
    REQUIRE(tl.tokens()[0].is(Keyword::DEFINE));
    REQUIRE(tl.tokens()[0].text() == "DEFINE");

    // Second token: character constant -> Integer token with value 'a'
    REQUIRE(tl.tokens()[1].is(TokenType::Integer));
    REQUIRE(tl.tokens()[1].int_value() == static_cast<int>('a'));
    REQUIRE(tl.tokens()[1].text() == "'a'");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

//
// New tests: unterminated comments/strings should be reported as errors
//

TEST_CASE("Unterminated C-style comment reports error",
          "[lexer][error][comment]") {
    g_options = Options();

    SuppressErrors suppress;

    TokenFileReader tfr;
    tfr.inject("unclosed_comment", "code /* unclosed\nmulti\nline\ncomment\n");
    tfr.set_fixed_line_number(1);

    // Tokenization should fail and produce no token lines
    TokenLine tl;
    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unterminated comment") != std::string::npos);
    REQUIRE(msg.find("unclosed_comment:1:") != std::string::npos);
}

TEST_CASE("Unterminated double-quoted string reports error",
          "[lexer][error][string]") {
    g_options = Options();

    SuppressErrors suppress;

    TokenFileReader tfr;
    tfr.inject("unclosed_dquote", "db \"unterminated\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unterminated string") != std::string::npos);
    REQUIRE(msg.find("unclosed_dquote:1:") != std::string::npos);
}

TEST_CASE("Unterminated single-quoted string reports error",
          "[lexer][error][string]") {
    g_options = Options();

    SuppressErrors suppress;

    TokenFileReader tfr;
    tfr.inject("unclosed_squote", "db 'u\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unterminated string") != std::string::npos);
    REQUIRE(msg.find("unclosed_squote:1:") != std::string::npos);
}

// New test: verify identifiers are upper-cased when g_options.ucase_labels == true
TEST_CASE("g_options.ucase_labels causes identifiers to be upper-cased",
          "[lexer][ucase]") {
    g_options = Options();
    g_options.ucase_labels = true;

    TokenFileReader tfr;
    tfr.inject("ucase_test", "foo bar Baz qux123\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    std::vector<std::string> ids;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Identifier));
        ids.push_back(t.text());
    }

    std::vector<std::string> expected = { "FOO", "BAR", "BAZ", "QUX123" };
    REQUIRE(ids == expected);

    // Also verify that keywords are upper-cased and mapped to Keyword enum
    g_options = Options();
    g_options.ucase_labels = true;

    tfr.inject("ucase_kw", "ld a, 0\n");
    tfr.set_fixed_line_number(1);

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().size() == 4);
    REQUIRE(tl.tokens()[0].text() == "LD");
    REQUIRE(tl.tokens()[0].keyword() == Keyword::LD);
    REQUIRE(tl.tokens()[1].text() == "A");
    REQUIRE(tl.tokens()[1].keyword() == Keyword::A);
    REQUIRE(tl.tokens()[2].text() == ",");
    REQUIRE(tl.tokens()[2].type() == TokenType::Comma);
    REQUIRE(tl.tokens()[3].text() == "0");
    REQUIRE(tl.tokens()[3].type() == TokenType::Integer);
    REQUIRE(tl.tokens()[3].int_value() == 0);

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());

    // restore options
    g_options = Options();
}

// New tests: verify swap IX<->IY behavior
TEST_CASE("g_options.swap_ix_iy swaps IX/IY keywords and token text",
          "[lexer][swap_ix_iy]") {
    // Prepare the input containing a variety of IX/IY related keywords
    const std::string content =
        "IX IXH IXL IY IYH IYL "
        "AIX AIY PIX PIY "
        "XIX XIY YIX YIY "
        "ZIX ZIY\n";

    // --- Case 1: swap disabled (default) ---
    g_options = Options(); // reset global options

    TokenFileReader tfr;
    tfr.inject("swap_test", content);
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    std::vector<std::string> ids_off;
    std::vector<Keyword> kws_off;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Identifier));
        ids_off.push_back(t.text());
        kws_off.push_back(t.keyword());
    }

    std::vector<std::string> expected_ids_off = {
        "IX", "IXH", "IXL", "IY", "IYH", "IYL",
        "AIX", "AIY", "PIX", "PIY",
        "XIX", "XIY", "YIX", "YIY",
        "ZIX", "ZIY"
    };
    std::vector<Keyword> expected_kws_off = {
        Keyword::IX, Keyword::IXH, Keyword::IXL, Keyword::IY, Keyword::IYH, Keyword::IYL,
        Keyword::AIX, Keyword::AIY, Keyword::PIX, Keyword::PIY,
        Keyword::XIX, Keyword::XIY, Keyword::YIX, Keyword::YIY,
        Keyword::ZIX, Keyword::ZIY
    };

    REQUIRE(ids_off.size() == expected_ids_off.size());
    for (size_t i = 0; i < expected_ids_off.size(); ++i) {
        REQUIRE(ids_off[i] == expected_ids_off[i]);
    }
    REQUIRE(kws_off.size() == expected_kws_off.size());
    for (size_t i = 0; i < expected_kws_off.size(); ++i) {
        REQUIRE(kws_off[i] == expected_kws_off[i]);
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());

    // --- Case 2: swap enabled ---
    g_options = Options();
    g_options.swap_ix_iy = true;

    tfr.inject("swap_test", content);
    tfr.set_fixed_line_number(1);

    REQUIRE(tfr.next_token_line(tl));

    std::vector<std::string> ids_on;
    std::vector<Keyword> kws_on;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Identifier));
        ids_on.push_back(t.text());
        kws_on.push_back(t.keyword());
    }

    // Expected names after swapping x<->y
    std::vector<std::string> expected_ids_on = {
        "IY", "IYH", "IYL", "IX", "IXH", "IXL",
        "AIY", "AIX", "PIY", "PIX",
        "YIY", "YIX", "XIY", "XIX",
        "ZIY", "ZIX"
    };
    std::vector<Keyword> expected_kws_on = {
        Keyword::IY, Keyword::IYH, Keyword::IYL, Keyword::IX, Keyword::IXH, Keyword::IXL,
        Keyword::AIY, Keyword::AIX, Keyword::PIY, Keyword::PIX,
        Keyword::YIY, Keyword::YIX, Keyword::XIY, Keyword::XIX,
        Keyword::ZIY, Keyword::ZIX
    };

    REQUIRE(ids_on.size() == expected_ids_on.size());
    for (size_t i = 0; i < expected_ids_on.size(); ++i) {
        REQUIRE(ids_on[i] == expected_ids_on[i]);
    }
    REQUIRE(kws_on.size() == expected_kws_on.size());
    for (size_t i = 0; i < expected_kws_on.size(); ++i) {
        REQUIRE(kws_on[i] == expected_kws_on[i]);
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());

    // restore options
    g_options = Options();
}

// -----------------------------------------------------------------------------
// Added tests: to_string preserving whitespace,
// get_tok_line out-of-range behavior, spacing rules for to_string, and
// operator-pair spacing tests.
// -----------------------------------------------------------------------------

TEST_CASE("TokenLine to_string preserves original token text including whitespace",
          "[lexer][tokensline][to_string]") {
    g_options = Options();

    TokenLine tl(Location("l", 1));
    tl.tokens().push_back(Token(TokenType::Identifier, "mov", true));
    tl.tokens().push_back(Token(TokenType::Identifier, "a", false));
    tl.tokens().push_back(Token(TokenType::Comma, ",", true));
    tl.tokens().push_back(Token(TokenType::Identifier, "b", false));

    REQUIRE(tl.to_string() == "mov a, b");
}

// New tests: verify that to_string inserts spaces between Identifier/Integer/Float
TEST_CASE("TokenLine to_string inserts spaces between Identifier, Integer and Float tokens",
          "[lexer][tokensline][to_string_spacing]") {
    g_options = Options();

    // Identifier followed by Integer
    TokenLine tl_id_int(Location("l", 1));
    tl_id_int.tokens().push_back(Token(TokenType::Identifier, "foo", false));
    tl_id_int.tokens().push_back(Token(TokenType::Integer, "123", false));
    REQUIRE(tl_id_int.to_string() == "foo 123");

    // Identifier followed by Float
    TokenLine tl_id_float(Location("l", 2));
    tl_id_float.tokens().push_back(Token(TokenType::Identifier, "foo", false));
    tl_id_float.tokens().push_back(Token(TokenType::Float, "1.23", false));
    REQUIRE(tl_id_float.to_string() == "foo 1.23");

    // Integer followed by Identifier
    TokenLine tl_int_id(Location("l", 3));
    tl_int_id.tokens().push_back(Token(TokenType::Integer, "123", false));
    tl_int_id.tokens().push_back(Token(TokenType::Identifier, "bar", false));
    REQUIRE(tl_int_id.to_string() == "123 bar");

    // Integer followed by Float
    TokenLine tl_int_float(Location("l", 4));
    tl_int_float.tokens().push_back(Token(TokenType::Integer, "123", false));
    tl_int_float.tokens().push_back(Token(TokenType::Float, "1.23", false));
    REQUIRE(tl_int_float.to_string() == "123 1.23");

    // Float followed by Identifier
    TokenLine tl_float_id(Location("l", 5));
    tl_float_id.tokens().push_back(Token(TokenType::Float, "1.23", false));
    tl_float_id.tokens().push_back(Token(TokenType::Identifier, "x", false));
    REQUIRE(tl_float_id.to_string() == "1.23 x");

    // Mixed with non-identifier/number tokens should not insert extra spaces beyond token text
    TokenLine tl_mixed(Location("l", 6));
    tl_mixed.tokens().push_back(Token(TokenType::Identifier, "mov", false));
    tl_mixed.tokens().push_back(Token(TokenType::LeftParen, "(", false));
    tl_mixed.tokens().push_back(Token(TokenType::Integer, "1", false));
    tl_mixed.tokens().push_back(Token(TokenType::RightParen, ")", false));
    // Expect "mov(1)" if no whitespace tokens were present in original tokens
    REQUIRE(tl_mixed.to_string() == "mov(1)");
}

// New tests: verify that to_string inserts spaces between tokens that would combine
// into multi-character operator tokens when concatenated.
TEST_CASE("TokenLine to_string inserts spaces between tokens that form multi-char operators",
          "[lexer][tokensline][to_string_op_spacing]") {
    g_options = Options();

    struct Pair {
        TokenType a;
        const char* ta;
        TokenType b;
        const char* tb;
    };
    std::vector<Pair> pairs = {
        { TokenType::LT, "<", TokenType::LT, "<" },          // "<" + "<" -> "<<"
        { TokenType::GT, ">", TokenType::GT, ">" },          // ">" + ">" -> ">>"
        { TokenType::LT, "<", TokenType::EQ, "=" },          // "<" + "=" -> "<="
        { TokenType::GT, ">", TokenType::EQ, "=" },          // ">" + "=" -> ">="
        { TokenType::LogicalNot, "!", TokenType::EQ, "=" },  // "!" + "=" -> "!="
        { TokenType::BitwiseAnd, "&", TokenType::BitwiseAnd, "&" }, // "&" + "&" -> "&&"
        { TokenType::BitwiseOr, "|", TokenType::BitwiseOr, "|" },   // "|" + "|" -> "||"
        { TokenType::BitwiseXor, "^", TokenType::BitwiseXor, "^" }, // "^" + "^" -> "^^"
        { TokenType::Multiply, "*", TokenType::Multiply, "*" },     // "*" + "*" -> "**"
        { TokenType::Hash, "#", TokenType::Hash, "#" },             // "#" + "#" -> "##"
        { TokenType::EQ, "=", TokenType::EQ, "=" },                 // "=" + "=" -> "=="
        { TokenType::LT, "<", TokenType::GT, ">" }                  // "<" + ">" -> "<>"
    };

    for (const auto& p : pairs) {
        TokenLine tl(Location("op", 1));
        tl.tokens().push_back(Token(p.a, p.ta, false));
        tl.tokens().push_back(Token(p.b, p.tb, false));
        std::string want = std::string(p.ta) + " " + std::string(p.tb);
        INFO("Checking pair: '" << p.ta << "' + '" << p.tb << "' -> to_string()");
        REQUIRE(tl.to_string() == want);
    }
}

// New tests: verify identifier forms '@ident', 'ident@ident' and 'ident' (C identifier rules)
TEST_CASE("Lexer detects identifiers '@ident', 'ident@ident' and 'ident'",
          "[lexer][ident]") {
    g_options = Options(); // default options (no upper-casing)

    // ident1 = [_a-zA-Z][_a-zA-Z0-9]*
    // ident  = '@' ident1 | ident1 '@' ident1 | ident1

    TokenFileReader tfr;
    tfr.inject("ident_forms", "@foo  _ok1@bar2  normal\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    std::vector<std::string> ids;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Identifier));
        ids.push_back(t.text());
    }

    std::vector<std::string> expected = {
        "@foo",       // '@' ident1
        "_ok1@bar2",  // ident1 '@' ident1
        "normal"      // ident1
    };

    REQUIRE(ids == expected);

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Lexer identifier forms allow underscores and digits after the first character",
          "[lexer][ident][chars]") {
    g_options = Options(); // default options

    // More thorough coverage of allowed characters within ident1

    TokenFileReader tfr;
    tfr.inject("ident_forms_chars", "@_AbC123  A_B@C9_d  Z9\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    std::vector<std::string> ids;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Identifier));
        ids.push_back(t.text());
    }

    std::vector<std::string> expected = {
        "@_AbC123",  // '@' + ident1 with underscores/digits allowed after first char
        "A_B@C9_d",  // ident1 '@' ident1
        "Z9"         // ident1
    };

    REQUIRE(ids == expected);

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

// New tests: verify all runs of any whitespace chars collapse
TEST_CASE("Lexer collapses mixed whitespace run",
          "[lexer][whitespace]") {
    g_options = Options();

    // Between A and B we place a contiguous run of space, tab, vertical-tab, form-feed, space

    TokenFileReader tfr;
    tfr.inject("ws_mixed", "\t\v\f A \t\v\f B \t\v\f \n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    REQUIRE(tl.tokens().size() == 2);
    REQUIRE(tl.tokens()[0].is(TokenType::Identifier));
    REQUIRE(tl.tokens()[0].text() == "A");
    REQUIRE(tl.tokens()[1].is(TokenType::Identifier));
    REQUIRE(tl.tokens()[1].text() == "B");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

// New tests: verify bitmask forms %"... and @ "..." are scanned into Integer with correct value
TEST_CASE("Lexer scans bitmask %\"-#-#\" and @\"-#-#\" into Integer tokens",
          "[lexer][bitmask]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("bitmask_basic", "%\"-#-#\" @\"-#-#\"\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    // Collect integer tokens
    std::vector<Token> ints;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Integer));
        ints.push_back(t);
    }

    // Expect two Integer tokens, both representing binary -#-# => 0101b => 5
    REQUIRE(ints.size() == 2);
    REQUIRE(ints[0].int_value() == 5);
    REQUIRE(ints[1].int_value() == 5);

    // Text should be preserved exactly (including leading %/@ and quotes)
    REQUIRE(ints[0].text() == "%\"-#-#\"");
    REQUIRE(ints[1].text() == "@\"-#-#\"");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Lexer bitmask handles empty and single-bit sequences",
          "[lexer][bitmask][edge]") {
    g_options = Options();

    // Empty -> 0, "#" -> 1, "-#" -> 1, "#-" -> 2

    TokenFileReader tfr;
    tfr.inject("bitmask_edges", "%\"\" %\"#\" %\"-#\" %\"#-\"\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));

    std::vector<int> values;
    std::vector<std::string> texts;
    for (const auto& t : tl.tokens()) {
        REQUIRE(t.is(TokenType::Integer));
        values.push_back(t.int_value());
        texts.push_back(t.text());
    }

    REQUIRE(values.size() == 4);
    REQUIRE(values[0] == 0); // %""    -> empty
    REQUIRE(values[1] == 1); // %"#"   -> 001b
    REQUIRE(values[2] == 1); // "%-#" -> 01b
    REQUIRE(values[3] == 2); // "%#-" -> 10b

    REQUIRE(texts[0] == "%\"\"");
    REQUIRE(texts[1] == "%\"#\"");
    REQUIRE(texts[2] == "%\"-#\"");
    REQUIRE(texts[3] == "%\"#-\"");

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

// New tests: verify underscores digit separators are ignored inside numeric literals
TEST_CASE("TokensFile parses integer literals with underscores as digit separators",
          "[lexer][integers][underscores]") {
    g_options = Options();

    // Include underscores in all supported integer formats:
    // - decimal with/without 'd'
    // - hex with trailing 'h' (both cases)
    // - hex with '$' and '0x' prefixes
    // - binary with trailing 'b', and '%' / '@' / '0b' prefixes
    const std::string content =
        "1_234 1_234d 1_234D 1A_2h 1a_2H $FF_FF 0xAB_CD 1010_1100b %1010_1100 @1010_1100 0b1010_1100\n";
    TokenFileReader tfr;
    tfr.inject("int_underscores", content);
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    std::vector<int> found;
    for (const auto& t : toks) {
        REQUIRE(t.type() == TokenType::Integer);
        found.push_back(t.int_value());
    }

    std::vector<int> expected = {
        1234,         // "1_234"
        1234,         // "1_234d"
        1234,         // "1_234D"
        0x1A2,        // "1A_2h"
        0x1A2,        // "1a_2H"
        0xFFFF,       // "$FF_FF"
        0xABCD,       // "0xAB_CD"
        0b10101100,   // "1010_1100b"
        0b10101100,   // "%1010_1100"
        0b10101100,   // "@1010_1100"
        0b10101100    // "0b1010_1100"
    };

    REQUIRE(found.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(found[i] == expected[i]);
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("Lexer parses floats with underscores in integer, fractional and exponent parts",
          "[lexer][float][underscores]") {
    g_options = Options();

    // Five floats:
    // 1) underscore in integer part: 1_234.5 -> 1234.5
    // 2) underscore in fractional part: 12.3_45 -> 12.345
    // 3) multiple underscores within fractional digits: 0.0_5 -> 0.05
    // 4) underscore in exponent: 1.25e1_2 -> 1.25e12
    // 5) underscore with negative exponent: 3.0e-0_3 -> 3.0e-3
    // 6) underscores in integer part and exponent: 4_2.0e0_0 -> 42.0

    TokenFileReader tfr;
    tfr.inject("float_underscores_if",
               "1_234.5 12.3_45 0.0_5 1.25e1_2 3.0e-0_3 4_2.0e0_0\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    std::vector<double> found;
    for (const auto& t : toks) {
        REQUIRE(t.is(TokenType::Float));
        found.push_back(t.float_value());
    }

    std::vector<double> expected = {
        1234.5,   // "1_234.5"
        12.345,   // "12.3_45"
        0.05,     // "0.0_5"
        1.25e12,  // "1.25e1_2"
        3.0e-3,   // "3.0e-0_3"
        42.0      // "4_2.0e0_0"
    };

    REQUIRE(found.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(found[i] == Catch::Approx(expected[i]).epsilon(1e-12));
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

// New tests: verify invalid digit sequences are rejected

TEST_CASE("Lexer rejects invalid underscore placements in integer/hex/binary literals",
          "[lexer][integers][underscores][invalid]") {
    g_options = Options();

    // Each case should trigger a lex error and produce no tokenized lines
    std::vector<std::string> cases = {
        "1_\n",         // decimal trailing underscore
        "123_d\n",      // underscore before optional 'd' suffix
        "$FF_\n",       // hex ($) with trailing underscore
        "0xAB__\n",     // hex (0x) with trailing underscores
        "1010_b\n",     // underscore before 'b' suffix
        "%1010_\n",     // prefixed binary with trailing underscore
        "@1010_\n",     // prefixed binary (@) with trailing underscore
        "0b1010_\n"     // 0b with trailing underscore
    };

    for (const auto& content : cases) {
        SuppressErrors suppress;
        TokenFileReader tfr;
        tfr.inject("invalid_num_underscores", content);
        tfr.set_fixed_line_number(1);

        TokenLine tl;
        REQUIRE_FALSE(tfr.next_token_line(tl));
        REQUIRE(tl.tokens().empty());
        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid character") != std::string::npos);
        REQUIRE(msg.find("invalid_num_underscores:1:") != std::string::npos);
    }
}

TEST_CASE("Lexer rejects invalid underscore placements in floats",
          "[lexer][float][underscores][invalid]") {
    g_options = Options();

    // Invalid placements around dot or exponent
    std::vector<std::string> cases = {
        "1_.2\n",     // underscore at end of integer part before '.'
        "1._2\n",     // underscore immediately after '.'
        ".1_\n",      // trailing underscore after fractional part
        "1._\n",      // underscore after '.' with no fractional digit
        "1.2e_3\n",   // underscore starts exponent digits
        "1.2e+_3\n"   // underscore immediately after exponent sign
    };

    for (const auto& content : cases) {
        SuppressErrors suppress;
        TokenFileReader tfr;
        tfr.inject("invalid_float_underscores", content);
        tfr.set_fixed_line_number(1);

        TokenLine tl;
        REQUIRE_FALSE(tfr.next_token_line(tl));
        REQUIRE(tl.tokens().empty());
        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid character") != std::string::npos);
        REQUIRE(msg.find("invalid_float_underscores:1:") != std::string::npos);
    }
}

// New tests: verify all supported floating-point formats (with and without exponent) parse correctly
TEST_CASE("Lexer parses canonical floating-point formats (mantissa with optional exponent)",
          "[lexer][float][canonical]") {
    g_options = Options();

    // Supported forms (a dot is required by the grammar):
    //  - dec+ '.' dec*        -> "123."      (fractional part optional)
    //  - dec* '.' dec+        -> ".789"      (integer part optional)
    //  - mantissa [eE][+-]?dec -> "1.e2", ".5E-2", "42.e+0"

    TokenFileReader tfr;
    tfr.inject("float_canonical", "123.456 123. .789 1.e2 .5E-2 42.e+0\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    std::vector<double> found;
    for (const auto& t : toks) {
        REQUIRE(t.is(TokenType::Float));
        found.push_back(t.float_value());
    }

    std::vector<double> expected = {
        123.456,   // "123.456"
        123.0,     // "123."
        0.789,     // ".789"
        100.0,     // "1.e2"
        0.005,     // ".5E-2"
        42.0       // "42.e+0"
    };

    REQUIRE(found.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(found[i] == Catch::Approx(expected[i]).epsilon(1e-12));
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

// New test: verify that a number immediately followed by letters is rejected (e.g., 123abc)
TEST_CASE("Lexer rejects numbers immediately followed by letters",
          "[lexer][invalid][trailing]") {
    g_options = Options();

    // Each case should trigger an error: "Invalid character"
    // Use forms across all numeric syntaxes to ensure consistent behavior.
    std::vector<std::string> cases = {
        "123abc\n",        // decimal + letters
        "12dxyz\n",        // decimal with optional 'd' then letters
        "1.23foo\n",       // float with letters
        "1.e2bar\n",       // float with exponent then letters
        "0x12ABxyz\n",     // hex 0x... then letters
        "$C0DExyz\n",      // hex $... then letters
        "1A2hBAD\n",       // hex with trailing 'h' then letters
        "1010bfoo\n",      // binary with trailing 'b' then letters
        "%1010bar\n",      // binary with % prefix then letters
        "@1010bar\n",      // binary with @ prefix then letters
        "0b1010bar\n"      // binary with 0b prefix then letters
    };

    for (const auto& content : cases) {
        SuppressErrors suppress;
        TokenFileReader tfr;
        tfr.inject("num_trailing_letters", content);
        tfr.set_fixed_line_number(1);

        TokenLine tl;
        REQUIRE_FALSE(tfr.next_token_line(tl));
        REQUIRE(tl.tokens().empty());
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid character") != std::string::npos);
        REQUIRE(msg.find("num_trailing_letters:1:") != std::string::npos);
    }
}

// New test: verify that 0x without following digits is rejected
TEST_CASE("Lexer rejects 0x prefix without digits",
          "[lexer][invalid][prefix]") {
    g_options = Options();

    struct Case {
        const char* text;
        const char* fname;
    } cases[] = {
        { "0x\n", "hex_prefix_no_digits" },
    };

    for (const auto& c : cases) {
        SuppressErrors suppress;
        TokenFileReader tfr;
        tfr.inject(c.fname, c.text);
        tfr.set_fixed_line_number(1);

        // Tokenization should fail and produce no token lines
        TokenLine tl;
        REQUIRE_FALSE(tfr.next_token_line(tl));
        REQUIRE(tl.tokens().empty());

        REQUIRE(g_errors.has_errors());
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid character") != std::string::npos);
        REQUIRE(msg.find(std::string(c.fname) + ":1:") != std::string::npos);
    }
}

// New test: verify that "0b" is accepted as a valid binary zero
TEST_CASE("Lexer accepts '0b' as binary zero",
          "[lexer][binary][zero]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("zero_0b", "0b\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    REQUIRE(toks.size() == 1);
    REQUIRE(toks[0].is(TokenType::Integer));
    REQUIRE(toks[0].int_value() == 0);
    REQUIRE(toks[0].text() == "0b");
}

// New tests: verify malformed floats (missing exponent digits, multiple signs, dangling e/E) are rejected
TEST_CASE("Lexer rejects malformed floats (missing exponent digits, multiple signs, dangling e/E)",
          "[lexer][float][invalid][malformed]") {
    g_options = Options();

    struct Case {
        const char* text;
        const char* fname;
    } cases[] = {
        { "1.e\n",          "malformed_float_1" },  // 'e' without digits
        { "1.e+\n",         "malformed_float_2" },  // 'e+' without digits
        { "1.e-\n",         "malformed_float_3" },  // 'e-' without digits
        { "1.23e\n",        "malformed_float_4" },  // missing exponent digits
        { ".5E\n",          "malformed_float_5" },  // missing exponent digits (uppercase E)
        { ".5E+\n",         "malformed_float_6" },  // sign but no digits
        { "1.2e++3\n",      "malformed_float_7" },  // multiple signs in exponent
        { "1.2e--3\n",      "malformed_float_8" },  // multiple signs in exponent
        { "1.2ee3\n",       "malformed_float_9" },  // double 'e'
        { "0.ee\n",         "malformed_float_10" }, // mantissa with '.' then dangling 'ee'
        { "0._e2\n",        "malformed_float_11" }  // underscore after '.' then 'e' (already invalid, ensure rejected)
    };

    for (const auto& c : cases) {
        SuppressErrors suppress;
        TokenFileReader tfr;
        tfr.inject(c.fname, c.text);
        tfr.set_fixed_line_number(1);

        // Tokenization should fail and produce no token lines
        TokenLine tl;
        REQUIRE_FALSE(tfr.next_token_line(tl));
        REQUIRE(tl.tokens().empty());

        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid character") != std::string::npos);
        REQUIRE(msg.find(std::string(c.fname) + ":1:") != std::string::npos);
    }
}

// New tests: verify single-quoted character constants are Integer and accept C-escapes plus \e
TEST_CASE("Single-quoted C escape sequences are converted to Integer (including \\e)",
          "[lexer][char][escapes]") {
    g_options = Options();

    struct Case {
        const char* line;     // one line input including newline
        int expected;         // expected integer value
        const char* text;     // expected token original text
    } cases[] = {
        { "'\\a'\n",   static_cast<int>('\a'), "'\\a'" },
        { "'\\b'\n",   static_cast<int>('\b'), "'\\b'" },
        { "'\\e'\n",   0x1B,                    "'\\e'" }, // non-standard C, supported by lexer
        { "'\\f'\n",   static_cast<int>('\f'), "'\\f'" },
        { "'\\n'\n",   static_cast<int>('\n'), "'\\n'" },
        { "'\\r'\n",   static_cast<int>('\r'), "'\\r'" },
        { "'\\t'\n",   static_cast<int>('\t'), "'\\t'" },
        { "'\\v'\n",   static_cast<int>('\v'), "'\\v'" },
        { "'\\\\'\n",  static_cast<int>('\\'), "'\\\\'" },
        { "'\\''\n",   static_cast<int>('\''), "'\\''" },
        { "'\"'\n",    static_cast<int>('\"'), "'\"'"   }, // double-quote does not require escaping
        { "'\\\"'\n",  static_cast<int>('\"'), "'\\\"'" }  // escaped double-quote also accepted
    };

    // Build a multi-line content string
    std::string content;
    for (const auto& c : cases) {
        content += c.line;
    }

    TokenFileReader tfr;
    tfr.inject("char_escapes", content);
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    size_t count = 0;
    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        REQUIRE(tfr.next_token_line(tl));
        const auto& toks = tl.tokens();

        REQUIRE(toks.size() == 1);
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == cases[i].expected);
        REQUIRE(toks[0].text() == cases[i].text);

        ++count;
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());

    REQUIRE(count == (sizeof(cases) / sizeof(cases[0])));
}

TEST_CASE("Single-quoted octal and hex escape sequences are converted to Integer",
          "[lexer][char][escapes][octhex]") {
    g_options = Options();

    struct Case {
        const char* line;
        int expected;
        const char* text;
    } cases[] = {
        // Octal: 1 to 3 digits
        { "'\\7'\n",     7,        "'\\7'"   },
        { "'\\101'\n",   65,       "'\\101'" }, // 'A'
        // Hex: \x followed by 1 or 2 hex digits
        { "'\\x7'\n",    0x07,     "'\\x7'"  },
        { "'\\x41'\n",   0x41,     "'\\x41'" }  // 'A'
    };

    std::string content;
    for (const auto& c : cases) {
        content += c.line;
    }

    TokenFileReader tfr;
    tfr.inject("char_escapes_octhex", content);
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    size_t count = 0;

    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        REQUIRE(tfr.next_token_line(tl));
        const auto& toks = tl.tokens();

        REQUIRE(toks.size() == 1);
        const auto& t = toks[0];
        REQUIRE(t.is(TokenType::Integer));
        REQUIRE(t.int_value() == cases[i].expected);
        REQUIRE(t.text() == cases[i].text);

        ++count;
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());

    REQUIRE(count == (sizeof(cases) / sizeof(cases[0])));
}

// New tests: verify that string literals accept all C-escapes plus \e, preserve original text(), and resolve into string_value()

TEST_CASE("String literals accept C escapes plus \\e and resolve to binary contents",
          "[lexer][string][escapes]") {
    g_options = Options();

    struct Case {
        const char*
        literal;   // input literal as it appears in source (including quotes)
    } cases[] = {
        { "\"\\a\"" },
        { "\"\\b\"" },
        { "\"\\e\"" },   // ESC (0x1B) supported by lexer
        { "\"\\f\"" },
        { "\"\\n\"" },
        { "\"\\r\"" },
        { "\"\\t\"" },
        { "\"\\v\"" },
        { "\"\\\\\"" },  // backslash
        { "\"\\\"\"" },  // double quote
        { "\"\\'\"" },   // single quote escaped
        { "\"ABC\"" },   // plain string
        { "\"A\\101B\"" }, // octal: \101 == 'A' -> "AAB"
        { "\"X\\x41Y\"" }, // hex: \x41 == 'A' -> "XAY"
        { "\"\\x7\\7\"" }  // hex one digit and octal one digit
    };

    // Build content with one literal per line
    std::string content;
    for (const auto& c : cases) {
        content += c.literal;
        content += "\n";
    }

    TokenFileReader tfr;
    tfr.inject("string_escapes", content);
    tfr.set_fixed_line_number(1);

    // Expected resolved contents built programmatically to avoid C++ escape confusion
    std::vector<std::string> expected;
    expected.reserve(sizeof(cases) / sizeof(cases[0]));
    {
        std::string s;
        s.push_back('\a');
        expected.push_back(s);
        s.clear();
        s.push_back('\b');
        expected.push_back(s);
        s.clear();
        s.push_back(static_cast<char>(0x1B));
        expected.push_back(s); // \e -> ESC
        s.clear();
        s.push_back('\f');
        expected.push_back(s);
        s.clear();
        s.push_back('\n');
        expected.push_back(s);
        s.clear();
        s.push_back('\r');
        expected.push_back(s);
        s.clear();
        s.push_back('\t');
        expected.push_back(s);
        s.clear();
        s.push_back('\v');
        expected.push_back(s);
        s.clear();
        s.push_back('\\');
        expected.push_back(s);
        s.clear();
        s.push_back('\"');
        expected.push_back(s);
        s.clear();
        s.push_back('\'');
        expected.push_back(s);
        s.clear();
        s.append("ABC");
        expected.push_back(s);
        s.clear();
        s.push_back('A');
        s.push_back('A');
        s.push_back('B');
        expected.push_back(s); // "A\101B"
        s.clear();
        s.push_back('X');
        s.push_back('A');
        s.push_back('Y');
        expected.push_back(s); // "X\x41Y"
        s.clear();
        s.push_back(static_cast<char>(0x07));
        s.push_back(static_cast<char>(0x07));
        expected.push_back(s); // "\x7\7"
    }

    TokenLine tl;
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(tfr.next_token_line(tl));
        const auto& toks = tl.tokens();

        REQUIRE(toks.size() == 1);
        const auto& t = toks[0];
        REQUIRE(t.is(TokenType::String));

        // text() must preserve the original source literal, including quotes and backslashes
        REQUIRE(t.text() == cases[i].literal);

        // string_value() must contain the resolved bytes (no quotes, escapes resolved)
        REQUIRE(t.string_value() == expected[i]);
    }

    REQUIRE_FALSE(tfr.next_token_line(tl));
    REQUIRE(tl.tokens().empty());
}

TEST_CASE("String literals resolve octal (1-3 digits) and hex (1-2 digits) escapes",
          "[lexer][string][escapes][octhex]") {
    g_options = Options();

    struct Case {
        const char* literal;
        std::string expected;
    } cases[] = {
        { "\"\\7\"",     std::string(1, static_cast<char>(7)) },
        { "\"\\101\"",   std::string(1, static_cast<char>(65)) },   // 'A'
        { "\"\\x7\"",    std::string(1, static_cast<char>(0x07)) },
        { "\"\\x41\"",   std::string(1, static_cast<char>(0x41)) }, // 'A'
        { "\"Z\\101\\x41Z\"", std::string("ZA" "A" "Z") }           // "ZAAZ"
    };

    std::string content;
    for (const auto& c : cases) {
        content += c.literal;
        content += "\n";
    }

    TokenFileReader tfr;
    tfr.inject("string_octhex", content);
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    size_t count = 0;

    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        REQUIRE(tfr.next_token_line(tl));
        const auto& toks = tl.tokens();

        REQUIRE(toks.size() == 1);
        const auto& t = toks[0];
        REQUIRE(t.is(TokenType::String));
        REQUIRE(t.text() == cases[i].literal);
        REQUIRE(t.string_value() == cases[i].expected);

        ++count;
    }

    REQUIRE(count == (sizeof(cases) / sizeof(cases[0])));
}

// New test: verify that an empty double-quoted string is accepted
TEST_CASE("Empty string literal is accepted and resolves to empty contents",
          "[lexer][string][empty]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("str_empty", "\"\"\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    const auto& toks = tl.tokens();

    REQUIRE(toks.size() == 1);
    REQUIRE(toks[0].is(TokenType::String));
    REQUIRE(toks[0].text() == "\"\"");
    REQUIRE(toks[0].string_value().empty());
}

// New tests: direct Token::Token(TokenType, const std::string&) constructor behavior
TEST_CASE("Token ctor infers keyword for Identifier and leaves others as None",
          "[token][ctor][identifier]") {
    // Known keyword (case-insensitive mapping performed in keyword_lookup)
    Token t1(TokenType::Identifier, "define", false);
    REQUIRE(t1.is(TokenType::Identifier));
    REQUIRE(t1.is(Keyword::DEFINE));

    // Non-keyword identifier
    Token t2(TokenType::Identifier, "NotAKeyword123", false);
    REQUIRE(t2.is(TokenType::Identifier));
    REQUIRE(t2.is(Keyword::None));
}

TEST_CASE("Token ctor parses Integer text into int_value_",
          "[token][ctor][integer]") {
    Token t_dec(TokenType::Integer, "123", false);
    REQUIRE(t_dec.is(TokenType::Integer));
    REQUIRE(t_dec.int_value() == 123);
    REQUIRE(t_dec.text() == "123");

    Token t_neg(TokenType::Integer, "-45", false);
    REQUIRE(t_neg.int_value() == -45);

    // Leading/trailing spaces are not trimmed here; stoi will throw if invalid.
    // Provide only well-formed numeric text.
    Token t_zero(TokenType::Integer, "0", false);
    REQUIRE(t_zero.int_value() == 0);
}

TEST_CASE("Token ctor parses Float text into float_value_",
          "[token][ctor][float]") {
    Token t_f1(TokenType::Float, "1.25", false);
    REQUIRE(t_f1.is(TokenType::Float));
    REQUIRE(t_f1.float_value() == Catch::Approx(1.25).epsilon(1e-12));

    Token t_f2(TokenType::Float, "-0.5", false);
    REQUIRE(t_f2.float_value() == Catch::Approx(-0.5).epsilon(1e-12));

    Token t_f3(TokenType::Float, "123.", false); // trailing dot form
    REQUIRE(t_f3.float_value() == Catch::Approx(123.0).epsilon(1e-12));
}

TEST_CASE("Token ctor unescapes String text into string_value_",
          "[token][ctor][string]") {
    // Raw source literal content (no surrounding quotes passed to constructor).
    // lexer passes original text including escapes but without enclosing quotes for TokenType::String.
    // Here we simulate that by giving an escaped interior; unescape_c_string should resolve it.
    Token t_str(TokenType::String, "\\n\\tA\\x41\\101\\\"", false);
    std::string expected;
    expected.push_back('\n');
    expected.push_back('\t');
    expected.push_back('A');
    expected.push_back('A');          // \x41
    expected.push_back('A');          // \101
    expected.push_back('\"');         // \"
    REQUIRE(t_str.is(TokenType::String));
    REQUIRE(t_str.string_value() == expected);

    // Empty string
    Token t_empty(TokenType::String, "", false);
    REQUIRE(t_empty.string_value().empty());
}

TEST_CASE("Token ctor leaves unrelated fields at defaults for non-matching types",
          "[token][ctor][defaults]") {
    Token t_plus(TokenType::Plus, "+", false);
    REQUIRE(t_plus.is(TokenType::Plus));
    REQUIRE(t_plus.int_value() == 0);
    REQUIRE(t_plus.float_value() == 0.0);
    REQUIRE(t_plus.keyword() == Keyword::None);
    REQUIRE(t_plus.string_value().empty());
}

TEST_CASE("Token ctor preserves original text() for all types",
          "[token][ctor][text]") {
    std::vector<std::pair<TokenType, std::string>> samples = {
        { TokenType::Identifier, "abc" },
        { TokenType::Integer, "789" },
        { TokenType::Float, "3.14" },
        { TokenType::String, "XYZ" },
        { TokenType::Plus, "+" },
    };
    for (const auto& s : samples) {
        Token t(s.first, s.second, false);
        REQUIRE(t.text() == s.second);
    }
}

TEST_CASE("Token ctor integer/float throws on invalid numeric text (no catch here)",
          "[token][ctor][error][numeric]") {
    // Provide invalid integer; constructor should throw std::invalid_argument from stoi.
    REQUIRE_THROWS(Token(TokenType::Integer, "12x", false));
    // Provide invalid float
    REQUIRE_THROWS(Token(TokenType::Float, "1.2.3", false));
}

TEST_CASE("Token ctor string unescape handles hex and octal edge cases",
          "[token][ctor][string][escapes]") {
    // \x7 and \x4F plus octal \377
    Token t(TokenType::String, "\\x7\\x4F\\377", false);
    std::string expected;
    expected.push_back(static_cast<char>(0x07));
    expected.push_back(static_cast<char>(0x4F));
    expected.push_back(static_cast<char>(0xFF));
    REQUIRE(t.string_value() == expected);
}

TEST_CASE("split_lines handles label colon", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "label: LD A, B\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Should be single line with label colon preserved
    REQUIRE(tl.to_string() == ".label");

    REQUIRE(tfr.next_token_line(tl));
    // Rest of line on next output
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles local label with dot", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", ".local: LD A, B\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Local label should be output alone
    REQUIRE(tl.to_string() == ".local");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles multiple consecutive labels", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "label1: label2: LD A, B\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".label1");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".label2");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles label only line", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "label:\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".label");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles local label only line", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", ".local:\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".local");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines splits on separator colon", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "LD A, B : ADD A, C\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "ADD A, C");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines splits on multiple separator colons", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "LD A, 1 : LD B, 2 : LD C, 3\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, 1");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD B, 2");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD C, 3");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines splits on backslash", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "LD A, B \\ ADD A, C\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "ADD A, C");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines preserves colon after instruction", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "LD A, (HL):\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, (HL)");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles simple ternary expression", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 1 ? 2 : 3\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Should be single line - colon is part of ternary, not a separator
    REQUIRE(tl.to_string() == "DEFB 1 ? 2 : 3");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles nested ternary expressions", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB a ? b ? c : d : e\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Nested ternary - both colons should stay (levels: 0?1?2?1?0)
    REQUIRE(tl.to_string() == "DEFB a ? b ? c : d : e");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles deeply nested ternary", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 0 ? 0 ? 2 : 3 : 1 ? 4 : 5\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 0 ? 0 ? 2 : 3 : 1 ? 4 : 5");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles ternary followed by separator",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 1 ? 2 : 3 : DEFB 4\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 1 ? 2 : 3");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 4");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles label with ternary on separate lines",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "label: DEFB 1 ? 2 : 3\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Label output alone
    REQUIRE(tl.to_string() == ".label");

    REQUIRE(tfr.next_token_line(tl));
    // Rest of line with ternary
    REQUIRE(tl.to_string() == "DEFB 1 ? 2 : 3");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles ternary with separator after",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 1 ? 2 : 3, 4 : LD A, 5\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 1 ? 2 : 3, 4");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, 5");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles complex mixed line with labels",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "label1: DEFB 1 ? 2 : 3 : label2: LD A, 4 ? 5 : 6\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".label1");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 1 ? 2 : 3");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".label2");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, 4 ? 5 : 6");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles multiple ternaries on same line",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 1 ? 2 : 3, 4 ? 5 : 6\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 1 ? 2 : 3, 4 ? 5 : 6");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines resets ternary level on backslash", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 1 ? 2 \\ : 3\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Backslash splits even inside ternary
    REQUIRE(tl.to_string() == "DEFB 1 ? 2");

    REQUIRE(tfr.next_token_line(tl));
    // Colon after backslash becomes a separator (ternary level reset)
    REQUIRE(tl.to_string() == "3");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles instruction followed by ternary",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "LD A, 1 ? 2 : 3\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // LD is instruction, but colon is part of ternary
    REQUIRE(tl.to_string() == "LD A, 1 ? 2 : 3");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles empty ternary branches", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 0 ? : 1\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 0 ? : 1");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles ternary in expression context",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "DEFB 2 * (1 ? 2 : 3) + 4\n");
    tfr.set_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "DEFB 2 * (1 ? 2 : 3) + 4");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles label followed by instruction with colon",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "loop: LD A, (HL): INC HL\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // Label output alone
    REQUIRE(tl.to_string() == ".loop");

    REQUIRE(tfr.next_token_line(tl));
    // Instruction colon stays
    REQUIRE(tl.to_string() == "LD A, (HL)");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "INC HL");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles all colon types in one line", "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "start: LD A, 1 ? 2 : 3 : LD B, (HL): : END\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    // start: = label colon (output alone)
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".start");

    // ? 2 : 3 = ternary colon (keep together)
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, 1 ? 2 : 3");

    // (HL): = instruction colon (keep)
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD B, (HL)");

    // Second standalone : splits to empty line
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "END");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles local label followed by instruction",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", ".loop: LD A, B\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".loop");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines handles mixed global and local labels",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "main: .local: LD A, B\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".main");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == ".local");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

TEST_CASE("split_lines non-first colon is separator not label",
          "[lexer][split]") {
    g_options = Options();

    TokenFileReader tfr;
    tfr.inject("split_test", "LD A, B: label: LD C, D\n");
    tfr.set_fixed_line_number(1);

    TokenLine tl;
    REQUIRE(tfr.next_token_line(tl));
    // First colon after LD is instruction colon
    REQUIRE(tl.to_string() == "LD A, B");

    REQUIRE(tfr.next_token_line(tl));
    // Second identifier+colon is now at start of new logical line, so it's a label
    REQUIRE(tl.to_string() == ".label");

    REQUIRE(tfr.next_token_line(tl));
    REQUIRE(tl.to_string() == "LD C, D");

    REQUIRE_FALSE(tfr.next_token_line(tl));
}

// test_lexer.cpp
TEST_CASE("TokenCache: basic caching") {
    auto& cache = TokenFileReader::get_cache_for_testing();
    cache.clear();

    auto temp_file = create_temp_file("test.asm", "ld a, 1\n");

    SECTION("First read populates cache") {
        REQUIRE(cache.cache_size() == 0);
        REQUIRE_FALSE(cache.has_cached(temp_file));

        TokenFileReader reader;
        REQUIRE(reader.open(temp_file));
        REQUIRE_FALSE(reader.is_using_cache());  // First read tokenizes

        TokenLine line;
        while (reader.next_token_line(line)) {}

        REQUIRE(cache.has_cached(temp_file));
        REQUIRE(cache.cache_size() == 1);
    }

    SECTION("Second read uses cache") {
        // Populate cache first
        {
            TokenFileReader reader;
            REQUIRE(reader.open(temp_file));
            TokenLine line;
            while (reader.next_token_line(line)) {}
        }

        // Second read should hit cache
        TokenFileReader reader;
        REQUIRE(reader.open(temp_file));
        REQUIRE(reader.is_using_cache());  // Using cached data!
    }
}

TEST_CASE("TokenCache: invalidation on file modification") {
    auto& cache = TokenFileReader::get_cache_for_testing();
    cache.clear();

    auto temp_file = create_temp_file("test.asm", "ld a, 1\n");

    // First read
    {
        TokenFileReader reader;
        REQUIRE(reader.open(temp_file));
        TokenLine line;
        while (reader.next_token_line(line)) {}
    }
    REQUIRE(cache.has_cached(temp_file));

    // Modify file
    std::this_thread::sleep_for(std::chrono::seconds(3));
    write_file(temp_file, "ld b, 2\n");  // Different content

    // Cache should miss (different mtime)
    TokenFileReader reader;
    REQUIRE(reader.open(temp_file));
    REQUIRE_FALSE(reader.is_using_cache());  // Cache invalidated!
}

TEST_CASE("TokenCache: options change invalidates cache") {
    auto& cache = TokenFileReader::get_cache_for_testing();
    cache.clear();

    auto temp_file = create_temp_file("test.asm", "label: ld a, 1\n");

    // Read with default options
    g_options.ucase_labels = false;
    {
        TokenFileReader reader;
        REQUIRE(reader.open(temp_file));
        TokenLine line;
        while (reader.next_token_line(line)) {}
    }
    REQUIRE(cache.has_cached(temp_file));

    // Change option that affects tokenization
    g_options.ucase_labels = true;

    // Should not use cache
    TokenFileReader reader;
    REQUIRE(reader.open(temp_file));
    REQUIRE_FALSE(reader.is_using_cache());
}

TEST_CASE("TokenCache: direct API tests") {
    TokenCache cache;
    cache.clear();

    auto temp_file = create_temp_file("test.asm", "ld a, 1\n");

    SECTION("get returns nullopt for uncached file") {
        REQUIRE_FALSE(cache.get(temp_file).has_value());
    }

    SECTION("put and get round-trip") {
        std::vector<TokenLine> lines;
        lines.emplace_back(Location(temp_file, 1));
        lines.back().tokens().emplace_back(
            TokenType::Identifier, "ld", Keyword::LD, false);

        cache.put(temp_file, lines);

        auto retrieved = cache.get(temp_file);
        REQUIRE(retrieved.has_value());
        REQUIRE(retrieved->size() == 1);
    }

    SECTION("clear removes all entries") {
        std::vector<TokenLine> lines;
        cache.put(temp_file, lines);
        REQUIRE(cache.get(temp_file).has_value());

        cache.clear();
        REQUIRE_FALSE(cache.get(temp_file).has_value());
    }
}
