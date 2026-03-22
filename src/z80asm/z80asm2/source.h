//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "source_loc.h"
#include "strings.h"
#include <cstdint>
#include <string>
#include <vector>

// all strings stored in g_strings for memory efficiency and fast comparisons

struct RawLine {
    std::string text;
    SourceLoc loc;   // physical line + file_id
};

struct SourceFile {
    StringInterner::Id file_id = 0;
    std::vector<uint32_t> line_offsets; // byte offset of each line start
    std::vector<uint32_t> line_lengths; // length of each line (excluding EOL)
    std::vector<std::vector<Token>> lines_tokens; // tokens per line
};

// get a unique ID for a virtual file path (e.g. for included files or generated content)
uint32_t register_virtual_file(const std::string_view path);

// read source file and return normalized path and lines
// caches file contents for later retrieval
// returns nullptr if the file could not be opened
SourceFile* get_source_file(const std::string_view file, const SourceLoc& loc);

// read one line of a file
// return an error string if file cannot be opened or line number is out of range
std::string read_line(const SourceFile& sf, uint32_t line, const SourceLoc& loc);

// read whole file from a string
// issues error message if file cannot be opened
bool read_file_to_string(const std::string_view filename, const SourceLoc& loc,
                         std::string& out_content);

// split lines of a text into a vector of strings
// accept LF, CR and CR-LF as line endings
void split_source_lines(SourceFile& sf, const std::string_view content);

// split content into lines and return vector of RawLine with text_id and SourceLoc
std::vector<RawLine> split_into_lines(const std::string_view content,
                                      uint32_t file_id,
                                      uint32_t starting_line);

