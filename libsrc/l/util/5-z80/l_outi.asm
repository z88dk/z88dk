INCLUDE "config_private.inc"

IF !__CPU_RABBIT__

IF (__CLIB_OPT_UNROLL & 0xc0)
   SECTION smc_clib
   SECTION smc_l
ELSE
   SECTION code_clib
   SECTION code_l
ENDIF

PUBLIC l_outi

IF __SMS

   EXTERN asm_SMSlib_outi_block
   defc   l_outi = asm_SMSlib_outi_block

   ; other outi entries defined in asm_SMSlib_outi_block

ELSE

PUBLIC l_outi_256
PUBLIC l_outi_128
PUBLIC l_outi_64
PUBLIC l_outi_32
PUBLIC l_outi_16
PUBLIC l_outi_8
PUBLIC l_outi_4
PUBLIC l_outi_2
PUBLIC l_outi_1 

defc l_outi_32 = l_outi_64 + 64
defc l_outi_16 = l_outi_32 + 32
defc l_outi_8  = l_outi_16 + 16
defc l_outi_4  = l_outi_8  +  8
defc l_outi_2  = l_outi_4  +  4
defc l_outi_1  = l_outi_2  +  2

l_outi_256:

   call l_outi_128

l_outi_128:

   call l_outi_64

IF (__CLIB_OPT_UNROLL & 0xc0)

   jp l_outi_64

sub_14:

   or a
   jp z, l_outi_256

   otir
   ret

PUBLIC l_outi_loop_smc

l_outi_loop_smc:

   ld a,b
   
   cp 14
   jp c, sub_14
   
   add a,a
   call c, l_outi_128
   
   add a,a
   call c, l_outi_64
   
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

l_outi_64:

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

   outi
   outi
   outi
   outi
   outi
   outi
   outi
   outi

l_outi:

   ret

ENDIF
ENDIF
