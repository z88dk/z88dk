INCLUDE "../../errorno.inc"

XLIB error_edom_zc
XDEF error_divide_by_zero_zc

LIB errno_zc

   pop hl
   
error_edom_zc:
error_divide_by_zero_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=EDOM

   ld hl,__EDOM
   jp errno_zc
