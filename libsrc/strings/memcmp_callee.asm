; int __CALLEE__ memcmp_callee(void *s1, void *s2, uint n)
; compare first n chars of s1 and s2
; 11.1999 djm, 12.2006 aralbrec

SECTION code_clib
PUBLIC memcmp_callee
PUBLIC _memcmp_callee
PUBLIC ASMDISP_MEMCMP_CALLEE
EXTERN     rcmx_cpi


.memcmp_callee
._memcmp_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ; enter : bc = uint n
   ;         de = void *s2
   ;         hl = void *s1
   ; exit  : if s==ct : hl = 0, Z flag set
   ;         if s<<ct : hl < 0, NC+NZ flag set
   ;         if s>>ct : hl > 0, C+NZ flag set
   ; uses : af, bc, de, hl

.asmentry

   ld a,b
   or c
   jr z, equal

.loop

   ld a,(de)
   inc de
   cpi
   jr nz, different
   jp pe, loop
   
.equal

   ld h,b
   ld l,c
   ret

.different

   dec hl
   cp (hl)
   ld h,$80
   ret nc
   dec h
   ret

DEFC ASMDISP_MEMCMP_CALLEE = # asmentry - memcmp_callee
