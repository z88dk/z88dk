//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "source.h"
#include "source_loc.h"
#include "utils.h"
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <utility>

SourceFile* get_source_file(const std::string& file, const SourceLoc& loc) {
    static std::unordered_map<std::string, SourceFile> cache;

    // exit quickly when file is empty, e.g. from an empty SouceLoc.file
    if (file.empty()) {
        return nullptr;
    }

    // normalize path and check cache
    std::string key = normalize_path(file);
    if (g_options.verbose) {
        std::cout << "Reading source file: " << key << std::endl;
    }
    auto it = cache.find(key);
    if (it != cache.end()) {
        return &it->second;
    }

    // read entire file into memory
    std::string contents = read_file_to_string(key, loc);

    // build SourceFile
    SourceFile& sf = cache[key];
    sf.file = strpool(key);
    sf.lines = std::move(split_source_lines(key, contents));

    return &sf;
}

std::string read_file_to_string(const std::string& filename, const SourceLoc& loc) {
    std::ifstream ifs(filename, std::ios::binary);
    if (!ifs) {
        error(loc, "Failed to open file: " + filename);
        return std::string();
    }

    return std::string((std::istreambuf_iterator<char>(ifs)),
                       std::istreambuf_iterator<char>());
}

// split into lines, handling CR, CR-LF, and LF
std::vector<SourceLine> split_source_lines(const std::string& filename,
        const std::string& content) {
    std::vector<SourceLine> lines;
    int line_num = 1;
    const char* p = content.c_str();
    while (*p) {
        const char* line_start = p;
        while (*p && *p != '\r' && *p != '\n') {
            ++p;
        }
        std::string line(line_start, p - line_start);

        SourceLine sl;
        sl.text = strpool(line);
        sl.loc = SourceLoc(filename, line_num, 1);
        lines.push_back(std::move(sl));
        line_num++;

        // Handle line endings
        if (*p == '\r') {
            ++p;
            if (*p == '\n') {
                ++p;
            }
        }
        else if (*p == '\n') {
            ++p;
        }
    }

    return lines;
}
