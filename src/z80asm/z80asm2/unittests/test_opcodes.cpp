//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../opcodes.h"
#include "../preprocessor.h"
#include "../unit.h"
#include "catch_amalgamated.hpp"
#include <sstream>

//-----------------------------------------------------------------------------
// z80asm opcodes parser unit tests
//-----------------------------------------------------------------------------

TEST_CASE("OpcodesParser: parse fails when first token is non-opcode keyword and emits error",
          "[opcodes][keyword][non-opcode]") {
    SuppressErrors suppress;
    CompilationUnit unit;
    Preprocessor pp;

    // Use a directive/keyword that is not an opcode: DEFB
    pp.push_virtual_file("DEFB 1\n", "non_opcode_first.asm", 1, true);

    TokenLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE_FALSE(line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "DEFB");

    OpcodesParser parser(&unit);

    const bool ok = parser.parse(line);
    REQUIRE_FALSE(ok);

    // Expect an error to have been recorded (current parse emits InvalidSyntax)
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Unexpected token") != std::string::npos);
    REQUIRE(msg.find("DEFB") != std::string::npos);
    /*
    REQUIRE(!msg.empty());

    // Current implementation emits: "Unexpected first keyword '<kw>'"
    */
}

TEST_CASE("OpcodesParser: simple 'nop' instruction parses successfully",
          "[opcodes][success][nop]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("nop\n", "nop_ok.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    REQUIRE(section->opcodes().size() == 2);
    REQUIRE(section->opcodes()[0]->size() == 0); // empty placeholder
    REQUIRE(section->opcodes()[1]->size() == 1); // this instruction
    REQUIRE(section->opcodes()[1]->bytes() == std::vector<uint8_t>({ 0x00 }));
    REQUIRE(section->opcodes()[1]->patches().size() == 0); // no patches
}

TEST_CASE("OpcodesParser: 'ld bc, (hl)' assembles into multiple opcodes without patches",
          "[opcodes][success][multi-opcodes][ld]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Single instruction that expands into multiple opcodes
    pp.push_virtual_file("ld bc, (hl)\n", "ld_bc_hl.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 4 opcode entries (indexes 1..4)
    REQUIRE(section->opcodes().size() == 5);
    REQUIRE(section->opcodes()[0]->size() == 0); // empty placeholder

    // opcode[1] == { 0x4E }
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes() == std::vector<uint8_t>({ 0x4E }));
    REQUIRE(section->opcodes()[1]->patches().size() == 0);

    // opcode[2] == { 0x23 }
    REQUIRE(section->opcodes()[2]->size() == 1);
    REQUIRE(section->opcodes()[2]->bytes() == std::vector<uint8_t>({ 0x23 }));
    REQUIRE(section->opcodes()[2]->patches().size() == 0);

    // opcode[3] == { 0x46 }
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes() == std::vector<uint8_t>({ 0x46 }));
    REQUIRE(section->opcodes()[3]->patches().size() == 0);

    // opcode[4] == { 0x2B }
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes() == std::vector<uint8_t>({ 0x2B }));
    REQUIRE(section->opcodes()[4]->patches().size() == 0);
}

TEST_CASE("OpcodesParser: 'ld a, 22*2' parses to correct opcode, patch, and expression",
          "[opcodes][patch][expression]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld a, 22*2\n", "ld_a_expr.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 2);
    REQUIRE(op->bytes()[0] == 0x3E); // LD A, n
    REQUIRE(op->bytes()[1] == 0x00); // Patched value placeholder

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch.offset() == 1);

    // The patch expression should evaluate to 44
    int value = patch.expression().evaluate();
    REQUIRE(value == 44); // This will be 44 if 22*2 is used
}

TEST_CASE("OpcodesParser: 'ld a, (ix-4)' parses to correct opcode, patch, and expression",
          "[opcodes][patch][expression][ix]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld a, (ix-4)\n", "ld_a_ix.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 3);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0x7E); // LD A, (IX+d)
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::ByteSigned);
    REQUIRE(patch.offset() == 2);

    // The patch expression should evaluate to -4
    int value = patch.expression().evaluate();
    REQUIRE(value == -4);
}

TEST_CASE("OpcodesParser: 'ld a, (ix+4)' parses to correct opcode, patch, and expression",
          "[opcodes][patch][expression][ix][positive-offset]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld a, (ix+4)\n", "ld_a_ix_pos.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 3);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0x7E); // LD A, (IX+d)
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::ByteSigned);
    REQUIRE(patch.offset() == 2);

    // The patch expression should evaluate to 4
    int value = patch.expression().evaluate();
    REQUIRE(value == 4);
}

TEST_CASE("OpcodesParser: 'ld a, (ix)' parses to correct opcode and no patch",
          "[opcodes][ix][no-patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld a, (ix)\n", "ld_a_ix_nopatch.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 3);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0x7E); // LD A, (IX+d)
    REQUIRE(op->bytes()[2] == 0x00); // Displacement is 0

    // There should be no patches
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 0);
}

TEST_CASE("OpcodesParser: 'nextreg 2,3' parses to correct opcode, patches, and expressions",
          "[opcodes][nextreg][patch][expression]") {
    g_options = Options();
    g_options.cpu_id = CPU::z80n;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("nextreg 2,3\n", "nextreg_2_3.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xED); // NEXTREG prefix
    REQUIRE(op->bytes()[1] == 0x91); // NEXTREG opcode
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (register)
    REQUIRE(op->bytes()[3] == 0x00); // Patched value placeholder (value)

    // There should be two patches
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 2);

    // First patch: register number
    const auto& patch0 = patches[0];
    REQUIRE(patch0.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch0.offset() == 2);
    int value0 = patch0.expression().evaluate();
    REQUIRE(value0 == 2);

    // Second patch: value
    const auto& patch1 = patches[1];
    REQUIRE(patch1.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch1.offset() == 3);
    int value1 = patch1.expression().evaluate();
    REQUIRE(value1 == 3);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'nextreg 2,3' fails on default CPU (z80) with correct error message",
          "[opcodes][nextreg][cpu][error]") {
    // Ensure default CPU (z80) is set
    g_options = Options();
    g_options.cpu_id = CPU::z80;

    SuppressErrors suppress;
    CompilationUnit unit;
    Preprocessor pp;
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("nextreg 2,3\n", "nextreg_2_3_z80.asm", 1, true);

    TokenLine line;
    REQUIRE(pp.next_line(line));
    // Parsing should fail
    REQUIRE_FALSE(parser.parse(line));

    // There should be an error about nextreg not being available on z80
    REQUIRE(g_errors.has_errors());
    const std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("nextreg") != std::string::npos);
    REQUIRE(msg.find("Unexpected token") != std::string::npos);
    REQUIRE(msg.find("z80") != std::string::npos);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'rlc (ix+4)' parses to correct opcode, patch, and expression",
          "[opcodes][rlc][ix][positive-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("rlc (ix+4)\n", "rlc_ix_plus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0xCB); // CB prefix
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (displacement)
    REQUIRE(op->bytes()[3] == 0x06); // RLC (IX+d)

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::ByteSigned);
    REQUIRE(patch.offset() == 2);

    // The patch expression should evaluate to 4
    int value = patch.expression().evaluate();
    REQUIRE(value == 4);
}

TEST_CASE("OpcodesParser: 'rlc (ix-4)' parses to correct opcode, patch, and expression",
          "[opcodes][rlc][ix][negative-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("rlc (ix-4)\n", "rlc_ix_minus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0xCB); // CB prefix
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (displacement)
    REQUIRE(op->bytes()[3] == 0x06); // RLC (IX+d)

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::ByteSigned);
    REQUIRE(patch.offset() == 2);

    // The patch expression should evaluate to -4
    int value = patch.expression().evaluate();
    REQUIRE(value == -4);
}

TEST_CASE("OpcodesParser: 'rlc (ix)' parses to correct opcode and no patch",
          "[opcodes][rlc][ix][no-patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("rlc (ix)\n", "rlc_ix_nopatch.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0xCB); // CB prefix
    REQUIRE(op->bytes()[2] == 0x00); // Displacement is 0
    REQUIRE(op->bytes()[3] == 0x06); // RLC (IX+d)

    // There should be no patches
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 0);
}

TEST_CASE("OpcodesParser: 'ld (ix+4), 5' parses to correct opcode, patches, and expressions",
          "[opcodes][ld][ix][positive-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld (ix+4), 5\n", "ld_ix_plus4_5.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0x36); // LD (IX+d), n
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (displacement)
    REQUIRE(op->bytes()[3] == 0x00); // Patched value placeholder (immediate)

    // There should be two patches
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 2);

    // First patch: displacement
    const auto& patch0 = patches[0];
    REQUIRE(patch0.range() == PatchRange::ByteSigned);
    REQUIRE(patch0.offset() == 2);
    int value0 = patch0.expression().evaluate();
    REQUIRE(value0 == 4);

    // Second patch: immediate value
    const auto& patch1 = patches[1];
    REQUIRE(patch1.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch1.offset() == 3);
    int value1 = patch1.expression().evaluate();
    REQUIRE(value1 == 5);
}

TEST_CASE("OpcodesParser: 'ld (ix-4), 5' parses to correct opcode, patches, and expressions",
          "[opcodes][ld][ix][negative-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld (ix-4), 5\n", "ld_ix_minus4_5.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0x36); // LD (IX+d), n
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (displacement)
    REQUIRE(op->bytes()[3] == 0x00); // Patched value placeholder (immediate)

    // There should be two patches
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 2);

    // First patch: displacement
    const auto& patch0 = patches[0];
    REQUIRE(patch0.range() == PatchRange::ByteSigned);
    REQUIRE(patch0.offset() == 2);
    int value0 = patch0.expression().evaluate();
    REQUIRE(value0 == -4);

    // Second patch: immediate value
    const auto& patch1 = patches[1];
    REQUIRE(patch1.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch1.offset() == 3);
    int value1 = patch1.expression().evaluate();
    REQUIRE(value1 == 5);
}

TEST_CASE("OpcodesParser: 'ld (ix), 5' parses to correct opcode, patch, and expression (no displacement patch)",
          "[opcodes][ld][ix][no-displacement][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld (ix), 5\n", "ld_ix_5.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xDD); // IX prefix
    REQUIRE(op->bytes()[1] == 0x36); // LD (IX+d), n
    REQUIRE(op->bytes()[2] == 0x00); // Displacement is 0
    REQUIRE(op->bytes()[3] == 0x00); // Patched value placeholder (immediate)

    // There should be only one patch (for the immediate value)
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);

    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch.offset() == 3);
    int value = patch.expression().evaluate();
    REQUIRE(value == 5);
}

TEST_CASE("OpcodesParser: 'ld de, sp+4' parses to correct opcode sequence and patch (positive offset)",
          "[opcodes][ld][de][sp][positive-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld de, sp+4\n", "ld_de_sp_plus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be five opcodes: placeholder and four instructions
    REQUIRE(section->opcodes().size() == 5);

    // 1st opcode: placeholder (size 0)
    REQUIRE(section->opcodes()[0]->size() == 0);

    // 2nd opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes()[0] == 0xEB);

    // 3rd opcode: LD HL,imm16 (0x21, 0x00, 0x00), patch at offset 1
    REQUIRE(section->opcodes()[2]->size() == 3);
    REQUIRE(section->opcodes()[2]->bytes()[0] == 0x21);
    REQUIRE(section->opcodes()[2]->bytes()[1] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[2] == 0x00);
    const auto& patches2 = section->opcodes()[2]->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteToWordUnsigned);
    REQUIRE(patch2.offset() == 1);
    int value2 = patch2.expression().evaluate();
    REQUIRE(value2 == 4);

    // 4th opcode: ADD HL,SP (0x39)
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes()[0] == 0x39);

    // 5th opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes()[0] == 0xEB);
}

TEST_CASE("OpcodesParser: 'ld de, sp-4' parses to correct opcode sequence and patch (negative offset)",
          "[opcodes][ld][de][sp][negative-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld de, sp-4\n", "ld_de_sp_minus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be five opcodes: placeholder and four instructions
    REQUIRE(section->opcodes().size() == 5);

    // 1st opcode: placeholder (size 0)
    REQUIRE(section->opcodes()[0]->size() == 0);

    // 2nd opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes()[0] == 0xEB);

    // 3rd opcode: LD HL,imm16 (0x21, 0x00, 0x00), patch at offset 1
    REQUIRE(section->opcodes()[2]->size() == 3);
    REQUIRE(section->opcodes()[2]->bytes()[0] == 0x21);
    REQUIRE(section->opcodes()[2]->bytes()[1] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[2] == 0x00);
    const auto& patches2 = section->opcodes()[2]->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteToWordUnsigned);
    REQUIRE(patch2.offset() == 1);
    int value2 = patch2.expression().evaluate();
    REQUIRE(value2 == -4);

    // 4th opcode: ADD HL,SP (0x39)
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes()[0] == 0x39);

    // 5th opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes()[0] == 0xEB);
}

TEST_CASE("OpcodesParser: 'ld de, sp' parses to correct opcode sequence and no patch",
          "[opcodes][ld][de][sp][no-patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld de, sp\n", "ld_de_sp.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be five opcodes: placeholder and four instructions
    REQUIRE(section->opcodes().size() == 5);

    // 1st opcode: placeholder (size 0)
    REQUIRE(section->opcodes()[0]->size() == 0);

    // 2nd opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes()[0] == 0xEB);

    // 3rd opcode: LD HL,imm16 (0x21, 0x00, 0x00), no patch
    REQUIRE(section->opcodes()[2]->size() == 3);
    REQUIRE(section->opcodes()[2]->bytes()[0] == 0x21);
    REQUIRE(section->opcodes()[2]->bytes()[1] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[2] == 0x00);
    const auto& patches2 = section->opcodes()[2]->patches();
    REQUIRE(patches2.size() == 0);

    // 4th opcode: ADD HL,SP (0x39)
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes()[0] == 0x39);

    // 5th opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes()[0] == 0xEB);
}

TEST_CASE("OpcodesParser: 'ld de, sp+4' on ez80 parses to correct opcode sequence and patch (positive offset, 24-bit)",
          "[opcodes][ld][de][sp][ez80][positive-offset][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld de, sp+4\n", "ld_de_sp_plus4_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be five opcodes: placeholder and four instructions
    REQUIRE(section->opcodes().size() == 5);

    // 1st opcode: placeholder (size 0)
    REQUIRE(section->opcodes()[0]->size() == 0);

    // 2nd opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes()[0] == 0xEB);

    // 3rd opcode: LD HL,imm24 (0x21, 0x00, 0x00, 0x00), patch at offset 1
    REQUIRE(section->opcodes()[2]->size() == 4);
    REQUIRE(section->opcodes()[2]->bytes()[0] == 0x21);
    REQUIRE(section->opcodes()[2]->bytes()[1] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[2] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[3] == 0x00);
    const auto& patches2 = section->opcodes()[2]->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteToPtr24Unsigned);
    REQUIRE(patch2.offset() == 1);
    int value2 = patch2.expression().evaluate();
    REQUIRE(value2 == 4);

    // 4th opcode: ADD HL,SP (0x39)
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes()[0] == 0x39);

    // 5th opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes()[0] == 0xEB);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld de, sp-4' on ez80 parses to correct opcode sequence and patch (negative offset, 24-bit)",
          "[opcodes][ld][de][sp][ez80][negative-offset][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld de, sp-4\n", "ld_de_sp_minus4_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be five opcodes: placeholder and four instructions
    REQUIRE(section->opcodes().size() == 5);

    // 1st opcode: placeholder (size 0)
    REQUIRE(section->opcodes()[0]->size() == 0);

    // 2nd opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes()[0] == 0xEB);

    // 3rd opcode: LD HL,imm24 (0x21, 0x00, 0x00, 0x00), patch at offset 1
    REQUIRE(section->opcodes()[2]->size() == 4);
    REQUIRE(section->opcodes()[2]->bytes()[0] == 0x21);
    REQUIRE(section->opcodes()[2]->bytes()[1] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[2] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[3] == 0x00);
    const auto& patches2 = section->opcodes()[2]->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteToPtr24Unsigned);
    REQUIRE(patch2.offset() == 1);
    int value2 = patch2.expression().evaluate();
    REQUIRE(value2 == -4);

    // 4th opcode: ADD HL,SP (0x39)
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes()[0] == 0x39);

    // 5th opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes()[0] == 0xEB);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld de, sp' on ez80 parses to correct opcode sequence and no patch (24-bit)",
          "[opcodes][ld][de][sp][ez80][no-patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld de, sp\n", "ld_de_sp_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be five opcodes: placeholder and four instructions
    REQUIRE(section->opcodes().size() == 5);

    // 1st opcode: placeholder (size 0)
    REQUIRE(section->opcodes()[0]->size() == 0);

    // 2nd opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[1]->size() == 1);
    REQUIRE(section->opcodes()[1]->bytes()[0] == 0xEB);

    // 3rd opcode: LD HL,imm24 (0x21, 0x00, 0x00, 0x00), no patch
    REQUIRE(section->opcodes()[2]->size() == 4);
    REQUIRE(section->opcodes()[2]->bytes()[0] == 0x21);
    REQUIRE(section->opcodes()[2]->bytes()[1] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[2] == 0x00);
    REQUIRE(section->opcodes()[2]->bytes()[3] == 0x00);
    const auto& patches2 = section->opcodes()[2]->patches();
    REQUIRE(patches2.size() == 0);

    // 4th opcode: ADD HL,SP (0x39)
    REQUIRE(section->opcodes()[3]->size() == 1);
    REQUIRE(section->opcodes()[3]->bytes()[0] == 0x39);

    // 5th opcode: EX DE,HL (0xEB)
    REQUIRE(section->opcodes()[4]->size() == 1);
    REQUIRE(section->opcodes()[4]->bytes()[0] == 0xEB);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld hl,0x1234' parses to correct opcode, patch, and expression",
          "[opcodes][ld][hl][imm16][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld hl,0x1234\n", "ld_hl_imm16.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 3);
    REQUIRE(op->bytes()[0] == 0x21); // LD HL,nn
    REQUIRE(op->bytes()[1] == 0x00); // Patched value placeholder (low byte)
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (high byte)

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::Word);
    REQUIRE(patch.offset() == 1);

    // The patch expression should evaluate to 0x1234
    int value = patch.expression().evaluate();
    REQUIRE(value == 0x1234);
}

TEST_CASE("OpcodesParser: 'ld hl,0x123456' on ez80 parses to correct opcode, patch, and expression (24-bit)",
          "[opcodes][ld][hl][imm24][ez80][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("ld hl,0x123456\n", "ld_hl_imm24_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0x21); // LD HL,nnn
    REQUIRE(op->bytes()[1] == 0x00); // Patched value placeholder (low byte)
    REQUIRE(op->bytes()[2] == 0x00); // Patched value placeholder (mid byte)
    REQUIRE(op->bytes()[3] == 0x00); // Patched value placeholder (high byte)

    // There should be one patch
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::Ptr24);
    REQUIRE(patch.offset() == 1);

    // The patch expression should evaluate to 0x123456
    int value = patch.expression().evaluate();
    REQUIRE(value == 0x123456);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'sub hl, de' assembles to CALL helper with Word patch and extern symbol",
          "[opcodes][sub][hl][patch][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("sub hl, de\n", "sub_hl_de.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect placeholder + one instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();

    // Expected bytes: { 0xCD, 0x00, 0x00 }
    REQUIRE(op->size() == 3);
    REQUIRE(op->bytes()[0] == 0xCD);
    REQUIRE(op->bytes()[1] == 0x00);
    REQUIRE(op->bytes()[2] == 0x00);

    // One Word patch at offset 1
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::Word);
    REQUIRE(patch.offset() == 1);

    // Patch expression text must be the helper symbol name
    REQUIRE(patch.expression().to_string() == "__z80asm__sub_hl_de");

    // The helper symbol should be declared in the current module as extern
    Symbol* helper = module->get_symbol("__z80asm__sub_hl_de");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());
}

TEST_CASE("OpcodesParser: 'sub hl, de' on ez80 assembles to CALL helper with Ptr24 patch and extern symbol",
          "[opcodes][sub][hl][ez80][patch][symbol]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("sub hl, de\n", "sub_hl_de_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect placeholder + one instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();

    // Expected bytes: { 0xCD, 0x00, 0x00, 0x00 } (24-bit pointer placeholder)
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes()[0] == 0xCD);
    REQUIRE(op->bytes()[1] == 0x00);
    REQUIRE(op->bytes()[2] == 0x00);
    REQUIRE(op->bytes()[3] == 0x00);

    // One Ptr24 patch at offset 1
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::Ptr24);
    REQUIRE(patch.offset() == 1);

    // Patch expression text must be the helper symbol name
    REQUIRE(patch.expression().to_string() == "__z80asm__sub_hl_de");

    // The helper symbol should be declared in the current module as extern
    Symbol* helper = module->get_symbol("__z80asm__sub_hl_de");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'call z, 0x1234' on r2ka expands to jr/nz + call + label (patches and symbol)",
          "[opcodes][call][r2ka][patch][symbol]") {
    g_options = Options();
    g_options.cpu_id = CPU::r2ka;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    // Assemble the instruction
    pp.push_virtual_file("call z, 0x1234\n", "call_z_0x1234_r2ka.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 3 opcodes (jr nz, call, label placeholder)
    REQUIRE(section->opcodes().size() == 4);

    // 1st opcode: jr nz, temporary_label -> bytes {0x20, 0x00}
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 2);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0x20, 0x00 }));

    // One patch: JrOffset at offset 1, expression should reference the temporary label
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::JrOffset);
    REQUIRE(patch1.offset() == 1);

    // The expression text holds the temporary label name (we'll use it to look up the symbol)
    const std::string temp_label_name = patch1.expression().to_string();
    REQUIRE(!temp_label_name.empty());

    // 2nd opcode: call 0x1234 -> bytes {0xCD, 0x00, 0x00}
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 3);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0xCD, 0x00, 0x00 }));

    // One patch: Word at offset 1; the expression should evaluate to 0x1234
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::Word);
    REQUIRE(patch2.offset() == 1);
    int call_target = patch2.expression().evaluate();
    REQUIRE(call_target == 0x1234);

    // 3rd opcode: empty placeholder (target of the temporary label)
    auto* op3 = section->opcodes()[3].get();
    REQUIRE(op3->size() == 0);

    // The temporary label symbol must exist in the module, be address-relative,
    // and point to the empty opcode (opcode index 3)
    Symbol* temp_sym = module->get_symbol(temp_label_name);
    REQUIRE(temp_sym != nullptr);
    REQUIRE(temp_sym->is_address_relative());

    // The symbol's opcode() should point to the same Opcode instance stored in the section
    REQUIRE(temp_sym->opcode() == section->opcodes()[3].get());

    g_options = Options();
}

// Added tests: verify 'ld hl, sp+4', 'ld hl, sp-4' and 'ld hl, sp' opcode expansion

TEST_CASE("OpcodesParser: 'ld hl, sp+4' parses to LD HL,imm16 + ADD HL,SP with signed word patch",
          "[opcodes][ld][hl][sp][positive-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, sp+4\n", "ld_hl_sp_plus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (LD HL,imm16) + (ADD HL,SP)
    REQUIRE(section->opcodes().size() == 3);

    // placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // LD HL,imm16 -> { 0x21, 0x00, 0x00 } with one ByteToWordSigned patch at offset 1
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes()[0] == 0x21);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::ByteToWordSigned);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().evaluate() == 4);

    // ADD HL,SP -> { 0x39 } with no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x39);
    REQUIRE(op2->patches().size() == 0);
}

TEST_CASE("OpcodesParser: 'ld hl, sp-4' parses to LD HL,imm16 + ADD HL,SP with signed word patch (negative)",
          "[opcodes][ld][hl][sp][negative-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, sp-4\n", "ld_hl_sp_minus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (LD HL,imm16) + (ADD HL,SP)
    REQUIRE(section->opcodes().size() == 3);

    // placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // LD HL,imm16 -> { 0x21, 0x00, 0x00 } with one ByteToWordSigned patch at offset 1
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes()[0] == 0x21);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::ByteToWordSigned);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().evaluate() == -4);

    // ADD HL,SP -> { 0x39 } with no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x39);
    REQUIRE(op2->patches().size() == 0);
}

TEST_CASE("OpcodesParser: 'ld hl, sp' parses to LD HL,imm16 + ADD HL,SP with no patch",
          "[opcodes][ld][hl][sp][no-patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, sp\n", "ld_hl_sp.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (LD HL,imm16) + (ADD HL,SP)
    REQUIRE(section->opcodes().size() == 3);

    // placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // LD HL,imm16 -> { 0x21, 0x00, 0x00 } with no patches
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes()[0] == 0x21);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->patches().size() == 0);

    // ADD HL,SP -> { 0x39 } with no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x39);
    REQUIRE(op2->patches().size() == 0);
}

// EZ80 variants of the 'ld hl, sp(+/-)N' tests: 24-bit LD HL and ByteToPtr24Signed patches

TEST_CASE("OpcodesParser: 'ld hl, sp+4' on ez80 parses to LD HL,imm24 + ADD HL,SP with signed 24-bit patch",
          "[opcodes][ld][hl][sp][ez80][positive-offset][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, sp+4\n", "ld_hl_sp_plus4_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (LD HL,imm24) + (ADD HL,SP)
    REQUIRE(section->opcodes().size() == 3);

    // placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // LD HL,imm24 -> { 0x21, 0x00, 0x00, 0x00 } with one ByteToPtr24Signed patch at offset 1
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 4);
    REQUIRE(op1->bytes()[0] == 0x21);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->bytes()[3] == 0x00);
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::ByteToPtr24Signed);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().evaluate() == 4);

    // ADD HL,SP -> { 0x39 } with no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x39);
    REQUIRE(op2->patches().size() == 0);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld hl, sp-4' on ez80 parses to LD HL,imm24 + ADD HL,SP with signed 24-bit patch (negative)",
          "[opcodes][ld][hl][sp][ez80][negative-offset][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, sp-4\n", "ld_hl_sp_minus4_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (LD HL,imm24) + (ADD HL,SP)
    REQUIRE(section->opcodes().size() == 3);

    // placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // LD HL,imm24 -> { 0x21, 0x00, 0x00, 0x00 } with one ByteToPtr24Signed patch at offset 1
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 4);
    REQUIRE(op1->bytes()[0] == 0x21);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->bytes()[3] == 0x00);
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::ByteToPtr24Signed);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().evaluate() == -4);

    // ADD HL,SP -> { 0x39 } with no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x39);
    REQUIRE(op2->patches().size() == 0);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld hl, sp' on ez80 parses to LD HL,imm24 + ADD HL,SP with no patch (24-bit)",
          "[opcodes][ld][hl][sp][ez80][no-patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, sp\n", "ld_hl_sp_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (LD HL,imm24) + (ADD HL,SP)
    REQUIRE(section->opcodes().size() == 3);

    // placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // LD HL,imm24 -> { 0x21, 0x00, 0x00, 0x00 } with no patches
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 4);
    REQUIRE(op1->bytes()[0] == 0x21);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->bytes()[3] == 0x00);
    REQUIRE(op1->patches().size() == 0);

    // ADD HL,SP -> { 0x39 } with no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x39);
    REQUIRE(op2->patches().size() == 0);

    g_options = Options();
}

// Tests for 'add sp, N' encoding: helper call + adjustment opcode

TEST_CASE("OpcodesParser: 'add sp, 4' expands to CALL helper + adjustment opcode with signed byte patch",
          "[opcodes][add][sp][patch][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("add sp, 4\n", "add_sp_4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (CALL helper) + (adjustment)
    REQUIRE(section->opcodes().size() == 3);

    // 1st opcode: CALL __z80asm__add_sp_d -> { 0xCD, 0x00, 0x00 }
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes()[0] == 0xCD);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);

    // One Word patch at offset 1 referencing the helper symbol
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::Word);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().to_string() == "__z80asm__add_sp_d");

    // Helper symbol should be declared extern in the module
    Symbol* helper = module->get_symbol("__z80asm__add_sp_d");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    // 2nd opcode: adjustment opcode -> { 0x00 } with one ByteSigned patch at offset 0 value 4
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x00);
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 0);
    REQUIRE(patch2.expression().evaluate() == 4);
}

TEST_CASE("OpcodesParser: 'add sp, -4' expands to CALL helper + adjustment opcode with signed byte patch (negative)",
          "[opcodes][add][sp][patch][symbol][negative]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("add sp, -4\n", "add_sp_minus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (CALL helper) + (adjustment)
    REQUIRE(section->opcodes().size() == 3);

    // 1st opcode: CALL __z80asm__add_sp_d -> { 0xCD, 0x00, 0x00 }
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes()[0] == 0xCD);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);

    // One Word patch at offset 1 referencing the helper symbol
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::Word);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().to_string() == "__z80asm__add_sp_d");

    // Helper symbol should be declared extern in the module
    Symbol* helper = module->get_symbol("__z80asm__add_sp_d");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    // 2nd opcode: adjustment opcode -> { 0x00 } with one ByteSigned patch at offset 0 value -4
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x00);
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 0);
    REQUIRE(patch2.expression().evaluate() == -4);
}

TEST_CASE("OpcodesParser: 'add sp, 0' expands to CALL helper + adjustment opcode with adjustment patch (zero)",
          "[opcodes][add][sp][no-patch][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("add sp, 0\n", "add_sp_0.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (CALL helper) + (adjustment)
    REQUIRE(section->opcodes().size() == 3);

    // 1st opcode: CALL __z80asm__add_sp_d -> { 0xCD, 0x00, 0x00 }
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes()[0] == 0xCD);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);

    // One Word patch at offset 1 referencing the helper symbol
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::Word);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().to_string() == "__z80asm__add_sp_d");

    // Helper symbol should be declared extern in the module
    Symbol* helper = module->get_symbol("__z80asm__add_sp_d");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    // 2nd opcode: adjustment opcode -> { 0x00 } with a ByteSigned patch at offset 0 (value is zero here,
    // but assembler always emits the adjustment patch because the value may be an expression)
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x00);
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 0);
    REQUIRE(patch2.expression().evaluate() == 0);
}

// EZ80 variants of the 'add sp, N' tests: 24-bit CALL and Ptr24 patch

TEST_CASE("OpcodesParser: 'add sp, 4' on ez80 expands to CALL helper + adjustment opcode with signed byte patch",
          "[opcodes][add][sp][ez80][patch][symbol]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("add sp, 4\n", "add_sp_4_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (CALL helper) + (adjustment)
    REQUIRE(section->opcodes().size() == 3);

    // 1st opcode: CALL __z80asm__add_sp_d -> { 0xCD, 0x00, 0x00, 0x00 }
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 4);
    REQUIRE(op1->bytes()[0] == 0xCD);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->bytes()[3] == 0x00);

    // One Ptr24 patch at offset 1 referencing the helper symbol
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::Ptr24);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().to_string() == "__z80asm__add_sp_d");

    // Helper symbol should be declared extern in the module
    Symbol* helper = module->get_symbol("__z80asm__add_sp_d");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    // 2nd opcode: adjustment opcode -> { 0x00 } with one ByteSigned patch at offset 0 value 4
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x00);
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 0);
    REQUIRE(patch2.expression().evaluate() == 4);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'add sp, -4' on ez80 expands to CALL helper + adjustment opcode with signed byte patch (negative)",
          "[opcodes][add][sp][ez80][patch][symbol][negative]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("add sp, -4\n", "add_sp_minus4_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (CALL helper) + (adjustment)
    REQUIRE(section->opcodes().size() == 3);

    // 1st opcode: CALL __z80asm__add_sp_d -> { 0xCD, 0x00, 0x00, 0x00 }
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 4);
    REQUIRE(op1->bytes()[0] == 0xCD);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->bytes()[3] == 0x00);

    // One Ptr24 patch at offset 1 referencing the helper symbol
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::Ptr24);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().to_string() == "__z80asm__add_sp_d");

    // Helper symbol should be declared extern in the module
    Symbol* helper = module->get_symbol("__z80asm__add_sp_d");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    // 2nd opcode: adjustment opcode -> { 0x00 } with one ByteSigned patch at offset 0 value -4
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x00);
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 0);
    REQUIRE(patch2.expression().evaluate() == -4);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'add sp, 0' on ez80 expands to CALL helper + adjustment opcode with adjustment patch (zero)",
          "[opcodes][add][sp][ez80][no-patch][symbol]") {
    g_options = Options();
    g_options.cpu_id = CPU::ez80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("add sp, 0\n", "add_sp_0_ez80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes (CALL helper) + (adjustment)
    REQUIRE(section->opcodes().size() == 3);

    // 1st opcode: CALL __z80asm__add_sp_d -> { 0xCD, 0x00, 0x00, 0x00 }
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 4);
    REQUIRE(op1->bytes()[0] == 0xCD);
    REQUIRE(op1->bytes()[1] == 0x00);
    REQUIRE(op1->bytes()[2] == 0x00);
    REQUIRE(op1->bytes()[3] == 0x00);

    // One Ptr24 patch at offset 1 referencing the helper symbol
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::Ptr24);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().to_string() == "__z80asm__add_sp_d");

    // Helper symbol should be declared extern in the module
    Symbol* helper = module->get_symbol("__z80asm__add_sp_d");
    REQUIRE(helper != nullptr);
    REQUIRE(helper->is_extern());

    // 2nd opcode: adjustment opcode -> { 0x00 } with a ByteSigned patch at offset 0
    // (value will evaluate to 0 here, assembler always emits the adjustment patch)
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes()[0] == 0x00);
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 0);
    REQUIRE(patch2.expression().evaluate() == 0);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld px,0x12345678' on r4k parses to 6-byte opcode with Dword patch",
          "[opcodes][ld][px][r4k][imm32][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::r4k;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld px,0x12345678\n", "ld_px_imm32_r4k.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();

    // Expected bytes: { 0xED, 0x1C, 0x00, 0x00, 0x00, 0x00 }
    REQUIRE(op->size() == 6);
    REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xED, 0x1C, 0x00, 0x00, 0x00, 0x00 }));

    // One Dword patch at offset 2
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::Dword);
    REQUIRE(patch.offset() == 2);

    // Patch expression should evaluate to 0x12345678
    int value = patch.expression().evaluate();
    REQUIRE(value == 0x12345678);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'lcall 0x12, 0x3456' on r2ka parses to single opcode with segment+address patches",
          "[opcodes][lcall][r2ka][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::r2ka;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("lcall 0x12, 0x3456\n", "lcall_12_3456_r2ka.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 1 instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();

    // Expected bytes: { 0xCF, 0x00, 0x00, 0x00 }
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xCF, 0x00, 0x00, 0x00 }));

    // Two patches: first = segment (ByteUnsigned at offset 3 -> 0x12)
    //              second = address  (Word        at offset 1 -> 0x3456)
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 2);

    const auto& patch0 = patches[0];
    REQUIRE(patch0.range() == PatchRange::ByteUnsigned);
    REQUIRE(patch0.offset() == 3);
    REQUIRE(patch0.expression().evaluate() == 0x12);

    const auto& patch1 = patches[1];
    REQUIRE(patch1.range() == PatchRange::Word);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().evaluate() == 0x3456);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'llcall 0x1234, 0x5678' on r4k parses to single opcode with segment+address word patches",
          "[opcodes][llcall][r4k][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::r4k;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("llcall 0x1234, 0x5678\n", "llcall_1234_5678_r4k.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 1 instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();

    // Expected bytes: { 0x8F, 0x00, 0x00, 0x00, 0x00 }
    REQUIRE(op->size() == 5);
    REQUIRE(op->bytes() == std::vector<uint8_t>({ 0x8F, 0x00, 0x00, 0x00, 0x00 }));

    // Two patches:
    //  - first: segment (Word) at offset 3 -> 0x1234
    //  - second: address (Word) at offset 1 -> 0x5678
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 2);

    const auto& patch0 = patches[0];
    REQUIRE(patch0.range() == PatchRange::Word);
    REQUIRE(patch0.offset() == 3);
    REQUIRE(patch0.expression().evaluate() == 0x1234);

    const auto& patch1 = patches[1];
    REQUIRE(patch1.range() == PatchRange::Word);
    REQUIRE(patch1.offset() == 1);
    REQUIRE(patch1.expression().evaluate() == 0x5678);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ld hl,(0x4000)' on gbz80 expands to expected 6-opcode sequence with word patches",
          "[opcodes][ld][hl][gbz80][patch]") {
    g_options = Options();
    g_options.cpu_id = CPU::gbz80;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, (0x4000)\n", "ld_hl_ptr_0x4000_gbz80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 6 opcode entries (indexes 1..6)
    REQUIRE(section->opcodes().size() == 7);
    REQUIRE(section->opcodes()[0]->size() == 0); // placeholder

    // 1: { 0xF5 } no patches
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 1);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0xF5 }));
    REQUIRE(op1->patches().size() == 0);

    // 2: { 0xFA, 0x00, 0x00 } patch Word @ offset 1 -> 0x4000
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 3);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0xFA, 0x00, 0x00 }));
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::Word);
    REQUIRE(patch2.offset() == 1);
    REQUIRE(patch2.expression().evaluate() == 0x4000);

    // 3: { 0x6F } no patches
    auto* op3 = section->opcodes()[3].get();
    REQUIRE(op3->size() == 1);
    REQUIRE(op3->bytes() == std::vector<uint8_t>({ 0x6F }));
    REQUIRE(op3->patches().size() == 0);

    // 4: { 0xFA, 0x00, 0x00 } patch Word @ offset 1 -> 0x4001
    auto* op4 = section->opcodes()[4].get();
    REQUIRE(op4->size() == 3);
    REQUIRE(op4->bytes() == std::vector<uint8_t>({ 0xFA, 0x00, 0x00 }));
    const auto& patches4 = op4->patches();
    REQUIRE(patches4.size() == 1);
    const auto& patch4 = patches4[0];
    REQUIRE(patch4.range() == PatchRange::Word);
    REQUIRE(patch4.offset() == 1);
    REQUIRE(patch4.expression().evaluate() == 0x4001);

    // 5: { 0x67 } no patches
    auto* op5 = section->opcodes()[5].get();
    REQUIRE(op5->size() == 1);
    REQUIRE(op5->bytes() == std::vector<uint8_t>({ 0x67 }));
    REQUIRE(op5->patches().size() == 0);

    // 6: { 0xF1 } no patches
    auto* op6 = section->opcodes()[6].get();
    REQUIRE(op6->size() == 1);
    REQUIRE(op6->bytes() == std::vector<uint8_t>({ 0xF1 }));
    REQUIRE(op6->patches().size() == 0);

    g_options = Options();
}

// Added tests for 'ld hl, (ix+4)', 'ld hl, (ix-4)', and 'ld hl, (ix)'

TEST_CASE("OpcodesParser: 'ld hl, (ix+4)' parses to two opcodes with correct patches",
          "[opcodes][ld][hl][ix][positive-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, (ix+4)\n", "ld_hl_ix_plus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes
    REQUIRE(section->opcodes().size() == 3);

    // first opcode: { 0xDD, 0x6E, 0x00 } with displacement patch +4
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0xDD, 0x6E, 0x00 }));
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::ByteSigned);
    REQUIRE(patch1.offset() == 2);
    REQUIRE(patch1.expression().evaluate() == 4);

    // second opcode: { 0xDD, 0x66, 0x00 } with displacement patch +5
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 3);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0xDD, 0x66, 0x00 }));
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 2);
    REQUIRE(patch2.expression().evaluate() == 5);
}

TEST_CASE("OpcodesParser: 'ld hl, (ix-4)' parses to two opcodes with correct patches (negative offset)",
          "[opcodes][ld][hl][ix][negative-offset][patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, (ix-4)\n", "ld_hl_ix_minus4.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes
    REQUIRE(section->opcodes().size() == 3);

    // first opcode: { 0xDD, 0x6E, 0x00 } with displacement patch -4
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0xDD, 0x6E, 0x00 }));
    const auto& patches1 = op1->patches();
    REQUIRE(patches1.size() == 1);
    const auto& patch1 = patches1[0];
    REQUIRE(patch1.range() == PatchRange::ByteSigned);
    REQUIRE(patch1.offset() == 2);
    REQUIRE(patch1.expression().evaluate() == -4);

    // second opcode: { 0xDD, 0x66, 0x00 } with displacement patch -3
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 3);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0xDD, 0x66, 0x00 }));
    const auto& patches2 = op2->patches();
    REQUIRE(patches2.size() == 1);
    const auto& patch2 = patches2[0];
    REQUIRE(patch2.range() == PatchRange::ByteSigned);
    REQUIRE(patch2.offset() == 2);
    REQUIRE(patch2.expression().evaluate() == -3);
}

TEST_CASE("OpcodesParser: 'ld hl, (ix)' parses to two opcodes with no patches",
          "[opcodes][ld][hl][ix][no-patch]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ld hl, (ix)\n", "ld_hl_ix_nopatch.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 2 opcodes
    REQUIRE(section->opcodes().size() == 3);

    // first opcode: { 0xDD, 0x6E, 0x00 } with no patch
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 3);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0xDD, 0x6E, 0x00 }));
    REQUIRE(op1->patches().size() == 0);

    // second opcode: { 0xDD, 0x66, 0x00 } with displacement patch +1
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 3);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0xDD, 0x66, 0x01 }));
    REQUIRE(op1->patches().size() == 0);
}

TEST_CASE("OpcodesParser: 'bool hl' expands to expected 7-opcode sequence with jr temp label",
          "[opcodes][bool][hl][patch][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("bool hl\n", "bool_hl.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: placeholder + 7 opcode entries (indexes 1..7)
    REQUIRE(section->opcodes().size() == 8);
    REQUIRE(section->opcodes()[0]->size() == 0); // placeholder

    // 1: { 0xF5 } no patches
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 1);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0xF5 }));
    REQUIRE(op1->patches().size() == 0);

    // 2: { 0x7C } no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0x7C }));
    REQUIRE(op2->patches().size() == 0);

    // 3: { 0xB5 } no patches
    auto* op3 = section->opcodes()[3].get();
    REQUIRE(op3->size() == 1);
    REQUIRE(op3->bytes() == std::vector<uint8_t>({ 0xB5 }));
    REQUIRE(op3->patches().size() == 0);

    // 4: { 0x28, 0x00 } with one JrOffset patch at offset 1, expression "<temp>-1"
    auto* op4 = section->opcodes()[4].get();
    REQUIRE(op4->size() == 2);
    REQUIRE(op4->bytes() == std::vector<uint8_t>({ 0x28, 0x00 }));
    const auto& patches4 = op4->patches();
    REQUIRE(patches4.size() == 1);
    const auto& patch4 = patches4[0];
    REQUIRE(patch4.range() == PatchRange::JrOffset);
    REQUIRE(patch4.offset() == 1);

    // extract temporary label name from expression text (format: "<label>-1")
    const std::string expr_text = patch4.expression().to_string();
    REQUIRE(!expr_text.empty());
    size_t dash = expr_text.find('-');
    REQUIRE(dash != std::string::npos);
    std::string temp_label_name = expr_text.substr(0, dash);
    REQUIRE(!temp_label_name.empty());
    REQUIRE(expr_text == temp_label_name + "-1");

    // 5: { 0x21, 0x01, 0x00 } no patches
    auto* op5 = section->opcodes()[5].get();
    REQUIRE(op5->size() == 3);
    REQUIRE(op5->bytes() == std::vector<uint8_t>({ 0x21, 0x01, 0x00 }));
    REQUIRE(op5->patches().size() == 0);

    // 6: { 0xF1 } no patches
    auto* op6 = section->opcodes()[6].get();
    REQUIRE(op6->size() == 1);
    REQUIRE(op6->bytes() == std::vector<uint8_t>({ 0xF1 }));
    REQUIRE(op6->patches().size() == 0);

    // 7: label placeholder (size 0) pointed by temp symbol
    auto* op7 = section->opcodes()[7].get();
    REQUIRE(op7->size() == 0);

    Symbol* temp_sym = module->get_symbol(temp_label_name);
    REQUIRE(temp_sym != nullptr);
    REQUIRE(temp_sym->is_address_relative());
    REQUIRE(temp_sym->opcode() == op7);
}

TEST_CASE("OpcodesParser: 'bool hl' on 8080 expands to expected 7-opcode sequence (8080 variant)",
          "[opcodes][bool][hl][8080][patch][symbol]") {
    // set CPU to 8080 for this test
    g_options = Options();
    g_options.cpu_id = CPU::i8080;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("bool hl\n", "bool_hl_8080.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // restore default options
    g_options = Options();

    // Expect: placeholder + 7 opcode entries (indexes 1..7)
    REQUIRE(section->opcodes().size() == 8);
    REQUIRE(section->opcodes()[0]->size() == 0); // placeholder

    // 1: { 0xF5 } no patches
    auto* op1 = section->opcodes()[1].get();
    REQUIRE(op1->size() == 1);
    REQUIRE(op1->bytes() == std::vector<uint8_t>({ 0xF5 }));
    REQUIRE(op1->patches().size() == 0);

    // 2: { 0x7C } no patches
    auto* op2 = section->opcodes()[2].get();
    REQUIRE(op2->size() == 1);
    REQUIRE(op2->bytes() == std::vector<uint8_t>({ 0x7C }));
    REQUIRE(op2->patches().size() == 0);

    // 3: { 0xB5 } no patches
    auto* op3 = section->opcodes()[3].get();
    REQUIRE(op3->size() == 1);
    REQUIRE(op3->bytes() == std::vector<uint8_t>({ 0xB5 }));
    REQUIRE(op3->patches().size() == 0);

    // 4 (8080 variant): { 0xCA, 0x00, 0x00 } with one Word patch at offset 1, expression "<temp_label>-1"
    auto* op4 = section->opcodes()[4].get();
    REQUIRE(op4->size() == 3);
    REQUIRE(op4->bytes() == std::vector<uint8_t>({ 0xCA, 0x00, 0x00 }));
    const auto& patches4 = op4->patches();
    REQUIRE(patches4.size() == 1);
    const auto& patch4 = patches4[0];
    REQUIRE(patch4.range() == PatchRange::Word);
    REQUIRE(patch4.offset() == 1);

    // expression text should be "<temp_label>-1" -> extract temp_label
    const std::string expr_text4 = patch4.expression().to_string();
    REQUIRE(!expr_text4.empty());
    size_t dash_pos4 = expr_text4.find('-');
    REQUIRE(dash_pos4 != std::string::npos);
    std::string temp_label_name4 = expr_text4.substr(0, dash_pos4);
    REQUIRE(expr_text4 == temp_label_name4 + "-1");

    // 5: { 0x21, 0x01, 0x00 } no patches
    auto* op5 = section->opcodes()[5].get();
    REQUIRE(op5->size() == 3);
    REQUIRE(op5->bytes() == std::vector<uint8_t>({ 0x21, 0x01, 0x00 }));
    REQUIRE(op5->patches().size() == 0);

    // 6: { 0xF1 } no patches
    auto* op6 = section->opcodes()[6].get();
    REQUIRE(op6->size() == 1);
    REQUIRE(op6->bytes() == std::vector<uint8_t>({ 0xF1 }));
    REQUIRE(op6->patches().size() == 0);

    // 7: label placeholder (size 0) pointed by temp symbol
    auto* op7 = section->opcodes()[7].get();
    REQUIRE(op7->size() == 0);

    Symbol* temp_sym4 = module->get_symbol(temp_label_name4);
    REQUIRE(temp_sym4 != nullptr);
    REQUIRE(temp_sym4->is_address_relative());
    REQUIRE(temp_sym4->opcode() == op7);
}

TEST_CASE("OpcodesParser: 'push 0x1234' on z80n assembles to CALL-like opcode with WordBigEndian patch",
          "[opcodes][push][z80n][patch][wordbigendian]") {
    g_options = Options();
    g_options.cpu_id = CPU::z80n;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("push 0x1234\n", "push_0x1234_z80n.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // There should be two opcodes: placeholder and the instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();

    // Expected bytes: { 0xED, 0x8A, 0x00, 0x00 }
    REQUIRE(op->size() == 4);
    REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xED, 0x8A, 0x00, 0x00 }));

    // One WordBigEndian patch at offset 2 with value 0x1234
    const auto& patches = op->patches();
    REQUIRE(patches.size() == 1);
    const auto& patch = patches[0];
    REQUIRE(patch.range() == PatchRange::WordBigEndian);
    REQUIRE(patch.offset() == 2);
    REQUIRE(patch.expression().evaluate() == 0x1234);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ldh a, (0xFF25)' on gbz80 emits HighOffset patch with 0xFF25",
          "[opcodes][gbz80][ldh][highoffset]") {
    g_options = Options();
    g_options.cpu_id = CPU::gbz80;

    Preprocessor pp;
    CompilationUnit unit;
    Section* section = unit.current_module()->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ldh a, (0xFF25)\n", "ldh_a_ff25_gbz80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // placeholder + instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xF0, 0x00 }));
    REQUIRE(op->patches().size() == 1);

    const auto& patch = op->patches()[0];
    REQUIRE(patch.range() == PatchRange::HighOffset);
    REQUIRE(patch.offset() == 1);
    REQUIRE(patch.expression().evaluate() == 0xFF25);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'ldh a, (0x25)' on gbz80 emits HighOffset patch with 0x25",
          "[opcodes][gbz80][ldh][highoffset][short]") {
    g_options = Options();
    g_options.cpu_id = CPU::gbz80;

    Preprocessor pp;
    CompilationUnit unit;
    Section* section = unit.current_module()->current_section();
    OpcodesParser parser(&unit);

    pp.push_virtual_file("ldh a, (0x25)\n", "ldh_a_25_gbz80.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // placeholder + instruction
    REQUIRE(section->opcodes().size() == 2);
    auto* op = section->opcodes()[1].get();
    REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xF0, 0x00 }));
    REQUIRE(op->patches().size() == 1);

    const auto& patch = op->patches()[0];
    REQUIRE(patch.range() == PatchRange::HighOffset);
    REQUIRE(patch.offset() == 1);
    REQUIRE(patch.expression().evaluate() == 0x25);

    g_options = Options();
}

TEST_CASE("OpcodesParser: label + jr loop emits label placeholder and jr with JrOffset patch",
    "[opcodes][label][jr][patch][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    module->add_label_symbol("loop", Location("jr_loop.asm", 1), 0); 
    pp.push_virtual_file("jr loop\n", "jr_loop.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: global placeholder + label placeholder + jr opcode
    REQUIRE(section->opcodes().size() == 3);

    // [0] global placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // [1] label placeholder for 'loop'
    auto* op_label = section->opcodes()[1].get();
    REQUIRE(op_label->size() == 0);
    REQUIRE(op_label->patches().size() == 0);

    // [2] jr opcode
    auto* op_jr = section->opcodes()[2].get();
    REQUIRE(op_jr->bytes() == std::vector<uint8_t>({ 0x18, 0x00 }));
    REQUIRE(op_jr->patches().size() == 1);
    const auto& patch = op_jr->patches()[0];
    REQUIRE(patch.range() == PatchRange::JrOffset);
    REQUIRE(patch.offset() == 1);
    REQUIRE(patch.expression().to_string() == "loop");

    // Symbol 'loop' must point to the label opcode
    Symbol* loop_sym = module->get_symbol("loop");
    REQUIRE(loop_sym != nullptr);
    REQUIRE(loop_sym->is_address_relative());
    REQUIRE(loop_sym->opcode() == op_label);
}

TEST_CASE("OpcodesParser: label + jre loop on r4k emits label placeholder and jre with JreOffset patch",
    "[opcodes][label][jre][r4k][patch][symbol]") {
    g_options = Options();
    g_options.cpu_id = CPU::r4k;

    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    OpcodesParser parser(&unit);

    module->add_label_symbol("loop", Location("jre_loop_r4k.asm", 1), 0);
    pp.push_virtual_file("jre loop\n", "jre_loop_r4k.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: global placeholder + label placeholder + jre opcode
    REQUIRE(section->opcodes().size() == 3);

    // [0] global placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // [1] label placeholder for 'loop'
    auto* op_label = section->opcodes()[1].get();
    REQUIRE(op_label->size() == 0);
    REQUIRE(op_label->patches().size() == 0);

    // [2] jre opcode
    auto* op_jre = section->opcodes()[2].get();
    REQUIRE(op_jre->bytes() == std::vector<uint8_t>({ 0x98, 0x00, 0x00 }));
    REQUIRE(op_jre->patches().size() == 1);
    const auto& patch = op_jre->patches()[0];
    REQUIRE(patch.range() == PatchRange::JreOffset);
    REQUIRE(patch.offset() == 1);
    REQUIRE(patch.expression().to_string() == "loop");

    // Symbol 'loop' must point to the label opcode
    Symbol* loop_sym = module->get_symbol("loop");
    REQUIRE(loop_sym != nullptr);
    REQUIRE(loop_sym->is_address_relative());
    REQUIRE(loop_sym->opcode() == op_label);

    g_options = Options();
}

TEST_CASE("OpcodesParser: 'bit N, (ix+4)' parses to correct opcode and displacement patch for N=1..7",
    "[opcodes][bit][ix][positive-offset][patch]") {
    for (int n = 1; n <= 7; ++n) {
        CAPTURE(n);
        Preprocessor pp;
        CompilationUnit unit;
        Section* section = unit.current_module()->current_section();
        OpcodesParser parser(&unit);

        std::ostringstream asm_src;
        asm_src << "bit " << n << ", (ix+4)\n";
        pp.push_virtual_file(asm_src.str(), "bit_ix_plus4.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(section->opcodes().size() == 2);
        auto* op = section->opcodes()[1].get();
        REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xDD, 0xCB, 0x00, static_cast<uint8_t>(0x46 + 8 * n) }));
        REQUIRE(op->patches().size() == 1);
        const auto& patch = op->patches()[0];
        REQUIRE(patch.range() == PatchRange::ByteSigned);
        REQUIRE(patch.offset() == 2);
        REQUIRE(patch.expression().evaluate() == 4);
    }
}

TEST_CASE("OpcodesParser: 'bit N, (ix-4)' parses to correct opcode and displacement patch for N=1..7",
    "[opcodes][bit][ix][negative-offset][patch]") {
    for (int n = 1; n <= 7; ++n) {
        CAPTURE(n);
        Preprocessor pp;
        CompilationUnit unit;
        Section* section = unit.current_module()->current_section();
        OpcodesParser parser(&unit);

        std::ostringstream asm_src;
        asm_src << "bit " << n << ", (ix-4)\n";
        pp.push_virtual_file(asm_src.str(), "bit_ix_minus4.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(section->opcodes().size() == 2);
        auto* op = section->opcodes()[1].get();
        REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xDD, 0xCB, 0x00, static_cast<uint8_t>(0x46 + 8 * n) }));
        REQUIRE(op->patches().size() == 1);
        const auto& patch = op->patches()[0];
        REQUIRE(patch.range() == PatchRange::ByteSigned);
        REQUIRE(patch.offset() == 2);
        REQUIRE(patch.expression().evaluate() == -4);
    }
}

TEST_CASE("OpcodesParser: 'bit N, (ix)' parses to correct opcode with no displacement patch for N=1..7",
    "[opcodes][bit][ix][no-patch]") {
    for (int n = 1; n <= 7; ++n) {
        CAPTURE(n);
        Preprocessor pp;
        CompilationUnit unit;
        Section* section = unit.current_module()->current_section();
        OpcodesParser parser(&unit);

        std::ostringstream asm_src;
        asm_src << "bit " << n << ", (ix)\n";
        pp.push_virtual_file(asm_src.str(), "bit_ix_nopatch.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(section->opcodes().size() == 2);
        auto* op = section->opcodes()[1].get();
        REQUIRE(op->bytes() == std::vector<uint8_t>({ 0xDD, 0xCB, 0x00, static_cast<uint8_t>(0x46 + 8 * n) }));
        REQUIRE(op->patches().size() == 0);
    }
}

TEST_CASE("OpcodesParser: 'rl N, bcde' on r4k assembles to single opcode with no patches for N={1,2,4}",
    "[opcodes][rl][bcde][r4k][no-patch]") {
    const int Ns[] = { 1, 2, 4 };
    for (int n : Ns) {
        CAPTURE(n);
        g_options = Options();
        g_options.cpu_id = CPU::r4k;

        Preprocessor pp;
        CompilationUnit unit;
        Section* section = unit.current_module()->current_section();
        OpcodesParser parser(&unit);

        std::ostringstream asm_src;
        asm_src << "rl " << n << ", bcde\n";
        pp.push_virtual_file(asm_src.str(), "rl_bcde_r4k.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        // placeholder + instruction
        REQUIRE(section->opcodes().size() == 2);
        auto* op = section->opcodes()[1].get();
        REQUIRE(op->bytes() ==
            std::vector<uint8_t>({ 0xDD, static_cast<uint8_t>(104 + n - 1) }));
        REQUIRE(op->patches().empty());
    }
    g_options = Options();
}
