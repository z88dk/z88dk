SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_hbios1_stdio_msg_flsh

EXTERN __BF_CIOINIT
EXTERN asm_hbios
EXTERN console_01_input_stdio_msg_flsh

rc_01_input_hbios1_stdio_msg_flsh:
 
   ; get rid of any pending chars in the hbios1 buffer
   ld bc,__BF_CIOINIT<<8|0x01
   ld de,0xffff
   call asm_hbios

   jp console_01_input_stdio_msg_flsh
