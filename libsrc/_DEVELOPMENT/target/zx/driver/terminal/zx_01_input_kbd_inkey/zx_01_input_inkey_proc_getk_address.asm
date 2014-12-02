
SECTION seg_code_fcntl

PUBLIC zx_01_input_inkey_proc_getk_address

EXTERN l_offset_ix_de

zx_01_input_inkey_proc_getk_address:

   ; return & getk_state
   
   ld hl,25
   jp l_offset_ix_de           ; hl = & getk_state
