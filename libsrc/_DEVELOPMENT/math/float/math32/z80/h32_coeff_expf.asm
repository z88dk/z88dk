;
; Extracted from cephes-math
;
; Cephes is a C language library for special functions of mathematical physics
; and related items of interest to scientists and engineers.
; https://fossies.org/
;
;-------------------------------------------------------------------------
; Coefficients for expf()
;-------------------------------------------------------------------------

SECTION rodata_fp_math32

PUBLIC _m32_coeff_expf

._m32_coeff_expf

DEFQ 0x3F000000         ; 5.0000001201E-1
DEFQ 0x3E2AAAAA         ; 1.6666665459E-1
DEFQ 0x3D2AA9C1         ; 4.1665795894E-2
DEFQ 0x3C088908         ; 8.3334519073E-3
DEFQ 0x3AB743CE         ; 1.3981999507E-3
DEFQ 0x39506967         ; 1.9875691500E-4

