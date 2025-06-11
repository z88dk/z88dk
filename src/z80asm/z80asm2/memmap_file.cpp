//-----------------------------------------------------------------------------
// z80asm
// Memory-mapped binary file
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "memmap_file.h"
#include <cassert>
using namespace std;

void MemmapFile::clear() {
    m_data.clear();
    m_read_pos = 0; // reset read position
}

void MemmapFile::align() {
    int padding = (ALIGN_SIZE - (m_data.size() % ALIGN_SIZE)) % ALIGN_SIZE;
    if (padding > 0) {
        m_data.insert(m_data.end(), padding, 0); // fill with zeros
    }
}

void MemmapFile::append_byte(uint8_t value) {
    m_data.push_back(value);
}

void MemmapFile::append_short(uint16_t value) {
    append_byte(value & 0xFF);
    append_byte((value >> 8) & 0xFF);
}

void MemmapFile::append_long(uint32_t value) {
    append_byte(value & 0xFF);
    append_byte((value >> 8) & 0xFF);
    append_byte((value >> 16) & 0xFF);
    append_byte((value >> 24) & 0xFF);
}

void MemmapFile::append_data(const uint8_t* data, size_t length) {
    m_data.insert(m_data.end(), data, data + length);
}

size_t MemmapFile::read_pos() const {
    assert(m_read_pos <= m_data.size() && "Read position out of bounds");
    return m_read_pos;
}

void MemmapFile::set_read_pos(size_t pos) {
    assert(pos <= m_data.size() && "Read position out of bounds");
    m_read_pos = pos;
}

uint8_t MemmapFile::read_byte() {
    assert(m_read_pos < m_data.size() && "Read position out of bounds");
    return m_data[m_read_pos++];
}

uint16_t MemmapFile::read_short() {
    assert(m_read_pos + 1 < m_data.size() && "Read position out of bounds");
    uint16_t value = static_cast<uint16_t>(m_data[m_read_pos]) |
        (static_cast<uint16_t>(m_data[m_read_pos + 1]) << 8);
    m_read_pos += 2;
    return value;
}

uint32_t MemmapFile::read_long() {
    assert(m_read_pos + 3 < m_data.size() && "Read position out of bounds");
    uint32_t value = static_cast<uint32_t>(m_data[m_read_pos]) |
        (static_cast<uint32_t>(m_data[m_read_pos + 1]) << 8) |
        (static_cast<uint32_t>(m_data[m_read_pos + 2]) << 16) |
        (static_cast<uint32_t>(m_data[m_read_pos + 3]) << 24);
    m_read_pos += 4;
    return value;
}

void MemmapFile::read_data(uint8_t* data, size_t length) {
    assert(m_read_pos + length <= m_data.size() && "Read position out of bounds");
    copy(m_data.begin() + m_read_pos, m_data.begin() + m_read_pos + length, data);
    m_read_pos += length;
}
