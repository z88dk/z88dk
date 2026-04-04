//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "pathnames.h"
#include "file_mgr.h"
#include "source_loc.h"
#include "string_interner.h"
#include <fstream>
#include <iostream>
#include <list>
#include <sstream>
#include <string>
#include <string_view>
#include <utility>

FileManager g_file_mgr;

class FileHandleCache {
public:
    std::ifstream* get(std::string_view filename, const SourceLoc& loc) {
        // If already cached, move to front and return
        for (auto it = entries.begin(); it != entries.end(); ++it) {
            if (it->filename == filename) {
                entries.splice(entries.begin(), entries, it);
                return &it->stream;
            }
        }

        // Not cached: open new stream
        entries.emplace_front();
        auto& e = entries.front();
        e.filename = filename;
        e.stream.open(e.filename, std::ios::binary);
        if (!e.stream) {
            error(loc, "Failed to open file: " + e.filename);
            entries.pop_front();
            return nullptr;
        }

        // If too many, evict last
        if (entries.size() > MAX_ENTRIES) {
            entries.pop_back();
        }

        return &e.stream;
    }

private:
    struct Entry {
        std::string filename;
        std::ifstream stream;
    };

    static constexpr size_t MAX_ENTRIES = 16;
    std::list<Entry> entries;
};

static FileHandleCache g_file_handle_cache;

static inline size_t find_line_end(std::string_view content, size_t pos) {
    size_t n = content.size();
    size_t end = pos;

    while (end < n && content[end] != '\n' && content[end] != '\r') {
        ++end;
    }

    return end;
}

static inline size_t skip_line_ending(std::string_view content, size_t end) {
    size_t n = content.size();

    if (end < n) {
        if (content[end] == '\r' && end + 1 < n && content[end + 1] == '\n') {
            return end + 2;
        }
        else {
            return end + 1;
        }
    }

    return end;
}

StringInterner::Id FileManager::register_virtual_file(std::string_view path) {
    return g_strings.intern(normalize_path(path));
}

SourceFile* FileManager::get_source_file(std::string_view filename,
        const SourceLoc& loc) {
    // Normalize and intern the filename
    std::string norm = normalize_path(filename);
    StringInterner::Id file_id = g_strings.intern(norm);

    // Already loaded?
    auto it = source_cache_.find(file_id);
    if (it != source_cache_.end()) {
        return &it->second;
    }

    // Guard: if we are already loading this file (re-entrant call from
    // error reporting during tokenization), return nullptr to break the
    // recursion.  The caller (print_message) will simply skip showing
    // the source line context.
    if (source_loading_.count(file_id)) {
        return nullptr;
    }
    source_loading_.insert(file_id);

    // Read entire file into memory
    std::string content;
    if (!read_file_to_string(norm, loc, content)) {
        // read_file_to_string() already emitted an error
        source_loading_.erase(file_id);
        return nullptr;
    }

    // Build a new SourceFile
    SourceFile sf;
    sf.file_id = file_id;

    // Split into line offsets + lengths
    split_source_lines(sf, content);

    // Tokenize each line
    tokenize(sf, content);

    // Remove loading guard before inserting into cache
    source_loading_.erase(file_id);

    // Insert into cache and return pointer
    auto [pos, inserted] = source_cache_.emplace(file_id, std::move(sf));
    return &pos->second;
}

std::string FileManager::get_source_line(std::string_view filename,
        size_t line_number) {
    if (line_number == 0) {
        return "";
    }

    // Fast path: try the cached SourceFile
    SourceFile* file = get_source_file(filename, SourceLoc());
    if (file) {
        size_t index = line_number - 1;
        if (index < file->line_offsets.size()) {
            return read_line(*file, index, SourceLoc());
        }
        return "";
    }

    // Slow path: get_source_file returned nullptr (recursion guard hit).
    // Read the file independently and split into lines.
    std::string content;
    if (!read_file_to_string(filename, SourceLoc(), content)) {
        return "";
    }

    // Walk through lines until we reach the requested one
    size_t pos = 0;
    size_t current_line = 1;
    const size_t n = content.size();

    while (pos < n) {
        size_t end = find_line_end(content, pos);

        if (current_line == line_number) {
            return std::string(content, pos, end - pos);
        }

        pos = skip_line_ending(content, end);
        ++current_line;
    }

    return "";
}

bool FileManager::read_file_to_string(std::string_view filename,
                                      const SourceLoc& loc,
                                      std::string& out_content) {
    std::ifstream* in = g_file_handle_cache.get(filename, loc);
    if (!in) {
        return false;
    }

    in->clear();
    in->seekg(0);
    std::ostringstream ss;
    ss << in->rdbuf();
    out_content = ss.str();
    return true;
}

std::vector<RawLine> FileManager::split_into_lines(std::string_view content,
        StringInterner::Id file_id,
        size_t starting_line) {
    std::vector<RawLine> out;

    size_t pos = 0;
    size_t line = starting_line;

    while (pos < content.size()) {
        size_t end = find_line_end(content, pos);

        RawLine rl;
        rl.text = content.substr(pos, end - pos);
        rl.loc = SourceLoc(file_id, line, 1);
        out.push_back(std::move(rl));

        pos = skip_line_ending(content, end);
        ++line;
    }

    return out;
}

std::string FileManager::read_line(const SourceFile& sf, size_t line,
                                   const SourceLoc& loc) {
    // If line is within bounds, read normally
    if (line < sf.line_offsets.size()) {
        const char* filename = g_strings.c_str(sf.file_id);
        std::ifstream* in = g_file_handle_cache.get(filename, loc);

        if (!in) {
            return "";    // cannot open file, but don't break diagnostics
        }

        in->clear();
        in->seekg(sf.line_offsets[line]);

        std::string result;
        result.resize(sf.line_lengths[line]);
        in->read(result.data(), sf.line_lengths[line]);

        return result;
    }

    // If line == number_of_lines or beyond that, return empty line (EOF)
    return "";
}

const std::vector<uint8_t>* FileManager::read_binary_file(
    std::string_view filename,
    const SourceLoc& loc) {
    std::string norm = normalize_path(filename);
    StringInterner::Id file_id = g_strings.intern(norm);

    // Return from cache if already loaded
    auto it = binary_cache_.find(file_id);
    if (it != binary_cache_.end()) {
        return &it->second;
    }

    // Read file
    std::ifstream in(norm, std::ios::binary | std::ios::ate);
    if (!in) {
        error(loc, "Failed to open file: " + norm);
        return nullptr;
    }

    std::streamsize size = in.tellg();
    in.seekg(0, std::ios::beg);

    std::vector<uint8_t> data(static_cast<size_t>(size));
    if (size > 0 &&
            !in.read(reinterpret_cast<char*>(data.data()), size)) {
        error(loc, "Failed to read file: " + norm);
        return nullptr;
    }

    // Insert into cache and return pointer
    auto result = binary_cache_.emplace(file_id, std::move(data));
    return &result.first->second;
}

void FileManager::split_source_lines(SourceFile& sf, std::string_view content) {
    sf.line_offsets.clear();
    sf.line_lengths.clear();

    size_t pos = 0;
    const size_t n = content.size();
    while (pos < n) {
        size_t end = find_line_end(content, pos);

        sf.line_offsets.push_back(pos);
        sf.line_lengths.push_back(end - pos);

        pos = skip_line_ending(content, end);
    }

    // Handle final empty line if file ends with newline
    if (pos == n) {
        sf.line_offsets.push_back(pos);
        sf.line_lengths.push_back(0);
    }
}

