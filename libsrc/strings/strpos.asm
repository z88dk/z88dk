; int strpos(char *s, char c)
; find index of first occurrence of c in s
; 01.2007 aralbrec

; exit : hl = index in s
; uses : asm : af, bc, hl
;          c : af, bc, de, hl

XLIB strpos
XDEF ASMDISP_STRPOS

.strpos

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   ; e = char c
   ; bc = char *s

.asmentry

   ld hl,0
   
.loop

   ld a,(bc)
   cp e                      ; putting this first allows
   ret z                     ;  search for end of string
   
   or a
   jr z, fail

   inc bc
   inc hl
   jp loop


.fail

   dec a
   ld l,a
   ld h,a
   ret

DEFC ASMDISP_STRPOS = asmentry - strpos
