//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../lexer.h"
#include "../model.h"
#include "catch_amalgamated.hpp"
#include <sstream>

//-----------------------------------------------------------------------------
// Patch tests
//-----------------------------------------------------------------------------

TEST_CASE("Patch: default constructor", "[model][patch]") {
    Patch patch;
    REQUIRE(patch.offset() == 0);
    REQUIRE(patch.range() == PatchRange::Undefined);
}

TEST_CASE("Patch: constructor with parameters", "[model][patch]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Symbol* target_sym = module.add_symbol("target", loc, 0x1234,
                                           SymbolType::Constant);

    Expression expr(make_symbol(target_sym), loc);
    Patch patch(2, PatchRange::Word, expr);

    REQUIRE(patch.offset() == 2);
    REQUIRE(patch.range() == PatchRange::Word);
    REQUIRE(patch.location().filename() == "test.asm");
    REQUIRE(patch.location().line_num() == 10);
}

TEST_CASE("Patch: JR offset range", "[model][patch]") {
    Location loc("test.asm", 20);
    Expression expr(make_integer(10), loc);
    Patch patch(1, PatchRange::JrOffset, expr);

    REQUIRE(patch.range() == PatchRange::JrOffset);

    REQUIRE(patch.expression().evaluate() == 10);
}

TEST_CASE("Patch: byte unsigned range", "[model][patch]") {
    Location loc("test.asm", 30);
    Expression expr(make_integer(0xFF), loc);
    Patch patch(0, PatchRange::ByteUnsigned, expr);

    REQUIRE(patch.range() == PatchRange::ByteUnsigned);

    REQUIRE(patch.expression().evaluate() == 0xFF);
}

TEST_CASE("Patch: word little-endian range", "[model][patch]") {
    Location loc("test.asm", 40);
    Expression expr(make_integer(0x1234), loc);
    Patch patch(1, PatchRange::Word, expr);

    REQUIRE(patch.range() == PatchRange::Word);

    REQUIRE(patch.expression().evaluate() == 0x1234);
}

TEST_CASE("Patch: all range types", "[model][patch]") {
    Location loc("test.asm", 50);
    Expression expr(make_integer(0), loc);

    std::vector<PatchRange> ranges = {
        PatchRange::Undefined,
        PatchRange::JrOffset,
        PatchRange::ByteUnsigned,
        PatchRange::ByteSigned,
        PatchRange::Word,
        PatchRange::WordBigEndian,
        PatchRange::Dword,
        PatchRange::ByteToWordUnsigned,
        PatchRange::ByteToWordSigned,
        PatchRange::Ptr24,
        PatchRange::HighOffset,
        PatchRange::Assignment,
        PatchRange::JreOffset,
        PatchRange::ByteToPtr24Unsigned,
        PatchRange::ByteToPtr24Signed
    };

    for (auto range : ranges) {
        Patch patch(0, range, expr);
        REQUIRE(patch.range() == range);
    }
}

//-----------------------------------------------------------------------------
// Opcode tests
//-----------------------------------------------------------------------------

TEST_CASE("Opcode: location-only constructor", "[model][opcode]") {
    Location loc("test.asm", 10);
    Opcode opcode(loc);

    REQUIRE(opcode.address() == 0);
    REQUIRE(opcode.size() == 0);
    REQUIRE_FALSE(opcode.has_patches());
    REQUIRE(opcode.location().filename() == "test.asm");
    REQUIRE(opcode.location().line_num() == 10);
}

TEST_CASE("Opcode: constructor with bytes", "[model][opcode]") {
    Location loc("test.asm", 20);
    std::vector<uint8_t> bytes = {0x3E, 0x42};  // LD A, 42
    Opcode opcode(bytes, loc);

    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x3E);
    REQUIRE(opcode.bytes()[1] == 0x42);
    REQUIRE(opcode.location().filename() == "test.asm");
    REQUIRE(opcode.location().line_num() == 20);
}

TEST_CASE("Opcode: constructor with address and bytes", "[model][opcode]") {
    Location loc("test.asm", 30);
    std::vector<uint8_t> bytes = {0xC3, 0x00, 0x80};  // JP 0x8000
    Opcode opcode(0x1000, bytes, loc);

    REQUIRE(opcode.address() == 0x1000);
    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.location().filename() == "test.asm");
    REQUIRE(opcode.location().line_num() == 30);
}

TEST_CASE("Opcode: add patch", "[model][opcode]") {
    Location loc("test.asm", 100);
    Module module("TEST", loc);
    Symbol* target_sym = module.add_symbol("target", loc);

    std::vector<uint8_t> bytes = {0xC3, 0x00, 0x00};  // JP address (needs patch)
    Opcode opcode(bytes, loc);

    Expression expr(make_symbol(target_sym), loc);
    Patch patch(1, PatchRange::Word, expr);

    opcode.add_patch(patch);

    REQUIRE(opcode.has_patches());
    REQUIRE(opcode.patches().size() == 1);
    REQUIRE(opcode.patches()[0].offset() == 1);
    REQUIRE(opcode.patches()[0].range() == PatchRange::Word);
}

TEST_CASE("Opcode: multiple patches", "[model][opcode]") {
    Location loc("test.asm", 110);
    std::vector<uint8_t> bytes = {0x00, 0x00, 0x00, 0x00};
    Opcode opcode(bytes, loc);

    // Add two patches
    Expression expr1(make_integer(0x12), loc);
    Patch patch1(0, PatchRange::ByteUnsigned, expr1);
    opcode.add_patch(patch1);

    Expression expr2(make_integer(0x3456), loc);
    Patch patch2(2, PatchRange::Word, expr2);
    opcode.add_patch(patch2);

    REQUIRE(opcode.patches().size() == 2);
    REQUIRE(opcode.patches()[0].offset() == 0);
    REQUIRE(opcode.patches()[1].offset() == 2);
}

TEST_CASE("Opcode: clear patches", "[model][opcode]") {
    Location loc("test.asm", 120);
    std::vector<uint8_t> bytes = {0x00, 0x00};
    Opcode opcode(bytes, loc);

    Expression expr(make_integer(42), loc);
    Patch patch(0, PatchRange::ByteUnsigned, expr);

    opcode.add_patch(patch);
    REQUIRE(opcode.has_patches());

    opcode.clear_patches();
    REQUIRE_FALSE(opcode.has_patches());
    REQUIRE(opcode.patches().size() == 0);
}

TEST_CASE("Opcode: location is immutable", "[model][opcode]") {
    Location loc("main.asm", 200);
    Opcode opcode(loc);

    REQUIRE(opcode.location().filename() == "main.asm");
    REQUIRE(opcode.location().line_num() == 200);

    // Location cannot be changed - it's immutable
    // The following would not compile:
    // opcode.set_location(Location("other.asm", 300));  // ERROR: no member function 'set_location'
}

TEST_CASE("Opcode: clear bytes", "[model][opcode]") {
    Location loc("test.asm", 130);
    std::vector<uint8_t> bytes = {0x3E, 0x42, 0x00};
    Opcode opcode(bytes, loc);

    REQUIRE(opcode.size() == 3);

    opcode.clear_bytes();
    REQUIRE(opcode.size() == 0);
    REQUIRE(opcode.bytes().empty());
}

TEST_CASE("Opcode: add single byte", "[model][opcode]") {
    Location loc("test.asm", 140);
    Opcode opcode(loc);

    opcode.add_byte(0x3E);
    REQUIRE(opcode.size() == 1);
    REQUIRE(opcode.bytes()[0] == 0x3E);

    opcode.add_byte(0x42);
    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x3E);
    REQUIRE(opcode.bytes()[1] == 0x42);
}

TEST_CASE("Opcode: add_bytes with single byte value", "[model][opcode]") {
    Location loc("test.asm", 150);
    Opcode opcode(loc);
    opcode.add_bytes(0x3E);

    REQUIRE(opcode.size() == 1);
    REQUIRE(opcode.bytes()[0] == 0x3E);
}

TEST_CASE("Opcode: add_bytes with two byte value", "[model][opcode]") {
    Location loc("test.asm", 160);
    Opcode opcode(loc);
    opcode.add_bytes(0x1234);

    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
}

TEST_CASE("Opcode: add_bytes with three byte value", "[model][opcode]") {
    Location loc("test.asm", 170);
    Opcode opcode(loc);
    opcode.add_bytes(0xC30000);

    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.bytes()[0] == 0xC3);
    REQUIRE(opcode.bytes()[1] == 0x00);
    REQUIRE(opcode.bytes()[2] == 0x00);
}

TEST_CASE("Opcode: add_bytes with four byte value", "[model][opcode]") {
    Location loc("test.asm", 180);
    Opcode opcode(loc);
    opcode.add_bytes(0x12345678);

    REQUIRE(opcode.size() == 4);
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
    REQUIRE(opcode.bytes()[2] == 0x56);
    REQUIRE(opcode.bytes()[3] == 0x78);
}

TEST_CASE("Opcode: add_bytes with zero", "[model][opcode]") {
    Location loc("test.asm", 190);
    Opcode opcode(loc);
    opcode.add_bytes(0);

    REQUIRE(opcode.size() == 1);
    REQUIRE(opcode.bytes()[0] == 0x00);
}

TEST_CASE("Opcode: add_bytes with leading zeros", "[model][opcode]") {
    Location loc("test.asm", 200);
    Opcode opcode(loc);
    opcode.add_bytes(0x00001234);

    // Should skip leading zero bytes and add from first non-zero
    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
}

TEST_CASE("Opcode: add_bytes with various values", "[model][opcode]") {
    Location loc("test.asm", 210);

    struct TestCase {
        unsigned value;
        std::vector<uint8_t> expected;
    };

    std::vector<TestCase> tests = {
        {0x00, {0x00}},
        {0x01, {0x01}},
        {0xFF, {0xFF}},
        {0x0100, {0x01, 0x00}},
        {0xFFFF, {0xFF, 0xFF}},
        {0x010000, {0x01, 0x00, 0x00}},
        {0xC30000, {0xC3, 0x00, 0x00}},
        {0xFFFFFF, {0xFF, 0xFF, 0xFF}},
        {0x01000000, {0x01, 0x00, 0x00, 0x00}},
        {0xDEADBEEF, {0xDE, 0xAD, 0xBE, 0xEF}},
    };

    for (const auto& test : tests) {
        Opcode opcode(loc);
        opcode.add_bytes(test.value);

        REQUIRE(opcode.size() == test.expected.size());
        for (size_t i = 0; i < test.expected.size(); ++i) {
            REQUIRE(opcode.bytes()[i] == test.expected[i]);
        }
    }
}

TEST_CASE("Opcode: build instruction with add_byte", "[model][opcode]") {
    Location loc("test.asm", 220);
    Opcode opcode(loc);

    // Build: LD A, 42 (0x3E 0x2A)
    opcode.add_byte(0x3E);
    opcode.add_byte(0x2A);

    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x3E);
    REQUIRE(opcode.bytes()[1] == 0x2A);
}

TEST_CASE("Opcode: build instruction with add_bytes", "[model][opcode]") {
    Location loc("test.asm", 230);
    Opcode opcode(loc);

    // Build: JP 0x8000 (0xC3 0x00 0x80)
    opcode.add_bytes(0xC38000);

    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.bytes()[0] == 0xC3);
    REQUIRE(opcode.bytes()[1] == 0x80);
    REQUIRE(opcode.bytes()[2] == 0x00);
}

TEST_CASE("Opcode: mix add_byte and add_bytes", "[model][opcode]") {
    Location loc("test.asm", 240);
    Opcode opcode(loc);

    // Build complex instruction
    opcode.add_byte(0xDD);      // IX prefix
    opcode.add_byte(0x21);      // LD IX,
    opcode.add_bytes(0x1234);   // 0x1234

    REQUIRE(opcode.size() == 4);
    REQUIRE(opcode.bytes()[0] == 0xDD);
    REQUIRE(opcode.bytes()[1] == 0x21);
    REQUIRE(opcode.bytes()[2] == 0x12);
    REQUIRE(opcode.bytes()[3] == 0x34);
}

TEST_CASE("Opcode: clear and rebuild", "[model][opcode]") {
    Location loc("test.asm", 250);
    Opcode opcode(loc);

    // Build first instruction
    opcode.add_byte(0x3E);
    opcode.add_byte(0x42);
    REQUIRE(opcode.size() == 2);

    // Clear and build new instruction
    opcode.clear_bytes();
    REQUIRE(opcode.size() == 0);

    opcode.add_bytes(0xC30000);
    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.bytes()[0] == 0xC3);
    REQUIRE(opcode.bytes()[1] == 0x00);
    REQUIRE(opcode.bytes()[2] == 0x00);
}

TEST_CASE("Integration: build complete instruction with patches",
          "[model][opcode][integration]") {
    Location loc("test.asm", 100);
    Module module("TEST", loc);
    Symbol* label_sym = module.add_symbol("label", loc);

    Opcode opcode(loc);

    // Build: JP label (0xC3 followed by address - needs patch)
    opcode.add_byte(0xC3);
    opcode.add_byte(0x00);  // Placeholder for address
    opcode.add_byte(0x00);  // Placeholder for address

    // Add patch for the address
    Expression expr(make_symbol(label_sym), loc);
    Patch patch(1, PatchRange::Word, expr);
    opcode.add_patch(patch);

    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.bytes()[0] == 0xC3);
    REQUIRE(opcode.bytes()[1] == 0x00);
    REQUIRE(opcode.bytes()[2] == 0x00);
    REQUIRE(opcode.has_patches());
    REQUIRE(opcode.patches()[0].offset() == 1);
}

TEST_CASE("Integration: build data with add_bytes",
          "[model][opcode][integration]") {
    Location loc("test.asm", 260);
    Opcode opcode(loc);

    // DEFW 0x1234, 0x5678
    opcode.add_bytes(0x1234);
    opcode.add_bytes(0x5678);

    REQUIRE(opcode.size() == 4);
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
    REQUIRE(opcode.bytes()[2] == 0x56);
    REQUIRE(opcode.bytes()[3] == 0x78);
}

//-----------------------------------------------------------------------------
// Integration tests: Section with opcodes and patches
//-----------------------------------------------------------------------------

TEST_CASE("Integration: section with patched opcodes", "[model][integration]") {
    Location loc("program.asm", 10);
    Module module("TEST", loc);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    // Add NOP
    sec.add_opcode(Opcode({0x00}, loc));

    // Add LD A, value (needs patch)
    Symbol* value_sym = module.add_symbol("value", loc, 42, SymbolType::Constant);
    Opcode ld_opcode({0x3E, 0x00}, loc);
    Expression expr1(make_symbol(value_sym), loc);
    Patch patch1(1, PatchRange::ByteUnsigned, expr1);
    ld_opcode.add_patch(patch1);
    sec.add_opcode(ld_opcode);

    // Add JP label (needs patch)
    Symbol* start_sym = module.add_symbol("start", loc);
    Opcode jp_opcode({0xC3, 0x00, 0x00}, loc);
    Expression expr2(make_symbol(start_sym), loc);
    Patch patch2(1, PatchRange::Word, expr2);
    jp_opcode.add_patch(patch2);
    sec.add_opcode(jp_opcode);

    REQUIRE(sec.opcodes().size() == 4);
    REQUIRE(sec.size() == 6);  // 1 + 2 + 3
    REQUIRE(sec.pc() == 0x8006);
    REQUIRE(sec.opcodes()[2]->has_patches());
    REQUIRE(sec.opcodes()[3]->has_patches());
}

TEST_CASE("Integration: compute opcode addresses in section",
          "[model][integration]") {
    Location loc("test.asm", 50);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    // Add opcodes
    sec.add_opcode(Opcode({0x00}, loc));                    // 0x8000
    sec.add_opcode(Opcode({0x3E, 0x42}, loc));              // 0x8001
    sec.add_opcode(Opcode({0xC3, 0x00, 0x80}, loc));        // 0x8003

    // Compute and set addresses
    int addr = sec.base_address();
    for (auto& opcode : sec.opcodes()) {
        opcode->set_address(addr);
        addr += static_cast<int>(opcode->size());
    }

    sec.compute_opcodes_addresses();
    REQUIRE(sec.opcodes()[1]->address() == 0x8000);
    REQUIRE(sec.opcodes()[2]->address() == 0x8001);
    REQUIRE(sec.opcodes()[3]->address() == 0x8003);
}

TEST_CASE("Integration: relative jump with patch", "[model][integration]") {
    Location loc("test.asm", 50);
    Module module("TEST", loc);
    Section sec("CODE");
    sec.set_base_address(0x1000);
    Symbol* loop_sym = module.add_symbol("loop", loc);

    // JR offset (needs patch to compute relative offset)
    Opcode jr_opcode({0x18, 0x00}, loc);

    // Create expression: target - ($ + 2)
    // Where $ is current address and 2 is instruction size
    Expression target_expr(make_symbol(loop_sym), loc);
    Patch patch(1, PatchRange::JrOffset, target_expr);
    jr_opcode.add_patch(patch);

    sec.add_opcode(jr_opcode);

    REQUIRE(sec.opcodes()[1]->has_patches());
    REQUIRE(sec.opcodes()[1]->patches()[0].range() == PatchRange::JrOffset);
}

TEST_CASE("Integration: mixed code and data section", "[model][integration]") {
    Location loc1("test.asm", 100);
    Module module("TEST", loc1);
    Symbol* constant_sym = module.add_symbol("constant", loc1, 42,
                           SymbolType::Constant);
    Symbol* label_sym = module.add_symbol("label", loc1);

    Section sec("CODE");
    sec.set_base_address(0x8000);

    Location loc2("mixed.asm", 100);

    // Code: LD A, value
    Opcode ld_opcode({0x3E, 0x00}, loc2);
    Expression expr1(make_symbol(constant_sym), loc2);
    Patch patch1(1, PatchRange::ByteUnsigned, expr1);
    ld_opcode.add_patch(patch1);
    sec.add_opcode(ld_opcode);

    // Data: DEFW address
    Opcode data_opcode({0x00, 0x00}, loc2);
    Expression expr2(make_symbol(label_sym), loc2);
    Patch patch2(0, PatchRange::Word, expr2);
    data_opcode.add_patch(patch2);
    sec.add_opcode(data_opcode);

    REQUIRE(sec.opcodes().size() == 3);
    REQUIRE(sec.size() == 4);
    REQUIRE(sec.opcodes()[1]->has_patches());
    REQUIRE(sec.opcodes()[2]->has_patches());
}

//-----------------------------------------------------------------------------
// Section tests
//-----------------------------------------------------------------------------

TEST_CASE("Section: default constructor", "[model][section]") {
    Section sec;
    REQUIRE(sec.name() == "");
    REQUIRE(sec.alignment() == 1);
    REQUIRE(sec.base_address() == 0);
    REQUIRE(sec.size() == 0);
    REQUIRE(sec.pc() == 0);
}

TEST_CASE("Section: constructor with name", "[model][section]") {
    Section sec("CODE");
    REQUIRE(sec.name() == "CODE");
    REQUIRE(sec.alignment() == 1);
    REQUIRE(sec.base_address() == 0);
}

TEST_CASE("Section: alignment default", "[model][section]") {
    Section sec("CODE");
    REQUIRE(sec.alignment() == 1);

    // With default alignment, base address is not adjusted
    sec.set_base_address(0x8001);
    REQUIRE(sec.base_address() == 0x8001);
}

TEST_CASE("Section: alignment of 4", "[model][section]") {
    Section sec("CODE");
    sec.set_alignment(4);

    REQUIRE(sec.alignment() == 4);

    // Test various addresses get aligned to multiple of 4
    sec.set_base_address(0x8000);
    REQUIRE(sec.base_address() == 0x8000);  // Already aligned

    sec.set_base_address(0x8001);
    REQUIRE(sec.base_address() == 0x8004);  // Rounded up to 0x8004

    sec.set_base_address(0x8002);
    REQUIRE(sec.base_address() == 0x8004);  // Rounded up to 0x8004

    sec.set_base_address(0x8003);
    REQUIRE(sec.base_address() == 0x8004);  // Rounded up to 0x8004

    sec.set_base_address(0x8004);
    REQUIRE(sec.base_address() == 0x8004);  // Already aligned
}

TEST_CASE("Section: alignment of 16", "[model][section]") {
    Section sec("DATA");
    sec.set_alignment(16);

    REQUIRE(sec.alignment() == 16);

    // Test alignment to multiple of 16
    sec.set_base_address(0x1000);
    REQUIRE(sec.base_address() == 0x1000);  // Already aligned

    sec.set_base_address(0x1001);
    REQUIRE(sec.base_address() == 0x1010);  // Rounded up

    sec.set_base_address(0x100F);
    REQUIRE(sec.base_address() == 0x1010);  // Rounded up

    sec.set_base_address(0x1010);
    REQUIRE(sec.base_address() == 0x1010);  // Already aligned
}

TEST_CASE("Section: alignment of 256", "[model][section]") {
    Section sec("PAGE");
    sec.set_alignment(256);

    REQUIRE(sec.alignment() == 256);

    // Test page alignment
    sec.set_base_address(0x0000);
    REQUIRE(sec.base_address() == 0x0000);  // Already aligned

    sec.set_base_address(0x0001);
    REQUIRE(sec.base_address() == 0x0100);  // Rounded up to next page

    sec.set_base_address(0x00FF);
    REQUIRE(sec.base_address() == 0x0100);  // Rounded up to next page

    sec.set_base_address(0x0100);
    REQUIRE(sec.base_address() == 0x0100);  // Already aligned
}

TEST_CASE("Section: change alignment after setting base address",
          "[model][section]") {
    Section sec("CODE");

    // Set base address with default alignment
    sec.set_base_address(0x8001);
    REQUIRE(sec.base_address() == 0x8001);

    // Change alignment to 4 - base address should be re-aligned
    sec.set_alignment(4);
    REQUIRE(sec.alignment() == 4);
    REQUIRE(sec.base_address() == 0x8004);  // Re-aligned
}

TEST_CASE("Section: zero alignment defaults to 1", "[model][section]") {
    Section sec("CODE");
    sec.set_alignment(0);

    REQUIRE(sec.alignment() == 1);

    sec.set_base_address(0x8001);
    REQUIRE(sec.base_address() == 0x8001);  // No adjustment
}

TEST_CASE("Section: negative alignment defaults to 1", "[model][section]") {
    Section sec("CODE");
    sec.set_alignment(-4);

    REQUIRE(sec.alignment() == 1);

    sec.set_base_address(0x8001);
    REQUIRE(sec.base_address() == 0x8001);  // No adjustment
}

TEST_CASE("Section: alignment with zero base address", "[model][section]") {
    Section sec("CODE");
    sec.set_alignment(4);

    sec.set_base_address(0);
    REQUIRE(sec.base_address() == 0);  // Zero is aligned to any value
}

TEST_CASE("Section: alignment doesn't affect opcodes or pc",
          "[model][section]") {
    Location loc("test.asm", 10);
    Section sec("CODE");
    sec.set_alignment(4);
    sec.set_base_address(0x8001);  // Will be aligned to 0x8004

    REQUIRE(sec.base_address() == 0x8004);
    REQUIRE(sec.pc() == 0x8004);  // Empty section

    // Add opcodes
    sec.add_opcode(Opcode({0x00}, loc));
    REQUIRE(sec.pc() == 0x8005);  // base + 1

    sec.add_opcode(Opcode({0x3E, 0x42}, loc));
    REQUIRE(sec.pc() == 0x8007);  // base + 3
}

TEST_CASE("Section: add opcode", "[model][section]") {
    Location loc("test.asm", 10);
    Section sec("CODE");

    std::vector<uint8_t> bytes = {0x00};  // NOP
    Opcode opcode(bytes, loc);
    sec.add_opcode(opcode);

    REQUIRE(sec.opcodes().size() == 2);
    REQUIRE(sec.size() == 1);
}

TEST_CASE("Section: multiple opcodes", "[model][section]") {
    Location loc("test.asm", 20);
    Section sec("CODE");

    // Add several opcodes
    sec.add_opcode(Opcode({0x00}, loc));                    // NOP - 1 byte
    sec.add_opcode(Opcode({0x3E, 0x42}, loc));              // LD A, 42 - 2 bytes
    sec.add_opcode(Opcode({0xC3, 0x00, 0x80}, loc));        // JP 0x8000 - 3 bytes

    REQUIRE(sec.opcodes().size() == 4);
    REQUIRE(sec.size() == 6);  // 1 + 2 + 3
}

TEST_CASE("Section: program counter calculation", "[model][section]") {
    Location loc("test.asm", 30);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    REQUIRE(sec.pc() == 0x8000);  // Empty section

    sec.add_opcode(Opcode({0x00}, loc));
    REQUIRE(sec.pc() == 0x8001);  // Base + 1

    sec.add_opcode(Opcode({0x3E, 0x42}, loc));
    REQUIRE(sec.pc() == 0x8003);  // Base + 3
}

TEST_CASE("Section: program counter with alignment", "[model][section]") {
    Location loc("test.asm", 35);
    Section sec("CODE");
    sec.set_alignment(16);
    sec.set_base_address(0x8001);  // Will be aligned to 0x8010

    REQUIRE(sec.base_address() == 0x8010);
    REQUIRE(sec.pc() == 0x8010);  // Empty section

    sec.add_opcode(Opcode({0x00}, loc));
    REQUIRE(sec.pc() == 0x8011);  // Aligned base + 1

    sec.add_opcode(Opcode({0x3E, 0x42}, loc));
    REQUIRE(sec.pc() == 0x8013);  // Aligned base + 3
}

TEST_CASE("Section: clear opcodes", "[model][section]") {
    Location loc("test.asm", 40);
    Section sec("CODE");
    REQUIRE(sec.size() == 0);

    sec.add_opcode(Opcode({0x00}, loc));
    sec.add_opcode(Opcode({0x00}, loc));
    REQUIRE(sec.size() == 2);

    sec.clear_opcodes();
    REQUIRE(sec.opcodes().size() == 1); // start with an empty opcode
    REQUIRE(sec.size() == 0);
}

TEST_CASE("Section: alignment boundary cases", "[model][section]") {
    Section sec("CODE");

    // Alignment of 1 (no constraint)
    sec.set_alignment(1);
    sec.set_base_address(0x1234);
    REQUIRE(sec.base_address() == 0x1234);

    // Alignment of 2
    sec.set_alignment(2);
    sec.set_base_address(0x1234);
    REQUIRE(sec.base_address() == 0x1234);  // Already even
    sec.set_base_address(0x1235);
    REQUIRE(sec.base_address() == 0x1236);  // Rounded up

    // Alignment of 8
    sec.set_alignment(8);
    sec.set_base_address(0x1230);
    REQUIRE(sec.base_address() == 0x1230);  // Already aligned
    sec.set_base_address(0x1231);
    REQUIRE(sec.base_address() == 0x1238);  // Rounded up
    sec.set_base_address(0x1237);
    REQUIRE(sec.base_address() == 0x1238);  // Rounded up
}

TEST_CASE("Section: alignment with large addresses", "[model][section]") {
    Section sec("CODE");
    sec.set_alignment(0x1000);  // 4K alignment

    sec.set_base_address(0x10000);
    REQUIRE(sec.base_address() == 0x10000);  // Already aligned

    sec.set_base_address(0x10001);
    REQUIRE(sec.base_address() == 0x11000);  // Rounded up to next 4K boundary

    sec.set_base_address(0x10FFF);
    REQUIRE(sec.base_address() == 0x11000);  // Rounded up to next 4K boundary
}

//-----------------------------------------------------------------------------
// Integration tests: Section with alignment and opcodes
//-----------------------------------------------------------------------------

TEST_CASE("Integration: aligned section with opcodes",
          "[model][section][integration]") {
    Location loc("aligned.asm", 100);
    Section sec("CODE");

    // Set 16-byte alignment
    sec.set_alignment(16);
    sec.set_base_address(0x8005);  // Will be aligned to 0x8010

    REQUIRE(sec.base_address() == 0x8010);

    // Add some opcodes
    sec.add_opcode(Opcode({0x00}, loc));                    // 0x8010
    sec.add_opcode(Opcode({0x3E, 0x42}, loc));              // 0x8011-0x8012
    sec.add_opcode(Opcode({0xC3, 0x00, 0x80}, loc));        // 0x8013-0x8015

    REQUIRE(sec.opcodes().size() == 4);
    REQUIRE(sec.size() == 6);
    REQUIRE(sec.pc() == 0x8016);  // 0x8010 + 6
}

TEST_CASE("Integration: section alignment for page-aligned data",
          "[model][section][integration]") {
    Location loc("page.asm", 50);
    Section sec("LOOKUP_TABLE");

    // Align to 256-byte page boundary
    sec.set_alignment(256);
    sec.set_base_address(0x7F80);  // Will be aligned to 0x8000

    REQUIRE(sec.base_address() == 0x8000);

    // Fill with data
    for (int i = 0; i < 256; ++i) {
        sec.add_opcode(Opcode({static_cast<uint8_t>(i)}, loc));
    }

    REQUIRE(sec.size() == 256);
    REQUIRE(sec.pc() == 0x8100);  // Next page boundary
}

TEST_CASE("Integration: multiple sections with different alignments",
          "[model][section][integration]") {
    Location loc("multi.asm", 200);

    // Code section with 4-byte alignment
    Section code("CODE");
    code.set_alignment(4);
    code.set_base_address(0x8001);
    REQUIRE(code.base_address() == 0x8004);

    // Data section with 16-byte alignment
    Section data("DATA");
    data.set_alignment(16);
    data.set_base_address(0x9005);
    REQUIRE(data.base_address() == 0x9010);

    // Stack section with page alignment
    Section stack("STACK");
    stack.set_alignment(256);
    stack.set_base_address(0xA0FF);
    REQUIRE(stack.base_address() == 0xA100);
}

//-----------------------------------------------------------------------------
// Module and Symbol declaration/definition tests
//-----------------------------------------------------------------------------

TEST_CASE("Module: declare_symbol creates new undefined symbol with scope",
          "[model][module][declare]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Symbol* sym = module.declare_symbol("FOO", loc, SymbolScope::Public);

    REQUIRE(sym != nullptr);
    REQUIRE(sym->name() == "FOO");
    REQUIRE(sym->is_undefined());
    REQUIRE(sym->scope() == SymbolScope::Public);
    REQUIRE(sym->location().filename() == "test.asm");
    REQUIRE(sym->location().line_num() == 10);

    REQUIRE(module.has_symbol("FOO"));
}

TEST_CASE("Module: declare_symbol allows scope update from Local",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 20);
    Module module("TEST", loc1);

    // First declare as Local (default)
    Symbol* sym1 = module.declare_symbol("BAR", loc1, SymbolScope::Local);
    REQUIRE(sym1->scope() == SymbolScope::Local);

    // Update to Public - should succeed
    Symbol* sym2 = module.declare_symbol("BAR", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);  // Same symbol
    REQUIRE(sym2->scope() == SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: declare_symbol allows same scope redeclaration",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 30);
    Location loc2("test.asm", 40);
    Module module("TEST", loc1);

    // Declare as Public
    Symbol* sym1 = module.declare_symbol("EXPORT", loc1, SymbolScope::Public);
    REQUIRE(sym1->scope() == SymbolScope::Public);

    // Redeclare as Public - should succeed without error
    Symbol* sym2 = module.declare_symbol("EXPORT", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);  // Same symbol
    REQUIRE(sym2->scope() == SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: declare_symbol errors on scope conflict (Public to Extern)",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 50);
    Location loc2("test.asm", 60);
    Module module("TEST", loc1);

    // Declare as Public
    Symbol* sym1 = module.declare_symbol("CONFLICT", loc1, SymbolScope::Public);
    REQUIRE(sym1->scope() == SymbolScope::Public);

    // Try to change to Extern - should error
    Symbol* sym2 = module.declare_symbol("CONFLICT", loc2, SymbolScope::Extern);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->scope() == SymbolScope::Public);  // Scope unchanged

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:60:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("CONFLICT") != std::string::npos);
}

TEST_CASE("Module: declare_symbol errors on scope conflict (Extern to Public)",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 70);
    Location loc2("test.asm", 80);
    Module module("TEST", loc1);

    // Declare as Extern
    Symbol* sym1 = module.declare_symbol("IMPORT", loc1, SymbolScope::Extern);
    REQUIRE(sym1->scope() == SymbolScope::Extern);

    // Try to change to Public - should error
    Symbol* sym2 = module.declare_symbol("IMPORT", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->scope() == SymbolScope::Extern);  // Scope unchanged

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:80:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
}

TEST_CASE("Module: declare_symbol errors declaring defined symbol as Extern",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 90);
    Location loc2("test.asm", 100);
    Module module("TEST", loc1);

    // Define symbol
    Symbol* sym1 = module.add_symbol("DEFINED", loc1, 42, SymbolType::Constant);
    REQUIRE(sym1->is_defined());
    REQUIRE(sym1->value() == 42);

    // Try to declare as Extern - should error
    Symbol* sym2 = module.declare_symbol("DEFINED", loc2, SymbolScope::Extern);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->is_defined());  // Still defined

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:100:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("cannot declare defined symbol as EXTERN") !=
            std::string::npos);
}

TEST_CASE("Module: declare_symbol allows Global scope transitions",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 110);
    Location loc2("test.asm", 120);
    Module module("TEST", loc1);

    // Declare as Global
    Symbol* sym1 = module.declare_symbol("GLOBAL_SYM", loc1, SymbolScope::Global);
    REQUIRE(sym1->scope() == SymbolScope::Global);

    // Change to Public - should succeed (Global can transition)
    Symbol* sym2 = module.declare_symbol("GLOBAL_SYM", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);
    REQUIRE(sym2->scope() == SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: add_symbol creates new undefined symbol",
          "[model][module][add]") {
    Location loc("test.asm", 130);
    Module module("TEST", loc);

    Symbol* sym = module.add_symbol("NEW_SYM", loc);

    REQUIRE(sym != nullptr);
    REQUIRE(sym->name() == "NEW_SYM");
    REQUIRE(sym->is_undefined());
    REQUIRE(sym->scope() == SymbolScope::Local);
    REQUIRE(sym->location().filename() == "test.asm");
    REQUIRE(sym->location().line_num() == 130);
}

TEST_CASE("Module: add_symbol creates new defined symbol",
          "[model][module][add]") {
    Location loc("test.asm", 140);
    Module module("TEST", loc);

    Symbol* sym = module.add_symbol("CONST", loc, 100, SymbolType::Constant);

    REQUIRE(sym != nullptr);
    REQUIRE(sym->name() == "CONST");
    REQUIRE(sym->is_constant());
    REQUIRE(sym->is_defined());
    REQUIRE(sym->value() == 100);
    REQUIRE(sym->location().filename() == "test.asm");
    REQUIRE(sym->location().line_num() == 140);
}

TEST_CASE("Module: add_symbol updates undefined symbol",
          "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 150);
    Location loc2("test.asm", 160);
    Module module("TEST", loc1);

    // Create undefined symbol
    Symbol* sym1 = module.add_symbol("FORWARD", loc1);
    REQUIRE(sym1->is_undefined());

    // Define it later
    Symbol* sym2 = module.add_symbol("FORWARD", loc2, 200, SymbolType::Constant);
    REQUIRE(sym2 == sym1);  // Same symbol
    REQUIRE(sym2->is_constant());
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2->value() == 200);
    REQUIRE(sym2->location().line_num() == 160);  // Location updated
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: add_symbol errors on redefinition", "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 170);
    Location loc2("test.asm", 180);
    Module module("TEST", loc1);

    // Define symbol
    Symbol* sym1 = module.add_symbol("LABEL", loc1, 0x8000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym1->is_defined());
    REQUIRE(sym1->value() == 0x8000);

    // Try to redefine - should error
    Symbol* sym2 = module.add_symbol("LABEL", loc2, 0x9000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->value() == 0x8000);  // Value unchanged

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:180:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("LABEL") != std::string::npos);
}

TEST_CASE("Module: add_symbol errors defining Extern symbol",
          "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 190);
    Location loc2("test.asm", 200);
    Module module("TEST", loc1);

    // Declare as Extern
    Symbol* sym1 = module.declare_symbol("EXTERNAL", loc1, SymbolScope::Extern);
    REQUIRE(sym1->is_extern());
    REQUIRE(sym1->is_undefined());

    // Try to define - should error
    Symbol* sym2 = module.add_symbol("EXTERNAL", loc2, 100, SymbolType::Constant);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:200:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("cannot define EXTERN symbol") != std::string::npos);
}

TEST_CASE("Module: add_symbol updates location only when defining",
          "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 210);
    Location loc2("test.asm", 220);
    Module module("TEST", loc1);

    // Create undefined symbol
    Symbol* sym1 = module.add_symbol("TEST_SYM", loc1);
    REQUIRE(sym1->location().line_num() == 210);

    // Define it - location should update
    Symbol* sym2 = module.add_symbol("TEST_SYM", loc2, 50, SymbolType::Constant);
    REQUIRE(sym2->location().line_num() == 220);
    REQUIRE_FALSE(g_errors.has_errors());
}

//-----------------------------------------------------------------------------
// Integration tests: declare and define workflow
//-----------------------------------------------------------------------------

TEST_CASE("Integration: PUBLIC declaration followed by definition",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("module.asm", 10);
    Location loc2("module.asm", 50);
    Module module("MYMODULE", loc1);

    // Declare PUBLIC first
    Symbol* sym1 = module.declare_symbol("API_FUNC", loc1, SymbolScope::Public);
    REQUIRE(sym1->is_public());
    REQUIRE(sym1->is_undefined());

    // Define it later
    Symbol* sym2 = module.add_symbol("API_FUNC", loc2, 0x8000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym2 == sym1);
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2->is_public());
    REQUIRE(sym2->is_exported());
    REQUIRE(sym2 == sym1);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: EXTERN declaration stays undefined",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("main.asm", 10);
    Module module("MAIN", loc1);

    // Declare EXTERN
    Symbol* sym = module.declare_symbol("LIBRARY_FUNC", loc1, SymbolScope::Extern);
    REQUIRE(sym->is_extern());
    REQUIRE(sym->is_undefined());
    REQUIRE(sym->is_imported());
    REQUIRE_FALSE(g_errors.has_errors());

    // Cannot define EXTERN symbols
    Location loc2("main.asm", 50);
    module.add_symbol("LIBRARY_FUNC", loc2, 0x9000, SymbolType::AddressRelative);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Integration: GLOBAL declaration then definition acts as PUBLIC",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("module.asm", 10);
    Location loc2("module.asm", 50);
    Module module("TEST", loc1);

    // Declare GLOBAL (undefined)
    Symbol* sym1 = module.declare_symbol("GLOBAL_VAR", loc1, SymbolScope::Global);
    REQUIRE(sym1->is_global());
    REQUIRE(sym1->is_undefined());
    REQUIRE(sym1->is_extern());  // Acts as EXTERN when undefined
    REQUIRE(sym1->is_imported());

    // Define it
    Symbol* sym2 = module.add_symbol("GLOBAL_VAR", loc2, 42, SymbolType::Constant);
    REQUIRE(sym2->is_global());
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2->is_public());  // Acts as PUBLIC when defined
    REQUIRE(sym2->is_exported());
    REQUIRE(sym2 == sym1);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: definition before PUBLIC declaration",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("module.asm", 10);
    Location loc2("module.asm", 50);
    Module module("TEST", loc1);

    // Define first (as Local)
    Symbol* sym1 = module.add_symbol("FUNC", loc1, 0x8000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym1->is_defined());
    REQUIRE(sym1->is_local());

    // Declare PUBLIC later - should update scope
    Symbol* sym2 = module.declare_symbol("FUNC", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);
    REQUIRE(sym2->is_public());
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2 == sym1);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: multiple forward references", "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("program.asm", 10);
    Location loc2("program.asm", 20);
    Location loc3("program.asm", 30);
    Location loc4("program.asm", 100);
    Module module("TEST", loc1);

    // Multiple forward references (undefined)
    Symbol* sym1 = module.add_symbol("LOOP", loc1);
    Symbol* sym2 = module.add_symbol("LOOP", loc2);
    Symbol* sym3 = module.add_symbol("LOOP", loc3);

    REQUIRE(sym1 == sym2);
    REQUIRE(sym2 == sym3);
    REQUIRE(sym1->is_undefined());

    // Finally define it
    Symbol* sym4 = module.add_symbol("LOOP", loc4, 0x8050,
                                     SymbolType::AddressRelative);
    REQUIRE(sym4 == sym1);
    REQUIRE(sym4->is_defined());
    REQUIRE(sym4->value() == 0x8050);
    REQUIRE(sym1 == sym4);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: scope conflict detection", "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("conflict.asm", 10);
    Location loc2("conflict.asm", 20);
    Location loc3("conflict.asm", 30);
    Module module("TEST", loc1);

    // Declare as PUBLIC
    module.declare_symbol("SYMBOL", loc1, SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to redeclare as EXTERN - should error
    module.declare_symbol("SYMBOL", loc2, SymbolScope::Extern);
    REQUIRE(g_errors.has_errors());
    SuppressErrors suppress2;

    // PUBLIC to PUBLIC is fine
    module.declare_symbol("SYMBOL", loc3, SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: typical assembly workflow", "[model][integration]") {
    SuppressErrors suppress;
    Location loc("test.asm", 1);
    Module module("MAIN", loc);

    // Line 10: PUBLIC start
    loc.set_line_num(10);
    module.declare_symbol("start", loc, SymbolScope::Public);

    // Line 20: EXTERN printf
    loc.set_line_num(20);
    module.declare_symbol("printf", loc, SymbolScope::Extern);

    // Line 30: start: (label definition)
    loc.set_line_num(30);
    Symbol* start = module.add_symbol("start", loc, 0x8000,
                                      SymbolType::AddressRelative);

    // Line 40: MAX_SIZE EQU 100
    loc.set_line_num(40);
    Symbol* max_size = module.add_symbol("MAX_SIZE", loc, 100,
                                         SymbolType::Constant);

    // Line 50: loop: (local label)
    loc.set_line_num(50);
    Symbol* loop = module.add_symbol("loop", loc, 0x8010,
                                     SymbolType::AddressRelative);

    REQUIRE_FALSE(g_errors.has_errors());

    // Verify symbols
    REQUIRE(start->is_public());
    REQUIRE(start->is_defined());
    REQUIRE(start->is_exported());
    REQUIRE(start->value() == 0x8000);

    REQUIRE(module.find_symbol("printf")->is_extern());
    REQUIRE(module.find_symbol("printf")->is_undefined());
    REQUIRE(module.find_symbol("printf")->is_imported());

    REQUIRE(max_size->is_constant());
    REQUIRE(max_size->is_local());
    REQUIRE(max_size->value() == 100);

    REQUIRE(loop->is_address_relative());
    REQUIRE(loop->is_local());
    REQUIRE(loop->value() == 0x8010);
}

TEST_CASE("Integration: error recovery continues after redefinition",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 20);
    Location loc3("test.asm", 30);
    Module module("TEST", loc1);

    // Define a symbol
    module.add_symbol("DUP", loc1, 100, SymbolType::Constant);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to redefine (error)
    module.add_symbol("DUP", loc2, 200, SymbolType::Constant);
    REQUIRE(g_errors.has_errors());
    SuppressErrors suppress2;

    // Can still define new symbols after error
    Symbol* new_sym = module.add_symbol("NEW", loc3, 300, SymbolType::Constant);
    REQUIRE(new_sym->value() == 300);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: all scope types with definitions",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc("scopes.asm", 1);
    Module module("TEST", loc);

    // Local symbol (default)
    loc.set_line_num(10);
    Symbol* local_sym = module.add_symbol("local_var", loc, 10,
                                          SymbolType::Constant);
    REQUIRE(local_sym->is_local());
    REQUIRE_FALSE(local_sym->is_exported());
    REQUIRE_FALSE(local_sym->is_imported());

    // Public symbol (exported)
    loc.set_line_num(20);
    module.declare_symbol("public_func", loc, SymbolScope::Public);
    Symbol* public_sym = module.add_symbol("public_func", loc, 0x8000,
                                           SymbolType::AddressRelative);
    REQUIRE(public_sym->is_public());
    REQUIRE(public_sym->is_exported());

    // Extern symbol (imported, stays undefined)
    loc.set_line_num(30);
    Symbol* extern_sym = module.declare_symbol("extern_func", loc,
                         SymbolScope::Extern);
    REQUIRE(extern_sym->is_extern());
    REQUIRE(extern_sym->is_imported());
    REQUIRE(extern_sym->is_undefined());

    // Global symbol (acts as PUBLIC when defined)
    loc.set_line_num(40);
    module.declare_symbol("global_var", loc, SymbolScope::Global);
    Symbol* global_sym = module.add_symbol("global_var", loc, 42,
                                           SymbolType::Constant);
    REQUIRE(global_sym->is_global());
    REQUIRE(global_sym->is_public());  // Acts as PUBLIC when defined
    REQUIRE(global_sym->is_exported());

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: cannot redefine after error", "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 20);
    Module module("TEST", loc1);

    // Define symbol
    Symbol* sym1 = module.add_symbol("TWICE", loc1, 100, SymbolType::Constant);
    REQUIRE(sym1->value() == 100);

    // Try to redefine (error)
    Symbol* sym2 = module.add_symbol("TWICE", loc2, 200, SymbolType::Constant);
    REQUIRE(g_errors.has_errors());

    // Symbol unchanged despite error
    REQUIRE(sym2 == sym1);
    REQUIRE(sym1->value() == 100);  // Original value preserved
}

TEST_CASE("Integration: declare Extern then try to define (error)",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 50);
    Module module("TEST", loc1);

    // Declare EXTERN
    Symbol* sym1 = module.declare_symbol("LIB_FUNC", loc1, SymbolScope::Extern);
    REQUIRE(sym1->is_extern());
    REQUIRE(sym1->is_undefined());

    // Try to define (should error)
    Symbol* sym2 = module.add_symbol("LIB_FUNC", loc2, 0x9000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym2 == sym1);
    REQUIRE(g_errors.has_errors());

    // Symbol remains EXTERN and undefined
    REQUIRE(sym1->is_extern());
    REQUIRE(sym1->is_undefined());
}

//-----------------------------------------------------------------------------
// Module section management tests
//-----------------------------------------------------------------------------

TEST_CASE("Module: constructor creates default empty section",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    REQUIRE(module.sections().size() == 1);
    REQUIRE(module.sections()[0]->name() == "");
    REQUIRE(module.current_section() != nullptr);
    REQUIRE(module.current_section()->name() == "");
}

TEST_CASE("Module: default section is current after construction",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* default_section = module.sections()[0].get();
    REQUIRE(module.current_section() == default_section);
}

TEST_CASE("Module: add_section creates new section and makes it current",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* code_section = module.add_section("CODE");

    REQUIRE(code_section != nullptr);
    REQUIRE(code_section->name() == "CODE");
    REQUIRE(module.sections().size() == 2);
    REQUIRE(module.current_section() == code_section);
}

TEST_CASE("Module: add_section with existing name returns existing and makes it current",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* code1 = module.add_section("CODE");
    Section* data = module.add_section("DATA");
    Section* code2 = module.add_section("CODE");

    REQUIRE(code2 == code1);  // Same section returned
    REQUIRE(code1 != data);
    REQUIRE(code2 != data);
    REQUIRE(module.sections().size() == 3);  // Empty + CODE + DATA
    REQUIRE(module.current_section() == code1);  // CODE is now current again
}

TEST_CASE("Module: section pointer stability across additions",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    // Get pointer to default section
    Section* default_section = module.current_section();

    // Add many sections
    Section* code = module.add_section("CODE");
    Section* data = module.add_section("DATA");
    Section* bss = module.add_section("BSS");
    Section* rodata = module.add_section("RODATA");

    // Original pointers should still be valid
    REQUIRE(default_section->name() == "");
    REQUIRE(code->name() == "CODE");
    REQUIRE(data->name() == "DATA");
    REQUIRE(bss->name() == "BSS");
    REQUIRE(rodata->name() == "RODATA");

    // All sections should be in the list
    REQUIRE(module.sections().size() == 5);
}

TEST_CASE("Module: section pointers remain stable when switching sections",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* code = module.add_section("CODE");
    Section* data = module.add_section("DATA");

    // Switch back to CODE
    Section* code2 = module.add_section("CODE");
    REQUIRE(code2 == code);
    REQUIRE(module.current_section() == code);

    // Switch back to DATA
    Section* data2 = module.add_section("DATA");
    REQUIRE(data2 == data);
    REQUIRE(module.current_section() == data);
}

TEST_CASE("Module: can add opcodes to current section",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    module.add_section("CODE");
    Section* code = module.current_section();

    code->add_opcode(Opcode({ 0x00 }, loc));  // NOP
    code->add_opcode(Opcode({ 0x3E, 0x42 }, loc));  // LD A, 42

    REQUIRE(code->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(code->size() == 3);
}

TEST_CASE("Module: opcodes remain accessible after section switch",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    // Add opcodes to CODE section
    Section* code = module.add_section("CODE");
    code->add_opcode(Opcode({ 0x00 }, loc));
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Switch to DATA section
    Section* data = module.add_section("DATA");
    data->add_opcode(Opcode({ 0x42 }, loc));

    // Switch back to CODE
    module.add_section("CODE");
    REQUIRE(module.current_section() == code);
    code->add_opcode(Opcode({ 0x3E, 0x00 }, loc));

    // Back to DATA
    module.add_section("DATA");
    data->add_opcode(Opcode({ 0xFF }, loc));

    // All pointers should still be valid
    REQUIRE(code->opcodes().size() == 4);
    REQUIRE(data->opcodes().size() == 3);
}

TEST_CASE("Module: find_section returns correct section",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    module.add_section("CODE");
    module.add_section("DATA");

    REQUIRE(module.find_section("")->name() == "");
    REQUIRE(module.find_section("CODE")->name() == "CODE");
    REQUIRE(module.find_section("DATA")->name() == "DATA");
    REQUIRE(module.find_section("NONEXISTENT") == nullptr);
}

TEST_CASE("Module: clear_sections recreates default section",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    // Add several sections
    module.add_section("CODE");
    module.add_section("DATA");
    module.add_section("BSS");
    REQUIRE(module.sections().size() == 4);  // Empty + 3

    // Clear all sections
    module.clear_sections();

    // Should have recreated default empty section
    REQUIRE(module.sections().size() == 1);
    REQUIRE(module.sections()[0]->name() == "");
    REQUIRE(module.current_section() != nullptr);
    REQUIRE(module.current_section()->name() == "");
}

TEST_CASE("Module: section pointer stability with symbols",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);

    // Add symbol referencing section
    Symbol* label = module.add_symbol("start", loc, 0x8000,
                                      SymbolType::AddressRelative);
    label->set_opcode(code->last_opcode());
    label->set_offset(0);

    // Add more sections
    module.add_section("DATA");
    module.add_section("BSS");
    module.add_section("RODATA");

    // Symbol's section pointer should still be valid
    REQUIRE(label->opcode() == code->last_opcode());
}

TEST_CASE("Module: multiple symbols referencing different sections",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);

    Section* data = module.add_section("DATA");
    data->set_base_address(0x9000);

    // Add symbols to different sections
    Symbol* code_label = module.add_symbol("start", loc, 0x8000,
                                           SymbolType::AddressRelative);
    code_label->set_opcode(code->last_opcode());
    code_label->set_offset(0);

    Symbol* data_label = module.add_symbol("buffer", loc, 0x9000,
                                           SymbolType::AddressRelative);
    data_label->set_opcode(data->last_opcode());
    data_label->set_offset(0);

    // Verify both symbols retain correct section pointers
    REQUIRE(code_label->opcode() == code->last_opcode());
    REQUIRE(data_label->opcode() == data->last_opcode());
}

TEST_CASE("Module: current_section const accessor",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    const Section* sec = module.current_section();
    REQUIRE(sec != nullptr);
    REQUIRE(sec->name() == "");
}

TEST_CASE("Module: sections accessor provides access to unique_ptr elements",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    module.add_section("CODE");
    module.add_section("DATA");

    // Access via const reference
    const auto& sections = module.sections();
    REQUIRE(sections.size() == 3);
    REQUIRE(sections[0]->name() == "");
    REQUIRE(sections[1]->name() == "CODE");
    REQUIRE(sections[2]->name() == "DATA");
}

TEST_CASE("Module: section iteration", "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    module.add_section("CODE");
    module.add_section("DATA");
    module.add_section("BSS");

    std::vector<std::string> names;
    for (const auto& section : module.sections()) {
        names.push_back(section->name());
    }

    REQUIRE(names.size() == 4);
    REQUIRE(names[0] == "");
    REQUIRE(names[1] == "CODE");
    REQUIRE(names[2] == "DATA");
    REQUIRE(names[3] == "BSS");
}

//-----------------------------------------------------------------------------
// Integration tests: Module with sections, symbols, and opcodes
//-----------------------------------------------------------------------------

TEST_CASE("Integration: complete module with sections and symbols",
          "[model][integration]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);

    // CODE section
    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);

    loc.set_line_num(10);
    Symbol* start = module.add_symbol("start", loc, 0x8000,
                                      SymbolType::AddressRelative);
    Opcode* start_opcode = code->last_opcode();
    start->set_opcode(start_opcode);
    start->set_offset(0);
    start->set_scope(SymbolScope::Public);

    loc.set_line_num(15);
    code->add_opcode(Opcode({ 0x3E, 0x42 }, loc));  // LD A, 42

    loc.set_line_num(20);
    Symbol* loop = module.add_symbol("loop", loc, 0x8002,
                                     SymbolType::AddressRelative);
    Opcode* loop_opcode = code->last_opcode();
    loop->set_opcode(loop_opcode);
    loop->set_offset(2);

    loc.set_line_num(25);
    code->add_opcode(Opcode({ 0x18, 0xFE }, loc));  // JR loop

    // DATA section
    Section* data = module.add_section("DATA");
    data->set_base_address(0x9000);

    loc.set_line_num(30);
    Symbol* buffer = module.add_symbol("buffer", loc, 0x9000,
                                       SymbolType::AddressRelative);
    Opcode* buffer_opcode = data->last_opcode();
    buffer->set_opcode(buffer_opcode);
    buffer->set_offset(0);

    loc.set_line_num(35);
    data->add_opcode(Opcode({ 0x00, 0x00, 0x00, 0x00 }, loc));  // DEFS 4

    // Verify structure
    REQUIRE(module.sections().size() == 3);  // Empty + CODE + DATA
    REQUIRE(module.symbols().size() == 3);   // start, loop, buffer

    REQUIRE(start->opcode() == start_opcode);
    REQUIRE(loop->opcode() == loop_opcode);
    REQUIRE(buffer->opcode() == buffer_opcode);

    REQUIRE(code->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(code->size() == 4);
    REQUIRE(data->opcodes().size() == 2); // section starts with empty opcode
    REQUIRE(data->size() == 4);
}

TEST_CASE("Integration: section switching workflow", "[model][integration]") {
    Location loc("multi.asm", 1);
    Module module("TEST", loc);

    // Start in CODE section
    loc.set_line_num(10);
    Section* code = module.add_section("CODE");
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Switch to DATA section
    loc.set_line_num(20);
    Section* data = module.add_section("DATA");
    data->add_opcode(Opcode({ 0x42 }, loc));

    // Back to CODE
    loc.set_line_num(30);
    module.add_section("CODE");
    REQUIRE(module.current_section() == code);
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Back to DATA
    loc.set_line_num(40);
    module.add_section("DATA");
    REQUIRE(module.current_section() == data);
    data->add_opcode(Opcode({ 0xFF }, loc));

    // Verify final state
    REQUIRE(code->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(data->opcodes().size() == 3); // section starts with empty opcode
}

TEST_CASE("Integration: default section behavior", "[model][integration]") {
    Location loc("default.asm", 1);
    Module module("TEST", loc);

    // Add opcodes to default section without explicit section directive
    Section* default_sec = module.current_section();
    REQUIRE(default_sec->name() == "");

    loc.set_line_num(10);
    default_sec->add_opcode(Opcode({ 0x00 }, loc));
    loc.set_line_num(20);
    default_sec->add_opcode(Opcode({ 0x3E, 0x42 }, loc));

    // Add named section
    Section* code = module.add_section("CODE");
    loc.set_line_num(30);
    code->add_opcode(Opcode({ 0xC3, 0x00, 0x80 }, loc));

    // Verify both sections exist and have correct opcodes
    REQUIRE(module.sections().size() == 2);
    REQUIRE(default_sec->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(code->opcodes().size() == 2);
}

TEST_CASE("Integration: section with alignment and symbols",
          "[model][integration]") {
    Location loc("aligned.asm", 10);
    Module module("TEST", loc);

    // Create page-aligned section
    Section* page = module.add_section("PAGE_DATA");
    page->set_alignment(256);
    page->set_base_address(0x7F80);  // Will align to 0x8000

    REQUIRE(page->base_address() == 0x8000);

    // Add symbol at start of page
    Symbol* page_start = module.add_symbol("page_start", loc, 0x8000,
                                           SymbolType::AddressRelative);
    Opcode* page_start_opcode = page->last_opcode();
    page_start->set_opcode(page_start_opcode);
    page_start->set_offset(0);

    // Add data
    for (int i = 0; i < 256; ++i) {
        page->add_opcode(Opcode({ static_cast<uint8_t>(i) }, loc));
    }

    REQUIRE(page->size() == 256);
    REQUIRE(page->pc() == 0x8100);
    REQUIRE(page_start->opcode() == page_start_opcode);
}

//-----------------------------------------------------------------------------
// Section opcode pointer stability tests
//-----------------------------------------------------------------------------

TEST_CASE("Section: add_opcode returns pointer to added opcode",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    Opcode* opcode1 = section.add_opcode(Opcode({ 0x00 }, loc));
    REQUIRE(opcode1 != nullptr);
    REQUIRE(opcode1->size() == 1);
    REQUIRE(opcode1->bytes()[0] == 0x00);

    Opcode* opcode2 = section.add_opcode(Opcode({ 0x3E, 0x42 }, loc));
    REQUIRE(opcode2 != nullptr);
    REQUIRE(opcode2->size() == 2);
    REQUIRE(opcode2->bytes()[0] == 0x3E);
    REQUIRE(opcode2->bytes()[1] == 0x42);

    // Different pointers
    REQUIRE(opcode1 != opcode2);
}

TEST_CASE("Section: opcode pointers remain stable across additions",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    // Add first opcode and save pointer
    Opcode* first = section.add_opcode(Opcode({ 0x00 }, loc));
    REQUIRE(first->size() == 1);
    REQUIRE(section.opcodes().size() == 2); // section starts with empty opcode

    // Add many more opcodes
    std::vector<Opcode*> opcodes;
    opcodes.push_back(first);
    for (int i = 0; i < 100; ++i) {
        opcodes.push_back(section.add_opcode(Opcode({ 0x00 }, loc)));
    }

    // First pointer should still be valid and point to correct data
    REQUIRE(first->size() == 1);
    REQUIRE(first->bytes()[0] == 0x00);

    // All pointers should still be valid
    for (size_t i = 0; i < opcodes.size(); ++i) {
        REQUIRE(opcodes[i]->size() == 1);
        REQUIRE(opcodes[i]->bytes()[0] == 0x00);
    }

    REQUIRE(section.opcodes().size() == 102); // section starts with empty opcode
}

TEST_CASE("Section: opcode pointers can be modified through returned pointer",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    Opcode* opcode = section.add_opcode(Opcode({ 0x00, 0x00 }, loc));
    REQUIRE(opcode->size() == 2);

    // Modify through pointer
    opcode->set_bytes({ 0x3E, 0x42 });

    // Verify modification persists
    REQUIRE(opcode->size() == 2);
    REQUIRE(opcode->bytes()[0] == 0x3E);
    REQUIRE(opcode->bytes()[1] == 0x42);

    // Verify through section access
    const auto& opcodes = section.opcodes();
    REQUIRE(opcodes.size() == 2); // section start with empty opcode
    REQUIRE(opcodes[1]->bytes()[0] == 0x3E);
    REQUIRE(opcodes[1]->bytes()[1] == 0x42);
}

TEST_CASE("Section: opcode pointers with patches remain stable",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section section("CODE");
    Symbol* target_sym = module.add_symbol("target", loc);

    // Add opcode with patch
    Opcode* opcode = section.add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));
    Expression expr(make_symbol(target_sym), loc);
    Patch patch(1, PatchRange::Word, expr);
    opcode->add_patch(patch);

    REQUIRE(opcode->has_patches());
    REQUIRE(opcode->patches().size() == 1);

    // Add more opcodes
    for (int i = 0; i < 50; ++i) {
        section.add_opcode(Opcode({ 0x00 }, loc));
    }

    // Original opcode pointer should still be valid
    REQUIRE(opcode->has_patches());
    REQUIRE(opcode->patches().size() == 1);
    REQUIRE(opcode->patches()[0].offset() == 1);
}

//-----------------------------------------------------------------------------
// Section last_opcode() tests
//-----------------------------------------------------------------------------

TEST_CASE("Section: last_opcode never returns nullptr",
          "[model][section][opcode]") {
    Section section("CODE");

    REQUIRE(section.last_opcode() != nullptr);
}

TEST_CASE("Section: last_opcode returns pointer to last added opcode",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    Opcode* first = section.add_opcode(Opcode({ 0x00 }, loc));
    REQUIRE(section.last_opcode() == first);

    Opcode* second = section.add_opcode(Opcode({ 0x3E, 0x42 }, loc));
    REQUIRE(section.last_opcode() == second);
    REQUIRE(section.last_opcode() != first);

    Opcode* third = section.add_opcode(Opcode({ 0xC3, 0x00, 0x80 }, loc));
    REQUIRE(section.last_opcode() == third);
}

TEST_CASE("Section: last_opcode const version", "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    section.add_opcode(Opcode({ 0x00 }, loc));
    section.add_opcode(Opcode({ 0x3E, 0x42 }, loc));

    const Section& const_section = section;
    const Opcode* last = const_section.last_opcode();

    REQUIRE(last != nullptr);
    REQUIRE(last->size() == 2);
    REQUIRE(last->bytes()[0] == 0x3E);
    REQUIRE(last->bytes()[1] == 0x42);
}

TEST_CASE("Section: last_opcode can be used to modify last opcode",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    section.add_opcode(Opcode({ 0x00 }, loc));
    section.add_opcode(Opcode({ 0x00, 0x00 }, loc));

    Opcode* last = section.last_opcode();
    REQUIRE(last != nullptr);

    // Modify last opcode
    last->set_bytes({ 0x3E, 0x42 });

    // Verify modification
    REQUIRE(section.last_opcode()->size() == 2);
    REQUIRE(section.last_opcode()->bytes()[0] == 0x3E);
    REQUIRE(section.last_opcode()->bytes()[1] == 0x42);
}

TEST_CASE("Section: last_opcode after clear_opcodes",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");
    REQUIRE(section.last_opcode() != nullptr);

    section.add_opcode(Opcode({ 0x00 }, loc));
    section.add_opcode(Opcode({ 0x00 }, loc));
    REQUIRE(section.last_opcode() != nullptr);

    section.clear_opcodes();
    REQUIRE(section.last_opcode() != nullptr);
}

TEST_CASE("Section: last_opcode with patches", "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section section("CODE");
    Symbol* target_sym = module.add_symbol("target", loc);

    section.add_opcode(Opcode({ 0x00 }, loc));
    section.add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));

    Opcode* last = section.last_opcode();
    REQUIRE(last != nullptr);

    // Add patch to last opcode
    Expression expr(make_symbol(target_sym), loc);
    Patch patch(1, PatchRange::Word, expr);
    last->add_patch(patch);

    // Verify patch is accessible
    REQUIRE(section.last_opcode()->has_patches());
    REQUIRE(section.last_opcode()->patches().size() == 1);
}

//-----------------------------------------------------------------------------
// Integration tests: Opcode pointer stability with symbols
//-----------------------------------------------------------------------------

TEST_CASE("Integration: label symbol with opcode pointer",
          "[model][integration]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Add some code
    section->add_opcode(Opcode({ 0x00 }, loc));
    section->add_opcode(Opcode({ 0x3E, 0x42 }, loc));

    // Add label at current position
    Opcode* label_opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* label = module.add_symbol("loop", loc, 0, SymbolType::AddressRelative);
    label->set_opcode(section->last_opcode());

    // Add more code
    for (int i = 0; i < 50; ++i) {
        section->add_opcode(Opcode({ 0x00 }, loc));
    }

    // Opcode pointer should still be valid
    REQUIRE(label_opcode->size() == 1);
    REQUIRE(label->opcode() == label_opcode);
}

TEST_CASE("Integration: multiple labels with stable opcode pointers",
          "[model][integration]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Create multiple labels with associated opcodes
    std::vector<Opcode*> label_opcodes;
    std::vector<Symbol*> labels;

    for (int i = 0; i < 10; ++i) {
        Opcode* opcode = section->add_opcode(Opcode({ 0x00 }, loc));
        label_opcodes.push_back(opcode);

        std::string label_name = "label" + std::to_string(i);
        Symbol* label = module.add_symbol(label_name, loc, i,
                                          SymbolType::AddressRelative);
        label->set_opcode(section->last_opcode());
        labels.push_back(label);
    }

    // Add more code
    for (int i = 0; i < 100; ++i) {
        section->add_opcode(Opcode({ 0x00 }, loc));
    }

    // All opcode pointers should still be valid
    for (size_t i = 0; i < label_opcodes.size(); ++i) {
        REQUIRE(label_opcodes[i]->size() == 1);
        REQUIRE(labels[i]->opcode() == label_opcodes[i]);
    }
}

TEST_CASE("Integration: last_opcode for associating labels",
          "[model][integration]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Simulate assembly: add instruction then label
    loc.set_line_num(10);
    section->add_opcode(Opcode({ 0x3E, 0x00 }, loc));  // LD A, 0

    loc.set_line_num(20);
    section->add_opcode(Opcode({ 0x00 }, loc));         // NOP (at loop:)
    Opcode* loop_opcode = section->last_opcode();

    Symbol* loop_label = module.add_symbol("loop", loc, 0,
                                           SymbolType::AddressRelative);
    loop_label->set_opcode(loop_opcode);

    loc.set_line_num(30);
    section->add_opcode(Opcode({ 0x3C }, loc));         // INC A

    loc.set_line_num(40);
    section->add_opcode(Opcode({ 0x18, 0xFC }, loc));   // JR loop

    // Verify loop opcode pointer is still valid
    REQUIRE(loop_opcode != nullptr);
    REQUIRE(loop_opcode->size() == 1);
    REQUIRE(loop_opcode->bytes()[0] == 0x00);

    REQUIRE(loop_label->opcode() == loop_opcode);
    REQUIRE(section->opcodes().size() == 5); // section starts with empty opcode
}

TEST_CASE("Integration: opcode pointer stability across section switches",
          "[model][integration]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    // CODE section
    Section* code = module.add_section("CODE");
    Opcode* code_opcode = code->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* code_label = module.add_symbol("start", loc, 0,
                                           SymbolType::AddressRelative);
    code_label->set_opcode(code->last_opcode());

    // DATA section
    Section* data = module.add_section("DATA");
    Opcode* data_opcode = data->add_opcode(Opcode({ 0x42 }, loc));
    Symbol* data_label = module.add_symbol("value", loc, 0,
                                           SymbolType::AddressRelative);
    data_label->set_opcode(data->last_opcode());

    // Back to CODE
    module.add_section("CODE");
    code->add_opcode(Opcode({ 0x3E, 0x00 }, loc));

    // Back to DATA
    module.add_section("DATA");
    data->add_opcode(Opcode({ 0xFF }, loc));

    // All pointers should still be valid
    REQUIRE(code_opcode->bytes()[0] == 0x00);
    REQUIRE(data_opcode->bytes()[0] == 0x42);
    REQUIRE(code_label->opcode() == code_opcode);
    REQUIRE(data_label->opcode() == data_opcode);
}

TEST_CASE("Integration: opcode modification through stable pointers",
          "[model][integration]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Add placeholder opcode
    Opcode* placeholder = section->add_opcode(Opcode({ 0x00, 0x00, 0x00 }, loc));

    // Add more opcodes
    for (int i = 0; i < 20; ++i) {
        section->add_opcode(Opcode({ 0x00 }, loc));
    }

    // Later, patch the placeholder (simulating two-pass assembly)
    placeholder->set_bytes({ 0xC3, 0x00, 0x80 });  // JP 0x8000
    Expression expr(make_integer(0x8000), loc);
    Patch patch(1, PatchRange::Word, expr);
    placeholder->add_patch(patch);

    // Verify modification
    REQUIRE(placeholder->size() == 3);
    REQUIRE(placeholder->bytes()[0] == 0xC3);
    REQUIRE(placeholder->has_patches());
}

TEST_CASE("Integration: last_opcode workflow for label association",
          "[model][integration]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Simulate typical assembly workflow
    loc.set_line_num(10);
    section->add_opcode(Opcode({ 0x00 }, loc));  // NOP

    // Label at next position
    loc.set_line_num(11);
    section->add_opcode(Opcode({ 0x00 }, loc));  // NOP (placeholder for start:)
    Opcode* start_opcode = section->last_opcode();
    Symbol* start = module.add_symbol("start", loc, 0, SymbolType::AddressRelative);
    start->set_opcode(section->last_opcode());
    start->set_offset(1);  // Offset 1 from section base
    module.declare_symbol("start", loc, SymbolScope::Public);

    loc.set_line_num(12);
    section->add_opcode(Opcode({ 0x3E, 0x42 }, loc));  // LD A, 42

    // Another label
    loc.set_line_num(13);
    section->add_opcode(Opcode({ 0x00 }, loc));  // NOP (placeholder for loop:)
    Opcode* loop_opcode = section->last_opcode();
    Symbol* loop = module.add_symbol("loop", loc, 0, SymbolType::AddressRelative);
    loop->set_opcode(section->last_opcode());
    loop->set_offset(3);  // Offset 3 from section base

    loc.set_line_num(14);
    section->add_opcode(Opcode({ 0x18, 0xFE }, loc));  // JR loop

    // Verify structure
    REQUIRE(section->opcodes().size() == 6); // section starts with empty opcode
    REQUIRE(start_opcode->size() == 1);
    REQUIRE(loop_opcode->size() == 1);
    REQUIRE(start->is_public());
    REQUIRE(start->opcode() == start_opcode);
    REQUIRE(loop->opcode() == loop_opcode);
}

TEST_CASE("Integration: opcode pointers survive section operations",
          "[model][integration]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Section* section = module.add_section("CODE");
    section->set_alignment(16);
    section->set_base_address(0x8001);  // Will align to 0x8010

    // Add opcodes and save pointers
    std::vector<Opcode*> opcodes;
    for (int i = 0; i < 10; ++i) {
        opcodes.push_back(section->add_opcode(Opcode({ static_cast<uint8_t>(i) },
                                              loc)));
    }

    // Perform section operations
    REQUIRE(section->base_address() == 0x8010);
    REQUIRE(section->size() == 10);
    REQUIRE(section->pc() == 0x801A);

    // All opcode pointers should still be valid
    for (size_t i = 0; i < opcodes.size(); ++i) {
        REQUIRE(opcodes[i]->size() == 1);
        REQUIRE(opcodes[i]->bytes()[0] == static_cast<uint8_t>(i));
    }
}

//-----------------------------------------------------------------------------
// Symbol label constructor test
//-----------------------------------------------------------------------------

TEST_CASE("Symbol: label constructor", "[model][symbol]") {
    Location loc("test.asm", 100);
    Section section("CODE");
    section.set_base_address(0x8000);

    Opcode* opcode = section.add_opcode(Opcode({ 0x00 }, loc));

    Symbol label("start", loc, opcode, 0, SymbolType::AddressRelative);

    REQUIRE(label.name() == "start");
    REQUIRE(label.type() == SymbolType::AddressRelative);
    REQUIRE(label.is_address_relative());
    REQUIRE(label.is_defined());
    REQUIRE(label.opcode() == opcode);
    REQUIRE(label.offset() == 0);
    REQUIRE(label.location().filename() == "test.asm");
    REQUIRE(label.location().line_num() == 100);
    REQUIRE(label.scope() == SymbolScope::Local);  // Default scope
}

TEST_CASE("Symbol: label constructor with offset", "[model][symbol]") {
    Location loc("test.asm", 50);
    Section section("CODE");
    section.set_base_address(0x8000);

    // Add some opcodes
    section.add_opcode(Opcode({ 0x00 }, loc));
    section.add_opcode(Opcode({ 0x3E, 0x42 }, loc));
    Opcode* label_opcode = section.add_opcode(Opcode({ 0x00 }, loc));

    Symbol label("loop", loc, label_opcode, 3, SymbolType::AddressRelative);

    REQUIRE(label.name() == "loop");
    REQUIRE(label.is_address_relative());
    REQUIRE(label.opcode() == label_opcode);
    REQUIRE(label.offset() == 3);
}

TEST_CASE("Symbol: label constructor default type", "[model][symbol]") {
    Location loc("test.asm", 10);
    Section section("CODE");
    Opcode* opcode = section.add_opcode(Opcode({ 0x00 }, loc));

    // Using default type parameter (AddressRelative)
    Symbol label("entry", loc, opcode, 0);

    REQUIRE(label.type() == SymbolType::AddressRelative);
    REQUIRE(label.is_address_relative());
    REQUIRE(label.is_defined());
}

TEST_CASE("Symbol: label constructor opcode pointer stability",
          "[model][symbol]") {
    Location loc("test.asm", 20);
    Section section("CODE");

    Opcode* opcode1 = section.add_opcode(Opcode({ 0x00 }, loc));
    Symbol label1("label1", loc, opcode1, 0);

    // Add more opcodes
    for (int i = 0; i < 50; ++i) {
        section.add_opcode(Opcode({ 0x00 }, loc));
    }

    Opcode* opcode2 = section.add_opcode(Opcode({ 0x3E, 0x42 }, loc));
    Symbol label2("label2", loc, opcode2, 51);

    // Verify pointers are still valid
    REQUIRE(label1.opcode() == opcode1);
    REQUIRE(label1.opcode()->size() == 1);
    REQUIRE(label2.opcode() == opcode2);
    REQUIRE(label2.opcode()->size() == 2);
}

//-----------------------------------------------------------------------------
// Integration test: Complete label workflow with new constructor
//-----------------------------------------------------------------------------

TEST_CASE("Integration: label creation workflow with new constructor",
          "[model][integration]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);

    Section* section = module.add_section("CODE");
    section->set_base_address(0x8000);

    // Simulate assembly workflow
    loc.set_line_num(10);
    section->add_opcode(Opcode({ 0x00 }, loc));  // NOP

    // Label at current position
    loc.set_line_num(11);
    Opcode* start_opcode = section->add_opcode(Opcode({ 0x3E, 0x00 },
                           loc));  // LD A, 0

    // Create label using new constructor
    Symbol start_label("start", loc, start_opcode, 1);

    // Manually add to module's symbol table (in real code, Module would do this)
    // For this test, just verify the Symbol object is correct
    REQUIRE(start_label.name() == "start");
    REQUIRE(start_label.is_address_relative());
    REQUIRE(start_label.is_defined());
    REQUIRE(start_label.opcode() == start_opcode);
    REQUIRE(start_label.offset() == 1);
    REQUIRE(start_label.scope() == SymbolScope::Local);

    // Add more code
    loc.set_line_num(12);
    section->add_opcode(Opcode({ 0x3C }, loc));  // INC A

    loc.set_line_num(13);
    Opcode* loop_opcode = section->add_opcode(Opcode({ 0x00 },
                          loc));  // NOP (placeholder)
    Symbol loop_label("loop", loc, loop_opcode, 3);

    loc.set_line_num(14);
    section->add_opcode(Opcode({ 0x18, 0xFE }, loc));  // JR loop

    // Verify both labels
    REQUIRE(start_label.opcode() == start_opcode);
    REQUIRE(loop_label.opcode() == loop_opcode);
    REQUIRE(section->opcodes().size() == 6); // section starts with empty opcode
}

TEST_CASE("Integration: public label with new constructor",
          "[model][integration]") {
    Location loc("module.asm", 10);
    Module module("MYLIB", loc);

    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Add entry point
    Opcode* entry_opcode = section->add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));

    // Create public label
    Symbol api_func("api_func", loc, entry_opcode, 0);

    // Would normally be added via module.add_symbol() and then declared public
    REQUIRE(api_func.name() == "api_func");
    REQUIRE(api_func.is_address_relative());
    REQUIRE(api_func.opcode() == entry_opcode);

    // Simulate PUBLIC declaration
    api_func.set_scope(SymbolScope::Public);
    REQUIRE(api_func.is_public());
    REQUIRE(api_func.is_exported());
}

//-----------------------------------------------------------------------------
// Integration tests: Expression with label symbols
//-----------------------------------------------------------------------------

TEST_CASE("Integration: label reference in expression",
          "[model][integration][expr]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Add code
    loc.set_line_num(10);
    section->add_opcode(Opcode({ 0x00 }, loc));  // 0x8000: NOP

    loc.set_line_num(11);
    Opcode* loop_opcode = section->add_opcode(Opcode({ 0x3E, 0x00 },
                          loc));  // 0x8001: LD A, 0
    Symbol* loop = module.add_symbol("loop", loc);
    loop->set_type(SymbolType::AddressRelative);
    loop->set_opcode(loop_opcode);
    loop->set_offset(0);

    loc.set_line_num(12);
    section->add_opcode(Opcode({ 0x3C }, loc));  // 0x8003: INC A

    loc.set_line_num(13);
    section->add_opcode(Opcode({ 0x18, 0x00 },
                               loc));  // 0x8004: JR loop (offset to be calculated)

    // Calculate JR offset: loop - ($ + 2)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "loop", true));
    line.tokens().push_back(Token(TokenType::Minus, "-", true));
    line.tokens().push_back(Token(TokenType::LeftParen, "(", true));
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    section->compute_opcodes_addresses();
    REQUIRE(expr.evaluate() == -5);  // 0x8001 - 0x8006 = -5 (correct JR offset)
}

TEST_CASE("Integration: forward reference in expression",
          "[model][integration][expr]") {
    Location loc("program.asm", 10);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Parse expression with forward reference (symbol defined later)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "end_label", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // Symbol should be created but undefined
    Symbol* sym = module.find_symbol("end_label");
    REQUIRE(sym != nullptr);
    REQUIRE(sym->is_undefined());

    // Evaluation should fail at this point
    REQUIRE_THROWS_AS(expr.evaluate(), UndefinedSymbol);

    // Now define the symbol
    sym->set_value(0x8100);
    sym->set_type(SymbolType::Constant);

    // Evaluation should now succeed
    REQUIRE(expr.evaluate() == 0x8100);
}

TEST_CASE("Integration: expression in patch", "[model][integration][expr]") {
    Location loc("program.asm", 10);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create target label
    Opcode* target_opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* target = module.add_symbol("target", loc);
    target->set_type(SymbolType::AddressRelative);
    target->set_opcode(target_opcode);
    target->set_offset(0);

    // Add JP instruction with patch
    Opcode* jp_opcode = section->add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));

    // Create expression for patch: target
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "target", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // Add patch to opcode
    Patch patch(1, PatchRange::Word, expr);
    jp_opcode->add_patch(patch);

    // Verify patch
    REQUIRE(jp_opcode->has_patches());
    REQUIRE(jp_opcode->patches().size() == 1);

    // Evaluate patch expression
    section->compute_opcodes_addresses();
    REQUIRE(jp_opcode->patches()[0].expression().evaluate() == 0x8000);
}

TEST_CASE("Integration: $ in different sections",
          "[model][integration][expr]") {
    Location loc("multi.asm", 10);
    Module module("TEST", loc);

    // CODE section
    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);
    code->add_opcode(Opcode({ 0x00 }, loc));
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Parse $ in CODE section
    TokenLine line1(loc);
    line1.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr1;
    size_t i1 = 0;
    REQUIRE(expr1.parse(line1, i1, &module, code));

    REQUIRE(expr1.evaluate() == 0x8001);  // Last opcode in CODE

    // DATA section
    Section* data = module.add_section("DATA");
    data->set_base_address(0x9000);
    data->add_opcode(Opcode({ 0x42 }, loc));

    // Parse $ in DATA section
    TokenLine line2(loc);
    line2.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr2;
    size_t i2 = 0;
    REQUIRE(expr2.parse(line2, i2, &module, data));

    REQUIRE(expr2.evaluate() == 0x9000);  // Last opcode in DATA
}

TEST_CASE("Integration: expression with PUBLIC symbol",
          "[model][integration][expr]") {
    Location loc("lib.asm", 10);
    Module module("LIB", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create and export symbol
    Opcode* api_opcode = section->add_opcode(Opcode({ 0xC9 }, loc));  // RET
    Symbol* api_func = module.add_symbol("api_init", loc);
    api_func->set_type(SymbolType::AddressRelative);
    api_func->set_opcode(api_opcode);
    api_func->set_offset(0);
    module.declare_symbol("api_init", loc, SymbolScope::Public);

    // Use in expression
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "api_init", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    section->compute_opcodes_addresses();
    REQUIRE(expr.evaluate() == 0x8000);
    REQUIRE(api_func->is_public());
}

TEST_CASE("Integration: complex offset calculation",
          "[model][integration][expr]") {
    Location loc("calc.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create structure offsets
    module.add_symbol("struct_size", loc, 16, SymbolType::Constant);
    module.add_symbol("index", loc, 3, SymbolType::Constant);
    module.add_symbol("base_addr", loc, 0x9000, SymbolType::Constant);

    section->add_opcode(Opcode({ 0x00 }, loc));

    // Calculate: base_addr + (index * struct_size) + 4
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "base_addr", true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::LeftParen, "(", true));
    line.tokens().push_back(Token(TokenType::Identifier, "index", false));
    line.tokens().push_back(Token(TokenType::Multiply, "*", true));
    line.tokens().push_back(Token(TokenType::Identifier, "struct_size", true));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, true));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    REQUIRE(expr.evaluate() == 0x9034);  // 0x9000 + (3 * 16) + 4
}

//-----------------------------------------------------------------------------
// CompilationUnit tests
//-----------------------------------------------------------------------------

TEST_CASE("CompilationUnit: constructor creates default empty module",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    REQUIRE(unit.name() == "test");
    REQUIRE(unit.location().filename() == "test.asm");
    REQUIRE(unit.location().line_num() == 1);
    REQUIRE(unit.modules().size() == 1);
    REQUIRE(unit.modules()[0]->name() == "");
    REQUIRE(unit.current_module() != nullptr);
    REQUIRE(unit.current_module()->name() == "");
}

TEST_CASE("CompilationUnit: default module is current after construction",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    const Module* default_module = unit.modules()[0].get();
    REQUIRE(unit.current_module() == default_module);
}

TEST_CASE("CompilationUnit: add_module creates new module and makes it current",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    Module* main_module = unit.add_module("MAIN");

    REQUIRE(main_module != nullptr);
    REQUIRE(main_module->name() == "MAIN");
    REQUIRE(unit.modules().size() == 2);
    REQUIRE(unit.current_module() == main_module);
}

TEST_CASE("CompilationUnit: add_module with existing name returns existing",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    Module* main1 = unit.add_module("MAIN");
    Module* lib = unit.add_module("LIB");
    Module* main2 = unit.add_module("MAIN");

    REQUIRE(main2 == main1);  // Same module returned
    REQUIRE(main1 != lib);
    REQUIRE(main2 != lib);
    REQUIRE(unit.modules().size() == 3);  // Empty + MAIN + LIB
    REQUIRE(unit.current_module() == main1);  // MAIN is now current again
}

TEST_CASE("CompilationUnit: module pointer stability across additions",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    // Get pointer to default module
    Module* default_module = unit.current_module();

    // Add many modules
    Module* main = unit.add_module("MAIN");
    Module* lib1 = unit.add_module("LIB1");
    Module* lib2 = unit.add_module("LIB2");
    Module* lib3 = unit.add_module("LIB3");

    // Original pointers should still be valid
    REQUIRE(default_module->name() == "");
    REQUIRE(main->name() == "MAIN");
    REQUIRE(lib1->name() == "LIB1");
    REQUIRE(lib2->name() == "LIB2");
    REQUIRE(lib3->name() == "LIB3");

    // All modules should be in the list
    REQUIRE(unit.modules().size() == 5);
}

TEST_CASE("CompilationUnit: module pointers remain stable when switching modules",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    Module* main = unit.add_module("MAIN");
    Module* lib = unit.add_module("LIB");

    // Switch back to MAIN
    Module* main2 = unit.add_module("MAIN");
    REQUIRE(main2 == main);
    REQUIRE(unit.current_module() == main);

    // Switch back to LIB
    Module* lib2 = unit.add_module("LIB");
    REQUIRE(lib2 == lib);
    REQUIRE(unit.current_module() == lib);
}

TEST_CASE("CompilationUnit: find_module returns correct module",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    unit.add_module("MAIN");
    unit.add_module("LIB");

    REQUIRE(unit.find_module("")->name() == "");
    REQUIRE(unit.find_module("MAIN")->name() == "MAIN");
    REQUIRE(unit.find_module("LIB")->name() == "LIB");
    REQUIRE(unit.find_module("NONEXISTENT") == nullptr);
}

TEST_CASE("CompilationUnit: clear_modules recreates default module",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    // Add several modules
    unit.add_module("MAIN");
    unit.add_module("LIB1");
    unit.add_module("LIB2");
    REQUIRE(unit.modules().size() == 4);  // Empty + 3

    // Clear all modules
    unit.clear_modules();

    // Should have recreated default empty module
    REQUIRE(unit.modules().size() == 1);
    REQUIRE(unit.modules()[0]->name() == "");
    REQUIRE(unit.current_module() != nullptr);
    REQUIRE(unit.current_module()->name() == "");
}

TEST_CASE("CompilationUnit: current_module const accessor",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    const Module* mod = unit.current_module();
    REQUIRE(mod != nullptr);
    REQUIRE(mod->name() == "");
}

TEST_CASE("CompilationUnit: module iteration", "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    unit.add_module("MAIN");
    unit.add_module("LIB1");
    unit.add_module("LIB2");

    std::vector<std::string> names;
    for (const auto& module : unit.modules()) {
        names.push_back(module->name());
    }

    REQUIRE(names.size() == 4);
    REQUIRE(names[0] == "");
    REQUIRE(names[1] == "MAIN");
    REQUIRE(names[2] == "LIB1");
    REQUIRE(names[3] == "LIB2");
}

//-----------------------------------------------------------------------------
// Integration tests: CompilationUnit with modules and symbols
//-----------------------------------------------------------------------------

TEST_CASE("Integration: compilation unit with multiple modules",
          "[model][integration]") {
    Location loc("program.asm", 1);
    CompilationUnit unit("program", loc);

    // MAIN module with public symbol
    Module* main = unit.add_module("MAIN");
    loc.set_line_num(10);
    Symbol* start = main->add_symbol("start", loc, 0x8000, SymbolType::Constant);
    start->set_scope(SymbolScope::Public);

    // LIB module with exported function
    Module* lib = unit.add_module("LIB");
    loc.set_line_num(20);
    Symbol* func = lib->add_symbol("lib_init", loc, 0x9000, SymbolType::Constant);
    func->set_scope(SymbolScope::Public);

    // Verify structure
    REQUIRE(unit.modules().size() == 3);  // Empty + MAIN + LIB

    REQUIRE(main->symbols().size() == 1);
    REQUIRE(lib->symbols().size() == 1);

    REQUIRE(start->is_public());
    REQUIRE(func->is_public());
}

TEST_CASE("Integration: module switching workflow", "[model][integration]") {
    Location loc("multi.asm", 1);
    CompilationUnit unit("multi", loc);

    // Start in MAIN module
    loc.set_line_num(10);
    Module* main = unit.add_module("MAIN");
    main->add_symbol("var1", loc, 10, SymbolType::Constant);

    // Switch to LIB module
    loc.set_line_num(20);
    Module* lib = unit.add_module("LIB");
    lib->add_symbol("var2", loc, 20, SymbolType::Constant);

    // Back to MAIN
    loc.set_line_num(30);
    unit.add_module("MAIN");
    REQUIRE(unit.current_module() == main);
    main->add_symbol("var3", loc, 30, SymbolType::Constant);

    // Back to LIB
    loc.set_line_num(40);
    unit.add_module("LIB");
    REQUIRE(unit.current_module() == lib);
    lib->add_symbol("var4", loc, 40, SymbolType::Constant);

    // Verify final state
    REQUIRE(main->symbols().size() == 2);  // var1, var3
    REQUIRE(lib->symbols().size() == 2);   // var2, var4
}

TEST_CASE("Integration: default module behavior", "[model][integration]") {
    Location loc("default.asm", 1);
    CompilationUnit unit("default", loc);

    // Add symbols to default module without explicit module directive
    Module* default_mod = unit.current_module();
    REQUIRE(default_mod->name() == "");

    loc.set_line_num(10);
    default_mod->add_symbol("label1", loc, 0x8000, SymbolType::Constant);

    loc.set_line_num(20);
    default_mod->add_symbol("label2", loc, 0x8010, SymbolType::Constant);

    // Add named module
    Module* main = unit.add_module("MAIN");
    loc.set_line_num(30);
    main->add_symbol("label3", loc, 0x9000, SymbolType::Constant);

    // Verify both modules exist and have correct symbols
    REQUIRE(unit.modules().size() == 2);
    REQUIRE(default_mod->symbols().size() == 2);
    REQUIRE(main->symbols().size() == 1);
}

TEST_CASE("Integration: compilation unit with sections and modules",
          "[model][integration]") {
    Location loc("complete.asm", 1);
    CompilationUnit unit("complete", loc);

    // MAIN module with CODE section
    Module* main = unit.add_module("MAIN");
    Section* code = main->add_section("CODE");
    code->set_base_address(0x8000);

    loc.set_line_num(10);
    Symbol* start = main->add_symbol("start", loc, 0x8000,
                                     SymbolType::AddressRelative);
    Opcode* start_opcode = code->last_opcode();
    start->set_opcode(start_opcode);
    start->set_scope(SymbolScope::Public);

    code->add_opcode(Opcode({ 0x00 }, loc));

    // LIB module with DATA section
    Module* lib = unit.add_module("LIB");
    Section* data = lib->add_section("DATA");
    data->set_base_address(0x9000);

    loc.set_line_num(20);
    Symbol* buffer = lib->add_symbol("buffer", loc, 0x9000,
                                     SymbolType::AddressRelative);
    Opcode* buffer_opcode = data->last_opcode();
    buffer->set_opcode(buffer_opcode);
    buffer->set_scope(SymbolScope::Public);

    data->add_opcode(Opcode({ 0x42 }, loc));

    // Verify structure
    REQUIRE(unit.modules().size() == 3);  // Empty + MAIN + LIB
    REQUIRE(main->sections().size() == 2);  // Default + CODE
    REQUIRE(lib->sections().size() == 2);   // Default + DATA

    REQUIRE(start->opcode() == start_opcode);
    REQUIRE(buffer->opcode() == buffer_opcode);
}

TEST_CASE("CompilationUnit: modules accessor provides const reference",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    unit.add_module("MAIN");

    // Access via const reference - accessor returns const
    const auto& modules = unit.modules();
    REQUIRE(modules.size() == 2);
    REQUIRE(modules[0]->name() == "");
    REQUIRE(modules[1]->name() == "MAIN");
}

TEST_CASE("Integration: parse and check constant expression",
          "[model][integration][constant]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Define constants
    module.add_symbol("MAX", loc, 255, SymbolType::Constant);
    module.add_symbol("MIN", loc, 0, SymbolType::Constant);

    // Parse: MAX + MIN * 2
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "MAX", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Identifier, "MIN", false));
    line.tokens().push_back(Token(TokenType::Multiply, "*", false));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(expr.is_constant());

    int result = expr.evaluate();
    REQUIRE(result == 255);
}

TEST_CASE("Integration: parse and check non-constant expression",
          "[model][integration][constant]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Define constant and label
    module.add_symbol("OFFSET", loc, 10, SymbolType::Constant);

    Opcode* opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* label = module.add_symbol("start", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(opcode);

    // Parse: start + OFFSET (not constant because of label)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "start", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Identifier, "OFFSET", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE_FALSE(expr.is_constant());  // Contains label
}

//-----------------------------------------------------------------------------
// Library tests
//-----------------------------------------------------------------------------

TEST_CASE("Library: constructor with filename", "[model][library]") {
    Library lib("mylib.lib");

    REQUIRE(lib.filename() == "mylib.lib");
    REQUIRE(lib.modules().size() == 0);
    REQUIRE(lib.public_symbols().size() == 0);
    REQUIRE(lib.module_count() == 0);
    REQUIRE(lib.public_symbol_count() == 0);
}

TEST_CASE("Library: add module", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Module* mod_ptr = module.get();

    Module* result = lib.add_module(std::move(module));

    REQUIRE(result == mod_ptr);
    REQUIRE(lib.modules().size() == 1);
    REQUIRE(lib.module_count() == 1);
    REQUIRE(lib.modules()[0].get() == mod_ptr);
}

TEST_CASE("Library: add module with public symbols", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);

    // Add public symbol
    Symbol* sym = module->add_symbol("exported_func", loc, 0x8000,
                                     SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);

    lib.add_module(std::move(module));

    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.has_public_symbol("exported_func"));

    Module* found = lib.find_public_symbol("exported_func");
    REQUIRE(found != nullptr);
    REQUIRE(found->name() == "MOD1");
}

TEST_CASE("Library: add module with local symbols", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);

    // Add local symbol (should not be indexed)
    module->add_symbol("local_var", loc, 42, SymbolType::Constant);

    lib.add_module(std::move(module));

    REQUIRE(lib.public_symbol_count() == 0);
    REQUIRE_FALSE(lib.has_public_symbol("local_var"));
    REQUIRE(lib.find_public_symbol("local_var") == nullptr);
}

TEST_CASE("Library: multiple modules with public symbols", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    // Module 1 with public symbol
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("func1", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    Module* mod1_ptr = lib.add_module(std::move(mod1));

    // Module 2 with different public symbol
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("func2", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    Module* mod2_ptr = lib.add_module(std::move(mod2));

    REQUIRE(lib.module_count() == 2);
    REQUIRE(lib.public_symbol_count() == 2);

    REQUIRE(lib.find_public_symbol("func1") == mod1_ptr);
    REQUIRE(lib.find_public_symbol("func2") == mod2_ptr);
}

TEST_CASE("Library: duplicate public symbol keeps first", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    // Module 1 with public symbol
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("duplicate", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    Module* mod1_ptr = lib.add_module(std::move(mod1));

    // Module 2 with same public symbol
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("duplicate", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod2));

    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.find_public_symbol("duplicate") == mod1_ptr);  // First wins
}

TEST_CASE("Library: find module by name", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Module* mod1_ptr = lib.add_module(std::move(mod1));

    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Module* mod2_ptr = lib.add_module(std::move(mod2));

    REQUIRE(lib.find_module("MOD1") == mod1_ptr);
    REQUIRE(lib.find_module("MOD2") == mod2_ptr);
    REQUIRE(lib.find_module("NONEXISTENT") == nullptr);
}

TEST_CASE("Library: clear modules", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    lib.add_module(std::move(module));

    REQUIRE(lib.module_count() == 1);
    REQUIRE(lib.public_symbol_count() == 1);

    lib.clear_modules();

    REQUIRE(lib.module_count() == 0);
    REQUIRE(lib.public_symbol_count() == 0);
    REQUIRE(lib.modules().empty());
    REQUIRE(lib.public_symbols().empty());
}

TEST_CASE("Library: rebuild public symbol index", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    Module* mod_ptr = lib.add_module(std::move(module));

    REQUIRE(lib.public_symbol_count() == 0);

    // Make symbol public after adding to library
    sym->set_scope(SymbolScope::Public);

    // Rebuild index
    lib.rebuild_public_symbol_index();

    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.find_public_symbol("func") == mod_ptr);
}

TEST_CASE("Library: const accessors", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    Module* mod_ptr = lib.add_module(std::move(module));

    const Library& const_lib = lib;

    REQUIRE(const_lib.filename() == "test.lib");
    REQUIRE(const_lib.module_count() == 1);
    REQUIRE(const_lib.public_symbol_count() == 1);
    REQUIRE(const_lib.has_public_symbol("func"));

    const Module* found = const_lib.find_public_symbol("func");
    REQUIRE(found == mod_ptr);
}

TEST_CASE("Library: iteration over modules", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    lib.add_module(std::make_unique<Module>("MOD1", loc));
    lib.add_module(std::make_unique<Module>("MOD2", loc));
    lib.add_module(std::make_unique<Module>("MOD3", loc));

    std::vector<std::string> names;
    for (const auto& module : lib.modules()) {
        names.push_back(module->name());
    }

    REQUIRE(names.size() == 3);
    REQUIRE(names[0] == "MOD1");
    REQUIRE(names[1] == "MOD2");
    REQUIRE(names[2] == "MOD3");
}

TEST_CASE("Library: public symbol index iteration", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("func1", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod1));

    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("func2", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod2));

    std::set<std::string> symbol_names;
    for (const auto& [name, module] : lib.public_symbols()) {
        symbol_names.insert(name);
    }

    REQUIRE(symbol_names.size() == 2);
    REQUIRE(symbol_names.count("func1") == 1);
    REQUIRE(symbol_names.count("func2") == 1);
}

//-----------------------------------------------------------------------------
// Integration tests: Library with complete modules
//-----------------------------------------------------------------------------

TEST_CASE("Integration: library with code modules",
          "[model][integration][library]") {
    Library lib("math.lib");
    Location loc("math.asm", 1);

    // Create module with function
    auto module = std::make_unique<Module>("MATH", loc);

    // Add CODE section
    Section* code = module->add_section("CODE");
    code->set_base_address(0x8000);

    // Add public function
    loc.set_line_num(10);
    Opcode* func_opcode = code->add_opcode(Opcode({ 0xC9 }, loc));  // RET
    Symbol* func = module->add_symbol("add", loc);
    func->set_type(SymbolType::AddressRelative);
    func->set_opcode(func_opcode);
    func->set_scope(SymbolScope::Public);

    lib.add_module(std::move(module));

    // Verify library structure
    REQUIRE(lib.module_count() == 1);
    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.has_public_symbol("add"));

    Module* found_module = lib.find_public_symbol("add");
    REQUIRE(found_module != nullptr);
    REQUIRE(found_module->name() == "MATH");

    const Symbol* found_symbol = found_module->find_symbol("add");
    REQUIRE(found_symbol != nullptr);
    REQUIRE(found_symbol->is_public());
}

TEST_CASE("Integration: library linking scenario",
          "[model][integration][library]") {
    // Simulate linking scenario:
    // Main program calls library function

    Library lib("stdio.lib");
    Location loc("stdio.asm", 1);

    // Library module with print function
    auto lib_module = std::make_unique<Module>("STDIO", loc);
    Section* lib_code = lib_module->add_section("CODE");
    lib_code->set_base_address(0xC000);

    loc.set_line_num(10);
    Opcode* print_opcode = lib_code->add_opcode(Opcode({ 0xC9 }, loc));
    Symbol* print_func = lib_module->add_symbol("print", loc);
    print_func->set_type(SymbolType::AddressRelative);
    print_func->set_opcode(print_opcode);
    print_func->set_scope(SymbolScope::Public);

    lib.add_module(std::move(lib_module));

    // Main program that calls print
    CompilationUnit main_unit("main.asm", loc);
    Module* main_module = main_unit.current_module();
    Section* main_code = main_module->add_section("CODE");
    main_code->set_base_address(0x8000);

    // Declare external reference to print
    loc.set_line_num(20);
    Symbol* print_ref = main_module->declare_symbol("print", loc,
                        SymbolScope::Extern);
    REQUIRE(print_ref->is_extern());

    // Add CALL instruction with patch
    loc.set_line_num(21);
    Opcode* call_opcode = main_code->add_opcode(Opcode({ 0xCD, 0x00, 0x00 }, loc));
    Expression call_target(make_symbol(print_ref), loc);
    Patch call_patch(1, PatchRange::Word, call_target);
    call_opcode->add_patch(call_patch);

    // Link step: resolve external reference
    REQUIRE(lib.has_public_symbol("print"));
    Module* defining_module = lib.find_public_symbol("print");
    REQUIRE(defining_module != nullptr);

    const Symbol* print_def = defining_module->find_symbol("print");
    REQUIRE(print_def != nullptr);
    REQUIRE(print_def->is_public());

    // In real linker, would copy print_def's value to print_ref
    // For this test, just verify structure is correct
    REQUIRE(call_opcode->has_patches());
    REQUIRE(call_opcode->patches()[0].range() == PatchRange::Word);
}

TEST_CASE("Integration: library search order",
          "[model][integration][library]") {
    // Multiple libraries with duplicate symbols - first library wins

    Location loc("test.asm", 1);

    Library lib1("lib1.lib");
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("common_func", loc, 0x8000,
                                    SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    lib1.add_module(std::move(mod1));

    Library lib2("lib2.lib");
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("common_func", loc, 0x9000,
                                    SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib2.add_module(std::move(mod2));

    // In linking, search order matters
    std::vector<Library*> search_path = { &lib1, &lib2 };

    Module* found = nullptr;
    for (Library* lib : search_path) {
        found = lib->find_public_symbol("common_func");
        if (found) {
            break;
        }
    }

    REQUIRE(found != nullptr);
    REQUIRE(found->name() == "MOD1");  // First library wins
}

//-----------------------------------------------------------------------------
// Linker tests
//-----------------------------------------------------------------------------

TEST_CASE("Linker: constructor creates empty state", "[model][linker]") {
    Linker linker;

    REQUIRE(linker.module_count() == 0);
    REQUIRE(linker.public_symbol_count() == 0);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(linker.has_unresolved_symbols());
    REQUIRE(linker.modules().empty());
    REQUIRE(linker.public_symbols().empty());
    REQUIRE(linker.unresolved_externs().empty());
    REQUIRE(linker.libraries().empty());
}

TEST_CASE("Linker: add module with public symbols", "[model][linker]") {
    Linker linker;
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MAIN", loc);
    Symbol* sym = module->add_symbol("main", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);

    Module* module_ptr = linker.add_module(std::move(module));

    REQUIRE(module_ptr != nullptr);
    REQUIRE(linker.module_count() == 1);
    REQUIRE(linker.public_symbol_count() == 1);
    REQUIRE(linker.public_symbols().count("main") == 1);
    REQUIRE(linker.public_symbols().at("main") == module_ptr);
}

TEST_CASE("Linker: add module with extern symbols", "[model][linker]") {
    Linker linker;
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MAIN", loc);
    module->declare_symbol("printf", loc, SymbolScope::Extern);

    linker.add_module(std::move(module));

    REQUIRE(linker.module_count() == 1);
    REQUIRE(linker.unresolved_symbol_count() == 1);
    REQUIRE(linker.has_unresolved_symbols());
    REQUIRE(linker.unresolved_externs().count("printf") == 1);
}

TEST_CASE("Linker: extern resolved by later public", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Module 1: uses external symbol
    auto mod1 = std::make_unique<Module>("MAIN", loc);
    mod1->declare_symbol("helper", loc, SymbolScope::Extern);
    linker.add_module(std::move(mod1));

    REQUIRE(linker.unresolved_symbol_count() == 1);

    // Module 2: defines the symbol
    auto mod2 = std::make_unique<Module>("UTIL", loc);
    Symbol* sym = mod2->add_symbol("helper", loc, 0x9000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod2));

    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(linker.has_unresolved_symbols());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Linker: public resolves existing extern", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Module 1: defines public symbol
    auto mod1 = std::make_unique<Module>("LIB", loc);
    Symbol* sym = mod1->add_symbol("api_func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod1));

    REQUIRE(linker.public_symbol_count() == 1);

    // Module 2: uses the symbol (should not be unresolved)
    auto mod2 = std::make_unique<Module>("MAIN", loc);
    mod2->declare_symbol("api_func", loc, SymbolScope::Extern);
    linker.add_module(std::move(mod2));

    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Linker: duplicate public symbols error", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc1("mod1.asm", 10);
    Location loc2("mod2.asm", 20);

    // Module 1: defines public symbol
    auto mod1 = std::make_unique<Module>("MOD1", loc1);
    Symbol* sym1 = mod1->add_symbol("duplicate", loc1, 0x8000,
                                    SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod1));

    REQUIRE_FALSE(g_errors.has_errors());

    // Module 2: defines same public symbol (error)
    auto mod2 = std::make_unique<Module>("MOD2", loc2);
    Symbol* sym2 = mod2->add_symbol("duplicate", loc2, 0x9000,
                                    SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod2));

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Duplicate public symbol") != std::string::npos);
    REQUIRE(msg.find("duplicate") != std::string::npos);
}

TEST_CASE("Linker: add library", "[model][linker]") {
    Linker linker;
    Library lib("test.lib");

    linker.add_library(&lib);

    REQUIRE(linker.libraries().size() == 1);
    REQUIRE(linker.libraries()[0] == &lib);
}

TEST_CASE("Linker: link_libraries resolves symbols", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Create library with public symbol
    Library lib("stdio.lib");
    auto lib_module = std::make_unique<Module>("STDIO", loc);
    Symbol* lib_sym = lib_module->add_symbol("printf", loc, 0xC000,
                      SymbolType::Constant);
    lib_sym->set_scope(SymbolScope::Public);
    lib.add_module(std::move(lib_module));

    linker.add_library(&lib);

    // Add main module with extern reference
    auto main_module = std::make_unique<Module>("MAIN", loc);
    main_module->declare_symbol("printf", loc, SymbolScope::Extern);
    linker.add_module(std::move(main_module));

    REQUIRE(linker.unresolved_symbol_count() == 1);

    // Link libraries
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Linker: link_libraries reports unresolved", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 10);

    // Add module with unresolved extern
    auto module = std::make_unique<Module>("MAIN", loc);
    module->declare_symbol("undefined", loc, SymbolScope::Extern);
    linker.add_module(std::move(module));

    REQUIRE(linker.unresolved_symbol_count() == 1);

    // Link libraries (no libraries added, so should fail)
    bool success = linker.link_libraries();

    REQUIRE_FALSE(success);
    REQUIRE(linker.unresolved_symbol_count() == 1);
    REQUIRE(g_errors.has_errors());

    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:10:") != std::string::npos);
    REQUIRE(msg.find("Unresolved external symbol") != std::string::npos);
    REQUIRE(msg.find("undefined") != std::string::npos);
}

TEST_CASE("Linker: library search order", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Library 1 with symbol
    Library lib1("lib1.lib");
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("common", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    lib1.add_module(std::move(mod1));

    // Library 2 with same symbol
    Library lib2("lib2.lib");
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("common", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib2.add_module(std::move(mod2));

    // Add libraries in order
    linker.add_library(&lib1);
    linker.add_library(&lib2);

    // Add module with extern
    auto main_module = std::make_unique<Module>("MAIN", loc);
    main_module->declare_symbol("common", loc, SymbolScope::Extern);
    linker.add_module(std::move(main_module));

    // Link - should resolve from first library
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE_FALSE(g_errors.has_errors());
    // In full implementation, would verify MOD1 was pulled in, not MOD2
}

TEST_CASE("Linker: clear state", "[model][linker]") {
    Linker linker;
    Location loc("test.asm", 1);
    Library lib("test.lib");

    // Add some state
    auto module = std::make_unique<Module>("MAIN", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    linker.add_module(std::move(module));
    linker.add_library(&lib);

    REQUIRE(linker.module_count() > 0);
    REQUIRE(linker.public_symbol_count() > 0);

    // Clear
    linker.clear();

    REQUIRE(linker.module_count() == 0);
    REQUIRE(linker.public_symbol_count() == 0);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE(linker.modules().empty());
    REQUIRE(linker.public_symbols().empty());
    REQUIRE(linker.unresolved_externs().empty());
    REQUIRE(linker.libraries().empty());
}

TEST_CASE("Linker: multiple unresolved locations tracked", "[model][linker]") {
    Linker linker;
    Location loc1("main.asm", 10);
    Location loc2("main.asm", 20);
    Location loc3("util.asm", 15);

    // Module with multiple references to same extern
    auto mod1 = std::make_unique<Module>("MAIN", loc1);
    mod1->declare_symbol("helper", loc1, SymbolScope::Extern);
    mod1->declare_symbol("helper", loc2, SymbolScope::Extern);
    linker.add_module(std::move(mod1));

    auto mod2 = std::make_unique<Module>("UTIL", loc3);
    mod2->declare_symbol("helper", loc3, SymbolScope::Extern);
    linker.add_module(std::move(mod2));

    // Should track all locations
    REQUIRE(linker.unresolved_symbol_count() == 1);
    const auto& externs = linker.unresolved_externs();
    REQUIRE(externs.at("helper").size() == 3);
}

//-----------------------------------------------------------------------------
// Integration tests: Complete linking workflow
//-----------------------------------------------------------------------------

TEST_CASE("Integration: simple program linking",
          "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Main module with entry point
    auto main_mod = std::make_unique<Module>("MAIN", loc);
    Section* main_code = main_mod->add_section("CODE");
    main_code->set_base_address(0x8000);

    Symbol* start = main_mod->add_symbol("_start", loc, 0x8000,
                                         SymbolType::Constant);
    start->set_scope(SymbolScope::Public);

    /*Symbol* helper_ref =*/ main_mod->declare_symbol("helper", loc,
            SymbolScope::Extern);

    linker.add_module(std::move(main_mod));

    // Utility module with helper function
    auto util_mod = std::make_unique<Module>("UTIL", loc);
    Symbol* helper = util_mod->add_symbol("helper", loc, 0x9000,
                                          SymbolType::Constant);
    helper->set_scope(SymbolScope::Public);

    linker.add_module(std::move(util_mod));

    // Should be fully resolved
    REQUIRE(linker.module_count() == 2);
    REQUIRE(linker.public_symbol_count() == 2);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(linker.has_unresolved_symbols());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: linking with library", "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("main.asm", 1);

    // Create standard library
    Library stdlib("stdlib.lib");

    auto print_mod = std::make_unique<Module>("PRINT", loc);
    Symbol* print = print_mod->add_symbol("print", loc, 0xC000,
                                          SymbolType::Constant);
    print->set_scope(SymbolScope::Public);
    stdlib.add_module(std::move(print_mod));

    auto math_mod = std::make_unique<Module>("MATH", loc);
    Symbol* multiply = math_mod->add_symbol("multiply", loc, 0xC100,
                                            SymbolType::Constant);
    multiply->set_scope(SymbolScope::Public);
    stdlib.add_module(std::move(math_mod));

    linker.add_library(&stdlib);

    // Main program using library functions
    auto main = std::make_unique<Module>("MAIN", loc);
    Symbol* start = main->add_symbol("_start", loc, 0x8000, SymbolType::Constant);
    start->set_scope(SymbolScope::Public);

    main->declare_symbol("print", loc, SymbolScope::Extern);
    main->declare_symbol("multiply", loc, SymbolScope::Extern);

    linker.add_module(std::move(main));

    REQUIRE(linker.unresolved_symbol_count() == 2);

    // Link
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: complex linking scenario",
          "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Library 1: stdio
    Library stdio("stdio.lib");
    auto printf_mod = std::make_unique<Module>("PRINTF", loc);
    Symbol* printf_sym = printf_mod->add_symbol("printf", loc, 0xC000,
                         SymbolType::Constant);
    printf_sym->set_scope(SymbolScope::Public);
    stdio.add_module(std::move(printf_mod));

    // Library 2: math
    Library math("math.lib");
    auto sqrt_mod = std::make_unique<Module>("SQRT", loc);
    Symbol* sqrt_sym = sqrt_mod->add_symbol("sqrt", loc, 0xD000,
                                            SymbolType::Constant);
    sqrt_sym->set_scope(SymbolScope::Public);
    math.add_module(std::move(sqrt_mod));

    linker.add_library(&stdio);
    linker.add_library(&math);

    // Module 1: main
    auto main = std::make_unique<Module>("MAIN", loc);
    Symbol* start = main->add_symbol("_start", loc, 0x8000, SymbolType::Constant);
    start->set_scope(SymbolScope::Public);
    main->declare_symbol("printf", loc, SymbolScope::Extern);
    main->declare_symbol("calc", loc, SymbolScope::Extern);
    linker.add_module(std::move(main));

    // Module 2: utility (provides calc, uses sqrt)
    auto util = std::make_unique<Module>("UTIL", loc);
    Symbol* calc = util->add_symbol("calc", loc, 0x9000, SymbolType::Constant);
    calc->set_scope(SymbolScope::Public);
    util->declare_symbol("sqrt", loc, SymbolScope::Extern);
    linker.add_module(std::move(util));

    // At this point: printf and sqrt are unresolved
    REQUIRE(linker.unresolved_symbol_count() == 2);

    // Link
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE(linker.public_symbol_count() ==
            4);  // _start, calc, printf, sqrt (conceptually)
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: partial linking failure",
          "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 10);

    // Library with one function
    Library lib("partial.lib");
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* func1 = mod1->add_symbol("func1", loc, 0xC000, SymbolType::Constant);
    func1->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod1));

    linker.add_library(&lib);

    // Main module with two extern references
    auto main = std::make_unique<Module>("MAIN", loc);
    main->declare_symbol("func1", loc, SymbolScope::Extern);
    main->declare_symbol("func2", loc, SymbolScope::Extern);  // Not in library
    linker.add_module(std::move(main));

    REQUIRE(linker.unresolved_symbol_count() == 2);

    // Link - should partially resolve
    bool success = linker.link_libraries();

    REQUIRE_FALSE(success);
    REQUIRE(linker.unresolved_symbol_count() == 1);
    REQUIRE(linker.unresolved_externs().count("func2") == 1);
    REQUIRE(g_errors.has_errors());
}

//-----------------------------------------------------------------------------
// Patch resolve() tests
//-----------------------------------------------------------------------------

TEST_CASE("Patch: resolve ByteUnsigned in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x42), loc);
    Patch patch(0, PatchRange::ByteUnsigned, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));

    REQUIRE(bytes[0] == 0x42);
    REQUIRE(bytes[1] == 0x00);
    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve ByteUnsigned out of range warns", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Patch patch(0, PatchRange::ByteUnsigned, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));

    REQUIRE(bytes[0] == 0x34);  // Truncated
    REQUIRE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve ByteUnsigned negative value warns",
          "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(-1), loc);
    Patch patch(0, PatchRange::ByteUnsigned, expr);

    std::vector<uint8_t> bytes = { 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));

    REQUIRE(bytes[0] == 0xFF);  // -1 as unsigned byte
    REQUIRE_FALSE(
        g_errors.has_warnings());  // -1 is in range for unsigned byte (treated as 255)
}

TEST_CASE("Patch: resolve ByteSigned in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(127), loc);
        Patch patch(0, PatchRange::ByteSigned, expr);

        std::vector<uint8_t> bytes = { 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 127);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    {
        Expression expr(make_integer(-128), loc);
        Patch patch(0, PatchRange::ByteSigned, expr);

        std::vector<uint8_t> bytes = { 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x80);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve ByteSigned out of range warns", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(128), loc);
        Patch patch(0, PatchRange::ByteSigned, expr);

        std::vector<uint8_t> bytes = { 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x80);
        REQUIRE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(-129), loc);
        Patch patch(0, PatchRange::ByteSigned, expr);

        std::vector<uint8_t> bytes = { 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x7F);  // Truncated
        REQUIRE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve HighOffset in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(0x00), loc);
        Patch patch(0, PatchRange::HighOffset, expr);

        std::vector<uint8_t> bytes = { 0xFF };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    {
        Expression expr(make_integer(-1), loc);  // 0xFFFF
        Patch patch(0, PatchRange::HighOffset, expr);

        std::vector<uint8_t> bytes = { 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve HighOffset out of range warns", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x0100), loc);
    Patch patch(0, PatchRange::HighOffset, expr);

    std::vector<uint8_t> bytes = { 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));
    REQUIRE(bytes[0] == 0x00);  // Low byte
    REQUIRE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve ByteToWordUnsigned", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(0x42), loc);
        Patch patch(0, PatchRange::ByteToWordUnsigned, expr);

        std::vector<uint8_t> bytes = { 0xFF, 0xFF };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x42);
        REQUIRE(bytes[1] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(0x100), loc);
        Patch patch(0, PatchRange::ByteToWordUnsigned, expr);

        std::vector<uint8_t> bytes = { 0x00, 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x00);
        REQUIRE(bytes[1] == 0x00);
        REQUIRE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve ByteToWordSigned", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(127), loc);
        Patch patch(0, PatchRange::ByteToWordSigned, expr);

        std::vector<uint8_t> bytes = { 0x00, 0xFF };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 127);
        REQUIRE(bytes[1] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(-1), loc);
        Patch patch(0, PatchRange::ByteToWordSigned, expr);

        std::vector<uint8_t> bytes = { 0x00, 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0xFF);
        REQUIRE(bytes[1] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress3;

    {
        Expression expr(make_integer(-128), loc);
        Patch patch(0, PatchRange::ByteToWordSigned, expr);

        std::vector<uint8_t> bytes = { 0x00, 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0x80);
        REQUIRE(bytes[1] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve ByteToPtr24Unsigned", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x42), loc);
    Patch patch(0, PatchRange::ByteToPtr24Unsigned, expr);

    std::vector<uint8_t> bytes = { 0xFF, 0xFF, 0xFF };
    REQUIRE(patch.resolve(bytes, 0, 0));
    REQUIRE(bytes[0] == 0x42);
    REQUIRE(bytes[1] == 0x00);
    REQUIRE(bytes[2] == 0x00);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve ByteToPtr24Signed", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(127), loc);
        Patch patch(0, PatchRange::ByteToPtr24Signed, expr);

        std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 127);
        REQUIRE(bytes[1] == 0x00);
        REQUIRE(bytes[2] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(-1), loc);
        Patch patch(0, PatchRange::ByteToPtr24Signed, expr);

        std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00 };
        REQUIRE(patch.resolve(bytes, 0, 0));
        REQUIRE(bytes[0] == 0xFF);
        REQUIRE(bytes[1] == 0xFF);
        REQUIRE(bytes[2] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve Ptr24", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x123456), loc);
    Patch patch(0, PatchRange::Ptr24, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));
    REQUIRE(bytes[0] == 0x56);
    REQUIRE(bytes[1] == 0x34);
    REQUIRE(bytes[2] == 0x12);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve Word little-endian", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Patch patch(0, PatchRange::Word, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));
    REQUIRE(bytes[0] == 0x34);
    REQUIRE(bytes[1] == 0x12);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve WordBigEndian", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Patch patch(0, PatchRange::WordBigEndian, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));
    REQUIRE(bytes[0] == 0x12);
    REQUIRE(bytes[1] == 0x34);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve Dword little-endian", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x12345678), loc);
    Patch patch(0, PatchRange::Dword, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));
    REQUIRE(bytes[0] == 0x78);
    REQUIRE(bytes[1] == 0x56);
    REQUIRE(bytes[2] == 0x34);
    REQUIRE(bytes[3] == 0x12);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve JrOffset in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    // JR forward: target = 0x8020, current = 0x8000, opcode_size = 2
    // offset = 0x8020 - (0x8000 + 2) = 30
    Expression expr(make_integer(0x8020), loc);
    Patch patch(1, PatchRange::JrOffset, expr);

    std::vector<uint8_t> bytes = { 0x18, 0x00 };  // JR offset
    REQUIRE(patch.resolve(bytes, 0x8000, 2));
    REQUIRE(bytes[0] == 0x18);
    REQUIRE(bytes[1] == 30);
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve JrOffset backward", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    // JR backward: target = 0x8000, current = 0x8020, opcode_size = 2
    // offset = 0x8000 - (0x8020 + 2) = -34
    Expression expr(make_integer(0x8000), loc);
    Patch patch(1, PatchRange::JrOffset, expr);

    std::vector<uint8_t> bytes = { 0x18, 0x00 };
    REQUIRE(patch.resolve(bytes, 0x8020, 2));
    REQUIRE(bytes[0] == 0x18);
    REQUIRE(bytes[1] == static_cast<uint8_t>(-34));
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve JrOffset out of range errors", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    // JR too far forward: offset = 200 (out of range)
    Expression expr(make_integer(0x8100), loc);
    Patch patch(1, PatchRange::JrOffset, expr);

    std::vector<uint8_t> bytes = { 0x18, 0x00 };
    REQUIRE(patch.resolve(bytes, 0x8000, 2));
    REQUIRE(g_errors.has_errors());  // Error, not warning
}

TEST_CASE("Patch: resolve JreOffset (extended) in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    // JRE forward: target = 0x9000, current = 0x8000, opcode_size = 3
    // offset = 0x9000 - (0x8000 + 3) = 4093
    Expression expr(make_integer(0x9000), loc);
    Patch patch(1, PatchRange::JreOffset, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0x8000, 3));
    REQUIRE(bytes[1] == static_cast<uint8_t>(4093 & 0xFF));
    REQUIRE(bytes[2] == static_cast<uint8_t>(4093 >> 8));
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve JreOffset backward", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    // JRE backward: target = 0x8000, current = 0x9000, opcode_size = 3
    // offset = 0x8000 - (0x9000 + 3) = -4099
    Expression expr(make_integer(0x8000), loc);
    Patch patch(1, PatchRange::JreOffset, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0x9000, 3));

    int16_t expected = -4099;
    REQUIRE(bytes[1] == static_cast<uint8_t>(expected & 0xFF));
    REQUIRE(bytes[2] == static_cast<uint8_t>((expected >> 8) & 0xFF));
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve JreOffset out of range errors", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    // JRE too far: offset = 40000 (out of range for signed 16-bit)
    Expression expr(make_integer(0x18000), loc);
    Patch patch(1, PatchRange::JreOffset, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0x8000, 3));
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve with offset into byte vector", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Patch patch(2, PatchRange::Word, expr);  // offset = 2

    std::vector<uint8_t> bytes = { 0x00, 0x00, 0xFF, 0xFF };
    REQUIRE(patch.resolve(bytes, 0, 0));

    REQUIRE(bytes[0] == 0x00);  // Unchanged
    REQUIRE(bytes[1] == 0x00);  // Unchanged
    REQUIRE(bytes[2] == 0x34);  // Patched
    REQUIRE(bytes[3] == 0x12);  // Patched
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve Assignment does nothing", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Patch patch(0, PatchRange::Assignment, expr);

    std::vector<uint8_t> bytes = { 0xFF, 0xFF };
    REQUIRE(patch.resolve(bytes, 0, 0));

    REQUIRE(bytes[0] == 0xFF);  // Unchanged
    REQUIRE(bytes[1] == 0xFF);  // Unchanged
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve bounds checking", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Patch patch(10, PatchRange::Word, expr);  // offset beyond vector size

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));

    // Bytes unchanged - patch was out of bounds
    REQUIRE(bytes[0] == 0x00);
    REQUIRE(bytes[1] == 0x00);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve with expression evaluation error", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    // Create undefined symbol
    Symbol* undef = module.add_symbol("undefined", loc);

    Expression expr(make_symbol(undef), loc);
    Patch patch(0, PatchRange::Word, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE_FALSE(patch.resolve(bytes, 0, 0));  // Should fail

    // Bytes unchanged
    REQUIRE(bytes[0] == 0x00);
    REQUIRE(bytes[1] == 0x00);
}

//-----------------------------------------------------------------------------
// Integration tests: Patch with complex expressions
//-----------------------------------------------------------------------------

TEST_CASE("Integration: patch with computed value",
          "[model][integration][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    // Create constants
    module.add_symbol("BASE", loc, 0x8000, SymbolType::Constant);
    module.add_symbol("OFFSET", loc, 0x100, SymbolType::Constant);

    // Create expression: BASE + OFFSET
    Expression expr(make_binary_op(
                        ExprOp::Add,
                        make_symbol(module.find_symbol("BASE")),
                        make_symbol(module.find_symbol("OFFSET"))
                    ), loc);

    Patch patch(0, PatchRange::Word, expr);

    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    REQUIRE(patch.resolve(bytes, 0, 0));

    REQUIRE(bytes[0] == 0x00);
    REQUIRE(bytes[1] == 0x81);  // 0x8100 little-endian
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Integration: patch all range types in sequence",
          "[model][integration][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    std::vector<uint8_t> bytes(20, 0x00);
    int offset = 0;

    // ByteUnsigned
    {
        Expression expr(make_integer(0x42), loc);
        Patch patch(offset, PatchRange::ByteUnsigned, expr);
        REQUIRE(patch.resolve(bytes, 0, 0));
        offset += 1;
    }

    // Word
    {
        Expression expr(make_integer(0x1234), loc);
        Patch patch(offset, PatchRange::Word, expr);
        REQUIRE(patch.resolve(bytes, 0, 0));
        offset += 2;
    }

    // Ptr24
    {
        Expression expr(make_integer(0x567890), loc);
        Patch patch(offset, PatchRange::Ptr24, expr);
        REQUIRE(patch.resolve(bytes, 0, 0));
        offset += 3;
    }

    // Dword
    {
        Expression expr(make_integer(0x12345678), loc);
        Patch patch(offset, PatchRange::Dword, expr);
        REQUIRE(patch.resolve(bytes, 0, 0));
        offset += 4;
    }

    // Verify all patches
    REQUIRE(bytes[0] == 0x42);              // ByteUnsigned
    REQUIRE(bytes[1] == 0x34);              // Word low
    REQUIRE(bytes[2] == 0x12);              // Word high
    REQUIRE(bytes[3] == 0x90);              // Ptr24 byte 0
    REQUIRE(bytes[4] == 0x78);              // Ptr24 byte 1
    REQUIRE(bytes[5] == 0x56);              // Ptr24 byte 2
    REQUIRE(bytes[6] == 0x78);              // Dword byte 0
    REQUIRE(bytes[7] == 0x56);              // Dword byte 1
    REQUIRE(bytes[8] == 0x34);              // Dword byte 2
    REQUIRE(bytes[9] == 0x12);              // Dword byte 3

    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: patch with relative offset calculation",
          "[model][integration][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create label at 0x8000
    Opcode* target_opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    section->compute_opcodes_addresses();

    Symbol* label = module.add_symbol("loop", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(target_opcode);
    label->set_offset(0);

    // JR to loop from address 0x8020
    Expression expr(make_symbol(label), loc);
    Patch patch(1, PatchRange::JrOffset, expr);

    std::vector<uint8_t> bytes = { 0x18, 0x00 };
    REQUIRE(patch.resolve(bytes, 0x8020, 2));

    // offset = 0x8000 - (0x8020 + 2) = -34 = 0xDE
    REQUIRE(bytes[1] == 0xDE);
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}
