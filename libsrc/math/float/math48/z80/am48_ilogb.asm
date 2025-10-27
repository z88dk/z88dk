
; int ilogb(double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_ilogb

EXTERN error_erange_zc

am48_ilogb:

   ; Return the power of two exponent of x with significand of x >= 1 and < 2.
   ; This is a logarithm as opposed to lm48_frexp which disassembles the internal exponent of x.
   ;
   ; enter : AC' = double x
   ;
   ; exit  : success
   ;
   ;            HL = ilogb(x)
   ;            carry reset
   ;
   ;         fail if x == 0
   ;
   ;            HL = INT_MIN
   ;            carry set, errno set
   ;
   ; uses  : af, hl
   
   exx
   ld a,l                      ; biased exponent
   or a
   exx
   jr z, error                 ; if x == 0
   
   sub $80                     ; subtract bias
   ld l,a
   sbc a,a
   ld h,a
   
   dec hl
   ret

error:

   call error_erange_zc
   
   ld h,$80                    ; hl = INT_MIN = $8000
   ret
