//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <cstdint>

void remove_file(const std::string& filename);
std::string normalize_path(const std::string& path);

#ifdef _DEBUG
void cat_file(const std::string& filename);
#endif

bool str_ends_with(const std::string& str, const std::string& ending);
std::string str_tolower(std::string str);
std::string str_toupper(std::string str);
std::string int_to_hex(uint8_t value);
