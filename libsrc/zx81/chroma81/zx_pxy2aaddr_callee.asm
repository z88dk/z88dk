; uchar __CALLEE__ *zx_pxy2aaddr_callee(uchar xcoord, uchar ycoord)
; Stefano, 2014.12

XLIB zx_pxy2aaddr_callee
XDEF ASMDISP_ZX_PXY2AADDR_CALLEE
XREF HRG_LineStart

.zx_pxy2aaddr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,e
   
.asmentry

   ; enter:  l = pix X 0..255
   ;         h = pix Y 0..191
   ; exit : hl = screen address
   ; uses : af, hl, +bc, +de

   ld a,l
   rra
   rra
   rra
   and $1f
   ld c,a
   ld a,h
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
   ld  e,c
   add hl,de
   
   ret

DEFC ASMDISP_ZX_PXY2AADDR_CALLEE = # asmentry - zx_pxy2aaddr_callee
