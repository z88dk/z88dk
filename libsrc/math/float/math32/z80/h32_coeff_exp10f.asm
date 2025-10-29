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
;  Approximation of f(x) = 10**x
;  with weight function g(x) = 10**x
;  on interval [ 0, 0.15051499783 ]
;  with a polynomial of degree 7.
;  double f(double x)
;  {
;    double u = 8.090484272600454e-2;
;    u = u * x + 2.0380373931544082e-1;
;    u = u * x + 5.3978993685198384e-1;
;    u = u * x + 1.1712266435079228;
;    u = u * x + 2.0346796696616236;
;    u = u * x + 2.6509490353631601;
;    u = u * x + 2.3025850931327687;
;    return u * x + 9.9999999999984258e-1;
;  }
;
;-------------------------------------------------------------------------
; Coefficients for exp10f()
;-------------------------------------------------------------------------

SECTION rodata_clib
SECTION rodata_fp_math32

PUBLIC _m32_coeff_exp10f

._m32_coeff_exp10f
DEFQ 0x3F800000                 ; 1.0000000000000000E+00
DEFQ 0x40135D8E                 ; 2.3025850931327687E+00
DEFQ 0x4029A926                 ; 2.6509490353631601E+00
DEFQ 0x40023831                 ; 2.0346796696616236E+00
DEFQ 0x3F95EAC1                 ; 1.1712266435079228E+00
DEFQ 0x3F0A2FAC                 ; 5.3978993685198384E-01
DEFQ 0x3E50B1ED                 ; 2.0380373931544082E-01
DEFQ 0x3DA5B170                 ; 8.0904842726004540E-02

