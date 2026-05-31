//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "lexer_tokens.h"
#include <cstdint>
#include <memory>
#include <vector>

// bytecode for opcodes match
enum class OpcodesOp : uint8_t {
    Bytes,          // followed by number of bytes and literal bytes

    ExprConst,      // followed by offset and size;
    // one of CheckRange::xxx
    // one of ExprFormula::xxx; coeficients required by formula

    ExprPatch,      // followed by offset and size;
    // and PATCH_xxx flags

    AltJpOpcode,    // if present, this is a jr instruction
    // followed by number of bytes, literal bytes,
    // offset and size
};

// match of opcode pattern, used during opcode search
struct OpcodesMatch {
    bool matched = false;
    int32_t accept_id = -1;
    std::vector<std::unique_ptr<Expr>> exprs;
};

std::unique_ptr<LabelStmt> parse_label(ParseLine& pline);
std::unique_ptr<Program> parse(const std::vector<LogicalLine>& asm_lines);
