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

TEST_CASE("Parser: DEFB/DB emit placeholder bytes and patches", "[parser][defb][db]") {
    const std::vector<std::string> kws = {
        "DEFB", "DB", "DEFM", "DM", "BYTE"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        // Use an expression to ensure evaluation works too
        std::string src = kw + std::string(" 1, 2+1, 3\n");
        pp.push_virtual_file(src, "data.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 3);
        REQUIRE(op->bytes()[0] == 0);
        REQUIRE(op->bytes()[1] == 0);
        REQUIRE(op->bytes()[2] == 0);

        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 1);
        REQUIRE(patches[2].offset() == 2);
        REQUIRE(patches[0].range() == PatchRange::ByteUnsigned);
        REQUIRE(patches[1].range() == PatchRange::ByteUnsigned);
        REQUIRE(patches[2].range() == PatchRange::ByteUnsigned);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 3); // 2+1
        REQUIRE(patches[2].expression().evaluate() == 3);
    }
}

TEST_CASE("Parser: DEFB/DB ignore extra commas", "[parser][defb][db][commas]") {
    const std::vector<std::string> kws = {
        "DEFB", "DB", "DEFM", "DM", "BYTE"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" ,,,1,,,2,, ,3,,,\n");
        pp.push_virtual_file(src, "data_commas.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 3);
        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 1);
        REQUIRE(patches[2].offset() == 2);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 2);
        REQUIRE(patches[2].expression().evaluate() == 3);
    }
}

TEST_CASE("Parser: DEFB/DB empty body produces zero-sized opcode", "[parser][defb][db][empty]") {
    const std::vector<std::string> kws = {
        "DEFB", "DB", "DEFM", "DM", "BYTE"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" \n");
        pp.push_virtual_file(src, "data_empty.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 0);
        REQUIRE(op->patches().size() == 0);
    }
}

TEST_CASE("Parser: DEFB/DB report expression syntax errors",
          "[parser][defb][db][errors]") {
    const std::vector<std::string> kws = {
        "DEFB", "DB", "DEFM", "DM", "BYTE"
    };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        // Invalid expression after comma
        std::string src = kw + std::string(" 1+*3 \n");
        pp.push_virtual_file(src, "data_err.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(g_errors.error_count() == 1);
        REQUIRE_THAT(g_errors.last_error_message(),
                     Catch::Matchers::ContainsSubstring("Invalid expression"));

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();
        REQUIRE(op->size() == 0);
        REQUIRE(op->patches().size() == 0);
    }
}

TEST_CASE("Parser: DEFB/DB report unexpected tokens after expression",
          "[parser][defb][db][errors]") {
    const std::vector<std::string> kws = {
        "DEFB", "DB", "DEFM", "DM", "BYTE"
    };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);
        // Extra token after expression
        std::string src = kw + std::string(" 1 EXTRA\n");
        pp.push_virtual_file(src, "data_err2.asm", 1, true);
        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }
        REQUIRE(g_errors.error_count() == 1);
        REQUIRE_THAT(g_errors.last_error_message(),
                     Catch::Matchers::ContainsSubstring(
                         "Expected ',' between expressions"));
        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();
        const auto& patches = op->patches();
        REQUIRE(op->size() == 1);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[0].expression().evaluate() == 1);
    }
}

TEST_CASE("Parser: DEFW/DW/WORD emit placeholder words and patches", "[parser][defw][dw][word]") {
    const std::vector<std::string> kws = { "DEFW", "DW", "WORD" };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1, 2+1, 0x1234\n");
        pp.push_virtual_file(src, "data_word.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 6); // 3 words * 2 bytes
        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 2);
        REQUIRE(patches[2].offset() == 4);
        REQUIRE(patches[0].range() == PatchRange::Word);
        REQUIRE(patches[1].range() == PatchRange::Word);
        REQUIRE(patches[2].range() == PatchRange::Word);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 3);
        REQUIRE(patches[2].expression().evaluate() == 0x1234);
    }
}

TEST_CASE("Parser: DEFW/DW/WORD ignore extra commas", "[parser][defw][dw][word][commas]") {
    const std::vector<std::string> kws = { "DEFW", "DW", "WORD" };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" ,,,1,,,2,, ,3,,,\n");
        pp.push_virtual_file(src, "data_commas_word.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 6);
        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 2);
        REQUIRE(patches[2].offset() == 4);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 2);
        REQUIRE(patches[2].expression().evaluate() == 3);
    }
}

TEST_CASE("Parser: DEFW/DW/WORD empty body produces zero-sized opcode", "[parser][defw][dw][word][empty]") {
    const std::vector<std::string> kws = { "DEFW", "DW", "WORD" };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" \n");
        pp.push_virtual_file(src, "data_empty_word.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 0);
        REQUIRE(op->patches().size() == 0);
    }
}

TEST_CASE("Parser: DEFW/DW/WORD report expression syntax errors",
    "[parser][defw][dw][word][errors]") {
    const std::vector<std::string> kws = { "DEFW", "DW", "WORD" };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1+*2 \n");
        pp.push_virtual_file(src, "data_err_word.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(g_errors.error_count() == 1);
        REQUIRE_THAT(g_errors.last_error_message(),
            Catch::Matchers::ContainsSubstring("Invalid expression"));

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();
        REQUIRE(op->size() == 0);
        REQUIRE(op->patches().size() == 0);
    }
}

