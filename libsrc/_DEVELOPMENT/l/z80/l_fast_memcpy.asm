
INCLUDE "clib_cfg.asm"

SECTION code_l

PUBLIC l_fast_memcpy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_FASTCOPY & $40
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; self-modifying code allowed
   
EXTERN l_fast_memcpy_smc
   
defc l_fast_memcpy = l_fast_memcpy_smc

   ; enter : hl = void *src
   ;         de = void *dst
   ;         bc = size_t n > 0
   ;
   ; exit  : hl = src + n
   ;         de = dst + n
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EXTERN l_fast_ldir_0

; number of loops should be at least ~16 to beat memcpy
; and higher to beat naked ldir due to call overhead

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
   jp c, try_4
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
   jp c, try_2
   sub 4
   
   ldi
   ldi
   ldi
   ldi

try_2:

   cp 2
   jp c, try_1
   sub 2
   
   ldi
   ldi

try_1:

   jp z, l_fast_ldir_0
   
   ldi
   jp l_fast_ldir_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
