//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../file_cache.h"
#include "../utils.h"
#include "catch_amalgamated.hpp"
#include <chrono>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>
#include <thread>

// Test utility class for creating temporary test files
class test_file {
public:
    test_file(const std::string& filename, const std::string& content)
        : filename_(filename) {
        write_string_to_file(filename_, content);
    }

    ~test_file() {
        std::remove(filename_.c_str());
    }

    const std::string& name() const {
        return filename_;
    }

private:
    std::string filename_;
};

//-----------------------------------------------------------------------------
// Test FileCache basic functionality
//-----------------------------------------------------------------------------

TEST_CASE("FileCache: read_file returns nullptr for non-existent file",
          "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "nonexistent_file_12345.txt";
    std::remove(fname.c_str());

    const auto* content = g_file_cache.read_file(fname);

    REQUIRE(content == nullptr);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("FileCache: read_file caches file content", "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_cache_read.txt";
    const std::string content_str = "Hello, World!\nLine 2\n";

    write_string_to_file(fname, content_str);

    // First read - cache miss
    const auto* content1 = g_file_cache.read_file(fname);
    REQUIRE(content1 != nullptr);
    REQUIRE(content1->size() == content_str.size());
    REQUIRE(std::string(content1->begin(), content1->end()) == content_str);
    REQUIRE_FALSE(g_errors.has_errors());

    // Second read - cache hit (should return same pointer)
    const auto* content2 = g_file_cache.read_file(fname);
    REQUIRE(content2 == content1);

    // Verify file is cached
    REQUIRE(g_file_cache.is_cached(fname));

    std::remove(fname.c_str());
}

TEST_CASE("FileCache: invalidate removes file from cache", "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_cache_invalidate.txt";
    write_string_to_file(fname, "test content");

    // Cache the file
    const auto* content1 = g_file_cache.read_file(fname);
    REQUIRE(content1 != nullptr);
    REQUIRE(g_file_cache.is_cached(fname));

    // Invalidate
    g_file_cache.invalidate(fname);
    REQUIRE_FALSE(g_file_cache.is_cached(fname));

    // Read again - should be different pointer
    const auto* content2 = g_file_cache.read_file(fname);
    REQUIRE(content2 != nullptr);
    REQUIRE(content2 != content1);  // Different pointer because it was re-read

    std::remove(fname.c_str());
}

TEST_CASE("FileCache: clear removes all cached files", "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname1 = "test_clear_1.txt";
    const std::string fname2 = "test_clear_2.txt";

    write_string_to_file(fname1, "file 1");
    write_string_to_file(fname2, "file 2");

    g_file_cache.read_file(fname1);
    g_file_cache.read_file(fname2);

    REQUIRE(g_file_cache.is_cached(fname1));
    REQUIRE(g_file_cache.is_cached(fname2));

    g_file_cache.clear();

    REQUIRE_FALSE(g_file_cache.is_cached(fname1));
    REQUIRE_FALSE(g_file_cache.is_cached(fname2));

    std::remove(fname1.c_str());
    std::remove(fname2.c_str());
}

TEST_CASE("FileCache: detects file modification and re-reads",
          "[file_cache][stale]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_modification.txt";

    // Write initial content
    write_string_to_file(fname, "version 1");

    // Read and cache
    const auto* content1 = g_file_cache.read_file(fname);
    REQUIRE(content1 != nullptr);
    REQUIRE(std::string(content1->begin(), content1->end()) == "version 1");

    // Wait long enough to ensure different timestamp (2+ seconds for most filesystems)
    std::this_thread::sleep_for(std::chrono::seconds(3));

    // Modify file
    write_string_to_file(fname, "version 2");

    // Read again - should detect modification and re-read
    const auto* content2 = g_file_cache.read_file(fname);
    REQUIRE(content2 != nullptr);
    REQUIRE(std::string(content2->begin(), content2->end()) == "version 2");

    std::remove(fname.c_str());
}

TEST_CASE("FileCache: handles binary files with null bytes", "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_binary.bin";
    const std::vector<unsigned char> binary_data = {0x00, 0x01, 0xFF, 0x00, 0x7E};

    write_bytes_to_file(fname, binary_data);

    const auto* content = g_file_cache.read_file(fname);
    REQUIRE(content != nullptr);
    REQUIRE(content->size() == binary_data.size());

    for (size_t i = 0; i < binary_data.size(); ++i) {
        REQUIRE(static_cast<unsigned char>((*content)[i]) == binary_data[i]);
    }

    std::remove(fname.c_str());
}

TEST_CASE("FileCache: handles empty files", "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_empty.txt";
    write_string_to_file(fname, "");

    const auto* content = g_file_cache.read_file(fname);
    REQUIRE(content != nullptr);
    REQUIRE(content->empty());

    std::remove(fname.c_str());
}

TEST_CASE("FileCache: normalizes paths for cache keys", "[file_cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_normalize.txt";
    write_string_to_file(fname, "test");

    // Read with different path representations
    const auto* content1 = g_file_cache.read_file(fname);
    const auto* content2 = g_file_cache.read_file("./" + fname);

    // Should return same cached content
    REQUIRE(content1 != nullptr);
    REQUIRE(content2 == content1);

    std::remove(fname.c_str());
}

//-----------------------------------------------------------------------------
// Test FileReader
//-----------------------------------------------------------------------------

TEST_CASE("FileReader: opens and reads file", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_reader.txt";
    write_string_to_file(fname, "Line 1\nLine 2\nLine 3\n");

    FileReader reader(fname);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == fname);
    REQUIRE(reader.size() == 21);
    REQUIRE(reader.line_number() == 0);

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: fails to open non-existent file", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "nonexistent_12345.txt";
    std::remove(fname.c_str());

    FileReader reader(fname);

    REQUIRE_FALSE(reader.is_open());
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("FileReader: reads lines correctly", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_reader_lines.txt";
    write_string_to_file(fname, "Line 1\nLine 2\nLine 3");

    FileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string line;

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 1);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 2");
    REQUIRE(reader.line_number() == 2);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 3");
    REQUIRE(reader.line_number() == 3);

    REQUIRE_FALSE(reader.next_line(line));
    REQUIRE(line.empty());

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: handles different line endings", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_line_endings.txt";

    // Create file with mixed line endings
    std::string content = "Unix\nWindows\r\nMac\rEnd";
    write_string_to_file(fname, content);

    FileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string line;

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Unix");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Windows");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Mac");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "End");

    REQUIRE_FALSE(reader.next_line(line));

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: reset restarts reading", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_reset.txt";
    write_string_to_file(fname, "Line 1\nLine 2\n");

    FileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string line;

    // Read first line
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 1);

    // Reset
    reader.reset();
    REQUIRE(reader.line_number() == 0);

    // Read again from beginning
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 1);

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: handles empty file", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_empty_reader.txt";
    write_string_to_file(fname, "");

    FileReader reader(fname);
    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 0);
    REQUIRE_FALSE(reader.has_next_line());

    std::string line;
    REQUIRE_FALSE(reader.next_line(line));

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: content() returns file contents", "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_content.txt";
    const std::string text = "Hello\nWorld\n";
    write_string_to_file(fname, text);

    FileReader reader(fname);
    REQUIRE(reader.is_open());

    const auto& content = reader.content();
    REQUIRE(content.size() == text.size());
    REQUIRE(std::string(content.begin(), content.end()) == text);

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: handles file without trailing newline",
          "[file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_no_newline.txt";
    write_string_to_file(fname, "No newline at end");

    FileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "No newline at end");

    REQUIRE_FALSE(reader.next_line(line));

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: default constructor", "[file_cache]") {
    FileReader reader;

    REQUIRE_FALSE(reader.is_open());
    REQUIRE(reader.filename().empty());
    REQUIRE(reader.size() == 0);
    REQUIRE_FALSE(reader.has_next_line());

    std::string line;
    REQUIRE_FALSE(reader.next_line(line));
    REQUIRE(reader.line_number() == 0);
}

TEST_CASE("FileReader: default constructor then open", "[file_cache]") {
    test_file file("test.txt", "Hello\nWorld\n");

    FileReader reader;  // Default construct
    REQUIRE_FALSE(reader.is_open());

    // Open the file
    REQUIRE(reader.open(file.name()));
    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == file.name());
    REQUIRE(reader.size() == 12);

    // Read lines
    std::string line;
    REQUIRE(reader.has_next_line());
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Hello");
    REQUIRE(reader.line_number() == 1);

    REQUIRE(reader.has_next_line());
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "World");
    REQUIRE(reader.line_number() == 2);

    REQUIRE_FALSE(reader.has_next_line());
}

TEST_CASE("FileReader: reopen with different file", "[file_cache]") {
    test_file file1("test1.txt", "First\n");
    test_file file2("test2.txt", "Second\n");

    FileReader reader;

    // Open first file
    REQUIRE(reader.open(file1.name()));
    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "First");

    // Open second file (replaces first)
    REQUIRE(reader.open(file2.name()));
    REQUIRE(reader.filename() == file2.name());
    REQUIRE(reader.line_number() == 0);  // Reset

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Second");
}

TEST_CASE("FileReader: open nonexistent file", "[file_cache]") {
    SuppressErrors suppress;
    FileReader reader;

    REQUIRE_FALSE(reader.open("nonexistent.txt"));
    REQUIRE_FALSE(reader.is_open());
    REQUIRE(reader.filename() ==
            "nonexistent.txt");  // Filename is set even on failure
    REQUIRE(reader.size() == 0);
    REQUIRE_FALSE(reader.has_next_line());

    std::string line;
    REQUIRE_FALSE(reader.next_line(line));
}

TEST_CASE("FileReader: member variable usage", "[file_cache]") {
    test_file file("test.txt", "Line1\nLine2\n");

    // Simulate member variable usage
    struct TestClass {
        FileReader reader;  // Can now be a member without initialization

        bool load(const std::string& filename) {
            return reader.open(filename);
        }

        std::string read_first_line() {
            std::string line;
            if (reader.next_line(line)) {
                return line;
            }
            return "";
        }
    };

    TestClass obj;
    REQUIRE_FALSE(obj.reader.is_open());  // Default constructed

    REQUIRE(obj.load(file.name()));
    REQUIRE(obj.reader.is_open());

    REQUIRE(obj.read_first_line() == "Line1");
}

TEST_CASE("FileReader: constructor still works", "[file_cache]") {
    test_file file("test.txt", "Line1\nLine2\n");

    // Constructor should still work as before
    FileReader reader(file.name());

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == file.name());

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line1");
}

//-----------------------------------------------------------------------------
// Test BinFileReader
//-----------------------------------------------------------------------------

TEST_CASE("BinFileReader: default constructor", "[bin_file_reader]") {
    BinFileReader reader;

    REQUIRE_FALSE(reader.is_open());
    REQUIRE(reader.filename().empty());
    REQUIRE(reader.size() == 0);
    REQUIRE(reader.tell() == 0);
    REQUIRE_FALSE(reader.can_read(1));
}

TEST_CASE("BinFileReader: default constructor then open", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_bin_default.bin";
    const std::vector<unsigned char> data = { 0x01, 0x02, 0x03, 0x04, 0x05 };
    write_bytes_to_file(fname, data);

    BinFileReader reader;  // Default construct
    REQUIRE_FALSE(reader.is_open());

    // Open the file
    REQUIRE(reader.open(fname));
    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == fname);
    REQUIRE(reader.size() == 5);
    REQUIRE(reader.tell() == 0);

    // Read data
    REQUIRE(reader.read_uint8() == 0x01);
    REQUIRE(reader.tell() == 1);
    REQUIRE(reader.read_uint8() == 0x02);
    REQUIRE(reader.tell() == 2);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: reopen with different file", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname1 = "test_bin1.bin";
    const std::string fname2 = "test_bin2.bin";
    const std::vector<unsigned char> data1 = { 0x10, 0x20 };
    const std::vector<unsigned char> data2 = { 0x30, 0x40, 0x50 };

    write_bytes_to_file(fname1, data1);
    write_bytes_to_file(fname2, data2);

    BinFileReader reader;

    // Open first file
    REQUIRE(reader.open(fname1));
    REQUIRE(reader.read_uint8() == 0x10);
    REQUIRE(reader.read_uint8() == 0x20);

    // Open second file (replaces first)
    REQUIRE(reader.open(fname2));
    REQUIRE(reader.filename() == fname2);
    REQUIRE(reader.tell() == 0);  // Reset
    REQUIRE(reader.size() == 3);

    REQUIRE(reader.read_uint8() == 0x30);
    REQUIRE(reader.read_uint8() == 0x40);
    REQUIRE(reader.read_uint8() == 0x50);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname1.c_str());
    std::remove(fname2.c_str());
}

TEST_CASE("BinFileReader: open nonexistent file", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    BinFileReader reader;

    REQUIRE_FALSE(reader.open("nonexistent_bin.bin"));
    REQUIRE_FALSE(reader.is_open());
    REQUIRE(reader.filename() ==
            "nonexistent_bin.bin");  // Filename is set even on failure
    REQUIRE(reader.size() == 0);
    REQUIRE(reader.tell() == 0);
    REQUIRE_FALSE(reader.can_read(1));
}

TEST_CASE("BinFileReader: read operations on unopened file",
          "[bin_file_reader]") {
    SuppressErrors suppress;

    BinFileReader reader;  // Default construct, not opened
    REQUIRE_FALSE(reader.is_open());

    // All read operations should fail gracefully
    REQUIRE(reader.read_uint8() == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress2;
    REQUIRE(reader.read_int16() == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress3;
    REQUIRE(reader.read_int32() == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress4;
    REQUIRE(reader.read_string(5).empty());
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress5;
    REQUIRE(reader.read_uint8_at(0) == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress6;
    REQUIRE(reader.read_int16_at(0) == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress7;
    REQUIRE(reader.read_int32_at(0) == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress8;
    REQUIRE(reader.read_string_at(0, 5).empty());
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("BinFileReader: member variable usage", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_bin_member.bin";
    const std::vector<unsigned char> data = { 0xAA, 0xBB, 0xCC, 0xDD };
    write_bytes_to_file(fname, data);

    // Simulate member variable usage
    struct TestClass {
        BinFileReader reader;  // Can now be a member without initialization

        bool load(const std::string& filename) {
            return reader.open(filename);
        }

        int read_first_byte() {
            if (reader.is_open()) {
                return reader.read_uint8();
            }
            return -1;
        }
    };

    TestClass obj;
    REQUIRE_FALSE(obj.reader.is_open());  // Default constructed

    REQUIRE(obj.load(fname));
    REQUIRE(obj.reader.is_open());

    REQUIRE(obj.read_first_byte() == 0xAA);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: constructor still works", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_bin_ctor.bin";
    const std::vector<unsigned char> data = { 0x11, 0x22 };
    write_bytes_to_file(fname, data);

    // Constructor should still work as before
    BinFileReader reader(fname);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == fname);
    REQUIRE(reader.size() == 2);

    REQUIRE(reader.read_uint8() == 0x11);
    REQUIRE(reader.read_uint8() == 0x22);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: opens and reads binary file", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_bin_reader.bin";
    const std::vector<unsigned char> data = {0x01, 0x02, 0x03, 0x04, 0x05};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == fname);
    REQUIRE(reader.size() == 5);
    REQUIRE(reader.tell() == 0);
    REQUIRE_FALSE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: fails to open non-existent file",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "nonexistent_bin_12345.bin";
    std::remove(fname.c_str());

    BinFileReader reader(fname);

    REQUIRE_FALSE(reader.is_open());
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("BinFileReader: read_uint8 reads single byte", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_uint8.bin";
    const std::vector<unsigned char> data = {0x00, 0x42, 0xFF, 0x7F, 0x80};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_uint8() == 0x00);
    REQUIRE(reader.tell() == 1);

    REQUIRE(reader.read_uint8() == 0x42);
    REQUIRE(reader.tell() == 2);

    REQUIRE(reader.read_uint8() == 0xFF);
    REQUIRE(reader.tell() == 3);

    REQUIRE(reader.read_uint8() == 0x7F);
    REQUIRE(reader.read_uint8() == 0x80);
    REQUIRE(reader.tell() == 5);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_int16 reads little-endian 16-bit integers",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_int16.bin";
    // Little-endian: 0x0000, 0x1234, 0xFFFF (or -1)
    const std::vector<unsigned char> data = {
        0x00, 0x00,  // 0
        0x34, 0x12,  // 0x1234
        0xFF, 0xFF,  // -1
        0x00, 0x80   // -32768
    };
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_int16() == 0);
    REQUIRE(reader.tell() == 2);

    REQUIRE(reader.read_int16() == 0x1234);
    REQUIRE(reader.tell() == 4);

    REQUIRE(reader.read_int16() == -1);
    REQUIRE(reader.tell() == 6);

    REQUIRE(reader.read_int16() == -32768);
    REQUIRE(reader.tell() == 8);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_int32 reads little-endian 32-bit integers",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_int32.bin";
    // Little-endian: 0x00000000, 0x12345678, 0xFFFFFFFF (or -1)
    const std::vector<unsigned char> data = {
        0x00, 0x00, 0x00, 0x00,  // 0
        0x78, 0x56, 0x34, 0x12,  // 0x12345678
        0xFF, 0xFF, 0xFF, 0xFF,  // -1
        0x00, 0x00, 0x00, 0x80   // -2147483648
    };
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_int32() == 0);
    REQUIRE(reader.tell() == 4);

    REQUIRE(reader.read_int32() == 0x12345678);
    REQUIRE(reader.tell() == 8);

    REQUIRE(reader.read_int32() == -1);
    REQUIRE(reader.tell() == 12);

    REQUIRE(reader.read_int32() == static_cast<int>(-2147483648));
    REQUIRE(reader.tell() == 16);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_string reads specified length",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_string.bin";
    const std::string content = "Hello, World!";
    write_string_to_file(fname, content);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string str1 = reader.read_string(5);
    REQUIRE(str1 == "Hello");
    REQUIRE(reader.tell() == 5);

    std::string str2 = reader.read_string(2);
    REQUIRE(str2 == ", ");
    REQUIRE(reader.tell() == 7);

    std::string str3 = reader.read_string(6);
    REQUIRE(str3 == "World!");
    REQUIRE(reader.tell() == 13);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_string handles empty string",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_empty_string.bin";
    write_string_to_file(fname, "test");

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string str = reader.read_string(0);
    REQUIRE(str.empty());
    REQUIRE(reader.tell() == 0);  // Position should not advance

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_string handles embedded nulls",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_null_string.bin";
    const std::vector<unsigned char> data = {0x41, 0x00, 0x42, 0x00, 0x43};  // "A\0B\0C"
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string str = reader.read_string(5);
    REQUIRE(str.size() == 5);
    REQUIRE(str[0] == 'A');
    REQUIRE(str[1] == '\0');
    REQUIRE(str[2] == 'B');
    REQUIRE(str[3] == '\0');
    REQUIRE(str[4] == 'C');

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_uint8_at reads from specified position",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_uint8_at.bin";
    const std::vector<unsigned char> data = {0x10, 0x20, 0x30, 0x40, 0x50};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    // Read from various positions without changing current position
    REQUIRE(reader.read_uint8_at(0) == 0x10);
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_uint8_at(2) == 0x30);
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_uint8_at(4) == 0x50);
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_int16_at reads from specified position",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_int16_at.bin";
    const std::vector<unsigned char> data = {
        0x34, 0x12,  // 0x1234 at offset 0
        0x78, 0x56,  // 0x5678 at offset 2
        0xCD, 0xAB   // 0xABCD at offset 4
    };
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_int16_at(0) == 0x1234);
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_int16_at(2) == 0x5678);
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_int16_at(4) == static_cast<int16_t>(0xABCD));
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_int32_at reads from specified position",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_int32_at.bin";
    const std::vector<unsigned char> data = {
        0x78, 0x56, 0x34, 0x12,  // 0x12345678 at offset 0
        0xEF, 0xCD, 0xAB, 0x90   // 0x90ABCDEF at offset 4
    };
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_int32_at(0) == 0x12345678);
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_int32_at(4) == static_cast<int32_t>(0x90ABCDEF));
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_string_at reads from specified position",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_string_at.bin";
    write_string_to_file(fname, "0123456789");

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_string_at(0, 3) == "012");
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_string_at(5, 3) == "567");
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE(reader.read_string_at(7, 3) == "789");
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_string_at handles empty string",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_empty_string_at.bin";
    write_string_to_file(fname, "test");

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    std::string str = reader.read_string_at(2, 0);
    REQUIRE(str.empty());
    REQUIRE(reader.tell() == 0);  // Position unchanged

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: seek and tell manage position", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_seek.bin";
    const std::vector<unsigned char> data = {0x00, 0x11, 0x22, 0x33, 0x44};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.tell() == 0);

    reader.seek(2);
    REQUIRE(reader.tell() == 2);
    REQUIRE(reader.read_uint8() == 0x22);
    REQUIRE(reader.tell() == 3);

    reader.seek(0);
    REQUIRE(reader.tell() == 0);
    REQUIRE(reader.read_uint8() == 0x00);

    reader.seek(4);
    REQUIRE(reader.tell() == 4);
    REQUIRE(reader.read_uint8() == 0x44);

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: reset resets position to beginning",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_reset.bin";
    const std::vector<unsigned char> data = {0x01, 0x02, 0x03};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_uint8() == 0x01);
    REQUIRE(reader.read_uint8() == 0x02);
    REQUIRE(reader.tell() == 2);

    reader.reset();
    REQUIRE(reader.tell() == 0);

    REQUIRE(reader.read_uint8() == 0x01);
    REQUIRE(reader.tell() == 1);

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: can_read checks available bytes",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_can_read.bin";
    const std::vector<unsigned char> data = {0x01, 0x02, 0x03, 0x04, 0x05};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.can_read(5));
    REQUIRE(reader.can_read(3));
    REQUIRE_FALSE(reader.can_read(6));

    reader.read_uint8();
    reader.read_uint8();
    REQUIRE(reader.tell() == 2);

    REQUIRE(reader.can_read(3));
    REQUIRE_FALSE(reader.can_read(4));

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read past end of file generates error",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_read_past_end.bin";
    const std::vector<unsigned char> data = {0x01, 0x02};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_uint8() == 0x01);
    REQUIRE(reader.read_uint8() == 0x02);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to read past end
    SuppressErrors suppress2;
    int value = reader.read_uint8();
    REQUIRE(value == 0);
    REQUIRE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_int16 past end generates error",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_int16_past_end.bin";
    const std::vector<unsigned char> data = {0x01, 0x02, 0x03};  // Only 3 bytes
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_uint8() == 0x01);

    // Try to read 2 bytes with only 2 remaining
    REQUIRE(reader.read_int16() == 0x0302);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to read past end
    SuppressErrors suppress2;
    int value = reader.read_int16();
    REQUIRE(value == 0);
    REQUIRE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_int32 past end generates error",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_int32_past_end.bin";
    const std::vector<unsigned char> data = {0x01, 0x02};  // Only 2 bytes
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    // Try to read 4 bytes with only 2 available
    SuppressErrors suppress2;
    int value = reader.read_int32();
    REQUIRE(value == 0);
    REQUIRE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: read_string past end generates error",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_string_past_end.bin";
    write_string_to_file(fname, "12345");

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    // Read some bytes
    reader.read_string(3);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to read more than remaining
    SuppressErrors suppress2;
    std::string str = reader.read_string(5);
    REQUIRE(str.empty());
    REQUIRE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: _at methods with out-of-bounds position generate error",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_at_out_of_bounds.bin";
    const std::vector<unsigned char> data = {0x01, 0x02, 0x03};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    // Try to read at invalid positions
    SuppressErrors suppress2;
    int value = reader.read_uint8_at(10);
    REQUIRE(value == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress3;
    value = reader.read_int16_at(
                2);  // Would need bytes at 2 and 3, but only 3 exists
    REQUIRE(value == 0);
    REQUIRE(g_errors.has_errors());

    SuppressErrors suppress4;
    std::string str = reader.read_string_at(2, 5);
    REQUIRE(str.empty());
    REQUIRE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: handles empty file", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_empty_bin.bin";
    write_bytes_to_file(fname, {});

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 0);
    REQUIRE(reader.tell() == 0);
    REQUIRE_FALSE(reader.can_read(1));

    // Try to read from empty file
    SuppressErrors suppress2;
    int value = reader.read_uint8();
    REQUIRE(value == 0);
    REQUIRE(g_errors.has_errors());

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: content() returns file contents",
          "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_content.bin";
    const std::vector<unsigned char> data = {0xDE, 0xAD, 0xBE, 0xEF};
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    const auto& content = reader.content();
    REQUIRE(content.size() == 4);
    REQUIRE(static_cast<uint8_t>(content[0]) == 0xDE);
    REQUIRE(static_cast<uint8_t>(content[1]) == 0xAD);
    REQUIRE(static_cast<uint8_t>(content[2]) == 0xBE);
    REQUIRE(static_cast<uint8_t>(content[3]) == 0xEF);

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: mixed read operations", "[bin_file_reader]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_mixed_read.bin";
    // Create a structured binary file:
    // uint8:  0x42
    // int16:  0x1234 (little-endian: 0x34, 0x12)
    // int32:  0x12345678 (little-endian: 0x78, 0x56, 0x34, 0x12)
    // string: "TEST" (4 bytes)
    const std::vector<unsigned char> data = {
        0x42,                        // uint8
        0x34, 0x12,                 // int16
        0x78, 0x56, 0x34, 0x12,     // int32
        'T', 'E', 'S', 'T'          // string
    };
    write_bytes_to_file(fname, data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());

    REQUIRE(reader.read_uint8() == 0x42);
    REQUIRE(reader.tell() == 1);

    REQUIRE(reader.read_int16() == 0x1234);
    REQUIRE(reader.tell() == 3);

    REQUIRE(reader.read_int32() == 0x12345678);
    REQUIRE(reader.tell() == 7);

    REQUIRE(reader.read_string(4) == "TEST");
    REQUIRE(reader.tell() == 11);

    REQUIRE_FALSE(g_errors.has_errors());
    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: uses file cache", "[bin_file_reader][cache]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_cache_usage.bin";
    const std::vector<unsigned char> data = {0x01, 0x02, 0x03};
    write_bytes_to_file(fname, data);

    // First reader caches the file
    BinFileReader reader1(fname);
    REQUIRE(reader1.is_open());
    REQUIRE(g_file_cache.is_cached(fname));

    // Second reader uses cached data
    BinFileReader reader2(fname);
    REQUIRE(reader2.is_open());

    // Both readers should work independently
    REQUIRE(reader1.read_uint8() == 0x01);
    REQUIRE(reader2.read_uint8() == 0x01);

    REQUIRE(reader1.tell() == 1);
    REQUIRE(reader2.tell() == 1);

    std::remove(fname.c_str());
}

//-----------------------------------------------------------------------------
// Test FileReader inject functionality
//-----------------------------------------------------------------------------

TEST_CASE("FileReader: inject string content", "[file_reader][inject]") {
    FileReader reader;

    reader.inject("virtual.txt", "Line 1\nLine 2\nLine 3\n");

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.txt");
    REQUIRE(reader.size() == 21);
    REQUIRE(reader.line_number() == 0);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 1);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 2");
    REQUIRE(reader.line_number() == 2);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 3");
    REQUIRE(reader.line_number() == 3);

    REQUIRE_FALSE(reader.next_line(line));
}

TEST_CASE("FileReader: inject vector content", "[file_reader][inject]") {
    FileReader reader;

    std::string text = "Hello\nWorld\n";
    std::vector<char> content(text.begin(), text.end());

    reader.inject("virtual.txt", content);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.txt");
    REQUIRE(reader.size() == 12);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Hello");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "World");

    REQUIRE_FALSE(reader.next_line(line));
}

TEST_CASE("FileReader: inject empty content", "[file_reader][inject]") {
    FileReader reader;

    reader.inject("empty.txt", "");

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "empty.txt");
    REQUIRE(reader.size() == 0);
    REQUIRE_FALSE(reader.has_next_line());

    std::string line;
    REQUIRE_FALSE(reader.next_line(line));
}

TEST_CASE("FileReader: inject replaces open file", "[file_reader][inject]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_inject_replace.txt";
    write_string_to_file(fname, "File content");

    FileReader reader(fname);
    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 12);

    // Inject new content
    reader.inject("virtual.txt", "Injected content");

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.txt");
    REQUIRE(reader.size() == 16);
    REQUIRE(reader.line_number() == 0);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Injected content");

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: inject with different line endings",
          "[file_reader][inject]") {
    FileReader reader;

    reader.inject("mixed.txt", "Unix\nWindows\r\nMac\rEnd");

    REQUIRE(reader.is_open());

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Unix");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Windows");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Mac");

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "End");

    REQUIRE_FALSE(reader.next_line(line));
}

TEST_CASE("FileReader: inject and reset", "[file_reader][inject]") {
    FileReader reader;

    reader.inject("virtual.txt", "First\nSecond\n");

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "First");
    REQUIRE(reader.line_number() == 1);

    reader.reset();
    REQUIRE(reader.line_number() == 0);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "First");
    REQUIRE(reader.line_number() == 1);
}

TEST_CASE("FileReader: inject with binary content (nulls)",
          "[file_reader][inject]") {
    FileReader reader;

    std::vector<char> content = { 'A', '\0', 'B', '\n', 'C', '\0', 'D' };
    reader.inject("binary.txt", content);

    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 7);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line.size() == 3);
    REQUIRE(line[0] == 'A');
    REQUIRE(line[1] == '\0');
    REQUIRE(line[2] == 'B');

    REQUIRE(reader.next_line(line));
    REQUIRE(line.size() == 3);
    REQUIRE(line[0] == 'C');
    REQUIRE(line[1] == '\0');
    REQUIRE(line[2] == 'D');
}

//-----------------------------------------------------------------------------
// Test BinFileReader inject functionality
//-----------------------------------------------------------------------------

TEST_CASE("BinFileReader: inject vector<char> content",
          "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<char> content = { 0x01, 0x02, 0x03, 0x04, 0x05 };
    reader.inject("virtual.bin", content);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.bin");
    REQUIRE(reader.size() == 5);
    REQUIRE(reader.tell() == 0);

    REQUIRE(reader.read_uint8() == 0x01);
    REQUIRE(reader.tell() == 1);
    REQUIRE(reader.read_uint8() == 0x02);
    REQUIRE(reader.read_uint8() == 0x03);
    REQUIRE(reader.read_uint8() == 0x04);
    REQUIRE(reader.read_uint8() == 0x05);
    REQUIRE(reader.tell() == 5);
}

TEST_CASE("BinFileReader: inject vector<unsigned char> content",
          "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<unsigned char> content = { 0xAA, 0xBB, 0xCC, 0xDD };
    reader.inject("virtual.bin", content);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.bin");
    REQUIRE(reader.size() == 4);

    REQUIRE(reader.read_uint8() == 0xAA);
    REQUIRE(reader.read_uint8() == 0xBB);
    REQUIRE(reader.read_uint8() == 0xCC);
    REQUIRE(reader.read_uint8() == 0xDD);
}

TEST_CASE("BinFileReader: inject string content", "[bin_file_reader][inject]") {
    BinFileReader reader;

    reader.inject("virtual.bin", "Hello");

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.bin");
    REQUIRE(reader.size() == 5);

    REQUIRE(reader.read_string(5) == "Hello");
}

TEST_CASE("BinFileReader: inject empty content", "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<char> empty;
    reader.inject("empty.bin", empty);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "empty.bin");
    REQUIRE(reader.size() == 0);
    REQUIRE(reader.tell() == 0);
    REQUIRE_FALSE(reader.can_read(1));
}

TEST_CASE("BinFileReader: inject structured binary data",
          "[bin_file_reader][inject]") {
    BinFileReader reader;

    // Create structured data:
    // uint8:  0x42
    // int16:  0x1234 (little-endian)
    // int32:  0x12345678 (little-endian)
    // string: "TEST"
    std::vector<unsigned char> data = {
        0x42,                        // uint8
        0x34, 0x12,                 // int16
        0x78, 0x56, 0x34, 0x12,     // int32
        'T', 'E', 'S', 'T'          // string
    };

    reader.inject("structured.bin", data);

    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 11);

    REQUIRE(reader.read_uint8() == 0x42);
    REQUIRE(reader.tell() == 1);

    REQUIRE(reader.read_int16() == 0x1234);
    REQUIRE(reader.tell() == 3);

    REQUIRE(reader.read_int32() == 0x12345678);
    REQUIRE(reader.tell() == 7);

    REQUIRE(reader.read_string(4) == "TEST");
    REQUIRE(reader.tell() == 11);
}

TEST_CASE("BinFileReader: inject and use _at methods",
          "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<unsigned char> data = { 0x10, 0x20, 0x30, 0x40, 0x50 };
    reader.inject("virtual.bin", data);

    REQUIRE(reader.is_open());

    // Read from various positions without changing current position
    REQUIRE(reader.read_uint8_at(0) == 0x10);
    REQUIRE(reader.tell() == 0);

    REQUIRE(reader.read_uint8_at(2) == 0x30);
    REQUIRE(reader.tell() == 0);

    REQUIRE(reader.read_uint8_at(4) == 0x50);
    REQUIRE(reader.tell() == 0);
}

TEST_CASE("BinFileReader: inject replaces open file",
          "[bin_file_reader][inject]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_inject_replace.bin";
    const std::vector<unsigned char> file_data = { 0x01, 0x02, 0x03 };
    write_bytes_to_file(fname, file_data);

    BinFileReader reader(fname);
    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 3);

    // Inject new content
    std::vector<unsigned char> injected = { 0xAA, 0xBB, 0xCC, 0xDD };
    reader.inject("virtual.bin", injected);

    REQUIRE(reader.is_open());
    REQUIRE(reader.filename() == "virtual.bin");
    REQUIRE(reader.size() == 4);
    REQUIRE(reader.tell() == 0);

    REQUIRE(reader.read_uint8() == 0xAA);
    REQUIRE(reader.read_uint8() == 0xBB);
    REQUIRE(reader.read_uint8() == 0xCC);
    REQUIRE(reader.read_uint8() == 0xDD);

    std::remove(fname.c_str());
}

TEST_CASE("BinFileReader: inject and reset/seek", "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<unsigned char> data = { 0x11, 0x22, 0x33, 0x44 };
    reader.inject("virtual.bin", data);

    REQUIRE(reader.read_uint8() == 0x11);
    REQUIRE(reader.read_uint8() == 0x22);
    REQUIRE(reader.tell() == 2);

    reader.reset();
    REQUIRE(reader.tell() == 0);

    REQUIRE(reader.read_uint8() == 0x11);

    reader.seek(3);
    REQUIRE(reader.tell() == 3);
    REQUIRE(reader.read_uint8() == 0x44);
}

TEST_CASE("BinFileReader: inject and check can_read",
          "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<unsigned char> data = { 0x01, 0x02, 0x03 };
    reader.inject("virtual.bin", data);

    REQUIRE(reader.can_read(3));
    REQUIRE_FALSE(reader.can_read(4));

    reader.read_uint8();
    reader.read_uint8();
    REQUIRE(reader.tell() == 2);

    REQUIRE(reader.can_read(1));
    REQUIRE_FALSE(reader.can_read(2));
}

TEST_CASE("BinFileReader: inject with null bytes",
          "[bin_file_reader][inject]") {
    BinFileReader reader;

    std::vector<unsigned char> data = { 0x41, 0x00, 0x42, 0x00, 0x43 };
    reader.inject("nulls.bin", data);

    REQUIRE(reader.is_open());
    REQUIRE(reader.size() == 5);

    std::string str = reader.read_string(5);
    REQUIRE(str.size() == 5);
    REQUIRE(str[0] == 'A');
    REQUIRE(str[1] == '\0');
    REQUIRE(str[2] == 'B');
    REQUIRE(str[3] == '\0');
    REQUIRE(str[4] == 'C');
}

//-----------------------------------------------------------------------------
// Test FileReader line number control
//-----------------------------------------------------------------------------

TEST_CASE("FileReader: set_line_number changes current line number",
          "[file_reader][line_number]") {
    FileReader reader;
    reader.inject("test.txt", "Line 1\nLine 2\nLine 3\n");

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 1);

    // Change line number
    reader.set_line_number(10);
    REQUIRE(reader.line_number() == 10);

    // Next line should increment from 10
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 2");
    REQUIRE(reader.line_number() == 11);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 3");
    REQUIRE(reader.line_number() == 12);
}

TEST_CASE("FileReader: set_fixed_line_number prevents increment",
          "[file_reader][line_number]") {
    FileReader reader;
    reader.inject("test.txt", "Line 1\nLine 2\nLine 3\nLine 4\n");

    // Set fixed line number
    reader.set_fixed_line_number(42);
    REQUIRE(reader.line_number() == 42);
    REQUIRE(reader.has_fixed_line_number());

    std::string line;

    // All lines should report line number 42
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 42);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 2");
    REQUIRE(reader.line_number() == 42);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 3");
    REQUIRE(reader.line_number() == 42);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 4");
    REQUIRE(reader.line_number() == 42);
}

TEST_CASE("FileReader: clear_fixed_line_number resumes normal increment",
          "[file_reader][line_number]") {
    FileReader reader;
    reader.inject("test.txt", "Line 1\nLine 2\nLine 3\nLine 4\n");

    // Set fixed line number
    reader.set_fixed_line_number(100);
    REQUIRE(reader.has_fixed_line_number());

    std::string line;

    // Read two lines at fixed line number
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 100);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 2");
    REQUIRE(reader.line_number() == 100);

    // Clear fixed line number
    reader.clear_fixed_line_number();
    REQUIRE_FALSE(reader.has_fixed_line_number());
    REQUIRE(reader.line_number() == 100);  // Still at 100

    // Next lines should increment normally
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 3");
    REQUIRE(reader.line_number() == 101);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 4");
    REQUIRE(reader.line_number() == 102);
}

TEST_CASE("FileReader: reset clears fixed line number",
          "[file_reader][line_number]") {
    FileReader reader;
    reader.inject("test.txt", "Line 1\nLine 2\n");

    reader.set_fixed_line_number(50);
    REQUIRE(reader.has_fixed_line_number());

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(reader.line_number() == 50);

    // Reset should clear fixed line number
    reader.reset();
    REQUIRE_FALSE(reader.has_fixed_line_number());
    REQUIRE(reader.line_number() == 0);

    // Should increment normally after reset
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 1");
    REQUIRE(reader.line_number() == 1);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line 2");
    REQUIRE(reader.line_number() == 2);
}

TEST_CASE("FileReader: open clears fixed line number",
          "[file_reader][line_number]") {
    SuppressErrors suppress;
    g_file_cache.clear();

    const std::string fname = "test_fixed_line.txt";
    write_string_to_file(fname, "File line 1\nFile line 2\n");

    FileReader reader;
    reader.inject("virtual.txt", "Virtual line 1\n");
    reader.set_fixed_line_number(99);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(reader.line_number() == 99);
    REQUIRE(reader.has_fixed_line_number());

    // Open should clear fixed line number
    REQUIRE(reader.open(fname));
    REQUIRE_FALSE(reader.has_fixed_line_number());
    REQUIRE(reader.line_number() == 0);

    // Should increment normally
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "File line 1");
    REQUIRE(reader.line_number() == 1);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "File line 2");
    REQUIRE(reader.line_number() == 2);

    std::remove(fname.c_str());
}

TEST_CASE("FileReader: inject clears fixed line number",
          "[file_reader][line_number]") {
    FileReader reader;
    reader.inject("first.txt", "First\n");
    reader.set_fixed_line_number(77);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(reader.line_number() == 77);
    REQUIRE(reader.has_fixed_line_number());

    // Inject should clear fixed line number
    reader.inject("second.txt", "Second\n");
    REQUIRE_FALSE(reader.has_fixed_line_number());
    REQUIRE(reader.line_number() == 0);

    // Should increment normally
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Second");
    REQUIRE(reader.line_number() == 1);
}

TEST_CASE("FileReader: macro expansion simulation",
          "[file_reader][line_number]") {
    FileReader reader;

    // Simulate reading a file with a macro expansion
    // Main file at line 10-12
    reader.inject("main.asm", "line before macro\nmacro_call\nline after macro\n");

    std::string line;

    // Read line 1
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "line before macro");
    REQUIRE(reader.line_number() == 1);

    // Read line 2 (macro call)
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "macro_call");
    REQUIRE(reader.line_number() == 2);

    // Now inject macro expansion at fixed line 2
    reader.inject("macro_expansion",
                  "expanded line 1\nexpanded line 2\nexpanded line 3\n");
    reader.set_fixed_line_number(2);  // All expanded lines report line 2

    // Read macro expansion
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "expanded line 1");
    REQUIRE(reader.line_number() == 2);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "expanded line 2");
    REQUIRE(reader.line_number() == 2);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "expanded line 3");
    REQUIRE(reader.line_number() == 2);

    // Simulate returning to main file
    reader.inject("main.asm", "line after macro\n");
    reader.set_line_number(3);  // Resume at line 3

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "line after macro");
    REQUIRE(reader.line_number() == 4);  // Increments from 3
}

TEST_CASE("FileReader: include file simulation", "[file_reader][line_number]") {
    FileReader reader;

    // Simulate main file
    reader.inject("main.asm", "line 1\nline 2\nline 3\n");

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "line 1");
    REQUIRE(reader.line_number() == 1);

    // Save current state before include
    size_t saved_line = reader.line_number();

    // Simulate reading include file (starts at line 1)
    reader.inject("include.inc", "included A\nincluded B\n");
    reader.set_line_number(0);  // Reset to 0 so first read becomes 1

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "included A");
    REQUIRE(reader.line_number() == 1);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "included B");
    REQUIRE(reader.line_number() == 2);

    // Return to main file
    reader.inject("main.asm", "line 2\nline 3\n");
    reader.set_line_number(saved_line);  // Resume where we left off

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "line 2");
    REQUIRE(reader.line_number() == 2);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "line 3");
    REQUIRE(reader.line_number() == 3);
}

TEST_CASE("FileReader: set_line_number at start",
          "[file_reader][line_number]") {
    FileReader reader;
    reader.inject("test.txt", "Line A\nLine B\n");

    // Set line number before reading anything
    reader.set_line_number(100);
    REQUIRE(reader.line_number() == 100);

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line A");
    REQUIRE(reader.line_number() == 101);

    REQUIRE(reader.next_line(line));
    REQUIRE(line == "Line B");
    REQUIRE(reader.line_number() == 102);
}

TEST_CASE("FileReader: has_fixed_line_number default state",
          "[file_reader][line_number]") {
    FileReader reader;

    // Default state
    REQUIRE_FALSE(reader.has_fixed_line_number());

    reader.inject("test.txt", "Line 1\n");
    REQUIRE_FALSE(reader.has_fixed_line_number());

    std::string line;
    REQUIRE(reader.next_line(line));
    REQUIRE_FALSE(reader.has_fixed_line_number());
}
