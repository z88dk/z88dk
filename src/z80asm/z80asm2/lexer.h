//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "file_cache.h"
#include "keywords.h"
#include "location.h"
#include "options.h"
#include <deque>
#include <filesystem>
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
    // Get cached tokens for a file, returns nullopt if not cached or invalid
    std::optional<std::vector<TokenLine>> get(const std::string& filename);

    // Store tokenized result in cache
    void put(const std::string& filename, std::vector<TokenLine> token_lines);

    // Clear all cache entries
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
        std::vector<TokenLine> token_lines;
        Options options_snapshot;  // Cache is invalidated if options change
    };

    // Make this const so it can be called from const test methods
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

    // Override open to handle cache lookup
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

    // Inject pre-tokenized lines into the reader; they take precedence over file/cached content.
    void inject_tokens(const std::vector<TokenLine>& lines);

private:
    // Cache-related members
    static TokenCache& get_cache();
    bool use_cached_mode_ = false;
    std::vector<TokenLine> cached_lines_;
    size_t current_line_index_ = 0;
    std::vector<TokenLine> pending_cache_lines_;

    // Existing members
    std::string source_line_;
    std::deque<TokenLine> output_queue_;

    // Queue of injected token lines that are returned first (split into logical lines).
    std::deque<TokenLine> injected_tokens_;

    bool tokenize_line(TokenLine& token_line);
    // Updated: split into the provided target queue (output or injected)
    void split_lines(const TokenLine& input_line,
                     std::deque<TokenLine>& target_queue);

    // Helper to check cache after opening
    void check_cache();
};
