
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_32_32x32

EXTERN l_fast_mulu_40_32x8, l0_fast_mulu_40_32x8, l0_fast_mulu_32_24x8
EXTERN l_fast_mulu_32_16x16, l_fast_mulu_32_24x16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   EXTERN error_mulu_overflow_mc

ELSE

   EXTERN l_fast_mulu_16_8x8, l_fast_mulu_24_16x8
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_fast_mulu_32_32x32:

   ; unsigned multiplication of two 32-bit
   ; multiplicands into a 32-bit product
   ;
   ; error reported on overflow
   ;
   ; enter : dehl = 32-bit multiplicand
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit product
   ;            carry reset
   ;
   ;         unsigned overflow (LIA-1 enabled only)
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', (ixh if loop unrolling disabled, ix if LIA-1 disabled)

   ; try to reduce multiplication
   
   inc d
   dec d
   jr nz, _24b_x               ; 25 to 32 bits

   inc e
   dec e
   jr nz, _16b_x               ; 17 to 24 bits

   inc h
   dec h
   jr nz, _8b_x                ; 9 to 16 bits

_8_32:

   ; dehl' * l

   ld a,l
   exx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call l_fast_mulu_40_32x8
   
   or a
   ret z

overflow:
   
   call error_mulu_overflow_mc
   
   ld e,l
   ld d,h
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jp l_fast_mulu_40_32x8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_24b_x:

   ; dehl * dehl'

   exx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   inc d
   dec d
   jr nz, overflow             ; 24b_24b = 48b

   inc e
   dec e
   jr nz, overflow             ; 24b_16b = 40b
   
   inc h
   dec h
   jr nz, overflow             ; 24b_8b = 32b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   inc d
   dec d
   jr nz, _24b_24b
   
   inc e
   dec e
   jr nz, _24b_16b
   
   inc h
   dec h
   jr nz, _24b_8b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_32_8:

   ; l * dehl'
   
   ld a,l
   exx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   call l0_fast_mulu_40_32x8
   
   or a
   ret z

   jr overflow

ELSE

   jp l0_fast_mulu_40_32x8

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_16b_x:

   ; ehl * dehl'

   exx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   inc d
   dec d
   jr nz, overflow             ; 16b_24b = 40b
   
   inc e
   dec e
   jr nz, overflow             ; 16b_16b = 32b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   inc d
   dec d
   jr nz, _16b_24b
   
   inc e
   dec e
   jr nz, _16b_16b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   inc h
   dec h
   jr nz, _24_16

_24_8:

   ; ehl' * l

   ld a,l
   exx
   
   jp l0_fast_mulu_32_24x8

_8b_x:

   ; hl * dehl'

   exx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   inc d
   dec d
   jr nz, overflow             ; 8b_24b = 32b

ELSE

   inc d
   dec d
   jr nz, _8b_24b

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   inc e
   dec e
   jr z, _16_16
   
   ; hl' * ehl

   exx

_24_16:

   ; ehl' * hl

   push hl
   exx
   pop bc
   
   jp l_fast_mulu_32_24x16

_16_16:

   ; hl' * hl
   
   push hl
   exx
   pop de
   
   jp l_fast_mulu_32_16x16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF (__CLIB_OPT_IMATH_FAST & $80) = 0

_24b_24b:

   ; dehl' * dehl

   push hl                     ; save L
   
   exx
   
   push de                     ; save d

   call _24b_16b
   
   exx
   
   pop de
   ld e,d
   pop hl
   
   call l_fast_mulu_16_8x8
   
   ld a,l
   
   exx
   
   add a,d
   ld d,a
   
   or a
   ret

_24b_16b:

   ; dehl' * ehl
   
   exx

_16b_24b:

   ; ehl' * dehl

   push de
   push hl
   
   exx
   
   ld c,h
   ld b,e
   
   ld a,l
   
   pop hl
   pop de
   
   push af
   
   call l_fast_mulu_32_24x16
   
   ld d,e
   ld e,h
   ld h,l
   ld l,0
   
   exx
   
   pop af
   
   call l0_fast_mulu_40_32x8
   
   push de
   push hl
   
   exx
   
   pop bc
   add hl,bc
   
   ex de,hl
   
   pop bc
   adc hl,bc

   ex de,hl
   
   or a
   ret

_8b_24b:

   ; hl' * dehl

   exx
   
_24b_8b:

   ; dehl' * hl

   ld a,l
   
   exx
   
   push de
   push hl
   
   call l0_fast_mulu_40_32x8

   exx
   
   ld a,h
   
   pop hl
   pop de
   
   call l0_fast_mulu_32_24x8

   ld d,e
   ld e,h
   ld h,l
   ld l,0
   
   push de
   push hl
   
   exx
   
   pop bc
   add hl,bc
   
   ex de,hl
   
   pop bc
   adc hl,bc
   
   ex de,hl
   
   or a
   ret

_16b_16b:

   ; ehl' * ehl

   push hl
   
   exx
   
   pop bc
   push hl
   
   call l_fast_mulu_32_24x16
   
   exx
   
   pop hl
   
   call l_fast_mulu_24_16x8
   
   push hl
   
   exx
   
   pop bc
   
   ex de,hl
   add hl,bc
   ex de,hl
   
   or a
   ret

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
