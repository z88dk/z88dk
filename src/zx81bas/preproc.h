//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>

struct SrcLine {
    std::string text;		// line text
    std::string filename;	// source location
    int line_num;
};

bool preproc(std::string input_file, std::vector<SrcLine>& out_lines);
