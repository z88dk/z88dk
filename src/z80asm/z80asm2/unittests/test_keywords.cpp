//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../keywords.h"
#include "catch_amalgamated.hpp"

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

TEST_CASE("trim removes leading and trailing whitespace", "[trim]") {
    REQUIRE(trim("   abc   ") == "abc");
    REQUIRE(trim("\t\txyz\t") == "xyz");
    REQUIRE(trim("  \t  test  \t ") == "test");
    REQUIRE(trim("") == "");
    REQUIRE(trim("nochange") == "nochange");
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
        REQUIRE(keyword_is_directive(to_keyword(d)));
        // also ensure lowercase works (to_keyword is case-insensitive)
        INFO("directive(lower): " << d);
        REQUIRE(keyword_is_directive(to_keyword(to_lower(d))));
    }

    // Some non-directives that must return false
    REQUIRE_FALSE(keyword_is_directive(to_keyword("LD")));
    REQUIRE_FALSE(keyword_is_directive(to_keyword("AF")));
    REQUIRE_FALSE(keyword_is_directive(to_keyword("NONEXISTENT")));
}

TEST_CASE("keyword_to_string returns the keyword text", "[keyword_to_string]") {
    REQUIRE(keyword_to_string(Keyword::None) == "None");
    REQUIRE(keyword_to_string(Keyword::LD) == "LD");
    REQUIRE(keyword_to_string(Keyword::AF) == "AF");
    REQUIRE(keyword_to_string(Keyword::AF_) == "AF'");
    REQUIRE(keyword_to_string(Keyword::DEFINE) == "DEFINE");
    REQUIRE(keyword_to_string(Keyword::REPT) == "REPT");
}

