SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_64_oterm_msg_cls

EXTERN asm_tshr_cls_wc_pix, l_offset_ix_de

tshr_01_output_char_64_oterm_msg_cls:

   ; clear the window
   ;
   ; can use : af, bc, de, hl
   
   ld hl,16
   call l_offset_ix_de         ; hl = window.rect *
   
   push hl
   
   ld l,0
   
   ex (sp),ix                  ; ix = window.rect *
   call asm_tshr_cls_wc_pix
   
   pop ix
   ret
