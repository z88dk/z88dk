//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "hla.h"
#include "hla_impl.h"
#include "lexer_tokens.h"
#include <vector>
#include "diag.h"

// driver function
std::vector<LogicalLine> hla_process(const std::vector<LogicalLine>& lines) {
    auto start_errors = g_diag.get_error_count();
    auto program = hla_parse(lines);
    hla_semantic_check(*program);

    if (g_diag.get_error_count() != start_errors) {
        // If there were errors during parsing or semantic check, return an empty
        // output to avoid generating potentially invalid assembly code.
        return {};
    }
    return hla_lower(*program);
}
