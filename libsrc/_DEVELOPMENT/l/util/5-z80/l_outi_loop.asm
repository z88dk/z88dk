INCLUDE "config_private.inc"

IF !__CPU_RABBIT__

SECTION code_clib
SECTION code_l

PUBLIC l_outi_loop

IF __SMS

PUBLIC l_outi_loop_smc
defc   l_outi_loop_smc = l_outi_loop

;; smc not possible for SMS because the
;; SMS's outi block is too big

ENDIF

IF (__SMS = 0) && (__CLIB_OPT_UNROLL & 0x80)

EXTERN l_outi_loop_smc
defc   l_outi_loop = l_outi_loop_smc

ELSE

EXTERN l_outi
EXTERN l_outi_256, l_outi_128
EXTERN l_outi_64, l_outi_32, l_outi_16

l_outi_loop:

   ld a,b

   cp 16
   jp c, sub_16

   rla
   call c, l_outi_128

   rla
   call c, l_outi_64
   
   rla
   call c, l_outi_32

   rla
   call c, l_outi_16

   ret z

   otir
   ret
   
sub_16:

   or a
   jp z, l_outi_256

   otir
   ret

ENDIF
ENDIF
