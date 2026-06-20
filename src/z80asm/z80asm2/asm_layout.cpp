//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_expr.h"
#include "asm_layout.h"
#include "diag.h"
#include "ir.h"
#include <string_view>

bool compute_layout(Program& prog, bool& changed) {
    bool in_phase = false;
    uint real_pc = 0;
    uint phase_pc = 0;
    SourceLoc phase_loc;

    // update the address set changed to true if any address is updated
    auto update = [&](uint & old_address, uint new_address) {
        if (old_address != new_address) {
            old_address = new_address;
            changed = true;
        }
    };

    // layout either with real_pc or phased_pc depending on in_phase
    auto layout = [&](uint & old_address, uint size) {
        if (in_phase) {
            update(old_address, phase_pc);
            real_pc += size;
            phase_pc += size;
        }
        else {
            update(old_address, real_pc);
            real_pc += size;
        }
    };

    bool failed = false;
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {
            in_phase = false;
            real_pc = 0;
            phase_pc = 0;
            phase_loc = SourceLoc();

            for (auto& stmt : sec->stmts) {
                if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                    opc_stmt->section = sec.get();
                    layout(opc_stmt->address, static_cast<uint>(opc_stmt->bytes.size()));
                    continue;
                }

                if (auto lbl_stmt = dynamic_cast<LabelStmt*>(stmt)) {
                    lbl_stmt->section = sec.get();
                    layout(lbl_stmt->address, 0);
                    continue;
                }

                if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt)) {
                    org_stmt->section = sec.get();
                    layout(org_stmt->address, 0);

                    uint base_address = 0;
                    if (sec->org_stmt) {
                        if (!get_const_expr_value(sec->org_stmt->expr.get(), base_address,
                                                  "ORG")) {
                            failed = true;
                        }
                    }

                    uint new_address = org_stmt->address;
                    if (!get_const_expr_value(org_stmt->expr.get(), new_address,
                                              "ORG")) {
                        failed = true;
                    }

                    if (new_address < base_address ||
                            new_address < org_stmt->address) {
                        g_diag.error(org_stmt->loc,
                                     "ORG address cannot be less than previously allocated address");
                        failed = true;
                        break; // cannot continue, org_stmt->padding_size would be very large
                    }

                    org_stmt->padding_size = new_address - org_stmt->address;
                    layout(org_stmt->address, org_stmt->padding_size);

                    continue;
                }

                if (auto defc_stmt = dynamic_cast<DefcStmt*>(stmt)) {
                    defc_stmt->section = sec.get();
                    layout(defc_stmt->address, 0);
                    continue;
                }

                if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt)) {
                    align_stmt->section = sec.get();
                    layout(align_stmt->address, 0);

                    uint align_value = 1;
                    if (!get_const_expr_value(align_stmt->align_expr.get(), align_value,
                                              "ALIGN")) {
                        failed = true;
                    }

                    if (align_value == 0 || (align_value & (align_value - 1)) != 0) {
                        g_diag.error(align_stmt->loc,
                                     "ALIGN value must be a power of two");
                        failed = true;
                        break;
                    }

                    uint new_address =
                        (align_stmt->address + (align_value - 1)) & ~(align_value - 1);
                    align_stmt->padding_size = new_address - align_stmt->address;
                    layout(align_stmt->address, align_stmt->padding_size);
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsNumericStmt*>(stmt)) {
                    defs_stmt->section = sec.get();
                    layout(defs_stmt->address, 0);

                    uint size_value = 0;
                    if (!get_const_expr_value(defs_stmt->size_expr.get(), size_value,
                                              "DEFS")) {
                        failed = true;
                    }

                    defs_stmt->padding_size = size_value;
                    layout(defs_stmt->address, defs_stmt->padding_size);
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsStringStmt*>(stmt)) {
                    defs_stmt->section = sec.get();
                    layout(defs_stmt->address, 0);

                    std::string_view str_value = g_strings.view(defs_stmt->string_id);
                    uint size_value = static_cast<uint>(str_value.size());
                    if (!get_const_expr_value(defs_stmt->size_expr.get(), size_value,
                                              "DEFS")) {
                        failed = true;
                    }

                    if (size_value < str_value.size()) {
                        g_diag.error(defs_stmt->loc,
                                     "DEFS size cannot be less than the string length");
                        failed = true;
                        break;
                    }

                    defs_stmt->padding_size = size_value;
                    layout(defs_stmt->address, defs_stmt->padding_size);
                    continue;
                }

                if (auto phase_stmt = dynamic_cast<PhaseStmt*>(stmt)) {
                    if (in_phase) {
                        g_diag.error(phase_stmt->loc,
                                     "Nested PHASE statements are not allowed");
                        g_diag.note(phase_loc, "Previous PHASE here");
                        failed = true;
                    }
                    else {
                        in_phase = true;
                        phase_loc = phase_stmt->loc;
                        phase_stmt->section = sec.get();

                        uint phase_value = 0;
                        if (!get_const_expr_value(phase_stmt->expr.get(), phase_value,
                                                  "PHASE")) {
                            failed = true;
                            break;
                        }

                        phase_pc = phase_value;
                        layout(phase_stmt->address, 0);
                    }
                    continue;
                }

                if (auto dephase_stmt = dynamic_cast<DephaseStmt*>(stmt)) {
                    if (!in_phase) {
                        g_diag.error(dephase_stmt->loc,
                                     "DEPHASE statements are not allowed outside of a PHASE");
                        failed = true;
                    }
                    else {
                        in_phase = false;
                        dephase_stmt->section = sec.get();
                        layout(dephase_stmt->address, 0);
                    }
                    continue;
                }
            }

            // Update section size after processing all statements
            sec->size = real_pc;
        }
    }

    return !failed;
}
