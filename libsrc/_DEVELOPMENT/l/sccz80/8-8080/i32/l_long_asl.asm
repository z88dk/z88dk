;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)
;
;       aralbrec 01/2007
;       shifts are faster than doubling and ex with de/hl


SECTION code_clib
SECTION code_l_sccz80
PUBLIC l_long_asl
PUBLIC l_long_aslo


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

; Optimised version enters with dehl=long, count = a
.l_long_aslo
   and 31
   ret z

   ld b,a
IF __CPU_GBZ80__
   ld a,e    ;Primary = dahl
ENDIF

.loop
   add hl,hl
IF __CPU_GBZ80__
   rla
   rl d
ELSE
   ld a,e
   rla
   ld e,a
   ld a,d 
   rla
   ld d,a
ENDIF
   dec b
   jp  nz,loop
IF __CPU_GBZ80__
   ld e,a
ENDIF
   ret

