; void __CALLEE__ *memset_callee(void *s, char c, uint n)
; write c into first n chars of s
; 04.2001 djm, 12.2006 aralbrec

SECTION code_clib
PUBLIC memset_callee
PUBLIC _memset_callee
PUBLIC ASMDISP_MEMSET_CALLEE

.memset_callee
._memset_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ; enter : hl = void *s
   ;          e = char c
   ;         bc = uint n
   ; exit  : hl = void *s
   ; uses  : af, bc, de
   
.asmentry

   ld a,b
   or c
   ret z
   
   ld (hl),e
   dec bc
   ld a,b
   or c
   ret z
   
   push hl
   ld e,l
   ld d,h
   inc de
   ldir
   pop hl

   ret

DEFC ASMDISP_MEMSET_CALLEE = # asmentry - memset_callee
