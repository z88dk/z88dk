
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_oterm_msg_cls

EXTERN asm_zx_cls_wc, l_offset_ix_de

zx_01_output_fzx_oterm_msg_cls:

   ; clear the window
   ;
   ; can use : af, bc, de, hl
   
   ld hl,16
   call l_offset_ix_de         ; hl = window.rect *
   
   push hl
   ld l,(ix+52)                ; l = foreground colour
   ld (ix+54),l                ; copy foreground colour to background colour
   
   ex (sp),ix                  ; ix = window.rect *
   call asm_zx_cls_wc
   
   pop ix
   ret
