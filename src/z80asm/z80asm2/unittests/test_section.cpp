//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../expr.h"
#include "../location.h"
#include "../module.h"
#include "../section.h"
#include "../symbols.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Patch tests
//-----------------------------------------------------------------------------

TEST_CASE("Patch: default constructor", "[model][patch]") {
    Patch patch(nullptr);
    REQUIRE(patch.offset() == 0);
    REQUIRE(patch.range() == PatchRange::Undefined);
}

TEST_CASE("Patch: constructor with parameters", "[model][patch]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Symbol* target_sym = module.add_symbol("target", loc, 0x1234,
                                           SymbolType::Constant);

    Expression expr(make_symbol(target_sym), loc);
    Section section("CODE");
    Opcode opcode(&section, loc);
    Patch patch(&opcode, 2, PatchRange::Word, expr);

    REQUIRE(patch.offset() == 2);
    REQUIRE(patch.range() == PatchRange::Word);
    REQUIRE(patch.location().filename() == "test.asm");
    REQUIRE(patch.location().line_num() == 10);
}

TEST_CASE("Patch: JR offset range", "[model][patch]") {
    Location loc("test.asm", 20);
    Expression expr(make_integer(10), loc);
    Section section("CODE");
    Opcode opcode(&section, loc);
    Patch patch(&opcode, 1, PatchRange::JrOffset, expr);

    REQUIRE(patch.range() == PatchRange::JrOffset);

    REQUIRE(patch.expression().evaluate() == 10);
}

TEST_CASE("Patch: byte unsigned range", "[model][patch]") {
    Location loc("test.asm", 30);
    Expression expr(make_integer(0xFF), loc);
    Section section("CODE");
    Opcode opcode(&section, loc);
    Patch patch(&opcode, 0, PatchRange::ByteUnsigned, expr);

    REQUIRE(patch.range() == PatchRange::ByteUnsigned);

    REQUIRE(patch.expression().evaluate() == 0xFF);
}

TEST_CASE("Patch: word little-endian range", "[model][patch]") {
    Location loc("test.asm", 40);
    Expression expr(make_integer(0x1234), loc);
    Section section("CODE");
    Opcode opcode(&section, loc);
    Patch patch(&opcode, 1, PatchRange::Word, expr);

    REQUIRE(patch.range() == PatchRange::Word);

    REQUIRE(patch.expression().evaluate() == 0x1234);
}

TEST_CASE("Patch: all range types", "[model][patch]") {
    Location loc("test.asm", 50);
    Expression expr(make_integer(0), loc);
    Section section("CODE");
    Opcode opcode(&section, loc);

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
        Patch patch(&opcode, 0, range, expr);
        REQUIRE(patch.range() == range);
    }
}

//-----------------------------------------------------------------------------
// Opcode tests
//-----------------------------------------------------------------------------

TEST_CASE("Opcode: location-only constructor", "[model][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");
    Opcode opcode(&section, loc);

    REQUIRE(opcode.address() == 0);
    REQUIRE(opcode.size() == 0);
    REQUIRE_FALSE(opcode.has_patches());
    REQUIRE(opcode.location().filename() == "test.asm");
    REQUIRE(opcode.location().line_num() == 10);
}

TEST_CASE("Opcode: constructor with bytes", "[model][opcode]") {
    Location loc("test.asm", 20);
    std::vector<uint8_t> bytes = { 0x3E, 0x42 };  // LD A, 42
    Section section("CODE");
    Opcode opcode(&section, bytes, loc);

    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x3E);
    REQUIRE(opcode.bytes()[1] == 0x42);
    REQUIRE(opcode.location().filename() == "test.asm");
    REQUIRE(opcode.location().line_num() == 20);
}

TEST_CASE("Opcode: constructor with address and bytes", "[model][opcode]") {
    Location loc("test.asm", 30);
    std::vector<uint8_t> bytes = { 0xC3, 0x00, 0x80 };  // JP 0x8000
    Section section("CODE");
    Opcode opcode(&section, 0x1000, bytes, loc);

    REQUIRE(opcode.address() == 0x1000);
    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.location().filename() == "test.asm");
    REQUIRE(opcode.location().line_num() == 30);
}

TEST_CASE("Opcode: add patch", "[model][opcode]") {
    Location loc("test.asm", 100);
    Module module("TEST", loc);
    Symbol* target_sym = module.add_symbol("target", loc);

    std::vector<uint8_t> bytes = { 0xC3, 0x00, 0x00 };  // JP address (needs patch)
    Section section("CODE");
    Opcode opcode(&section, bytes, loc);

    Expression expr(make_symbol(target_sym), loc);
    Patch patch(&opcode, 1, PatchRange::Word, expr);

    opcode.add_patch(patch);

    REQUIRE(opcode.has_patches());
    REQUIRE(opcode.patches().size() == 1);
    REQUIRE(opcode.patches()[0].offset() == 1);
    REQUIRE(opcode.patches()[0].range() == PatchRange::Word);
}

TEST_CASE("Opcode: multiple patches", "[model][opcode]") {
    Location loc("test.asm", 110);
    std::vector<uint8_t> bytes = { 0x00, 0x00, 0x00, 0x00 };
    Section section("CODE");
    Opcode opcode(&section, bytes, loc);

    // Add two patches
    Expression expr1(make_integer(0x12), loc);
    Patch patch1(&opcode, 0, PatchRange::ByteUnsigned, expr1);
    opcode.add_patch(patch1);

    Expression expr2(make_integer(0x3456), loc);
    Patch patch2(&opcode, 2, PatchRange::Word, expr2);
    opcode.add_patch(patch2);

    REQUIRE(opcode.patches().size() == 2);
    REQUIRE(opcode.patches()[0].offset() == 0);
    REQUIRE(opcode.patches()[1].offset() == 2);
}

TEST_CASE("Opcode: clear patches", "[model][opcode]") {
    Location loc("test.asm", 120);
    std::vector<uint8_t> bytes = { 0x00, 0x00 };
    Section section("CODE");
    Opcode opcode(&section, bytes, loc);

    Expression expr(make_integer(42), loc);
    Patch patch(&opcode, 0, PatchRange::ByteUnsigned, expr);

    opcode.add_patch(patch);
    REQUIRE(opcode.has_patches());

    opcode.clear_patches();
    REQUIRE_FALSE(opcode.has_patches());
    REQUIRE(opcode.patches().size() == 0);
}

TEST_CASE("Opcode: location is immutable", "[model][opcode]") {
    Location loc("main.asm", 200);
    Section section("CODE");
    Opcode opcode(&section, loc);

    REQUIRE(opcode.location().filename() == "main.asm");
    REQUIRE(opcode.location().line_num() == 200);
}

TEST_CASE("Opcode: clear bytes", "[model][opcode]") {
    Location loc("test.asm", 130);
    std::vector<uint8_t> bytes = { 0x3E, 0x42, 0x00 };
    Section section("CODE");
    Opcode opcode(&section, bytes, loc);

    REQUIRE(opcode.size() == 3);

    opcode.clear_bytes();
    REQUIRE(opcode.size() == 0);
    REQUIRE(opcode.bytes().empty());
}

TEST_CASE("Opcode: add single byte", "[model][opcode]") {
    Location loc("test.asm", 140);
    Section section("CODE");
    Opcode opcode(&section, loc);

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
    Section section("CODE");
    Opcode opcode(&section, loc);
    opcode.add_bytes(0x3E);

    REQUIRE(opcode.size() == 1);
    REQUIRE(opcode.bytes()[0] == 0x3E);
}

TEST_CASE("Opcode: add_bytes with two byte value", "[model][opcode]") {
    Location loc("test.asm", 160);
    Section section("CODE");
    Opcode opcode(&section, loc);
    opcode.add_bytes(0x1234);

    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
}

TEST_CASE("Opcode: add_bytes with three byte value", "[model][opcode]") {
    Location loc("test.asm", 170);
    Section section("CODE");
    Opcode opcode(&section, loc);
    opcode.add_bytes(0xC30000);

    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.bytes()[0] == 0xC3);
    REQUIRE(opcode.bytes()[1] == 0x00);
    REQUIRE(opcode.bytes()[2] == 0x00);
}

TEST_CASE("Opcode: add_bytes with four byte value", "[model][opcode]") {
    Location loc("test.asm", 180);
    Section section("CODE");
    Opcode opcode(&section, loc);
    opcode.add_bytes(0x12345678);

    REQUIRE(opcode.size() == 4);
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
    REQUIRE(opcode.bytes()[2] == 0x56);
    REQUIRE(opcode.bytes()[3] == 0x78);
}

TEST_CASE("Opcode: add_bytes with zero", "[model][opcode]") {
    Location loc("test.asm", 190);
    Section section("CODE");
    Opcode opcode(&section, loc);
    opcode.add_bytes(0);

    REQUIRE(opcode.size() == 1);
    REQUIRE(opcode.bytes()[0] == 0x00);
}

TEST_CASE("Opcode: add_bytes with leading zeros", "[model][opcode]") {
    Location loc("test.asm", 200);
    Section section("CODE");
    Opcode opcode(&section, loc);
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
        Section section("CODE");
        Opcode opcode(&section, loc);
        opcode.add_bytes(test.value);

        REQUIRE(opcode.size() == test.expected.size());
        for (size_t i = 0; i < test.expected.size(); ++i) {
            REQUIRE(opcode.bytes()[i] == test.expected[i]);
        }
    }
}

TEST_CASE("Opcode: build instruction with add_byte", "[model][opcode]") {
    Location loc("test.asm", 220);
    Section section("CODE");
    Opcode opcode(&section, loc);

    // Build: LD A, 42 (0x3E 0x2A)
    opcode.add_byte(0x3E);
    opcode.add_byte(0x2A);

    REQUIRE(opcode.size() == 2);
    REQUIRE(opcode.bytes()[0] == 0x3E);
    REQUIRE(opcode.bytes()[1] == 0x2A);
}

TEST_CASE("Opcode: build instruction with add_bytes", "[model][opcode]") {
    Location loc("test.asm", 230);
    Section section("CODE");
    Opcode opcode(&section, loc);

    // Build: JP 0x8000 (0xC3 0x00 0x80)
    opcode.add_bytes(0xC38000);

    REQUIRE(opcode.size() == 3);
    REQUIRE(opcode.bytes()[0] == 0xC3);
    REQUIRE(opcode.bytes()[1] == 0x80);
    REQUIRE(opcode.bytes()[2] == 0x00);
}

TEST_CASE("Opcode: mix add_byte and add_bytes", "[model][opcode]") {
    Location loc("test.asm", 240);
    Section section("CODE");
    Opcode opcode(&section, loc);

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
    Section section("CODE");
    Opcode opcode(&section, loc);

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

    Section section("CODE");
    Opcode opcode(&section, loc);

    // Build: JP label (0xC3 followed by address - needs patch)
    opcode.add_byte(0xC3);
    opcode.add_byte(0x00);  // Placeholder for address
    opcode.add_byte(0x00);  // Placeholder for address

    // Add patch for the address
    Expression expr(make_symbol(label_sym), loc);
    Patch patch(&opcode, 1, PatchRange::Word, expr);
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
    Section section("CODE");
    Opcode opcode(&section, loc);

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
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));

    // Add LD A, value (needs patch)
    Symbol* value_sym = module.add_symbol("value", loc, 42, SymbolType::Constant);
    Opcode ld_opcode(&sec, std::vector<uint8_t> { 0x3E, 0x00 }, loc);
    Expression expr1(make_symbol(value_sym), loc);
    Patch patch1(&ld_opcode, 1, PatchRange::ByteUnsigned, expr1);
    ld_opcode.add_patch(patch1);
    sec.add_opcode(ld_opcode);

    // Add JP label (needs patch)
    Symbol* start_sym = module.add_symbol("start", loc);
    Opcode jp_opcode(&sec, std::vector<uint8_t> { 0xC3, 0x00, 0x00 }, loc);
    Expression expr2(make_symbol(start_sym), loc);
    Patch patch2(&jp_opcode, 1, PatchRange::Word, expr2);
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
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));                   // 0x8000
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));             // 0x8001
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0xC3, 0x00, 0x80 }, loc));       // 0x8003

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
    Opcode jr_opcode(&sec, std::vector<uint8_t> { 0x18, 0x00 }, loc);

    // Create expression: target - ($ + 2)
    Expression target_expr(make_symbol(loop_sym), loc);
    Patch patch(&jr_opcode, 1, PatchRange::JrOffset, target_expr);
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
    Opcode ld_opcode(&sec, std::vector<uint8_t> { 0x3E, 0x00 }, loc2);
    Expression expr1(make_symbol(constant_sym), loc2);
    Patch patch1(&ld_opcode, 1, PatchRange::ByteUnsigned, expr1);
    ld_opcode.add_patch(patch1);
    sec.add_opcode(ld_opcode);

    // Data: DEFW address
    Opcode data_opcode(&sec, std::vector<uint8_t> { 0x00, 0x00 }, loc2);
    Expression expr2(make_symbol(label_sym), loc2);
    Patch patch2(&data_opcode, 0, PatchRange::Word, expr2);
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
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(sec.pc() == 0x8005);  // base + 1

    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    REQUIRE(sec.pc() == 0x8007);  // base + 3
}

TEST_CASE("Section: add opcode", "[model][section]") {
    Location loc("test.asm", 10);
    Section sec("CODE");

    std::vector<uint8_t> bytes = { 0x00 };  // NOP
    Opcode opcode(&sec, bytes, loc);
    sec.add_opcode(opcode);

    REQUIRE(sec.opcodes().size() == 2);
    REQUIRE(sec.size() == 1);
}

TEST_CASE("Section: multiple opcodes", "[model][section]") {
    Location loc("test.asm", 20);
    Section sec("CODE");

    // Add several opcodes
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));                   // NOP - 1 byte
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));             // LD A, 42 - 2 bytes
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0xC3, 0x00, 0x80 }, loc));       // JP 0x8000 - 3 bytes

    REQUIRE(sec.opcodes().size() == 4);
    REQUIRE(sec.size() == 6);  // 1 + 2 + 3
}

TEST_CASE("Section: program counter calculation", "[model][section]") {
    Location loc("test.asm", 30);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    REQUIRE(sec.pc() == 0x8000);  // Empty section

    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(sec.pc() == 0x8001);  // Base + 1

    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    REQUIRE(sec.pc() == 0x8003);  // Base + 3
}

TEST_CASE("Section: program counter with alignment", "[model][section]") {
    Location loc("test.asm", 35);
    Section sec("CODE");
    sec.set_alignment(16);
    sec.set_base_address(0x8001);  // Will be aligned to 0x8010

    REQUIRE(sec.base_address() == 0x8010);
    REQUIRE(sec.pc() == 0x8010);  // Empty section

    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(sec.pc() == 0x8011);  // Aligned base + 1

    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    REQUIRE(sec.pc() == 0x8013);  // Aligned base + 3
}

TEST_CASE("Section: clear opcodes", "[model][section]") {
    Location loc("test.asm", 40);
    Section sec("CODE");
    REQUIRE(sec.size() == 0);

    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(sec.size() == 2);

    sec.clear_opcodes();
    REQUIRE(sec.opcodes().size() == 1); // start with an empty opcode
    REQUIRE(sec.size() == 0);
}

TEST_CASE("Section: program counter calculation with clear and add",
          "[model][section]") {
    Location loc("test.asm", 30);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    // Add opcodes
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    REQUIRE(sec.pc() == 0x8003);  // 3 bytes

    // Clear and add new opcodes
    sec.clear_opcodes();
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0xC3, 0x00, 0x80 }, loc));
    REQUIRE(sec.pc() == 0x8003);  // 3 bytes
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
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x00 }, loc));                   // 0x8010
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0x3E, 0x42 }, loc));             // 0x8011-0x8012
    sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { 0xC3, 0x00, 0x80 }, loc));       // 0x8013-0x8015

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
        sec.add_opcode(Opcode(&sec, std::vector<uint8_t> { static_cast<uint8_t>(i) }, loc));
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
// Section opcode pointer stability tests
//-----------------------------------------------------------------------------

TEST_CASE("Section: add_opcode returns pointer to added opcode",
          "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    Opcode* opcode1 = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(opcode1 != nullptr);
    REQUIRE(opcode1->size() == 1);
    REQUIRE(opcode1->bytes()[0] == 0x00);

    Opcode* opcode2 = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
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
    Opcode* first = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(first->size() == 1);
    REQUIRE(section.opcodes().size() == 2); // section starts with empty opcode

    // Add many more opcodes
    std::vector<Opcode*> opcodes;
    opcodes.push_back(first);
    for (int i = 0; i < 100; ++i) {
        opcodes.push_back(section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc)));
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

    Opcode* opcode = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc));
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
    Opcode* opcode = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0xC3, 0x00, 0x00 }, loc));
    Expression expr(make_symbol(target_sym), loc);
    Patch patch(opcode, 1, PatchRange::Word, expr);
    opcode->add_patch(patch);

    REQUIRE(opcode->has_patches());
    REQUIRE(opcode->patches().size() == 1);

    // Add more opcodes
    for (int i = 0; i < 50; ++i) {
        section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
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

    Opcode* first = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(section.last_opcode() == first);

    Opcode* second = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    REQUIRE(section.last_opcode() == second);
    REQUIRE(section.last_opcode() != first);

    Opcode* third = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0xC3, 0x00, 0x80 }, loc));
    REQUIRE(section.last_opcode() == third);
}

TEST_CASE("Section: last_opcode const version", "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Section section("CODE");

    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x3E, 0x42 }, loc));

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

    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc));

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

    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    REQUIRE(section.last_opcode() != nullptr);

    section.clear_opcodes();
    REQUIRE(section.last_opcode() != nullptr);
}

TEST_CASE("Section: last_opcode with patches", "[model][section][opcode]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);
    Section section("CODE");
    Symbol* target_sym = module.add_symbol("target", loc);

    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0xC3, 0x00, 0x00 }, loc));

    Opcode* last = section.last_opcode();
    REQUIRE(last != nullptr);

    // Add patch to last opcode
    Expression expr(make_symbol(target_sym), loc);
    Patch patch(last, 1, PatchRange::Word, expr);
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
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x3E, 0x42 }, loc));

    // Add label at current position
    Opcode* label_opcode = section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
    Symbol* label = module.add_symbol("loop", loc, 0, SymbolType::AddressRelative);
    label->set_opcode(section->last_opcode());

    // Add more code
    for (int i = 0; i < 50; ++i) {
        section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
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
        Opcode* opcode = section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
        label_opcodes.push_back(opcode);

        std::string label_name = "label" + std::to_string(i);
        Symbol* label = module.add_symbol(label_name, loc, i,
                                          SymbolType::AddressRelative);
        label->set_opcode(section->last_opcode());
        labels.push_back(label);
    }

    // Add more code
    for (int i = 0; i < 100; ++i) {
        section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
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
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x3E, 0x00 }, loc)); // LD A, 0

    loc.set_line_num(20);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));        // NOP (at loop:)
    Opcode* loop_opcode = section->last_opcode();

    Symbol* loop_label = module.add_symbol("loop", loc, 0,
                                           SymbolType::AddressRelative);
    loop_label->set_opcode(loop_opcode);

    loc.set_line_num(30);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x3C }, loc));        // INC A

    loc.set_line_num(40);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x18, 0xFC }, loc));  // JR loop

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
    Opcode* code_opcode = code->add_opcode(Opcode(code, std::vector<uint8_t> { 0x00 }, loc));
    Symbol* code_label = module.add_symbol("start", loc, 0,
                                           SymbolType::AddressRelative);
    code_label->set_opcode(code->last_opcode());

    // DATA section
    Section* data = module.add_section("DATA");
    Opcode* data_opcode = data->add_opcode(Opcode(data, std::vector<uint8_t> { 0x42 }, loc));
    Symbol* data_label = module.add_symbol("value", loc, 0,
                                           SymbolType::AddressRelative);
    data_label->set_opcode(data->last_opcode());

    // Back to CODE
    module.add_section("CODE");
    code->add_opcode(Opcode(code, std::vector<uint8_t> { 0x3E, 0x00 }, loc));

    // Back to DATA
    module.add_section("DATA");
    data->add_opcode(Opcode(data, std::vector<uint8_t> { 0xFF }, loc));

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
    Opcode* placeholder = section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00, 0x00, 0x00 }, loc));

    // Add more opcodes
    for (int i = 0; i < 20; ++i) {
        section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
    }

    // Later, patch the placeholder (simulating two-pass assembly)
    placeholder->set_bytes({ 0xC3, 0x00, 0x80 });  // JP 0x8000
    Expression expr(make_integer(0x8000), loc);
    Patch patch(placeholder, 1, PatchRange::Word, expr);
    placeholder->add_patch(patch);

    // Verify modification
    REQUIRE(placeholder->size() == 3);
    REQUIRE(placeholder->bytes()[0] == 0xC3);
    REQUIRE(placeholder->bytes()[1] == 0x00);
    REQUIRE(placeholder->bytes()[2] == 0x80);
}

TEST_CASE("Integration: last_opcode workflow for label association",
          "[model][integration]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Simulate typical assembly workflow
    loc.set_line_num(10);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc)); // NOP

    // Label at next position
    loc.set_line_num(11);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc)); // NOP (placeholder for start:)
    Opcode* start_opcode = section->last_opcode();
    Symbol* start = module.add_symbol("start", loc, 0, SymbolType::AddressRelative);
    start->set_opcode(section->last_opcode());
    start->set_offset(1);  // Offset 1 from section base
    module.declare_symbol("start", loc, SymbolScope::Public);

    loc.set_line_num(12);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x3E, 0x42 }, loc)); // LD A, 42

    // Another label
    loc.set_line_num(13);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc)); // NOP (placeholder for loop:)
    Opcode* loop_opcode = section->last_opcode();
    Symbol* loop = module.add_symbol("loop", loc, 0, SymbolType::AddressRelative);
    loop->set_opcode(section->last_opcode());
    loop->set_offset(3);  // Offset 3 from section base

    loc.set_line_num(14);
    section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x18, 0xFC }, loc));  // JR loop

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
        opcodes.push_back(section->add_opcode(Opcode(section, std::vector<uint8_t> { static_cast<uint8_t>(i) }, loc)));
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

    Opcode* opcode = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));

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
    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    Opcode* label_opcode = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));

    Symbol label("loop", loc, label_opcode, 3, SymbolType::AddressRelative);

    REQUIRE(label.name() == "loop");
    REQUIRE(label.is_address_relative());
    REQUIRE(label.opcode() == label_opcode);
    REQUIRE(label.offset() == 3);
}

TEST_CASE("Symbol: label constructor default type", "[model][symbol]") {
    Location loc("test.asm", 10);
    Section section("CODE");
    Opcode* opcode = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));

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

    Opcode* opcode1 = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    Symbol label1("label1", loc, opcode1, 0);

    // Add more opcodes
    for (int i = 0; i < 50; ++i) {
        section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x00 }, loc));
    }

    Opcode* opcode2 = section.add_opcode(Opcode(&section, std::vector<uint8_t> { 0x3E, 0x42 }, loc));
    Symbol label2("label2", loc, opcode2, 51);

    // Verify pointers are still valid
    REQUIRE(label1.opcode() == opcode1);
    REQUIRE(label1.opcode()->size() == 1);
    REQUIRE(label2.opcode() == opcode2);
    REQUIRE(label2.opcode()->size() == 2);
}

//-----------------------------------------------------------------------------
// Patch resolve() tests
//-----------------------------------------------------------------------------

TEST_CASE("Patch: resolve ByteUnsigned in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x42), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::ByteUnsigned, expr);
    REQUIRE(patch.resolve());

    REQUIRE(opcode.bytes()[0] == 0x42);
    REQUIRE(opcode.bytes()[1] == 0x00);
    REQUIRE_FALSE(g_errors.has_errors());
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve ByteUnsigned out of range warns", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::ByteUnsigned, expr);
    REQUIRE(patch.resolve());

    REQUIRE(opcode.bytes()[0] == 0x34);  // Truncated
    REQUIRE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Patch: resolve ByteUnsigned negative value warns",
          "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(-1), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::ByteUnsigned, expr);
    REQUIRE(patch.resolve());

    REQUIRE(opcode.bytes()[0] == 0xFF);  // -1 as unsigned byte
    REQUIRE_FALSE(g_errors.has_warnings());  // -1 is in range for unsigned byte (treated as 255)
}

TEST_CASE("Patch: resolve ByteSigned in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(127), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 127);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    {
        Expression expr(make_integer(-128), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x80);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve ByteSigned out of range warns", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(128), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x80);
        REQUIRE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(-129), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x7F);  // Truncated
        REQUIRE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve HighOffset in range", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(0x00), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0xFF }, loc);

        Patch patch(&opcode, 0, PatchRange::HighOffset, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    {
        Expression expr(make_integer(-1), loc);  // 0xFFFF
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::HighOffset, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve HighOffset out of range warns", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x0100), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::HighOffset, expr);
    REQUIRE(patch.resolve());
    REQUIRE(opcode.bytes()[0] == 0x00);  // Low byte
    REQUIRE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve ByteToWordUnsigned", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(0x42), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0xFF, 0xFF }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToWordUnsigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x42);
        REQUIRE(opcode.bytes()[1] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(0x100), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToWordUnsigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x00);
        REQUIRE(opcode.bytes()[1] == 0x00);
        REQUIRE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve ByteToWordSigned", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(127), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0xFF }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToWordSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 127);
        REQUIRE(opcode.bytes()[1] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(-1), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToWordSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0xFF);
        REQUIRE(opcode.bytes()[1] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress3;

    {
        Expression expr(make_integer(-128), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToWordSigned, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0x80);
        REQUIRE(opcode.bytes()[1] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve ByteToPtr24Unsigned", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x42), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0xFF, 0xFF, 0xFF }, loc);

    Patch patch(&opcode, 0, PatchRange::ByteToPtr24Unsigned, expr);
    REQUIRE(patch.resolve());
    REQUIRE(opcode.bytes()[0] == 0x42);
    REQUIRE(opcode.bytes()[1] == 0x00);
    REQUIRE(opcode.bytes()[2] == 0x00);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve ByteToPtr24Signed", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    {
        Expression expr(make_integer(127), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00, 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToPtr24Signed, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 127);
        REQUIRE(opcode.bytes()[1] == 0x00);
        REQUIRE(opcode.bytes()[2] == 0x00);
        REQUIRE_FALSE(g_errors.has_warnings());
    }

    SuppressErrors suppress2;

    {
        Expression expr(make_integer(-1), loc);
        Section section("CODE");
        Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00, 0x00 }, loc);

        Patch patch(&opcode, 0, PatchRange::ByteToPtr24Signed, expr);
        REQUIRE(patch.resolve());
        REQUIRE(opcode.bytes()[0] == 0xFF);
        REQUIRE(opcode.bytes()[1] == 0xFF);
        REQUIRE(opcode.bytes()[2] == 0xFF);
        REQUIRE_FALSE(g_errors.has_warnings());
    }
}

TEST_CASE("Patch: resolve Ptr24", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x123456), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::Ptr24, expr);
    REQUIRE(patch.resolve());
    REQUIRE(opcode.bytes()[0] == 0x56);
    REQUIRE(opcode.bytes()[1] == 0x34);
    REQUIRE(opcode.bytes()[2] == 0x12);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve Word little-endian", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::Word, expr);
    REQUIRE(patch.resolve());
    REQUIRE(opcode.bytes()[0] == 0x34);
    REQUIRE(opcode.bytes()[1] == 0x12);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve WordBigEndian", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x1234), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::WordBigEndian, expr);
    REQUIRE(patch.resolve());
    REQUIRE(opcode.bytes()[0] == 0x12);
    REQUIRE(opcode.bytes()[1] == 0x34);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve Dword little-endian", "[model][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Expression expr(make_integer(0x12345678), loc);
    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00, 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::Dword, expr);
    REQUIRE(patch.resolve());
    REQUIRE(opcode.bytes()[0] == 0x78);
    REQUIRE(opcode.bytes()[1] == 0x56);
    REQUIRE(opcode.bytes()[2] == 0x34);
    REQUIRE(opcode.bytes()[3] == 0x12);
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Patch: resolve JR offset range", "[model][patch]") {
    Location loc("test.asm", 20);
    Expression expr(make_integer(10), loc);
    Section section("CODE");
    Opcode opcode(&section, loc);
    Patch patch(&opcode, 1, PatchRange::JrOffset, expr);

    REQUIRE(patch.range() == PatchRange::JrOffset);

    REQUIRE(patch.expression().evaluate() == 10);
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

    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t> { 0x00, 0x00 }, loc);

    Patch patch(&opcode, 0, PatchRange::Word, expr);
    REQUIRE(patch.resolve());

    REQUIRE(opcode.bytes()[0] == 0x00);
    REQUIRE(opcode.bytes()[1] == 0x81);  // 0x8100 little-endian
    REQUIRE_FALSE(g_errors.has_warnings());
}

TEST_CASE("Integration: patch all range types in sequence",
          "[model][integration][patch]") {
    SuppressErrors suppress;
    Location loc("test.asm", 10);

    Section section("CODE");
    Opcode opcode(&section, std::vector<uint8_t>(20, 0x00), loc);
    int offset = 0;

    // ByteUnsigned
    {
        Expression expr(make_integer(0x42), loc);
        Patch patch(&opcode, offset, PatchRange::ByteUnsigned, expr);
        REQUIRE(patch.resolve());
        offset += 1;
    }

    // Word
    {
        Expression expr(make_integer(0x1234), loc);
        Patch patch(&opcode, offset, PatchRange::Word, expr);
        REQUIRE(patch.resolve());
        offset += 2;
    }

    // Ptr24
    {
        Expression expr(make_integer(0x567890), loc);
        Patch patch(&opcode, offset, PatchRange::Ptr24, expr);
        REQUIRE(patch.resolve());
        offset += 3;
    }

    // Dword
    {
        Expression expr(make_integer(0x12345678), loc);
        Patch patch(&opcode, offset, PatchRange::Dword, expr);
        REQUIRE(patch.resolve());
        offset += 4;
    }

    // Verify all patches
    REQUIRE(opcode.bytes()[0] == 0x42);              // ByteUnsigned
    REQUIRE(opcode.bytes()[1] == 0x34);              // Word low
    REQUIRE(opcode.bytes()[2] == 0x12);              // Word high
    REQUIRE(opcode.bytes()[3] == 0x90);              // Ptr24 byte 0
    REQUIRE(opcode.bytes()[4] == 0x78);              // Ptr24 byte 1
    REQUIRE(opcode.bytes()[5] == 0x56);              // Ptr24 byte 2
    REQUIRE(opcode.bytes()[6] == 0x78);              // Dword byte 0
    REQUIRE(opcode.bytes()[7] == 0x56);              // Dword byte 1
    REQUIRE(opcode.bytes()[8] == 0x34);              // Dword byte 2
    REQUIRE(opcode.bytes()[9] == 0x12);              // Dword byte 3

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
    Opcode* target_opcode = section->add_opcode(Opcode(section, std::vector<uint8_t> { 0x00 }, loc));
    section->compute_opcodes_addresses();

    Symbol* label = module.add_symbol("loop", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(target_opcode);
    label->set_offset(0);

    // JR to loop from address 0x8020
    Expression expr(make_symbol(label), loc);
    Section dummy("CODE");
    Opcode opcode(&dummy, std::vector<uint8_t> { 0x18, 0x00 }, loc);
    opcode.set_address(0x8020);

    Patch patch(&opcode, 1, PatchRange::JrOffset, expr);
    REQUIRE(patch.resolve());

    // offset = 0x8000 - (0x8020 + 2) = -34 = 0xDE
    REQUIRE(opcode.bytes()[1] == 0xDE);
    REQUIRE_FALSE(g_errors.has_warnings());
    REQUIRE_FALSE(g_errors.has_errors());
}
