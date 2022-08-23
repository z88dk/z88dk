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
;  Approximation of f(x) = exp(x)
;  with weight function g(x) = exp(x)
;  on interval [ -0.5, 0.5 ]
;  with a polynomial of degree 9.
; float f(float x)
; {
;   float u = 2.7401157e-6f;
;   u = u * x + 2.4972405e-5f;
;   u = u * x + 1.984268e-4f;
;   u = u * x + 1.388852e-3f;
;   u = u * x + 8.3333304e-3f;
;   u = u * x + 4.166667e-2f;
;   u = u * x + 1.6666667e-1f;
;   u = u * x + 5.e-1f;
;   u = u * x + 1.f;
;   return u * x + 1.f;
; }
;
;-------------------------------------------------------------------------
; Coefficients for expf()
;-------------------------------------------------------------------------

SECTION rodata_clib
SECTION rodata_fp_math32

PUBLIC _m32_coeff_expf

._m32_coeff_expf
DEFQ 0x3F800000         ; 1.0000000e+0
DEFQ 0x3F800000         ; 1.0000000e+0
DEFQ 0x3F000000         ; 5.0000000e-1
DEFQ 0x3E2AAAAB         ; 1.6666667e-1
DEFQ 0x3D2AAAAB         ; 4.1666667e-2
DEFQ 0x3C088889         ; 8.3333334e-3
DEFQ 0x3AB60B61         ; 1.3888889e-3
DEFQ 0x395010CA         ; 1.9842680e-4
DEFQ 0x37D17BD5         ; 2.4972405e-5
DEFQ 0x3637E2D4         ; 2.7401157e-6
