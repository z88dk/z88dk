
XLIB error_edom_mc
XDEF error_divide_by_zero_mc

LIB errno_mc

   pop hl
   
error_edom_mc:
error_divide_by_zero_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=EDOM

   ld hl,__EDOM
   jp errno_mc
