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
;  Approximation of f(x) = 2**x
;  with weight function g(x) = 2**x
;  on interval [ -0.5, 0.5 ]
;  with a polynomial of degree 9.
;  double f(double x)
;  {
;    double u = 1.0150336705309648e-7;
;    u = u * x + 1.3259405609345135e-6;
;    u = u * x + 1.5252984838653427e-5;
;    u = u * x + 1.540343494807179e-4;
;    u = u * x + 1.3333557617604443e-3;
;    u = u * x + 9.6181291920672461e-3;
;    u = u * x + 5.5504108668685612e-2;
;    u = u * x + 2.4022650695649653e-1;
;    u = u * x + 6.9314718055987097e-1;
;    return u * x + 1.0000000000000128;
;  }
;
;-------------------------------------------------------------------------
; Coefficients for exp2f()
;-------------------------------------------------------------------------

SECTION rodata_fp_math32

PUBLIC _m32_coeff_exp2f

._m32_coeff_exp2f
DEFQ 0x3F800000                 ; 1.0000000000000000E+00
DEFQ 0x3F317218                 ; 6.9314718055987097E-01
DEFQ 0x3E75FDF0                 ; 2.4022650695649653E-01
DEFQ 0x3D635847                 ; 5.5504108668685612E-02
DEFQ 0x3C1D955C                 ; 9.6181291920672461E-03
DEFQ 0x3AAEC3FF                 ; 1.3333557617604443E-03
DEFQ 0x39218448                 ; 1.5403434948071790E-04
DEFQ 0x377FE712                 ; 1.5252984838653427E-05
DEFQ 0x35B1F6F9                 ; 1.3259405609345135E-06
DEFQ 0x33D9FA11                 ; 1.0150336705309648E-07

