; char *strstr(char *s, char *w)
; return ptr to first occurrence of string w in s
; 01.2007 aralbrec

; exit :     found : hl = ptr in s, NC flag set
;        not found : hl = 0, C flag set
; uses : af, de, hl

XLIB strstr
XDEF ASMDISP_STRSTR

.strstr

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   ; de = char *s
   ; hl = char *w

.asmentry

   dec de
   
.loop1

   inc de
   ld a,(de)
   cp (hl)
   jr z, maybe
   or a
   jp nz, loop1
   
.fail

   ld l,a
   ld h,a
   scf
   ret
   
.maybe

   push hl                   ; save char *w
   push de                   ; save char *s

   ex de,hl

.loop2

   ld a,(de)
   or a
   jr z, match
   inc de
   
   cp (hl)
   inc hl
   jp z, loop2
   
   pop de
   pop hl
   jp loop1
   
.match

   pop hl
   pop de
   ret

DEFC ASMDISP_STRSTR = asmentry - strstr
