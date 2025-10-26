//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../location.h"
#include "catch_amalgamated.hpp"

TEST_CASE("Location default constructor creates empty location", "[Location]") {
    Location loc;
    REQUIRE(loc.filename().empty());
    REQUIRE(loc.line_num() == 0);
    REQUIRE(loc.empty());
}

TEST_CASE("Location constructor sets filename and line number", "[Location]") {
    Location loc("foo.asm", 42);
    REQUIRE(loc.filename() == "foo.asm");
    REQUIRE(loc.line_num() == 42);
    REQUIRE_FALSE(loc.empty());
}

TEST_CASE("Location::clear resets filename and line number", "[Location]") {
    Location loc("bar.asm", 10);
    loc.clear();
    REQUIRE(loc.filename().empty());
    REQUIRE(loc.line_num() == 0);
    REQUIRE(loc.empty());
}

TEST_CASE("Location::set_filename and set_line_num update values",
          "[Location]") {
    Location loc;
    loc.set_filename("baz.asm");
    loc.set_line_num(99);
    REQUIRE(loc.filename() == "baz.asm");
    REQUIRE(loc.line_num() == 99);
    REQUIRE_FALSE(loc.empty());
}
