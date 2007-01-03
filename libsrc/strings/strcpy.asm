; char *strcpy(char *s, char *ct)
; copy string ct to s including '\0'

; exit : hl = char *s
; uses : af, bc, de, hl

XLIB strcpy
XDEF ASMDISP_STRCPY

.strcpy

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc

   ; de = dest char*s
   ; hl = source char*ct

.asmentry

   push de

.loop

   ld a,(hl)
   ldi
   or a
   jp nz, loop
   
   pop hl
   ret

DEFC ASMDISP_STRCPY = asmentry - strcpy
