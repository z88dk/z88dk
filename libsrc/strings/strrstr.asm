; char *strrstr(char *s, char *w)
; return ptr to last occurrence of string w in s
; 01.2007 aralbrec

; exit :     found : hl = ptr in s, NC flag set
;        not found : hl = 0, C flag set
; uses : asm : af, bc, hl
;          c : af, bc, de, hl

XLIB strrstr
XDEF ASMDISP_STRRSTR

.strrstr

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   ; de = char *w
   ; hl = char *s

.asmentry

   ; first find end of s and len(s)
   
   xor a
   ld c,a
   ld b,a
   cpir
   dec hl
   
   ; de = char *w
   ; hl = terminating '\0' in char *s
   ; bc = -(length of char *s)-1
   
   ; degenerate case
   
   ld a,(de)
   or a
   ret z
   
.loop1

   dec hl
   inc bc
   
   ld a,b
   or c
   jr z, nomatch

   ld a,(de)
   cp (hl)
   jp nz, loop1

   push hl                   ; save char *s
   push de                   ; save char *w

.loop2

   inc de
   ld a,(de)
   or a
   jr z, match
   inc hl
   cp (hl)
   jp z, loop2
   
   pop de
   pop hl
   jp loop1

.nomatch

   ld l,c
   ld h,b
   scf
   ret

.match

   pop de
   pop hl
   ret

DEFC ASMDISP_STRRSTR = asmentry - strrstr
