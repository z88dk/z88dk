INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_ldd_loop
PUBLIC l_ldd_loop_0
PUBLIC l_ldd_loop_small

IF (__CLIB_OPT_UNROLL & 0x80)

EXTERN l_ldd_loop_smc
defc   l_ldd_loop = l_ldd_loop_smc

EXTERN l_ldd_loop_smc_0
defc   l_ldd_loop_0 = l_ldd_loop_smc_0

EXTERN l_ldd_loop_smc_small
defc   l_ldd_loop_small = l_ldd_loop_smc_small

ELSE

EXTERN l_ldd
EXTERN l_ldd_256, l_ldd_128
EXTERN l_ldd_64, l_ldd_32, l_ldd_16

l_ldd_loop:

   ld a,b
   
   or a
   jp z, fine

l_ldd_loop_0:
coarse:

   call l_ldd_256
   
   dec a
   jp nz, coarse

l_ldd_loop_small:
fine:

   ld a,c

   cp 16
   jp c, sub_16

   add a,a
   call c, l_ldd_128

   add a,a
   call c, l_ldd_64
   
   add a,a
   call c, l_ldd_32

   add a,a
   call c, l_ldd_16

   ret z
   
   lddr
   ret

sub_16:

   or a
   ret z

   lddr
   ret

ENDIF
