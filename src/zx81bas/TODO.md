## TODO

- remove unused labels
- generate output file
- lower VARS section
- Assign ZX81 line numbers
- Convert ASCII strings to ZX81 character set.
- Write .P
- Constant folding
- Dead code elimination
- PROC inlining
- Control Flow Graph, eliminate empty branches simplify IFs with only one THEN
  statement
- In FOR make step expression optional

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


The clean architecture
semantic_transform()
- Expand PEEKW/POKEW
- Expand DIV/MOD
- Expand FN
- Fold constant expressions

Produce canonical AST

lower_prog()
- Lower IF/WHILE/FOR/PROC/EXIT
- Produce flat ZX81 BASIC IR
No constant folding here

optimize()
- Fold constant conditions
- Simplify IF diamonds
- Remove redundant GOTOs
- Merge labels
- Dead code elimination
- Peephole optimizations
