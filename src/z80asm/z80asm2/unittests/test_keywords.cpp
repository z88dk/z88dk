//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../keywords.h"
#include "catch_amalgamated.hpp"
#include <cctype>

TEST_CASE("keyword_lookup converts strings to Keyword enum",
          "[keyword_lookup]") {
    REQUIRE(keyword_lookup("LD") == Keyword::LD);
    REQUIRE(keyword_lookup("ld") == Keyword::LD);
    REQUIRE(keyword_lookup("Ld") == Keyword::LD);
    REQUIRE(keyword_lookup("AF") == Keyword::AF);
    REQUIRE(keyword_lookup("af") == Keyword::AF);
    REQUIRE(keyword_lookup("Af") == Keyword::AF);
    REQUIRE(keyword_lookup("AF'") == Keyword::AF_);
    REQUIRE(keyword_lookup("af'") == Keyword::AF_);
    REQUIRE(keyword_lookup("Af'") == Keyword::AF_);
    REQUIRE(keyword_lookup("NONEXISTENT") == Keyword::None);
    REQUIRE(keyword_lookup("") == Keyword::None);
}

TEST_CASE("keyword_is_directive recognizes directive keywords",
          "[keyword_is_directive]") {
    // Known directive keywords that should return true
    const std::vector<std::string> directives = {
        "MACRO", "ENDM", "DEFINE", "DEFL", "INCLUDE", "UNDEF",
        "LINE", "EXITM"
    };

    for (const auto& d : directives) {
        INFO("directive: " << d);
        REQUIRE(keyword_is_directive(keyword_lookup(d)));
        // also ensure lowercase works (keyword_lookup is case-insensitive)
        INFO("directive(lower): " << d);
        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_directive(keyword_lookup(lower)));
    }

    // Some non-directives that must return false
    REQUIRE_FALSE(keyword_is_directive(keyword_lookup("LD")));
    REQUIRE_FALSE(keyword_is_directive(keyword_lookup("AF")));
    REQUIRE_FALSE(keyword_is_directive(keyword_lookup("NONEXISTENT")));
}

TEST_CASE("keyword_to_string returns the keyword text", "[keyword_to_string]") {
    REQUIRE(keyword_to_string(Keyword::None) == "None");
    REQUIRE(keyword_to_string(Keyword::LD) == "LD");
    REQUIRE(keyword_to_string(Keyword::AF) == "AF");
    REQUIRE(keyword_to_string(Keyword::AF_) == "AF'");
    REQUIRE(keyword_to_string(Keyword::DEFINE) == "DEFINE");
    REQUIRE(keyword_to_string(Keyword::REPT) == "REPT");
}

