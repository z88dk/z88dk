/* Const-fold stress: each function should fold to a literal at compile
   time. Used as a baseline for F1 (drop parser-side fold). After F1,
   the walker's ast_fold_constants must produce identical asm. */

int int_add(void)  { return 5 + 3; }
int int_sub(void)  { return 100 - 23; }
int int_mul(void)  { return 7 * 11; }
int int_div(void)  { return 100 / 4; }
int int_mod(void)  { return 23 % 5; }
int int_and(void)  { return 0xF0 & 0x18; }
int int_or(void)   { return 0x80 | 0x07; }
int int_xor(void)  { return 0xFF ^ 0x55; }
int int_shl(void)  { return 1 << 8; }
int int_shr(void)  { return 0x1000 >> 4; }
int int_neg(void)  { return -42; }
int int_comp(void) { return ~0xFF; }
int int_lneg(void) { return !0; }
int int_lneg2(void){ return !5; }

int cmp_eq(void)   { return 5 == 5; }
int cmp_ne(void)   { return 5 != 6; }
int cmp_lt(void)   { return 3 < 7; }
int cmp_ge(void)   { return 7 >= 7; }

int char_overflow(void) { return (char)200 + (char)100; }  /* legacy promotes to int */
int char_inrange(void)  { return (unsigned char)100 + (unsigned char)50; }

long long_add(void) { return 100000L + 50000L; }
long long_mul(void) { return 1000L * 1000L; }
long long_shr(void) { return 0x10000L >> 8; }

unsigned u_div(void) { return 100u / 7u; }
unsigned u_mod(void) { return 100u % 7u; }
unsigned u_shr(void) { return 0xFFFFu >> 4; }

int mixed_chain(void) { return (5 + 3) * 2 - 1; }
int nested_paren(void){ return (((10 - 5) + (8 * 2)) << 2); }

/* These should fold via const-prop (variable assigned a literal). */
int const_prop(void) { int x = 42; return x + 8; }

int main(void) {
    return int_add() + int_sub() + cmp_eq() + char_overflow()
         + (int)long_add() + u_div() + mixed_chain() + const_prop();
}
