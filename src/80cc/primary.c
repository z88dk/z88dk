/*
 *      Small C+ Compiler
 *      Split into parts djm 3/3/99
 *
 *      This part contains various routines to deal with constants
 *      and also finds variable names in the hash tables
 *
 *      $Id: primary.c,v 1.27 2016-11-25 19:46:20 dom Exp $
 */

#include "ccdefs.h"

int primary(LVALUE* lval)
{
    char sname[NAMESIZE];
    SYMBOL* ptr;
    int k;

    if (cmatch('(')) {
        array *comma_chain = NULL;
        while (1) {
            k = heir1(lval);
            if (cmatch(',')) {
                /* Comma operator: this expression's value is discarded
                   but its side effects must be preserved. Collect the
                   node into a chain; the final value (after the last
                   comma) becomes the result. */
                if (lval->node) {
                    if (comma_chain == NULL) comma_chain = array_init(NULL);
                    array_add(comma_chain, lval->node);
                    lval->node = NULL;
                }
                continue;
            }
            break;
        }
        needchar(')');
        if (comma_chain && lval->node) {
            array_add(comma_chain, lval->node);
            lval->node = ast_compound(comma_chain);
        }
        //if ( k == 1 && lval->cast_type) docast(lval, lval);
        return k;
    }

    memset(lval, 0, sizeof(LVALUE));

    if (symname(sname)) {
        if (strcmp(sname, "sizeof") == 0) {
            size_of(lval);
            return (0);
        } else if ( strcmp(sname, "__builtin_offsetof") == 0 ) {
            offset_of(lval);
            return(0);
        } else if ( strcmp(sname, "__func__") == 0 ) {
            /* Append currfn->name (with trailing \0) to the literal
               queue; the walker emits `ld hl, i_<litlab>+<offs>`
               from the AST_STR_LIT node. */
            int32_t offs;
            size_t len = strlen(currfn->name);
            storeq(len + 1, (unsigned char *)currfn->name, &offs);
            lval->const_val = offs;
            lval->is_const = 0;
            lval->ltype = make_pointer(type_char);
            lval->ptr_type = KIND_CHAR;
            lval->val_type = KIND_INT;
            lval->flags = FLAGS_NONE;
            lval->node = ast_str_lit(offs);
            return 0;
        } else if ((ptr = findloc(sname))) {
            lval->offset = 0;
            lval->symbol = ptr;
            lval->ltype = ptr->ctype;
            lval->val_type = lval->indirect_kind = ptr->type;
            lval->flags = ptr->flags;
            lval->ptr_type = KIND_NONE;
            lval->node = ast_local_var(ptr, sname);
            if ( ispointer(lval->ltype) ) {
                lval->ptr_type = ptr->ctype->ptr->kind;
                /* djm long pointers */
                lval->indirect_kind = lval->val_type = lval->ltype->kind;
            }
            
            if ( lval->ltype->kind == KIND_ARRAY || lval->ltype->kind == KIND_STRUCT ) {
                /* djm pointer? */
                lval->ptr_type = lval->ltype->kind == KIND_ARRAY ? lval->ltype->ptr->kind : ptr->type;
                lval->val_type = KIND_PTR;
                return (0);
            } else
                return (1);
        }
        /* djm search for local statics */
        ptr = findstc(sname);
        if (!ptr)
            ptr = findglb(sname);
        if (ptr && ptr->ctype ) {
            if (ptr->ctype->kind != KIND_FUNC && !(ptr->ctype->kind == KIND_PTR && ptr->ctype->ptr->kind == KIND_FUNC) ) {
                if (ptr->ident == ID_ENUM)
                    errorfmt("Unknown symbol: %s", 1, sname);
                lval->node = ast_global_var(ptr, sname);
                if (ptr->ctype->kind == KIND_ENUM) {
                    lval->symbol = NULL;
                    lval->ltype = type_int;
                    lval->val_type = KIND_INT;
                    lval->indirect_kind = KIND_NONE;
                    lval->is_const = 1;
                    lval->const_val = ptr->size;
                    lval->flags = FLAGS_NONE;
                    /* F2: lower enum-member references to AST_LITERAL
                       directly so constexpr()'s ast_fold_constants
                       traversal can fold expressions like
                       `enum E { A = 5, B = A + 1 }`. The previous
                       ast_global_var node would have blocked the
                       fold at the binop step. */
                    lval->node = ast_literal(type_int, (zdouble)ptr->size);
                    return (0);
                }
                lval->symbol = ptr;
                lval->ltype = ptr->ctype;
                lval->indirect_kind = KIND_NONE;
                lval->val_type = ptr->ctype->kind;
                lval->flags = ptr->flags;
                if ( ispointer(lval->ltype) ) {
                    lval->ptr_type = ptr->ctype->ptr->kind;
                }
                if (lval->ltype->kind != KIND_ARRAY && lval->ltype->kind != KIND_STRUCT ) {
                    return (1);
                }
                /* Handle arrays... */
                lval->indirect_kind = lval->ptr_type = ptr->type;
                if ( ispointer(lval->ltype) || lval->ltype->kind == KIND_ARRAY ) {
                    if ( ptr->ctype->flags & FARACC ) { lval->flags |= FARACC; }
                    lval->ptr_type = lval->ltype->ptr->kind;
                }
                return (0);
            } else {
                /* KIND_FUNC or pointer-to-FUNC. Legacy never set lval->node
                   here; for AST mode we need it so callfunction() can stash
                   the callee expression on AST_FUNCPTR_CALL.callee. */
                lval->symbol = ptr;
                lval->ltype = ptr->ctype;
                lval->val_type = KIND_INT;
                lval->ptr_type = KIND_NONE;
                lval->indirect_kind = KIND_NONE;
                lval->node = ast_global_var(ptr, sname);
                return 1;
            }
        } else {
            /* Check to see if we have a right bracket, if we don't assume
             * it's a function then we can break an awful lot of code, do it
             * this way and it's safer... we're not GNU after all!
             */
            if (!rcmatch('(')) {

                errorfmt("Unknown symbol: %s", 1, sname);
                lval->symbol = addglb(sname, type_int, ID_VARIABLE, KIND_INT, 0, EXTERNAL);
                lval->ltype = type_int;
                lval->val_type = KIND_INT;
                lval->ptr_type = KIND_NONE;
                lval->indirect_kind = KIND_NONE;
	            return(1);
            } else {
                /* assume it's a function we haven't seen yet */
                /* NB value set to 0 */
                warningfmt("implicit-function-definition", "Implicit definition of function '%s' it will return an int. Prototype it explicitly if this is not what you want.", sname);
                ptr = addglb(sname, default_function(sname), 0, KIND_INT, 0, STATIK);
                ptr->size = 0;
                ptr->flags |= c_use_r2l_calling_convention == YES ? 0 : SMALLC;
            }
        }
        lval->symbol = ptr;
        lval->ltype = ptr->ctype;
        lval->indirect_kind = KIND_NONE;
        lval->val_type = ptr->type ; /* Null function, always int */
        lval->flags = ptr->flags;
        return (0);
    }
    if (constant(lval)) {
        // lval->ltype is set by constant(), also sets up lval->node
        lval->symbol = NULL;
        lval->indirect_kind = KIND_NONE;
        return (0);
    } else {
        errorfmt("Invalid expression", 0);
        junk();
        return (0);
    }
}


/* calc() / calcun() / CalcStand() removed by F3-narrow. The single
   remaining caller (plunge.c::plnge2a's parser-side const-tracking
   path) inlined the logic as a local static helper. AST-side fold
   for emit goes through ast_opt::ast_fold_constants. */

/* Complains if an operand isn't int */
int intcheck(LVALUE* lval, LVALUE* lval2)
{
    if ( kind_is_decimal(lval->val_type)|| kind_is_decimal(lval2->val_type) ) {
        errorfmt("Operands must be integer types", 0);
        return -1;
    }
    return 0;
}

/* Forces result, having type t2, to have type t1 */
void force(Kind t1, Kind t2, char isunsigned1, char isunsigned2, int isconst)
{
    if (t2 == KIND_CARRY) {
        gen_conv_carry2int();
        isunsigned2 = NO;
        t2 = KIND_INT;
    }

    if (kind_is_decimal(t1)) {
        zconvert_to_decimal(t2, t1, isunsigned2, isunsigned1);
    } else {
        if (kind_is_decimal(t2)) {
            zconvert_from_decimal(t2, t1, isunsigned1);
            return;
        }
    }

    if (t1 == KIND_LONGLONG) {
        if (t2 != KIND_LONGLONG ) {
            zconvert_to_llong(isunsigned1, t2, isunsigned2);
        }
        return;
    }

    /* t2 =source, t1=dest */
    /* int to long, if signed, do sign, if not ld de,0 */
    /* Check to see if constant or not... */
    if (t1 == KIND_LONG) {
        if (t2 != KIND_LONG ) {
            zconvert_to_long(isunsigned1, t2, isunsigned2);
        }
        return;
    }

    if ( t2 == KIND_LONGLONG ) {
        if ( t1 != KIND_LONGLONG && !kind_is_decimal(t1)) {
            // Just convert down to a 32 bit number regardless of destination type
            // inefficient, but we have just been dealing with 64 bit numbers!
            zconvert_to_long(isunsigned1, t2, isunsigned2);
        }
        return;
    }
    

    /* Converting between pointer types..far and near. The narrowing
       far→near warning has been migrated to ast_opt (ast_typecheck
       pass at OP_CAST sites). */
    if (t1 == KIND_CPTR && t2 == KIND_INT)
        gen_conv_uint2long();
        
    /* Char conversion */
    if (t1 == KIND_CHAR && isunsigned2 == NO && !isconst) {
        if (isunsigned1 == NO)
            gen_conv_sint2char();
        else
            gen_conv_uint2char();
    } else if (t1 == KIND_CHAR && isunsigned2 == YES && !isconst) {
        if (isunsigned1 == NO)
            gen_conv_sint2char();
        else
            gen_conv_uint2char();
    }
}

/*
 * If only one operand is KIND_DOUBLE, converts the other one to
 * KIND_DOUBLE.  Returns 1 if result will be KIND_DOUBLE
 *
 * Maybe should an operand in here for KIND_LONG?
 */
int widen_if_float(LVALUE* lval, LVALUE* lval2, int operator_is_commutative)
{
    (void)operator_is_commutative;
    /* AST-mode helper: mirror the legacy decimal-promotion rules onto
       lval / lval2 state (val_type, ltype) so the parser's later
       decision-making picks the right widened type, but skip the
       runtime conversion emit — the walker (cg2_walk_to_decimal in
       ast_codegen2.c) does that from the AST. */
    if (kind_is_floating(lval2->val_type)) {
        if ( kind_is_floating(lval->val_type)) {
            if ( lval->val_type == KIND_DOUBLE) {
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
                return 1;
            }
        }
        if (lval->val_type != lval2->val_type ) {
            lval->val_type = lval2->val_type;
            lval->ltype = lval2->ltype;
        }
        return 1;
    } else if (kind_is_floating(lval->val_type)) {
        lval2->val_type = lval->val_type;
        lval2->ltype = lval->ltype;
        return 1;
    } else if ( kind_is_fixed(lval2->val_type) ) {
        if (lval->val_type != lval2->val_type ) {
            lval->val_type = lval2->val_type;
            lval->ltype = lval2->ltype;
        }
        return 1;
    } else if ( kind_is_fixed(lval->val_type) ) {
        lval2->val_type = lval->val_type;
        lval2->ltype = lval->ltype;
        return 1;
    }
    return 0;
}

void widenintegers(LVALUE* lval, LVALUE* lval2)
{
    /* AST-mode: mirror integer-promotion rules onto lval / lval2 state
       (val_type, ltype) so later parser logic sees the right widened
       type. Skip the runtime widening emit — the walker handles that
       via OP_CAST nodes and cg2_walk_to_long / cg2_walk_to_llong. */
    if (lval2->val_type == KIND_CARRY) {
        lval2->ltype = type_int;
        lval2->val_type = KIND_INT;
    }

    if (lval2->val_type == KIND_LONGLONG) {
        if (lval->val_type != KIND_LONGLONG) {
            lval->ltype = lval->ltype->isunsigned ? type_ulonglong : type_longlong;
            lval->val_type = KIND_LONGLONG;
        }
        return;
    }

    if (lval->val_type == KIND_LONGLONG) {
        if (lval2->val_type != KIND_LONGLONG ) {
            lval->ltype = lval->ltype->isunsigned ? type_ulonglong : type_longlong;
            lval->val_type = KIND_LONGLONG;
        }
        return;
    }

    if (lval2->val_type == KIND_LONG || lval2->val_type == KIND_CPTR) {
        if (lval->val_type != KIND_LONG && lval->val_type != KIND_CPTR) {
            if ( lval2->val_type == KIND_CPTR) {
            } else if ( lval->ltype->isunsigned || lval2->ltype->isunsigned) {
                lval->ltype = type_ulong;
            } else {
                lval->ltype = type_long;
            }
            lval->val_type = KIND_LONG;
        } else if ( lval2->val_type == KIND_LONG) {
            if ( lval->ltype->isunsigned || lval2->ltype->isunsigned) {
                lval->ltype = type_ulong;
            } else {
                lval->ltype = type_long;
            }
        }
        return;
    }

    if (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR ) {
        if ( lval->val_type == KIND_LONG ) {
            if ( lval->ltype->isunsigned || lval2->ltype->isunsigned) {
                lval->ltype = type_ulong;
            } else {
                lval->ltype = type_long;
            }
        }
        return;
    }

    // Promote a char upto an int as necessary
    if ( lval->val_type == KIND_CHAR && lval2->val_type == KIND_INT ) {
        if ( lval->ltype->isunsigned || lval2->ltype->isunsigned ) {
            lval->ltype = type_uint;
        } else {
            lval->ltype = type_int;
        }
        lval->val_type = KIND_INT;
    }

    // Sign mismatch
    if ( lval->ltype->isunsigned != lval2->ltype->isunsigned ) {
        // Longs considered above
        if ( lval->ltype->kind == KIND_CHAR ) {
            lval->ltype = type_uchar;
        } else if ( lval->ltype->kind == KIND_INT ) {
            lval->ltype = type_uint;
        }
    }
}

/*
 * true if val1 -> int pointer or int array and
 * val2 not ptr or array
 */
int dbltest(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type) {
        if (lval->ptr_type == KIND_CHAR)
            return (0);
        if (lval2->ptr_type)
            return (0);
        return (1);
    } else
        return (0);
}

/*
 * determine type of binary operation
 */
void result(LVALUE* lval, LVALUE* lval2)
{
    if (lval->ptr_type && lval2->ptr_type) {
        lval->ptr_type = KIND_NONE; /* ptr-ptr => int */
        if (lval->val_type == KIND_CPTR) {
            lval->val_type = KIND_LONG;
            lval->ltype = type_long;
        } else {
            lval->val_type = KIND_INT;
            lval->ltype = type_int;            
        }
        lval->indirect_kind = KIND_NONE;
    } else if (lval2->ptr_type) { /* ptr +- int => ptr */
        lval->symbol = lval2->symbol;
        lval->ltype = lval2->ltype;
        lval->indirect_kind = lval2->indirect_kind;
        lval->ptr_type = lval2->ptr_type;
    }
}

/*
 * prestep - preincrement or predecrement lvalue
 */

void prestep(
    LVALUE* lval,
    int n,
    void (*step)(LVALUE *lval),
    int ast_type)
{
    (void)n; (void)step;
    if (heira(lval) == 0) {
        needlval();
    } else {
        /* AST-mode: emit (load / step / store) for the pre-step is
           done by the walker via cg2_step. Here we just wrap the
           AST with the appropriate step uop and mark the symbol
           as written. */
        lval->node = ast_uop(ast_type, lval->node);
        rvalue(lval);
        if (lval->symbol)
            lval->symbol->isassigned = YES;
    }
}

/*
 * poststep - postincrement or postdecrement lvalue
 */
void poststep(
    int k,
    LVALUE* lval,
    int n,
    void (*step)(LVALUE *lval),
    void (*unstep)(LVALUE *lval),
    int ast_type)
{
    (void)n; (void)step; (void)unstep;
    if (k == 0) {
        needlval();
    } else {
        /* AST-mode: emit (load / step / store / un-step) for the
           post-step is done by the walker via cg2_step. Just wrap
           the AST and mark the symbol as written. */
        lval->node = ast_uop(ast_type, lval->node);
        rvalue(lval);
        if (lval->symbol)
            lval->symbol->isassigned = YES;
    }
}

/*
 * generate code to postincrement by n
 * no need to change for long pointers since we're going to have
 * memory pools..
 */
/* The walker emits the actual store from the OP_ASSIGN AST node;
   this hook exists for the const-write diagnostic + isassigned flag
   (used by the maybe-uninitialised warning in rvalue() below). */
void store(LVALUE* lval)
{
    if ( lval->symbol && lval->symbol->isconst && lval->symbol->isassigned )
        errorfmt("Attempt to modify const lvalue \'%s\'",0,lval->symbol->name);
    if ( lval->symbol )
        lval->symbol->isassigned = YES;
}


void rvalue(LVALUE* lval)
{
    /* AST construction: wrap the lvalue's address in an OP_DEREF and
       stamp it with the storage type so the walker knows the load
       width — for member access the operand simplifies to
       `(+ (lv=p) offset)` whose own type is meaningless.
       The maybe-uninitialised warning fires here because rvalue() is
       the canonical "use this lvalue's value" hook.
       Legacy emit (gen_load_static / gen_load_indirect / docast /
       gen_intrinsic_in) deleted in Phase H.2.b.1 — the walker emits
       the loads from the AST. */
    lval->node = ast_uop(OP_DEREF, lval->node);
    lval->node->type = lval->ltype;
    if ( lval->symbol && lval->symbol->isassigned == NO ) {
        warningfmt("maybe-uninitialized","Variable '%s' may be used before initialisation", lval->symbol->name);
    }
    if (lval->cast_type) docast(lval, lval);
}

#define CHECK(v, min, max) do { \
        if ( v < min || v > max ) warningfmt("limited-range","Value is out of range for assignment"); \
    } while (0)

void check_assign_range(Type *type, double const_value)
{
    Kind lhs_val_type = type->kind;
    int  factor = type->bit_size ? ((1 << type->bit_size) - 1) : 0xffff;

    if ( lhs_val_type == KIND_INT && !isutype(type) ) {
        CHECK(const_value, -(32767 & factor), (65535 & factor));
    } else if ( lhs_val_type == KIND_INT && isutype(type) ) {
        CHECK(const_value, 0, (65535 & factor));
    } else if ( lhs_val_type == KIND_CHAR && !isutype(type) ) {
        CHECK(const_value, -(127 & factor), (255 & factor));
    } else if ( lhs_val_type == KIND_CHAR && isutype(type) ) {
        CHECK(const_value, 0, (255 & factor));
    }
}
#undef CHECK

/** 
 * \retval 1 - If constant true
 * \retval 0 - If constant false
 * \retval -1 - Not constant
 */
struct nodepair *test(int label, int parens)
{
    LVALUE lval={0};
    struct nodepair *pair = calloc(1,sizeof(*pair));
    
    if (parens)
        needchar('(');
    array *comma_chain = NULL;
    while (1) {
        if (heir1(&lval)) {
            rvalue(&lval);
        }
        if (cmatch(',')) {
            /* Comma operator: this expression's value is discarded
               but its side effects must be preserved in the AST. */
            if (lval.node) {
                if (comma_chain == NULL) comma_chain = array_init(NULL);
                array_add(comma_chain, lval.node);
                lval.node = NULL;
            }
        } else
            break;
    }
    if (comma_chain && lval.node) {
        array_add(comma_chain, lval.node);
        lval.node = ast_compound(comma_chain);
    }
    if (parens)
        needchar(')');
    if (lval.is_const) { /* constant expression */
        if (lval.const_val) {
            /* true constant, perform body */
            pair->i = lval.const_val;
            pair->node = lval.node;
            return pair;
        }
        /* false constant, jump round body */
      //  gen_jp_label(label);
        pair->i = 0;
        pair->node = lval.node;
        return pair;
    }
    
    /* AST-mode: the testjump/jumpnc emit is gone — the walker handles
       conditional branches from AST_IF / AST_TERNARY / AST_CONDITIONAL
       nodes via gen_jp_label + truthiness test. */

    pair->node = lval.node;
    pair->i = -1;
    return pair;
}

/*
 * evaluate constant expression
 * return TRUE if it is a constant expression
 *
 * F2: builds the AST via expression(), runs ast_fold_constants on
 * the sub-tree, and reads the value from the resulting AST_LITERAL.
 * No longer depends on the parser-side `lval->is_const` /
 * `lval->const_val` tracking — paving the way for F3 to delete
 * those LVALUE fields entirely. Caller contract unchanged.
 */
int constexpr(double *val, Kind *type, int flag)
{
    zdouble valtemp;
    int con;
    struct nodepair *pair;
    Type   *type_ptr;

    pair = expression(&con, &valtemp, &type_ptr);

    /* Try to fold the AST sub-tree to a literal. ast_const_propagate
       isn't needed here: enum-member references already lower to
       AST_LITERAL at parse time (see the ID_ENUM branch in primary.c);
       no other parse-time constant context involves cross-statement
       binding propagation. */
    Node *folded = ast_fold_constants(pair->node);
    if (folded && folded->ast_type == AST_LITERAL) {
        *val  = folded->zval;
        *type = folded->type ? folded->type->kind : KIND_INT;
        return 1;
    }
    if (flag)
        errorfmt("Expecting constant expression", 0);
    *val = 0;
    *type = KIND_INT;
    return 0;
}

/*
 * scale constant value according to type
 */
void cscale(Type *type, int* val)
{
    if ( type->size == -1 || ispointer(type)) { 
        // It's an array of unknown length
        *val *= type->ptr->size / type->ptr->len;
        return;
    }
    *val *= type->size / type->len;
}


/**
 * \param lval - The lval that holds the cast informatino
 * \param dest_lval - The lvalue that will be changed
 */
int docast(LVALUE* lval, LVALUE *dest_lval)
{
    /* AST-mode: wrap the cast target with an OP_CAST AST node, fold
       the constant value through the narrowing-cast, then update the
       destination lval state (ltype / val_type / ptr_type /
       indirect_kind) to reflect the cast target. The runtime
       conversion emit is dropped — the walker emits OP_CAST via
       zconvert_to_decimal / zconvert_to_long / zconvert_to_llong. */
    dest_lval->node = ast_cast(lval->cast_type, dest_lval->node);

    if ( kind_is_integer(lval->cast_type->kind) && dest_lval->is_const) {
        int64_t val = dest_lval->const_val;
        if ( lval->cast_type->kind < dest_lval->val_type) {
            if ( lval->cast_type->kind == KIND_INT ) {
                dest_lval->const_val = lval->cast_type->isunsigned ? (uint16_t)(val & 0xffff) : (int16_t)(val & 0xffff);
            } else if ( lval->cast_type->kind == KIND_CHAR) {
                dest_lval->const_val = lval->cast_type->isunsigned ? (uint8_t)(val & 0xff) : (int8_t)(val & 0xff);
            } else if ( lval->cast_type->kind == KIND_LONG) {
                dest_lval->const_val = lval->cast_type->isunsigned ? (uint32_t)(val & 0xffffffff) : (int32_t)(val & 0xffffffff);
            }
        }
    }

    dest_lval->ltype = lval->cast_type;
    dest_lval->val_type = dest_lval->ltype->kind;
    lval->cast_type = NULL;
    dest_lval->ptr_type = KIND_NONE;
    if ( ispointer(dest_lval->ltype) ) {
        dest_lval->ptr_type = dest_lval->ltype->ptr->kind;
        dest_lval->indirect_kind = dest_lval->val_type = dest_lval->ltype->kind;
    }
    return (1);
}

/*
 * Check whether a type is unsigned..
 */

int ulvalue(LVALUE* lval)
{
    return isutype(lval->ltype);
}

