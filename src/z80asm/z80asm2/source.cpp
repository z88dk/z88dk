//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "source.h"
#include <fstream>
#include <unordered_map>

SourceLine::SourceLine()
    : text(strpool("")), expanded_text(strpool("")) {
}

SourceFile& get_source_file(const std::string& file) {
    static std::unordered_map<std::string, SourceFile> cache;

    std::string key = normalize_path(file);
    auto it = cache.find(key);
    if (it != cache.end()) {
        return it->second;
    }

    // read entire file into memory
    std::ifstream ifs(key, std::ios::binary);
    std::string contents((std::istreambuf_iterator<char>(ifs)),
                         std::istreambuf_iterator<char>());

    // build SourceFile
    SourceFile& sf = cache[key];
    sf.file = strpool(key);

    // split into lines, handling CR, CR-LF, and LF
    std::string line;
    int line_num = 1;
    for (size_t i = 0; i < contents.size(); i++) {
        char c = contents[i];
        if (c == '\r') {
            // CR or CR-LF
            if (i + 1 < contents.size() && contents[i + 1] == '\n') {
                i++;  // skip LF after CR
            }
            SourceLine sl;
            sl.text = strpool(line);
            sl.loc = SourceLoc(key, line_num, 1);
            sf.lines.push_back(sl);
            line.clear();
            line_num++;
        }
        else if (c == '\n') {
            SourceLine sl;
            sl.text = strpool(line);
            sl.loc = SourceLoc(key, line_num, 1);
            sf.lines.push_back(sl);
            line.clear();
            line_num++;
        }
        else {
            line += c;
        }
    }

    // add last line if file doesn't end with a newline
    if (!line.empty()) {
        SourceLine sl;
        sl.text = strpool(line);
        sl.loc = SourceLoc(key, line_num, 1);
        sf.lines.push_back(sl);
    }

    return sf;
}
