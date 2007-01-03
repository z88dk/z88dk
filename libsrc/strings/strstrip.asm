; char *strstrip(char *s, char c)
; remove occurences of leading char c from string s
; 01.2007 aralbrec

; exit : hl = char *s
; uses : af, bc, de, hl

XLIB strstrip
XDEF ASMDISP_STRSTRIP

.strstrip

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   ld a,e

.asmentry

   ;  a = unwanted char c
   ; hl = char *s
   
   ld e,l
   ld d,h

.skip

   cp (hl)
   inc hl
   jp z, skip
   dec hl

   ; the case where there are no unwanted chars is common...
   
   ld a,l
   cp e
   jr nz, copy
   ld a,h
   cp d
   jr nz, copy
   
   ex de,hl
   ret

.copy

   push de
   
.copyloop

   ld a,(hl)
   ldi
   or a
   jp nz, copyloop
   
   pop hl
   ret

DEFC ASMDISP_STRSTRIP = asmentry - strstrip
