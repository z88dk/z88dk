//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>

#define release_assert(expr) do { \
        if (!(expr)) { \
            std::cerr << "internal error: " << #expr << std::endl \
                      << "file: " << __FILE__ << std::endl \
                      << "line: " << __LINE__ << std::endl \
                      << "please report this error" << std::endl; \
        } \
    } while (0)
