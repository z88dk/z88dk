
XLIB error_enomem_zc

INCLUDE "../../errorno.inc"
LIB errno_zc


   pop hl
   
error_enomem_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOMEM

   ld hl,__ENOMEM
   jp errno_zc
