//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <vector>
#include "lexer.h"
#include "preproc_context.h"
#include "preproc_directives.h"

void expand_line(
    PreprocessorContext& ctx,
    const LogicalLine& in,
    std::vector<Token>& out_tokens);

