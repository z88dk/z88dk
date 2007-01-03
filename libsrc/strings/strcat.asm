; char *strcat(char *s, char *ct)
; copy ct to end of s
; 12.2006 aralbrec

; exit : hl = char *s
; uses : af, bc, de, hl


XLIB strcat
XDEF ASMDISP_STRCAT

.strcat

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   ; de = source char *ct
   ; hl = dest char *s

.asmentry

   push hl                   ; save char *s
   
   ; first find end of char *s

   xor a
   ld c,a
   ld b,a
   cpir
   dec hl
   
   ; next copy char *ct to end of char *s
   
   ex de,hl
   
.loop

   ld a,(hl)
   ldi
   or a
   jp nz, loop
   
   pop hl                    ; return with hl = char *s
   ret

DEFC ASMDISP_STRCAT = asmentry - strcat
