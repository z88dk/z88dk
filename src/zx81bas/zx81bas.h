//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

static inline const std::string SYMBOL_PREFIX = "ZX81BAS";
static inline const std::string CPP_DEFINE = "__" + SYMBOL_PREFIX + "__";
static inline const std::string END_OF_PROGRAM =
    SYMBOL_PREFIX + "ENDOFPROGRAM";
