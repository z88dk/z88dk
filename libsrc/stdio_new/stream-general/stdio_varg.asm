; stdio_varg
; 05.2008 aralbrec

XLIB stdio_varg

; initial code for variable argument functions that computes the
; address of the top of the argument list and retrieves the first
; argument there
;
; exit : hl = & top of argument list
;        de = first 16-bit argument on argument list

.stdio_varg

   inc a
   add a,a
   inc a
   ld l,a
   ld h,0
   add hl,sp
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   
   ret
