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
    REQUIRE(msg.find("Illegal opcode") != std::string::npos);
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
