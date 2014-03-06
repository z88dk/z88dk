
XLIB error_efbig_zc

LIB errno_zc

   pop hl
   
error_efbig_zc:

   ; set hl=-1
   ; set carry flag
   ; set errno=EFBIG

   ld hl,__EFBIG
   jp errno_zc
