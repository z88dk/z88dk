; char __FASTCALL__ *strrev(char *s)
; reverse string
; 12.2006 aralbrec

; enter: hl = char *s
; exit : hl = char *s
; uses : af, bc, de

SECTION code_clib
PUBLIC strrev
PUBLIC _strrev
PUBLIC ASMDISP_STRREV
EXTERN     rcmx_cpir


.strrev
._strrev

   xor a
   ld c,a
   ld b,a
   ld e,l
   ld d,h
   cpir                      ; find end of string
   dec hl
   dec hl
   
   push de

   ld a,b                    ; bc = -(bc/2)-1
   sra a
   rr c
   cpl
   ld b,a
   ld a,c
   cpl
   ld c,a

   or b
   jr z, exit
   
.revlp

   ld a,(de)
   ldi
   dec hl
   ld (hl),a
   dec hl
   jp pe, revlp
   
.exit

   pop hl
   ret

DEFC ASMDISP_STRREV = 0
