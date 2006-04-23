; uchar __FASTCALL__ inp(uint port)
; 09.2005 aralbrec

XLIB inp

.inp
   ld c,l
   ld b,h
   in l,(c)
   ret
