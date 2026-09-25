//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "errors.h"
#include "optimize.h"
#include "release_assert.h"
#include "simplify_expr.h"
#include "walker.h"
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

struct LabelRefVisitor : ASTVisitor {
    std::unordered_set<std::string> labels;

    explicit LabelRefVisitor(Prog& prog) {
        // collect labels from PRAGMA statements
        for (auto& stmt : prog.pragma_vars) {
            stmt->accept(*this);
        }
    }

    virtual ~LabelRefVisitor() = default;

    void collect_used_labels(const std::vector<TokLine>& asm_lines) {
        for (auto& line : asm_lines) {
            for (auto& token : line.tokens) {
                if (token.type == TokenType::LabelRefLine ||
                        token.type == TokenType::LabelRefAddr) {
                    labels.insert(token.svalue);
                }
            }
        }
    }

    void visit(LabelAddrRefExpr& e) override {
        labels.insert(e.name);
    }

    void visit(LabelLineRefExpr& e) override {
        labels.insert(e.name);
    }

    void visit(RemStmt& s) override {
        collect_used_labels(s.asm_lines);
    }

    void visit(PragmaStrVarStmt& s) override {
        collect_used_labels(s.asm_lines);
    }
};

struct RenameRefLabelsVisitor : ASTVisitor {
    std::unordered_map<std::string, std::string> label_map;

    explicit RenameRefLabelsVisitor(Prog& prog, const
                                    std::unordered_map<std::string, std::string>& m)
        : label_map(m) {
        // rename in PRAGMA statements
        for (auto& stmt : prog.pragma_vars) {
            stmt->accept(*this);
        }
    }

    virtual ~RenameRefLabelsVisitor() = default;

    void visit(LabelLineRefExpr& e) override {
        auto it = label_map.find(e.name);
        if (it != label_map.end()) {
            e.name = it->second;
        }
    }

    void visit(LabelAddrRefExpr& e) override {
        auto it = label_map.find(e.name);
        if (it != label_map.end()) {
            e.name = it->second;
        }
    }

    void rename_labels(std::vector<TokLine>& asm_lines) {
        for (auto& line : asm_lines) {
            for (auto& token : line.tokens) {
                if (token.type == TokenType::LabelRefLine ||
                        token.type == TokenType::LabelRefAddr) {
                    auto it = label_map.find(token.svalue);
                    if (it != label_map.end()) {
                        token.svalue = it->second;
                    }
                }
            }
        }
    }

    void visit(RemStmt& s) override {
        rename_labels(s.asm_lines);
    }

    void visit(PragmaStrVarStmt& s) override {
        rename_labels(s.asm_lines);
    }
};

static bool peephole(Prog& prog) {
    bool changed = false;

    // breaks flow
    auto is_breaking_stmt = [](Stmt * stmt) -> bool {
        if (dynamic_cast<GotoStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<ReturnStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<StopStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<EndStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<StopStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<RunStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<NewStmt*>(stmt)) {
            return true;
        }
        if (dynamic_cast<LoadStmt*>(stmt)) {
            return true;
        }
        return false;
    };

    // find out all jump targets
    LabelRefVisitor label_refs(prog);
    prog.accept(label_refs);

    for (size_t i = 0; i < prog.stmts.size(); ++i) {
        auto& stmt = prog.stmts[i];

        // eliminate IF 0 THEN GOTO xx
        // replace IF 1 THEN GOTO xx -> GOTO xx
        if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            release_assert(if_stmt->then_stmts.size() == 1);
            release_assert(if_stmt->else_stmts.size() == 0);
            auto cond_expr = dynamic_cast<NumberExpr*>(if_stmt->condition.get());
            if (cond_expr) {    // condition is constant
                if (cond_expr->value == 0.0) {  // IF never taken
                    // remove
                    prog.stmts.erase(prog.stmts.begin() + i);
                    --i;
                    changed = true;
                    continue;
                }
                else {  // IF always taken
                    // replace by then statement (GOTO)
                    prog.stmts[i] = if_stmt->then_stmts[0]->clone();
                    changed = true;
                    continue;
                }
            }
        }

        // eliminate GOTO to next statement
        if (auto goto_stmt = dynamic_cast<GotoStmt*>(stmt.get())) {
            if (i + 1 < prog.stmts.size()) {
                auto next_stmt = prog.stmts[i + 1].get();
                if (auto next_label_stmt = dynamic_cast<LabelStmt*>(next_stmt)) {
                    auto target_expr = dynamic_cast<LabelLineRefExpr*>
                                       (goto_stmt->target_expr.get());
                    if (target_expr && target_expr->name == next_label_stmt->label) {
                        // remove GOTO to next statement
                        prog.stmts.erase(prog.stmts.begin() + i);
                        --i;
                        changed = true;
                        continue;
                    }
                }
                if (auto next_line_stmt = dynamic_cast<LineNumStmt*>(next_stmt)) {
                    auto target_expr = dynamic_cast<NumberExpr*>(goto_stmt->target_expr.get());
                    if (target_expr
                            && static_cast<int>(target_expr->value) == next_line_stmt->line_num) {
                        // remove GOTO to next statement
                        prog.stmts.erase(prog.stmts.begin() + i);
                        --i;
                        changed = true;
                        continue;
                    }
                }
            }
        }

        // eliminate LET X=X
        if (auto let_stmt = dynamic_cast<LetStmt*>(stmt.get())) {
            auto lhs_var = dynamic_cast<VariableExpr*>(let_stmt->lhs.get());
            auto rhs_var = dynamic_cast<VariableExpr*>(let_stmt->rhs.get());
            if (lhs_var && rhs_var && lhs_var->name == rhs_var->name) {
                // remove LET X=X
                prog.stmts.erase(prog.stmts.begin() + i);
                --i;
                changed = true;
                continue;
            }
        }

        // eliminate labels not referenced
        if (auto label_stmt = dynamic_cast<LabelStmt*>(stmt.get())) {
            if (label_refs.labels.count(label_stmt->label) == 0) {
                // remove label
                prog.stmts.erase(prog.stmts.begin() + i);
                --i;
                changed = true;
                continue;
            }
        }

        // merge consecutive labels
        if (auto label_stmt = dynamic_cast<LabelStmt*>(stmt.get())) {
            if (i + 1 < prog.stmts.size()) {
                auto next_stmt = prog.stmts[i + 1].get();
                if (auto next_label_stmt = dynamic_cast<LabelStmt*>(next_stmt)) {
                    std::string name = label_stmt->label;
                    std::string alias = next_label_stmt->label;

                    // rename second label to first
                    std::unordered_map<std::string, std::string> label_map;
                    label_map[alias] = name;
                    RenameRefLabelsVisitor visitor(prog, label_map);
                    prog.accept(visitor);

                    // remove second label
                    prog.stmts.erase(prog.stmts.begin() + i + 1);
                    --i;
                    changed = true;
                    continue;
                }
            }
        }

        // simplify:
        //      IF cond THEN GOTO L1
        //      stmt
        //      L1:
        // into:
        //      IF not cond THEN stmt
        if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            auto& then_stmt = if_stmt->then_stmts[0];
            if (auto then_goto_stmt = dynamic_cast<GotoStmt*>(then_stmt.get())) {
                if (auto label_ref_expr = dynamic_cast<LabelLineRefExpr*>
                                          (then_goto_stmt->target_expr.get())) {
                    std::string target = label_ref_expr->name;

                    if (i + 2 < prog.stmts.size()) {
                        auto& stmt1 = prog.stmts[i + 1];
                        auto& stmt2 = prog.stmts[i + 2];
                        if (auto label_stmt = dynamic_cast<LabelStmt*>(stmt2.get())) {
                            if (target == label_stmt->label) {
                                // found construct; build new one
                                auto not_cond = make_node<UnaryExpr>
                                                (TokenType::NOT, std::move(if_stmt->condition), stmt->loc);
                                auto new_if_stmt = make_node<IfStmt>(std::move(not_cond), stmt->loc);
                                new_if_stmt->then_stmts.push_back(std::move(stmt1));
                                prog.stmts[i] = std::move(new_if_stmt);
                                prog.stmts.erase(prog.stmts.begin() + i + 1);
                                --i;
                                changed = true;
                                continue;
                            }
                        }
                    }
                }
            }
        }

        // remove unreachable statements after a breaking statement
        if (is_breaking_stmt(stmt.get())) {
            if (i + 1 < prog.stmts.size()) {
                auto& next_stmt = prog.stmts[i + 1];
                if (!dynamic_cast<LabelStmt*>(next_stmt.get()) &&
                        !dynamic_cast<LineNumStmt*>(next_stmt.get())) {
                    // remove unreachable statement
                    prog.stmts.erase(prog.stmts.begin() + i + 1);
                    --i;
                    changed = true;
                    continue;
                }
            }
        }
    }

    return changed;
}

bool optimize(Prog& prog) {
    bool changed = true;
    while (changed) {
        changed = false;
        simplify_exprs(prog);

        if (peephole(prog)) {
            changed = true;
        }
    }

    return get_error_count() == 0;
}
