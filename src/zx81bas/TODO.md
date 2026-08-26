## TODO

- add ZX Spectrum additional BASIC keywords as extended keywords
- populate LOCAL in PROC from LOCAL statements
- variable collection and symbol table creation
- check of data types number/string
- lower to standard BASIC
- number lines
- generate output file
- parse of graphical images for 2x2 graphics

## Parser

void lower_if_else(const IfElseStmt& s, std::vector<std::unique_ptr<Stmt>>& out) {

    std::string false_label = generate_label("false");
    std::string end_label   = generate_label("end");

    // IF NOT condition THEN GOTO @false
    auto neg_cond = make_not_expr(s.condition.get());
    out.push_back(make_goto_if_stmt(neg_cond, false_label));

    // true branch
    for (auto& t : s.true_branch)
        out.push_back(lower_stmt(t));

    // GOTO @end
    out.push_back(make_goto_stmt(end_label));

    // @false:
    out.push_back(make_label_stmt(false_label));

    // false branch
    for (auto& f : s.false_branch)
        out.push_back(lower_stmt(f));

    // @end:
    out.push_back(make_label_stmt(end_label));
}


std::vector<std::unique_ptr<Stmt>> lower_repeat(const RepeatStmt& r) {
    std::vector<std::unique_ptr<Stmt>> out;

    std::string start_label = generate_label("repeat_start");
    std::string end_label   = generate_label("repeat_end");

    // @start:
    out.push_back(std::make_unique<LabelStmt>(LabelStmt{start_label}));

    // Lower each statement in the body
    for (auto& s : r.body) {
        if (auto exit = dynamic_cast<ExitStmt*>(s.get())) {
            // EXIT -> GOTO @end
            auto g = std::make_unique<GotoStmt>();
            g->is_label = true;
            g->target_label = end_label;
            out.push_back(std::move(g));
        } else {
            // Normal statement -> lower recursively
            out.push_back(lower_stmt(*s));
        }
    }

    // IF NOT condition2 THEN GOTO @start
    {
        auto neg = std::make_unique<UnaryExpr>();
        neg->op = TokenType::Not;
        neg->operand = clone_expr(r.until_condition.get());

        auto goto_start = std::make_unique<GotoStmt>();
        goto_start->is_label = true;
        goto_start->target_label = start_label;

        auto ifstmt = std::make_unique<IfStmt>();
        ifstmt->condition = std::move(neg);
        ifstmt->then_stmt = std::move(goto_start);

        out.push_back(std::move(ifstmt));
    }

    // @end:
    out.push_back(std::make_unique<LabelStmt>(LabelStmt{end_label}));

    return out;
}


std::vector<std::unique_ptr<Stmt>> lower_while(const WhileStmt& w) {
    std::vector<std::unique_ptr<Stmt>> out;

    std::string start_label = generate_label("while_start");
    std::string end_label   = generate_label("while_end");

    // @start:
    out.push_back(std::make_unique<LabelStmt>(LabelStmt{start_label}));

    // IF NOT condition1 THEN GOTO @end
    {
        auto neg = std::make_unique<UnaryExpr>();
        neg->op = TokenType::Not;
        neg->operand = clone_expr(w.condition.get());

        auto goto_end = std::make_unique<GotoStmt>();
        goto_end->is_label = true;
        goto_end->target_label = end_label;

        auto ifstmt = std::make_unique<IfStmt>();
        ifstmt->condition = std::move(neg);
        ifstmt->then_stmt = std::move(goto_end);

        out.push_back(std::move(ifstmt));
    }

    // Body statements
    for (auto& s : w.body) {
        if (auto exit = dynamic_cast<ExitStmt*>(s.get())) {
            // EXIT -> GOTO @end
            auto g = std::make_unique<GotoStmt>();
            g->is_label = true;
            g->target_label = end_label;
            out.push_back(std::move(g));
        } else {
            // Normal statement -> lower recursively
            out.push_back(lower_stmt(*s));
        }
    }

    // GOTO @start
    {
        auto g = std::make_unique<GotoStmt>();
        g->is_label = true;
        g->target_label = start_label;
        out.push_back(std::move(g));
    }

    // @end:
    out.push_back(std::make_unique<LabelStmt>(LabelStmt{end_label}));

    return out;
}


std::vector<std::unique_ptr<Stmt>> lower_proc_call(const ProcCallStmt& call) {
    std::vector<std::unique_ptr<Stmt>> out;

    // Assign parameters
    for (size_t i = 0; i < call.args.size(); ++i) {
        auto let = std::make_unique<LetStmt>();
        let->lhs = make_var_expr(call.name + "_" + call.params[i]); // PROCname_A
        let->rhs = clone_expr(call.args[i].get());
        out.push_back(std::move(let));
    }

    // GOSUB @PROCname
    auto g = std::make_unique<GosubStmt>();
    g->is_label = true;
    g->target_label = call.name;
    out.push_back(std::move(g));

    return out;
}

std::vector<std::unique_ptr<Stmt>> lower_proc_def(const ProcDefStmt& def) {
    std::vector<std::unique_ptr<Stmt>> out;

    // @PROCname:
    out.push_back(std::make_unique<LabelStmt>(LabelStmt{def.name}));

    // Lower body
    for (auto& s : def.body) {

        // EXIT inside a PROC -> RETURN
        if (auto exit = dynamic_cast<ExitStmt*>(s.get())) {
            out.push_back(std::make_unique<ReturnStmt>());
            continue;
        }

        // Local variable mangling, LET rewriting, etc.
        out.push_back(lower_stmt_in_proc(def.name, *s));
    }

    // Final RETURN
    out.push_back(std::make_unique<ReturnStmt>());

    return out;
}


std::unique_ptr<Expr> rewrite_proc_expr(const std::string& procname, const Expr* e) {
    if (auto v = dynamic_cast<const VariableExpr*>(e)) {
        return make_var_expr(procname + "_" + v->name);
    }
    else if (auto b = dynamic_cast<const BinaryExpr*>(e)) {
        auto out = std::make_unique<BinaryExpr>();
        out->op = b->op;
        out->left = rewrite_proc_expr(procname, b->left.get());
        out->right = rewrite_proc_expr(procname, b->right.get());
        return out;
    }
    else if (auto u = dynamic_cast<const UnaryExpr*>(e)) {
        auto out = std::make_unique<UnaryExpr>();
        out->op = u->op;
        out->operand = rewrite_proc_expr(procname, u->operand.get());
        return out;
    }
    else {
        return clone_expr(e);
    }
}

std::vector<std::unique_ptr<Stmt>> lower_fn_def(const FnDefStmt& def) {
    std::vector<std::unique_ptr<Stmt>> out;

    // LET FNname = <rewritten body>
    auto let = std::make_unique<LetStmt>();
    let->lhs = make_var_expr(def.name);  // FNname
    let->rhs = rewrite_fn_expr(def.name, def.body.get());

    out.push_back(std::move(let));
    return out;
}

std::vector<std::unique_ptr<Stmt>> lower_fn_call(const FnCallExpr& call) {
    std::vector<std::unique_ptr<Stmt>> out;

    // Assign parameters
    for (size_t i = 0; i < call.args.size(); ++i) {
        auto let = std::make_unique<LetStmt>();
        let->lhs = make_var_expr(call.name + "_" + call.params[i]); // FNname_A
        let->rhs = clone_expr(call.args[i].get());
        out.push_back(std::move(let));
    }

    // Compute function result
    auto let = std::make_unique<LetStmt>();
    let->lhs = make_var_expr(call.name);  // FNname
    let->rhs = rewrite_fn_expr(call.name, lookup_fn_body(call.name));
    out.push_back(std::move(let));

    return out;
}

std::unique_ptr<Expr> rewrite_fn_expr(const std::string& fnname, const Expr* e) {
    if (auto v = dynamic_cast<const VariableExpr*>(e)) {
        return make_var_expr(fnname + "_" + v->name);
    }
    else if (auto b = dynamic_cast<const BinaryExpr*>(e)) {
        auto out = std::make_unique<BinaryExpr>();
        out->op = b->op;
        out->left = rewrite_fn_expr(fnname, b->left.get());
        out->right = rewrite_fn_expr(fnname, b->right.get());
        return out;
    }
    else if (auto u = dynamic_cast<const UnaryExpr*>(e)) {
        auto out = std::make_unique<UnaryExpr>();
        out->op = u->op;
        out->operand = rewrite_fn_expr(fnname, u->operand.get());
        return out;
    }
    else {
        return clone_expr(e);
    }
}


## Expression emitter

void emit_child(const Expr& child, int parent_prec, std::ostream& out) {
    int child_prec = precedence(child);

    bool need_parens = child_prec > parent_prec;

    if (need_parens) out << "(";
    emit_expr(child, out);
    if (need_parens) out << ")";
}

void emit_expr(const Expr& e, std::ostream& out) {

    // Number
    if (auto n = dynamic_cast<const NumberExpr*>(&e)) {
        out << n->value;
        return;
    }

    // String literal
    if (auto s = dynamic_cast<const StringLiteralExpr*>(&e)) {
        out << "\"" << s->value << "\"";
        return;
    }

    // Variable
    if (auto v = dynamic_cast<const VariableExpr*>(&e)) {
        out << v->name;
        return;
    }

    // Array reference
    if (auto a = dynamic_cast<const ArrayRefExpr*>(&e)) {
        out << a->name << "(";
        for (size_t i = 0; i < a->indices.size(); ++i) {
            if (i > 0) out << ",";
            emit_expr(*a->indices[i], out);
        }
        out << ")";
        return;
    }

    // Slice
    if (auto s = dynamic_cast<const SliceExpr*>(&e)) {
        out << s->base->name << "(";

        if (s->from) emit_expr(*s->from, out);
        out << " TO ";
        if (s->to) emit_expr(*s->to, out);

        out << ")";
        return;
    }

    // Function call
    if (auto f = dynamic_cast<const FunctionCallExpr*>(&e)) {
        out << f->name;
        if (!f->args.empty()) {
            out << "(";
            for (size_t i = 0; i < f->args.size(); ++i) {
                if (i > 0) out << ",";
                emit_expr(*f->args[i], out);
            }
            out << ")";
        }
        return;
    }

    // Unary
    if (auto u = dynamic_cast<const UnaryExpr*>(&e)) {
        out << "-";
        emit_child(*u->operand, precedence(e), out);
        return;
    }

    // Binary
    if (auto b = dynamic_cast<const BinaryExpr*>(&e)) {
        emit_child(*b->left, precedence(e), out);

        out << " " << token_text(b->op) << " ";

        emit_child(*b->right, precedence(e), out);
        return;
    }
}

## Correct architecture

1. Parsing
Build AST only.
No type decisions.

2. Symbol table construction
From:

DIM A(...) -> numeric array

DIM A$(...) -> string array

LET A$ = ... -> string variable

LET A = ... -> numeric variable

DEF FN -> numeric function

DEF PROC -> procedure

3. Type inference
For each expression:

numbers -> numeric

string literals -> string

CODE expr -> numeric

CHR$ expr -> string

LEN expr -> numeric

PEEK expr -> numeric

STR$ expr -> string

slices -> string

array refs -> type of array

variables -> type from symbol table

4. Type checking
Check:

LHS type matches RHS type

slice LHS must be string

array element type matches RHS

numeric operators only on numeric expressions

string operators only on string expressions

function argument types match function requirements

5. Lowering / code generation

## Mapping of labels

1. T2P behavior

@start1:
	GOTO @start1							' @start1 is the BASIC line number
	PRINT 256*PEEK &start1+PEEK(&start1+1)	' gets line number (compatible with t2p)

In lowered code:
start1_line EQU 1000
start1:
	DEFW_BE	1000		; line number
	...

2. Interface to ASM

	REM
#ASM
start2:
	ret
#BASIC
	RAND USR &start2			' ASM labels can be refered in BASIC like &name

Conclusion: ASM lines don't need BASIC line numbers or @labels.
