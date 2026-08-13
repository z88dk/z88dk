/*
 *  ast_iter.h — generic child traversal for AST analysis passes.
 *
 *  Captures the per-variant Node child layout in ONE place
 *  (ast_for_each_child). Passes recurse generically through the
 *  iterator instead of re-enumerating which fields exist for each
 *  ast_type. Reduces every tree-walking pass to a handful of lines
 *  and eliminates the "default: walk node->left" footgun on leaf
 *  variants whose union slot holds a non-pointer (zval, sym).
 *
 *  Mutating passes (fold, simplify, strength-reduce) write back
 *  through ast_slot_set so the same code handles direct fields
 *  (`node->left`) and array-element children (`node->stmts[i]`)
 *  uniformly.
 */

#ifndef AST_ITER_H
#define AST_ITER_H

#include "define.h"

/* A "slot" is the address of a Node* — either a named field of a
   parent node, or a position inside an array-valued field. The
   slot pointer is valid only for the duration of the callback. */
typedef struct {
    Node **direct;   /* != NULL: address of a Node* field */
    array *arr;     /* != NULL: array; arr_idx is the position */
    int    arr_idx;
} AstSlot;

static inline Node *ast_slot_get(const AstSlot *s)
{
    return s->direct ? *s->direct
                     : (Node *)array_get_byindex(s->arr, s->arr_idx);
}

static inline void ast_slot_set(const AstSlot *s, Node *n)
{
    if (s->direct) *s->direct = n;
    else           array_set_byindex(s->arr, s->arr_idx, n);
}

typedef void (*ast_visit_fn)(const AstSlot *slot, void *ctx);

/* Call `fn` once per child of `parent`. NULL parent is a no-op.
   The slot is invalidated when `fn` returns; if the callback
   wants to remember a position, it must dereference inside the
   call. */
void ast_for_each_child(Node *parent, ast_visit_fn fn, void *ctx);

#endif
