//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <string>
#include <vector>

struct RawLine {
    std::string text;
    SourceLoc loc;   // physical line + file_id
};

struct SourceFile {
    StringInterner::Id file_id = 0;
    std::vector<size_t> line_offsets; // byte offset of each line start
    std::vector<size_t> line_lengths; // length of each line (excluding EOL)
    std::vector<std::vector<Token>> lines_tokens; // tokens per line
};

// get a unique ID for a virtual file path
// (e.g. for included files or generated content)
StringInterner::Id register_virtual_file(std::string_view path);

// read source file and return normalized path and lines
// caches file contents for later retrieval
// returns nullptr if the file could not be opened
SourceFile* get_source_file(std::string_view file, const SourceLoc& loc);

// read one line of a file
// return an error string if file cannot be opened or line number is out of range
std::string read_line(const SourceFile& sf, size_t line, const SourceLoc& loc);

// get a source line by filename and 1-based line number
// tries the cached SourceFile first; if unavailable (e.g. during tokenization
// of the same file), falls back to reading the file and splitting lines
// returns empty string if the file cannot be read or line is out of range
std::string get_source_line(std::string_view filename,
                            size_t line_number);

// read whole file to a string
// issues error message if file cannot be opened
bool read_file_to_string(std::string_view filename, const SourceLoc& loc,
                         std::string& out_content);

// read whole binary file to a vector
// issues error message if file cannot be opened
bool read_binary_file(std::string_view filename, const SourceLoc& loc,
                      std::vector<uint8_t>& out_content);

// issues error message if file cannot be opened
bool read_file_to_string(std::string_view filename, const SourceLoc& loc,
                         std::string& out_content);

// split lines of a text into a vector of strings
// accept LF, CR and CR-LF as line endings
void split_source_lines(SourceFile& sf, std::string_view content);

// split content into lines and return vector of RawLine with text_id and SourceLoc
std::vector<RawLine> split_into_lines(std::string_view content,
                                      StringInterner::Id file_id,
                                      size_t starting_line);

