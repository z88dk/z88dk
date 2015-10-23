
SECTION code_l

PUBLIC l_fast_memcpy

EXTERN l_fast_ldir_0

; call to this subroutine is faster
; than memcpy if number of loops >= 38

l_fast_memcpy:

   ; enter : hl = void *src
   ;         de = void *dst
   ;         bc = size_t n > 0
   ;
   ; exit  : hl = src + n
   ;         de = dst + n
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl
   
   push hl
   
   ld a,$10
   sub c
   and $0f
   add a,a
   
   add a,l_fast_ldir_0 % 256
   ld l,a
   adc a,l_fast_ldir_0 / 256
   ld h,a

   ex (sp),hl
   
   ld a,c
   srl b
   rra
   srl b
   rra
   srl b
   rra
   srl b
   rra
   ld c,a
   
   ret
