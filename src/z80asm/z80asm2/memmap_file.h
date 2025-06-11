//-----------------------------------------------------------------------------
// z80asm
// Memory-mapped binary file
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include <vector>
#include <cstdint>
using namespace std;

class MemmapFile {
public:
    const static int LONG_ERROR = 0xFFFFFFFF; // error value for long reads

    MemmapFile() = default;
    MemmapFile(const MemmapFile& other) = delete;
    MemmapFile& operator=(const MemmapFile& other) = delete;

    void clear();
    const vector<uint8_t>& data() const { return m_data; }
    int size() const { return static_cast<int>(m_data.size()); }

    void align();
    void append_byte(uint8_t value);
    void append_short(uint16_t value);
    void append_long(uint32_t value);
    void append_data(const uint8_t* data, size_t length);

    size_t read_pos() const;
    void set_read_pos(size_t pos);

    uint8_t read_byte();
    uint16_t read_short();
    uint32_t read_long();
    void read_data(uint8_t* data, size_t length);

private:
    const static int ALIGN_SIZE = sizeof(uint32_t);    // alignment size in bytes
    vector<uint8_t> m_data;     // memory-mapped binary data
    size_t m_read_pos;          // read position in the data vector
};
