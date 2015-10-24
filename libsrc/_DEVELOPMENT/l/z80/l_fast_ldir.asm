
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_FASTCOPY & $c0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION smc_l

;; self-modifying code allowed

; call to this subroutine is faster
; than raw ldir if number of loops >= 16

PUBLIC l_fast_memcpy_smc

l_fast_memcpy_smc:

   ld a,$10
   sub c
   and $0f
   inc a
   add a,a
   ld (joffset+1),a

joffset:

   jr l_fast_ldir_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_l

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; call directly into this loop is faster
; than raw ldir if number of loops >= 6

PUBLIC l_fast_ldir, l_fast_ldir_0

l_fast_ldir_0:

   ldi
   ldi
   ldi
   ldi
   
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   
   ldi
   ldi
   ldi
   ldi

   jp pe, l_fast_ldir_0

l_fast_ldir:

   ret
