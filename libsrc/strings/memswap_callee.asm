; void __CALLEE__ *memswap_callee(void *s1, void *s2, uint n)
; swap N bytes in the two memory regions
; 01.2007 aralbrec

SECTION code_clib
PUBLIC memswap_callee
PUBLIC _memswap_callee
PUBLIC ASMDISP_MEMSWAP_CALLEE

.memswap_callee
._memswap_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ; enter : bc = uint n
   ;         de = void *s2
   ;         hl = void *s1
   ; uses  : af, bc, de, hl
   
.asmentry

   ld a,b
   or c
   ret z

   push hl

.loop
   
   ld a,(de)
   ldi
   dec hl
   ld (hl),a
   inc hl
   jp pe, loop

   pop hl
   ret

DEFC ASMDISP_MEMSWAP_CALLEE = # asmentry - memswap_callee
