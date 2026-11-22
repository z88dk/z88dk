
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix8u

EXTERN am48_dfix16u, error_erange_mc

am48_dfix8u:

   ; double to 8-bit unsigned integer (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = AC (AC saved in EXX set)
   ;
   ;         success
   ;
   ;            L = (unsigned int)(x)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            L = char_max or char_min
   ;            carry set, errno set
   ;
   ; notes : FIX(1.5)=    1=  $0001
   ;         FIX(-1.5)=  -1=  $FFFF
   ;         FIX(0.5)=    0=  $0000
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   ; not doing special version for char

   call am48_dfix16u
   jr c, uint_overflow
   
   ; check for 8-bit overflow

   ld a,h
   or a
   ret z
   
   call error_erange_mc

   ret p
   
   ld l,$80
   ret

uint_overflow:

   ld l,h
   ret
