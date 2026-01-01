//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../parser.h"
#include "../preprocessor.h"
#include "../unit.h"
#include "catch_amalgamated.hpp"
#include <sstream>

TEST_CASE("Parser: label: generates placeholder opcode and symbol",
          "[parser][label][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    Parser parser(&unit);

    pp.push_virtual_file("loop:\n", "loop.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: global placeholder + label placeholder
    REQUIRE(section->opcodes().size() == 2);

    // [0] global placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // [1] label placeholder for 'loop'
    auto* op_label = section->opcodes()[1].get();
    REQUIRE(op_label->size() == 0);
    REQUIRE(op_label->patches().size() == 0);

    // Symbol 'loop' must point to the label opcode
    Symbol* loop_sym = module->get_symbol("loop");
    REQUIRE(loop_sym != nullptr);
    REQUIRE(loop_sym->is_address_relative());
    REQUIRE(loop_sym->opcode() == op_label);
}

TEST_CASE("Parser: .label generates placeholder opcode and symbol",
          "[parser][label][symbol]") {
    Preprocessor pp;
    CompilationUnit unit;
    Module* module = unit.current_module();
    Section* section = module->current_section();
    Parser parser(&unit);

    pp.push_virtual_file(".loop\n", "loop.asm", 1, true);

    TokenLine line;
    while (pp.next_line(line)) {
        REQUIRE(parser.parse(line));
    }

    // Expect: global placeholder + label placeholder
    REQUIRE(section->opcodes().size() == 2);

    // [0] global placeholder
    REQUIRE(section->opcodes()[0]->size() == 0);

    // [1] label placeholder for 'loop'
    auto* op_label = section->opcodes()[1].get();
    REQUIRE(op_label->size() == 0);
    REQUIRE(op_label->patches().size() == 0);

    // Symbol 'loop' must point to the label opcode
    Symbol* loop_sym = module->get_symbol("loop");
    REQUIRE(loop_sym != nullptr);
    REQUIRE(loop_sym->is_address_relative());
    REQUIRE(loop_sym->opcode() == op_label);
}

