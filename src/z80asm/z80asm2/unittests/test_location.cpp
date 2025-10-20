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

TEST_CASE("Location::set_logical_line_num computes logical line number",
          "[Location]") {
    Location loc("foo.asm", 1);
    // Simulate #line 100 at physical line 10, now at physical line 15
    loc.set_logical_line_num(100, 10, 15);
    // Should be 100 + (15-10) - 1 = 104
    // (-1 because #line N means next line is N)
    REQUIRE(loc.line_num() == 104);
}

TEST_CASE("Location::set_physical_line_num sets line number", "[Location]") {
    Location loc("foo.asm", 1);
    loc.set_physical_line_num(123);
    REQUIRE(loc.line_num() == 123);
}

TEST_CASE("Location::inc_line_num increments line number when enabled",
          "[Location]") {
    Location loc("foo.asm", 5);
    loc.inc_line_num();
    REQUIRE(loc.line_num() == 6);
}

TEST_CASE("Location::set_inc_line_nums disables and enables incrementing",
          "[Location]") {
    Location loc("foo.asm", 10);
    loc.set_inc_line_nums(false);
    loc.inc_line_num();
    REQUIRE(loc.line_num() == 10); // Should not increment
    loc.set_inc_line_nums(true);
    loc.inc_line_num();
    REQUIRE(loc.line_num() == 11); // Should increment now
}
