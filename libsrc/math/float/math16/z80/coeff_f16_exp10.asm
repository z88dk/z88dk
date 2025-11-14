;
; Extracted from cephes-math
;
; Cephes is a C language library for special functions of mathematical physics
; and related items of interest to scientists and engineers.
; https://fossies.org/
;
; Coefficients from lolremez, to make use of additional accuracy in
; calculation from 32-bit mantissa poly() function.
;
; Approximation of f(x) = 10**x
; with weight function g(x) = 10**x
; on interval [ 0, 0.15051499783 ]
; with a polynomial of degree 5.
; p(x)=((((6.4075045e-1*x+1.1538467)*x+2.0360299)*x+2.6509022)*x+2.3025857)*x+1.
;
; float f(float x)
; {
;    float u = 6.4075045e-1f;
;    u = u * x + 1.1538467f;
;    u = u * x + 2.0360299f;
;    u = u * x + 2.6509022f;
;    u = u * x + 2.3025857f;
;    return u * x + 1.f;
; }
;
;-------------------------------------------------------------------------
; Coefficients for exp10f()
;-------------------------------------------------------------------------

SECTION rodata_fp_math16

PUBLIC _f16_coeff_exp10

._f16_coeff_exp10
DEFQ 0x3F800000                 ; 1.0000000
DEFQ 0x40135D90                 ; 2.3025857
DEFQ 0x4029A862                 ; 2.6509022
DEFQ 0x40024E50                 ; 2.0360299
DEFQ 0x3F93B140                 ; 1.1538467
DEFQ 0x3F240839                 ; 6.4075045e-1

