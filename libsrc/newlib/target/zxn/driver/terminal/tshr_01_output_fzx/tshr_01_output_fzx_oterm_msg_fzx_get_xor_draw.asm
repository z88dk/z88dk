SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_fzx_oterm_msg_fzx_get_xor_draw

EXTERN __fzx_tshr_draw_xor

tshr_01_output_fzx_oterm_msg_fzx_get_xor_draw:

;   * OTERM_MSG_FZX_GET_XOR_DRAW
;
;     exit   : bc = & fzx xor draw function
;     can use: af, bc, de, hl

   ld bc,__fzx_tshr_draw_xor
   ret
