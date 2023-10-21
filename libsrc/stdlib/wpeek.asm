; uint __FASTCALL__ wpeek(void *addr)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC wpeek
PUBLIC _wpeek
PUBLIC wpeek_fastcall
PUBLIC _wpeek_fastcall

.wpeek
._wpeek
    pop de
    pop hl
    push hl
    push de
.wpeek_fastcall
._wpeek_fastcall

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret
