; char __FASTCALL__ *strrev(char *s)
; reverse string
; 12.2006 aralbrec

; enter: hl = char *s
; exit : hl = char *s
; uses : af, bc, de, af'

XLIB strrev
XDEF ASMDISP_STRREV

.strrev

   xor a
   ld c,a
   ld b,a
   ld e,l
   ld d,h
   cpir                      ; find end of string
   dec hl
   dec hl
   sra b
   rr c
      
   push de
   
.revlp

   inc bc
   ld a,b
   or c
   jr z, exit
   
   ld a,(hl)
   ex af,af
   ld a,(de)
   ld (hl),a
   ex af,af
   ld (de),a
   dec hl
   inc de
   jp revlp
   
.exit

   pop hl
   ret

DEFC ASMDISP_STRREV = 0
