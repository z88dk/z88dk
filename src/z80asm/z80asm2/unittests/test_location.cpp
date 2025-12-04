//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../location.h"
#include "catch_amalgamated.hpp"

TEST_CASE("Location: default constructor", "[location]") {
    Location loc;
    
    REQUIRE(loc.filename() == "");
    REQUIRE(loc.line_num() == 0);
    REQUIRE(loc.empty());
}

TEST_CASE("Location: constructor with filename", "[location]") {
    Location loc("test.asm");
    
    REQUIRE(loc.filename() == "test.asm");
    REQUIRE(loc.line_num() == 0);
    REQUIRE_FALSE(loc.empty());
}

TEST_CASE("Location: constructor with filename and line number", "[location]") {
    Location loc("test.asm", 42);
    
    REQUIRE(loc.filename() == "test.asm");
    REQUIRE(loc.line_num() == 42);
    REQUIRE_FALSE(loc.empty());
}

TEST_CASE("Location: set filename", "[location]") {
    Location loc;
    loc.set_filename("main.asm");
    
    REQUIRE(loc.filename() == "main.asm");
}

TEST_CASE("Location: set line number", "[location]") {
    Location loc;
    loc.set_line_num(100);
    
    REQUIRE(loc.line_num() == 100);
}

TEST_CASE("Location: increment line number", "[location]") {
    Location loc("test.asm", 10);
    
    loc.inc_line_num();
    REQUIRE(loc.line_num() == 11);
    
    loc.inc_line_num();
    REQUIRE(loc.line_num() == 12);
}

TEST_CASE("Location: clear", "[location]") {
    Location loc("test.asm", 42);
    REQUIRE_FALSE(loc.empty());
    
    loc.clear();
    REQUIRE(loc.filename() == "");
    REQUIRE(loc.line_num() == 0);
    REQUIRE(loc.empty());
}

TEST_CASE("Location: empty check", "[location]") {
    Location loc1;
    REQUIRE(loc1.empty());
    
    Location loc2("", 0);
    REQUIRE(loc2.empty());
    
    Location loc3("test.asm", 0);
    REQUIRE_FALSE(loc3.empty());
    
    Location loc4("", 42);
    REQUIRE_FALSE(loc4.empty());
}

TEST_CASE("Location: multiple locations share same filename", "[location]") {
    // Create multiple locations with the same filename
    Location loc1("shared.asm", 10);
    Location loc2("shared.asm", 20);
    Location loc3("shared.asm", 30);
    
    // All should have the same filename
    REQUIRE(loc1.filename() == "shared.asm");
    REQUIRE(loc2.filename() == "shared.asm");
    REQUIRE(loc3.filename() == "shared.asm");
    
    // But different line numbers
    REQUIRE(loc1.line_num() == 10);
    REQUIRE(loc2.line_num() == 20);
    REQUIRE(loc3.line_num() == 30);
    
    // Test that they point to the same string (memory optimization)
    REQUIRE(&loc1.filename() == &loc2.filename());
    REQUIRE(&loc2.filename() == &loc3.filename());
}

TEST_CASE("Location: many different filenames", "[location]") {
    std::vector<Location> locations;
    
    // Create locations with different filenames
    for (int i = 0; i < 100; ++i) {
        std::string filename = "file" + std::to_string(i) + ".asm";
        locations.emplace_back(filename, i);
    }
    
    // Verify all locations
    for (int i = 0; i < 100; ++i) {
        std::string expected = "file" + std::to_string(i) + ".asm";
        REQUIRE(locations[i].filename() == expected);
        REQUIRE(locations[i].line_num() == i);
    }
}

TEST_CASE("Location: copy constructor", "[location]") {
    Location loc1("test.asm", 42);
    Location loc2(loc1);
    
    REQUIRE(loc2.filename() == "test.asm");
    REQUIRE(loc2.line_num() == 42);
    
    // Modifying loc2 shouldn't affect loc1
    loc2.set_filename("other.asm");
    loc2.set_line_num(100);
    
    REQUIRE(loc1.filename() == "test.asm");
    REQUIRE(loc1.line_num() == 42);
    REQUIRE(loc2.filename() == "other.asm");
    REQUIRE(loc2.line_num() == 100);
}

TEST_CASE("Location: assignment operator", "[location]") {
    Location loc1("test.asm", 42);
    Location loc2;
    
    loc2 = loc1;
    
    REQUIRE(loc2.filename() == "test.asm");
    REQUIRE(loc2.line_num() == 42);
    
    // Modifying loc2 shouldn't affect loc1
    loc2.set_filename("other.asm");
    loc2.set_line_num(100);
    
    REQUIRE(loc1.filename() == "test.asm");
    REQUIRE(loc1.line_num() == 42);
    REQUIRE(loc2.filename() == "other.asm");
    REQUIRE(loc2.line_num() == 100);
}

TEST_CASE("Location: filename deduplication", "[location]") {
    // Create many locations with the same filename
    std::vector<Location> locations;
    for (int i = 0; i < 1000; ++i) {
        locations.emplace_back("main.asm", i);
    }
    
    // All should share the same string instance
    const std::string* first_ptr = &locations[0].filename();
    for (size_t i = 1; i < locations.size(); ++i) {
        REQUIRE(&locations[i].filename() == first_ptr);
    }
}

TEST_CASE("Location: updating filename on multiple locations", "[location]") {
    Location loc1("original.asm", 10);
    Location loc2("original.asm", 20);
    
    // Both should reference the same filename
    REQUIRE(&loc1.filename() == &loc2.filename());
    
    // Change filename on loc1
    loc1.set_filename("modified.asm");
    
    // loc1 should have new filename, loc2 should keep old
    REQUIRE(loc1.filename() == "modified.asm");
    REQUIRE(loc2.filename() == "original.asm");
    
    // They should no longer reference the same string
    REQUIRE(&loc1.filename() != &loc2.filename());
}

TEST_CASE("Location: stress test - many locations and filenames", "[location]") {
    std::vector<Location> locations;
    
    // Create 10 files with 100 locations each
    for (int file = 0; file < 10; ++file) {
        std::string filename = "file" + std::to_string(file) + ".asm";
        for (int line = 1; line <= 100; ++line) {
            locations.emplace_back(filename, line);
        }
    }
    
    // Verify all 1000 locations
    for (int file = 0; file < 10; ++file) {
        std::string expected_filename = "file" + std::to_string(file) + ".asm";
        for (int line = 1; line <= 100; ++line) {
            int index = file * 100 + (line - 1);
            REQUIRE(locations[index].filename() == expected_filename);
            REQUIRE(locations[index].line_num() == line);
        }
    }
    
    // Verify filename sharing within each file
    for (int file = 0; file < 10; ++file) {
        const std::string* first_ptr = &locations[file * 100].filename();
        for (int line = 1; line < 100; ++line) {
            int index = file * 100 + line;
            REQUIRE(&locations[index].filename() == first_ptr);
        }
    }
}
