INCLUDE "config_private.inc"

IF (__CLIB_OPT_UNROLL & 0xc0)
   SECTION smc_clib
   SECTION smc_l
ELSE
   SECTION code_clib
   SECTION code_l
ENDIF

PUBLIC l_ldd

PUBLIC l_ldd_256
PUBLIC l_ldd_128
PUBLIC l_ldd_64
PUBLIC l_ldd_32
PUBLIC l_ldd_16
PUBLIC l_ldd_8
PUBLIC l_ldd_4
PUBLIC l_ldd_2
PUBLIC l_ldd_1

defc l_ldd_32 = l_ldd_64 + 64
defc l_ldd_16 = l_ldd_32 + 32
defc l_ldd_8  = l_ldd_16 + 16
defc l_ldd_4  = l_ldd_8  +  8
defc l_ldd_2  = l_ldd_4  +  4
defc l_ldd_1  = l_ldd_2  +  2

l_ldd_256:

   call l_ldd_128

l_ldd_128:

   call l_ldd_64

IF (__CLIB_OPT_UNROLL & 0xc0)

   jp l_ldd_64

sub_14:

   or a
   ret z
   
   lddr
   ret

PUBLIC l_ldd_loop_smc
PUBLIC l_ldd_loop_smc_0
PUBLIC l_ldd_loop_smc_small

l_ldd_loop_smc:

   ld a,b
   
   or a
   jp z, fine

l_ldd_loop_smc_0:
coarse:

   call l_ldd_256
   
   dec a
   jp nz, coarse

l_ldd_loop_smc_small:
fine:

   ld a,c
   
   cp 14
   jp c, sub_14
   
   add a,a
   call c, l_ldd_128
   
   add a,a
   call c, l_ldd_64

   ret z

enter_loop:

   xor a
   sub c
   and $3f
   add a,a
   
   ld (active_jr + 1),a

active_jr:

   jr 0

ENDIF

l_ldd_64:

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd
   ldd

l_ldd:

   ret
