//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <unordered_map>
#include <vector>

class Location {
public:
    Location(const std::string& filename = "", size_t line_num = 0);
    void clear();
    bool empty() const;

    const std::string& filename() const;
    size_t line_num() const;

    void set_filename(const std::string& filename);
    void set_line_num(size_t line_num);
    void inc_line_num();

private:
    // Accessors for static storage (Construct On First Use Idiom)
    // These functions ensure the static data is initialized before first use,
    // avoiding the static initialization order fiasco
    static std::vector<std::string>& get_filenames();
    static std::unordered_map<std::string, size_t>& get_filename_map();

    // Get or create filename index
    static size_t get_filename_index(const std::string& filename);

    // Get filename from index (empty string for index 0)
    static const std::string& get_filename_by_index(size_t index);

    size_t filename_index_ = 0;  // Index into filenames vector (0 = empty)
    size_t line_num_ = 0;
};
