//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../expr.h"
#include "catch_amalgamated.hpp"

TEST_CASE("dummy passing test", "[expr][dummy]") {
    REQUIRE(true);
}

