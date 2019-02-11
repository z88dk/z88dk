; uint __CALLEE__ zx_saddr2px_callee(void *pixeladdr, uchar mask)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_saddr2px_callee
PUBLIC _zx_saddr2px_callee
PUBLIC ASMDISP_ZX_SADDR2PX_CALLEE

.zx_saddr2px_callee
._zx_saddr2px_callee

   pop hl
   pop de
   ld a,e
   ex (sp),hl

.asmentry

; enter :  a = mask
;         hl = screen address
; exit  : hl = pixel X 0..255
; uses  : af, hl

   ld h,0
   sla l
   sla l
   sla l
   
   or a
   ret z
   dec l

.maskloop

   inc l
   rla
   jp nc, maskloop
   
   ret

DEFC ASMDISP_ZX_SADDR2PX_CALLEE = # asmentry - zx_saddr2px_callee
