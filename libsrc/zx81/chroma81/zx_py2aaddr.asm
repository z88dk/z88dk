; uchar __FASTCALL__ *zx_py2aaddr(uchar ycoord)
; aralbrec 06.2007

XLIB zx_py2aaddr
XREF HRG_LineStart

.zx_py2aaddr

   ld a,l
   rra
   rra
   rra
   and $1f
   ld b,a
   ld hl,HRG_LineStart+2+32768
   jr z,zrow
   ld de,35
.rloop
   add hl,de
   djnz rloop
.zrow
   
   ret
