; uchar __FASTCALL__ inp(uint port)
; 09.2005 aralbrec

XLIB inp
XDEF ASMDISP_INP

.inp
   ld c,l
   ld b,h
   in l,(c)
   ld h,0
   ret

DEFC ASMDISP_INP = 0
