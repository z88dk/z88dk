; uchar __CALLEE__ *zx_cyx2aaddr_callee(uchar row, uchar col)
; Stefano, 2014.12

XLIB zx_cyx2aaddr_callee
XDEF ASMDISP_ZX_CYX2AADDR_CALLEE
XREF HRG_LineStart

.zx_cyx2aaddr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,l
   ld l,e

.asmentry

   ; h = char Y 0..23
   ; l = char X 0..31

   ld c,l
   ld a,h
   and $1f
   ld b,a
   ld hl,HRG_LineStart+2+32768
   jr z,zrow
   ld de,35
.rloop
   add hl,de
   djnz rloop
.zrow
   ld  e,c
   add hl,de
   
   ret

DEFC ASMDISP_ZX_CYX2AADDR_CALLEE = # asmentry - zx_cyx2aaddr_callee
