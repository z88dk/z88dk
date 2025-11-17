//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../hla.h"
#include "../symbol_table.h"
#include "catch_amalgamated.hpp"
#include <filesystem>
#include <fstream>
#include <sstream>

// Capture std::cerr during tests to avoid noisy output
namespace {
struct StderrSilencer {
    StderrSilencer() : old_buf(std::cerr.rdbuf(stream.rdbuf())) {}
    ~StderrSilencer() {
        std::cerr.rdbuf(old_buf);
    }
    std::string str() const {
        return stream.str();
    }
private:
    std::ostringstream stream;
    std::streambuf* old_buf = nullptr;
};
static StderrSilencer g_stderr_silencer;
}

static std::vector<TokensLine> run_hla_on_text(const std::string& src,
        const std::string& fname) {
    HLA hla;
    hla.clear();
    hla.push_virtual_file(src, fname, 1, true);

    TokensLine line;
    std::vector<TokensLine> out;
    while (hla.next_line(line)) {
        if (!line.empty()) {
            out.push_back(line);
        }
    }

    return out;
}

static void expect_cp_imm(const TokensLine& l, int imm) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(Keyword::CP));
    REQUIRE(l[1].is(TokenType::Integer));
    REQUIRE(l[1].int_value() == imm);
}

static void expect_jp_cond_label(const TokensLine& l, Keyword cond,
                                 const std::string& label) {
    REQUIRE(l.size() == 4);
    REQUIRE(l[0].is(Keyword::JP));
    REQUIRE(l[1].is(cond));
    REQUIRE(l[2].is(TokenType::Comma));
    REQUIRE(l[3].is(TokenType::Identifier));
    REQUIRE(l[3].text() == label);
}

static void expect_jp_label(const TokensLine& l, const std::string& label) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(Keyword::JP));
    REQUIRE(l[1].is(TokenType::Identifier));
    REQUIRE(l[1].text() == label);
}

static void expect_dot_label_def(const TokensLine& l,
                                 const std::string& label) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(TokenType::Dot));
    REQUIRE(l[1].is(TokenType::Identifier));
    REQUIRE(l[1].text() == label);
}

static void expect_nop(const TokensLine& l) {
    REQUIRE(l.size() >= 1);
    REQUIRE(l[0].is(Keyword::NOP));
}

static void expect_cp_reg(const TokensLine& l, Keyword reg) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(Keyword::CP));
    REQUIRE(l[1].is(reg));
}

static void expect_cp_mem_hl(const TokensLine& l) {
    REQUIRE(l.size() == 4);
    REQUIRE(l[0].is(Keyword::CP));
    REQUIRE(l[1].is(TokenType::LeftParen));
    REQUIRE(l[2].is(Keyword::HL));
    REQUIRE(l[3].is(TokenType::RightParen));
}

static void expect_cp_mem_abs(const TokensLine& l, int addr) {
    REQUIRE(l.size() == 4);
    REQUIRE(l[0].is(Keyword::CP));
    REQUIRE(l[1].is(TokenType::LeftParen));
    REQUIRE(l[2].is(TokenType::Integer));
    REQUIRE(l[2].int_value() == addr);
    REQUIRE(l[3].is(TokenType::RightParen));
}

static std::string expect_jp_cond_any_label(const TokensLine& l, Keyword cond) {
    REQUIRE(l.size() == 4);
    REQUIRE(l[0].is(Keyword::JP));
    REQUIRE(l[1].is(cond));
    REQUIRE(l[2].is(TokenType::Comma));
    REQUIRE(l[3].is(TokenType::Identifier));
    return l[3].text();
}

static void expect_dec_bc(const TokensLine& l) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(Keyword::DEC));
    REQUIRE(l[1].is(Keyword::BC));
}
static void expect_ld_a_b(const TokensLine& l) {
    REQUIRE(l.size() == 4);
    REQUIRE(l[0].is(Keyword::LD));
    REQUIRE(l[1].is(Keyword::A));
    REQUIRE(l[2].is(TokenType::Comma));
    REQUIRE(l[3].is(Keyword::B));
}
static void expect_or_c(const TokensLine& l) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(Keyword::OR));
    REQUIRE(l[1].is(Keyword::C));
}

static void expect_dec_b(const TokensLine& l) {
    REQUIRE(l.size() == 2);
    REQUIRE(l[0].is(Keyword::DEC));
    REQUIRE(l[1].is(Keyword::B));
}

TEST_CASE("HLA passes through plain assembly without HLA directives unchanged",
          "[hla]") {
    namespace fs = std::filesystem;

    // Prepare a temporary source file with plain Z80 assembly lines
    const std::string src =
        "LD A, B\n"
        "ADD A, 1\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_plain.asm");
    REQUIRE(lines.size() >= 2);

    // Line 1: LD A,B
    {
        const auto& l = lines[0];
        REQUIRE(l.size() == 4);
        REQUIRE(l[0].is(Keyword::LD));
        REQUIRE(l[1].is(Keyword::A));
        REQUIRE(l[2].is(TokenType::Comma));
        REQUIRE(l[3].is(Keyword::B));
    }

    // Line 2: ADD A,1
    {
        const auto& l = lines[1];
        REQUIRE(l.size() == 4);
        REQUIRE(l[0].is(Keyword::ADD));
        REQUIRE(l[1].is(Keyword::A));
        REQUIRE(l[2].is(TokenType::Comma));
        REQUIRE(l[3].is(TokenType::Integer));
        REQUIRE(l[3].int_value() == 1);
    }
}

TEST_CASE("Relational operators: %IF A op imm8 %ENDIF", "[hla][relops]") {
    struct Case {
        const char* op;
        Keyword jp1;
        Keyword jp2;
        bool twoJumps;
    };
    // Mapping for false-branch after CP imm:
    // == -> JP NZ, else
    // != -> JP Z,  else
    //  < -> JP NC, else
    // <= -> JP NZ, else; JP NC, else
    //  > -> JP Z,  else;  JP C,  else
    // >= -> JP C,  else
    const Case cases[] = {
        { "==", Keyword::NZ, Keyword::None, false },
        { "!=", Keyword::Z,  Keyword::None, false },
        { "<",  Keyword::NC, Keyword::None, false },
        { "<=", Keyword::NZ, Keyword::NC,   true  },
        { ">",  Keyword::Z,  Keyword::C,    true  },
        { ">=", Keyword::C,  Keyword::None, false },
    };

    for (const auto& c : cases) {
        const std::string src =
            std::string("%IF A ") + c.op + " 7\n"
            "NOP\n"
            "%ENDIF\n";

        const auto lines = run_hla_on_text(src,
                                           std::string("z80asm_hla_if_rel_") + c.op + ".asm");

        // Expected common prefix: CP 7, then 1 or 2 conditionals to HLA_IF_0_ELSE
        size_t idx = 0;
        REQUIRE(lines.size() >= 5); // minimum when single conditional jump
        expect_cp_imm(lines[idx++], 7);

        expect_jp_cond_label(lines[idx++], c.jp1, "HLA_IF_0_ELSE");
        if (c.twoJumps) {
            REQUIRE(lines.size() >= 6); // account for extra conditional
            expect_jp_cond_label(lines[idx++], c.jp2, "HLA_IF_0_ELSE");
        }

        // Body
        expect_nop(lines[idx++]);

        // .HLA_IF_0_ELSE
        expect_dot_label_def(lines[idx++], "HLA_IF_0_ELSE");

        // .HLA_IF_0_END
        expect_dot_label_def(lines[idx++], "HLA_IF_0_END");
    }
}

TEST_CASE("%IF A==imm ... %ENDIF", "[hla][if]") {
    // Single IF with no ELSE
    const std::string src =
        "%IF A == 1\n"
        "NOP\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_if_endif.asm");
    // Expected:
    // 0: CP 1
    // 1: JP NZ, HLA_IF_0_ELSE
    // 2: NOP
    // 3: .HLA_IF_0_ELSE
    // 4: .HLA_IF_0_END
    REQUIRE(lines.size() >= 5);
    expect_cp_imm(lines[0], 1);
    expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
    REQUIRE(lines[2].size() == 1);
    REQUIRE(lines[2][0].is(Keyword::NOP));
    expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
    expect_dot_label_def(lines[4], "HLA_IF_0_END");
}

TEST_CASE("%IF/%ELSE/%ENDIF with A==imm", "[hla][if][else]") {
    const std::string src =
        "%IF A == 2\n"
        "NOP ; IF branch\n"
        "%ELSE\n"
        "NOP ; ELSE branch\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_if_else_endif.asm");
    // Expected:
    // 0: CP 2
    // 1: JP NZ, HLA_IF_0_ELSE
    // 2: NOP
    // 3: JP HLA_IF_0_END
    // 4: .HLA_IF_0_ELSE
    // 5: NOP
    // 6: .HLA_IF_0_END
    REQUIRE(lines.size() >= 7);
    expect_cp_imm(lines[0], 2);
    expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
    REQUIRE(lines[2][0].is(Keyword::NOP));
    expect_jp_label(lines[3], "HLA_IF_0_END");
    expect_dot_label_def(lines[4], "HLA_IF_0_ELSE");
    REQUIRE(lines[5][0].is(Keyword::NOP));
    expect_dot_label_def(lines[6], "HLA_IF_0_END");
}

TEST_CASE("%IF/%ELIF/%ELSE/%ENDIF with A==imm", "[hla][if][elif][else]") {
    const std::string src =
        "%IF A == 1\n"
        "NOP ; IF\n"
        "%ELIF A == 2\n"
        "NOP ; ELIF\n"
        "%ELSE\n"
        "NOP ; ELSE\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_if_elif_else_endif.asm");
    // Expected:
    // 0: CP 1
    // 1: JP NZ, HLA_IF_0_ELSE
    // 2: NOP
    // 3: JP HLA_IF_0_END
    // 4: .HLA_IF_0_ELSE
    // 5: CP 2
    // 6: JP NZ, HLA_IF_1_ELSE
    // 7: NOP
    // 8: JP HLA_IF_0_END
    // 9: .HLA_IF_1_ELSE
    // 10: NOP
    // 11: .HLA_IF_0_END
    REQUIRE(lines.size() >= 12);
    expect_cp_imm(lines[0], 1);
    expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
    REQUIRE(lines[2][0].is(Keyword::NOP));
    expect_jp_label(lines[3], "HLA_IF_0_END");
    expect_dot_label_def(lines[4], "HLA_IF_0_ELSE");
    expect_cp_imm(lines[5], 2);
    expect_jp_cond_label(lines[6], Keyword::NZ, "HLA_IF_1_ELSE");
    REQUIRE(lines[7][0].is(Keyword::NOP));
    expect_jp_label(lines[8], "HLA_IF_0_END");
    expect_dot_label_def(lines[9], "HLA_IF_1_ELSE");
    REQUIRE(lines[10][0].is(Keyword::NOP));
    expect_dot_label_def(lines[11], "HLA_IF_0_END");
}

TEST_CASE("%IF/%ELIF/%ELIF/%ENDIF with A==imm", "[hla][if][elif]") {
    const std::string src =
        "%IF A == 1\n"
        "NOP ; IF\n"
        "%ELIF A == 2\n"
        "NOP ; ELIF1\n"
        "%ELIF A == 3\n"
        "NOP ; ELIF2\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_if_elif_elif_endif.asm");
    // Expected:
    // 0:  CP 1
    // 1:  JP NZ, HLA_IF_0_ELSE
    // 2:  NOP
    // 3:  JP HLA_IF_0_END
    // 4:  .HLA_IF_0_ELSE
    // 5:  CP 2
    // 6:  JP NZ, HLA_IF_1_ELSE
    // 7:  NOP
    // 8:  JP HLA_IF_0_END
    // 9:  .HLA_IF_1_ELSE
    // 10: CP 3
    // 11: JP NZ, HLA_IF_2_ELSE
    // 12: NOP
    // 13: .HLA_IF_2_ELSE
    // 14: .HLA_IF_0_END
    REQUIRE(lines.size() >= 15);
    expect_cp_imm(lines[0], 1);
    expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
    REQUIRE(lines[2][0].is(Keyword::NOP));
    expect_jp_label(lines[3], "HLA_IF_0_END");
    expect_dot_label_def(lines[4], "HLA_IF_0_ELSE");
    expect_cp_imm(lines[5], 2);
    expect_jp_cond_label(lines[6], Keyword::NZ, "HLA_IF_1_ELSE");
    REQUIRE(lines[7][0].is(Keyword::NOP));
    expect_jp_label(lines[8], "HLA_IF_0_END");
    expect_dot_label_def(lines[9], "HLA_IF_1_ELSE");
    expect_cp_imm(lines[10], 3);
    expect_jp_cond_label(lines[11], Keyword::NZ, "HLA_IF_2_ELSE");
    REQUIRE(lines[12][0].is(Keyword::NOP));
    expect_dot_label_def(lines[13], "HLA_IF_2_ELSE");
    expect_dot_label_def(lines[14], "HLA_IF_0_END");
}

TEST_CASE("%IF/%ELIF/%ELIF/%ELSE/%ENDIF with A==imm", "[hla][if][elif][else]") {
    const std::string src =
        "%IF A == 1\n"
        "NOP ; IF\n"
        "%ELIF A == 2\n"
        "NOP ; ELIF1\n"
        "%ELIF A == 3\n"
        "NOP ; ELIF2\n"
        "%ELSE\n"
        "NOP ; ELSE\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src,
                                       "z80asm_hla_if_elif_elif_else_endif.asm");
    // Expected (like previous, but ELSE instead of terminal ELSE label at ENDIF):
    // 0:  CP 1
    // 1:  JP NZ, HLA_IF_0_ELSE
    // 2:  NOP
    // 3:  JP HLA_IF_0_END
    // 4:  .HLA_IF_0_ELSE
    // 5:  CP 2
    // 6:  JP NZ, HLA_IF_1_ELSE
    // 7:  NOP
    // 8:  JP HLA_IF_0_END
    // 9:  .HLA_IF_1_ELSE
    // 10: CP 3
    // 11: JP NZ, HLA_IF_2_ELSE
    // 12: NOP
    // 13: JP HLA_IF_0_END
    // 14: .HLA_IF_2_ELSE
    // 15: NOP   (ELSE body)
    // 16: .HLA_IF_0_END
    REQUIRE(lines.size() >= 17);
    expect_cp_imm(lines[0], 1);
    expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
    REQUIRE(lines[2][0].is(Keyword::NOP));
    expect_jp_label(lines[3], "HLA_IF_0_END");
    expect_dot_label_def(lines[4], "HLA_IF_0_ELSE");
    expect_cp_imm(lines[5], 2);
    expect_jp_cond_label(lines[6], Keyword::NZ, "HLA_IF_1_ELSE");
    REQUIRE(lines[7][0].is(Keyword::NOP));
    expect_jp_label(lines[8], "HLA_IF_0_END");
    expect_dot_label_def(lines[9], "HLA_IF_1_ELSE");
    expect_cp_imm(lines[10], 3);
    expect_jp_cond_label(lines[11], Keyword::NZ, "HLA_IF_2_ELSE");
    REQUIRE(lines[12][0].is(Keyword::NOP));
    expect_jp_label(lines[13], "HLA_IF_0_END");
    expect_dot_label_def(lines[14], "HLA_IF_2_ELSE");
    REQUIRE(lines[15][0].is(Keyword::NOP));
    expect_dot_label_def(lines[16], "HLA_IF_0_END");
}

TEST_CASE("%IF A == operand %ENDIF - all operand kinds", "[hla][operands]") {
    SECTION("A == imm8") {
        const std::string src =
            "%IF A == 42\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_a_eq_imm.asm");
        REQUIRE(lines.size() >= 5);
        expect_cp_imm(lines[0], 42);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("A == B (reg8)") {
        const std::string src =
            "%IF A == B\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_a_eq_b.asm");
        REQUIRE(lines.size() >= 5);
        expect_cp_reg(lines[0], Keyword::B);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("A == A (self compare)") {
        const std::string src =
            "%IF A == A\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_a_eq_a.asm");
        REQUIRE(lines.size() >= 5);
        expect_cp_reg(lines[0], Keyword::A); // CP A
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("A == (HL)") {
        const std::string src =
            "%IF A == (HL)\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_a_eq_memhl.asm");
        REQUIRE(lines.size() >= 5);
        expect_cp_mem_hl(lines[0]); // CP (HL)
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("A == (abs)") {
        const std::string src =
            "%IF A == (123)\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_a_eq_memabs.asm");
        REQUIRE(lines.size() >= 5);
        expect_cp_mem_abs(lines[0], 123); // CP (123)
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }
}

TEST_CASE("%IF operand == A %ENDIF - A on RHS is accepted", "[hla][rhsA]") {
    SECTION("imm8 == A") {
        const std::string src =
            "%IF 42 == A\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_imm_eq_a.asm");
        REQUIRE(lines.size() >= 5);
        // Normalized to A == 42 -> CP 42
        expect_cp_imm(lines[0], 42);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("B == A (reg8)") {
        const std::string src =
            "%IF B == A\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_b_eq_a.asm");
        REQUIRE(lines.size() >= 5);
        // Normalized to A == B -> CP B
        expect_cp_reg(lines[0], Keyword::B);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("(HL) == A") {
        const std::string src =
            "%IF (HL) == A\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_memhl_eq_a.asm");
        REQUIRE(lines.size() >= 5);
        // Normalized to A == (HL) -> CP (HL)
        expect_cp_mem_hl(lines[0]);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("(abs) == A") {
        const std::string src =
            "%IF (123) == A\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_memabs_eq_a.asm");
        REQUIRE(lines.size() >= 5);
        // Normalized to A == (123) -> CP (123)
        expect_cp_mem_abs(lines[0], 123);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
    }

    SECTION("relational: 7 < A (normalizes to A > 7)") {
        const std::string src =
            "%IF 7 < A\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_imm_lt_a.asm");
        REQUIRE(lines.size() >= 6);
        // Normalized to A > 7 -> CP 7; false when Z or C
        expect_cp_imm(lines[0], 7);
        expect_jp_cond_label(lines[1], Keyword::Z, "HLA_IF_0_ELSE");
        expect_jp_cond_label(lines[2], Keyword::C, "HLA_IF_0_ELSE");
        expect_nop(lines[3]);
        expect_dot_label_def(lines[4], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[5], "HLA_IF_0_END");
    }
}

TEST_CASE("%WHILE / %WEND basic forms", "[hla][while]") {
    struct Case {
        const char* expr;
        int imm;
        std::vector<Keyword> conds; // false-branch JP conditions expected
    };
    // Mapping (same as IF false conditions):
    // A == n  -> NZ
    // A != n  -> Z
    // A <  n  -> NC
    // A <= n  -> NZ, NC
    // A >  n  -> Z, C
    // A >= n  -> C
    const Case cases[] = {
        { "A == 5", 5, { Keyword::NZ } },
        { "A != 6", 6, { Keyword::Z } },
        { "A < 7",  7, { Keyword::NC } },
        { "A <= 8", 8, { Keyword::NZ, Keyword::NC } },
        { "A > 9",  9, { Keyword::Z, Keyword::C } },
        { "A >= 10", 10, { Keyword::C } },
    };

    for (const auto& c : cases) {
        std::string src =
            std::string("%WHILE ") + c.expr + "\n"
            "NOP\n"
            "%WEND\n";

        std::string fname = std::string("z80asm_hla_while_") + c.expr + ".asm";
        auto lines = run_hla_on_text(src, fname);

        // Expected sequence:
        // 0: .HLA_WHILE_0_TOP
        // 1: CP imm
        // 2..(n): JP <cond>, HLA_WHILE_0_END (one or more)
        // body: NOP
        // JP HLA_WHILE_0_TOP
        // .HLA_WHILE_0_END
        // Total lines = 1 (top) + 1 (CP) + c.conds.size() + 1 (NOP) + 1 (JP back) + 1 (END label)
        size_t expected_min = 1 + 1 + c.conds.size() + 1 + 1 + 1;
        REQUIRE(lines.size() >= expected_min);

        size_t idx = 0;
        // .HLA_WHILE_0_TOP
        expect_dot_label_def(lines[idx++], "HLA_WHILE_0_TOP");

        // CP imm
        expect_cp_imm(lines[idx++], c.imm);

        // Conditional jumps
        for (auto cond : c.conds) {
            expect_jp_cond_label(lines[idx++], cond, "HLA_WHILE_0_END");
        }

        // Body NOP
        expect_nop(lines[idx++]);

        // JP HLA_WHILE_0_TOP (unconditional)
        expect_jp_label(lines[idx++], "HLA_WHILE_0_TOP");

        // .HLA_WHILE_0_END
        expect_dot_label_def(lines[idx++], "HLA_WHILE_0_END");
    }
}

TEST_CASE("%WHILE with A on RHS normalization", "[hla][while][rhsA]") {
    // Example: 3 < A normalizes to A > 3 (false conditions Z, C)
    const std::string src =
        "%WHILE 3 < A\n"
        "NOP\n"
        "%WEND\n";

    auto lines = run_hla_on_text(src, "z80asm_hla_while_rhs_a.asm");
    // Expect:
    // .HLA_WHILE_0_TOP
    // CP 3
    // JP Z, HLA_WHILE_0_END
    // JP C, HLA_WHILE_0_END
    // NOP
    // JP HLA_WHILE_0_TOP
    // .HLA_WHILE_0_END
    REQUIRE(lines.size() >= 7);
    size_t idx = 0;
    expect_dot_label_def(lines[idx++], "HLA_WHILE_0_TOP");
    expect_cp_imm(lines[idx++], 3);
    expect_jp_cond_label(lines[idx++], Keyword::Z, "HLA_WHILE_0_END");
    expect_jp_cond_label(lines[idx++], Keyword::C, "HLA_WHILE_0_END");
    expect_nop(lines[idx++]);
    expect_jp_label(lines[idx++], "HLA_WHILE_0_TOP");
    expect_dot_label_def(lines[idx++], "HLA_WHILE_0_END");
}

TEST_CASE("%IF accepts constant expressions as immediate value or immediate address",
          "[hla][expr][immediate][address]") {
    SECTION("Immediate constant expression: A == 1+2*3 -> CP 7") {
        g_errors.reset();
        g_symbol_table.clear();
        const std::string src =
            "%IF A == 1 + 2 * 3\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_constexpr_imm.asm");

        REQUIRE(lines.size() >= 5);
        expect_cp_imm(lines[0], 7);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Immediate address expression: A == (0x100+0x23) -> CP (0x123)") {
        g_errors.reset();
        g_symbol_table.clear();
        const std::string src =
            "%IF A == (0x100 + 0x23)\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_constexpr_addr.asm");

        REQUIRE(lines.size() >= 5);
        expect_cp_mem_abs(lines[0], 0x123);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Nested parens in address expression are handled: A == ((10+5)*(2+3)) -> CP 75") {
        g_errors.reset();
        g_symbol_table.clear();
        const std::string src =
            "%IF A == ((10 + 5) * (2 + 3))\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_constexpr_nested.asm");

        REQUIRE(lines.size() >= 5);
        expect_cp_mem_abs(lines[0], 75);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
        REQUIRE_FALSE(g_errors.has_errors());
    }
}

TEST_CASE("%IF accepts constant symbols; rejects undefined or non-constant symbols",
          "[hla][expr][symbols]") {
    // Helper to define a symbol in the test symbol table
    auto define_sym = [](const std::string & name, int value, bool is_const,
    bool is_def = true) {
        Symbol s;
        s.name = name;
        s.value = value;
        s.is_defined = is_def;
        s.is_constant = is_const;
        g_symbol_table.add_symbol(name, s);
    };

    SECTION("Constant symbol in immediate expression") {
        g_errors.reset();
        g_symbol_table.clear();
        define_sym("CONST7", 7, true);

        const std::string src =
            "%IF A == CONST7\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_const_sym.asm");

        REQUIRE(lines.size() >= 5);
        expect_cp_imm(lines[0], 7);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Constant symbol inside immediate address expression") {
        g_errors.reset();
        g_symbol_table.clear();
        define_sym("BASE", 0x100, true);

        const std::string src =
            "%IF A == (BASE + 2)\n"
            "NOP\n"
            "%ENDIF\n";
        const auto lines = run_hla_on_text(src, "z80asm_hla_if_const_sym_addr.asm");

        REQUIRE(lines.size() >= 5);
        expect_cp_mem_abs(lines[0], 0x102);
        expect_jp_cond_label(lines[1], Keyword::NZ, "HLA_IF_0_ELSE");
        expect_nop(lines[2]);
        expect_dot_label_def(lines[3], "HLA_IF_0_ELSE");
        expect_dot_label_def(lines[4], "HLA_IF_0_END");
        REQUIRE_FALSE(g_errors.has_errors());
    }

    SECTION("Undefined symbol is rejected") {
        g_errors.reset();
        g_symbol_table.clear();
        const std::string src =
            "%IF A == UNDEF_SYM\n"
            "NOP\n"
            "%ENDIF\n";
        (void)run_hla_on_text(src, "z80asm_hla_if_undef_sym.asm");

        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("invalid constant expression"));
    }

    SECTION("Defined but non-constant symbol is rejected") {
        g_errors.reset();
        g_symbol_table.clear();
        define_sym("VARX", 3, false); // defined but not constant

        const std::string src =
            "%IF A == (VARX + 1)\n"
            "NOP\n"
            "%ENDIF\n";
        (void)run_hla_on_text(src, "z80asm_hla_if_nonconst_sym.asm");

        REQUIRE(g_errors.has_errors());
        std::string msg = g_errors.last_error_message();
        REQUIRE(msg.find("invalid constant expression"));
    }
}

TEST_CASE("Boolean AND short-circuit: %IF (A==1)&&(A<5) %ENDIF",
          "[hla][bool][and]") {
    const std::string src =
        "%IF (A == 1) && (A < 5)\n"
        "NOP\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_bool_and.asm");
    // Expected:
    // CP 1
    // JP NZ, HLA_IF_0_ELSE
    // CP 5
    // JP NC, HLA_IF_0_ELSE
    // NOP
    // .HLA_IF_0_ELSE
    // .HLA_IF_0_END
    REQUIRE(lines.size() >= 7);
    size_t idx = 0;
    expect_cp_imm(lines[idx++], 1);
    expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_IF_0_ELSE");
    expect_cp_imm(lines[idx++], 5);
    expect_jp_cond_label(lines[idx++], Keyword::NC, "HLA_IF_0_ELSE");
    expect_nop(lines[idx++]);
    expect_dot_label_def(lines[idx++], "HLA_IF_0_ELSE");
    expect_dot_label_def(lines[idx++], "HLA_IF_0_END");
}

TEST_CASE("Boolean OR short-circuit: %IF (A==1)||(A<5) %ENDIF",
          "[hla][bool][or]") {
    const std::string src =
        "%IF (A == 1) || (A < 5)\n"
        "NOP\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_bool_or.asm");
    // Expected:
    // CP 1
    // JP Z, <skip_bool_label>
    // CP 5
    // JP NC, HLA_IF_0_ELSE
    // .<skip_bool_label>
    // NOP
    // .HLA_IF_0_ELSE
    // .HLA_IF_0_END
    REQUIRE(lines.size() >= 8);
    size_t idx = 0;
    expect_cp_imm(lines[idx++], 1);
    std::string skip_lbl = expect_jp_cond_any_label(lines[idx++],
                           Keyword::Z); // true(L) -> skip
    expect_cp_imm(lines[idx++], 5);
    expect_jp_cond_label(lines[idx++], Keyword::NC, "HLA_IF_0_ELSE");
    expect_dot_label_def(lines[idx++], skip_lbl);
    expect_nop(lines[idx++]);
    expect_dot_label_def(lines[idx++], "HLA_IF_0_ELSE");
    expect_dot_label_def(lines[idx++], "HLA_IF_0_END");
}

TEST_CASE("Boolean NOT: %IF !(A==3) %ENDIF", "[hla][bool][not]") {
    const std::string src =
        "%IF !(A == 3)\n"
        "NOP\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_bool_not.asm");
    // FALSE of !E == TRUE of E -> branch on Z for A==3
    // Expected:
    // CP 3
    // JP Z, HLA_IF_0_ELSE
    // NOP
    // .HLA_IF_0_ELSE
    // .HLA_IF_0_END
    REQUIRE(lines.size() >= 5);
    size_t idx = 0;
    expect_cp_imm(lines[idx++], 3);
    expect_jp_cond_label(lines[idx++], Keyword::Z, "HLA_IF_0_ELSE");
    expect_nop(lines[idx++]);
    expect_dot_label_def(lines[idx++], "HLA_IF_0_ELSE");
    expect_dot_label_def(lines[idx++], "HLA_IF_0_END");
}

TEST_CASE("Nested boolean: (A==1) && ((A<5) || (A>10))",
          "[hla][bool][nested]") {
    const std::string src =
        "%IF (A == 1) && ((A < 5) || (A > 10))\n"
        "NOP\n"
        "%ENDIF\n";

    const auto lines = run_hla_on_text(src, "z80asm_hla_bool_nested.asm");
    // Expected:
    // CP 1
    // JP NZ, HLA_IF_0_ELSE
    // CP 5
    // JP C, <skip_bool_label>          ; true(L of OR) -> skip R
    // CP 10
    // JP Z, HLA_IF_0_ELSE              ; false(R of OR) part 1
    // JP C, HLA_IF_0_ELSE              ; false(R of OR) part 2
    // .<skip_bool_label>
    // NOP
    // .HLA_IF_0_ELSE
    // .HLA_IF_0_END
    REQUIRE(lines.size() >= 11);
    size_t idx = 0;
    expect_cp_imm(lines[idx++], 1);
    expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_IF_0_ELSE");

    // OR left: A < 5, true -> C
    expect_cp_imm(lines[idx++], 5);
    std::string skip_lbl = expect_jp_cond_any_label(lines[idx++], Keyword::C);

    // OR right: A > 10, false -> Z or C
    expect_cp_imm(lines[idx++], 10);
    expect_jp_cond_label(lines[idx++], Keyword::Z, "HLA_IF_0_ELSE");
    expect_jp_cond_label(lines[idx++], Keyword::C, "HLA_IF_0_ELSE");

    // skip to continue when OR-left was true
    expect_dot_label_def(lines[idx++], skip_lbl);

    // body + end labels
    expect_nop(lines[idx++]);
    expect_dot_label_def(lines[idx++], "HLA_IF_0_ELSE");
    expect_dot_label_def(lines[idx++], "HLA_IF_0_END");
}

TEST_CASE("%WHILE end markers: %WEND, %ENDW and %ENDWHILE are synonyms",
          "[hla][while][synonyms]") {
    const std::vector<std::string> ends = { "WEND", "ENDW", "ENDWHILE" };

    for (const auto& endkw : ends) {
        const std::string src =
            "%WHILE A == 5\n"
            "NOP\n"
            "%" + endkw + "\n";

        auto lines = run_hla_on_text(src, "z80asm_hla_while_end_synonyms.asm");

        // Expect:
        // .HLA_WHILE_0_TOP
        // CP 5
        // JP NZ, HLA_WHILE_0_END
        // NOP
        // JP HLA_WHILE_0_TOP
        // .HLA_WHILE_0_END
        REQUIRE(lines.size() >= 6);
        size_t idx = 0;
        expect_dot_label_def(lines[idx++], "HLA_WHILE_0_TOP");
        expect_cp_imm(lines[idx++], 5);
        expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_WHILE_0_END");
        expect_nop(lines[idx++]);
        expect_jp_label(lines[idx++], "HLA_WHILE_0_TOP");
        expect_dot_label_def(lines[idx++], "HLA_WHILE_0_END");
    }
}

// Add after existing while tests (just before %IF accepts constant expressions section or at end)

TEST_CASE("%REPEAT / %UNTIL basic A==imm", "[hla][repeat][until]") {
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTIL A == 3\n";

    auto lines = run_hla_on_text(src, "z80asm_hla_repeat_until_basic.asm");
    // Expected:
    // .HLA_REPEAT_0_TOP
    // NOP
    // CP 3
    // JP NZ, HLA_REPEAT_0_TOP
    // .HLA_REPEAT_0_END
    REQUIRE(lines.size() >= 5);
    size_t idx = 0;
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_TOP");
    expect_nop(lines[idx++]);
    expect_cp_imm(lines[idx++], 3);
    expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_REPEAT_0_TOP");
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_END");
}

TEST_CASE("%REPEAT / %UNTIL with relational generating two false jumps (A <= imm)",
          "[hla][repeat][until][rel]") {
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTIL A <= 7\n";

    auto lines = run_hla_on_text(src, "z80asm_hla_repeat_until_le.asm");
    // Expected false jumps: NZ and NC back to top
    // .HLA_REPEAT_0_TOP
    // NOP
    // CP 7
    // JP NZ, HLA_REPEAT_0_TOP
    // JP NC, HLA_REPEAT_0_TOP
    // .HLA_REPEAT_0_END
    REQUIRE(lines.size() >= 6);
    size_t idx = 0;
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_TOP");
    expect_nop(lines[idx++]);
    expect_cp_imm(lines[idx++], 7);
    expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_REPEAT_0_TOP");
    expect_jp_cond_label(lines[idx++], Keyword::NC, "HLA_REPEAT_0_TOP");
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_END");
}

TEST_CASE("%REPEAT / %UNTIL A on RHS normalization (imm < A => A > imm)",
          "[hla][repeat][until][rhsA]") {
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTIL 2 < A\n"; // normalized to A > 2 -> false if Z or C

    auto lines = run_hla_on_text(src, "z80asm_hla_repeat_until_rhs_a.asm");
    // .HLA_REPEAT_0_TOP
    // NOP
    // CP 2
    // JP Z, HLA_REPEAT_0_TOP
    // JP C, HLA_REPEAT_0_TOP
    // .HLA_REPEAT_0_END
    REQUIRE(lines.size() >= 6);
    size_t idx = 0;
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_TOP");
    expect_nop(lines[idx++]);
    expect_cp_imm(lines[idx++], 2);
    expect_jp_cond_label(lines[idx++], Keyword::Z, "HLA_REPEAT_0_TOP");
    expect_jp_cond_label(lines[idx++], Keyword::C, "HLA_REPEAT_0_TOP");
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_END");
}

TEST_CASE("%UNTIL without %REPEAT reports error",
          "[hla][repeat][until][error]") {
    const std::string src = "%UNTIL A==1\n";
    (void)run_hla_on_text(src, "z80asm_hla_until_no_repeat.asm");
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("%UNTIL without matching %REPEAT") !=
            std::string::npos);
}

TEST_CASE("%REPEAT missing %UNTIL reports error at EOF",
          "[hla][repeat][until][error][eof]") {
    g_errors.reset();
    const std::string src = "%REPEAT\nNOP\n";
    (void)run_hla_on_text(src, "z80asm_hla_repeat_no_until.asm");
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Unclosed HLA block") !=
            std::string::npos);
}

// -----------------------------------------------------------------------------
// %REPEAT / %UNTILB tests (modified for DEC B / JP NZ scheme)
// -----------------------------------------------------------------------------

TEST_CASE("%REPEAT / %UNTILB basic emits DEC B / JP NZ back to top and end label",
          "[hla][repeat][untilb]") {
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTILB\n";

    auto lines = run_hla_on_text(src, "z80asm_hla_repeat_untilb_basic.asm");
    // Expect:
    // .HLA_REPEAT_0_TOP
    // NOP
    // DEC B
    // JP NZ, HLA_REPEAT_0_TOP
    // .HLA_REPEAT_0_END
    REQUIRE(lines.size() >= 5);
    size_t idx = 0;
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_TOP");
    expect_nop(lines[idx++]);
    expect_dec_b(lines[idx++]);
    expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_REPEAT_0_TOP");
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_END");
}

TEST_CASE("%UNTILB without %REPEAT reports error",
          "[hla][repeat][untilb][error]") {
    g_errors.reset();
    const std::string src = "%UNTILB\n";
    (void)run_hla_on_text(src, "z80asm_hla_untilb_no_repeat.asm");
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("%UNTILB without matching %REPEAT")
            != std::string::npos);
}

TEST_CASE("%UNTILB with trailing tokens reports error",
          "[hla][repeat][untilb][error][trailing]") {
    g_errors.reset();
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTILB extra\n";
    (void)run_hla_on_text(src, "z80asm_hla_untilb_trailing.asm");
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Unexpected tokens after %UNTILB") !=
            std::string::npos);
}

TEST_CASE("%REPEAT / %UNTILBC basic emits dec bc / ld a,b / or c / jp nz back to top then end label",
          "[hla][repeat][untilbc]") {
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTILBC\n";

    auto lines = run_hla_on_text(src, "z80asm_hla_repeat_untilbc_basic.asm");
    // Expect:
    // 0 .HLA_REPEAT_0_TOP
    // 1 NOP
    // 2 DEC BC
    // 3 LD A,B
    // 4 OR C
    // 5 JP NZ, HLA_REPEAT_0_TOP
    // 6 .HLA_REPEAT_0_END
    REQUIRE(lines.size() >= 7);
    size_t idx = 0;
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_TOP");
    expect_nop(lines[idx++]);
    expect_dec_bc(lines[idx++]);
    expect_ld_a_b(lines[idx++]);
    expect_or_c(lines[idx++]);
    expect_jp_cond_label(lines[idx++], Keyword::NZ, "HLA_REPEAT_0_TOP");
    expect_dot_label_def(lines[idx++], "HLA_REPEAT_0_END");
}

TEST_CASE("%UNTILBC without %REPEAT reports error",
          "[hla][repeat][untilbc][error]") {
    g_errors.reset();
    const std::string src = "%UNTILBC\n";
    (void)run_hla_on_text(src, "z80asm_hla_untilbc_no_repeat.asm");
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("%UNTILBC without matching %REPEAT")
            != std::string::npos);
}

TEST_CASE("%UNTILBC with trailing tokens reports error",
          "[hla][repeat][untilbc][error][trailing]") {
    g_errors.reset();
    const std::string src =
        "%REPEAT\n"
        "NOP\n"
        "%UNTILBC extra\n";
    (void)run_hla_on_text(src, "z80asm_hla_untilbc_trailing.asm");
    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.last_error_message().find("Unexpected tokens after %UNTILBC")
            != std::string::npos);
}

TEST_CASE("Nested %REPEAT with inner %UNTILBC works independently",
          "[hla][repeat][untilbc][nested]") {
    g_errors.reset();
    const std::string src =
        "%REPEAT\n"              // outer
        "NOP\n"
        "%REPEAT\n"              // inner
        "NOP\n"
        "%UNTILBC\n"             // end inner
        "NOP\n"
        "%UNTILBC\n";            // end outer

    auto lines = run_hla_on_text(src, "z80asm_hla_repeat_untilbc_nested.asm");
    // We only check ordering of the two sequences and distinct labels
    // Collect top labels
    std::string outer_top = "HLA_REPEAT_0_TOP";
    std::string inner_top = "HLA_REPEAT_1_TOP";

    // Find indices of sequences
    // Expect pattern:
    // .outer_top
    // NOP
    // .inner_top
    // NOP
    // DEC BC
    // LD A,B
    // OR C
    // JP NZ, inner_top
    // .HLA_REPEAT_1_END
    // NOP
    // DEC BC
    // LD A,B
    // OR C
    // JP NZ, outer_top
    // .HLA_REPEAT_0_END

    // Minimal sanity checks
    REQUIRE(lines.size() >= 14);
    // outer start
    expect_dot_label_def(lines[0], outer_top);
    expect_nop(lines[1]);
    // inner start
    expect_dot_label_def(lines[2], inner_top);
    expect_nop(lines[3]);
    // inner untilbc sequence
    expect_dec_bc(lines[4]);
    expect_ld_a_b(lines[5]);
    expect_or_c(lines[6]);
    expect_jp_cond_label(lines[7], Keyword::NZ, inner_top);
    // inner end label
    REQUIRE(lines[8].size() == 2);
    REQUIRE(lines[8][1].text().find("HLA_REPEAT_1_END") != std::string::npos);
    // middle NOP
    expect_nop(lines[9]);
    // outer untilbc sequence
    expect_dec_bc(lines[10]);
    expect_ld_a_b(lines[11]);
    expect_or_c(lines[12]);
    expect_jp_cond_label(lines[13], Keyword::NZ, outer_top);
    // outer end (last line)
    REQUIRE(lines.back().size() == 2);
    REQUIRE(lines.back()[1].text().find("HLA_REPEAT_0_END") != std::string::npos);
    REQUIRE_FALSE(g_errors.has_errors());
}

