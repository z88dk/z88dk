//-----------------------------------------------------------------------------
// z80asm
// Memory-mapped binary data
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "memmap.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
using namespace std;

void Memmap::clear() {
    m_data.clear();
    m_pos = 0; // reset read/write position
}

void Memmap::align() {
    ptrdiff_t padding = (ALIGN_SIZE - (m_pos % ALIGN_SIZE)) % ALIGN_SIZE;
    m_pos += padding;
    extend_data();
}

size_t Memmap::pos() const {
    assert(m_pos <= m_data.size() && "Read/write position out of bounds");
    return m_pos;
}

void Memmap::set_pos(size_t pos) {
    assert(pos <= m_data.size() && "Read/write position out of bounds");
    m_pos = pos;
}

void Memmap::write_byte(uint8_t value) {
    extend_data(1);
    m_data[m_pos++] = value;
}

void Memmap::write_short(uint16_t value) {
    extend_data(2);
    m_data[m_pos++] = value & 0xFF;
    m_data[m_pos++] = (value >> 8) & 0xFF;
}

void Memmap::write_long(uint32_t value) {
    extend_data(4);
    m_data[m_pos++] = value & 0xFF;
    m_data[m_pos++] = (value >> 8) & 0xFF;
    m_data[m_pos++] = (value >> 16) & 0xFF;
    m_data[m_pos++] = (value >> 24) & 0xFF;
}

void Memmap::write_data(const uint8_t* data, size_t length) {
    if (length == 0)
        return; // nothing to write, but valid
    else {
        assert(data != nullptr && "Data pointer cannot be null");
        extend_data(length);
        copy(data, data + length, m_data.begin() + m_pos);
        m_pos += length;
    }
}

bool Memmap::read_byte(uint8_t& value) {
    if (m_pos >= m_data.size())
        return false; // out of bounds
    else {
        value = m_data[m_pos++];
        return true;
    }
}

bool Memmap::read_short(uint16_t& value) {
    if (m_pos + 1 >= m_data.size())
        return false; // out of bounds
    else {
        value = static_cast<uint16_t>(m_data[m_pos]) |
            (static_cast<uint16_t>(m_data[m_pos + 1]) << 8);
        m_pos += 2;
        return true;
    }
}

bool Memmap::read_long(uint32_t& value) {
    if (m_pos + 3 >= m_data.size())
        return false; // out of bounds
    else {
        value = static_cast<uint32_t>(m_data[m_pos]) |
            (static_cast<uint32_t>(m_data[m_pos + 1]) << 8) |
            (static_cast<uint32_t>(m_data[m_pos + 2]) << 16) |
            (static_cast<uint32_t>(m_data[m_pos + 3]) << 24);
        m_pos += 4;
        return true;
    }
}

bool Memmap::read_data(uint8_t* data, size_t length) {
    if (m_pos + length > m_data.size())
        return false; // out of bounds
    else if (length == 0)
        return true; // nothing to read, but valid
    else {
        assert(data != nullptr && "Data pointer cannot be null");
        copy(m_data.begin() + m_pos, m_data.begin() + m_pos + length, data);
        m_pos += length;
        return true;
    }
}

void Memmap::extend_data(size_t count) {
    ptrdiff_t padding = m_pos + count - m_data.size();
    if (padding > 0)
        m_data.insert(m_data.end(), padding, 0); // fill with zeros
}

#ifdef _DEBUG
#include <iostream>

void Memmap::test() {
    Memmap mem;
    mem.align();
    mem.write_byte(0x12); // Example write to memory-mapped file
    mem.align();
    mem.write_short(0x1234); // Example write to memory-mapped file
    mem.align();
    mem.write_long(0x12345678); // Example write to memory-mapped file
    mem.align();
    mem.write_long(Memmap::LONG_ERROR); // Example write to memory-mapped file
    mem.align();
    mem.set_pos(0); // Reset position for reading
    uint8_t byte_value;
    assert(mem.read_byte(byte_value) && byte_value == 0x12); // Read back the byte
    mem.align();
    uint16_t short_value;
    assert(mem.read_short(short_value) && short_value == 0x1234); // Read back the short
    mem.align();
    uint32_t long_value;
    assert(mem.read_long(long_value) && long_value == 0x12345678); // Read back the long
    mem.align();
    assert(mem.read_long(long_value) && long_value == Memmap::LONG_ERROR); // Read back the long error value
    mem.align();
    assert(mem.pos() == mem.size()); // Ensure position is at the end
    mem.clear(); // Clear the memory-mapped file
    assert(mem.size() == 0 && mem.pos() == 0); // Ensure it is empty
    mem.write_data(reinterpret_cast<const uint8_t*>("Test"), 4); // Write some data
    mem.set_pos(0); // Reset position for reading
    uint8_t data[4];
    assert(mem.read_data(data, 4) && mem.pos() == 4); // Read back the data
    assert(data[0] == 'T' && data[1] == 'e' && data[2] == 's' && data[3] == 't'); // Check the data
    mem.clear(); // Clear the memory-mapped file again
    assert(mem.size() == 0 && mem.pos() == 0); // Ensure it is empty again
    cout << "Memmap test passed." << endl;
}

#endif
