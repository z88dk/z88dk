//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"

#include "string_interner.h"
#include "string_utils.h"
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>

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

void Stmt::dump(DumpContext ctx) const {
    ctx.line("Stmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
}

void OpcodeStmt::dump(DumpContext ctx) const {
    ctx.line("OpcodeStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    c.line("Address: " + int_to_hex(address));

    if (is_short_jump) {
        c.line("Is short jump");
    }

    // Dump bytes
    if (!bytes.empty()) {
        std::string bytes_str = "Bytes: ";
        for (size_t i = 0; i < bytes.size(); ++i) {
            if (i > 0) {
                bytes_str += " ";
            }
            bytes_str += int_to_hex(bytes[i]);
        }
        c.line(bytes_str);
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

LabelStmt::LabelStmt(StringInterner::Id text_id_, const SourceLoc& loc_)
    : Stmt(loc_), text_id(text_id_) {
}

void LabelStmt::dump(DumpContext ctx) const {
    ctx.line("LabelStmt");
    auto c = ctx.child();
    c.line("Location: " + loc.to_string());
    std::string ident_str = g_strings.to_string(text_id);
    c.line("Label: " + ident_str);
    if (is_local) {
        c.line("Local part: " + ident_str.substr(at_pos));
    }
}

void Program::dump(DumpContext ctx) const {
    ctx.line("Program");
    auto c = ctx.child();
    for (const auto& stmt : stmts) {
        stmt->dump(c);
    }
}

void dump_ast_and_exit(const std::unique_ptr<Program>& prog) {
    DumpContext ctx(std::cout);
    prog->dump(ctx);
    exit(EXIT_SUCCESS);
}

void ExprLiteralInt::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralInt: " + int_to_hex(value));
}

void ExprLiteralFloat::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralFloat: " + std::to_string(value));
}

void ExprLiteralAsmpc::dump(DumpContext ctx) const {
    ctx.line("ExprLiteralAsmpc");
}

void ExprSymbol::dump(DumpContext ctx) const {
    ctx.line("ExprSymbol: " + g_strings.to_string(name_id));
}

void ExprLocalLabel::dump(DumpContext ctx) const {
    ctx.line("ExprLocalLabel: " + g_strings.to_string(name_id) + " @ " + std::to_string(at_pos));
}

void ExprUnary::dump(DumpContext ctx) const {
    ctx.line("ExprUnary: " + to_string(op));
    auto c = ctx.child();
    c.line("RHS:");
    rhs->dump(c.child());
}

void ExprBinary::dump(DumpContext ctx) const {
    ctx.line("ExprBinary: " + to_string(op));
    auto c = ctx.child();
    c.line("LHS:");
    lhs->dump(c.child());
    c.line("RHS:");
    rhs->dump(c.child());
}

void ExprTernary::dump(DumpContext ctx) const {
    ctx.line("ExprTernary");
    auto c = ctx.child();
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
    c.line("Arg:");
    arg->dump(c.child());
}

void Patch::dump(DumpContext ctx) const {
    ctx.line("Patch");
    auto c = ctx.child();
    c.line("Offset: " + int_to_hex(offset) + ", Size: " + int_to_hex(size));

    if (is_constant) {
        c.line("Constant patch");
    }

    // Dump patch type
    std::string type_str;
    switch (type) {
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
        type_str = "Unknown";
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
        validation_str = "Unknown";
        break;
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
        formula_str = "Unknown";
        break;
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
            std::string alt_str = "Alt bytes: ";
            for (size_t i = 0; i < alt_bytes.size(); ++i) {
                if (i > 0) {
                    alt_str += " ";
                }
                alt_str += int_to_hex(alt_bytes[i]);
            }
            c.line(alt_str);
        }
    }

    if (inner) {
        c.line("Inner expression:");
        inner->dump(c.child());
    }
}
