
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_sdcc

PUBLIC __mulsuchar_callee, __mulsuchar_callee_0

__mulsuchar_callee:

   ; 8-bit mixed multiply
   ;
   ; enter : stack = multiplicand (signed byte), multiplicand (byte), ret
   ;
   ; exit  : hl = 16-bit product

   pop af
   pop hl
   push af
   
   ld e,h
   
   ; must promote to 16-bits

__mulsuchar_callee_0:

   ld h,0
   
   ld a,e
   add a,a
   sbc a,a
   ld d,a
   
IF __CLIB_OPT_IMATH <= 50

   EXTERN l_mulu_16_16x16

   jp l_mulu_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_muls_16_16x16
   
   jp l_fast_muls_16_16x16

ENDIF
