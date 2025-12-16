//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "file_cache.h"
#include "options.h"
#include "utils.h"
#include <fstream>
#include <iostream>
#include <stdexcept>

//-----------------------------------------------------------------------------
// Global file cache instance
//-----------------------------------------------------------------------------

FileCache g_file_cache;

//-----------------------------------------------------------------------------
// FileCache implementation
//-----------------------------------------------------------------------------

bool FileCache::is_stale(const std::string& filename,
                         const CacheEntry& entry) const {
    std::error_code ec;
    auto current_time = std::filesystem::last_write_time(filename, ec);

    if (ec) {
        // File no longer exists or cannot be accessed
        return true;
    }

    // Check if file has been modified since it was cached
    return current_time != entry.last_write_time;
}

const std::vector<char>* FileCache::read_file(const std::string& filename) {
    // Normalize path for consistent cache keys
    std::string normalized = normalize_path(filename);

    // Check cache
    auto it = cache_.find(normalized);
    if (it != cache_.end()) {
        // Check if cached entry is stale
        if (is_stale(filename, *it->second)) {
            // File has been modified - invalidate cache entry
            cache_.erase(it);
            // Fall through to re-read the file
        }
        else {
            // Cache hit with fresh data
            return &it->second->content;
        }
    }

    // Cache miss or stale entry - read file

    // Get file modification time before reading
    std::error_code ec;
    auto write_time = std::filesystem::last_write_time(filename, ec);
    if (ec) {
        // Cannot get file time - file may not exist
        g_errors.error(ErrorCode::FileNotFound, filename);
        return nullptr;
    }

    // Use utils.h read_file_to_string function
    try {
        std::string file_content = read_file_to_string(filename);

        // Create cache entry
        auto entry = std::make_unique<CacheEntry>();
        entry->content.assign(file_content.begin(), file_content.end());
        entry->last_write_time = write_time;

        // Store in cache
        auto* content_ptr = &entry->content;
        cache_[normalized] = std::move(entry);

        return content_ptr;
    }
    catch (const std::runtime_error&) {
        // File could not be read
        g_errors.error(ErrorCode::FileOpenError, filename);
        return nullptr;
    }
}

bool FileCache::is_cached(const std::string& filename) const {
    std::string normalized = normalize_path(filename);
    auto it = cache_.find(normalized);

    if (it == cache_.end()) {
        return false;
    }

    // Check if entry is stale
    return !is_stale(filename, *it->second);
}

void FileCache::invalidate(const std::string& filename) {
    std::string normalized = normalize_path(filename);
    cache_.erase(normalized);
}

void FileCache::clear() {
    cache_.clear();
}

//-----------------------------------------------------------------------------
// FileReader implementation
//-----------------------------------------------------------------------------

std::vector<char> FileReader::empty_content_;

FileReader::FileReader(const std::string& filename) {
    open(filename);
}

bool FileReader::open(const std::string& filename) {
    filename_ = filename;
    content_ = g_file_cache.read_file(filename);
    injected_content_.clear();  // Clear any injected content
    pos_ = 0;
    line_number_ = 0;
    fixed_line_number_ = false;  // Reset to normal behavior
    return content_ != nullptr;
}

void FileReader::inject(const std::string& filename,
                        const std::string& content) {
    inject(filename, std::vector<char>(content.begin(), content.end()));
}

void FileReader::inject(const std::string& filename,
                        const std::vector<char>& content) {
    filename_ = filename;
    injected_content_ = content;
    content_ = &injected_content_;
    pos_ = 0;
    line_number_ = 0;
    fixed_line_number_ = false;  // Reset to normal behavior
}

bool FileReader::is_open() const {
    return content_ != nullptr;
}

const std::string& FileReader::filename() const {
    return filename_;
}

size_t FileReader::size() const {
    return content_ ? content_->size() : 0;
}

const std::vector<char>& FileReader::content() const {
    return content_ ? *content_ : empty_content_;
}

bool FileReader::has_next_line() const {
    if (!content_) {
        return false;
    }
    return pos_ < content_->size();
}

bool FileReader::next_line(std::string& out_line) {
    out_line.clear();

    if (!content_) {
        return false;
    }

    if (pos_ >= content_->size()) {
        return false;
    }

    // Increment line number only if not fixed
    if (!fixed_line_number_ && !just_updated_) {
        ++line_number_;
    }
    just_updated_ = false;

    // Read until newline or end of file
    while (pos_ < content_->size()) {
        char c = (*content_)[pos_++];

        if (c == '\n') {
            break;
        }

        if (c == '\r') {
            // Handle CR-LF or standalone CR
            if (pos_ < content_->size() && (*content_)[pos_] == '\n') {
                ++pos_;  // Skip LF after CR
            }
            break;
        }

        out_line += c;
    }

    Location location(filename_, line_number_);
    g_errors.set_location(location);
    g_errors.set_source_line(out_line);

    return true;
}

void FileReader::reset() {
    pos_ = 0;
    line_number_ = 0;
    fixed_line_number_ = false;
}

size_t FileReader::line_number() const {
    return line_number_;
}

void FileReader::set_line_number(size_t line_num) {
    line_number_ = line_num;
    just_updated_ = true;
}

void FileReader::set_fixed_line_number(size_t line_num) {
    line_number_ = line_num;
    fixed_line_number_ = true;
}

void FileReader::clear_fixed_line_number() {
    fixed_line_number_ = false;
}

bool FileReader::has_fixed_line_number() const {
    return fixed_line_number_;
}

//-----------------------------------------------------------------------------
// BinFileReader implementation
//-----------------------------------------------------------------------------

std::vector<char> BinFileReader::empty_content_;

BinFileReader::BinFileReader(const std::string& filename) {
    open(filename);
}

bool BinFileReader::open(const std::string& filename) {
    filename_ = filename;
    content_ = g_file_cache.read_file(filename);
    injected_content_.clear();  // Clear any injected content
    pos_ = 0;
    return content_ != nullptr;
}

void BinFileReader::inject(const std::string& filename,
                           const std::vector<char>& content) {
    filename_ = filename;
    injected_content_ = content;
    content_ = &injected_content_;
    pos_ = 0;
}

void BinFileReader::inject(const std::string& filename,
                           const std::vector<unsigned char>& content) {
    inject(filename, std::vector<char>(content.begin(), content.end()));
}

void BinFileReader::inject(const std::string& filename,
                           const std::string& content) {
    inject(filename, std::vector<char>(content.begin(), content.end()));
}

bool BinFileReader::is_open() const {
    return content_ != nullptr;
}

const std::string& BinFileReader::filename() const {
    return filename_;
}

size_t BinFileReader::size() const {
    return content_ ? content_->size() : 0;
}

const std::vector<char>& BinFileReader::content() const {
    return content_ ? *content_ : empty_content_;
}

size_t BinFileReader::tell() const {
    return pos_;
}

void BinFileReader::seek(size_t pos) {
    pos_ = pos;
}

void BinFileReader::reset() {
    pos_ = 0;
}

bool BinFileReader::can_read(size_t num_bytes) const {
    if (!content_) {
        return false;
    }
    return (pos_ + num_bytes) <= content_->size();
}

bool BinFileReader::check_bounds(size_t position, size_t num_bytes) const {
    if (!content_) {
        g_errors.error(ErrorCode::FileOpenError, filename_);
        return false;
    }

    if ((position + num_bytes) > content_->size()) {
        g_errors.error(ErrorCode::InvalidObjectFile,
                       filename_ + " at position " + std::to_string(position));
        return false;
    }
    return true;
}

int BinFileReader::read_uint8() {
    if (!check_bounds(pos_, 1)) {
        return 0;
    }

    uint8_t value = static_cast<uint8_t>((*content_)[pos_]);
    pos_++;
    return value;
}

int BinFileReader::read_int16() {
    if (!check_bounds(pos_, 2)) {
        return 0;
    }

    // Little-endian
    int value = static_cast<uint8_t>((*content_)[pos_]) |
                (static_cast<uint8_t>((*content_)[pos_ + 1]) << 8);

    // Sign extend from 16-bit to int
    if (value & 0x8000) {
        value |= ~0xFFFF;
    }

    pos_ += 2;
    return value;
}

int BinFileReader::read_int32() {
    if (!check_bounds(pos_, 4)) {
        return 0;
    }

    // Little-endian
    int value = static_cast<uint8_t>((*content_)[pos_]) |
                (static_cast<uint8_t>((*content_)[pos_ + 1]) << 8) |
                (static_cast<uint8_t>((*content_)[pos_ + 2]) << 16) |
                (static_cast<uint8_t>((*content_)[pos_ + 3]) << 24);

    pos_ += 4;
    return value;
}

std::string BinFileReader::read_string(size_t length) {
    if (length == 0) {
        return "";
    }

    if (!check_bounds(pos_, length)) {
        return "";
    }

    std::string result(content_->begin() + pos_, content_->begin() + pos_ + length);
    pos_ += length;
    return result;
}

int BinFileReader::read_uint8_at(size_t pos) {
    if (!check_bounds(pos, 1)) {
        return 0;
    }

    return static_cast<uint8_t>((*content_)[pos]);
}

int BinFileReader::read_int16_at(size_t pos) {
    if (!check_bounds(pos, 2)) {
        return 0;
    }

    // Little-endian
    int value = static_cast<uint8_t>((*content_)[pos]) |
                (static_cast<uint8_t>((*content_)[pos + 1]) << 8);

    // Sign extend from 16-bit to int
    if (value & 0x8000) {
        value |= ~0xFFFF;
    }

    return value;
}

int BinFileReader::read_int32_at(size_t pos) {
    if (!check_bounds(pos, 4)) {
        return 0;
    }

    // Little-endian
    int value = static_cast<uint8_t>((*content_)[pos]) |
                (static_cast<uint8_t>((*content_)[pos + 1]) << 8) |
                (static_cast<uint8_t>((*content_)[pos + 2]) << 16) |
                (static_cast<uint8_t>((*content_)[pos + 3]) << 24);

    return value;
}

std::string BinFileReader::read_string_at(size_t pos, size_t length) {
    if (length == 0) {
        return "";
    }

    if (!check_bounds(pos, length)) {
        return "";
    }

    return std::string(content_->begin() + pos, content_->begin() + pos + length);
}

//-----------------------------------------------------------------------------
// Dependency file creator
//-----------------------------------------------------------------------------

void DependencyFile::clear() {
    dependencies_.clear();
}

void DependencyFile::add_dependency(const std::string& filename) {
    dependencies_.push_back(filename);
}

const std::vector<std::string>& DependencyFile::dependencies() const {
    return dependencies_;
}

bool DependencyFile::write() {
    const size_t LINE_WIDTH = 80;

    if (dependencies_.empty()) {
        return false;
    }

    // get main source file
    std::string target = dependencies_.front();

    // get dependency file name and target file name
    std::string d_filename = g_options.get_d_filename(target);
    std::string o_filename = g_options.get_o_filename(target);

    // generate dependency file
    std::ofstream ofs(d_filename, std::ios::out | std::ios::binary);
    if (!ofs) {
        g_errors.error(ErrorCode::FileOpenError, d_filename);
        return false;
    }

    if (g_options.verbose) {
        std::cout << "Generating dependency file: " << d_filename << std::endl;
    }

    // output file names
    size_t pos = 0;
    ofs << o_filename << ":";
    pos += o_filename.size() + 1;

    for (auto& f : dependencies_) {
        if (pos + f.size() + 1 + 2 >= LINE_WIDTH) { // +2: account for space-backslash
            pos = 7;
            ofs << " \\" << std::endl << std::string(pos, ' ');
        }

        ofs << " " << f;
        pos += f.size() + 1;
    }
    ofs << std::endl;

    return true;
}
