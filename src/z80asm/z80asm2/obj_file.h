//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "ir.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <set>
#include <string_view>
#include <unordered_map>
#include <vector>

using uint = unsigned int;

#define OBJ_FILE_VERSION 18

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

static constexpr std::string_view OBJ_FILE_SIGNATURE = "Z80RMF" STR(
            OBJ_FILE_VERSION);
static constexpr std::string_view LIB_FILE_SIGNATURE = "Z80LMF" STR(
            OBJ_FILE_VERSION);

enum class ObjExprRange {
    Undefined = 0,              // end marker
    JrOffset = 1,               // 8-bit relative offset for JR
    ByteUnsigned = 2,           // 8-bit unsigned
    ByteSigned = 3,             // 8-bit signed
    Word = 4,                   // 16-bit value little-endian
    WordBE = 5,                 // 16-bit value big-endian
    DWord = 6,                  // 32-bit signed
    ByteToWordUnsigned = 7,     // unsigned byte extended to 16 bits
    ByteToWordSigned = 8,       // signed byte sign-extended to 16 bits
    Ptr24 = 9,                  // 24-bit pointer
    HighOffset = 10,            // byte offset to 0xFF00
    Assignment = 11,            // DEFC expression assigning a symbol
    JreOffset = 12,             // 16-bit relative offset for JRE
    ByteToPtrUnsigned = 13,     // unsigned byte extended to 24 bits
    ByteToPtrSigned = 14,       // signed byte sign-extended to 24 bits
};

struct ObjExpr : public TreeNode {
    StringInterner::Id text_id = 0; // expression text
    ObjExprRange range = ObjExprRange::Undefined; // range of patch
    uint asmpc = 0;             // offset of ASMPC for the instruction
    uint code_pos = 0;          // offset of patch position
    uint opcode_size = 0;       // size of opcode
    StringInterner::Id section_name_id = 0; // section
    StringInterner::Id target_name_id = 0;  // name for Assignment
    SourceLoc loc;              // location of expression

    virtual ~ObjExpr() = default;
    void dump(DumpContext ctx) const override;
};

enum class ObjSymbolScope {
    Undefined = 0,              // end marker
    Local = 1,                  // local
    Public = 2,                 // public
};

enum class ObjSymbolType {
    Undefined = 0,              // not used
    Constant = 1,               // constant
    AddressRelative = 2,        // offset to base address
    Computed = 3,               // expression needs to be evaluated
};

struct ObjSymbol : public TreeNode {
    StringInterner::Id name_id = 0; // symbol name
    SourceLoc loc;              // location of definition
    ObjSymbolScope scope = ObjSymbolScope::Undefined; // scope
    ObjSymbolType type = ObjSymbolType::Undefined;    // type
    int value;                  // constant value of offset to base address
    StringInterner::Id section_name_id = 0; // section

    virtual ~ObjSymbol() = default;
    void dump(DumpContext ctx) const override;
};

struct ObjSection : public TreeNode {
    static constexpr int OrgNotDefined = -1;
    static constexpr int OrgSectionSplit = -2;

    StringInterner::Id name_id = 0; // section name
    bool org_defined = false;   // true if ORG defined
    uint base_address = 0;      // ORG if defined
    bool section_split = false; // true if section needs splitting
    uint align = 1;             // alignment address
    std::vector<uint8_t> bytes; // binary data

    virtual ~ObjSection() = default;
    void dump(DumpContext ctx) const override;
};

struct ObjectModule : public TreeNode {
    StringInterner::Id module_name_id = 0;
    CPU cpu_id = CPU::z80;
    bool swap_ix_iy = false;

    std::vector<ObjExpr> exprs;
    std::vector<ObjSymbol> symbols;
    std::vector<StringInterner::Id> externs;
    std::vector<ObjSection> sections;

    virtual ~ObjectModule() = default;
    void dump(DumpContext ctx) const override;
};

struct ObjectLibrary : public TreeNode {
    std::vector<ObjectModule> modules;
    std::set<StringInterner::Id> public_symbols;

    virtual ~ObjectLibrary() = default;
    void dump(DumpContext ctx) const override;
};

bool write_object_library(const ObjectLibrary& obj_lib,
                          std::string_view filename);

[[noreturn]]
void dump_obj_lib_and_exit(const ObjectLibrary& obj_lib);
