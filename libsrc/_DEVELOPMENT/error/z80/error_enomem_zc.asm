
XLIB error_enomem_zc

XREF __ENOMEM

LIB errno_zc

   pop hl
   pop hl
   pop hl
   
error_enomem_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOMEM

   ld hl,__ENOMEM
   jp errno_zc
