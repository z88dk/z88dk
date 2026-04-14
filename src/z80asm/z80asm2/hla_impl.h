//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "hla_ast.h"
#include "lexer_tokens.h"
#include <memory>
#include <vector>

// worker functions
std::unique_ptr<HLA_Program> hla_parse(const std::vector<LogicalLine>& lines);
void hla_semantic_check(HLA_Program& program);
void hla_semantic_check_body(std::vector<std::unique_ptr<HLA_Node>>& body);
std::unique_ptr<HLA_Expr> fold_expr(std::unique_ptr<HLA_Expr> expr);
void hla_emit_cond(const HLA_Expr& e, HLA_Label Ltrue, HLA_Label Lfalse,
                   bool prefer_true_fallthrough,
                   std::vector<LogicalLine>& out);
std::vector<LogicalLine> hla_lower(const HLA_Program& program);
void hla_lower_body(const std::vector<std::unique_ptr<HLA_Node>>& body,
                    std::vector<LogicalLine>& out);
