
INCLUDE "config_private.inc"

IF __CLIB_OPT_FASTCOPY & $c0

   SECTION smc_clib
   SECTION smc_l

ELSE

   SECTION code_clib
   SECTION code_l

ENDIF

PUBLIC l_fast_memcpy
PUBLIC l_fast_ldir, l_fast_ldir_0

IF __CLIB_OPT_FASTCOPY & $c0

   PUBLIC l_fast_memcpy_smc

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_FASTCOPY & $40
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; library can use self-modifying code
   
defc l_fast_memcpy = l_fast_memcpy_smc

; call to this subroutine is faster
; than raw ldir if number of loops >= 19

l_fast_memcpy_smc:

   ; enter : hl = void *src
   ;         de = void *dst
   ;         bc = size_t n > 0
   ;
   ; exit  : hl = src + n
   ;         de = dst + n
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   ld a,$10
   sub c
   and $0f
   add a,a
   ld (joffset+1),a

joffset:

   jr l_fast_ldir_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; call to this subroutine is faster
; than raw ldir if number of loops >= 25

l_fast_memcpy:

   ; enter : hl = void *src
   ;         de = void *dst
   ;         bc = size_t n >= 16
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

   ;; fall through to l_fast_ldir_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; call directly into this loop is faster
; than raw ldir if number of loops >= 8

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF (__CLIB_OPT_FASTCOPY & $c0) = $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; call to this subroutine is faster
; than raw ldir if number of loops >= 19

l_fast_memcpy_smc:

   ; enter : hl = void *src
   ;         de = void *dst
   ;         bc = size_t n > 0
   ;
   ; exit  : hl = src + n
   ;         de = dst + n
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   ld a,$10
   sub c
   and $0f
   add a,a
   sub 49
   ld (joffset+1),a

joffset:

   jr l_fast_ldir_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
