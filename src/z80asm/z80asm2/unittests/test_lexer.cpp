//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../options.h"
#include "../keywords.h"
#include "../lexer.h"
#include "catch_amalgamated.hpp"
#include <algorithm>
#include <set>
#include <string>
#include <vector>
#include <iostream>
#include <sstream>

// Helper to capture std::cerr output
class CerrRedirect {
    std::ostringstream ss;
    std::streambuf* old;
public:
    CerrRedirect() : old(std::cerr.rdbuf(ss.rdbuf())) {}
    ~CerrRedirect() {
        std::cerr.rdbuf(old);
    }
    std::string str() const {
        return ss.str();
    }
};

// Global capture for this translation unit to prevent tests from printing to the console.
static CerrRedirect g_cerr_silencer;

TEST_CASE("TokensLine basic operations", "[lexer]") {
    g_options = Options();

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

    // to_string concatenates original token texts, inseritng spaces where needed
    REQUIRE(line.to_string() == "foo 123");

    const Token& last = line.back();
    REQUIRE(last.text() == "123");
}

// New test: verify that creating an Identifier token sets the keyword attribute
TEST_CASE("Token constructor sets keyword for identifiers",
          "[lexer][token][keyword]") {
    g_options = Options();

    // Known keyword should map to corresponding Keyword enum (DEFINE)
    Token t_define(TokenType::Identifier, "DEFINE");
    REQUIRE(t_define.is(Keyword::DEFINE));
    REQUIRE(t_define.keyword() == Keyword::DEFINE);

    Token t_define2(TokenType::Identifier, "define");
    REQUIRE(t_define2.is(Keyword::DEFINE));
    REQUIRE(t_define2.keyword() == Keyword::DEFINE);

    // Non-keyword identifier should map to Keyword::None
    Token t_custom(TokenType::Identifier, "myIdentifier");
    REQUIRE(t_custom.is(Keyword::None));
    REQUIRE(t_custom.keyword() == Keyword::None);

    // Case-insensitive mapping: when options cause uppercasing, keyword mapping still works.
    g_options = Options();
    g_options.ucase_labels = true;
    Token t_ucase(TokenType::Identifier, "define"); // lowercase input
    REQUIRE(t_ucase.keyword() == Keyword::DEFINE);
    // restore options
    g_options = Options();
}

TEST_CASE("TokensFile from string, counts and bounds", "[lexer]") {
    g_options = Options();

    const std::string content = "one\ntwo\n\nthree";
    TokensFile tf(content, "virtual", 10, false);

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
    REQUIRE(tf.get_tok_line(static_cast<unsigned>(-1)).empty());
    REQUIRE(tf.get_tok_line(999).empty());

    // each non-empty tokenized line should have a location set to first_line_num (virtual file)
    for (unsigned i = 0; i < tf.tok_lines_count(); ++i) {
        const TokensLine& tl = tf.get_tok_line(i);
        REQUIRE(tl.location().line_num() == 10);
        REQUIRE(!tl.empty());
        const auto& tks = tl.tokens();
        REQUIRE(tks.size() >= 1);
    }
}

TEST_CASE("split_lines handles CRLF and LF mixed endings", "[lexer]") {
    g_options = Options();

    const std::string content = "a\r\nb\nc\r\n";
    TokensFile tf(content, "virtual2", 1, true);
    REQUIRE(tf.line_count() == 3);
    REQUIRE(tf.get_line(0) == "a");
    REQUIRE(tf.get_line(1) == "b");
    REQUIRE(tf.get_line(2) == "c");
}

TEST_CASE("empty content produces no token lines", "[lexer]") {
    g_options = Options();

    const std::string content = "\n\r\n\n"; // only empty lines
    TokensFile tf(content, "empty", 1, true);
    REQUIRE(tf.line_count() == 3);
    REQUIRE(tf.tok_lines_count() == 0);
}

TEST_CASE("TokensFile tokenizes all TokenType values", "[lexer][token_types]") {
    g_options = Options();

    // Build a single line that contains examples of each token type (except EndOfFile).
    // Note: backslash is included as a standalone token; whitespace is produced between tokens.
    const std::string content = "id 123 1.23 \"str\" + \\ , . ( ) [ ] { }\n";
    TokensFile tf(content, "types_test", 1, true);

    REQUIRE(tf.tok_lines_count() == 1);
    const TokensLine& tl = tf.get_tok_line(0);
    const auto& toks = tl.tokens();

    // Collect seen token types
    std::set<TokenType> seen;
    for (const auto& t : toks) {
        seen.insert(t.type());
    }

    // Expected token types (exclude EndOfFile)
    std::vector<TokenType> expected = {
        TokenType::Identifier,
        TokenType::Integer,
        TokenType::Float,
        TokenType::String,
        TokenType::Backslash,
        TokenType::Comma,
        TokenType::Dot,
        TokenType::LeftParen,
        TokenType::RightParen,
        TokenType::LeftBracket,
        TokenType::RightBracket,
        TokenType::LeftBrace,
        TokenType::RightBrace,
        TokenType::Whitespace
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
}

TEST_CASE("TokensFile tokenizes all TokenType values",
          "[lexer][operator_types]") {
    g_options = Options();

    // Construct one line that includes representative symbols for operator tokens.
    // Some operator tokens are multi-character and must be contiguous (e.g. '!=', '<<', '^^', '**', '##').
    const std::string content =
        "! != ~ ^ ^^ & && * ** / % + - << >> < <= > >= = ? : # ## | ||\n";

    TokensFile tf(content, "op_test", 1, false);
    REQUIRE(tf.tok_lines_count() == 1);

    const TokensLine& tl = tf.get_tok_line(0);
    const auto& toks = tl.tokens();

    // Collect operator token TokenType values in the order they appear.
    std::vector<TokenType> seen;
    for (const auto& t : toks) {
        if (t.is_not(TokenType::Whitespace)) {
            seen.push_back(t.type());
        }
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
        TokenType::Modulus,      // "%"
        TokenType::Plus,         // "+"
        TokenType::Minus,        // "-"
        TokenType::ShiftLeft,    // "<<"
        TokenType::ShiftRight,   // ">>"
        TokenType::LT,           // "<"
        TokenType::LE,           // "<="
        TokenType::GT,           // ">"
        TokenType::GE,           // ">="
        TokenType::EQ,           // "="
        TokenType::Quest,        // "?"
        TokenType::Colon,        // ":"
        TokenType::Hash,         // "#"
        TokenType::DoubleHash,   // "##"
        TokenType::BitwiseOr,    // "|"
        TokenType::LogicalOr     // "||"
    };

    REQUIRE(seen.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(seen[i] == expected[i]);
    }
}

//
// New tests: verify comment removal for ';', '//' and '/* */'
//

static std::vector<std::string> token_texts(const TokensLine& tl) {
    std::vector<std::string> out;
    for (const auto& t : tl.tokens()) {
        out.push_back(t.text());
    }
    return out;
}

TEST_CASE("Lexer removes semicolon comments (';') from input",
          "[lexer][comments]") {
    g_options = Options();

    const std::string content = "mov a, b ; this is a comment\nnext\n";
    TokensFile tf(content, "comment_semicolon", 1, false);

    // Two non-empty tokenized lines: first with "mov a, b", second with "next"
    REQUIRE(tf.tok_lines_count() == 2);

    const TokensLine& first = tf.get_tok_line(0);
    auto texts = token_texts(first);

    // Ensure the code tokens are present
    REQUIRE(std::find(texts.begin(), texts.end(), "mov") != texts.end());
    REQUIRE(std::find(texts.begin(), texts.end(), "a") != texts.end());
    REQUIRE(std::find(texts.begin(), texts.end(), "b") != texts.end());

    // Ensure comment text does not appear
    REQUIRE(std::none_of(texts.begin(), texts.end(), [](const std::string & s) {
        return s.find(";") != std::string::npos || s.find("this") != std::string::npos;
    }));

    // Second line should contain 'next'
    const TokensLine& second = tf.get_tok_line(1);
    auto texts2 = token_texts(second);
    REQUIRE(std::find(texts2.begin(), texts2.end(), "next") != texts2.end());
}

TEST_CASE("Lexer removes double-slash comments ('//') from input",
          "[lexer][comments]") {
    g_options = Options();

    const std::string content = "ld bc, 0 // set bc to zero\n";
    TokensFile tf(content, "comment_double_slash", 1, false);

    // One tokenized line (comment removed)
    REQUIRE(tf.tok_lines_count() == 1);

    const TokensLine& tl = tf.get_tok_line(0);
    auto texts = token_texts(tl);

    // Ensure code tokens exist and comment tokens do not
    REQUIRE(std::find(texts.begin(), texts.end(), "ld") != texts.end());
    REQUIRE(std::find(texts.begin(), texts.end(), "bc") != texts.end());
    REQUIRE(std::find(texts.begin(), texts.end(), "0") != texts.end());
    REQUIRE(std::none_of(texts.begin(), texts.end(), [](const std::string & s) {
        return s.find("//") != std::string::npos || s.find("set") != std::string::npos;
    }));
}

TEST_CASE("Lexer removes C-style multi-line comments ('/* */') across lines",
          "[lexer][comments]") {
    g_options = Options();

    const std::string content = "a /* multi\ncomment */ b\n";
    TokensFile tf(content, "comment_c_style", 1, false);

    // The tokenizer removes the comment; resulting token line should contain 'a' and 'b'
    REQUIRE(tf.tok_lines_count() == 1);

    const TokensLine& tl = tf.get_tok_line(0);
    auto texts = token_texts(tl);

    REQUIRE(std::find(texts.begin(), texts.end(), "a") != texts.end());
    REQUIRE(std::find(texts.begin(), texts.end(), "b") != texts.end());

    // Ensure no fragments of the comment remain
    REQUIRE(std::none_of(texts.begin(), texts.end(), [](const std::string & s) {
        return s.find("/*") != std::string::npos
               || s.find("*/") != std::string::npos
               || s.find("multi") != std::string::npos
               || s.find("comment") != std::string::npos;
    }));
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
    const std::string content =
        "123 123d 1Ah 1aH $FF 0xAB 1011b %1011 @1011 0b1011\n";
    TokensFile tf(content, "int_formats", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const TokensLine& tl = tf.get_tok_line(0);
    const auto& toks = tl.tokens();

    std::vector<int> found;
    for (const auto& t : toks) {
        if (t.type() == TokenType::Integer) {
            found.push_back(t.int_value());
        }
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
}

TEST_CASE("Single-quoted characters returned as Integer", "[lexer][char]") {
    g_options = Options();

    // Lines:
    // 'A'    -> ASCII 65
    // '\n'   -> newline (10)
    // '\t'   -> tab (9)
    const std::string content = "'A'\n'\\n'\n'\\t'\n";
    TokensFile tf(content, "char_test", 1, false);

    REQUIRE(tf.tok_lines_count() == 3);

    const auto& toks0 = tf.get_tok_line(0).tokens();
    REQUIRE(toks0.size() == 1);
    REQUIRE(toks0[0].is(TokenType::Integer));
    REQUIRE(toks0[0].int_value() == static_cast<int>('A'));
    REQUIRE(toks0[0].text() == "'A'");

    const auto& toks1 = tf.get_tok_line(1).tokens();
    REQUIRE(toks1.size() == 1);
    REQUIRE(toks1[0].is(TokenType::Integer));
    REQUIRE(toks1[0].int_value() == static_cast<int>('\n'));
    REQUIRE(toks1[0].text() == "'\\n'");

    const auto& toks2 = tf.get_tok_line(2).tokens();
    REQUIRE(toks2.size() == 1);
    REQUIRE(toks2[0].is(TokenType::Integer));
    REQUIRE(toks2[0].int_value() == static_cast<int>('\t'));
    REQUIRE(toks2[0].text() == "'\\t'");
}

//
// New tests: verify invalid single-quoted character forms produce errors
//

TEST_CASE("Single-quoted empty and multi-character literals produce Invalid quoted character error",
          "[lexer][char][error]") {
    g_options = Options();

    g_errors.reset();

    // Empty quoted character: ''  -> should trigger Invalid quoted character
    const std::string content_empty = "''\n";
    TokensFile tf_empty(content_empty, "char_err_empty", 1, false);

    // Tokenization should fail and produce no token lines
    REQUIRE(tf_empty.tok_lines_count() == 0);
    REQUIRE(g_errors.has_errors());
    {
        const std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("Invalid quoted character") != std::string::npos);
        REQUIRE(msg.find("''") != std::string::npos);
        REQUIRE(msg.find("char_err_empty:1:") != std::string::npos);
    }

    // Reset errors before next case
    g_errors.reset();

    // Multi-character quoted literal: 'AB' -> should trigger Invalid quoted character
    const std::string content_multi = "'AB'\n";
    TokensFile tf_multi(content_multi, "char_err_multi", 1, false);

    REQUIRE(tf_multi.tok_lines_count() == 0);
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

    const std::string content = "AF'\n";
    TokensFile tf(content, "kw_quote_test", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    // Should produce a single identifier token which maps to Keyword::AF_
    REQUIRE(toks.size() == 1);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].is(Keyword::AF_));
    REQUIRE(toks[0].text() == "AF'");
}

TEST_CASE("Trailing quote after a keyword starts a character constant (DEFINE'a')",
          "[lexer][keywords][quote_char]") {
    g_options = Options();

    g_errors.reset();
    const std::string content = "DEFINE'a'\n";
    TokensFile tf(content, "kw_then_char", 1, false);

    // One tokenized line
    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    // Expect two tokens: the keyword DEFINE (no trailing quote) and the character constant as Integer
    REQUIRE(toks.size() == 2);

    // First token: keyword DEFINE
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].is(Keyword::DEFINE));
    REQUIRE(toks[0].text() == "DEFINE");

    // Second token: character constant -> Integer token with value 'a'
    REQUIRE(toks[1].is(TokenType::Integer));
    REQUIRE(toks[1].int_value() == static_cast<int>('a'));
    REQUIRE(toks[1].text() == "'a'");
}

//
// New tests: unterminated comments/strings should be reported as errors
//

TEST_CASE("Unterminated C-style comment reports error",
          "[lexer][error][comment]") {
    g_options = Options();

    g_errors.reset();
    const std::string content = "code /* unclosed comment\n";
    TokensFile tf(content, "unclosed_comment", 1, false);

    // Tokenization should fail and produce no token lines
    REQUIRE(tf.tok_lines_count() == 0);
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unterminated comment") != std::string::npos);
    REQUIRE(msg.find("unclosed_comment:1:") != std::string::npos);
}

TEST_CASE("Unterminated double-quoted string reports error",
          "[lexer][error][string]") {
    g_options = Options();

    g_errors.reset();
    const std::string content = "db \"unterminated\n";
    TokensFile tf(content, "unclosed_dquote", 1, false);

    REQUIRE(tf.tok_lines_count() == 0);
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unterminated string") != std::string::npos);
    REQUIRE(msg.find("unclosed_dquote:1:") != std::string::npos);
}

TEST_CASE("Unterminated single-quoted string reports error",
          "[lexer][error][string]") {
    g_options = Options();

    g_errors.reset();
    const std::string content = "db 'u\n";
    TokensFile tf(content, "unclosed_squote", 1, false);

    REQUIRE(tf.tok_lines_count() == 0);
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unterminated string") != std::string::npos);
    REQUIRE(msg.find("unclosed_squote:1:") != std::string::npos);
}

// New tests: include trailing extra token errors were added earlier (omitted here for brevity)

// New test: verify identifiers are upper-cased when g_options.ucase_labels == true
TEST_CASE("g_options.ucase_labels causes identifiers to be upper-cased",
          "[lexer][ucase]") {
    g_options = Options();
    g_options.ucase_labels = true;

    const std::string content = "foo bar Baz qux123\n";
    TokensFile tf(content, "ucase_test", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<std::string> ids;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier)) {
            ids.push_back(t.text());
        }
    }

    std::vector<std::string> expected = { "FOO", "BAR", "BAZ", "QUX123" };
    REQUIRE(ids == expected);

    // Also verify that keywords are upper-cased and mapped to Keyword enum
    g_options = Options();
    g_options.ucase_labels = true;
    const std::string content2 = "ld a, 0\n";
    TokensFile tf2(content2, "ucase_kw", 1, false);
    REQUIRE(tf2.tok_lines_count() == 1);
    const auto& toks2 = tf2.get_tok_line(0).tokens();

    // find first identifier token
    size_t idx = 0;
    while (idx < toks2.size() && !toks2[idx].is(TokenType::Identifier)) {
        ++idx;
    }
    REQUIRE(idx < toks2.size());
    REQUIRE(toks2[idx].text() == "LD");
    REQUIRE(toks2[idx].keyword() == Keyword::LD);

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
    TokensFile tf_off(content, "swap_off", 1, false);
    REQUIRE(tf_off.tok_lines_count() == 1);

    std::vector<std::string> ids_off;
    std::vector<Keyword> kws_off;
    for (const auto& t : tf_off.get_tok_line(0).tokens()) {
        if (t.is(TokenType::Identifier)) {
            ids_off.push_back(t.text());
            kws_off.push_back(t.keyword());
        }
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

    // --- Case 2: swap enabled ---
    g_options = Options();
    g_options.swap_ix_iy = true;

    TokensFile tf_on(content, "swap_on", 1, false);
    REQUIRE(tf_on.tok_lines_count() == 1);

    std::vector<std::string> ids_on;
    std::vector<Keyword> kws_on;
    for (const auto& t : tf_on.get_tok_line(0).tokens()) {
        if (t.is(TokenType::Identifier)) {
            ids_on.push_back(t.text());
            kws_on.push_back(t.keyword());
        }
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

    // restore options
    g_options = Options();
}

// -----------------------------------------------------------------------------
// Added tests: bounds, skip_spaces/at_end, to_string preserving whitespace,
// get_tok_line out-of-range behavior, spacing rules for to_string, and
// operator-pair spacing tests.
// -----------------------------------------------------------------------------

TEST_CASE("TokensLine operator[] out-of-range returns EndOfFile token",
          "[lexer][tokensline][bounds]") {
    g_options = Options();

    TokensLine tl(Location("file", 1));
    REQUIRE(tl.empty());
    const Token& t = tl[0]; // out-of-range
    REQUIRE(t.is(TokenType::EndOfFile));
    REQUIRE(t.text().empty());
}

TEST_CASE("TokensLine skip_spaces and at_end behave correctly",
          "[lexer][tokensline][spaces]") {
    g_options = Options();

    TokensLine only_spaces(Location("loc", 1));
    only_spaces.push_back(Token(TokenType::Whitespace, " "));
    only_spaces.push_back(Token(TokenType::Whitespace, "\t"));
    unsigned idx = 0;
    // at_end should skip spaces and report end
    REQUIRE(only_spaces.at_end(idx));
    // idx should have been advanced by skip_spaces (>= size)
    REQUIRE(idx >= only_spaces.size());

    TokensLine mixed(Location("loc", 2));
    mixed.push_back(Token(TokenType::Whitespace, " "));
    mixed.push_back(Token(TokenType::Identifier, "a"));
    unsigned j = 0;
    // skip_spaces should advance j to first non-space token index (1)
    mixed.skip_spaces(j);
    REQUIRE(j == 1u);
    // at_end should return false because a non-space token exists after skipping
    unsigned k = 0;
    REQUIRE_FALSE(mixed.at_end(k));
}

TEST_CASE("TokensLine to_string preserves original token text including whitespace",
          "[lexer][tokensline][to_string]") {
    g_options = Options();

    TokensLine tl(Location("l", 1));
    tl.push_back(Token(TokenType::Identifier, "mov"));
    tl.push_back(Token(TokenType::Whitespace, " "));
    tl.push_back(Token(TokenType::Identifier, "a"));
    tl.push_back(Token(TokenType::Comma, ","));
    tl.push_back(Token(TokenType::Whitespace, " "));
    tl.push_back(Token(TokenType::Identifier, "b"));

    REQUIRE(tl.to_string() == "mov a, b");
}

// New tests: verify that to_string inserts spaces between Identifier/Integer/Float
TEST_CASE("TokensLine to_string inserts spaces between Identifier, Integer and Float tokens",
          "[lexer][tokensline][to_string_spacing]") {
    g_options = Options();

    // Identifier followed by Integer
    TokensLine tl_id_int(Location("l", 1));
    tl_id_int.push_back(Token(TokenType::Identifier, "foo"));
    tl_id_int.push_back(Token(TokenType::Integer, "123"));
    REQUIRE(tl_id_int.to_string() == "foo 123");

    // Identifier followed by Float
    TokensLine tl_id_float(Location("l", 2));
    tl_id_float.push_back(Token(TokenType::Identifier, "foo"));
    tl_id_float.push_back(Token(TokenType::Float, "1.23"));
    REQUIRE(tl_id_float.to_string() == "foo 1.23");

    // Integer followed by Identifier
    TokensLine tl_int_id(Location("l", 3));
    tl_int_id.push_back(Token(TokenType::Integer, "123"));
    tl_int_id.push_back(Token(TokenType::Identifier, "bar"));
    REQUIRE(tl_int_id.to_string() == "123 bar");

    // Integer followed by Float
    TokensLine tl_int_float(Location("l", 4));
    tl_int_float.push_back(Token(TokenType::Integer, "123"));
    tl_int_float.push_back(Token(TokenType::Float, "1.23"));
    REQUIRE(tl_int_float.to_string() == "123 1.23");

    // Float followed by Identifier
    TokensLine tl_float_id(Location("l", 5));
    tl_float_id.push_back(Token(TokenType::Float, "1.23"));
    tl_float_id.push_back(Token(TokenType::Identifier, "x"));
    REQUIRE(tl_float_id.to_string() == "1.23 x");

    // Mixed with non-identifier/number tokens should not insert extra spaces beyond token text
    TokensLine tl_mixed(Location("l", 6));
    tl_mixed.push_back(Token(TokenType::Identifier, "mov"));
    tl_mixed.push_back(Token(TokenType::LeftParen, "("));
    tl_mixed.push_back(Token(TokenType::Integer, "1"));
    tl_mixed.push_back(Token(TokenType::RightParen, ")"));
    // Expect "mov(1)" if no whitespace tokens were present in original tokens
    REQUIRE(tl_mixed.to_string() == "mov(1)");
}

// New tests: verify that to_string inserts spaces between tokens that would combine
// into multi-character operator tokens when concatenated.
TEST_CASE("TokensLine to_string inserts spaces between tokens that form multi-char operators",
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
        TokensLine tl(Location("op", 1));
        tl.push_back(Token(p.a, p.ta));
        tl.push_back(Token(p.b, p.tb));
        std::string want = std::string(p.ta) + " " + std::string(p.tb);
        INFO("Checking pair: '" << p.ta << "' + '" << p.tb << "' -> to_string()");
        REQUIRE(tl.to_string() == want);
    }
}

TEST_CASE("TokensFile get_tok_line out-of-range returns empty TokensLine",
          "[lexer][tokensfile][bounds]") {
    g_options = Options();

    const std::string content = "one\n";
    TokensFile tf(content, "v", 1, false);
    REQUIRE(tf.tok_lines_count() == 1);
    const TokensLine& out = tf.get_tok_line(99);
    REQUIRE(out.empty());
    // out.tokens() should be empty
    REQUIRE(out.empty());
}

// New tests: verify identifier forms '@ident', 'ident@ident' and 'ident' (C identifier rules)
TEST_CASE("Lexer detects identifiers '@ident', 'ident@ident' and 'ident'",
          "[lexer][ident]") {
    g_options = Options(); // default options (no upper-casing)

    // ident1 = [_a-zA-Z][_a-zA-Z0-9]*
    // ident  = '@' ident1 | ident1 '@' ident1 | ident1
    const std::string content = "@foo  _ok1@bar2  normal\n";
    TokensFile tf(content, "ident_forms", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<std::string> ids;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier)) {
            ids.push_back(t.text());
        }
    }

    std::vector<std::string> expected = {
        "@foo",       // '@' ident1
        "_ok1@bar2",  // ident1 '@' ident1
        "normal"      // ident1
    };

    REQUIRE(ids == expected);
}

TEST_CASE("Lexer identifier forms allow underscores and digits after the first character",
          "[lexer][ident][chars]") {
    g_options = Options(); // default options

    // More thorough coverage of allowed characters within ident1
    const std::string content = "@_AbC123  A_B@C9_d  Z9\n";
    TokensFile tf(content, "ident_forms_chars", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<std::string> ids;
    for (const auto& t : toks) {
        if (t.is(TokenType::Identifier)) {
            ids.push_back(t.text());
        }
    }

    std::vector<std::string> expected = {
        "@_AbC123",  // '@' + ident1 with underscores/digits allowed after first char
        "A_B@C9_d",  // ident1 '@' ident1
        "Z9"         // ident1
    };

    REQUIRE(ids == expected);
}

// New tests: verify all runs of any whitespace chars collapse to a single Whitespace token
TEST_CASE("Lexer collapses mixed whitespace run into one Whitespace token",
          "[lexer][whitespace]") {
    g_options = Options();

    // Between A and B we place a contiguous run of space, tab, vertical-tab, form-feed, space
    const std::string content = "A \t\v\f B\n";
    TokensFile tf(content, "ws_mixed", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    REQUIRE(toks.size() == 3);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "A");

    REQUIRE(toks[1].is(TokenType::Whitespace)); // single token for the whole run

    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "B");
}

TEST_CASE("Lexer collapses multiple whitespace runs each to one Whitespace token",
          "[lexer][whitespace]") {
    g_options = Options();

    // Three runs of whitespace separating A, B, C, D
    // 1) spaces, 2) tabs, 3) vertical-tab + form-feed
    const std::string content = "A   B\t\tC\v\fD\n";
    TokensFile tf(content, "ws_runs", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    // Expect: A, WS, B, WS, C, WS, D
    REQUIRE(toks.size() == 7);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "A");
    REQUIRE(toks[1].is(TokenType::Whitespace));

    REQUIRE(toks[2].is(TokenType::Identifier));
    REQUIRE(toks[2].text() == "B");
    REQUIRE(toks[3].is(TokenType::Whitespace));

    REQUIRE(toks[4].is(TokenType::Identifier));
    REQUIRE(toks[4].text() == "C");
    REQUIRE(toks[5].is(TokenType::Whitespace));

    REQUIRE(toks[6].is(TokenType::Identifier));
    REQUIRE(toks[6].text() == "D");
}

TEST_CASE("Lexer trims leading and trailing whitespace runs",
          "[lexer][whitespace][edges]") {
    g_options = Options();

    // Leading run: space+tab, trailing run: tab+space
    const std::string content = " \tA\t \n";
    TokensFile tf(content, "ws_edges", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    // Expect: WS, A, WS
    REQUIRE(toks.size() == 1);
    REQUIRE(toks[0].is(TokenType::Identifier));
    REQUIRE(toks[0].text() == "A");
}

// New tests: verify bitmask forms %"... and @ "..." are scanned into Integer with correct value
TEST_CASE("Lexer scans bitmask %\"-#-#\" and @\"-#-#\" into Integer tokens",
          "[lexer][bitmask]") {
    g_options = Options();

    const std::string content = "%\"-#-#\" @\"-#-#\"\n";
    TokensFile tf(content, "bitmask_basic", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    // Collect integer tokens
    std::vector<const Token*> ints;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer)) {
            ints.push_back(&t);
        }
    }

    // Expect two Integer tokens, both representing binary -#-# => 0101b => 5
    REQUIRE(ints.size() == 2);
    REQUIRE(ints[0]->int_value() == 5);
    REQUIRE(ints[1]->int_value() == 5);

    // Text should be preserved exactly (including leading %/@ and quotes)
    REQUIRE(ints[0]->text() == "%\"-#-#\"");
    REQUIRE(ints[1]->text() == "@\"-#-#\"");
}

TEST_CASE("Lexer bitmask handles empty and single-bit sequences",
          "[lexer][bitmask][edge]") {
    g_options = Options();

    // Empty -> 0, "#" -> 1, "-#" -> 1, "#-" -> 2
    const std::string content = "%\"\" %\"#\" %\"-#\" %\"#-\"\n";
    TokensFile tf(content, "bitmask_edges", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<int> values;
    std::vector<std::string> texts;
    for (const auto& t : toks) {
        if (t.is(TokenType::Integer)) {
            values.push_back(t.int_value());
            texts.push_back(t.text());
        }
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
    TokensFile tf(content, "int_underscores", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const TokensLine& tl = tf.get_tok_line(0);
    const auto& toks = tl.tokens();

    std::vector<int> found;
    for (const auto& t : toks) {
        if (t.type() == TokenType::Integer) {
            found.push_back(t.int_value());
        }
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
}

// New tests: verify floats accept underscores as digit separators in integer, fractional and exponent parts
TEST_CASE("Lexer parses floats with underscores in integer and fractional parts",
          "[lexer][float][underscores]") {
    g_options = Options();

    // Three floats:
    // 1) underscore in integer part: 1_234.5 -> 1234.5
    // 2) underscore in fractional part: 12.3_45 -> 12.345
    // 3) multiple underscores within fractional digits: 0.0_5 -> 0.05
    const std::string content = "1_234.5 12.3_45 0.0_5\n";
    TokensFile tf(content, "float_underscores_if", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<double> found;
    for (const auto& t : toks) {
        if (t.is(TokenType::Float)) {
            found.push_back(t.float_value());
        }
    }

    std::vector<double> expected = {
        1234.5,   // "1_234.5"
        12.345,   // "12.3_45"
        0.05      // "0.0_5"
    };

    REQUIRE(found.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(found[i] == Catch::Approx(expected[i]).epsilon(1e-12));
    }
}

TEST_CASE("Lexer parses floats with underscores in exponent part (and combined)",
          "[lexer][float][underscores][exponent]") {
    g_options = Options();

    // Three floats:
    // 1) underscore in exponent: 1.25e1_2 -> 1.25e12
    // 2) underscore with negative exponent: 3.0e-0_3 -> 3.0e-3
    // 3) underscores in integer part and exponent: 4_2.0e0_0 -> 42.0
    const std::string content = "1.25e1_2 3.0e-0_3 4_2.0e0_0\n";
    TokensFile tf(content, "float_underscores_exp", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<double> found;
    for (const auto& t : toks) {
        if (t.is(TokenType::Float)) {
            found.push_back(t.float_value());
        }
    }

    std::vector<double> expected = {
        1.25e12,  // "1.25e1_2"
        3.0e-3,   // "3.0e-0_3"
        42.0      // "4_2.0e0_0"
    };

    REQUIRE(found.size() == expected.size());
    for (size_t i = 0; i < expected.size(); ++i) {
        REQUIRE(found[i] == Catch::Approx(expected[i]).epsilon(1e-12));
    }
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
        g_errors.reset();
        TokensFile tf(content, "invalid_num_underscores", 1, false);
        REQUIRE(tf.tok_lines_count() == 0);
        REQUIRE(g_errors.has_errors());
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
        g_errors.reset();
        TokensFile tf(content, "invalid_float_underscores", 1, false);
        REQUIRE(tf.tok_lines_count() == 0);
        REQUIRE(g_errors.has_errors());
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
    const std::string content = "123.456 123. .789 1.e2 .5E-2 42.e+0\n";
    TokensFile tf(content, "float_canonical", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    std::vector<double> found;
    for (const auto& t : toks) {
        if (t.is(TokenType::Float)) {
            found.push_back(t.float_value());
        }
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
        g_errors.reset();
        TokensFile tf(content, "num_trailing_letters", 1, false);
        REQUIRE(tf.tok_lines_count() == 0);
        REQUIRE(g_errors.has_errors());
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
        g_errors.reset();
        TokensFile tf(c.text, c.fname, 1, false);

        // Tokenization should fail and produce no token lines
        REQUIRE(tf.tok_lines_count() == 0);
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

    const std::string content = "0b\n";
    TokensFile tf(content, "zero_0b", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

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
        g_errors.reset();
        TokensFile tf(c.text, c.fname, 1, false);

        // Tokenization should fail and produce no token lines
        REQUIRE(tf.tok_lines_count() == 0);
        REQUIRE(g_errors.has_errors());

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

    TokensFile tf(content, "char_escapes", 1, false);
    REQUIRE(tf.tok_lines_count() == (sizeof(cases) / sizeof(cases[0])));

    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        const auto& toks = tf.get_tok_line(static_cast<unsigned>(i)).tokens();
        REQUIRE(toks.size() == 1);
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == cases[i].expected);
        REQUIRE(toks[0].text() == cases[i].text);
    }
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

    TokensFile tf(content, "char_escapes_octhex", 1, false);
    REQUIRE(tf.tok_lines_count() == (sizeof(cases) / sizeof(cases[0])));

    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        const auto& toks = tf.get_tok_line(static_cast<unsigned>(i)).tokens();
        REQUIRE(toks.size() == 1);
        REQUIRE(toks[0].is(TokenType::Integer));
        REQUIRE(toks[0].int_value() == cases[i].expected);
        REQUIRE(toks[0].text() == cases[i].text);
    }
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

    TokensFile tf(content, "string_escapes", 1, false);
    REQUIRE(tf.tok_lines_count() == (sizeof(cases) / sizeof(cases[0])));

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

    for (size_t i = 0; i < expected.size(); ++i) {
        const auto& toks = tf.get_tok_line(static_cast<unsigned>(i)).tokens();
        REQUIRE(toks.size() == 1);
        const auto& t = toks[0];
        REQUIRE(t.is(TokenType::String));

        // text() must preserve the original source literal, including quotes and backslashes
        REQUIRE(t.text() == cases[i].literal);

        // string_value() must contain the resolved bytes (no quotes, escapes resolved)
        REQUIRE(t.string_value() == expected[i]);
    }
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

    TokensFile tf(content, "string_octhex", 1, false);
    REQUIRE(tf.tok_lines_count() == (sizeof(cases) / sizeof(cases[0])));

    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        const auto& toks = tf.get_tok_line(static_cast<unsigned>(i)).tokens();
        REQUIRE(toks.size() == 1);
        const auto& t = toks[0];
        REQUIRE(t.is(TokenType::String));
        REQUIRE(t.text() == cases[i].literal);
        REQUIRE(t.string_value() == cases[i].expected);
    }
}

// New test: verify that an empty double-quoted string is accepted
TEST_CASE("Empty string literal is accepted and resolves to empty contents",
          "[lexer][string][empty]") {
    g_options = Options();

    const std::string content = "\"\"\n";
    TokensFile tf(content, "str_empty", 1, false);

    REQUIRE(tf.tok_lines_count() == 1);
    const auto& toks = tf.get_tok_line(0).tokens();

    REQUIRE(toks.size() == 1);
    REQUIRE(toks[0].is(TokenType::String));
    REQUIRE(toks[0].text() == "\"\"");
    REQUIRE(toks[0].string_value().empty());
}

TEST_CASE("TokensLine trim removes whitespace and returns change status",
          "[lexer][trim]") {
    g_options = Options();

    TokensLine line;

    // Add leading whitespace
    line.push_back(Token(TokenType::Whitespace, " "));
    line.push_back(Token(TokenType::Whitespace, "\t"));

    // Add meaningful tokens
    line.push_back(Token(TokenType::Identifier, "foo"));
    line.push_back(Token(TokenType::Integer, "123"));

    // Add trailing whitespace
    line.push_back(Token(TokenType::Whitespace, " "));
    line.push_back(Token(TokenType::Whitespace, "\n"));

    REQUIRE(line.size() == 6);

    bool changed = line.trim();

    // After trimming, only the meaningful tokens should remain
    REQUIRE(changed == true);
    REQUIRE(line.size() == 2);
    REQUIRE(line[0].text() == "foo");
    REQUIRE(line[1].text() == "123");

    // Now trimming again should return false (no change)
    changed = line.trim();
    REQUIRE(changed == false);
}

// New tests: direct Token::Token(TokenType, const std::string&) constructor behavior
TEST_CASE("Token ctor infers keyword for Identifier and leaves others as None",
          "[token][ctor][identifier]") {
    // Known keyword (case-insensitive mapping performed in keyword_lookup)
    Token t1(TokenType::Identifier, "define");
    REQUIRE(t1.is(TokenType::Identifier));
    REQUIRE(t1.is(Keyword::DEFINE));

    // Non-keyword identifier
    Token t2(TokenType::Identifier, "NotAKeyword123");
    REQUIRE(t2.is(TokenType::Identifier));
    REQUIRE(t2.is(Keyword::None));
}

TEST_CASE("Token ctor parses Integer text into int_value_",
          "[token][ctor][integer]") {
    Token t_dec(TokenType::Integer, "123");
    REQUIRE(t_dec.is(TokenType::Integer));
    REQUIRE(t_dec.int_value() == 123);
    REQUIRE(t_dec.text() == "123");

    Token t_neg(TokenType::Integer, "-45");
    REQUIRE(t_neg.int_value() == -45);

    // Leading/trailing spaces are not trimmed here; stoi will throw if invalid.
    // Provide only well-formed numeric text.
    Token t_zero(TokenType::Integer, "0");
    REQUIRE(t_zero.int_value() == 0);
}

TEST_CASE("Token ctor parses Float text into float_value_",
          "[token][ctor][float]") {
    Token t_f1(TokenType::Float, "1.25");
    REQUIRE(t_f1.is(TokenType::Float));
    REQUIRE(t_f1.float_value() == Catch::Approx(1.25).epsilon(1e-12));

    Token t_f2(TokenType::Float, "-0.5");
    REQUIRE(t_f2.float_value() == Catch::Approx(-0.5).epsilon(1e-12));

    Token t_f3(TokenType::Float, "123."); // trailing dot form
    REQUIRE(t_f3.float_value() == Catch::Approx(123.0).epsilon(1e-12));
}

TEST_CASE("Token ctor unescapes String text into string_value_",
          "[token][ctor][string]") {
    // Raw source literal content (no surrounding quotes passed to constructor).
    // lexer passes original text including escapes but without enclosing quotes for TokenType::String.
    // Here we simulate that by giving an escaped interior; unescape_c_string should resolve it.
    Token t_str(TokenType::String, "\\n\\tA\\x41\\101\\\"");
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
    Token t_empty(TokenType::String, "");
    REQUIRE(t_empty.string_value().empty());
}

TEST_CASE("Token ctor leaves unrelated fields at defaults for non-matching types",
          "[token][ctor][defaults]") {
    Token t_ws(TokenType::Whitespace, " ");
    REQUIRE(t_ws.is(TokenType::Whitespace));
    // Should not parse as integer/float/string/keyword
    REQUIRE(t_ws.int_value() == 0);
    REQUIRE(t_ws.float_value() == 0.0);
    REQUIRE(t_ws.keyword() == Keyword::None);
    REQUIRE(t_ws.string_value().empty());

    Token t_plus(TokenType::Plus, "+");
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
        { TokenType::Whitespace, " \t" }
    };
    for (const auto& s : samples) {
        Token t(s.first, s.second);
        REQUIRE(t.text() == s.second);
    }
}

TEST_CASE("Token ctor integer/float throws on invalid numeric text (no catch here)",
          "[token][ctor][error][numeric]") {
    // Provide invalid integer; constructor should throw std::invalid_argument from stoi.
    REQUIRE_THROWS(Token(TokenType::Integer, "12x"));
    // Provide invalid float
    REQUIRE_THROWS(Token(TokenType::Float, "1.2.3"));
}

TEST_CASE("Token ctor string unescape handles hex and octal edge cases",
          "[token][ctor][string][escapes]") {
    // \x7 and \x4F plus octal \377
    Token t(TokenType::String, "\\x7\\x4F\\377");
    std::string expected;
    expected.push_back(static_cast<char>(0x07));
    expected.push_back(static_cast<char>(0x4F));
    expected.push_back(static_cast<char>(0xFF));
    REQUIRE(t.string_value() == expected);
}

