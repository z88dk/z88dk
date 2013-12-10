
XLIB error_einval_zc

INCLUDE "../../errorno.inc"
LIB errno_zc


   pop hl

error_einval_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=EINVAL

   ld hl,__EINVAL
   jp errno_zc
