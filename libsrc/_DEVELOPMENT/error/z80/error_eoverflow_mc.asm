
INCLUDE "../../errorno.inc"

XLIB error_eoverflow_mc

LIB errno_mc

   pop hl
   
error_eoverflow_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=EOVERFLOW

   ld hl,__EOVERFLOW
   jp errno_mc
