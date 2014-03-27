
XLIB error_enotsup_zc

XREF __ENOTSUP

LIB errno_zc

   pop hl
   
error_enotsup_zc:

   ; set hl=0
   ; set carry flag
   ; set errno=ENOTSUP

   ld hl,__ENOTSUP
   jp errno_zc
