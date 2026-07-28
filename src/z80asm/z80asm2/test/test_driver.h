//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#pragma once

#include <string_view>
#include <vector>

bool run_test(std::string_view test_name);
const std::vector<std::string_view>& test_names();

#endif
