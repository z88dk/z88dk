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

