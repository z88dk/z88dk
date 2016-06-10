; uchar __CALLEE__ *zx_saddrpright_callee(void *pixeladdr, uchar *mask)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddrpright_callee
PUBLIC _zx_saddrpright_callee
PUBLIC ASMDISP_ZX_SADDRPRIGHT_CALLEE

.zx_saddrpright_callee
._zx_saddrpright_callee

   pop af
   pop hl
   pop de
   push af
   
.asmentry

; enter: de = valid screen address
;        hl = uchar *mask
; exit : carry = moved off screen
;        hl = new screen address right one pixel
;        *mask = new mask right one pixel
; uses : af, hl, de

   rrc (hl)
   ex de,hl
   ret nc
   
   inc l
   ld a,l
   and $1f
   ret nz
   scf
   
   ret

DEFC ASMDISP_ZX_SADDRPRIGHT_CALLEE = # asmentry - zx_saddrpright_callee
