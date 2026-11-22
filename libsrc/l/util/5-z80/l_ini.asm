INCLUDE "config_private.inc"

IF !__CPU_RABBIT__

IF (__CLIB_OPT_UNROLL & 0xc0)
   SECTION smc_clib
   SECTION smc_l
ELSE
   SECTION code_clib
   SECTION code_l
ENDIF

PUBLIC l_ini

PUBLIC l_ini_512
PUBLIC l_ini_256
PUBLIC l_ini_128
PUBLIC l_ini_64
PUBLIC l_ini_32
PUBLIC l_ini_16
PUBLIC l_ini_8
PUBLIC l_ini_4
PUBLIC l_ini_2
PUBLIC l_ini_1 

defc l_ini_32 = l_ini_64 + 64
defc l_ini_16 = l_ini_32 + 32
defc l_ini_8  = l_ini_16 + 16
defc l_ini_4  = l_ini_8  +  8
defc l_ini_2  = l_ini_4  +  4
defc l_ini_1  = l_ini_2  +  2

l_ini_512:

   call l_ini_256

l_ini_256:

   call l_ini_128

l_ini_128:

   call l_ini_64

IF (__CLIB_OPT_UNROLL & 0xc0)

   jp l_ini_64

sub_14:

   or a
   jp z, l_ini_256

   inir
   ret

PUBLIC l_ini_loop_smc

l_ini_loop_smc:

   ld a,b
   
   cp 14
   jp c, sub_14
   
   add a,a
   call c, l_ini_128
   
   add a,a
   call c, l_ini_64
   
   ret z

enter_loop:

   xor a
   sub b
   and $3f
   add a,a
   
   ld (active_jr + 1),a

active_jr:

   jr 0

ENDIF

l_ini_64:

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

   ini
   ini
   ini
   ini
   ini
   ini
   ini
   ini

l_ini:

   ret
ENDIF
