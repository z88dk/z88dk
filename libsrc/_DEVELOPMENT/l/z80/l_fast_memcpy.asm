
SECTION code_l

PUBLIC l_fast_memcpy

EXTERN l_fast_ldir_0

; call to this subroutine is faster
; than ldir if number of loops >= 38
; than asm_memcpy if number of loops >= 23

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

   ld a,c
   and $0f

try_8:

   cp 8
   jr c, try_4
   sub 8
   
   ldi
   ldi
   ldi
   ldi
   
   ldi
   ldi
   ldi
   ldi

try_4:

   cp 4
   jr c, try_2
   sub 4
   
   ldi
   ldi
   ldi
   ldi

try_2:

   cp 2
   jr c, try_1
   sub 2
   
   ldi
   ldi

try_1:

   jp z, l_fast_ldir_0
   
   ldi
   jp l_fast_ldir_0
