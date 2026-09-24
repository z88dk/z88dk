//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "optimize.h"
#include "simplify_expr.h"
#include <string>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <vector>
#include "release_assert.h"

/*
struct BasicBlock {
    std::vector<Stmt*> stmts;   // statements in the block
};

struct CFGNode {
    BasicBlock* block;
    std::vector<CFGNode*> succ;  // outgoing edges
    std::vector<CFGNode*> pred;  // incoming edges
};

struct CFGTarget {
    std::string label;
    int line_num = -1;

    explicit CFGTarget(std::string label_) : label(label_), line_num(-1) {}
    explicit CFGTarget(int line_num_) : label(), line_num(line_num_) {}

    bool operator==(const CFGTarget& other) const {
        return label == other.label &&
               line_num == other.line_num;
    }
};

// make CFGTarget hashable
template <>
struct std::hash<CFGTarget> {
    std::size_t operator()(const CFGTarget& t) const noexcept {
        std::size_t h1 = std::hash<std::string> {}(t.label);
        std::size_t h2 = std::hash<int> {}(t.line_num);

        // Simple hash combine
        return h1 ^ (h2 + 0x9e3779b9 + (h1 << 6) + (h1 >> 2));
    }
};


static std::vector<BasicBlock> build_basic_blocks(std::vector<StmtPtr>& stmts) {
    std::vector<BasicBlock> blocks;
    BasicBlock cur_block;

    auto is_label = [&](Stmt* s) {
        return dynamic_cast<LabelStmt*>(s) ||
            dynamic_cast<LineNumStmt*>(s);
        };

    auto is_terminator = [&](Stmt* s) {
        return dynamic_cast<IfStmt*>(s) ||
            dynamic_cast<ForStmt*>(s) ||
            dynamic_cast<NextStmt*>(s) ||
            dynamic_cast<GotoStmt*>(s) ||
            dynamic_cast<GosubStmt*>(s) ||
            dynamic_cast<ReturnStmt*>(s) ||
            dynamic_cast<StopStmt*>(s) ||
            dynamic_cast<EndStmt*>(s) ||
            dynamic_cast<RunStmt*>(s) ||
            dynamic_cast<NewStmt*>(s);
        };

    for (auto& stmt : stmts) {
        if (is_label(stmt.get())) {
            if (!cur_block.stmts.empty()) {
                blocks.push_back(std::move(cur_block));
                cur_block = BasicBlock();
            }
        }
        cur_block.stmts.push_back(stmt.get());
        if (is_terminator(stmt.get())) {
            blocks.push_back(std::move(cur_block));
            cur_block = BasicBlock();
        }
    }

    if (!cur_block.stmts.empty()) {
        blocks.push_back(std::move(cur_block));
    }

    return blocks;
}

static std::unordered_map<CFGTarget, size_t> build_cfg_targets(std::vector<BasicBlock>& blocks) {
    std::unordered_map<CFGTarget, size_t> targets;
    for (size_t i = 0; i < blocks.size(); ++i) {
        auto& block = blocks[i];
        if (block.stmts.empty()) {
            continue;
        }
        Stmt* first_stmt = block.stmts.front();
        if (auto label_stmt = dynamic_cast<LabelStmt*>(first_stmt)) {
            targets[CFGTarget(label_stmt->label)] = i;
        }
        else if (auto line_num_stmt = dynamic_cast<LineNumStmt*>(first_stmt)) {
            targets[CFGTarget(line_num_stmt->line_num)] = i;
        }
    }
    return targets;
}

static CFGTarget expr_to_cfg_target(Expr* expr) {
    if (auto label_expr = dynamic_cast<LabelLineRefExpr*>(expr)) {
        return CFGTarget(label_expr->name);
    }
    else if (auto num_expr = dynamic_cast<NumberExpr*>(expr)) {
        return CFGTarget(static_cast<int>(num_expr->value));
    }
    else {
        release_assert(0 && "Invalid expression for CFG target");
        return CFGTarget(-1);
    }
}

static std::vector<CFGNode> build_cfg_nodes(std::vector<BasicBlock>& blocks) {
    std::vector<CFGNode> cfg;

    // add all blocks as nodes in the CFG
    cfg.reserve(blocks.size());
    for (auto& block : blocks) {
        CFGNode node;
        node.block = &block;
        cfg.push_back(std::move(node));
    }

    // add edges between nodes based on control flow
    auto label_to_block = build_cfg_targets(blocks);
    for (size_t i = 0; i < cfg.size(); ++i) {
        CFGNode& node = cfg[i];
        BasicBlock& block = *node.block;

        if (block.stmts.empty()) {
            continue;
        }

        auto add_edge = [&](size_t target) {
            if (target < cfg.size()) {
                node.succ.push_back(&cfg[target]);
                cfg[target].pred.push_back(&node);
            }
            };

        Stmt* last_stmt = block.stmts.back();

        // GOTO
        if (auto g = dynamic_cast<GotoStmt*>(last_stmt)) {
            add_edge(label_to_block[CFGTarget(g->target)]);
            continue;
        }

        // IF
        if (auto ifs = dynamic_cast<IfStmt*>(last_stmt)) {
            add_edge(label_to_block[ifs->target]);
            add_edge(i + 1); // fallthrough
            continue;
        }

        // FOR
        if (auto fs = dynamic_cast<ForStmt*>(last_stmt)) {
            add_edge(i + 1); // loop body
            add_edge(label_to_block[fs->exit_label]);
            continue;
        }

        // NEXT
        if (auto ns = dynamic_cast<NextStmt*>(last_stmt)) {
            add_edge(label_to_block[ns->for_label]);
            continue;
        }

        // GOSUB
        if (auto gs = dynamic_cast<GosubStmt*>(last_stmt)) {
            add_edge(label_to_block[gs->target]); // subroutine entry
            add_edge(i + 1);                      // return continuation
            continue;
        }

        // RETURN
        if (dynamic_cast<ReturnStmt*>(last_stmt)) {
            for (int caller : all_gosub_callers_of_this_subroutine) {
                add_edge(caller + 1);
            }
            continue;
        }

        // STOP / RUN / NEW / END
        if (dynamic_cast<StopStmt*>(last_stmt) ||
            dynamic_cast<RunStmt*>(last_stmt) ||
            dynamic_cast<NewStmt*>(last_stmt) ||
            dynamic_cast<EndStmt*>(last_stmt)) {
            continue; // no successors
        }

        // Non-terminator: fallthrough
        add_edge(i + 1);
    }

    return cfg;
}

// Destination of a Control Flow change
// Control Flow Graph Basic Block
struct CFBasicBlock {
    CFGTarget entry;                     // entry point
    std::unordered_set<CFGTarget> exits; // exit points
    std::vector<StmtPtr> stmts;         // list of statements
    bool remove = false;

    explicit CFBasicBlock(std::string label_) : entry(label_) {}
    explicit CFBasicBlock(int line_num_) : entry(line_num_) {}

    CFBasicBlock(const CFBasicBlock&) = delete;
    CFBasicBlock& operator=(const CFBasicBlock&) = delete;
    CFBasicBlock(CFBasicBlock&&) = default;
    CFBasicBlock& operator=(CFBasicBlock&&) = default;

    void init(std::string label_) {
        entry = CFGTarget(label_);
        exits.clear();
        stmts.clear();
    }

    void init(int line_num_) {
        entry = CFGTarget(line_num_);
        exits.clear();
        stmts.clear();
    }
};

// update list of exists with jumps from the statement
static void update_exits(std::unordered_set<CFGTarget>& exits, Expr& expr) {
    if (auto e = dynamic_cast<LabelLineRefExpr*>(&expr)) {
        exits.insert(CFGTarget(e->name));
        return;
    }

    if (auto e = dynamic_cast<NumberExpr*>(&expr)) {
        exits.insert(CFGTarget(static_cast<int>(e->value)));
        return;
    }
}

static void update_exits(std::unordered_set<CFGTarget>& exits, Stmt& stmt) {
    if (auto s = dynamic_cast<GotoStmt*>(&stmt)) {
        update_exits(exits, *s->target_expr);
        return;
    }

    if (auto s = dynamic_cast<GosubStmt*>(&stmt)) {
        update_exits(exits, *s->target_expr);
        return;
    }

    if (auto s = dynamic_cast<RunStmt*>(&stmt)) {
        if (s->target_expr) {
            update_exits(exits, *s->target_expr);
        }
        return;
    }
}

// build a CFG from a list of statements
static std::vector<CFBasicBlock> build_cfg(std::vector<StmtPtr>& stmts) {
    std::vector<CFBasicBlock> out;

    // initial block
    CFBasicBlock cur_block(0);

    for (auto& stmt : stmts) {
        if (auto s = dynamic_cast<LabelStmt*>(stmt.get())) {
            cur_block.exits.insert(CFGTarget(s->label));
            out.push_back(std::move(cur_block));

            cur_block.init(s->label);
            cur_block.stmts.push_back(std::move(stmt));
            continue;
        }

        if (auto s = dynamic_cast<LineNumStmt*>(stmt.get())) {
            cur_block.exits.insert(CFGTarget(s->line_num));
            out.push_back(std::move(cur_block));

            cur_block.init(s->line_num);
            cur_block.stmts.push_back(std::move(stmt));
            continue;
        }

        if (auto s = dynamic_cast<IfStmt*>(stmt.get())) {
            update_exits(cur_block.exits, *s->then_stmts.front());
            cur_block.stmts.push_back(std::move(stmt));
            continue;
        }

        if (dynamic_cast<GotoStmt*>(stmt.get())) {
            update_exits(cur_block.exits, *stmt);
            cur_block.stmts.push_back(std::move(stmt));
            out.push_back(std::move(cur_block));

            cur_block.init(-1);
            continue;
        }

        if (dynamic_cast<ReturnStmt*>(stmt.get())) {
            cur_block.stmts.push_back(std::move(stmt));
            out.push_back(std::move(cur_block));

            cur_block.init(-1);
            continue;
        }

        if (dynamic_cast<StopStmt*>(stmt.get())) {
            cur_block.stmts.push_back(std::move(stmt));
            out.push_back(std::move(cur_block));

            cur_block.init(-1);
            continue;
        }

        if (dynamic_cast<RunStmt*>(stmt.get())) {
            update_exits(cur_block.exits, *stmt);
            cur_block.stmts.push_back(std::move(stmt));
            out.push_back(std::move(cur_block));

            cur_block.init(-1);
            continue;
        }

        if (dynamic_cast<NewStmt*>(stmt.get())) {
            cur_block.stmts.push_back(std::move(stmt));
            out.push_back(std::move(cur_block));

            cur_block.init(-1);
            continue;
        }

        update_exits(cur_block.exits, *stmt);
        cur_block.stmts.push_back(std::move(stmt));
    }

    out.push_back(std::move(cur_block));
    stmts.clear();

    return out;
}

static std::vector<StmtPtr> unpack_cfg(std::vector<CFBasicBlock>& cfg_blocks) {
    std::vector<StmtPtr> out;

    for (auto& block : cfg_blocks) {
        if (!block.remove) {
            for (auto& stmt : block.stmts) {
                if (!stmt->rewrite.remove) {
                    out.push_back(std::move(stmt));
                }
            }
        }
    }

    return out;
}

static bool remove_unreachable_code(Prog& prog) {
    bool changed = false;

    // find all jump targets
    std::unordered_set<CFGTarget> targets;
    targets.insert(CFGTarget(0));        // start line

    auto cfg_blocks = build_cfg(prog.stmts);
    for (auto& block : cfg_blocks) {
        for (auto& target : block.exits) {
            targets.insert(target);
        }
    }

    // remove all blocks that are not target of any jump
    for (auto& block : cfg_blocks) {
        if (targets.count(block.entry) == 0) {  // not used
            block.remove = true;
            changed = true;
        }
    }

    auto stmts = unpack_cfg(cfg_blocks);
    prog.stmts = std::move(stmts);

    return changed;
}

// remove IF 0 THEN GOTO xx
// replace IF 1 THEN GOTO xx -> GOTO xx
struct EliminateConstIfVisitor : ASTVisitor {
    bool changed = false;

    virtual ~EliminateConstIfVisitor() = default;

    void visit(IfStmt& stmt) override {
        auto cond_expr = dynamic_cast<NumberExpr*>(stmt.condition.get());
        if (cond_expr) {    // condition is constant
            if (cond_expr->value == 0.0) {  // IF never taken
                // remove
                stmt.rewrite.remove = true;
                changed = true;
            }
            else {  // IF always taken
                release_assert(stmt.then_stmts.size() == 1);
                release_assert(stmt.else_stmts.size() == 0);

                // replace by then statement (GOTO)
                stmt.rewrite.prepend.push_back(stmt.then_stmts[0]->clone());
                stmt.rewrite.remove = true;
                changed = true;
            }
        }
    }
};

static bool eliminate_const_if(Prog& prog) {
    EliminateConstIfVisitor visitor;
    prog.accept(visitor);
    return visitor.changed;
}
*/

static bool peephole(Prog& prog) {
    bool changed = false;
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
    }

    return changed;
}

bool optimize(Prog& prog) {
    simplify_exprs(prog);
    while (peephole(prog)) {
    }

    /*
    bool changed = true;
    while (changed) {
        changed = false;
        std::vector<BasicBlock> blocks = build_basic_blocks(prog.stmts);
        std::vector<CFGNode> cfg_nodes = build_cfg_nodes(blocks);

        if (remove_unreachable_code(prog)) {
            changed = true;
        }

        if (eliminate_const_if(prog)) {
            changed = true;
        }
    }
    */

    return get_error_count() == 0;
}
