//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
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

TEST_CASE("OpcodesParser: label-only line (leading dot token) returns false and reports error",
          "[opcodes][label-line][dot][error]") {
    SuppressErrors suppress;
    Preprocessor pp;
    CompilationUnit unit;

    // Label splitting will produce a line: '.' 'start' then an instruction line.
    pp.push_virtual_file("start: nop\n", "label_line.asm", 1, true);

    TokenLine line;
    // First line is label-only (dot plus label name)
    REQUIRE(pp.next_line(line));
    REQUIRE_FALSE(line.tokens().empty());
    REQUIRE(line.tokens().size() >= 2);
    REQUIRE(line.tokens()[0].text() == ".");
    REQUIRE(line.tokens()[1].text() == "start");

    OpcodesParser parser(&unit);
    const bool ok = parser.parse(line);
    REQUIRE_FALSE(ok);
    REQUIRE(g_errors.has_errors());

    const std::string msg = g_errors.last_error_message();
    REQUIRE(!msg.empty());
    REQUIRE(msg.find("Illegal opcode") != std::string::npos);
    REQUIRE(msg.find(".") != std::string::npos);
}

TEST_CASE("OpcodesParser: simple 'nop' instruction parses successfully (implementation pending)",
          "[opcodes][success][nop]") {
    SuppressErrors suppress;
    Preprocessor pp;
    CompilationUnit unit;

    pp.push_virtual_file("nop\n", "nop_ok.asm", 1, true);

    TokenLine line;
    REQUIRE(pp.next_line(line));
    REQUIRE_FALSE(line.tokens().empty());
    REQUIRE(line.tokens()[0].text() == "nop");

    OpcodesParser parser(&unit);
    bool ok = parser.parse(line);
    REQUIRE(ok);
    /*
    REQUIRE(pr.bytes.size() == 1);
    REQUIRE(pr.bytes[0] == 0x00); // NOP opcode byte
    REQUIRE(pr.placeholders.empty());
    REQUIRE(pr.constants.empty());
    */
}
