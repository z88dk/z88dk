INCLUDE "config_private.inc"

IF (__CLIB_OPT_UNROLL & 0xc0)
   SECTION smc_clib
   SECTION smc_l
ELSE
   SECTION code_clib
   SECTION code_l
ENDIF

PUBLIC l_ldi

PUBLIC l_ldi_256
PUBLIC l_ldi_128
PUBLIC l_ldi_64
PUBLIC l_ldi_32
PUBLIC l_ldi_16
PUBLIC l_ldi_8
PUBLIC l_ldi_4
PUBLIC l_ldi_2
PUBLIC l_ldi_1

defc l_ldi_32 = l_ldi_64 + 64
defc l_ldi_16 = l_ldi_32 + 32
defc l_ldi_8  = l_ldi_16 + 16
defc l_ldi_4  = l_ldi_8  +  8
defc l_ldi_2  = l_ldi_4  +  4
defc l_ldi_1  = l_ldi_2  +  2

l_ldi_256:

   call l_ldi_128

l_ldi_128:

   call l_ldi_64

IF (__CLIB_OPT_UNROLL & 0xc0)

   jp l_ldi_64

sub_14:

   or a
   ret z
   
   ldir
   ret

PUBLIC l_ldi_loop_smc
PUBLIC l_ldi_loop_smc_0
PUBLIC l_ldi_loop_smc_small

l_ldi_loop_smc:

   ld a,b
   
   or a
   jp z, fine

l_ldi_loop_smc_0:
coarse:

   call l_ldi_256
   
   dec a
   jp nz, coarse

l_ldi_loop_smc_small:
fine:

   ld a,c
   
   cp 14
   jp c, sub_14
   
   add a,a
   call c, l_ldi_128
   
   add a,a
   call c, l_ldi_64

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

l_ldi_64:

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi

l_ldi:

   ret
