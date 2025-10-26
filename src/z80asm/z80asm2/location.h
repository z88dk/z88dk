//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>

class Location {
public:
    Location(const std::string& filename = "", int line_num = 0);
    void clear();
    bool empty() const;

    const std::string& filename() const;
    int line_num() const;

    void set_filename(const std::string& filename);
    void set_line_num(int line_num);

private:
    std::string filename_;
    int line_num_ = 0;
};
