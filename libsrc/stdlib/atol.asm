; long __FASTCALL__ atol(char *s)
; 12.2006 aralbrec

XLIB atol
LIB strtol

.atol

   push hl
   ld hl,0
   push hl
   ld l,10
   push hl
   call strtol
   pop bc
   pop bc
   pop bc
   ret
