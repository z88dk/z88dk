//-----------------------------------------------------------------------------
// z80asm
// Memory-mapped binary data
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include <vector>
#include <cstdint>
using namespace std;

class Memmap {
public:
    const static uint32_t LONG_ERROR = UINT32_MAX; // long error value

    Memmap() = default;
    Memmap(const Memmap& other) = delete;
    Memmap& operator=(const Memmap& other) = delete;

    void clear();
    const vector<uint8_t>& data() const { return m_data; }
    size_t size() const { return m_data.size(); }
    size_t pos() const;
    void set_pos(size_t pos);

    void align();
    void write_byte(uint8_t value);
    void write_short(uint16_t value);
    void write_long(uint32_t value);
    void write_data(const uint8_t* data, size_t length);

    bool read_byte(uint8_t& value);
    bool read_short(uint16_t& value);
    bool read_long(uint32_t& value);
    bool read_data(uint8_t* data, size_t length);

    bool write_file(const string& filename);
    bool read_file(const string& filename);

#ifdef UNIT_TESTS
    static void test();
#endif

private:
    const static int ALIGN_SIZE = sizeof(uint32_t);    // alignment size in bytes
    vector<uint8_t> m_data;     // memory-mapped binary data
    size_t m_pos{ 0 };          // read/write position in the data vector

    void extend_data(size_t count = 0);
};
