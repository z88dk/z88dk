; char __CALLEE__ *ultoa_callee(char *s, unsigned long num)
; convert unsigned long to string and store in s
; 04.2007 aralbrec

PUBLIC ultoa_callee
PUBLIC _ultoa_callee
PUBLIC ASMDISP_ULTOA_CALLEE

EXTERN ltoa_callee, error_einval_zc
EXTERN LIBDISP_LTOA_CALLEE

.ultoa_callee
._ultoa_callee

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

.asmentry

   ld a,c
   or a
   jp z, error_einval_zc       ; divide by zero

   dec a
   jp z, error_einval_zc       ; radix = 1 makes no sense

   cp 36
   jp nc, error_einval_zc      ; max radix (37 - 1!)
   
   ld b,0
   jp ltoa_callee + LIBDISP_LTOA_CALLEE

defc ASMDISP_ULTOA_CALLEE = # asmentry - ultoa_callee
