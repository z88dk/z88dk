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
; Approximation of f(x) = exp(x)
; with weight function g(x) = exp(x)
; on interval [ -0.5, 0.5 ]
; with a polynomial of degree 5.
; p(x)=((((8.2592303e-3*x+4.2180928e-2)*x+1.667058e-1)*x+4.9995314e-1)*x+9.9999726e-1)*x+1.0000006
;
; float f(float x)
; {
;    float u = 8.2592303e-3f;
;    u = u * x + 4.2180928e-2f;
;    u = u * x + 1.667058e-1f;
;    u = u * x + 4.9995314e-1f;
;    u = u * x + 9.9999726e-1f;
;    return u * x + 1.0000006f;
; }
;
;-------------------------------------------------------------------------
; Coefficients for exp()
;-------------------------------------------------------------------------

SECTION rodata_fp_math16

PUBLIC _f16_coeff_exp

._f16_coeff_exp
DEFQ 0x3F800005         ; 1.0000006
DEFQ 0x3F7FFFD2         ; 9.9999726e-1
DEFQ 0x3EFFF9DC         ; 4.9995314e-1
DEFQ 0x3E2AB4ED         ; 1.667058e-1
DEFQ 0x3D2CC5E9         ; 4.2180928e-2
DEFQ 0x3C0751B9         ; 8.2592303e-3

