
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dfix8

EXTERN am48_dfix16, error_erange_mc

am48_dfix8:

   ; double to 8-bit integer (truncates)
   ;
   ; enter : AC' = double x
   ;
   ; exit  : AC' = AC (AC saved in EXX set)
   ;
   ;         success
   ;
   ;            L = (int)(x)
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

   call am48_dfix16
   jr c, int_overflow
   
   ; check for 8-bit overflow
   
   ld a,l
   add a,a
   sbc a,a
   xor h

   ret z                       ; if 8-bit sign extension matches
   
   ld a,h
   or a
   
   call error_erange_mc
   
   ld l,$7f
   ret p                       ; if positive
   
   inc l
   ret

int_overflow:

   ld l,h
   ret
   