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

    // to_string concatenates original token texts
    REQUIRE(line.to_string() == "foo123");

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
    TokensFile tf(content, "virtual2", 1);
    REQUIRE(tf.line_count() == 3);
    REQUIRE(tf.get_line(0) == "a");
    REQUIRE(tf.get_line(1) == "b");
    REQUIRE(tf.get_line(2) == "c");
}

TEST_CASE("empty content produces no token lines", "[lexer]") {
    g_options = Options();

    const std::string content = "\n\r\n\n"; // only empty lines
    TokensFile tf(content, "empty", 1);
    REQUIRE(tf.line_count() == 3);
    REQUIRE(tf.tok_lines_count() == 0);
}

TEST_CASE("TokensFile tokenizes all TokenType values", "[lexer][token_types]") {
    g_options = Options();

    // Build a single line that contains examples of each token type (except EndOfFile).
    // Note: backslash is included as a standalone token; whitespace is produced between tokens.
    const std::string content = "id 123 1.23 \"str\" + \\ , . ( ) [ ] { }\n";
    TokensFile tf(content, "types_test", 1);

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
        TokenType::Operator,
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

TEST_CASE("TokensFile tokenizes all OperatorType values",
          "[lexer][operator_types]") {
    g_options = Options();

    // Construct one line that includes representative symbols for operator tokens.
    // Some operator tokens are multi-character and must be contiguous (e.g. '!=', '<<', '^^', '**', '##').
    const std::string content =
        "! != ~ ^ ^^ & && * ** / % + - << >> < <= > >= = ? : # ## | ||\n";

    TokensFile tf(content, "op_test", 1);
    REQUIRE(tf.tok_lines_count() == 1);

    const TokensLine& tl = tf.get_tok_line(0);
    const auto& toks = tl.tokens();

    // Collect operator token OperatorType values in the order they appear.
    std::vector<OperatorType> seen;
    for (const auto& t : toks) {
        if (t.type() == TokenType::Operator) {
            seen.push_back(t.op());
        }
    }

    std::vector<OperatorType> expected = {
        OperatorType::LogicalNot,   // "!"
        OperatorType::NE,           // "!="
        OperatorType::BitwiseNot,   // "~"
        OperatorType::BitwiseXor,   // "^" (single)
        OperatorType::LogicalXor,   // "^^"
        OperatorType::BitwiseAnd,   // "&"
        OperatorType::LogicalAnd,   // "&&"
        OperatorType::Multiply,     // "*"
        OperatorType::Power,        // "**"
        OperatorType::Divide,       // "/"
        OperatorType::Modulus,      // "%"
        OperatorType::Plus,         // "+"
        OperatorType::Minus,        // "-"
        OperatorType::ShiftLeft,    // "<<"
        OperatorType::ShiftRight,   // ">>"
        OperatorType::LT,           // "<"
        OperatorType::LE,           // "<="
        OperatorType::GT,           // ">"
        OperatorType::GE,           // ">="
        OperatorType::EQ,           // "="
        OperatorType::Quest,        // "?"
        OperatorType::Colon,        // ":"
        OperatorType::Hash,         // "#"
        OperatorType::DoubleHash,   // "##"
        OperatorType::BitwiseOr,    // "|"
        OperatorType::LogicalOr     // "||"
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
    TokensFile tf(content, "comment_semicolon", 1);

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
    TokensFile tf(content, "comment_double_slash", 1);

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
    TokensFile tf(content, "comment_c_style", 1);

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
    const std::string content = "123 123d 1Ah $FF 0xAB 1011b %1011 @1011 0b1011\n";
    TokensFile tf(content, "int_formats", 1);

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
    TokensFile tf(content, "char_test", 1);

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
    TokensFile tf_empty(content_empty, "char_err_empty", 1);

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
    TokensFile tf_multi(content_multi, "char_err_multi", 1);

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
    TokensFile tf(content, "kw_quote_test", 1);

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
    TokensFile tf(content, "kw_then_char", 1);

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
    TokensFile tf(content, "unclosed_comment", 1);

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
    TokensFile tf(content, "unclosed_dquote", 1);

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
    TokensFile tf(content, "unclosed_squote", 1);

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
    TokensFile tf(content, "ucase_test", 1);

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
    TokensFile tf2(content2, "ucase_kw", 1);
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
    TokensFile tf_off(content, "swap_off", 1);
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

    TokensFile tf_on(content, "swap_on", 1);
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
