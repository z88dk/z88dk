; int __FASTCALL__ strlen(char *s)
; return length of s
; 12.2006 aralbrec

XLIB strlen
XDEF ASMDISP_STRLEN

; A funky version that's quicker than the
; usual implementation for lengths > 1

; enter: hl = char *s
; exit : hl = length
; uses : af, bc, hl

.strlen

   xor a
   ld c,a
   ld b,a
   cpir
   ld hl,$ffff
   sbc hl,bc
   ret

DEFC ASMDISP_STRLEN = 0
