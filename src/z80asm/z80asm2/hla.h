//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
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
    void process_if(const TokenLine& line, size_t& i);
    void process_elif(const TokenLine& line, size_t& i);
    void process_else(const TokenLine& line, size_t& i);
    void process_endif(const TokenLine& line, size_t& i);
    void process_while(const TokenLine& line, size_t& i);
    void process_wend(const TokenLine& line, size_t& i);
    void process_repeat(const TokenLine& line, size_t& i);
    void process_until(const TokenLine& line, size_t& i);
    void process_untilb(const TokenLine& line, size_t& i);
    void process_untilbc(const TokenLine& line, size_t& i);
    void process_break(const TokenLine& line, size_t& i);
    void process_continue(const TokenLine& line, size_t& i);
};
