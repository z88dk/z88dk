
XLIB error_enotsup_mc

LIB errno_mc

   pop hl
   
error_enotsup_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=ENOTSUP

   ld hl,__ENOTSUP
   jp errno_mc
