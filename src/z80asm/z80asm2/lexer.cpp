//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <memory>

//-----------------------------------------------------------------------------
// Token implementation
//-----------------------------------------------------------------------------

Token::Token(TokenType type, const std::string& text, bool has_space_after)
    : type_(type), text_(text), has_space_after_(has_space_after) {
    switch (type) {
    case TokenType::Identifier:
        keyword_ = keyword_lookup(text);
        break;
    case TokenType::Integer: {
        size_t pos = 0;
        int_value_ = std::stoi(text, &pos);
        if (pos != text.size()) {
            throw std::invalid_argument("Trailing chars in integer: " + text);
        }
        break;
    }
    case TokenType::Float: {
        size_t pos = 0;
        float_value_ = std::stod(text, &pos);
        if (pos != text.size()) {
            throw std::invalid_argument("Trailing chars in float: " + text);
        }
        break;
    }
    case TokenType::String:
        string_value_ = unescape_c_string(text);
        break;
    default:
        ;
    }
}

Token::Token(TokenType type, const std::string& text,
             int value, bool has_space_after)
    : type_(type), text_(text)
    , int_value_(value), has_space_after_(has_space_after) {
}

Token::Token(TokenType type, const std::string& text,
             double value, bool has_space_after)
    : type_(type), text_(text)
    , float_value_(value), has_space_after_(has_space_after) {
}

Token::Token(TokenType type, const std::string& text,
             std::string value, bool has_space_after)
    : type_(type), text_(text)
    , string_value_(value), has_space_after_(has_space_after) {
}

Token::Token(TokenType type, const std::string& text,
             Keyword keyword, bool has_space_after)
    : type_(type), text_(text)
    , keyword_(keyword), has_space_after_(has_space_after) {
}

bool Token::is(TokenType t) const {
    return type_ == t;
}

bool Token::is(Keyword kw) const {
    return keyword_ == kw;
}

bool Token::is_not(TokenType t) const {
    return type_ != t;
}

bool Token::is_not(Keyword kw) const {
    return keyword_ != kw;
}

// Read-only accessors
TokenType Token::type() const {
    return type_;
}

const std::string& Token::text() const {
    return text_;
}

int Token::int_value() const {
    return int_value_;
}

double Token::float_value() const {
    return float_value_;
}

const std::string& Token::string_value() const {
    return string_value_;
}

Keyword Token::keyword() const {
    return keyword_;
}

bool Token::has_space_after() const {
    return has_space_after_;
}

//-----------------------------------------------------------------------------
// TokenLine implementation
//-----------------------------------------------------------------------------

TokenLine::TokenLine(const Location& location)
    : location_(location) {
}

TokenLine::TokenLine(const Location& location,
                     const std::vector<Token>& tokens)
    : location_(location), tokens_(tokens) {
}

void TokenLine::clear() {
    location_.clear();
    tokens_.clear();
}

const Location& TokenLine::location() const {
    return location_;
}

Location& TokenLine::location() {
    return location_;
}

void TokenLine::set_location(const Location& location) {
    location_ = location;
}

std::vector<Token>& TokenLine::tokens() {
    return tokens_;
}

const std::vector<Token>& TokenLine::tokens() const {
    return tokens_;
}

bool TokenLine::has_token_type(TokenType tt) const {
    for (const auto& t : tokens_) {
        if (t.is(tt)) {
            return true;
        }
    }
    return false;
}

// Reconstruct the line by concatenating the original token texts in order.
// Insert spaces where necessary to avoid accidental re-scanning into different tokens:
//  - always insert a space between Identifier, Integer and Float tokens when adjacent
//  - insert a space between tokens whose concatenation would form a multi-character operator
std::string TokenLine::to_string() const {
    std::string out;
    out.reserve(tokens_.size() * 4);

    // list of multi-character operator strings that must not be produced by direct concatenation
    static const std::vector<std::string> problematic = {
        "<<", ">>", "<=", ">=", "==", "!=", "<>",
        "&&", "||", "^^", "**", "##"
    };

    auto is_idnum = [](TokenType t) {
        return t == TokenType::Identifier || t == TokenType::Integer ||
               t == TokenType::Float;
    };

    for (size_t i = 0; i < tokens_.size(); ++i) {
        const auto& tok = tokens_[i];
        char last_char = out.empty() ? ' ' : out.back();
        char first_char = tok.text().empty() ? ' ' : tok.text().front();

        if (i > 0 && last_char != ' ') {
            const auto& prev = tokens_[i - 1];

            bool need_space = false;
            if (is_idnum(prev.type()) && is_idnum(tok.type())) {
                need_space = true;
            }
            else if (prev.type() == TokenType::Dollar && is_hex_char(first_char)) {
                // $ followed by hex digit could be part of a hex number
                need_space = true;
            }
            else if ((prev.type() == TokenType::Modulo || prev.type() == TokenType::At) &&
                     is_bin_char(first_char)) {
                // % followed by number could be part of a binary number
                need_space = true;
            }
            else {
                std::string concat = prev.text() + tok.text();
                if (std::find(problematic.begin(), problematic.end(),
                              concat) != problematic.end()) {
                    need_space = true;
                }
            }

            if (need_space) {
                out += ' ';
            }
        }

        switch (tok.type()) {
        case TokenType::Integer:
            out += std::to_string(tok.int_value());
            break;
        default:
            out += tok.text();
            break;
        }

        last_char = out.empty() ? ' ' : out.back();
        if (last_char != ' ' && tok.has_space_after()) {
            out += ' ';
        }
    }

    return trim(out);
}

//-----------------------------------------------------------------------------
// TokenFileReader implementation
//-----------------------------------------------------------------------------

int TokenFileReader::g_provider_calls_in_session = 0;

TokenFileReader::TokenFileReader(const std::string& filename)
    : FileReader(filename) {
    open(filename);
}

bool TokenFileReader::open(const std::string& filename) {
    is_injected_ = false;

    // Do not install a default provider that captures `this`.
    line_provider_ = nullptr;

    return FileReader::open(filename);
}

bool TokenFileReader::next_line_from_provider() {
    // If a provider is installed (e.g., for injected content), use it.
    if (line_provider_) {
        // Count only provider-driven fetches; FileReader::next_line does not affect injected text.
        bool ok = line_provider_(source_line_);
        if (ok) {
            ++g_provider_calls_in_session;
        }
        return ok;
    }

    // Normal path: call FileReader directly; no lambda, no captured pointers.
    return FileReader::next_line(source_line_);
}

void TokenFileReader::set_line_provider(std::function<bool(std::string&)> provider) {
    line_provider_ = std::move(provider);
}

inline std::function<bool(std::string&)> TokenFileReader::get_line_provider() const {
    return line_provider_;
}

void TokenFileReader::set_line_number(size_t line_num) {
    FileReader::set_line_number(line_num);
    // update line numbers in output queue
    for (auto& line : output_queue_) {
        line.location().set_line_num(line_num);
    }
}

void TokenFileReader::set_fixed_line_number(size_t line_num) {
    FileReader::set_fixed_line_number(line_num);
    // update line numbers in output queue
    for (auto& line : output_queue_) {
        line.location().set_line_num(line_num);
    }
}

bool TokenFileReader::read_and_tokenize_line(TokenLine& token_line) {
    if (!next_line_from_provider()) {
        return false;
    }

    token_line.clear();
    size_t start_line_number = line_number_;
    if (tokenize_line(token_line)) {
        token_line.set_location(Location(filename_, start_line_number));
        split_lines(token_line, output_queue_);
    }
    return true;
}

bool TokenFileReader::next_token_line(TokenLine& token_line) {
    // 1) Injected tokens
    if (!injected_tokens_.empty()) {
        token_line = std::move(injected_tokens_.front());
        injected_tokens_.pop_front();

        g_errors.set_location(token_line.location());
        g_errors.set_expanded_line(token_line.to_string());
        return true;
    }

    // 2) Normal path
    while (true) {
        if (!output_queue_.empty()) {
            token_line = std::move(output_queue_.front());
            output_queue_.pop_front();

            g_errors.set_location(token_line.location());
            g_errors.set_expanded_line(token_line.to_string());
            return true;
        }

        token_line.clear();
        while (token_line.tokens().empty()) {
            if (!read_and_tokenize_line(token_line)) {
                return false;
            }
        }
    }
    return true;
}

void TokenFileReader::inject(const std::string& filename, const std::string& content) {
    (void)filename; // uset the current filename_ instead
    inject(filename, 1, false, content);
}

void TokenFileReader::inject(const std::string& filename, size_t line_number,
                             bool fixed_line_number, const std::string& content) {
    is_injected_ = true;
    std::vector<std::string> lines = ::split_lines(content);
    filename_ = filename;
    line_number_ = line_number - (fixed_line_number ? 0 : 1);
    fixed_line_number_ = fixed_line_number;

    // Save current provider (may be null)
    auto save_provider = get_line_provider();

    // Self-contained provider owning its data; used only during injection
    struct LinesProvider {
        std::vector<std::string> lines;
        size_t idx = 0;
        bool operator()(std::string& out) {
            if (idx >= lines.size()) {
                return false;
            }
            out = lines[idx++];
            return true;
        }
    };
    auto lp = std::make_shared<LinesProvider>(LinesProvider{ std::move(lines), 0 });
    set_line_provider([lp](std::string & out) {
        return (*lp)(out);
    });

    // Consume lines and tokenize into injected queue
    while (lp->idx < lp->lines.size()) {
        if (!fixed_line_number_) {
            ++line_number_;
        }

        source_line_ = lp->lines[lp->idx++];
        Location location(filename_, line_number_);
        g_errors.set_location(location);

        // Begin a new tokenize session; reset provider call counter
        g_provider_calls_in_session = 0;

        TokenLine tl(location);
        if (tokenize_line(tl)) {
            // If tokenize_line consumed N additional physical lines via the provider
            // (e.g., due to line continuation), advance the current line number accordingly.
            if (!fixed_line_number_ && g_provider_calls_in_session > 0) {
                line_number_ += g_provider_calls_in_session;
            }
            split_lines(tl, injected_tokens_);
        }
    }

    // Restore previous provider (or none)
    set_line_provider(save_provider);
}

void TokenFileReader::inject_tokens(const std::vector<TokenLine>& lines) {
    is_injected_ = true;
    // Split injected lines into logical lines using the same splitting rules.
    for (const auto& tl : lines) {
        split_lines(tl, injected_tokens_);
    }
}

//-----------------------------------------------------------------------------
// split_lines implementation (updated to use target_queue)
//-----------------------------------------------------------------------------

void TokenFileReader::split_lines(const TokenLine& line,
                                  std::deque<TokenLine>& target_queue) {
    const auto& tokens = line.tokens();

    // empty lines produce no result
    if (tokens.empty()) {
        return;
    }

    // Do not split lines that start with DEFINE
    if (is_define(line)) {
        target_queue.push_back(line);
        return;
    }

    // split labels at start of line
    size_t i = 0;
    split_labels(line, i, target_queue);

    // split the rest of the line
    TokenLine current_line(line.location());
    int ternary_level = 0;  // Track nesting level of ternary operators

    auto split_line = [&]() {
        if (!current_line.tokens().empty()) {
            target_queue.push_back(current_line);
            current_line.tokens().clear();
        }
        ternary_level = 0;
    };

    for (; i < line.tokens().size(); ++i) {
        const Token& token = line.tokens()[i];

        if (token.is(TokenType::Question)) {
            ternary_level++;
        }
        else if (token.is(TokenType::Colon)) {
            // is this colon after a segment override? (e.g., "A:")
            if (i > 0 &&
                    !tokens[i - 1].has_space_after() &&
                    keyword_is_segment_register(line.tokens()[i - 1].keyword())) {
                // fall through, do not split
            }
            // is this colon part of a ternary operator?
            else if (ternary_level > 0) {
                ternary_level--;
                // fall through, do not split
            }
            else {
                // this colon splits the line
                split_line();
                continue;
            }
        }
        else if (token.is(TokenType::Backslash)) {
            split_line();
            continue;
        }

        current_line.tokens().push_back(token);
    }

    split_line();   // move the last line if any
}

void TokenFileReader::split_labels(const TokenLine& line, size_t& i, std::deque<TokenLine>& target_queue) {
    const auto& tokens = line.tokens();

    while (true) {
        // .label
        if (i + 1 < tokens.size() &&
                tokens[i].is(TokenType::Dot) &&
                tokens[i + 1].is(TokenType::Identifier)) {

            TokenLine label_line(line.location());
            label_line.tokens().push_back(tokens[i]);     // Dot
            label_line.tokens().push_back(tokens[i + 1]); // Identifier
            target_queue.push_back(label_line);
            i += 2;
            continue;
        }

        // label:
        if (i + 1 < tokens.size() &&
                tokens[i].is(TokenType::Identifier) &&
                tokens[i + 1].is(TokenType::Colon) &&
                !keyword_is_instruction(tokens[i].keyword())) {

            TokenLine label_line(line.location());
            label_line.tokens().push_back(Token(TokenType::Dot, ".", false)); // Dot
            label_line.tokens().push_back(tokens[i]);     // Identifier
            target_queue.push_back(label_line);
            i += 2;
            continue;
        }

        break;
    }
}

bool TokenFileReader::is_define(const TokenLine& line) {
    const auto& tokens = line.tokens();
    // Case 1: "#define ..."
    if (tokens.size() >= 2 &&
            tokens[0].is(TokenType::Hash) &&
            tokens[1].is(Keyword::DEFINE)) {
        return true;
    }

    // Case 2: "define ..."
    if (tokens.size() >= 1 &&
            tokens[0].is(Keyword::DEFINE)) {
        return true;
    }

    // Case 3: "NAME define ..."
    if (tokens.size() >= 2 &&
            tokens[0].is(TokenType::Identifier) &&
            tokens[1].is(Keyword::DEFINE)) {
        return true;
    }

    return false;
}
