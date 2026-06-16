//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ir.h"
#include "cpu.h"
#include "expr.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "opcodes.h"
#include "opcodes_trie_token.h"
#include "options.h"
#include "source_loc.h"
#include <cstdint>
#include <memory>
#include <unordered_map>
#include <vector>

// bytecode for opcodes match
enum class OpcodesOp : uint8_t {
    Bytes,          // followed by number of bytes and literal bytes

    ExprConst,      // followed by offset and size;
    // one of CheckRange::xxx
    // one of ExprFormula::xxx; coeficients required by formula

    ExprPatch,      // followed by offset and size;
    // and PATCH_xxx flags

    AltJpOpcode,    // if present, this is a jr instruction
    // followed by number of bytes, literal bytes,
    // offset and size
};

std::unique_ptr<LabelStmt> parse_label(ParseLine& pline);

class Parser {
public:
    Parser(const std::vector<LogicalLine>& asm_lines_);
    std::unique_ptr<Program> parse(std::string_view prog_name);

private:
    // match of opcode pattern, used during opcode search
    struct OpcodesMatch {
        bool matched = false;
        int32_t accept_id = -1;
        std::vector<std::unique_ptr<Expr>> exprs;
    };

    // backtracking stack for opcode recognition
    struct ChoicePoint {
        enum class Type { Token, Expr } type;
        size_t node;
        size_t token_pos;
        const TrieTransition* transition;
        size_t expr_count;   // how many expressions were pushed so far
    };

    // attributes
    CPU parser_cpu_id{ DEFAULT_CPU };
    const std::vector<LogicalLine>& asm_lines;
    size_t line_idx = 0;            // current line index in asm_lines

    // function pointer tables for directive parsing
    using DirectiveParseFn =
        std::unique_ptr<Stmt>(Parser::*)(ParseLine&, const SourceLoc&,
                                         ParseStatus&);
    static std::unordered_map<Keyword, DirectiveParseFn> directive_parsers;

    // trie-based opcode recognition
    const TrieTransition* binary_search_transition(size_t node, TrieToken key);
    OpcodesMatch recognize_opcode(ParseLine& pline, ParseStatus& status);
    std::unique_ptr<OpcodeStmt> interpret_parse_bytecode(OpcodesMatch& match,
            const SourceLoc& loc);
    std::unique_ptr<OpcodeStmt> parse_opcode(ParseLine& pline,
            const SourceLoc& loc,
            ParseStatus& status);

    // directive parsing helpers
    std::unique_ptr<Stmt> parse_directive(ParseLine& pline, const SourceLoc& loc,
                                          ParseStatus& status);

    // main parsing functions
    void parse_line(std::unique_ptr<Program>& prog);
    std::unique_ptr<Stmt> parse_EXTERN(ParseLine& pline,
                                       const SourceLoc& loc,
                                       ParseStatus& status);
    std::unique_ptr<Stmt> parse_PUBLIC(ParseLine& pline,
                                       const SourceLoc& loc,
                                       ParseStatus& status);
    std::unique_ptr<Stmt> parse_GLOBAL(ParseLine& pline,
                                       const SourceLoc& loc,
                                       ParseStatus& status);
    std::unique_ptr<Stmt> parse_MODULE(ParseLine& pline,
                                       const SourceLoc& loc,
                                       ParseStatus& status);
    std::unique_ptr<Stmt> parse_SECTION(ParseLine& pline,
                                        const SourceLoc& loc,
                                        ParseStatus& status);
    std::unique_ptr<Stmt> parse_ORG(ParseLine& pline, const SourceLoc& loc,
                                    ParseStatus& status);
    std::unique_ptr<Stmt> parse_DEFC(ParseLine& pline, const SourceLoc& loc,
                                     ParseStatus& status);
    std::unique_ptr<Stmt> parse_ALIGN(ParseLine& pline, const SourceLoc& loc,
                                      ParseStatus& status);
    std::unique_ptr<Stmt> parse_DEFS(ParseLine& pline,
                                     const SourceLoc& loc,
                                     ParseStatus& status);
    std::unique_ptr<Stmt> parse_PRAGMA(ParseLine& pline,
                                       const SourceLoc& loc,
                                       ParseStatus& status);
    std::unique_ptr<Stmt> parse_BYTE(ParseLine& pline,
                                     const SourceLoc& loc,
                                     ParseStatus& status);
    std::unique_ptr<Stmt> parse_WORD(ParseLine& pline,
                                     const SourceLoc& loc,
                                     ParseStatus& status);
    std::unique_ptr<Stmt> parse_WORD_BE(ParseLine& pline,
                                        const SourceLoc& loc,
                                        ParseStatus& status);
    std::unique_ptr<Stmt> parse_PTR(ParseLine& pline,
                                    const SourceLoc& loc,
                                    ParseStatus& status);
    std::unique_ptr<Stmt> parse_DWORD(ParseLine& pline,
                                      const SourceLoc& loc,
                                      ParseStatus& status);
    std::unique_ptr<Stmt> parse_LSTON(ParseLine& pline,
                                      const SourceLoc& loc,
                                      ParseStatus& status);
    std::unique_ptr<Stmt> parse_LSTOFF(ParseLine& pline,
                                       const SourceLoc& loc,
                                       ParseStatus& status);
    std::unique_ptr<Stmt> parse_PHASE(ParseLine& pline,
                                      const SourceLoc& loc,
                                      ParseStatus& status);
    std::unique_ptr<Stmt> parse_DEPHASE(ParseLine& pline,
                                        const SourceLoc& loc,
                                        ParseStatus& status);
};
