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

   pop ix
   
   ld a,l         ; counter
   pop hl
   pop de
 
   and 31 
   jr z, done
   
   ld b,a
   ld a,e         ; primary = dahl
   
.loop

   add hl,hl
   rla
   rl d
   djnz loop
   
   ld e,a

.done

   jp (ix)
