INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l

PUBLIC l_ldi_loop
PUBLIC l_ldi_loop_0
PUBLIC l_ldi_loop_small

IF (__CLIB_OPT_UNROLL & 0x80)

EXTERN l_ldi_loop_smc
defc   l_ldi_loop = l_ldi_loop_smc

EXTERN l_ldi_loop_smc_0
defc   l_ldi_loop_0 = l_ldi_loop_smc_0

EXTERN l_ldi_loop_smc_small
defc   l_ldi_loop_small = l_ldi_loop_smc_small

ELSE

EXTERN l_ldi
EXTERN l_ldi_256, l_ldi_128
EXTERN l_ldi_64, l_ldi_32, l_ldi_16

l_ldi_loop:

   ld a,b
   
   or a
   jp z, fine

l_ldi_loop_0:
coarse:

   call l_ldi_256
   
   dec a
   jp nz, coarse

l_ldi_loop_small:
fine:

   ld a,c

   cp 16
   jp c, sub_16

   add a,a
   call c, l_ldi_128

   add a,a
   call c, l_ldi_64
   
   add a,a
   call c, l_ldi_32

   add a,a
   call c, l_ldi_16

   ret z
   
   ldir
   ret

sub_16:

   or a
   ret z

   ldir
   ret

ENDIF
