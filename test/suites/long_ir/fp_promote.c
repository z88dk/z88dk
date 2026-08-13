/* Mixed integer/double (acc-tier) float correctness — the conversions the
   removed walker used to insert, now in ir_build (build_operand_as_acc /
   coerce_int_to_float_kind). Covers arithmetic, comparison, assignment,
   initialisation and return across char/int/long/long long operands.
   Each case is its own function so frame layouts don't interact. */
#include "test.h"

double g;

/* --- arithmetic (mixed int OP double, both operand orders) --- */
static int a_mul(void){ double d = 4.0; return (int)(3 * d) + (int)(d * 5); }   /* 12+20 */
static int a_div(void){ double d = 4.0; return (int)(d / 2) + (int)(40 / d); }  /* 2+10 */
static int a_addsub(void){ double d = 4.0; return (int)(3 + d) + (int)(d - 1); }/* 7+3 */
static int a_char(void){ char c = 6; double d = 4.0; return (int)(c * d); }     /* 24 */
static int a_long(void){ long l = 100; double d = 4.0; return (int)(l * d); }   /* 400 */
static int a_ll(void){ long long q = 7; double d = 4.0; return (int)(q * d); }  /* 28 */

/* --- comparison (mixed) --- */
static int c_gt(void){ double d = 4.0; return (d > 3) + (3 < d) + (d == 4); }   /* 3 */

/* --- assignment / init / return conversions --- */
static int s_glob_var(int i){ g = i; return (int)g; }
static int s_glob_const(void){ g = 9; return (int)g; }
static int s_loc_var(int i){ double d = i; return (int)d; }
static int s_loc_const(void){ double d = 5; return (int)d; }
static int s_long(void){ long l = 1000; g = l; return (int)g; }
static double s_ret(int i){ return i; }

/* --- compound-assign with int rhs --- */
static int ca_add(void){ double d = 10.0; d += 5; return (int)d; }   /* 15 */
static int ca_sub(void){ double d = 10.0; d -= 3; return (int)d; }   /* 7 */
static int ca_mul(void){ double d = 4.0; d *= 5; return (int)d; }    /* 20 */
static int ca_div(void){ double d = 40.0; d /= 8; return (int)d; }   /* 5 */
static int ca_glob(void){ g = 10.0; g += 6; return (int)g; }         /* 16 */
static int inc_post(void){ double d = 5.0; int r = (int)(d++); return r*100+(int)d; } /* 506 */
static int inc_pre(void){ double d = 5.0; int r = (int)(++d); return r*100+(int)d; }  /* 606 */
static int inc_dec(void){ g = 5.0; g--; --g; return (int)g; }        /* 3 */

/* A write-once int reused across several acc-double ops becomes a slotless
   PR_BC tenant; the float helpers (dadd/dmul/l_int2long_s_float) clobber BC,
   and with no backing slot its value was reloaded from the -1 "no slot"
   address (below-frame garbage). Each op must see b==2. */
static int acc_int_reuse(void){
    double a = 2; int b = 2;
    a += b; a *= b; a /= b; a -= b;       /* 2 -> 4 -> 8 -> 4 -> 2 */
    return (int)a;
}

/* An int ARG (literal or value) to a double PARAM needs the int->double
   conversion at the call site (widen_arg_to_param). Without it the int is
   pushed at its narrow width and the callee reads a garbage wide value —
   e.g. `run_sqrt(6400, 80.0)` arrived with x==0. */
static int dparam(double x, double y){ return (int)(x + y); }
static int int_arg_to_double_param(void){
    int n = 9;
    return dparam(6400, 80) + dparam(n, 3);   /* 6480 + 12 = 6492 */
}

static void test_fp_promote(void)
{
    assertEqual(a_mul(), 32); assertEqual(a_div(), 12); assertEqual(a_addsub(), 10);
    assertEqual(a_char(), 24); assertEqual(a_long(), 400); assertEqual(a_ll(), 28);
    assertEqual(c_gt(), 3);
    assertEqual(s_glob_var(7), 7); assertEqual(s_glob_const(), 9);
    assertEqual(s_loc_var(7), 7); assertEqual(s_loc_const(), 5);
    assertEqual(s_long(), 1000); assertEqual((int)s_ret(11), 11);
    assertEqual(ca_add(), 15); assertEqual(ca_sub(), 7); assertEqual(ca_mul(), 20);
    assertEqual(ca_div(), 5); assertEqual(ca_glob(), 16);
    assertEqual(inc_post(), 506); assertEqual(inc_pre(), 606); assertEqual(inc_dec(), 3);
    assertEqual(acc_int_reuse(), 2);
    assertEqual(int_arg_to_double_param(), 6492);
}
int main(void){ suite_setup("fp-promote"); suite_add_test(test_fp_promote); return suite_run(); }
