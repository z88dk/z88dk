; uchar __FASTCALL__ *zx_py2aaddr(uchar ycoord)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_py2aaddr
PUBLIC _zx_py2aaddr
EXTERN HRG_LineStart

.zx_py2aaddr
._zx_py2aaddr

   ld a,l
   rra
   rra
   rra
   and $1f
   ld b,a
IF FORlambda
   ld hl,8319
ELSE
   ld hl,HRG_LineStart+2+32768
ENDIF
   jr z,zrow
IF FORlambda
   ld de,33
ELSE
   ld de,35
ENDIF
.rloop
   add hl,de
   djnz rloop
.zrow
   
   ret
