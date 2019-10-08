;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)
;
;       djm 7/5/99
;       This version is called when the optimizer has had a look at
;       the code
;
;       aralbrec 01/2007
;       switched to shifts from slower doubling using de/hl

                SECTION   code_crt0_sccz80
PUBLIC l_long_aslo

; Shift primary left by secondary
;
; Primary is on the stack, and is 32 bits long therefore we need only
; concern ourselves with l (secondary) as our counter
;
; For optimized version we enter with the word in dehl and the shift
; counter in a

.l_long_aslo
   and 31
   ret z
   
   ld b,a
   ld a,e         ; primary = dahl

.loop

   add hl,hl
   rla
   rl d
   djnz loop
   
   ld e,a
   ret
