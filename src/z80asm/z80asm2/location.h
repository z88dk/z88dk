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

    const std::string& filename() const {
        return filename_;
    }
    int line_num() const {
        return line_num_;
    }

    void set_filename(const std::string& filename) {
        filename_ = filename;
    }
    void set_line_num(int line_num) {
        line_num_ = line_num;
    }

    // Computes and sets the logical line number based on #line directive
    void set_logical_line_num(int line_directive_value,
                              int line_directive_physical_line,
                              int physical_line_num);

    // Sets the line number to the physical line number
    void set_physical_line_num(int physical_line_num);

    // Increments the logical line number
    void inc_line_num();

    // Control whether inc_line_num actually increments the stored number.
    // Default is true. Virtual files (macro expansions) can disable increments.
    void set_inc_line_nums(bool enable);

private:
    std::string filename_;
    int line_num_ = 0;
    bool inc_line_nums_ = true;
};


