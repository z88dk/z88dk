//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "hla.h"
#include "hla_impl.h"
#include "lexer_tokens.h"
#include <vector>

// driver function
std::vector<LogicalLine> hla_process(const std::vector<LogicalLine>& lines) {
    auto program = hla_parse(lines);
    hla_semantic_check(*program);
    return hla_lower(*program);
}
