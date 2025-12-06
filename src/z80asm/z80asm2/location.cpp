//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "location.h"

// Construct On First Use Idiom - guarantees initialization before first use
std::vector<std::string>& Location::get_filenames() {
    static std::vector<std::string> filenames = { "" };  // Index 0 is empty string
    return filenames;
}

std::unordered_map<std::string, size_t>& Location::get_filename_map() {
    static std::unordered_map<std::string, size_t> filename_map = { {"", 0} };
    return filename_map;
}

Location::Location(const std::string& filename, size_t line_num)
    : filename_index_(get_filename_index(filename)), line_num_(line_num) {}

void Location::clear() {
    filename_index_ = 0;
    line_num_ = 0;
}

bool Location::empty() const {
    return filename_index_ == 0 && line_num_ == 0;
}

const std::string& Location::filename() const {
    return get_filename_by_index(filename_index_);
}

size_t Location::line_num() const {
    return line_num_;
}

void Location::set_filename(const std::string& filename) {
    filename_index_ = get_filename_index(filename);
}

void Location::set_line_num(size_t line_num) {
    line_num_ = line_num;
}

void Location::inc_line_num() {
    ++line_num_;
}

size_t Location::get_filename_index(const std::string& filename) {
    auto& filename_map = get_filename_map();
    auto& filenames = get_filenames();

    // Try to find existing filename
    auto it = filename_map.find(filename);
    if (it != filename_map.end()) {
        return it->second;
    }

    // Add new filename
    size_t index = filenames.size();
    filenames.push_back(filename);
    filename_map[filename] = index;
    return index;
}

const std::string& Location::get_filename_by_index(size_t index) {
    auto& filenames = get_filenames();

    if (index < filenames.size()) {
        return filenames[index];
    }

    // Return empty string if index is out of bounds
    static const std::string empty_string;
    return empty_string;
}
