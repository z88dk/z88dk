//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../dump_context.h"
#include "../preproc.h"
#include <string>

void SrcLine::dump(DumpContext ctx) const {
    ctx.line("SrcLine {");
    auto child_ctx = ctx.child();
    child_ctx.line("text: \"" + text + "\"");
    child_ctx.line("filename: \"" + filename + "\"");
    child_ctx.line("line_num: " + std::to_string(line_num));
    ctx.line("}");
}

#endif
