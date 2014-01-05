INCLUDE "../../errorno.inc"

XLIB error_enomem_zc

LIB errno_zc

   pop hl
   pop hl
   
error_enomem_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOMEM

   ld hl,__ENOMEM
   jp errno_zc
