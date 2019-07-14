;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)
;
;       aralbrec 01/2007
;       shifts are faster than doubling and ex with de/hl


                SECTION   code_crt0_sccz80
PUBLIC l_long_asl


; Shift primary left by secondary
;
; Primary is on the stack, and is 32 bits long therefore we need only
; concern ourselves with l (secondary) as our counter

.l_long_asl

   pop bc 
   ld a,l         ; counter
   pop hl
   pop de
   push bc
 
   and 31 
   ret z
   
   ld b,a
   
.loop

   add hl,hl
   ld  a,e
   rla
   ld  e,a
   ld  a,d 
   rla
   ld  d,a
   dec b
   jp  nz,loop
   
   ld e,a

.done
   ret

