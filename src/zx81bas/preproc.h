//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "dump_context.h"
#include <string>
#include <utility>
#include <vector>

struct SrcLine : TreeNode {
    std::string text;		// line text
    std::string filename;	// source location
    int line_num = 0;

    SrcLine() = default;
    SrcLine(std::string text_, std::string filename_, int line_num_)
        : text(std::move(text_)),
          filename(std::move(filename_)),
          line_num(line_num_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

bool preproc(std::string input_file, std::vector<SrcLine>& out_lines);

// used during lexing, where pragmas are !ASM and !BASIC
bool match_ASM(const std::string& text);
bool match_BASIC(const std::string& text);
