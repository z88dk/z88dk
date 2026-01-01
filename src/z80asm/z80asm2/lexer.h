//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "file_cache.h"
#include "keywords.h"
#include "location.h"
#include "options.h"
#include <deque>
#include <filesystem>
#include <functional>
#include <memory>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// Token types
//-----------------------------------------------------------------------------

enum class TokenType {
    // Special, must be zero
    EndOfLine,

    // Literals
    Identifier,
    Integer,
    Float,
    String,

    // Operators
    Plus,           // +
    Minus,          // -
    Multiply,       // *
    Divide,         // /
    Modulo,         // %
    Power,          // **

    BitwiseAnd,     // &
    BitwiseOr,      // |
    BitwiseXor,     // ^
    BitwiseNot,     // ~
    LeftShift,      // <<
    RightShift,     // >>

    LogicalAnd,     // &&
    LogicalOr,      // ||
    LogicalXor,     // ^^
    LogicalNot,     // !

    EQ,             // =
    NE,             // !=
    LT,             // <
    LE,             // <=
    GT,             // >
    GE,             // >=

    // Delimiters
    LeftParen,      // (
    RightParen,     // )
    LeftBracket,    // [
    RightBracket,   // ]
    LeftBrace,      // {
    RightBrace,     // }
    Comma,          // ,
    Colon,          // :
    Dot,            // .
    Question,       // ?
    Hash,           // #
    DoubleHash,     // ##
    At,             // @
    Dollar,         // $
    Backslash,      // (backslash)

    // Assembly instruction pointer
    ASMPC,

    // disambiguate +register from +expression
    PlusA,          // +A
    PlusBC,         // +BC
    PlusDE,         // +DE
    PlusHL,         // +HL
    PlusIX,         // +IX
    PlusIY,         // +IY
};

//-----------------------------------------------------------------------------
// Token class
//-----------------------------------------------------------------------------

class Token {
public:
    Token(TokenType type, const std::string& text, bool has_space_after);

    // Constructor for Integer token with precomputed value
    explicit Token(TokenType type, const std::string& text,
                   int value, bool has_space_after);

    // Constructor for Float token with precomputed value
    explicit Token(TokenType type, const std::string& text,
                   double value, bool has_space_after);

    // Constructor for String token with precomputed value
    explicit Token(TokenType type, const std::string& text,
                   std::string value, bool has_space_after);

    // Constructor for Identifier token with keyword
    explicit Token(TokenType type, const std::string& text,
                   Keyword keyword, bool has_space_after);

    bool is(TokenType t) const;
    bool is(Keyword kw) const;

    bool is_not(TokenType t) const;
    bool is_not(Keyword kw) const;

    // Read-only accessors
    TokenType type() const;
    const std::string& text() const;
    int int_value() const;
    double float_value() const;
    const std::string& string_value() const;
    Keyword keyword() const;
    bool has_space_after() const;

private:
    TokenType type_;
    std::string text_;          // Original token string
    int int_value_ = 0;         // Used if type == Integer
    double float_value_ = 0.0;  // Used if type == Float
    std::string string_value_;  // Used if type == String (escape-resolved)
    Keyword keyword_ =
        Keyword::None;  // Used if type == Identifier and is a keyword
    bool has_space_after_ = false;
};

//-----------------------------------------------------------------------------
// TokenLine class - represents a tokenized source line
//-----------------------------------------------------------------------------

class TokenLine {
public:
    TokenLine() = default;
    explicit TokenLine(const Location& location);
    TokenLine(const Location& location, const std::vector<Token>& tokens);

    void clear();

    const Location& location() const;
    Location& location();
    void set_location(const Location& location);

    std::vector<Token>& tokens();
    const std::vector<Token>& tokens() const;

    bool has_token_type(TokenType tt) const;

    // Reconstruct the line by concatenating original token texts
    std::string to_string() const;

private:
    Location location_;
    std::vector<Token> tokens_;
};

//-----------------------------------------------------------------------------
// Token cache for file-based tokenization
//-----------------------------------------------------------------------------

class TokenCache {
public:
    // Get cached tokens for a file. Returns nullptr if not cached or invalid.
    // Also outputs cached preprocessor flags if available.
    std::shared_ptr<const std::vector<TokenLine>> get(
                const std::string& filename,
                bool& has_pragma_once,
                bool& has_ifndef_guard,
                std::string& ifndef_guard_symbol);

    // Store tokenized result in cache without copying the vector
    void put(const std::string& filename,
             std::shared_ptr<const std::vector<TokenLine>> token_lines,
             bool has_pragma_once,
             bool has_ifndef_guard,
             std::string ifndef_guard_symbol);

    void clear();

#ifdef UNIT_TESTS
    // Test-only methods
    size_t cache_size() const {
        return cache_.size();
    }
    bool has_cached(const std::string& filename) const {
        auto key = make_cache_key(filename);
        return key && cache_.find(*key) != cache_.end();
    }
#endif

private:
    struct CacheKey {
        std::string filename;
        std::filesystem::file_time_type mtime;
        std::uintmax_t file_size;

        bool operator==(const CacheKey& other) const {
            return filename == other.filename &&
                   mtime == other.mtime &&
                   file_size == other.file_size;
        }
    };

    struct CacheKeyHash {
        size_t operator()(const CacheKey& k) const {
            size_t h1 = std::hash<std::string> {}(k.filename);
            size_t h2 = std::hash<std::filesystem::file_time_type::rep> {}(
                            k.mtime.time_since_epoch().count());
            size_t h3 = std::hash<std::uintmax_t> {}(k.file_size);
            return h1 ^ (h2 << 1) ^ (h3 << 2);
        }
    };

    struct CachedEntry {
        std::shared_ptr<const std::vector<TokenLine>> token_lines;
        Options options_snapshot;  // Cache is invalidated if options change
        bool has_pragma_once_ = false;
        bool has_ifndef_guard_ = false;
        std::string ifndef_guard_symbol_;
    };

    std::optional<CacheKey> make_cache_key(const std::string& filename) const;
    bool options_match(const Options& cached, const Options& current) const;

    std::unordered_map<CacheKey, CachedEntry, CacheKeyHash> cache_;
};

//-----------------------------------------------------------------------------
// TokenFileReader class - reads and tokenizes a source file
//-----------------------------------------------------------------------------

class TokenFileReader : public FileReader {
public:
    TokenFileReader() = default;
    explicit TokenFileReader(const std::string& filename);
    bool open(const std::string& filename) override;
    bool next_token_line(TokenLine& token_line);

#ifdef UNIT_TESTS
    static TokenCache& get_cache_for_testing() {
        return get_cache();
    }
    bool is_using_cache() const {
        return use_cached_mode_;
    }
#endif

    // include guard detection accessors
    bool has_pragma_once() const;
    bool has_ifndef_guard() const;
    const std::string& ifndef_guard_symbol() const;

    // Inject lines into the reader; they take precedence over file/cached content.
    void inject(const std::string& filename, size_t line_number, bool fixed_line_number,
                const std::string& content);
    void inject_tokens(const std::vector<TokenLine>& lines);

    // Line provider abstraction: set a custom provider for subsequent physical line reads.
    // The provider should return true and write the next physical line into 'out',
    // or return false when no more lines are available.
    void set_line_provider(std::function<bool(std::string& out)> provider);
    std::function<bool(std::string&)> get_line_provider() const;

    // line number setters must update lines in output_queue_ as well
    void set_line_number(size_t line_num) override;
    void set_fixed_line_number(size_t line_num) override;

    static int g_provider_calls_in_session; // count of line provider calls in current session

private:
    // Cache-related members
    static TokenCache& get_cache();
    bool use_cached_mode_ = false;

    // Shared cached lines (no copy)
    std::shared_ptr<const std::vector<TokenLine>> cached_lines_ptr_;
    size_t current_line_index_ = 0;

    // Accumulated lines for eventual cache population during reading
    std::vector<TokenLine> pending_cache_lines_;

    // Existing members
    std::string source_line_;
    std::deque<TokenLine> output_queue_;
    bool is_injected_ = false;

    // Queue of injected token lines that are returned first (split into logical lines).
    std::deque<TokenLine> injected_tokens_;

    // Line provider used by tokenize_line to fetch the next physical line.
    // Defaults to the underlying FileReader::next_line.
    std::function<bool(std::string&)> line_provider_;

    // Include guards
    bool has_pragma_once_ = false;
    bool has_ifndef_guard_ = false;
    std::string ifndef_guard_symbol_;
    enum class DetectIfndefState {
        Initial, FoundIfndef, Final
    };
    DetectIfndefState detect_ifndef_state_ = DetectIfndefState::Initial;
    enum class DetectPragmaState {
        Initial, Final
    };
    DetectPragmaState detect_pragma_state_ = DetectPragmaState::Initial;

    bool tokenize_line(TokenLine& token_line);
    void inject(const std::string& filename, const std::string& content) override;

    // Updated: split into the provided target queue (output or injected)
    void split_lines(const TokenLine& line,
                     std::deque<TokenLine>& target_queue);
    void split_labels(const TokenLine& line, size_t& i,
                      std::deque<TokenLine>& target_queue);
    bool is_define(const TokenLine& line);

    // Helper to check cache after opening
    void check_cache();
    void accumulate_for_cache(const TokenLine& token_line);
    void persist_cache();

    // Helper used by the lexer/re2c-generated code to advance to the next physical line.
    bool next_line_from_provider();
    bool read_and_tokenize_line(TokenLine& token_line);

    // Detect include guards while reading the file from the provider
    void detect_include_guard(const TokenLine& line);
};
