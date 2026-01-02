//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "hla_codegen.h"
#include <deque>
#include <string>
#include <vector>

class Preprocessor;

class HLA {
public:
    HLA(Preprocessor* pp);
    void clear();
    bool next_line(TokenLine& out_line);

private:
    Preprocessor* pp_ = nullptr;
    std::deque<TokenLine> out_queue_;
    std::vector<hla::Block> block_stack_;

    bool next_pp_line(TokenLine& out_line);
    void process_directive(Keyword keyword, const TokenLine& line, size_t& i);
    void process_IF(const TokenLine& line, size_t& i);
    void process_ELIF(const TokenLine& line, size_t& i);
    void process_ELSEIF(const TokenLine& line, size_t& i);
    void process_ELSE(const TokenLine& line, size_t& i);
    void process_ENDIF(const TokenLine& line, size_t& i);
    void process_WHILE(const TokenLine& line, size_t& i);
    void process_WEND(const TokenLine& line, size_t& i);
    void process_ENDW(const TokenLine& line, size_t& i);
    void process_ENDWHILE(const TokenLine& line, size_t& i);
    void process_REPEAT(const TokenLine& line, size_t& i);
    void process_UNTIL(const TokenLine& line, size_t& i);
    void process_UNTILB(const TokenLine& line, size_t& i);
    void process_UNTILBC(const TokenLine& line, size_t& i);
    void process_BREAK(const TokenLine& line, size_t& i);
    void process_CONTINUE(const TokenLine& line, size_t& i);

    // tables of actions for directives
    using Action = void (HLA::*)(const TokenLine& line, size_t& i);
    static const Action hla_directive_actions[];
};
