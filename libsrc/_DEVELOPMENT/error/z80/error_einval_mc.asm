INCLUDE "../../errorno.inc"

XLIB error_einval_mc
LIB errno_mc

   pop hl

error_einval_mc:

   ; set hl=0
   ; set carry flag
   ; set errno=EINVAL

   ld hl,__EINVAL
   jp errno_mc
