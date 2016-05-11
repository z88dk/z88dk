; uint __CALLEE__ utoa_callee(uint num, char *s, uchar radix)
; convert unsigned int to string and store in s, return size of string
; 06.2008 aralbrec
; redone to be more in line with modern versions of this function

SECTION code_clib
PUBLIC utoa_callee
PUBLIC _utoa_callee
PUBLIC ASMDISP_UTOA_CALLEE

EXTERN itoa_callee, stdio_error_zc
EXTERN LIBDISP_ITOA_CALLEE

.utoa_callee
._utoa_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

.asmentry

   ld a,c
   or a
   jp z, stdio_error_zc        ; divide by zero
   
   dec a
   jp z, stdio_error_zc        ; radix = 1 makes no sense
   
   cp 36
   jp nc, stdio_error_zc       ; max radix (37 - 1!)
   
   ld b,0
   jp itoa_callee + LIBDISP_ITOA_CALLEE

defc ASMDISP_UTOA_CALLEE = # asmentry - utoa_callee
