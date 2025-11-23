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
    bool next_line(TokensLine& out_line);

private:
    Preprocessor* pp_ = nullptr;
    std::deque<TokensLine> out_queue_;
    std::vector<hla::Block> block_stack_;
    unsigned label_counter_ = 0;

    bool next_pp_line(TokensLine& out_line);
    void process_if(const TokensLine& line, unsigned& i);
    void process_elif(const TokensLine& line, unsigned& i);
    void process_else(const TokensLine& line, unsigned& i);
    void process_endif(const TokensLine& line, unsigned& i);
    void process_while(const TokensLine& line, unsigned& i);
    void process_wend(const TokensLine& line, unsigned& i);
    void process_repeat(const TokensLine& line, unsigned& i);
    void process_until(const TokensLine& line, unsigned& i);
    void process_untilb(const TokensLine& line, unsigned& i);
    void process_untilbc(const TokensLine& line, unsigned& i);
    void process_break(const TokensLine& line, unsigned& i);
    void process_continue(const TokensLine& line, unsigned& i);
};
