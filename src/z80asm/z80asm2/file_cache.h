//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include <chrono>
#include <cstddef>
#include <filesystem>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// FileCache - caches file contents in memory for efficient access
//-----------------------------------------------------------------------------

class FileCache {
public:
    FileCache() = default;
    ~FileCache() = default;

    // Disable copy/move
    FileCache(const FileCache&) = delete;
    FileCache& operator=(const FileCache&) = delete;
    FileCache(FileCache&&) = delete;
    FileCache& operator=(FileCache&&) = delete;

    // Read entire file into memory (from cache if available)
    // Returns nullptr if file cannot be read
    const std::vector<char>* read_file(const std::string& filename);

    // Check if file exists in cache
    bool is_cached(const std::string& filename) const;

    // Remove file from cache
    void invalidate(const std::string& filename);

    // Clear all cached files
    void clear();

#ifdef UNIT_TESTS
    // Test-only methods
    size_t cache_size() const {
        return cache_.size();
    }

    bool is_cached_and_fresh(const std::string& filename) const {
        std::string normalized = normalize_path(filename);
        auto it = cache_.find(normalized);
        if (it == cache_.end()) {
            return false;
        }
        return !is_stale(filename, *it->second);
    }
#endif

private:
    // Cached file entry
    struct CacheEntry {
        std::vector<char> content;
        std::filesystem::file_time_type last_write_time;
    };

    // Check if cached entry is stale (file modified since cached)
    bool is_stale(const std::string& filename, const CacheEntry& entry) const;

    std::unordered_map<std::string, std::unique_ptr<CacheEntry>> cache_;
};

// Global file cache instance
extern FileCache g_file_cache;

//-----------------------------------------------------------------------------
// FileReader - RAII wrapper for reading files with line-by-line access
//-----------------------------------------------------------------------------

class FileReader {
public:
    // Default constructor (creates unopened reader)
    FileReader() = default;

    // Open file (uses g_file_cache internally)
    explicit FileReader(const std::string& filename);

    // Open file for delayed initialization
    virtual bool open(const std::string& filename);

    // Inject content directly (creates virtual file)
    virtual void inject(const std::string& filename, const std::string& content);
    void inject(const std::string& filename, const std::vector<char>& content);

    // Check if file was successfully opened
    bool is_open() const;

    // Get filename
    const std::string& filename() const;

    // Get file size in bytes
    size_t size() const;

    // Get entire content
    const std::vector<char>& content() const;

    // Line-by-line access
    bool has_next_line() const;
    bool next_line(std::string& out_line);  // Read next line, returns false at EOF
    void reset();                            // Reset to beginning of file

    // Get current line number (1-based)
    size_t line_number() const;

    // Line number control (for virtual files / macro expansion)
    virtual void set_line_number(size_t line_num);
    virtual void set_fixed_line_number(size_t line_num);
    void clear_fixed_line_number();
    bool has_fixed_line_number() const;

protected:
    std::string filename_;
    const std::vector<char>* content_ = nullptr;
    std::vector<char> injected_content_;// Storage for injected content
    size_t pos_ = 0;                    // Current position in content
    size_t line_number_ = 0;            // Current line number (1-based)
    bool fixed_line_number_ = false;    // true if line_number_ should not increment
    bool just_updated_ = false;         // true if line_number_ was just set manually

    static std::vector<char> empty_content_;
};

//-----------------------------------------------------------------------------
// BinFileReader - RAII wrapper for reading binary structured data files
//-----------------------------------------------------------------------------

class BinFileReader {
public:
    // Default constructor (creates unopened reader)
    BinFileReader() = default;

    // Open binary file (uses g_file_cache internally)
    explicit BinFileReader(const std::string& filename);

    // Open file for delayed initialization
    bool open(const std::string& filename);

    // Inject content directly (creates virtual file)
    void inject(const std::string& filename, const std::vector<char>& content);
    void inject(const std::string& filename,
                const std::vector<unsigned char>& content);
    void inject(const std::string& filename, const std::string& content);

    // Check if file was successfully opened
    bool is_open() const;

    // Get filename
    const std::string& filename() const;

    // Get file size in bytes
    size_t size() const;

    // Get entire content
    const std::vector<char>& content() const;

    // Position management
    size_t tell() const;                    // Get current position
    void seek(size_t pos);                  // Set position (absolute)
    void reset();                           // Reset to beginning of file

    // Read operations from current position (advances position)
    int read_uint8();
    int read_int16();
    int read_int32();
    std::string read_string(size_t length);

    // Read operations from specified position (does not change current position)
    int read_uint8_at(size_t pos);
    int read_int16_at(size_t pos);
    int read_int32_at(size_t pos);
    std::string read_string_at(size_t pos, size_t length);

    // Check if we can read N bytes from current position
    bool can_read(size_t num_bytes) const;

private:
    std::string filename_;
    const std::vector<char>* content_ = nullptr;
    std::vector<char> injected_content_;  // Storage for injected content
    size_t pos_ = 0;                        // Current position in content

    // Helper: check bounds and report error if out of bounds
    bool check_bounds(size_t position, size_t num_bytes) const;

    static std::vector<char> empty_content_;
};

//-----------------------------------------------------------------------------
// Dependency file creator
//-----------------------------------------------------------------------------

class DependencyFile {
public:
    DependencyFile() = default;
    void clear();
    void add_dependency(const std::string& filename);
    const std::vector<std::string>& dependencies() const;
    bool write();

private:
    std::vector<std::string> dependencies_;
};
