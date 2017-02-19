
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_32_24x16

EXTERN l0_fast_mulu_32_24x8, l_fast_mulu_32_24x8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

EXTERN error_mulu_overflow_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_fast_mulu_32_24x16:

   ; unsigned multiplication of 24-bit and 16-bit
   ; multiplicands into a 32-bit product
   ;
   ; error reported on overflow
   ; 
   ; enter : ehl = 24-bit multiplicand
   ;          bc = 16-bit multiplicand
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
   
   ; uses  : af, bc, de, hl, (ixh if loop unrolling disabled)

   ; split into two multiplications

   ld d,c
   push hl
   push de                     ; save HLCE
   
   ld a,b
   call l0_fast_mulu_32_24x8        ; dehl = B * EHL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   inc d
   dec d
   jr nz, overflow_0

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; shift left 8 bits
   
   ld d,l
   ld l,h
   ld h,e
   ld e,a                      ; hlde = B * EHL << 8
   
   pop bc                      ; bc = CE
   ex (sp),hl                  ; hl = HL
   push de
   
   ld a,c
   ld e,b
   call l_fast_mulu_32_24x8         ; dehl = C * EHL

   ; add the two results
   
   pop bc
   add hl,bc
   
   ex de,hl
   
   pop bc
   adc hl,bc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
   
   jr c, overflow_1

ELSE

   or a

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ex de,hl
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

overflow_0:

   pop de
   pop hl
   
overflow_1:

   call error_mulu_overflow_mc
   
   ld e,l
   ld d,h
   
   ret

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
