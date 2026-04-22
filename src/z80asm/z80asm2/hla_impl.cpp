//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "hla_ast.h"
#include "hla_builder.h"
#include "hla_impl.h"
#include "lexer.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include <cassert>
#include <memory>
#include <string>
#include <utility>
#include <vector>

std::unique_ptr<HLA_Program> hla_parse(const std::vector<LogicalLine>& lines) {
    HLA_ProgramBuilder builder;     // manages the stack
    for (const auto& ll : lines) {
        if (ll.tokens.empty()) {    // need tokens to recreate LogicalLine
            continue;
        }

        ParseLine line(ll.tokens);
        if (builder.handle_directive(line)) {
            continue;   // directive handled by dispatcher, skip to next line
        }

        builder.handle_asm(line); // normal assembly line, add to current block
    }

    return builder.finish();   // checks for unclosed blocks}
}

void hla_semantic_check(HLA_Program& program) {
    hla_semantic_check_body(program.nodes);
}

void hla_semantic_check_body(std::vector<std::unique_ptr<HLA_Node>>& body) {
    for (auto& node : body) {
        if (auto* if_node = dynamic_cast<HLA_If*>(node.get())) {
            for (auto& branch : if_node->branches) {
                branch.condition = fold_expr(std::move(branch.condition));
                if (dynamic_cast<HLA_True*>(branch.condition.get())) {
                    branch.is_always_true = true;
                }
                else if (dynamic_cast<HLA_False*>(branch.condition.get())) {
                    branch.is_always_false = true;
                }

                hla_semantic_check_body(branch.body);
            }

            hla_semantic_check_body(if_node->else_body);
        }

        if (auto* loop_node = dynamic_cast<HLA_Loop*>(node.get())) {
            hla_semantic_check_body(loop_node->body);
        }

        if (auto* while_node = dynamic_cast<HLA_While*>(node.get())) {
            while_node->condition = fold_expr(std::move(while_node->condition));
            if (dynamic_cast<HLA_True*>(while_node->condition.get())) {
                while_node->is_forever = true;
            }
            else if (dynamic_cast<HLA_False*>(while_node->condition.get())) {
                while_node->never_runs = true;
            }
        }

        if (auto* repeat_node = dynamic_cast<HLA_Repeat*>(node.get())) {
            if (repeat_node->type == RepeatType::UntilExpr) {
                repeat_node->condition = fold_expr(std::move(repeat_node->condition));
                if (dynamic_cast<HLA_False*>(repeat_node->condition.get())) {
                    repeat_node->is_forever = true;
                }
                else if (dynamic_cast<HLA_True*>(repeat_node->condition.get())) {
                    repeat_node->runs_only_once = true;
                }
            }
        }
    }
}

enum class ConstBool { Unknown, True, False };

static ConstBool eval_const(const HLA_Expr* e) {
    if (dynamic_cast<const HLA_True*>(e)) {
        return ConstBool::True;
    }
    if (dynamic_cast<const HLA_False*>(e)) {
        return ConstBool::False;
    }
    return ConstBool::Unknown;
}

std::unique_ptr<HLA_Expr> fold_expr(std::unique_ptr<HLA_Expr> expr) {
    if (!expr) {
        return nullptr;
    }

    // Try each node type
    if (dynamic_cast<HLA_True*>(expr.get())) {
        return expr;
    }

    if (dynamic_cast<HLA_False*>(expr.get())) {
        return expr;
    }

    if (auto* n = dynamic_cast<HLA_NotExpr*>(expr.get())) {
        n->child = fold_expr(std::move(n->child));

        switch (eval_const(n->child.get())) {
        case ConstBool::True:
            return std::make_unique<HLA_False>();
        case ConstBool::False:
            return std::make_unique<HLA_True>();
        default:
            return expr;
        }
    }

    if (auto* a = dynamic_cast<HLA_AndExpr*>(expr.get())) {
        a->left = fold_expr(std::move(a->left));
        a->right = fold_expr(std::move(a->right));

        auto L = eval_const(a->left.get());
        auto R = eval_const(a->right.get());

        // Short-circuit: if either side is FALSE, whole expr is FALSE
        if (L == ConstBool::False || R == ConstBool::False) {
            return std::make_unique<HLA_False>();
        }

        // If both are TRUE, whole expr is TRUE
        if (L == ConstBool::True && R == ConstBool::True) {
            return std::make_unique<HLA_True>();
        }

        // Otherwise: unknown
        return expr;
    }

    if (auto* o = dynamic_cast<HLA_OrExpr*>(expr.get())) {
        o->left = fold_expr(std::move(o->left));
        o->right = fold_expr(std::move(o->right));

        auto L = eval_const(o->left.get());
        auto R = eval_const(o->right.get());

        // If either side is TRUE -> whole expr is TRUE
        if (L == ConstBool::True || R == ConstBool::True) {
            return std::make_unique<HLA_True>();
        }

        // If both sides are FALSE -> whole expr is FALSE
        if (L == ConstBool::False && R == ConstBool::False) {
            return std::make_unique<HLA_False>();
        }

        // Otherwise: unknown
        return expr;
    }

    // Flag tests and comparisons are never constant
    return expr;
}

static void emit_jmp(HLA_Label label, const SourceLoc& loc,
                     std::vector<LogicalLine>& out) {
    std::string text = "JR " + label.to_string();
    LogicalLine ll(loc);
    ll.tokens = tokenize_text(text, loc);
    out.push_back(std::move(ll));
}

static void emit_jcc(Keyword cond, HLA_Label label, const SourceLoc& loc,
                     std::vector<LogicalLine>& out) {
    std::string text = "JR " + keyword_to_string(cond) + ", " + label.to_string();
    LogicalLine ll(loc);
    ll.tokens = tokenize_text(text, loc);
    out.push_back(std::move(ll));
}

void emit_djnz(Keyword reg_kw, HLA_Label label,
               const SourceLoc& loc, std::vector<LogicalLine>& out) {
    std::vector<std::string> code;
    switch (reg_kw) {
    case Keyword::B:
        code.push_back("DJNZ " + label.to_string());
        break;
    case Keyword::A:
    case Keyword::C:
    case Keyword::D:
    case Keyword::E:
    case Keyword::H:
    case Keyword::L:
        code.push_back("DEC " + keyword_to_string(reg_kw));
        code.push_back("JR NZ, " + label.to_string());
        break;
    case Keyword::BC:
    case Keyword::DE:
    case Keyword::HL: {
        std::string register_pair = keyword_to_string(reg_kw);
        assert(register_pair.size() == 2); // sanity check
        std::string reg1(1, register_pair[0]);
        std::string reg2(1, register_pair[1]);

        code.push_back("DEC " + register_pair);
        code.push_back("LD A, " + reg1);
        code.push_back("OR " + reg2);
        code.push_back("JR NZ, " + label.to_string());
        break;
    }
    default:
        assert(0);
    }

    for (auto& text : code) {
        LogicalLine ll(loc);
        ll.tokens = tokenize_text(text, loc);
        out.push_back(std::move(ll));
    }
}

static void emit_cmp(const HLA_CompareExpr& cmp, const SourceLoc& loc,
                     std::vector<LogicalLine>& out) {
    if (!(cmp.left.size() == 1 && cmp.left[0].keyword == Keyword::A)) {
        // Build LD A, <expr> preserving original token locations
        LogicalLine ll(loc);
        SourceLoc expr_loc = cmp.left.empty() ? loc : cmp.left[0].loc;

        ll.tokens.push_back(Token::identifier("LD", expr_loc));
        ll.tokens.push_back(Token::identifier("A", expr_loc));
        ll.tokens.push_back(Token::token(TokenType::Comma, ",", expr_loc));

        // Append the original expression tokens
        for (const auto& tok : cmp.left) {
            ll.tokens.push_back(tok);
        }

        // Calculate EndOfLine location after the last token
        SourceLoc eol_loc = expr_loc;
        if (!cmp.left.empty()) {
            const Token& last = cmp.left.back();
            std::string_view text = g_strings.view(last.text_id);
            eol_loc = last.loc;
            eol_loc.column = static_cast<uint16_t>(last.loc.column + text.size());
        }

        ll.tokens.push_back(Token::end_of_line(eol_loc));
        out.push_back(std::move(ll));
    }

    // Build CP <expr> preserving original token locations
    LogicalLine ll(loc);
    SourceLoc expr_loc = cmp.right.empty() ? loc : cmp.right[0].loc;

    ll.tokens.push_back(Token::identifier("CP", expr_loc));

    // Append the original expression tokens
    for (const auto& tok : cmp.right) {
        ll.tokens.push_back(tok);
    }

    // Calculate EndOfLine location after the last token
    SourceLoc eol_loc = expr_loc;
    if (!cmp.right.empty()) {
        const Token& last = cmp.right.back();
        std::string_view text = g_strings.view(last.text_id);
        eol_loc = last.loc;
        eol_loc.column = static_cast<uint16_t>(last.loc.column + text.size());
    }

    ll.tokens.push_back(Token::end_of_line(eol_loc));
    out.push_back(std::move(ll));
}

static void place_label(HLA_Label label, const SourceLoc& loc,
                        std::vector<LogicalLine>& out) {
    std::string text = label.to_string() + ":";
    LogicalLine ll(loc);
    ll.tokens = tokenize_text(text, loc);
    out.push_back(std::move(ll));
}

static Keyword compare_to_condition(const HLA_CompareExpr& cmp) {
    switch (cmp.op) {
    case HLA_CompareExpr::Type::UnsignedLT:
        return Keyword::LTU;
    case HLA_CompareExpr::Type::UnsignedLE:
        return Keyword::LEU;
    case HLA_CompareExpr::Type::UnsignedGT:
        return Keyword::GTU;
    case HLA_CompareExpr::Type::UnsignedGE:
        return Keyword::GEU;
    case HLA_CompareExpr::Type::SignedLT:
        return Keyword::LT;
    case HLA_CompareExpr::Type::SignedLE:
        return Keyword::LE;
    case HLA_CompareExpr::Type::SignedGT:
        return Keyword::GT;
    case HLA_CompareExpr::Type::SignedGE:
        return Keyword::GE;
    case HLA_CompareExpr::Type::EQ:
        return Keyword::EQ;
    case HLA_CompareExpr::Type::NE:
        return Keyword::NZ;
    default:
        assert(0);
        return Keyword::None;
    }
}

void hla_emit_cond(const HLA_Expr& e,
                   HLA_Label Ltrue,
                   HLA_Label Lfalse,
                   bool prefer_true_fallthrough,
                   std::vector<LogicalLine>& out) {
    // ------------------------------------------------------------
    // TRUE
    // ------------------------------------------------------------
    if (dynamic_cast<const HLA_True*>(&e)) {
        if (Ltrue.is_valid()) {
            emit_jmp(Ltrue, e.loc, out);
        }
        return; // fall through = true
    }

    // ------------------------------------------------------------
    // FALSE
    // ------------------------------------------------------------
    if (dynamic_cast<const HLA_False*>(&e)) {
        if (Lfalse.is_valid()) {
            emit_jmp(Lfalse, e.loc, out);
        }
        return; // fall through = false
    }

    // ------------------------------------------------------------
    // NOT
    // ------------------------------------------------------------
    if (auto* n = dynamic_cast<const HLA_NotExpr*>(&e)) {
        // Swap labels and invert fallthrough preference
        hla_emit_cond(*n->child,
                      Lfalse, Ltrue,
                      !prefer_true_fallthrough,
                      out);
        return;
    }

    // ------------------------------------------------------------
    // AND (short-circuit)
    // ------------------------------------------------------------
    if (auto* a = dynamic_cast<const HLA_AndExpr*>(&e)) {

        // Case 1: only Lfalse is real -> fallthrough = true
        if (!Ltrue.is_valid()) {
            // A && B is false if A is false or B is false
            hla_emit_cond(*a->left,
                          /*Ltrue=*/NoLabel,
                          Lfalse,
                          /*prefer_true_fallthrough=*/true,
                          out);

            // If left was true, fall through here and evaluate right
            hla_emit_cond(*a->right,
                          /*Ltrue=*/NoLabel,
                          Lfalse,
                          /*prefer_true_fallthrough=*/true,
                          out);
            return;
        }

        // Case 2: both labels real
        HLA_Label Lmid;

        // If A is true -> evaluate B
        // If A is false -> jump to Lfalse
        hla_emit_cond(*a->left,
                      /*Ltrue=*/Lmid,
                      Lfalse,
                      /*prefer_true_fallthrough=*/false,
                      out);

        place_label(Lmid, e.loc, out);

        // Now evaluate B
        hla_emit_cond(*a->right,
                      Ltrue,
                      Lfalse,
                      /*prefer_true_fallthrough=*/false,
                      out);
        return;
    }

    // ------------------------------------------------------------
    // OR (short-circuit)
    // ------------------------------------------------------------
    if (auto* o = dynamic_cast<const HLA_OrExpr*>(&e)) {

        // Case 1: only Ltrue is real -> fallthrough = false
        if (!Lfalse.is_valid()) {
            // A || B is true if A is true or B is true
            hla_emit_cond(*o->left,
                          Ltrue,
                          /*Lfalse=*/NoLabel,
                          /*prefer_true_fallthrough=*/false,
                          out);

            // If left was false, fall through here and evaluate right
            hla_emit_cond(*o->right,
                          Ltrue,
                          /*Lfalse=*/NoLabel,
                          /*prefer_true_fallthrough=*/false,
                          out);
            return;
        }

        // Case 2: only Lfalse is real -> short-circuit true path
        if (!Ltrue.is_valid()) {
            HLA_Label Ldone;

            // If left is true -> done (expression true)
            // If left is false -> evaluate right
            hla_emit_cond(*o->left,
                          /*Ltrue=*/Ldone,
                          /*Lfalse=*/NoLabel,
                          /*prefer_true_fallthrough=*/false,
                          out);

            // Now only right can make expression false
            hla_emit_cond(*o->right,
                          /*Ltrue=*/NoLabel,
                          Lfalse,
                          /*prefer_true_fallthrough=*/true,
                          out);

            place_label(Ldone, e.loc, out);
            return;
        }

        // Case 3: both labels real
        HLA_Label Lmid;

        // If A is true -> jump to Ltrue
        // If A is false -> evaluate B
        hla_emit_cond(*o->left,
                      Ltrue,
                      /*Lfalse=*/Lmid,
                      /*prefer_true_fallthrough=*/true,
                      out);

        place_label(Lmid, e.loc, out);

        // Now evaluate B
        hla_emit_cond(*o->right,
                      Ltrue,
                      Lfalse,
                      /*prefer_true_fallthrough=*/true,
                      out);
        return;
    }

    // ------------------------------------------------------------
    // FLAG TEST (Z, NZ, C, NC, ...)
    // ------------------------------------------------------------
    if (auto* fl = dynamic_cast<const HLA_FlagExpr*>(&e)) {

        auto cond = fl->flag_token.keyword;
        auto inverted = keyword_invert_flag_condition(cond);

        if (!Ltrue.is_valid()) {
            // Only false label is real -> jump on NOT cond
            emit_jcc(inverted, Lfalse, e.loc, out);
            return;
        }

        if (!Lfalse.is_valid()) {
            // Only true label is real -> jump on cond
            emit_jcc(cond, Ltrue, e.loc, out);
            return;
        }

        // Both labels real
        if (prefer_true_fallthrough) {
            // Fallthrough = true -> jump on false
            emit_jcc(inverted, Lfalse, e.loc, out);
        }
        else {
            // Fallthrough = false -> jump on true
            emit_jcc(cond, Ltrue, e.loc, out);
        }
        return;
    }

    // ------------------------------------------------------------
    // COMPARISON (A < B, HL >= expr, etc.)
    // ------------------------------------------------------------
    if (auto* cmp = dynamic_cast<const HLA_CompareExpr*>(&e)) {

        auto cond = compare_to_condition(*cmp); // your helper
        auto inverted = keyword_invert_flag_condition(cond);

        emit_cmp(*cmp, e.loc, out);

        if (!Ltrue.is_valid()) {
            // Only false label is real -> jump on NOT cond
            emit_jcc(inverted, Lfalse, e.loc, out);
            return;
        }

        if (!Lfalse.is_valid()) {
            // Only true label is real -> jump on cond
            emit_jcc(cond, Ltrue, e.loc, out);
            return;
        }

        // Both labels real
        if (prefer_true_fallthrough) {
            emit_jcc(inverted, Lfalse, e.loc, out);
        }
        else {
            emit_jcc(cond, Ltrue, e.loc, out);
        }
        return;
    }

    // ------------------------------------------------------------
    // Should never reach here
    // ------------------------------------------------------------
    assert(0);
}

// Loop context for break/continue
struct LoopContext {
    HLA_Label break_label;
    HLA_Label continue_label;
};

static thread_local std::vector<LoopContext> g_loop_stack;

// Lower a single node
static void hla_lower_node(const HLA_Node& n, std::vector<LogicalLine>& out);

// ------------------------------------------------------------
// IF lowering
// ------------------------------------------------------------
static void hla_lower_if(const HLA_If& node, std::vector<LogicalLine>& out) {
    const bool has_else = !node.else_body.empty();
    bool chain_terminated = false; // set when a branch is known-always-true

    // Lower IF / ELSEIF branches
    for (size_t i = 0; i < node.branches.size(); ++i) {
        const auto& br = node.branches[i];

        if (br.is_always_false) {
            // Skip body entirely
            continue;
        }

        if (!br.is_always_true && br.condition) {
            // If condition false -> jump to next branch (or ELSE / end)
            hla_emit_cond(*br.condition,
                          /*Ltrue=*/NoLabel,
                          /*Lfalse=*/br.next_label,
                          /*prefer_true_fallthrough=*/true,
                          out);
        }

        // Body of this branch
        hla_lower_body(br.body, out);

        const bool is_last_branch = (i + 1 == node.branches.size());

        // Skip unconditional jump when branch is compile-time true:
        // we terminate chain and fall through directly to end_label.
        if (!br.is_always_true && !(is_last_branch && !has_else)) {
            emit_jmp(node.end_label, node.loc, out);
        }

        // If condition is always true, no later branch/ELSE can be reached.
        if (br.is_always_true) {
            chain_terminated = true;
            break;
        }

        place_label(br.next_label, br.loc, out);
    }

    // ELSE body (if present and not proven unreachable)
    if (has_else && !chain_terminated) {
        hla_lower_body(node.else_body, out);
    }

    place_label(node.end_label, node.loc, out);
}

// ------------------------------------------------------------
// WHILE lowering
// ------------------------------------------------------------
static void hla_lower_while(const HLA_While& node, std::vector<LogicalLine>& out) {
    if (node.never_runs) {
        // Completely dead loop
        return;
    }

    place_label(node.top_label, node.loc, out);

    // Condition (if not forever)
    if (!node.is_forever && node.condition) {
        hla_emit_cond(*node.condition,
                      /*Ltrue=*/NoLabel,
                      /*Lfalse=*/node.break_label,
                      /*prefer_true_fallthrough=*/true,
                      out);
    }

    // Body
    g_loop_stack.push_back({ node.break_label, node.top_label });
    hla_lower_body(node.body, out);
    g_loop_stack.pop_back();

    // Back edge
    emit_jmp(node.top_label, node.loc, out);

    place_label(node.break_label, node.loc, out);
}

// ------------------------------------------------------------
// REPEAT lowering
// ------------------------------------------------------------
static void hla_lower_repeat(const HLA_Repeat& node, std::vector<LogicalLine>& out) {
    place_label(node.top_label, node.loc, out);

    // Continue inside REPEAT must jump to the bottom test/decrement point.
    HLA_Label continue_label;

    g_loop_stack.push_back({ node.break_label, continue_label });
    hla_lower_body(node.body, out);
    g_loop_stack.pop_back();

    place_label(continue_label, node.loc, out);

    switch (node.type) {
    case RepeatType::UntilExpr:
        if (node.runs_only_once) {
            // REPEAT ... UNTIL TRUE -> run once, then break
            break;
        }
        if (node.is_forever) {
            // REPEAT ... UNTIL FALSE -> infinite loop
            emit_jmp(node.top_label, node.loc, out);
            break;
        }
        if (node.condition) {
            // REPEAT ... UNTIL expr
            // If expr false -> jump back to top
            hla_emit_cond(*node.condition,
                          /*Ltrue=*/node.break_label,
                          /*Lfalse=*/node.top_label,
                          /*prefer_true_fallthrough=*/true,
                          out);
        }
        break;

    case RepeatType::DjnzReg:
        // REPEAT ... DJNZ reg
        emit_djnz(node.reg_kw, node.top_label, node.loc, out);
        break;
    }

    place_label(node.break_label, node.loc, out);
}

// ------------------------------------------------------------
// BREAK / CONTINUE lowering
// ------------------------------------------------------------
static void hla_lower_break(const HLA_Break& n, std::vector<LogicalLine>& out) {
    assert(!g_loop_stack.empty());
    emit_jmp(g_loop_stack.back().break_label, n.loc, out);
}

static void hla_lower_continue(const HLA_Continue& n, std::vector<LogicalLine>& out) {
    assert(!g_loop_stack.empty());
    emit_jmp(g_loop_stack.back().continue_label, n.loc, out);
}

// ------------------------------------------------------------
// Generic node dispatcher
// ------------------------------------------------------------
static void hla_lower_node(const HLA_Node& n, std::vector<LogicalLine>& out) {
    if (auto* a = dynamic_cast<const HLA_Asm*>(&n)) {
        out.push_back(a->line);
        return;
    }

    if (auto* i = dynamic_cast<const HLA_If*>(&n)) {
        hla_lower_if(*i, out);
        return;
    }

    if (auto* w = dynamic_cast<const HLA_While*>(&n)) {
        hla_lower_while(*w, out);
        return;
    }

    if (auto* r = dynamic_cast<const HLA_Repeat*>(&n)) {
        hla_lower_repeat(*r, out);
        return;
    }

    if (auto* b = dynamic_cast<const HLA_Break*>(&n)) {
        hla_lower_break(*b, out);
        return;
    }

    if (auto* c = dynamic_cast<const HLA_Continue*>(&n)) {
        hla_lower_continue(*c, out);
        return;
    }

    assert(0);
}

// ------------------------------------------------------------
// Body lowering
// ------------------------------------------------------------
void hla_lower_body(const std::vector<std::unique_ptr<HLA_Node>>& body,
                    std::vector<LogicalLine>& out) {
    for (const auto& n : body) {
        hla_lower_node(*n, out);
    }
}

std::vector<LogicalLine> hla_lower(const HLA_Program& program) {
    std::vector<LogicalLine> out;
    hla_lower_body(program.nodes, out);
    return out;
}
