//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ir.h"
#include "lexer_tokens.h"
#include "release_assert.h"
#include "string_interner.h"
#include "string_utils.h"
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

Patch::~Patch() = default;

DumpContext::DumpContext(std::ostream& os_, int indent_)
    : os(os_), indent(indent_) {
}

void DumpContext::line(std::string_view text) {
    os << std::string(indent * 4, ' ') << text << std::endl;
}

DumpContext DumpContext::child() const {
    return DumpContext(os, indent + 1);
}

static std::string to_string(ExprType type) {
    switch (type) {
    case ExprType::Unknown:
        return "Unknown";
    case ExprType::Constant:
        return "Constant";
    case ExprType::AddressRelative:
        return "AddressRelative";
    case ExprType::Computed:
        return "Computed";
    default:
        release_assert(0);
        return "Unknown";
    }
}

static std::string section_name_or_empty(const Section* section) {
    if (!section) {
        return "";
    }
    std::string name = g_strings.to_string(section->name_id);
    return name.empty() ? "\"\"" : name;
}

// Helper to format a vector of bytes as a hex string
static std::string format_bytes(const std::vector<uint8_t>& bytes) {
    std::string result;
    for (size_t i = 0; i < bytes.size(); ++i) {
        if (i > 0) {
            result += " ";
        }
        result += int_to_hex(bytes[i]);
    }
    return result;
}

static void dump_expr_value(const ExprValue& value, DumpContext ctx) {
    ctx.line("Value type: " + to_string(value.type));
    switch (value.type) {
    case ExprType::Unknown:
        break;
    case ExprType::Constant:
        ctx.line("Value const: " + int_to_hex(value.const_value));
        break;
    case ExprType::AddressRelative:
        if (value.section) {
            ctx.line("Value section: " + section_name_or_empty(value.section));
        }
        ctx.line("Value offset: " + int_to_hex(value.offset));
        break;
    case ExprType::Computed:
        if (!value.tokens.empty()) {
            ctx.line("Value expr: " + to_string(value.tokens));
        }
        break;
    default:
        break;
    }
}

static void dump_expr_common(const Expr& expr, DumpContext ctx) {
    ctx.line("Location: " + expr.loc.to_string());
    dump_expr_value(expr.value, ctx);
    if (!expr.tokens.empty()) {
        ctx.line("Expr: " + to_string(expr.tokens));
    }
}

void Stmt::dump(DumpContext ctx) const {
    ctx.line("Stmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
}

void OpcodeStmt::dump(DumpContext ctx) const {
    ctx.line("OpcodeStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));

    if (is_short_jump) {
        c.line("Is short jump");
    }

    // Dump bytes
    if (!bytes.empty()) {
        c.line("Bytes: " + format_bytes(bytes));
    }

    // Dump patches
    if (!patches.empty()) {
        c.line("Patches:");
        auto pc = c.child();
        for (const auto& patch : patches) {
            patch->dump(pc);
        }
    }
}

LabelStmt::LabelStmt(StringInterner::Id name_id_, const SourceLoc& loc_)
    : Stmt(loc_), name_id(name_id_) {
}

void LabelStmt::dump(DumpContext ctx) const {
    ctx.line("LabelStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    std::string ident_str = g_strings.to_string(name_id);
    c.line("Label: " + ident_str);
    if (is_local) {
        c.line("Local part: " + ident_str.substr(at_pos));
    }
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (symbol) {
        c.line("Symbol info:");
        symbol->dump(c.child());
    }
}

void ExprLiteralInt::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralInt: " + int_to_hex(int_value));
    auto c = ctx.child();
    dump_expr_common(*this, c);
}

void ExprLiteralFloat::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralFloat: " + std::to_string(float_value));
    auto c = ctx.child();
    dump_expr_common(*this, c);
}

void ExprLiteralAsmpc::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralAsmpc");
    auto c = ctx.child();
    dump_expr_common(*this, c);
    if (stmt) {
        c.line("Address: " + int_to_hex(stmt->address));
    }
}

void ExprSymbol::dump(DumpContext ctx) const {
    ctx.line("ExprSymbol: " + g_strings.to_string(name_id));
    auto c = ctx.child();
    dump_expr_common(*this, c);
    if (symbol) {
        c.line("Symbol info:");
        symbol->dump(c.child());
    }
}

void ExprLocalLabel::dump(DumpContext ctx) const {
    ctx.line("ExprLocalLabel: " + g_strings.to_string(name_id) + " at " +
             std::to_string(at_pos));
    auto c = ctx.child();
    dump_expr_common(*this, c);
    if (symbol) {
        c.line("Symbol info:");
        symbol->dump(c.child());
    }
}

void ExprUnary::dump(DumpContext ctx) const {
    ctx.line("ExprUnary: " + to_string(op));
    auto c = ctx.child();
    dump_expr_common(*this, c);
    c.line("RHS:");
    rhs->dump(c.child());
}

void ExprBinary::dump(DumpContext ctx) const {
    ctx.line("ExprBinary: " + to_string(op));
    auto c = ctx.child();
    dump_expr_common(*this, c);
    c.line("LHS:");
    lhs->dump(c.child());
    c.line("RHS:");
    rhs->dump(c.child());
}

void ExprTernary::dump(DumpContext ctx) const {
    ctx.line("ExprTernary");
    auto c = ctx.child();
    dump_expr_common(*this, c);
    c.line("Condition:");
    cond->dump(c.child());
    c.line("Then:");
    then_expr->dump(c.child());
    c.line("Else:");
    else_expr->dump(c.child());
}

void ExprCallUnary::dump(DumpContext ctx) const {
    ctx.line("ExprCallUnary: " + to_string(keyword));
    auto c = ctx.child();
    dump_expr_common(*this, c);
    c.line("Arg:");
    arg->dump(c.child());
}

void Patch::dump(DumpContext ctx) const {
    ctx.line("Patch");
    auto c = ctx.child();
    dump_expr_common(*inner, c);
    c.line("Offset: " + int_to_hex(offset) + ", Size: " + int_to_hex(size));

    if (is_constant) {
        c.line("Constant patch");
    }

    // Dump patch type
    std::string type_str;
    switch (type) {
    case PatchType::None:
        type_str = "None";
        break;
    case PatchType::Unsigned:
        type_str = "Unsigned";
        break;
    case PatchType::Signed:
        type_str = "Signed";
        break;
    case PatchType::HighByte:
        type_str = "HighByte";
        break;
    case PatchType::BigEndian:
        type_str = "BigEndian";
        break;
    case PatchType::PCrelative:
        type_str = "PCrelative";
        break;
    default:
        release_assert(0);
        break;
    }
    c.line("Type: " + type_str);

    // Dump validation
    std::string validation_str;
    switch (validation) {
    case CheckRange::Is_any:
        validation_str = "Any";
        break;
    case CheckRange::Is_0:
        validation_str = "0";
        break;
    case CheckRange::Is_0_1_2:
        validation_str = "0,1,2";
        break;
    case CheckRange::Is_0_1_2_3:
        validation_str = "0,1,2,3";
        break;
    case CheckRange::Is_0_1_2_3_4_5_6_7:
        validation_str = "0-7";
        break;
    case CheckRange::Is_1_2_3_4_5_6_7_0_8_10_18_20_28_30_38:
        validation_str = "1-7,0,8,10,18,20,28,30,38";
        break;
    case CheckRange::Is_2_3_4_5_7_10_18_20_28_38:
        validation_str = "2-5,7,10,18,20,28,38";
        break;
    case CheckRange::Is_1_2_4:
        validation_str = "1,2,4";
        break;
    case CheckRange::Is_1_2_4_8:
        validation_str = "1,2,4,8";
        break;
    case CheckRange::Is_40:
        validation_str = "40";
        break;
    case CheckRange::Is_8:
        validation_str = "8";
        break;
    default:
        release_assert(0);
    }
    c.line("Validation: " + validation_str);

    // Dump formula
    std::string formula_str;
    switch (formula) {
    case ExprFormula::None:
        formula_str = "None";
        break;
    case ExprFormula::ScaleBelowThreshold:
        formula_str = "ScaleBelowThreshold";
        break;
    case ExprFormula::AddScaled:
        formula_str = "AddScaled";
        break;
    case ExprFormula::SelectOrAdd:
        formula_str = "SelectOrAdd";
        break;
    case ExprFormula::Select2:
        formula_str = "Select2";
        break;
    case ExprFormula::Select3:
        formula_str = "Select3";
        break;
    default:
        release_assert(0);
    }
    c.line("Formula: " + formula_str);

    if (!coefs.empty()) {
        std::string coefs_str = "Coefficients: ";
        for (size_t i = 0; i < coefs.size(); ++i) {
            if (i > 0) {
                coefs_str += ", ";
            }
            coefs_str += int_to_hex(coefs[i]);
        }
        c.line(coefs_str);
    }

    if (type == PatchType::PCrelative) {
        c.line("Short jump (alt offset: " + int_to_hex(alt_offset) +
               ", alt size: " + int_to_hex(alt_size) + ")");
        if (!alt_bytes.empty()) {
            c.line("Alt bytes: " + format_bytes(alt_bytes));
        }
    }

    if (inner) {
        c.line("Inner expression:");
        inner->dump(c.child());
    }
}

void OrgStmt::dump(DumpContext ctx) const {
    ctx.line("OrgStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (expr) {
        c.line("Expression:");
        expr->dump(c.child());
    }
    c.line("Padding size: " + int_to_hex(padding_size));
    if (!bytes.empty()) {
        c.line("Bytes: " + format_bytes(bytes));
    }
}

void DefcStmt::dump(DumpContext ctx) const {
    ctx.line("DefcStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    c.line("Name: " + g_strings.to_string(name_id));
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (symbol) {
        c.line("Symbol info:");
        symbol->dump(c.child());
    }
    if (expr) {
        c.line("Expression:");
        expr->dump(c.child());
    }
}

// Helper for dumping statements with a single name_id
static void dump_named_stmt(const std::string& stmt_type,
                            StringInterner::Id name_id,
                            const SourceLoc& loc, DumpContext ctx) {
    ctx.line(stmt_type);
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    c.line("Name: " + g_strings.to_string(name_id));
}

void ModuleStmt::dump(DumpContext ctx) const {
    dump_named_stmt("ModuleStmt", name_id, loc, ctx);
}

void SectionStmt::dump(DumpContext ctx) const {
    dump_named_stmt("SectionStmt", name_id, loc, ctx);
}

void AlignStmt::dump(DumpContext ctx) const {
    ctx.line("AlignStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (align_expr) {
        c.line("Alignment:");
        align_expr->dump(c.child());
    }
    if (filler_expr) {
        c.line("Filler byte:");
        filler_expr->dump(c.child());
    }
    c.line("Padding size: " + int_to_hex(padding_size));
    if (!bytes.empty()) {
        c.line("Bytes: " + format_bytes(bytes));
    }
}

void DefsNumericStmt::dump(DumpContext ctx) const {
    ctx.line("DefsNumericStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (size_expr) {
        c.line("Size:");
        size_expr->dump(c.child());
    }
    if (filler_expr) {
        c.line("Filler byte:");
        filler_expr->dump(c.child());
    }
    c.line("Padding size: " + int_to_hex(padding_size));
    if (!bytes.empty()) {
        c.line("Bytes: " + format_bytes(bytes));
    }
}

void DefsStringStmt::dump(DumpContext ctx) const {
    ctx.line("DefsStringStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (size_expr) {
        c.line("Size:");
        size_expr->dump(c.child());
    }
    c.line("String literal: " + escape_string(g_strings.to_string(string_id)));
    c.line("Filler byte: " + int_to_hex(filler_byte));
    c.line("Padding size: " + int_to_hex(padding_size));
    if (!bytes.empty()) {
        c.line("Bytes: " + format_bytes(bytes));
    }
}

void SymbolDeclareStmt::dump(DumpContext ctx) const {
    ctx.line("SymbolDeclareStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());

    // Dump declaration type
    std::string type_str;
    switch (type) {
    case SymbolDeclareType::Extern:
        type_str = "Extern";
        break;
    case SymbolDeclareType::Public:
        type_str = "Public";
        break;
    case SymbolDeclareType::Global:
        type_str = "Global";
        break;
    default:
        type_str = "Unknown";
        break;
    }
    c.line("Type: " + type_str);

    // Dump symbol names
    if (!names.empty()) {
        c.line("Symbols:");
        auto sc = c.child();
        for (const auto& name : names) {
            sc.line(g_strings.to_string(name.id) + " at " + name.loc.to_string());
        }
    }
}

void ListStmt::dump(DumpContext ctx) const {
    ctx.line("ListStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    c.line("Enable: " + std::string(enable ? "true" : "false"));
}

void PhaseStmt::dump(DumpContext ctx) const {
    ctx.line("PhaseStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
    if (expr) {
        c.line("Expression:");
        expr->dump(c.child());
    }
}

void DephaseStmt::dump(DumpContext ctx) const {
    ctx.line("DephaseStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    if (section) {
        c.line("Section: " + section_name_or_empty(section));
    }
    c.line("Address: " + int_to_hex(address));
}

static std::string to_string(SymbolDeclareType type) {
    switch (type) {
    case SymbolDeclareType::Extern:
        return "Extern";
    case SymbolDeclareType::Public:
        return "Public";
    case SymbolDeclareType::Global:
        return "Global";
    default:
        return "Unknown";
    }
}


void SymbolInfo::dump(DumpContext ctx) const {
    std::string sym_str = g_strings.to_string(name_id) + ": ";

    switch (def_type) {
    case SymbolInfo::DefType::Undefined:
        sym_str += "Undefined";
        break;
    case SymbolInfo::DefType::Label:
        sym_str += "Label";
        if (stmt && stmt->section) {
            sym_str += " " + int_to_hex(stmt->address);
            sym_str += " in section " + section_name_or_empty(stmt->section);
        }
        break;
    case SymbolInfo::DefType::Defc:
        sym_str += "Defc";
        if (stmt && stmt->section) {
            sym_str += " in section " + section_name_or_empty(stmt->section);
        }
        if (defc_expr) {
            sym_str += " = " + to_string(defc_expr->tokens);
        }
        break;
    default:
        release_assert(0);
        break;
    }

    ctx.line(sym_str);
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());

    if (def_type == SymbolInfo::DefType::Defc && defc_expr) {
        c.line("Expression:");
        defc_expr->dump(c.child());
    }
}

Section::Section(StringInterner::Id name_id_)
    : name_id(name_id_) {
}

void Section::dump(DumpContext ctx) const {
    dump(ctx, nullptr);
}

void Section::dump(DumpContext ctx, const Section* current) const {
    std::string section_name = "Section: " + section_name_or_empty(this);
    if (this == current) {
        section_name += " (current)";
    }
    ctx.line(section_name);
    auto c = ctx.child();

    c.line("Size: " + int_to_hex(size));

    if (has_opcodes) {
        c.line("Has opcodes");
    }

    if (org_stmt) {
        c.line("Section ORG:");
        org_stmt->dump(c.child());
    }

    if (align_stmt) {
        c.line("Section ALIGN:");
        align_stmt->dump(c.child());
    }

    if (!stmts.empty()) {
        c.line("Statements:");
        auto sc = c.child();
        for (const auto& stmt : stmts) {
            stmt->dump(sc);
        }
    }
}


Module::Module(StringInterner::Id name_id_)
    : name_id(name_id_) {
    set_section(g_strings.intern(DEFAULT_SECTION));
}

Section* Module::set_section(StringInterner::Id sec_name_id) {
    for (auto& sec : sections) {
        if (sec_name_id == sec->name_id) {
            // section already present
            cur_section = sec.get();
            return cur_section;
        }
    }

    // create new section
    auto sec = std::make_unique<Section>(sec_name_id);
    sections.emplace_back(std::move(sec));
    cur_section = sections.back().get();
    return cur_section;
}

void Module::dump(DumpContext ctx) const {
    dump(ctx, nullptr);
}

void Module::dump(DumpContext ctx, const Module* current) const {
    std::string module_name = "Module: " + g_strings.to_string(name_id);
    if (this == current) {
        module_name += " (current)";
    }
    ctx.line(module_name);
    auto c = ctx.child();

    // Dump symbols sorted by name
    if (!symbols.empty()) {
        c.line("Symbols:");
        auto sc = c.child();

        // Collect and sort symbols by name string
        std::vector<std::pair<std::string, const SymbolInfo*>> sorted_symbols;
        for (const auto& [sym_name_id, sym] : symbols) {
            sorted_symbols.emplace_back(g_strings.to_string(sym_name_id), sym.get());
        }
        std::sort(sorted_symbols.begin(), sorted_symbols.end(),
        [](const auto & a, const auto & b) {
            return a.first < b.first;
        });

        for (const auto& [name, sym] : sorted_symbols) {
            sym->dump(sc);
        }
    }

    // Dump sections
    if (!sections.empty()) {
        c.line("Sections:");
        auto sc = c.child();
        for (const auto& sec : sections) {
            sec->dump(sc, cur_section);
        }
    }
}


Program::Program(StringInterner::Id name_id_)
    : name_id(name_id_) {
    set_module(name_id_);
}

Module* Program::set_module(StringInterner::Id mod_name_id) {
    for (auto& mod : modules) {
        if (mod_name_id == mod->name_id) {
            // module already present
            cur_module = mod.get();
            return cur_module;
        }
    }

    // create new module
    auto mod = std::make_unique<Module>(mod_name_id);
    modules.emplace_back(std::move(mod));
    cur_module = modules.back().get();
    return cur_module;
}

void Program::dump(DumpContext ctx) const {
    ctx.line("Program: " + g_strings.to_string(name_id));
    auto c = ctx.child();

    // Dump declarations sorted by name
    if (!declarations.empty()) {
        c.line("Declarations:");
        auto dc = c.child();

        // Collect and sort declarations by name string
        std::vector<std::pair<std::string, const SymbolDeclare*>> sorted_decls;
        for (const auto& [decl_name_id, decl] : declarations) {
            sorted_decls.emplace_back(g_strings.to_string(decl_name_id), decl.get());
        }
        std::sort(sorted_decls.begin(), sorted_decls.end(),
        [](const auto & a, const auto & b) {
            return a.first < b.first;
        });

        for (const auto& [name, decl] : sorted_decls) {
            std::string decl_str = name + ": " +
                                   to_string(decl->type) + " at " +
                                   decl->loc.to_string();
            dc.line(decl_str);
        }
    }

    // Dump modules
    if (!modules.empty()) {
        c.line("Modules:");
        auto mc = c.child();
        for (const auto& mod : modules) {
            mod->dump(mc, cur_module);
        }
    }

    // Dump statements
    if (!stmts.empty()) {
        c.line("Statements:");
        auto sc = c.child();
        for (const auto& stmt : stmts) {
            stmt->dump(sc);
        }
    }
}

void dump_ast_and_exit(const std::unique_ptr<Program>& prog) {
    DumpContext ctx(std::cout);
    prog->dump(ctx);
    exit(EXIT_SUCCESS);
}

