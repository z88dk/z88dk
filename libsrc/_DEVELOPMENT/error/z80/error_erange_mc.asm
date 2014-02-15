
XLIB error_erange_mc
XDEF error_mulu_overflow_mc

LIB errno_mc

   pop hl
   
error_erange_mc:
error_mulu_overflow_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=ERANGE

   ld hl,__ERANGE
   jp errno_mc
