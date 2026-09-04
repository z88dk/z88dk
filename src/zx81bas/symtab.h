//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast_stmt.h"
#include "dump_context.h"
#include "errors.h"
#include <string>
#include <unordered_map>

struct Symtab : TreeNode {
    std::unordered_map<std::string, SourceLoc> vars;        // variables
    std::unordered_map<std::string, SourceLoc> arrays;      // arrays
    std::unordered_map<std::string, DefProcStmt*> procs;    // procedures
    std::unordered_map<std::string, DefFnStmt*> fns;        // functions
    std::unordered_map<std::string, LabelStmt*> labels;     // target labels
    std::unordered_map<int, LineNumStmt*> line_nums;        // target line numbers

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

bool create_symtab(Prog& prog, std::unique_ptr<Symtab>& symtab);
