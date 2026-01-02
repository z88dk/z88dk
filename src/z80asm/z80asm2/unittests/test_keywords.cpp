//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../keywords.h"
#include "catch_amalgamated.hpp"
#include <cctype>

TEST_CASE("keyword_lookup converts strings to Keyword enum",
          "[keyword_lookup]") {
    REQUIRE(keyword_lookup("LD") == Keyword::LD);
    REQUIRE(keyword_lookup("ld") == Keyword::LD);
    REQUIRE(keyword_lookup("Ld") == Keyword::LD);
    REQUIRE(keyword_lookup("AF") == Keyword::AF);
    REQUIRE(keyword_lookup("af") == Keyword::AF);
    REQUIRE(keyword_lookup("Af") == Keyword::AF);
    REQUIRE(keyword_lookup("AF'") == Keyword::AF_);
    REQUIRE(keyword_lookup("af'") == Keyword::AF_);
    REQUIRE(keyword_lookup("Af'") == Keyword::AF_);
    REQUIRE(keyword_lookup("NONEXISTENT") == Keyword::None);
    REQUIRE(keyword_lookup("") == Keyword::None);
}

TEST_CASE("keyword_is_preproc_directive recognizes directive keywords",
          "[keyword_is_preproc_directive]") {
    const std::vector<std::string> directives = {
        "MACRO", "ENDM", "DEFINE", "DEFL", "INCLUDE", "UNDEF",
        "LINE", "EXITM"
    };

    for (const auto& d : directives) {
        INFO("directive: " << d);
        REQUIRE(keyword_is_preproc_directive(keyword_lookup(d)));

        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_preproc_directive(keyword_lookup(lower)));
    }

    REQUIRE_FALSE(keyword_is_preproc_directive(keyword_lookup("LD")));
    REQUIRE_FALSE(keyword_is_preproc_directive(keyword_lookup("AF")));
    REQUIRE_FALSE(keyword_is_preproc_directive(keyword_lookup("NONEXISTENT")));
}

TEST_CASE("keyword_to_string returns the keyword text", "[keyword_to_string]") {
    REQUIRE(keyword_to_string(Keyword::None) == "None");
    REQUIRE(keyword_to_string(Keyword::LD) == "LD");
    REQUIRE(keyword_to_string(Keyword::AF) == "AF");
    REQUIRE(keyword_to_string(Keyword::AF_) == "AF'");
    REQUIRE(keyword_to_string(Keyword::DEFINE) == "DEFINE");
    REQUIRE(keyword_to_string(Keyword::REPT) == "REPT");
}

TEST_CASE("keyword_is_asm_directive recognizes assembly directive keywords",
          "[keyword_is_asm_directive]") {
    const std::vector<std::string> directives = { "DEFB", "DEFW", "DEFM", "DEFS" };

    for (const auto& d : directives) {
        INFO("asm directive: " << d);
        REQUIRE(keyword_is_asm_directive(keyword_lookup(d)));

        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_asm_directive(keyword_lookup(lower)));
    }

    REQUIRE_FALSE(keyword_is_asm_directive(keyword_lookup("LD")));
    REQUIRE_FALSE(keyword_is_asm_directive(keyword_lookup("MACRO")));
    REQUIRE_FALSE(keyword_is_asm_directive(keyword_lookup("NONEXISTENT")));
}

TEST_CASE("keyword_is_x_register recognizes X-register family",
          "[keyword_is_x_register]") {
    const std::vector<std::string> xregs = {
        "IX", "IXH", "IXL", "IY", "IYH", "IYL",
        "AIX", "AIY", "PIX", "PIY",
        "XIX", "XIY", "YIX", "YIY",
        "ZIX", "ZIY"
    };

    for (const auto& r : xregs) {
        INFO("x-reg: " << r);
        REQUIRE(keyword_is_x_register(keyword_lookup(r)));

        std::string lower = r;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_x_register(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_xregs = {
        "A", "B", "AF", "BC", "XP", "ZP", "NZ", "LD", "NONEXISTENT"
    };

    for (const auto& r : non_xregs) {
        INFO("non-x-reg: " << r);
        REQUIRE_FALSE(keyword_is_x_register(keyword_lookup(r)));
    }
}

TEST_CASE("keyword_directive_has_file_arg recognizes directives with file operands",
          "[keyword_directive_has_file_arg]") {
    const std::vector<std::string> file_directives = {
        "INCLUDE", "BINARY", "INCBIN", "LINE", "C_LINE"
    };

    for (const auto& d : file_directives) {
        INFO("file directive: " << d);
        REQUIRE(keyword_directive_has_file_arg(keyword_lookup(d)));

        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_directive_has_file_arg(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_file_directives = {
        "MACRO", "DEFINE", "DEFL", "REPT", "DEFB", "LD", "NONEXISTENT"
    };

    for (const auto& d : non_file_directives) {
        INFO("non-file directive: " << d);
        REQUIRE_FALSE(keyword_directive_has_file_arg(keyword_lookup(d)));
    }
}

TEST_CASE("keyword_is_conditional_directive recognizes conditional directives",
          "[keyword_is_conditional_directive]") {
    const std::vector<std::string> cond_directives = {
        "IF", "IFDEF", "IFNDEF", "ELSE", "ELSEIF", "ENDIF"
    };
    for (const auto& d : cond_directives) {
        INFO("conditional directive: " << d);
        REQUIRE(keyword_is_conditional_directive(keyword_lookup(d)));

        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_conditional_directive(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_cond_directives = {
        "MACRO", "DEFINE", "DEFL", "REPT", "DEFB", "LD", "NONEXISTENT"
    };
    for (const auto& d : non_cond_directives) {
        INFO("non-conditional directive: " << d);
        REQUIRE_FALSE(keyword_is_conditional_directive(keyword_lookup(d)));
    }
}

TEST_CASE("keyword_is_register recognizes register keywords",
          "[keyword_is_register]") {
    const std::vector<std::string> registers = {
        "A", "B", "C", "D", "E", "H", "L",
        "AF", "BC", "DE", "HL",
        "IX", "IY",
        "SP"
    };
    for (const auto& r : registers) {
        INFO("register: " << r);
        REQUIRE(keyword_is_register(keyword_lookup(r)));

        std::string lower = r;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_register(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_registers = {
        "LD", "MACRO", "DEFINE", "DEFB", "NONEXISTENT"
    };
    for (const auto& r : non_registers) {
        INFO("non-register: " << r);
        REQUIRE_FALSE(keyword_is_register(keyword_lookup(r)));
    }
}

TEST_CASE("keyword_is_opcode recognizes opcode keywords",
          "[keyword_is_opcode]") {
    const std::vector<std::string> opcodes = {
        "LD", "ADD", "SUB", "AND", "OR", "XOR", "JP", "CALL", "RET",
        "INC", "DEC", "NOP", "HALT", "DI", "EI"
    };
    for (const auto& op : opcodes) {
        INFO("opcode: " << op);
        REQUIRE(keyword_is_opcode(keyword_lookup(op)));

        std::string lower = op;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_opcode(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_opcodes = {
        "A", "B", "MACRO", "DEFINE", "DEFB", "NONEXISTENT"
    };
    for (const auto& op : non_opcodes) {
        INFO("non-opcode: " << op);
        REQUIRE_FALSE(keyword_is_opcode(keyword_lookup(op)));
    }
}

TEST_CASE("keyword_is_flag recognizes flag keywords",
          "[keyword_is_flag]") {
    const std::vector<std::string> flags = {
        "Z", "NZ", "C", "NC", "M", "P", "PE", "PO"
    };
    for (const auto& f : flags) {
        INFO("flag: " << f);
        REQUIRE(keyword_is_flag(keyword_lookup(f)));

        std::string lower = f;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_flag(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_flags = {
        "A", "B", "LD", "MACRO", "DEFINE", "DEFB", "NONEXISTENT"
    };
    for (const auto& f : non_flags) {
        INFO("non-flag: " << f);
        REQUIRE_FALSE(keyword_is_flag(keyword_lookup(f)));
    }
}

TEST_CASE("keyword_is_8bit_register recognizes 8-bit register keywords",
          "[keyword_is_8bit_register]") {
    const std::vector<std::string> regs_8bit = { "A", "B", "C", "D", "E", "H", "L" };
    for (const auto& r : regs_8bit) {
        INFO("8-bit register: " << r);
        REQUIRE(keyword_is_8bit_register(keyword_lookup(r)));

        std::string lower = r;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_8bit_register(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_regs_8bit = {
        "AF", "BC", "DE", "HL", "IX", "IY", "SP", "PC",
        "LD", "MACRO", "DEFINE", "DEFB", "NONEXISTENT"
    };
    for (const auto& r : non_regs_8bit) {
        INFO("non-8-bit register: " << r);
        REQUIRE_FALSE(keyword_is_8bit_register(keyword_lookup(r)));
    }
}

TEST_CASE("keyword_is_segment_register recognizes segment register keywords",
          "[keyword_is_segment_register]") {
    const std::vector<std::string> seg_regs = { "A", "PP", "XP", "YP", "ZP" };
    for (const auto& r : seg_regs) {
        INFO("segment register: " << r);
        REQUIRE(keyword_is_segment_register(keyword_lookup(r)));

        std::string lower = r;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_segment_register(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_seg_regs = {
        "B", "C", "LD", "MACRO", "DEFINE", "DEFB", "NONEXISTENT"
    };
    for (const auto& r : non_seg_regs) {
        INFO("non-segment register: " << r);
        REQUIRE_FALSE(keyword_is_segment_register(keyword_lookup(r)));
    }
}

TEST_CASE("keyword_is_preproc_name_directive recognizes name directives",
          "[keyword_is_preproc_name_directive]") {
    const std::vector<std::string> name_directives = {
        "DEFINE", "DEFL", "MACRO", "REPTC", "REPTI", "DEFC", "EQU"
    };
    for (const auto& d : name_directives) {
        INFO("name directive: " << d);
        REQUIRE(keyword_is_preproc_name_directive(keyword_lookup(d)));

        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_preproc_name_directive(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_name_directives = {
        "INCLUDE", "IF", "DEFB", "LD", "A", "NONEXISTENT"
    };
    for (const auto& d : non_name_directives) {
        INFO("non-name directive: " << d);
        REQUIRE_FALSE(keyword_is_preproc_name_directive(keyword_lookup(d)));
    }
}

TEST_CASE("keyword_is_hla_directive recognizes HLA directives",
          "[keyword_is_hla_directive]") {
    const std::vector<std::string> hla_directives = {
        "IF", "ELIF", "ELSE", "ENDIF",
        "WHILE", "WEND", "REPEAT", "UNTIL", "UNTILB", "UNTILBC",
        "BREAK", "CONTINUE"
    };
    for (const auto& d : hla_directives) {
        INFO("HLA directive: " << d);
        REQUIRE(keyword_is_hla_directive(keyword_lookup(d)));

        std::string lower = d;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_hla_directive(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_hla_directives = {
        "INCLUDE", "DEFB", "LD", "A", "NONEXISTENT"
    };
    for (const auto& d : non_hla_directives) {
        INFO("non-HLA directive: " << d);
        REQUIRE_FALSE(keyword_is_hla_directive(keyword_lookup(d)));
    }
}

TEST_CASE("keyword_is_instruction matches any instruction-like keyword",
          "[keyword_is_instruction]") {
    const std::vector<std::string> instructions = {
        "INCLUDE", // preproc directive
        "DEFINE",  // preproc name directive
        "IF",      // conditional directive
        "DEFB",    // asm directive
        "LD"       // opcode
    };
    for (const auto& k : instructions) {
        INFO("instruction: " << k);
        REQUIRE(keyword_is_instruction(keyword_lookup(k)));

        std::string lower = k;
        for (auto& ch : lower) {
            ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
        }
        REQUIRE(keyword_is_instruction(keyword_lookup(lower)));
    }

    const std::vector<std::string> non_instructions = {
        "A", "Z", "PP", "NONEXISTENT"
    };
    for (const auto& k : non_instructions) {
        INFO("non-instruction: " << k);
        REQUIRE_FALSE(keyword_is_instruction(keyword_lookup(k)));
    }
}

