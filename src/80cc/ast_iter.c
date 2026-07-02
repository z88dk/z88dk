/*
 *  ast_iter.c — generic child traversal.
 *
 *  Everything an analysis or rewrite pass needs to know about which
 *  Node fields hold children for a given ast_type lives in the
 *  switch below. Per-pass switches that used to duplicate this
 *  knowledge can disappear.
 *
 *  Adding a new AST variant: add a single case here. Other passes
 *  pick up the new variant automatically — they walk the resulting
 *  children without needing per-variant updates.
 */

#include "ccdefs.h"
#include "ast_iter.h"

void ast_for_each_child(Node *parent, ast_visit_fn fn, void *ctx)
{
    if (!parent) return;
    AstSlot s = {0};
#define SLOT(F) do {                                                    \
        s.direct = &parent->F; s.arr = NULL;                            \
        fn(&s, ctx);                                                    \
    } while (0)
#define EACH(F) do {                                                    \
        if (parent->F) {                                                \
            s.direct = NULL; s.arr = parent->F;                         \
            int _n = array_len(parent->F);                              \
            for (s.arr_idx = 0; s.arr_idx < _n; s.arr_idx++)            \
                fn(&s, ctx);                                            \
        }                                                               \
    } while (0)

    switch (parent->ast_type) {
    /* Leaves. The union slot in these variants holds a non-pointer
       (zval, sym, label) so blindly reading node->left etc. would
       interpret those bits as a Node*. */
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_LABEL:
    case AST_JUMP:
    case AST_UNDECL:
    case AST_INIT_STATIC:
    case AST_ASM:
        break;

    /* Binary operators incl. compound assignments. */
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
    case OP_ASSIGN:
    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR: case OP_AXOR:
    case OP_ASSHL: case OP_ASSHR:
        SLOT(left);
        SLOT(right);
        break;

    /* Unary operators — pre/post step, deref, addr, cast, sizeof,
       arithmetic neg / comp / lneg, plus AST_DEREF / AST_ADDR (the
       parser-side "address marker" wrappers). */
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_DEREF: case OP_ADDR:
    case AST_DEREF: case AST_ADDR:
    case OP_PRE_INC: case OP_POST_INC:
    case OP_PRE_DEC: case OP_POST_DEC:
    case OP_CAST:
    case OP_SIZEOF:
        SLOT(operand);
        break;

    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        EACH(args);
        SLOT(callee);
        break;

    case AST_RETURN:
        SLOT(retval);
        break;

    case AST_COMPOUND_STMT:
    case AST_INIT_LIST:
        EACH(stmts);
        break;

    case AST_IF:
    case AST_TERNARY:
        SLOT(cond);
        SLOT(then);
        SLOT(els);
        break;

    case AST_SWITCH:
        SLOT(sw_expr);
        SLOT(sw_body);
        /* sw_cases holds the dispatch-table AST_SWITCH_CASE nodes,
           distinct from the AST_LABEL markers that docase() inserts
           into sw_body. The two arrays don't share nodes, so we need
           to walk both — passes like jump-threading reach the case
           dispatches only through here. */
        EACH(sw_cases);
        break;

    case AST_SWITCH_CASE:
        SLOT(sw_value);
        break;

    case AST_DECL:
        SLOT(declvar);
        break;

    case AST_CRITICAL:
        SLOT(operand);
        break;

    case AST_LOOP_COUNTDOWN:
        SLOT(loop_init);
        SLOT(loop_body);
        break;

    case AST_PRESERVE_BC:
        SLOT(operand);
        break;
    }

#undef SLOT
#undef EACH
}
