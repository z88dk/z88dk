//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include <cstdint>
#include <string>
#include <vector>

bool encode_zx81_char(const char*& p, bool check_keywords,
                      uint8_t& out_code,
                      const SourceLoc& loc);
bool encode_zx81_string(const char*& p, char delimiter,
                        std::vector<uint8_t>& bytes,
                        const SourceLoc& loc);
