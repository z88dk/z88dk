; char *strrstrip(char *s, char c)
; remove any occurrences of c at the end of s
; 01.2007 aralbrec

; exit : hl = char *s
; uses : asm : af, de
;          c : af, bc, de, hl

XLIB strrstrip
XDEF ASMDISP_STRRSTRIP

.strrstrip

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   ; c = char c
   ; hl = char *s

.asmentry
   
   push hl
   
.failloop

   ld a,(hl)
   or a
   jr z, fail
   inc hl
   
   cp c
   jp nz, failloop
   
   ld e,l
   ld d,h
   dec de
   
.passloop

   ld a,(hl)
   or a
   jr z,pass
   inc hl
   
   cp c
   jr nz, failloop
   jp passloop

.pass

   xor a
   ld (de),a
   
.fail

   pop hl
   ret

DEFC ASMDISP_STRRSTRIP = asmentry - strrstrip
