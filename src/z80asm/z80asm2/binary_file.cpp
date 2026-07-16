//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif

#include "binary_file.h"
#include "diag.h"
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <string>

#if defined(_WIN32)

#define WIN32_LEAN_AND_MEAN
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>
// Undefine problematic Windows macros
#undef ERROR
#undef FALSE
#undef TRUE
#undef IN
#undef OUT
#undef ABSOLUTE
#undef RELATIVE
#undef None
#undef CONST

#elif defined(__unix__) || defined(__APPLE__)

#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#else

#include <cstdio>

#endif

BinaryFile::BinaryFile(const std::string& filename)
    : filename_(filename) {
#if defined(_WIN32) || defined(__unix__) || defined(__APPLE__)
    open_mapped(filename);
#else
    open_vector(filename);
#endif
}

BinaryFile::~BinaryFile() {
#if defined(_WIN32) || defined(__unix__) || defined(__APPLE__)
    close_mapped();
#endif
}

BinaryFile::BinaryFile(BinaryFile&& other) noexcept {
    move_from(std::move(other));
}

BinaryFile& BinaryFile::operator=(BinaryFile&& other) noexcept {
    if (this != &other) {
#if defined(_WIN32) || defined(__unix__) || defined(__APPLE__)
        close_mapped();
#endif
        move_from(std::move(other));
    }

    return *this;
}

#if defined(_WIN32)
void BinaryFile::open_mapped(const std::string& filename) {
    file_ = CreateFileA(
                filename.c_str(),
                GENERIC_READ,
                FILE_SHARE_READ,
                nullptr,
                OPEN_EXISTING,
                FILE_ATTRIBUTE_NORMAL,
                nullptr);

    if (static_cast<HANDLE>(file_) == INVALID_HANDLE_VALUE) {
        fatal_error("failed to open file '" + filename +
                    "': " + std::strerror(errno));
    }

    LARGE_INTEGER file_size{};
    if (!GetFileSizeEx(static_cast<HANDLE>(file_), &file_size)) {
        CloseHandle(static_cast<HANDLE>(file_));
        file_ = INVALID_HANDLE_VALUE;
        fatal_error("failed to get file size of '" + filename + "'");
    }

    size_ = static_cast<std::size_t>(file_size.QuadPart);

    if (size_ == 0) {
        return;
    }

    mapping_ = CreateFileMappingA(
                   static_cast<HANDLE>(file_),
                   nullptr,
                   PAGE_READONLY,
                   0,
                   0,
                   nullptr);

    if (!mapping_) {
        CloseHandle(static_cast<HANDLE>(file_));
        file_ = INVALID_HANDLE_VALUE;
        size_ = 0;
        fatal_error("failed to create file mapping for '" + filename + "'");
    }

    data_ = static_cast<const uint8_t*>(
                MapViewOfFile(
                    static_cast<HANDLE>(mapping_),
                    FILE_MAP_READ,
                    0,
                    0,
                    0));

    if (!data_) {
        CloseHandle(static_cast<HANDLE>(mapping_));
        CloseHandle(static_cast<HANDLE>(file_));

        mapping_ = nullptr;
        file_ = INVALID_HANDLE_VALUE;
        size_ = 0;
        fatal_error("failed to map file for '" + filename + "'");
    }
}

void BinaryFile::close_mapped() {
    if (data_) {
        UnmapViewOfFile(data_);
    }

    if (mapping_) {
        CloseHandle(static_cast<HANDLE>(mapping_));
    }

    if (static_cast<HANDLE>(file_) != INVALID_HANDLE_VALUE) {
        CloseHandle(static_cast<HANDLE>(file_));
    }

    data_ = nullptr;
    size_ = 0;
    mapping_ = nullptr;
    file_ = reinterpret_cast<void*>(INVALID_HANDLE_VALUE);
}

#elif defined(__unix__) || defined(__APPLE__)

void BinaryFile::open_mapped(const std::string& filename) {
    fd_ = ::open(filename.c_str(), O_RDONLY);
    if (fd_ < 0) {
        fatal_error("failed to open file '" + filename +
                    "': " + std::strerror(errno));
    }

    struct stat st {};
    if (::fstat(fd_, &st) != 0) {
        ::close(fd_);
        fd_ = -1;
        fatal_error("failed to stat file '" + filename + "'");
    }

    size_ = static_cast<std::size_t>(st.st_size);

    if (size_ == 0) {
        return;
    }

    void* p = ::mmap(
                  nullptr,
                  size_,
                  PROT_READ,
                  MAP_PRIVATE,
                  fd_,
                  0);

    if (p == MAP_FAILED) {
        ::close(fd_);
        fd_ = -1;
        size_ = 0;
        fatal_error("failed to mmap file '" + filename + "'");
    }

    data_ = static_cast<const uint8_t*>(p);
}

void BinaryFile::close_mapped() {
    if (data_) {
        ::munmap(const_cast<uint8_t*>(data_), size_);
    }

    if (fd_ >= 0) {
        ::close(fd_);
    }

    data_ = nullptr;
    size_ = 0;
    fd_ = -1;
}

#else

void BinaryFile::open_vector(const std::string& filename) {
    FILE* f = std::fopen(filename.c_str(), "rb");
    if (!f) {
        fatal_error("failed to open file '" + filename +
                    "': " + std::strerror(errno));
    }

    std::fseek(f, 0, SEEK_END);

    long file_size = std::ftell(f);
    if (file_size < 0) {
        std::fclose(f);
        fatal_error("failed to get file size of '" + filename + "'");
    }

    std::rewind(f);

    storage_.resize(static_cast<std::size_t>(file_size));

    if (!storage_.empty()) {
        std::size_t nread =
            std::fread(storage_.data(), 1, storage_.size(), f);

        if (nread != storage_.size()) {
            std::fclose(f);
            fatal_error("failed to read file '" + filename + "'");
        }
    }

    std::fclose(f);

    data_ = storage_.data();
    size_ = storage_.size();
}

#endif

void BinaryFile::move_from(BinaryFile&& other) noexcept {
    data_ = other.data_;
    size_ = other.size_;

#if defined(_WIN32)

    file_ = other.file_;
    mapping_ = other.mapping_;

    other.file_ = reinterpret_cast<void*>(INVALID_HANDLE_VALUE);
    other.mapping_ = nullptr;

#elif defined(__unix__) || defined(__APPLE__)

    fd_ = other.fd_;
    other.fd_ = -1;

#else

    storage_ = std::move(other.storage_);
    data_ = storage_.data();
    size_ = storage_.size();

#endif

    other.data_ = nullptr;
    other.size_ = 0;
}

const uint8_t* BinaryFile::get_data(size_t& ptr, size_t elem_size) const {
    if (ptr + elem_size > size_) {
        fatal_error("accessing data beyond file end on '" + filename_ + "'");
    }

    const uint8_t* base = data_ + ptr;
    ptr += elem_size;
    return base;
}

static size_t align_up(size_t value, size_t alignment) {
    return (value + alignment - 1) & ~(alignment - 1);
}

void BinaryFile::align_ptr(size_t& ptr) const {
    ptr = align_up(ptr, 4);
}

void BinaryFile::skip(size_t& ptr, size_t amount) const {
    get_data(ptr, amount); // bounds check + advance
}

void BinaryFile::seek(size_t& ptr, size_t new_pos) const {
    if (new_pos > size_) {
        fatal_error("seeking beyond file end on '" + filename_ + "'");
    }
    ptr = new_pos;
}

uint8_t BinaryFile::get_byte(size_t& ptr) const {
    const uint8_t* data = get_data(ptr, sizeof(uint8_t));
    return data[0];
}

uint16_t BinaryFile::get_word(size_t& ptr) const {
    const uint8_t* data = get_data(ptr, sizeof(uint16_t));
    return
        static_cast<uint16_t>(data[0]) |
        (static_cast<uint16_t>(data[1]) << 8);

}

uint32_t BinaryFile::get_dword(size_t& ptr) const {
    const uint8_t* data = get_data(ptr, sizeof(uint32_t));
    return
        static_cast<uint32_t>(data[0]) |
        (static_cast<uint32_t>(data[1]) << 8) |
        (static_cast<uint32_t>(data[2]) << 16) |
        (static_cast<uint32_t>(data[3]) << 24);
}

std::string_view BinaryFile::get_string_view(size_t& ptr,
        size_t str_size) const {
    const uint8_t* data = get_data(ptr, str_size);
    return std::string_view(reinterpret_cast<const char*>(data), str_size);
}

std::string_view BinaryFile::get_byte_string_view(size_t& ptr) const {
    uint8_t str_size = get_byte(ptr);
    return get_string_view(ptr, str_size);
}

std::string_view BinaryFile::get_word_string_view(size_t& ptr) const {
    uint16_t str_size = get_word(ptr);
    return get_string_view(ptr, str_size);
}

// peek_* uses get_* with a copy of ptr so the caller's cursor is not advanced
const uint8_t* BinaryFile::peek_data(size_t ptr, size_t elem_size) const {
    return get_data(ptr, elem_size);
}

uint8_t BinaryFile::peek_byte(size_t ptr) const {
    return get_byte(ptr);
}

uint16_t BinaryFile::peek_word(size_t ptr) const {
    return get_word(ptr);
}

uint32_t BinaryFile::peek_dword(size_t ptr) const {
    return get_dword(ptr);
}

std::string_view BinaryFile::peek_string_view(size_t ptr,
        size_t str_size) const {
    return get_string_view(ptr, str_size);
}

std::string_view BinaryFile::peek_byte_string_view(size_t ptr) const {
    return get_byte_string_view(ptr);
}

std::string_view BinaryFile::peek_word_string_view(size_t ptr) const {
    return get_word_string_view(ptr);
}
