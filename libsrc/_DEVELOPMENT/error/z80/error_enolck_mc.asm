INCLUDE "../../errorno.inc"

XLIB error_enolck_mc

LIB errno_mc

   pop hl
   
error_enolck_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=ENOLCK

   ld hl,__ENOLCK
   jp errno_mc
