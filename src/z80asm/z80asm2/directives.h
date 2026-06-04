//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "expr.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include <memory>

std::unique_ptr<Stmt> parse_directive(ParseLine& pline, const SourceLoc& loc,
                                      ParseStatus& status);
