
SECTION code_l

PUBLIC l_fast_ldir, l_fast_ldir_0

; call to this subroutine is faster
; than ldir if number of loops >= 8

l_fast_ldir_0:

   ldi
   ldi
   ldi
   ldi
   
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   
   ldi
   ldi
   ldi
   ldi

   jp pe, l_fast_ldir_0

l_fast_ldir:

   ret
