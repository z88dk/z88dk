//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "binary_data.h"
#include "binary_file.h"
#include <memory>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

using uint = unsigned int;

//-----------------------------------------------------------------------------
// String interner
//-----------------------------------------------------------------------------

class Strings {
public:
    explicit Strings();
    void clear();
    uint intern(std::string_view s);
    std::string_view view(uint id) const;
    const std::string& string(uint id) const;
    size_t size() const;

    // pack to a binary data
    void pack(BinaryData& bin_data) const;

private:
    std::vector<std::string> pool;
    std::unordered_map<std::string, uint> map;
};

extern Strings g_strings;

//-----------------------------------------------------------------------------
// String interner view
//-----------------------------------------------------------------------------

class StringsView {
public:
    explicit StringsView();
    void clear();
    std::string_view view(uint id) const;

    // unpack from binary file, strings are views on file data
    void unpack(std::shared_ptr<const BinaryFile> file, size_t ptr);

private:
    std::shared_ptr<const BinaryFile> file_;
    std::vector<std::string_view> strings_;

    void unpack(size_t ptr);
};
