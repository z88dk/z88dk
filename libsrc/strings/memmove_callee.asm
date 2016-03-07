; void __CALLEE__ *memmove_callee(void *s1, void *s2, uint n)
; copy n chars from s2 to s1, overlap safe
; 01.2007 aralbrec

SECTION code_clib
PUBLIC memmove_callee
PUBLIC _memmove_callee
PUBLIC ASMDISP_MEMMOVE_CALLEE

.memmove_callee
._memmove_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ; enter : bc = uint n
   ;         de = void *s2
   ;         hl = void *s1
   ; exit  : hl = void *s1
   ; uses  : af, bc, de, hl
   
.asmentry

   ld a,b
   or c
   ret z
   
   ; Because of the possibility of overlap between
   ; dst and src, we have two scenarios:
   ; 1 - (dst<src) in which case must ldir
   ; 2 - (dst>src) in which case must lddr from end
   
   ld a,h
   cp d
   jr c, must_ldir
   jr nz, must_lddr
   ld a,l
   cp e
   jr c, must_ldir
   ret z                     ; don't bother if dst=src

.must_lddr

   push hl
   dec bc
   add hl,bc
   ex de,hl
   add hl,bc
   inc bc
   lddr
   pop hl
   ret

.must_ldir

   push hl
   ex de,hl
   ldir
   pop hl
   ret

DEFC ASMDISP_MEMMOVE_CALLEE = # asmentry - memmove_callee
