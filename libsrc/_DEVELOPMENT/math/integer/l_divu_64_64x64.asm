
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_divu_64_64x64

   ; unsigned 64-bit division
   ;
   ; enter :      +------------------------
   ;              | +15 
   ;              | ...  divisor (8 bytes)
   ;              | + 8 
   ;         ix = |------------------------
   ;              | + 7
   ;              | ...  dividend (8 bytes)
   ;              | + 0
   ;              +------------------------
   ;
   ; exit  : success
   ;
   ;                 +------------------------
   ;                 | +15 
   ;                 | ...  divisor (8 bytes)
   ;                 | + 8 
   ;            ix = |------------------------
   ;                 | + 7
   ;                 | ...  quotient (8 bytes)
   ;                 | + 0
   ;                 +------------------------
   ;
   ;            dehl' dehl = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;                 +------------------------
   ;                 | +15 
   ;                 | ...  divisor (8 bytes)
   ;                 | + 8 
   ;            ix = |------------------------
   ;                 | + 7
   ;                 | ...  quotient(8 bytes)
   ;                 | + 0  0xffffffff
   ;                 +------------------------
   ;
   ;            dehl' dehl = dividend
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divu_64_64x64

   defc l_divu_64_64x64 = l_small_divu_64_64x64

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divu_64_64x64
   
   defc l_divu_64_64x64 = l_fast_divu_64_64x64

ENDIF
