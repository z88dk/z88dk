INCLUDE "config_private.inc"

IF !__CPU_RABBIT__

SECTION code_clib
SECTION code_l

PUBLIC l_ini_loop

IF __CLIB_OPT_UNROLL & 0x80

EXTERN l_ini_loop_smc
defc   l_ini_loop = l_ini_loop_smc

ELSE

EXTERN l_ini
EXTERN l_ini_256, l_ini_128
EXTERN l_ini_64, l_ini_32, l_ini_16

l_ini_loop:

   ld a,b

   cp 16
   jp c, sub_16

   rla
   call c, l_ini_128

   rla
   call c, l_ini_64
   
   rla
   call c, l_ini_32

   rla
   call c, l_ini_16

   ret z

   inir
   ret
   
sub_16:

   or a
   jp z, l_ini_256

   inir
   ret

ENDIF
ENDIF
