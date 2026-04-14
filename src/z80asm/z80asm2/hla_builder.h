//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "hla_ast.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include <memory>
#include <unordered_map>
#include <vector>

class HLA_ProgramBuilder {
public:
    bool handle_directive(ParseLine& line);
    void handle_asm(ParseLine& line);
    std::unique_ptr<HLA_Program> finish();

private:
    struct BlockContext {
        HLA_Node* node;   // the AST node that owns this block
        std::vector<std::unique_ptr<HLA_Node>>* body;  // the active body vector
    };

    std::vector<std::unique_ptr<HLA_Node>> root_body;
    std::vector<BlockContext> stack;    // stack of open blocks

    std::vector<std::unique_ptr<HLA_Node>>* current_body();

    // directives dispatcher table
    using DirectiveHandler =
        void (HLA_ProgramBuilder::*)(Keyword kw, const SourceLoc& kw_loc,
                                     ParseLine& line);
    static std::unordered_map<Keyword, DirectiveHandler> directive_handlers;

    void handle_if(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_elseif(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_else(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_endif(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_while(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_endwhile(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_repeat(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_until(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_djnz(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_break(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);
    void handle_continue(Keyword kw, const SourceLoc& kw_loc, ParseLine& line);

    // parse condition expressions
    std::unique_ptr<HLA_Expr> parse_condition(ParseLine& line);
    std::unique_ptr<HLA_Expr> parse_or(ParseLine& line);
    std::unique_ptr<HLA_Expr> parse_and(ParseLine& line);
    std::unique_ptr<HLA_Expr> parse_not(ParseLine& line);
    std::unique_ptr<HLA_Expr> parse_primary(ParseLine& line);
    std::unique_ptr<HLA_Expr> parse_comparison(ParseLine& line);
};
