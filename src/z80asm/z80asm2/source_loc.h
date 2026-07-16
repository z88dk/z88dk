//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "strings.h"
#include <cstdint>
#include <string>
#include <string_view>

using uint = unsigned int;

class SourceLoc {
public:
    SourceLoc() = default;
    SourceLoc(StringId filename_id, uint line, uint column);
    SourceLoc(std::string_view filename, uint line, uint column);

    void clear();
    bool empty() const;
    std::string to_string() const;

    StringId filename_id() const {
        return filename_id_;
    }
    std::string_view filename() const {
        return g_strings.view(filename_id_);
    }
    uint line() const {
        return line_;
    }
    uint column() const {
        return column_;
    }

private:
    StringId filename_id_;       // 4 bytes
    uint line_ = 0;              // 4 bytes
    uint column_ = 0;            // 4 bytes
};

// used to map physical to logical lines
class SourceLine {
public:
    SourceLine() = default;
    SourceLine(StringId filename_id, uint line);
    SourceLine(std::string_view filename, uint line);
    SourceLine(const SourceLoc& loc);

    StringId filename_id() const {
        return filename_id_;
    }
    std::string_view filename() const {
        return g_strings.view(filename_id_);
    }
    uint line() const {
        return line_;
    }

    bool operator==(const SourceLine& other) const;
    bool operator!=(const SourceLine& other) const;

private:
    uint line_ = 0;              // 4 bytes
    StringId filename_id_;       // 4 bytes


};

struct SourceLineHash {
    size_t operator()(const SourceLine& s) const ;
};

