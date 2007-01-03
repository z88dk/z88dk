; char *strrchr(char *s, char c)
; return ptr to last occurrence of c in s
; 04.2001 dom

; exit :     found : hl = ptr in s
;        not found : hl = 0
; uses : asm : af, de, hl
;          c : af, bc, de, hl

XLIB strrchr
XDEF ASMDISP_STRRCHR

.strrchr

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   ; c = char c
   ; de = char *s

.asmentry

   ld hl,0
   dec de
   
.loop

   inc de
   ld a,(de)
   or a
   ret z
   
   cp c
   jp nz, loop
   
   ld l,e
   ld h,d
   jp loop

DEFC ASMDISP_STRRCHR = asmentry - strrchr
