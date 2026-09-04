//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../dump_context.h"
#include "../symtab.h"
#include <algorithm>
#include <string>
#include <unordered_map>
#include <vector>
#include "../errors.h"
#include "../ast_stmt.h"

static void dump_symtab_map(const char* name,
                            const std::unordered_map<std::string, SourceLoc>& map,
                            DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, loc] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key).dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_def_proc_stmt_map(const char* name,
        const std::unordered_map<std::string, DefProcStmt*>& map,
        DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_def_fn_stmt_map(const char* name,
                                        const std::unordered_map<std::string, DefFnStmt*>& map,
                                        DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_labels_map(const char* name,
                                   const std::unordered_map<std::string, LabelStmt*>& map,
                                   DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_line_nums_map(const char* name,
                                      const std::unordered_map<int, LineNumStmt*>& map,
                                      DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<int> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line(std::to_string(key) + " {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

void Symtab::dump(DumpContext ctx) const {
    ctx.line("Symtab {");
    auto child_ctx = ctx.child();
    dump_symtab_map("vars", vars, child_ctx);
    dump_symtab_map("arrays", arrays, child_ctx);
    dump_symtab_def_proc_stmt_map("procs", procs, child_ctx);
    dump_symtab_def_fn_stmt_map("fns", fns, child_ctx);
    dump_symtab_labels_map("labels", labels, child_ctx);
    dump_symtab_line_nums_map("line_nums", line_nums, child_ctx);
    ctx.line("}");
}

#endif
