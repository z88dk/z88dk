//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "binary_data.h"
#include "diag.h"
#include "release_assert.h"
#include "strings.h"
#include <cstdint>
#include <string>
#include <string_view>
#include <utility>
#include <memory>
#include "binary_file.h"

Strings g_strings;

//-----------------------------------------------------------------------------
// String interner
//-----------------------------------------------------------------------------

Strings::Strings() {
    clear();
}

// Reserve ID 0 for the empty string
void Strings::clear() {
    pool.clear();
    map.clear();
    pool.emplace_back("");
}

uint Strings::intern(std::string_view s) {
    std::string key(s);
    auto it = map.find(key);
    if (it != map.end()) {
        return it->second;
    }
    uint id = static_cast<uint>(pool.size());
    pool.emplace_back(s);
    map.emplace(std::move(key), id);
    return id;
}

std::string_view Strings::view(uint id) const {
    release_assert(id < pool.size());
    return pool[id];
}

const std::string& Strings::string(uint id) const {
    release_assert(id < pool.size());
    return pool[id];
}

size_t Strings::size() const {
    return pool.size();
}

void Strings::pack(BinaryData& bin_data) const {
    // header has number of strings and total size of blob with all strings
    size_t num_strings = size();
    bin_data.put_dword(static_cast<uint32_t>(num_strings));
    size_t strings_size_pos = bin_data.size();
    bin_data.put_dword(0);

    // write index of each string into blob of strings concatenated separated by '\0'
    size_t str_table_pos = 0;
    for (size_t id = 0; id < num_strings; id++) {
        std::string_view str = view(static_cast<uint>(id));
        size_t pos = str_table_pos;
        str_table_pos += str.size() + 1;        // chars + null char

        bin_data.put_dword(static_cast<uint32_t>(pos));  // index into strings
    }

    // write all strings together
    for (size_t id = 0; id < num_strings; id++) {
        std::string_view str = view(static_cast<uint>(id));
        bin_data.put_string(str);              // string
        bin_data.put_byte(0);                  // null terminator
    }

    // align to 32-bit size
    size_t size_before_align = bin_data.size();
    bin_data.align(4);
    str_table_pos += bin_data.size() - size_before_align;

    // write the blob length (str_table_pos)
    bin_data.patch_dword(strings_size_pos, static_cast<uint32_t>(str_table_pos));
}

//-----------------------------------------------------------------------------
// String interner view
//-----------------------------------------------------------------------------

StringsView::StringsView() {
    clear();
}

void StringsView::clear() {
    file_.reset();
    strings_.clear();
    strings_.push_back("");  // reserve ID 0 for the empty string
}

std::string_view StringsView::view(uint id) const {
    if (id >= strings_.size()) {
        fatal_error("invalid string ID " + std::to_string(id) + " in file '" +
                    std::string(file_->filename()) +
                    "' (max " + std::to_string(strings_.size() - 1) + ")");
    }
    return strings_[id];
}

void StringsView::unpack(std::shared_ptr<const BinaryFile> file, size_t ptr) {
    file_ = std::move(file);
    unpack(ptr);
}

void StringsView::unpack(size_t ptr) {
    // get size
    size_t num_strings = file_->get_dword(ptr);
    size_t blob_size = file_->get_dword(ptr);
    size_t blob_start = ptr + num_strings * sizeof(uint32_t);

    // get blob
    const uint8_t* blob = file_->get_data(blob_start, blob_size);

    // clear data
    strings_.clear();
    strings_.reserve(num_strings);

    // get offsets and create string views
    for (size_t i = 0; i < num_strings; ++i) {
        size_t str_pos = file_->get_dword(ptr);
        if (str_pos >= blob_size) {
            fatal_error("invalid string position " + std::to_string(str_pos) +
                        " in file '" + std::string(file_->filename()) + "'");
        }
        const char* str = reinterpret_cast<const char*>(blob + str_pos);
        strings_.push_back(str);
    }
}
