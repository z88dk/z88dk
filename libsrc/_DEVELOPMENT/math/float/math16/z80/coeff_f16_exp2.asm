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
; Approximation of f(x) = 2**x
; with weight function g(x) = 2**x
; on interval [ -0.5, 0.5 ]
; with a polynomial of degree 5.
; p(x)=((((1.3276472e-3*x+9.6755413e-3)*x+5.5507133e-2)*x+2.402212e-1)*x+6.9314697e-1)*x+1.0000001
;
; float f(float x)
; {
;    float u = 1.3276472e-3f;
;    u = u * x + 9.6755413e-3f;
;    u = u * x + 5.5507133e-2f;
;    u = u * x + 2.402212e-1f;
;    u = u * x + 6.9314697e-1f;
;    return u * x + 1.000000f;
; }
;
;-------------------------------------------------------------------------
; Coefficients for exp2()
;-------------------------------------------------------------------------

SECTION rodata_fp_math16

PUBLIC _f16_coeff_exp2

._f16_coeff_exp2
DEFQ 0x3F800000                 ; 1.000000
DEFQ 0x3F317214                 ; 6.9314697e-1
DEFQ 0x3E75FC8C                 ; 2.402212e-1
DEFQ 0x3D635B73                 ; 5.5507133e-2
DEFQ 0x3C1E8629                 ; 9.6755413e-3
DEFQ 0x3AAE0473                 ; 1.3276472e-3

