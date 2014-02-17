
XLIB l_muls_8_8x8

LIB l_mulu_16_8x8, error_mulu_overflow_mc

l_muls_8_8x8:

   ; signed multiply of two 8-bit numbers
   ;
   ; error reported on overflow
   ;
   ; enter : l = 8-bit signed number
   ;         e = 8-bit signed number
   ;
   ; exit  : d = 0
   ;
   ;         success
   ;
   ;            hl = sign extended 8-bit product
   ;            carry reset
   ;
   ;         signed overflow
   ;
   ;            hl = sign extended CHAR_MIN or CHAR_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, de, hl
   
   ; determine sign of result
   
   ld a,l
   xor e
   push af
   
   ; make multiplicands positive
   
   bit 7,l
   jr z, ok_0
   
   ld a,l
   neg
   ld l,a

ok_0:

   bit 7,e
   jr z, ok_1
   
   ld a,e
   neg 
   ld e,a

ok_1:

   ; mutliply and check for overflow
   
   call l_mulu_16_8x8
   
   inc h
   dec h
   jr nz, unsigned_overflow
   
   bit 7,l
   jr nz, signed_overflow

   ; correct sign of result
   
   pop af
   ret p

   ld a,l   
   neg
   ld l,a
   dec h
   
   ret

unsigned_overflow:
signed_overflow:

   call error_mulu_overflow_mc
   
   ; hl = $ffff
   ; stack = sign of result
   
   pop af
   scf

   ld l,$80
   ret m                       ; return CHAR_MIN
   
   inc h
   dec l                       ; return CHAR_MAX
   
   ret
