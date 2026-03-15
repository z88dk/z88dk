//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "source_loc.h"
#include <string>
#include <vector>

// all strings stored in strpool for memory efficiency and fast comparisons

struct SourceLine {
    const char* text = "";
    std::vector<Token> tokens;
    SourceLoc loc;
};

struct SourceFile {
    const char* file = "";
    std::vector<SourceLine> lines;
};

// read source file and return normalized path and lines
// caches file contents for later retrieval
// returns nullptr if the file could not be opened
SourceFile* get_source_file(const std::string& file, const SourceLoc& loc = SourceLoc());

// read whole file from a string
// return empty string and issues error message if file cannot be opened
std::string read_file_to_string(const std::string& filename, const SourceLoc& loc = SourceLoc());

// split lines of a text into a vector of strings
// accept LF, CR and CR-LF as line endings
std::vector<SourceLine> split_source_lines(const std::string& filename, const std::string& content);
