//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "lexer.h"
#include "pathnames.h"
#include "source.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <fstream>
#include <iostream>
#include <list>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <utility>

class FileHandleCache {
public:
    std::ifstream* get(const std::string_view filename, const SourceLoc& loc) {
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
        if (entries.size() > max_entries) {
            entries.pop_back();
        }

        return &e.stream;
    }

private:
    struct Entry {
        std::string filename;
        std::ifstream stream;
    };

    static constexpr uint32_t max_entries = 16;
    std::list<Entry> entries;
};

static FileHandleCache g_file_handle_cache;

// Global cache: file_id -> SourceFile
static std::unordered_map<StringInterner::Id, SourceFile> g_source_cache;

// Guard against re-entrant get_source_file during tokenization
static std::unordered_set<StringInterner::Id> g_source_loading;

// get a unique ID for a virtual file path (e.g. for included files or generated content)
uint32_t register_virtual_file(const std::string_view path) {
    return g_strings.intern(path);
}

SourceFile* get_source_file(const std::string_view filename, const SourceLoc& loc) {
    // Normalize and intern the filename
    std::string norm = normalize_path(filename);
    StringInterner::Id file_id = g_strings.intern(norm);

    // Already loaded?
    auto it = g_source_cache.find(file_id);
    if (it != g_source_cache.end()) {
        return &it->second;
    }

    // Guard: if we are already loading this file (re-entrant call from
    // error reporting during tokenization), return nullptr to break the
    // recursion.  The caller (print_message) will simply skip showing
    // the source line context.
    if (g_source_loading.count(file_id)) {
        return nullptr;
    }
    g_source_loading.insert(file_id);

    // Read entire file into memory
    std::string content;
    if (!read_file_to_string(norm, loc, content)) {
        // read_file_to_string() already emitted an error
        g_source_loading.erase(file_id);
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
    g_source_loading.erase(file_id);

    // Insert into cache and return pointer
    auto [pos, inserted] = g_source_cache.emplace(file_id, std::move(sf));
    return &pos->second;
}

// read one line of a file
std::string read_line(const SourceFile& sf, uint32_t line,
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

bool read_file_to_string(const std::string_view filename,
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

static inline size_t find_line_end(const std::string_view content, size_t pos) {
    size_t n = content.size();
    size_t end = pos;

    while (end < n && content[end] != '\n' && content[end] != '\r') {
        ++end;
    }

    return end;
}

static inline size_t skip_line_ending(const std::string_view content, size_t end) {
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

// split into lines, handling CR, CR-LF, and LF
void split_source_lines(SourceFile& sf, const std::string_view content) {
    const uint32_t n = static_cast<uint32_t>(content.size());

    uint32_t pos = 0;
    uint32_t line = 0;

    while (pos < n) {
        size_t end = find_line_end(content, pos);

        sf.line_offsets.push_back(pos);
        sf.line_lengths.push_back(static_cast<uint32_t>(end - pos));

        pos = static_cast<uint32_t>(skip_line_ending(content, end));
        ++line;
    }

    // Handle final empty line if file ends with newline
    if (pos == n) {
        sf.line_offsets.push_back(pos);
        sf.line_lengths.push_back(0);
    }
}

std::vector<RawLine> split_into_lines(const std::string_view content,
                                      uint32_t file_id,
                                      uint32_t starting_line) {
    std::vector<RawLine> out;

    uint32_t pos = 0;
    uint32_t line = starting_line;

    while (pos < content.size()) {
        size_t end = find_line_end(content, pos);

        RawLine rl;
        rl.text = content.substr(pos, end - pos);
        rl.loc = SourceLoc(file_id, line, 1);
        out.push_back(std::move(rl));

        pos = static_cast<uint32_t>(skip_line_ending(content, end));
        ++line;
    }

    return out;
}
