//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "preproc_dump.h"
#include "preproc_context.h"
#include "lexer_dump.h"

void dump_logical_line(const LogicalLine& line,
                       StringInterner::Id& cur_file_id) {
    dump_tokens(line.tokens, cur_file_id);
}
