//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "dump_context.h"
#include "errors.h"
#include <string>
#include <utility>
#include <vector>

struct SrcLine : TreeNode {
    std::string text;		// line text
    SourceLoc loc;          // source location

    explicit SrcLine() = default;
    explicit SrcLine(const std::string& text_, std::string filename_, int line_num_)
        : text(text_), loc(filename_, line_num_) {}

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

bool preproc(std::string input_file, std::vector<SrcLine>& out_lines);

// used during lexing, where pragmas are !ASM and !ENDASM
bool match_ASM(const std::string& text, const SourceLoc& loc);
bool match_BASIC(const std::string& text, const SourceLoc& loc);
