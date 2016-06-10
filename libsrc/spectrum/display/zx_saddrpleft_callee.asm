; uchar __CALLEE__ *zx_saddrpleft_callee(void *pixeladdr, uchar *mask)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddrpleft_callee
PUBLIC _zx_saddrpleft_callee
PUBLIC ASMDISP_ZX_SADDRPLEFT_CALLEE

.zx_saddrpleft_callee
._zx_saddrpleft_callee

   pop af
   pop hl
   pop de
   push af

.asmentry

; enter: de = valid screen address
;        hl = uchar *mask
; exit : carry = moved off screen
;        hl = new screen address left one pixel
;        *mask = new bitmask left one pixel
; uses : af, hl, de

   rlc (hl)
   ex de,hl
   ret nc

   ld a,l
   dec l
   and $1f
   ret nz

   scf 
   ret

DEFC ASMDISP_ZX_SADDRPLEFT_CALLEE = # asmentry - zx_saddrpleft_callee
