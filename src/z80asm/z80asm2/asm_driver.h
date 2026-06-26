//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <string_view>
#include <vector>

void assemble_files(const std::vector<std::string>& filenames,
                    std::string_view output_dir);
void assemble_file(std::string_view filename, std::string_view output_dir);
