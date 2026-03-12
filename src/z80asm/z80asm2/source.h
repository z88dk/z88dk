//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "source_loc.h"
#include "utils.h"
#include <cstdint>
#include <string.h>
#include <vector>

// all strings stored in strpool for memory efficiency and fast comparisons

struct SourceLine {
    const char* text = "";              // filled by file reader
    const char* expanded_text = "";     // filled by preprocessor
    int address = 0;                    // filled by code generator
    std::vector<uint8_t> bytes;         // filled by code generator
    std::vector<Token> tokens;          // filled by lexer
    SourceLoc loc;                      // filled by file reader

    SourceLine();
};

struct SourceFile {
    const char* file = "";
    std::vector<SourceLine> lines;
};

// read source file and return normalized path and lines
// caches file contents for later retrieval
SourceFile& get_source_file(const std::string& file);
