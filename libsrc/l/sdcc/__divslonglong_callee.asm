
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __divslonglong_callee

EXTERN l_divs_64_64x64, __sdcc_exit_div_64_callee

__divslonglong_callee:

   ; signed 64-bit division
   ;
   ; enter :         +------------------------
   ;                 | +19 
   ;                 | ...  divisor (8 bytes)
   ;                 | +12 
   ;         stack = |------------------------
   ;                 | +11
   ;                 | ...  dividend (8 bytes)
   ;                 | +4
   ;                 |------------------------
   ;                 | +3
   ;                 | +2   quotient *
   ;                 |------------------------
   ;                 | +1
   ;                 | +0   return address
   ;                 +------------------------
   ;
   ; exit  : stack repaired
   ;
   ;         success
   ;
   ;            *quotient = quotient
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            *quotient = LONLONG_MAX or LONGLONG_MIN
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

   push ix
   
   ld ix,6
   add ix,sp                   ; ix = & dividend
   
   call l_divs_64_64x64
   
   jp __sdcc_exit_div_64_callee  ; store result
