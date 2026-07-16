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

StringTable g_strings;

//-----------------------------------------------------------------------------
// String interner
//-----------------------------------------------------------------------------

StringTable::StringTable() {
    clear();
}

void StringTable::clear() {
    pool_.clear();
    map_.clear();
    intern("");     // ID 0
}

StringId StringTable::intern(std::string_view s) {
    std::string key(s);
    auto it = map_.find(key);
    if (it != map_.end()) {
        return StringId(it->second);
    }
    uint32_t id = static_cast<uint32_t>(pool_.size());
    pool_.emplace_back(s);
    map_.emplace(std::move(key), id);
    return StringId(id);
}

std::string_view StringTable::view(StringId id) const {
    release_assert(id.id() < pool_.size());
    return pool_[id.id()];
}

std::string_view StringTable::operator[](StringId id) const {
    return view(id);
}

void StringTable::pack(BinaryData& bin_data) const {
    // header has number of strings and total size of blob with all strings
    size_t num_strings = size();
    bin_data.put_dword(static_cast<uint32_t>(num_strings));
    size_t strings_size_pos = bin_data.size();
    bin_data.put_dword(0);

    // write index of each string into blob of strings concatenated separated by '\0'
    size_t str_table_pos = 0;
    for (uint32_t id = 0; id < num_strings; id++) {
        std::string_view str = view(StringId(id));
        size_t pos = str_table_pos;
        str_table_pos += str.size() + 1;        // chars + null char

        bin_data.put_dword(static_cast<uint32_t>(pos));  // index into strings
    }

    // write all strings together
    for (uint32_t id = 0; id < num_strings; id++) {
        std::string_view str = view(StringId(id));
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

void StringTable::unpack(std::shared_ptr<const BinaryFile> file, size_t ptr) {
    // get size
    uint32_t num_strings = file->get_dword(ptr);
    uint32_t blob_size = file->get_dword(ptr);
    size_t blob_start = ptr + num_strings * sizeof(uint32_t);

    // get blob
    const uint8_t* blob = file->get_data(blob_start, blob_size);

    // clear data
    clear();

    // get offsets and create string views
    for (uint32_t i = 0; i < num_strings; ++i) {
        uint32_t str_pos = file->get_dword(ptr);
        if (str_pos >= blob_size) {
            fatal_error("invalid string position " + std::to_string(str_pos) +
                        " in file '" + std::string(file->filename()) + "'");
        }
        const char* str = reinterpret_cast<const char*>(blob + str_pos);
        intern(str);
    }
}
