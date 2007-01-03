; void *memchr(char *s, char c, int n)
; return ptr to first occurence of c in s
; 12.1999 djm, 12.2006 aralbrec

; exit :    found  : hl = ptr in char *s, Z flag set
;        not found : hl = 0, NZ flag set
; uses : asm : f, bc, hl
;          c : af, bc, de, hl

XLIB memchr
XDEF ASMDISP_MEMCHR

.memchr

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   ld a,e
   
   ;  a = char c
   ; bc = int n
   ; hl = char *s

.asmentry
   
   cpir
   dec hl
   ret z
   
   ld h,b
   ld l,c
   ret
   
DEFC ASMDISP_MEMCHR = asmentry - memchr
