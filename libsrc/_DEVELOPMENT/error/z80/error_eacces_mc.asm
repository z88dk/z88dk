
XLIB error_eacces_mc

LIB errno_mc

   pop hl
   
error_eacces_mc:

   ; set hl=-1
   ; set carry flag
   ; set errno=EACCES

   ld hl,__EACCES
   jp errno_mc
