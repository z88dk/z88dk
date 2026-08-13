#ifndef IR_KIND_H
#define IR_KIND_H

/* The scalar/aggregate type tag shared by the front end (define.h) and the
   IR layer (ir.h). Single source of truth: previously the enum lived in
   define.h while ir.h aliased `typedef int Kind`, so the IR/analysis layer
   carried the value but not the names and could not reason about it. The
   enum is dependency-free (pure constants), so including it in ir.h keeps
   the standalone, ccdefs-free ir_selftest link intact. */
typedef enum {
    KIND_NONE,
    KIND_VOID,
    KIND_CHAR,
    KIND_SHORT,
    KIND_INT,
    KIND_LONG,
    KIND_FLOAT,
    KIND_DOUBLE,
    KIND_ARRAY,
    KIND_PTR,
    KIND_CPTR,
    KIND_STRUCT, /* 11 */
    KIND_FUNC,
    KIND_ELLIPSES,
    KIND_PORT8,
    KIND_PORT16,
    KIND_ENUM,
    KIND_CARRY,
    KIND_FLOAT16,
    KIND_LONGLONG,
    KIND_ACCUM16,
    KIND_ACCUM32,
} Kind;

#define kind_is_fixed(x)  ( (x) == KIND_ACCUM16 || (x) == KIND_ACCUM32)
#define kind_is_floating(x)  ( (x) == KIND_DOUBLE || (x) == KIND_FLOAT16)
#define kind_is_integer(k) ( k == KIND_CHAR || k == KIND_INT || k == KIND_SHORT || k == KIND_LONG || k == KIND_LONGLONG )

#define kind_is_decimal(x)  ( kind_is_floating(x) || kind_is_fixed(x) )

/* Scalar width (bytes) determined by kind ALONE — the maths-mode-independent
   kinds. Returns 0 for kinds whose width needs more context: KIND_DOUBLE /
   KIND_FLOAT (the active maths mode, c_fp_size = 2/4/5/6/8) and the
   aggregates KIND_ARRAY / KIND_STRUCT (the declared element/member size).
   width_for_kind() in ir_build layers the c_fp_size float case on top of
   this; the IR/analysis layer uses it directly for (kind,width) consistency
   checks. NB width can't disambiguate the width-2 kinds (int / ptr /
   accum16 / float16 all → 2) — only the kind can; that's the point. */
static inline int kind_scalar_width(Kind k)
{
    switch (k) {
    case KIND_CHAR:                                     return 1;
    case KIND_SHORT: case KIND_INT: case KIND_PTR:
    case KIND_ACCUM16: case KIND_FLOAT16:               return 2;
    case KIND_CPTR:                                     return 4; /* DEHL: 3B in mem, 4B in regs */
    case KIND_LONG: case KIND_ACCUM32:                  return 4;
    case KIND_LONGLONG:                                 return 8;
    default:                                            return 0;
    }
}

/* Operation-dispatch class: the axis that decides HOW an operation lowers
   (sccz80's kind switch). Width is the wrong axis for this — same width spans
   integer/float/fixed/pointer (width-4 = long / math32 double / __far cptr /
   accum32). kind_class collapses the kind enum to the lowering families:

     KC_INTEGER   generic IR ops; width then picks the 1/2/4 carry-chain length
     KC_LONGLONG  always helper-dispatched (l_i64_* via IR_ACC_*) — separated
                  from INTEGER because it never uses the generic width path
     KC_FLOAT     helper-dispatched (dadd / l_f*_* via IR_ACC_*)
     KC_FIXED     _Accum: add/sub/cmp/neg are bit-identical to INTEGER; only
                  mul/div need Q-format scaling helpers (route per-operation)
     KC_POINTER   integer arithmetic, scaled by pointee size (far = own ABI)
     KC_AGGREGATE array/struct — no scalar arithmetic
     KC_OTHER     void/none/func/port/ellipses

   Total by construction (explicit switch); a routing default arm that hits
   KC_OTHER/AGGREGATE for an arithmetic op is a builder bug. KIND_CARRY (a 0/1
   flag result) and KIND_ENUM fold into INTEGER. */
typedef enum {
    KC_INTEGER,
    KC_LONGLONG,
    KC_FLOAT,
    KC_FIXED,
    KC_POINTER,
    KC_AGGREGATE,
    KC_OTHER,
} KindClass;

static inline KindClass kind_class(Kind k)
{
    switch (k) {
    case KIND_CHAR: case KIND_SHORT: case KIND_INT:
    case KIND_LONG: case KIND_ENUM:  case KIND_CARRY:    return KC_INTEGER;
    case KIND_LONGLONG:                                  return KC_LONGLONG;
    case KIND_FLOAT: case KIND_DOUBLE: case KIND_FLOAT16:return KC_FLOAT;
    case KIND_ACCUM16: case KIND_ACCUM32:                return KC_FIXED;
    case KIND_PTR: case KIND_CPTR:                       return KC_POINTER;
    case KIND_ARRAY: case KIND_STRUCT:                   return KC_AGGREGATE;
    default:                                             return KC_OTHER;
    }
}

#endif /* IR_KIND_H */
