## TODO

- number lines
- generate output file
- add constructors to xxxStmt
- add printer commands LPRINT, LLIST, COPY
- detect duplicated PROC arguments and locals
- detect PROC recursion
- detect FN recursion
- add tests to verify all lowering constructs
- check number of arguments vs parameters in PROC
- check number of arguments vs parameters in FN
- split JumpTargetStmt in LabelTargetStmt and LineNumTargetStmt
- lower VARS section
- solve LET A=FNid(10)+FNid(20)

## Parser

void visit(DefProcStmt& proc) override {
    symtab.add_proc(proc);

    auto it = std::find_if(
        prog.stmts.begin(),
        prog.stmts.end(),
        [&](auto& ptr){ return ptr.get() == &proc; }
    );

    if (it != prog.stmts.end())
        prog.stmts.erase(it);

    StmtWalker::visit(proc); // walk its body
}

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

## Pipeline

1. Parse
AST contains extended BASIC.

2. Semantic analysis
Type checks, symbol table, label resolution, etc.

3. Lowering (AST -> simpler AST)
Rewrite extended constructs into plain ZX81 BASIC AST.

4. Line numbering
Assign ZX81 line numbers after lowering.

5. Codegen
Convert AST nodes to ZX81 tokenized BASIC lines.

6. ZX81 string encoding
Convert ASCII strings to ZX81 character set.

7. File output
Write .P / .P81 / .TAP.

This separation keeps your compiler clean and debuggable.


Let's look at your pipeline again:

Preprocess

Tokenize

Parse

Semantic rewrite (visitor)

remove LOCAL

extract PROC/FN

rewrite identifiers

move pragma vars

canonicalize bodies

Symbol collection

now trivial

Lowering

now trivial

This is exactly the structure used in real compilers.

You've solved the hardest part
The moment you unify:

a recursive walker

enter/leave hooks

mark-and-erase mutation

canonical top-level structure

your compiler becomes much easier to extend.

You can now add:

constant folding

dead-code elimination

call-graph construction

recursion detection

inlining

lowering passes






The correct pipeline (clean, robust, used in real compilers)
Phase 1 - Structural Scan (Declarations Only)
You walk the program without entering procedure bodies.

You collect:

Procedure names

Parameter names

Global variable declarations

Constant definitions

Label names

You do not collect local variables yet.
You do not rewrite anything yet.

This produces the Declaration Table.

What this table is used for:
Checking that calls refer to existing procedures

Checking that argument counts match parameter counts

Checking that labels exist

Checking that constants are not redefined

Ensuring no name collisions between global categories

This table is stable and does not depend on rewriting.

Phase 2 - Semantic Pass (Inside Procedure Bodies)
Now you enter each procedure body.

You use the Declaration Table to validate:

Calls

Parameter usage

Category correctness (array vs scalar vs label vs proc)

During this pass you also:

Rewrite local variables ? procname_varname

Rewrite parameters ? procname_paramname

Rewrite implicit locals (if BASIC allows them)

You do not check undefined variables yet.
Because rewriting is still happening.

Phase 3 - Build the Definition Table (Post-Rewrite)
Now that all variables have their final names, you do a second scan:

You collect:

All rewritten variable names

All rewritten array names

All rewritten labels

All rewritten procedure names

All rewritten constants

This produces the Definition Table.

What this table is used for:
Detecting undefined variables

Detecting undefined arrays

Detecting undefined labels

Detecting illegal redefinitions after rewriting

Ensuring the final lowered program is internally consistent

This table is built after rewriting because only then do you know the final names.


Final recommended pipeline (simple and bulletproof)
1. Parse ? AST
No symbol table yet.

2. Declaration Pass (no rewriting)
Build Declaration Table:

Procedures

Parameters

Globals

Constants

Labels

3. Semantic Pass (with rewriting)
Use Declaration Table to:

Validate calls

Validate categories

Rewrite locals and parameters

Rewrite implicit locals

Rewrite arrays

4. Definition Pass (post-rewrite)
Build Definition Table:

All rewritten names

All rewritten labels

All rewritten arrays

5. Undefined-variable check
Use Definition Table to:

Detect undefined variables

Detect undefined arrays

Detect undefined labels

6. Lower to ZX81 BASIC






You detect non-trivial indirect recursion in a BASIC compiler by treating it as a graph-cycle detection problem in your semantic analysis phase. Nothing else-no symbol table, no lowering, no runtime layout-is required.

The trick is to build a call graph from your rewritten PROC/FN bodies and then run a cycle-detection algorithm (DFS or SCC). That's all recursion is: a cycle in the call graph.

? Concise takeaway
Build a call graph during semantic analysis and detect cycles (direct or indirect).  
You do not need the symbol table to do this.

?? Why recursion detection belongs in semantic analysis
Your pipeline has:

Preprocess

Tokenize

Parse

Semantic check ? this is where recursion detection must happen

Create symbol table

Lowering

You already rewrite PROC/FN bodies in semantic analysis. That means you already have:

canonical names

canonical bodies

ASTs with call expressions

This is everything needed to detect recursion.

Symbol table creation happens after rewriting, but recursion detection does not require symbol resolution-only name matching.

?? What recursion detection actually needs
To detect recursion, you need only:

A list of all PROC/FN names

Their canonical AST bodies

A way to extract calls from each body

A graph representation: caller ? callee

You do not need:

variable scopes

storage offsets

type information

lowered identifiers

symbol table entries

Indirect recursion is just a cycle:

Code
A ? B ? C ? A
Direct recursion is a trivial cycle:

Code
A ? A
?? How to implement it cleanly
1. During semantic_check, build a call graph
For each PROC/FN:

Walk its rewritten AST

For every call expression, record an edge

Store edges in an adjacency list

Example structure:

cpp
std::unordered_map<std::string, std::vector<std::string>> call_graph;
2. Run DFS cycle detection
Classic algorithm:

Maintain visited and in_stack sets

DFS from each node

If you ever see a node already in in_stack, you found a cycle ? recursion

3. Or use Tarjan SCC
Tarjan's strongly connected components algorithm finds all cycles in one pass.
Any SCC with size = 2 is indirect recursion.
Any SCC of size 1 with a self-edge is direct recursion.

4. Report recursion errors (or mark recursive procs)
Depending on your BASIC dialect:

If recursion is illegal ? error

If recursion is allowed ? annotate the PROC/FN as recursive

5. Lowering becomes trivial
Lowering should never detect recursion.
If lowering detects recursion, your architecture is wrong.

Lowering should only:

emit code

not perform semantic checks

not inspect call relationships

?? Why symbol table is irrelevant
You mentioned:

In semantic_check I don't have a symbol table yet and cannot detect indirect recursion.

But recursion detection does not require symbol resolution.
You already know the names of PROC/FN definitions and the names of calls.
That's enough.

If a call refers to an undefined PROC/FN, that's a separate semantic error.

?? Example: detecting indirect recursion
Given:

Code
PROC A
  CALL B
ENDPROC

PROC B
  CALL C
ENDPROC

PROC C
  CALL A
ENDPROC
Call graph:

Code
A ? B
B ? C
C ? A
DFS or SCC will detect the cycle {A, B, C}.

?? Non-obvious insight
You should build the call graph after rewriting identifiers, because rewriting may change the canonical names of PROC/FN parameters or locals, and you want the call graph to reflect the final canonical form.

This is why recursion detection belongs in semantic analysis after rewriting but before symbol table creation.

?? Final recommendation
Detect recursion in semantic_check by building a call graph and running cycle detection.  
Do not attempt recursion detection in lowering.
Do not rely on the symbol table.

If you want, I can sketch the exact C++ code for:

building the call graph from your AST

DFS cycle detection

Tarjan SCC detection

integrating it into your existing pipeline

Just tell me which style you prefer.
