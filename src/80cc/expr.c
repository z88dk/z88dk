/*
 * cc4.c - fourth part of Small-C/Plus compiler
 *         routines for recursive descent
 *
 * $Id: expr.c,v 1.13 2016-03-29 13:39:44 dom Exp $
 *
 */


#include "ccdefs.h"
#include "tokeniser.h"

static int        heir1a(LVALUE *lval);
static int        heir2a(LVALUE *lval);
static int        heir2b(LVALUE *lval);
static int        heir234(LVALUE *lval, int (*heir)(LVALUE *lval), TokenKind tk_op, void (*oper)(LVALUE *lval), int ast_type);
static int        heir2(LVALUE *lval);
static int        heir3(LVALUE *lval);
static int        heir4(LVALUE *lval);
static int        heir5(LVALUE *lval);
static int        heir6(LVALUE *lval);
static int        heir7(LVALUE *lval);
static int        heir8(LVALUE *lval);
static int        heir9(LVALUE *lval);
static int        heirb(LVALUE *lval);
static SYMBOL    *deref(LVALUE *lval, char isaddr);


struct nodepair *expression(int  *con, zdouble *val, Type **type)
{
    LVALUE lval={0};
    struct nodepair *pair = calloc(1,sizeof(*pair));

    if (heir1(&lval)) {
        rvalue(&lval);
    }
    *con = lval.is_const;
    *val = lval.const_val;
    *type = lval.ltype;

    pair->k = lval.ltype ? lval.ltype->kind : KIND_NONE;
    pair->node = lval.node;
    return pair;
}

int heir1(LVALUE* lval)
{
    LVALUE lval2={0}, lval3={0};
    void (*oper)(LVALUE *) = NULL;
    void  (*doper)(LVALUE *lval) = NULL;
    int asttype;
    int k;

    k = plnge1(heir1a, lval);
    doper = NULL;
    if (cmatch('=')) {
        if (k == 0) {
            if ( lval->ltype->kind != KIND_STRUCT ) {
                needlval();
                return 0;
            }
        }
        if (heir1(&lval2))
            rvalue(&lval2);

        /* If it's a const, then load it with the right type */
        if ( lval2.is_const ) {
            lval2.val_type = lval->val_type;
        }

        if ( ispointer(lval->ltype)) {
            Type *rhs = lval2.ltype;

            if ( lval->ltype->ptr->kind == KIND_FUNC && rhs->kind == KIND_FUNC ) {
                rhs = make_pointer(rhs);
            }

            if (  rhs->kind == KIND_ARRAY ) {
                rhs = make_pointer(rhs->ptr);
            }

            if ( type_matches(lval->ltype, rhs) == 0 && lval->ltype->ptr->kind != KIND_VOID && 
                    ! (ispointer(rhs) && rhs->ptr->kind == KIND_VOID) )  {
                if ( ispointer(lval->ltype) && lval2.is_const && lval2.const_val == 0 ) {
                    // All good
                } else if ( type_matches_pointer(lval->ltype, lval2.ltype) == 0 ) {
                    UT_string *str;

                    utstring_new(str);
                    utstring_printf(str,"Assigning '%s', type: ", lval->ltype->name);
                    type_describe(lval->ltype,str);
                    utstring_printf(str," from ");
                    type_describe(rhs, str);
                    warningfmt("incompatible-pointer-types","%s", utstring_body(str));
                    utstring_free(str);
                }
            } else if ( lval->ltype->ptr->kind == KIND_FUNC && rhs->ptr->kind == KIND_FUNC ) {
                // Check flag assignment
                if ( (rhs->ptr->flags & FASTCALL) != (lval->ltype->ptr->flags & FASTCALL) ) {
                    if ( array_len(rhs->ptr->parameters) ) {
                        warningfmt("incompatible-function-types","Assigning %sFASTCALL function pointer with %sFASTCALL function", (lval->ltype->ptr->flags & FASTCALL) ? "" : "non-", (rhs->ptr->flags & FASTCALL) ? "" : "non-");
                    }
                }
                if ( (lval->ltype->ptr->flags & CALLEE) != (rhs->ptr->flags & CALLEE) ) {
                    warningfmt("incompatible-function-types","Assigning %sCALLEE function pointer with %sCALLEE function", (lval->ltype->ptr->flags & CALLEE) ? "" :  "non-",  (rhs->ptr->flags & CALLEE) ? "" : "non-");
                }
                if ( (lval->ltype->ptr->flags & SMALLC) != (rhs->ptr->flags & SMALLC) ) {
                    warningfmt("incompatible-function-types","Assigning %s function pointer with %s function", (lval->ltype->ptr->flags & SMALLC) ? "__smallc" : "__stdc", (rhs->ptr->flags & SMALLC) ? "__smallc" : "__stdc");
                }
            }
        } else if ( lval->ltype->kind == KIND_STRUCT ) {
            if ( lval2.ltype->kind != KIND_STRUCT ) {
                errorfmt("Cannot assign to aggregate",0);
            }
        }
        if ( lval2.ltype->kind == KIND_VOID ) {
            warningfmt("void","Assigning from a void expression");
        }
        check_pointer_namespace(lval->ltype, lval2.ltype);

        if ( lval2.is_const) {
            check_assign_range(lval->ltype, lval2.const_val);
        }
        store(lval);
        lval->node = ast_binop(OP_ASSIGN, lval->node, lval2.node);
        /* Carry the *target storage type* on the assignment so AST-mode
           codegen knows the write width — for struct member writes the
           LHS expression simplifies to `(+ (lv=p) offset)` which has no
           recoverable storage type. lval->ltype is the lvalue type at
           the point of assignment (the member type for member access). */
        lval->node->type = lval->ltype;
        return 0;
    } else if (match("|=")) {
        oper = zor;
        asttype = OP_AOR;
    } else if (match("^=")) {
        oper = zxor;
        asttype = OP_AXOR;
    } else if (match("&=")) {
        oper = zand;
        asttype = OP_AAND;
    } else if (match("+=")) {
        oper = doper = zadd;
        asttype = OP_AADD;
    } else if (match("-=")) {
        oper = doper = zsub;
        asttype = OP_ASUB;
    } else if (match("*=")) {
        oper = doper = mult;
        asttype = OP_AMULT;
    } else if (match("/=")) {
        oper = doper = zdiv;
        asttype = OP_ADIV;
    } else if (match("%=")) {
        oper = zmod;
        asttype = OP_AMOD;
    } else if (match(">>=")) {
        oper = asr;
        asttype = OP_ASSHR;
    } else if (match("<<=")) {
        oper = asl;
        asttype = OP_ASSHL;
    } else
        return k;

    /* if we get here we have an oper= */
    if (k == 0) {
        needlval();
        return 0;
    }
    lval3.symbol = lval->symbol;
    lval3.ltype = lval->ltype;
    lval3.indirect_kind = lval->indirect_kind;
    lval3.flags = lval->flags;
    lval3.val_type = lval->val_type;
    lval3.offset = lval->offset;
    lval3.const_val = lval->const_val;
    lval3.is_const = lval->is_const;
    rvalue(lval);
    Node *compound_lhs_node = lval->node;
    if (oper == zadd || oper == zsub) {
        plnge2b(heir1, lval, &lval2, oper);
        /* plnge2b builds a plain OP_ADD/OP_SUB whose LHS is `compound_lhs_node`
           (the deref'd lvalue) and RHS is lval2.node. For compound assigns we
           need the same (LHS,RHS) shape but tagged OP_AADD/OP_ASUB so the
           walker emits the store-back. Discard plnge2b's binop node and
           rebuild with the correct tag. */
        lval->node = ast_binop(asttype, compound_lhs_node, lval2.node);
    } else
        plnge2a(heir1, lval, &lval2, oper, doper, asttype);

    store(&lval3);
    return 0;
}

/*
 * heir1a - conditional operator
 */
int heir1a(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

    k = heir2a(lval);
    /* heir2a parses and populates lval->node with the cond AST. Capture it
       AFTER, before we recurse into the ?:-branches which would overwrite. */
    Node *cond = lval->node;
    if (cmatch('?')) {
        if (k) rvalue(lval);

        /* TRUE branch into lval2, FALSE branch overwrites lval — same
           lval roles as the legacy code so subsequent decisions (and
           the resulting lval->ltype/val_type) reflect the FALSE arm. */
        if (heir1(&lval2)) rvalue(&lval2);
        needchar(':');
        if (heir1(lval)) rvalue(lval);

        /* Result type promotion mirrors the legacy widening so the
           AST has the right `val_type` / `ltype` on lval. The emit
           is gone — the walker handles the actual conversion via
           cg2_walk_to_decimal / cg2_walk_to_long. */
        if (lval2.val_type != lval->val_type) {
            if (kind_is_decimal(lval2.val_type)) {
                /* promotion handled in walker; nothing to mutate */
            } else if (kind_is_decimal(lval->val_type)) {
                /* promotion handled in walker; nothing to mutate */
            } else if (lval2.val_type == KIND_LONG && lval->val_type != KIND_LONG) {
                widenintegers(&lval2, lval);
                lval->val_type = KIND_LONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            } else if (lval->val_type == KIND_LONG && lval2.val_type != KIND_LONG) {
                widenintegers(lval, &lval2);
                lval->val_type = KIND_LONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            }
        }

        /* AST shape: (?: cond TRUE FALSE). lval2 holds the TRUE
           branch (parsed first), lval holds FALSE (parsed second). */
        lval->node = ast_conditional(cond, lval2.node, lval->node);
        lval->is_const = 0;
        return 0;
    } else
        return k;
}

int heir2a(LVALUE* lval)
{
    return skim(TK_LOR, heir2b, lval);
}

int heir2b(LVALUE* lval)
{
    return skim(TK_LAND, heir2, lval);
}

int heir234(LVALUE* lval, int (*heir)(LVALUE *lval), TokenKind tk_op, void (*oper)(LVALUE *lval), int ast_type)
{
    LVALUE lval2={0};
    int k;

    k = plnge1(heir, lval);
    /* Phase L3c-8d: tokeniser-driven entry — tk_op is one of
       TK_PIPE / TK_CARET / TK_AMP. The legacy `nch() == '='` and
       `nch() == opch` filters fold into the kind check since
       `|=` / `||` / `^=` / `&=` / `&&` are all distinct kinds. */
    if (tk_peek_kind_at_lptr() != tk_op) return k;
    if (k)
        rvalue(lval);
    while (1) {
        if (tk_match_kind_at_lptr(tk_op)) {
            plnge2a(heir, lval, &lval2, oper, NULL, ast_type);
        } else
            return 0;
    }
}

int heir2(LVALUE* lval)
{
    return heir234(lval, heir3, TK_PIPE, zor, OP_OR);
}

int heir3(LVALUE* lval)
{
    return heir234(lval, heir4, TK_CARET, zxor, OP_XOR);
}

int heir4(LVALUE* lval)
{
    return heir234(lval, heir5, TK_AMP, zand, OP_AND);
}

int heir5(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

    k = plnge1(heir6, lval);
    /* Phase L3c-8f: tokeniser-driven entry. TK_EQ / TK_NE are the
       equality binops; no compound-form filter needed (the only
       overlap chars are `==` vs `=`, but TK_ASSIGN is a distinct
       kind). */
    {
        TokenKind kw = tk_peek_kind_at_lptr();
        if (kw != TK_EQ && kw != TK_NE) return k;
    }
    if (k)
        rvalue(lval);
    while (1) {
        if (tk_match_kind_at_lptr(TK_EQ)) {
            plnge2a(heir6, lval, &lval2, zeq, zeq, OP_EQ);
        } else if (tk_match_kind_at_lptr(TK_NE)) {
            plnge2a(heir6, lval, &lval2, zne, zne, OP_NE);
        } else
            return 0;
    }
}

int heir6(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

    k = plnge1(heir7, lval);
    /* Phase L3c-8c: tokeniser-driven entry — TK_LT / TK_GT / TK_LE
       / TK_GE are the comparison kinds; TK_SHL / TK_SHR / *_ASSIGN
       are distinct kinds and automatically excluded by kind check.
       Folds the legacy 4-streq-check filter into one. */
    {
        TokenKind kw = tk_peek_kind_at_lptr();
        if (kw != TK_LT && kw != TK_GT && kw != TK_LE && kw != TK_GE) return k;
    }
    if (k)
        rvalue(lval);
    while (1) {
        if (tk_match_kind_at_lptr(TK_LE)) {
            plnge2a(heir7, lval, &lval2, zle, zle, OP_LE);
        } else if (tk_match_kind_at_lptr(TK_GE)) {
            plnge2a(heir7, lval, &lval2, zge, zge, OP_GE);
        } else if (tk_match_kind_at_lptr(TK_LT)) {
            plnge2a(heir7, lval, &lval2, zlt, zlt, OP_LT);
        } else if (tk_match_kind_at_lptr(TK_GT)) {
            plnge2a(heir7, lval, &lval2, zgt, zgt, OP_GT);
        } else
            return 0;
    }
}

int heir7(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

    k = plnge1(heir8, lval);
    /* Phase L3c-8c: TK_SHL / TK_SHR are the shift binops;
       TK_SHL_ASSIGN / TK_SHR_ASSIGN are distinct kinds and excluded
       by the equality check below. */
    {
        TokenKind kw = tk_peek_kind_at_lptr();
        if (kw != TK_SHL && kw != TK_SHR) return k;
    }
    if (k)
        rvalue(lval);
    while (1) {
        if (tk_match_kind_at_lptr(TK_SHR)) {
            plnge2a(heir8, lval, &lval2, asr, NULL, OP_SSHR);
        } else if (tk_match_kind_at_lptr(TK_SHL)) {
            plnge2a(heir8, lval, &lval2, asl, NULL, OP_SSHL);
        } else
            return 0;
    }
}

int heir8(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;


    k = plnge1(heir9, lval);
    /* Phase L3c-8a: tokeniser-driven entry check. TK_PLUS / TK_MINUS
       are the single-char forms; TK_INC / TK_DEC / TK_PLUS_ASSIGN /
       TK_MINUS_ASSIGN are distinct kinds and automatically excluded
       — folds in the legacy `nch() == '='` skip plus the `++`/`--`
       cases that aren't a binop entry. */
    {
        TokenKind kw = tk_peek_kind_at_lptr();
        if (kw != TK_PLUS && kw != TK_MINUS) return k;
    }
    if (k)
        rvalue(lval);
    while (1) {
        if (cmatch('+')) {
            plnge2b(heir9, lval, &lval2, zadd);
        } else if (cmatch('-')) {
            plnge2b(heir9, lval, &lval2, zsub);
        } else
            return 0;
    }
}

int heir9(LVALUE* lval)
{
    LVALUE lval2={0};
    int k;

    k = plnge1(heira, lval);
    /* Phase L3c-8a: tokeniser-driven entry check. TK_STAR / TK_SLASH
       / TK_PERCENT are the binop forms; TK_STAR_ASSIGN etc. are
       distinct kinds — automatically excluded by the kind check. */
    {
        TokenKind kw = tk_peek_kind_at_lptr();
        if (kw != TK_STAR && kw != TK_SLASH && kw != TK_PERCENT) return k;
    }
    if (k)
        rvalue(lval);
    while (1) {
        if (cmatch('*')) {
            plnge2a(heira, lval, &lval2, mult, mult, OP_MULT);
        } else if (cmatch('/')) {
            plnge2a(heira, lval, &lval2, zdiv, zdiv, OP_DIV);
        } else if (cmatch('%')) {
            plnge2a(heira, lval, &lval2, zmod, zmod, OP_MOD);
        } else
            return 0;
    }
}

/*
 * perform lval manipulation for pointer dereferencing/array subscripting
 */

SYMBOL *deref(LVALUE* lval, char isaddr)
{
    Type *old_type = lval->ltype;

    lval->symbol = NULL;
    if ( ispointer(lval->ltype) && lval->ltype->ptr->kind == KIND_FUNC ) {
        return lval->symbol;
    }

    lval->ltype = lval->ltype->ptr;
    if ( !ispointer(lval->ltype) ) 
        lval->ptr_type = KIND_NONE;
    else
        lval->ptr_type = lval->ltype->ptr->kind;
    lval->val_type = lval->indirect_kind = lval->ltype->kind;

    if ( old_type->kind == KIND_CPTR || (old_type->kind != KIND_PTR && (lval->flags & FARACC) )  ) {
        lval->flags |= FARACC;
    } else {
        lval->flags &= ~FARACC;
    }

    return lval->symbol;
}

int heira(LVALUE *lval)
{
    int k;
    LVALUE  cast_lval={0};
    int klptr;

    /* Cast check, little kludge here */
    if (rcmatch('(') ) {
        Type  *ctype;
        klptr = lptr;
        lptr++;
        if ( tk_peek_kind_at_lptr() != TK_EOF && (ctype = parse_expr_type()) != NULL ) {
            needchar(')');
            cast_lval.cast_type = ctype;
            k = heira(lval);
            if ( k == 1 ) {
                lval->cast_type = cast_lval.cast_type;
            } else {
                if (cast_lval.cast_type ) docast(&cast_lval, lval);
            }
            return k;
        } else {
            lptr = klptr;
        }
    }

    if (match("++")) {
        prestep(lval, 1, inc, OP_PRE_INC);
        return 0;
    } else if (match("--")) {
        prestep(lval, -1, dec, OP_PRE_DEC);
        return 0;
    } else if (cmatch('~')) {
        if (heira(lval))
            rvalue(lval);
        if ( kind_is_floating(lval->val_type) )
            errorfmt("Unary ~ operator is not valid for floating point",1);
        if ( kind_is_fixed(lval->val_type) )
            errorfmt("Unary ~ operator is not valid for fixed point",1);
        lval->node = ast_uop(OP_COMP, lval->node);
        lval->const_val = (int64_t)~(uint64_t)lval->const_val;
        return 0;
    } else if (cmatch('!')) {
        if (heira(lval))
            rvalue(lval);
        lval->const_val = !lval->const_val;
        lval->node = ast_uop(OP_LNEG, lval->node);
        return 0;
    } else if (cmatch('-')) {
        if (heira(lval))
            rvalue(lval);
        lval->const_val = -lval->const_val;
        /* OP_NEG, not OP_LNEG: this is unary minus (`-x`), not logical not. */
        lval->node = ast_uop(OP_NEG, lval->node);
        return 0;
    } else if (cmatch('*')) { /* unary * */
        if (heira(lval))
            rvalue(lval);
        if (lval->ltype->ptr == NULL ) {
            errorfmt("Can't dereference", 0);
            junk();
            return 0;
        } else {
            deref(lval, NO);
        }
        lval->is_const = 0; /* flag as not constant */
        lval->const_val = 1; /* omit rvalue() on func call */
        /* No OP_DEREF wrap here: the rvalue(lval) above already added one
           when it loaded the operand's pointer value, and the next rvalue()
           call (when *p is consumed as a value) will add another, giving
           OP_DEREF(OP_DEREF(p)) — exactly two emits, matching legacy. An
           extra wrap here would produce three OP_DEREFs and a duplicate
           gen_load_indirect emit in the walker. */
        return 1; /* dereferenced pointer is lvalue */
    } else if (cmatch('&')) {
        if (heira(lval) == 0) {
            lval->ltype = make_pointer(lval->ltype);
            lval->ptr_type = lval->ltype->ptr->kind;
            lval->val_type = lval->ltype->kind = lval->flags & FARACC ? KIND_CPTR : KIND_PTR;
            /* Wrap with OP_ADDR so the AST records that this expression
               yields an address rather than the value of the underlying
               lvalue. Legacy emit doesn't change here (heira's result is
               already an address), but the AST shape would otherwise be
               indistinguishable from an rvalue use. */
            if (lval->node) lval->node = ast_uop(OP_ADDR, lval->node);
            return 0;
        }
        lval->ltype = make_pointer(lval->ltype);
        lval->ptr_type = lval->ltype->ptr->kind;
        lval->val_type = lval->ltype->kind = lval->flags & FARACC ? KIND_CPTR : KIND_PTR;
        if (lval->symbol) {
            lval->symbol->isassigned = YES;
        }
        if (lval->indirect_kind) {
            /* Local-variable / deref'd pointer case: address-of doesn't
               emit anything (the address is already what an lvalue
               denotes), but the AST should still wrap with OP_ADDR so
               the shape is unambiguous. */
            if (lval->node) lval->node = ast_uop(OP_ADDR, lval->node);
            return 0;
        }
        /* global & non-array */
        lval->indirect_kind = lval->symbol->ctype->kind;
        lval->node = ast_uop(OP_ADDR, lval->node);
        return 0;
    }

    k = heirb(lval);

    if (match("++")) {
        poststep(k, lval, 1, inc, dec, OP_POST_INC);
        return 0;
    } else if (match("--")) {
        poststep(k, lval, -1, dec, inc, OP_POST_DEC);
        return 0;
    }
    return k;
}

int heirb(LVALUE* lval)
{
    char sname[NAMESIZE];
    zdouble dval;
    int val, con, direct, k;
    // Kind valtype;
    char flags;
    SYMBOL* ptr = NULL;


    k = primary(lval);
    ptr = lval->symbol;
    /* Phase L3c-8e: postfix dispatcher. TK_ARROW is its own kind
       (not TK_MINUS+TK_GT), so the legacy `ch() == '-' && nch() ==
       '>'` two-char check collapses into one kind comparison. */
    {
        TokenKind kw = tk_peek_kind_at_lptr();
        if (kw != TK_LBRACK && kw != TK_LPAREN && kw != TK_DOT && kw != TK_ARROW)
            goto postfix_done;
    }
    while (1) {
            if (cmatch('[')) {
                Type *type;
                if (k && ispointer(lval->ltype)) {
                    rvalue(lval);
                } else if ( !ispointer(lval->ltype) && lval->ltype->kind != KIND_ARRAY) {
                    errorfmt("Can't subscript", 0);
                    junk();
                    needchar(']');
                    return 0;
                }
                Node *array_node = lval->node;  /* the array/pointer being indexed */
                struct nodepair *idx_pair = expression(&con, &dval, &type);
                Node *idx_node = idx_pair ? idx_pair->node : NULL;
                val = dval;
                needchar(']');
                if (con) {
                    if ( val > lval->ltype->len && lval->ltype->len != -1 && lval->ltype->kind == KIND_ARRAY) {
                        warningfmt("unknown","Access of array at index %d is greater than size %d", val, lval->ltype->len);
                    }
                    if ( ispointer(lval->ltype) && lval->ltype->ptr->kind == KIND_ARRAY) {
                        val *= lval->ltype->ptr->size / lval->ltype->ptr->ptr->size;
                    }
                    cscale(lval->ltype, &val);
                    val += lval->offset;
                    if (ptr && ptr->storage == STKLOC && lval->ltype->kind == KIND_ARRAY &&  (ptr->ctype->kind != KIND_PTR && ptr->ctype->kind != KIND_CPTR)) {
                        /* constant offset to array on stack */
                        lval->offset = val;
                        if (array_node) {
                            lval->node = ast_binop(OP_ADD, array_node,
                                                   ast_literal(type_int, val));
                        }
                    } else if( lval->is_const ) {
                        /* Constant offset to cast to pointer constant */
                        lval->const_val += (val - lval->offset);
                        lval->offset = 0;
                    } else {
                        /* add constant offset to address in primary */
                        lval->node = ast_binop(OP_ADD, lval->node, ast_literal(type_int, val-lval->offset));
                        lval->offset = 0;
                    }
                } else {
                    lval->is_const = 0;   /* Can no longer be constant */
                    /* Capture the runtime index in the AST: arr[i] becomes
                       `(+ arr (* i elem_size))`. The OP_MULT scale was
                       previously claimed to be the walker's job but
                       wasn't actually emitted there — `int arr[10]; int
                       i; arr[i]` returned *(arr + i) instead of
                       *(arr + i*2). Scale at parse time so the walker
                       sees a plain byte-offset OP_ADD. ast_fold_constants
                       collapses `i * 1` and `i * 0` on its own. */
                    if (array_node && idx_node) {
                        int elem = 1;
                        if (lval->ltype) {
                            if (ispointer(lval->ltype) && lval->ltype->ptr) {
                                /* #278: scale = sizeof(*ptr). For
                                   `int(*)[16]` that's sizeof(int[16])
                                   = N*sizeof(int); for `int*` it's
                                   sizeof(int). The earlier
                                   `(ptr->size / ptr->len) * ptr->ptr->size`
                                   formula computed `inner_elem *
                                   inner_inner_elem` (= 4 for the 2D
                                   case) which silently miscompiled
                                   `m[i][j]` when `m` was a 2D-array
                                   parameter. */
                                elem = lval->ltype->ptr->size;
                            } else if (lval->ltype->kind == KIND_ARRAY
                                       && lval->ltype->ptr) {
                                /* True array — the size/len arithmetic
                                   below works when both are known, but
                                   `extern T x[]` (incomplete) leaves
                                   len == -1 and size == 0. The element
                                   type's own size is always reliable,
                                   so use it directly. */
                                elem = lval->ltype->ptr->size;
                            } else if (lval->ltype->size > 0
                                       && lval->ltype->len > 0) {
                                elem = lval->ltype->size / lval->ltype->len;
                            }
                        }
                        Node *scaled = idx_node;
                        if (elem > 1) {
                            scaled = ast_binop(OP_MULT, idx_node,
                                ast_literal(type_int, (zdouble)elem));
                        }
                        lval->node = ast_binop(OP_ADD, array_node, scaled);
                    }
                }
                ptr = deref(lval, YES);
                k = lval->ltype->kind == KIND_ARRAY ? 0 : 1;
            } else if (cmatch('(')) {
                Type *return_type = type_void;
                if ( ispointer(lval->ltype) ) {
                     if (k && lval->const_val == 0)
                        rvalue(lval);
                    /* Function pointer call: stash the callee expression
                       (lval->node so far) on the AST_FUNCPTR_CALL node so the
                       walker can re-emit it. callfunction() returns a fresh
                       AST node and only fills in args+sym; we set callee
                       afterwards. */
                    Node *callee_expr = lval->node;
                    lval->node = callfunction(NULL,lval->ltype);
                    if (lval->node) lval->node->callee = callee_expr;
                    return_type = lval->ltype->ptr->return_type;
                    if ( return_type == NULL ) {
                        return_type = lval->ltype->ptr;
                    }
                } else if ( lval->ltype->kind == KIND_FUNC ) {
                    // Normal function call
                    if ( ptr == NULL ) {
                        /* We've turned it into a function pointer call —
                           same callee-stashing logic as above. */
                        Node *callee_expr = lval->node;
                        lval->node = callfunction(NULL,make_pointer(lval->ltype));
                        if (lval->node) lval->node->callee = callee_expr;
                    } else {
                        lval->node = callfunction(ptr,NULL);
                    }
                    return_type = lval->ltype->return_type;
                } else {
                    // No idea what you are doing, calling a non pointer
                    errorfmt("Calling a non-pointer function?",1);
                }
                /* SDCC char-return widening: in AST mode the walker
                   handles the conversion via the result-type/OP_CAST
                   chain; the parser-side emit is gone. */
                lval->flags &= ~(CALLEE|FASTCALL|SMALLC);
                k = lval->is_const = lval->const_val = 0;
                lval->ltype = return_type;
                lval->ptr_type = KIND_NONE;
                lval->val_type = lval->ltype->kind;
                lval->symbol = NULL;
                // Function returing pointer
                if ( ispointer(lval->ltype) ) {
                    lval->val_type = lval->ltype->kind;
                    lval->ptr_type = lval->ltype->kind;
                    lval->indirect_kind = lval->ltype->kind;
                }
            }
            /* Handle structures... come in here with lval holding the previous
             * pointer to the struct thing..*/
            else if ((direct = cmatch('.')) || tk_match_kind_at_lptr(TK_ARROW)) {
                Type *str = lval->ltype;
                Type *member_type;
                int   name_result;

                // If there's a cast active, then use the cast type
                if ( lval->cast_type ) {
                    str = lval->cast_type;
                }
                name_result = symname(sname);
                if ( str->kind == KIND_PTR || str->kind == KIND_CPTR) {
                    if ( direct ) {
                        UT_string *us;
                        utstring_new(us);
                        utstring_printf(us,"Member reference to '%s' via '",name_result ? sname : "<unknown>");
                        type_describe(str,us);
                        utstring_printf(us,"' is a pointer; did you mean to use '->'?");
                        errorfmt("%s", 1, utstring_body(us));
                        utstring_free(us);
                        direct = 0;
                    }
                    str = str->ptr->tag;
                } else {
                    if ( direct == 0 ) {
                        UT_string *us;
                        utstring_new(us);
                        utstring_printf(us,"Member reference to '%s' via '",name_result ? sname : "<unknown>");
                        type_describe(str,us);
                        utstring_printf(us,"' is not a pointer; did you mean to use '.'?");
                        errorfmt("%s", 1, utstring_body(us));
                        utstring_free(us);
                        direct = 0;
                        direct = 1;
                    }
                    str = str->tag;
                }

                if (str == NULL ) {
                    errorfmt("Non struct type can't take member", 1);
                    junk();
                    return 0;
                }
                if (name_result == 0 || (member_type = find_tag_field(str, sname)) == NULL) {
                    errorfmt("Unknown member: '%s' of struct '%s'", 1, sname, str->name);
                    junk();
                    return 0;
                }

                /*
                 * Here, we're trying to chase our member up, we have to be careful
                 * not to access via far methods near data..
                 */
                if (k && direct == 0) {
                    rvalue(lval);
                }

                debug(DBG_FAR1, "prev=%s name=%s flags %d", lval->symbol->name, ptr->name, lval->flags);
                flags = member_type->flags;

                // We need to acccess via FARACC if:
                // 1. We're accessing via a cptr
                // 2. Our parent was FARACC
                if ( lval->ltype->kind == KIND_CPTR ) {
                    flags |= FARACC;
                } else if ( (lval->flags & FARACC) && (member_type->kind == KIND_CPTR || lval->ltype    ->kind == KIND_STRUCT) ) {
                    flags |= FARACC;
                }
                lval->flags = flags;
                lval->node = ast_binop(OP_ADD, lval->node, ast_literal(type_int,member_type->offset));
                lval->offset = member_type->offset;
                lval->symbol = NULL;
                lval->ltype = member_type;
                lval->indirect_kind = lval->val_type = member_type->kind;
                lval->ptr_type = lval->is_const = lval->const_val = 0;
                if (ispointer(lval->ltype) || lval->ltype->kind == KIND_ARRAY) {
                    lval->ptr_type = lval->ltype->ptr->kind;
                }
                if (lval->ltype->kind == KIND_ARRAY || lval->ltype->kind == KIND_STRUCT ) {
                    k = 0;
                } else
                    k = 1;
            } else
                return k;
        }
postfix_done:
    if (ptr && ptr->ctype->kind == KIND_FUNC) {
        lval->symbol = NULL;  // TODO: Can we actually set it correctly here? - Needed for verification of func ptr arguments
        lval->ltype = ptr->ctype;
        lval->flags = ptr->flags;
        return 0;
    } else if ( ptr && ptr->ctype->flags & FARACC ) {
        lval->flags = FARACC;
    }
    return k;
}
