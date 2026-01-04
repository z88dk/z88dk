//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../options.h"
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
    const std::vector<std::string> kws = {
        "DEFW", "DW", "WORD"
    };

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
    const std::vector<std::string> kws = {
        "DEFW", "DW", "WORD"
    };

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
    const std::vector<std::string> kws = {
        "DEFW", "DW", "WORD"
    };

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
    const std::vector<std::string> kws = {
        "DEFW", "DW", "WORD"
    };

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

TEST_CASE("Parser: DEFP/DP/PTR emit placeholder ptr24 values and patches",
          "[parser][defp][dp][ptr]") {
    const std::vector<std::string> kws = {
        "DEFP", "DP", "PTR"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1, 2+1, 0x123456\n");
        pp.push_virtual_file(src, "data_ptr24.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 9); // 3 entries * 3 bytes
        REQUIRE(op->bytes()[0] == 0);
        REQUIRE(op->bytes()[1] == 0);
        REQUIRE(op->bytes()[2] == 0);
        REQUIRE(op->bytes()[3] == 0);
        REQUIRE(op->bytes()[4] == 0);
        REQUIRE(op->bytes()[5] == 0);
        REQUIRE(op->bytes()[6] == 0);
        REQUIRE(op->bytes()[7] == 0);
        REQUIRE(op->bytes()[8] == 0);

        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 3);
        REQUIRE(patches[2].offset() == 6);
        REQUIRE(patches[0].range() == PatchRange::Ptr24);
        REQUIRE(patches[1].range() == PatchRange::Ptr24);
        REQUIRE(patches[2].range() == PatchRange::Ptr24);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 3);       // 2+1
        REQUIRE(patches[2].expression().evaluate() == 0x123456);
    }
}

TEST_CASE("Parser: DEFQ/DQ/DWORD emit placeholder dwords and patches",
          "[parser][defq][dq][dword]") {
    const std::vector<std::string> kws = {
        "DEFQ", "DQ", "DWORD"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1, 2+1, 0x12345678\n");
        pp.push_virtual_file(src, "data_dword.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 12); // 3 dwords * 4 bytes
        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 4);
        REQUIRE(patches[2].offset() == 8);
        REQUIRE(patches[0].range() == PatchRange::Dword);
        REQUIRE(patches[1].range() == PatchRange::Dword);
        REQUIRE(patches[2].range() == PatchRange::Dword);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 3);
        REQUIRE(patches[2].expression().evaluate() == 0x12345678);
    }
}

TEST_CASE("Parser: DEFQ/DQ/DWORD ignore extra commas",
          "[parser][defq][dq][dword][commas]") {
    const std::vector<std::string> kws = {
        "DEFQ", "DQ", "DWORD"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" ,,,1,,,2,, ,3,,,\n");
        pp.push_virtual_file(src, "data_commas_dword.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 12);
        const auto& patches = op->patches();
        REQUIRE(patches.size() == 3);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[1].offset() == 4);
        REQUIRE(patches[2].offset() == 8);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 2);
        REQUIRE(patches[2].expression().evaluate() == 3);
    }
}

TEST_CASE("Parser: DEFQ/DQ/DWORD empty body produces zero-sized opcode",
          "[parser][defq][dq][dword][empty]") {
    const std::vector<std::string> kws = {
        "DEFQ", "DQ", "DWORD"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" \n");
        pp.push_virtual_file(src, "data_empty_dword.asm", 1, true);

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

TEST_CASE("Parser: DEFQ/DQ/DWORD report expression syntax errors",
          "[parser][defq][dq][dword][errors]") {
    const std::vector<std::string> kws = {
        "DEFQ", "DQ", "DWORD"
    };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1+*3 \n");
        pp.push_virtual_file(src, "data_err_dword.asm", 1, true);

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

TEST_CASE("Parser: DEFQ/DQ/DWORD report unexpected tokens after expression",
          "[parser][defq][dq][dword][errors]") {
    const std::vector<std::string> kws = {
        "DEFQ", "DQ", "DWORD"
    };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1 EXTRA\n");
        pp.push_virtual_file(src, "data_err2_dword.asm", 1, true);

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
        REQUIRE(op->size() == 4);
        REQUIRE(patches.size() == 1);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[0].expression().evaluate() == 1);
    }
}

TEST_CASE("Parser: DEFW_BE/DW_BE/DEFDB/DDB emit placeholder big-endian words and patches",
          "[parser][defw_be][dw_be][defdb][ddb]") {
    const std::vector<std::string> kws = {
        "DEFW_BE", "DW_BE", "DEFDB", "DDB"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1, 2+1, 0x1234\n");
        pp.push_virtual_file(src, "data_word_be.asm", 1, true);

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
        REQUIRE(patches[0].range() == PatchRange::WordBigEndian);
        REQUIRE(patches[1].range() == PatchRange::WordBigEndian);
        REQUIRE(patches[2].range() == PatchRange::WordBigEndian);
        REQUIRE(patches[0].expression().evaluate() == 1);
        REQUIRE(patches[1].expression().evaluate() == 3);
        REQUIRE(patches[2].expression().evaluate() == 0x1234);
    }
}

TEST_CASE("Parser: DEFW_BE/DW_BE/DEFDB/DDB ignore extra commas",
          "[parser][defw_be][dw_be][defdb][ddb][commas]") {
    const std::vector<std::string> kws = {
        "DEFW_BE", "DW_BE", "DEFDB", "DDB"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" ,,,1,,,2,, ,3,,,\n");
        pp.push_virtual_file(src, "data_commas_word_be.asm", 1, true);

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

TEST_CASE("Parser: DEFW_BE/DW_BE/DEFDB/DDB empty body produces zero-sized opcode",
          "[parser][defw_be][dw_be][defdb][ddb][empty]") {
    const std::vector<std::string> kws = {
        "DEFW_BE", "DW_BE", "DEFDB", "DDB"
    };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" \n");
        pp.push_virtual_file(src, "data_empty_word_be.asm", 1, true);

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

TEST_CASE("Parser: DEFW_BE/DW_BE/DEFDB/DDB report expression syntax errors",
          "[parser][defw_be][dw_be][defdb][ddb][errors]") {
    const std::vector<std::string> kws = {
        "DEFW_BE", "DW_BE", "DEFDB", "DDB"
    };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1+*2 \n");
        pp.push_virtual_file(src, "data_err_word_be.asm", 1, true);

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

TEST_CASE("Parser: DEFW_BE/DW_BE/DEFDB/DDB report unexpected tokens after expression",
          "[parser][defw_be][dw_be][defdb][ddb][errors]") {
    const std::vector<std::string> kws = {
        "DEFW_BE", "DW_BE", "DEFDB", "DDB"
    };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        std::string src = kw + std::string(" 1 EXTRA\n");
        pp.push_virtual_file(src, "data_err2_word_be.asm", 1, true);

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
        REQUIRE(op->size() == 2);
        REQUIRE(patches.size() == 1);
        REQUIRE(patches[0].offset() == 0);
        REQUIRE(patches[0].range() == PatchRange::WordBigEndian);
        REQUIRE(patches[0].expression().evaluate() == 1);
    }
}

TEST_CASE("Parser: DEFS/DS reserve count uses filler", "[parser][defs][ds][filler]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string(" 4\n"), "defs_fill.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 4);
        REQUIRE(op->patches().empty());
        const auto& bytes = op->bytes();
        REQUIRE(bytes.size() == 4);
        for (size_t i = 1; i < bytes.size(); ++i) {
            REQUIRE(bytes[i] == bytes[0]); // all filled with the same filler byte
        }
    }
}

TEST_CASE("Parser: DEFS/DS supports explicit filler byte", "[parser][defs][ds][filler]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string(" 3, -1\n"), "defs_filler.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 3);
        REQUIRE(op->patches().empty());
        REQUIRE(op->bytes()[0] == 0xFF);
        REQUIRE(op->bytes()[1] == 0xFF);
        REQUIRE(op->bytes()[2] == 0xFF);
    }
}

TEST_CASE("Parser: DEFS/DS copies inline byte data when count matches", "[parser][defs][ds][data]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string(" 3, 1, 2, 3\n"), "defs_data.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 3);
        REQUIRE(op->patches().empty());
        REQUIRE(op->bytes()[0] == 1);
        REQUIRE(op->bytes()[1] == 2);
        REQUIRE(op->bytes()[2] == 3);
    }
}

TEST_CASE("Parser: DEFS/DS requires at least one expression", "[parser][defs][ds][errors]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string("\n"), "defs_empty.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(g_errors.error_count() == 1);
        REQUIRE_THAT(g_errors.last_error_message(),
                     Catch::Matchers::ContainsSubstring("requires at least one expression"));

        // No opcode should be emitted when the directive is invalid
        REQUIRE(section->opcodes().size() == 1);
    }
}

TEST_CASE("Parser: DEFS/DS errors when data exceeds reserved size", "[parser][defs][ds][errors]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string(" 2, 1, 2, 3\n"), "defs_overflow.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(g_errors.error_count() == 1);
        REQUIRE_THAT(g_errors.last_error_message(),
                     Catch::Matchers::ContainsSubstring("String longer than reserved space"));
        REQUIRE(section->opcodes().size() == 1);
    }
}

TEST_CASE("Parser: DEFS/DS validates filler range", "[parser][defs][ds][errors]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    for (const auto& kw : kws) {
        SuppressErrors silence;
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string(" 2, 300\n"), "defs_filler_range.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        REQUIRE(g_errors.error_count() == 1);
        REQUIRE_THAT(g_errors.last_error_message(),
                     Catch::Matchers::ContainsSubstring("Integer out of range"));
        REQUIRE(section->opcodes().size() == 1);
    }
}

TEST_CASE("Parser: DEFS/DS uses g_options filler when only count is provided",
          "[parser][defs][ds][filler][g_options]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    const uint8_t saved_filler = g_options.filler_byte;
    const uint8_t filler1 = 0xA5;
    const uint8_t filler2 = 0x3C;

    for (auto filler : {
                filler1, filler2
            }) {
        g_options.filler_byte = filler;

        for (const auto& kw : kws) {
            Preprocessor pp;
            CompilationUnit unit;
            Module* module = unit.current_module();
            Section* section = module->current_section();
            Parser parser(&unit);

            pp.push_virtual_file(kw + std::string(" 3\n"), "defs_default_filler.asm", 1, true);

            TokenLine line;
            while (pp.next_line(line)) {
                REQUIRE(parser.parse(line));
            }

            const auto& ops = section->opcodes();
            REQUIRE(ops.size() == 2); // sentinel + directive
            const Opcode* op = ops[1].get();

            REQUIRE(op->size() == 3);
            REQUIRE(op->patches().empty());
            const auto& bytes = op->bytes();
            REQUIRE(bytes.size() == 3);
            for (uint8_t b : bytes) {
                REQUIRE(b == filler);
            }
        }
    }

    g_options.filler_byte = saved_filler;
}

TEST_CASE("Parser: DEFS/DS fills remainder with g_options filler when data is shorter",
          "[parser][defs][ds][filler][string]") {
    const std::vector<std::string> kws = { "DEFS", "DS" };

    const uint8_t saved_filler = g_options.filler_byte;
    const uint8_t filler = 0xEE;
    g_options.filler_byte = filler;

    for (const auto& kw : kws) {
        Preprocessor pp;
        CompilationUnit unit;
        Module* module = unit.current_module();
        Section* section = module->current_section();
        Parser parser(&unit);

        pp.push_virtual_file(kw + std::string(" 5, \"AB\"\n"), "defs_string_pad.asm", 1, true);

        TokenLine line;
        while (pp.next_line(line)) {
            REQUIRE(parser.parse(line));
        }

        const auto& ops = section->opcodes();
        REQUIRE(ops.size() == 2); // sentinel + directive
        const Opcode* op = ops[1].get();

        REQUIRE(op->size() == 5);
        REQUIRE(op->patches().empty());
        const auto& bytes = op->bytes();
        REQUIRE(bytes.size() == 5);
        REQUIRE(bytes[0] == 'A');
        REQUIRE(bytes[1] == 'B');
        REQUIRE(bytes[2] == filler);
        REQUIRE(bytes[3] == filler);
        REQUIRE(bytes[4] == filler);
    }

    g_options.filler_byte = saved_filler;
}

