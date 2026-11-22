SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_oterm_msg_fzx_putc

EXTERN asm_fzx_putc

zx_01_output_fzx_oterm_msg_fzx_putc:

;   * OTERM_MSG_FZX_PUTC
;
;     enter  :  c = char to output
;              hl = struct fzx_state *
;     exit   : standard return value for asm_fzx_putc (a, carry)
;     can use: af, bc, de, hl

   push hl
   ex (sp),ix

   ex af,af'
   push af

   call asm_fzx_putc

   ex af,af'
   pop af
   ex af,af'

   pop ix
   ret
