//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "hla_codegen.h"
#include "preprocessor.h"
#include <deque>
#include <string>
#include <vector>

class HLA {
public:
    void clear();
    void push_file(const std::string& filename);
    void push_virtual_file(const std::string& content,
                           const std::string& filename,
                           int first_line_num, bool inc_line_nums);
    bool next_line(TokensLine& out_line);

private:
    Preprocessor preprocessor_;
    std::deque<TokensLine> out_queue_;
    std::vector<hla::Block> block_stack_;
    unsigned label_counter_ = 0;

    bool next_cleaned_line(TokensLine& out_line);
    void process_if(const TokensLine& line, unsigned& i);
    void process_elif(const TokensLine& line, unsigned& i);
    void process_else(const TokensLine& line, unsigned& i);
    void process_endif(const TokensLine& line, unsigned& i);
    void process_while(const TokensLine& line, unsigned& i);
    void process_wend(const TokensLine& line, unsigned& i);
    void process_repeat(const TokensLine& line, unsigned& i);
    void process_until(const TokensLine& line, unsigned& i);
};
