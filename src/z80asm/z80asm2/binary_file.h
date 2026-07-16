//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cstdint>
#include <string>
#include <string_view>

// Memory mapped binary file open for read-only access
// NOTE: user is responsible for checking bounds
class BinaryFile {
public:
    explicit BinaryFile(std::string_view filename);
    ~BinaryFile();
    BinaryFile(const BinaryFile&) = delete;
    BinaryFile& operator=(const BinaryFile&) = delete;
    BinaryFile(BinaryFile&& other) ;
    BinaryFile& operator=(BinaryFile&& other) ;

    const uint8_t* data() const  {
        return data_;
    }
    size_t size() const  {
        return size_;
    }
    std::string_view filename() const  {
        return filename_;
    }

    // pointer movement
    void align_ptr(size_t& ptr) const;
    void skip(size_t& ptr, size_t amount) const;
    size_t tell(size_t ptr) const  {
        return ptr;
    }
    void seek(size_t& ptr, size_t new_pos) const;

    // get data and advance pointer
    const uint8_t* get_data(size_t& ptr, size_t elem_size) const;
    uint8_t  get_byte(size_t& ptr) const;
    uint16_t get_word(size_t& ptr) const;
    uint32_t get_dword(size_t& ptr) const;
    std::string_view get_string_view(size_t& ptr, size_t str_size) const;
    std::string_view get_byte_string_view(size_t& ptr) const;
    std::string_view get_word_string_view(size_t& ptr) const;

    // peek data without advancing pointer
    const uint8_t* peek_data(size_t ptr, size_t elem_size) const;
    uint8_t peek_byte(size_t ptr) const;
    uint16_t peek_word(size_t ptr) const;
    uint32_t peek_dword(size_t ptr) const;
    std::string_view peek_string_view(size_t ptr, size_t str_size) const;
    std::string_view peek_byte_string_view(size_t ptr) const;
    std::string_view peek_word_string_view(size_t ptr) const;

private:
    std::string filename_;					// name of file
    const uint8_t* data_ = nullptr;			// point to data
    size_t size_ = 0;					    // data size
#if defined(_WIN32)
    void* file_ = nullptr;					// HANDLE (opaque pointer)
    void* mapping_ = nullptr;				// HANDLE (opaque pointer)
#elif defined(__unix__) || defined(__APPLE__)
    int fd_ = -1;
#else
    std::vector<uint8_t> storage_;			// holds data
#endif

#if defined(_WIN32) || defined(__unix__) || defined(__APPLE__)
    void open_mapped(std::string_view filename);
    void close_mapped();
#else
    void open_vector(std::string_view filename);
#endif

    void move_from(BinaryFile&& other) ;
};
