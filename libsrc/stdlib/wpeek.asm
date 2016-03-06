; uint __FASTCALL__ wpeek(void *addr)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC wpeek
PUBLIC _wpeek

.wpeek
._wpeek

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret
