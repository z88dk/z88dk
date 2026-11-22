SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_oterm_msg_cls

EXTERN l_offset_ix_de, asm_sms_cls_wc

sms_01_output_terminal_oterm_msg_cls:

   ; clear the window
   ;
   ; can use : af, bc, de, hl
   
   ld hl,16
   call l_offset_ix_de         ; hl = window.rect *
   
   push hl

   ld l,(ix+26)
   ld h,(ix+27)                ; hl = background colour
   
   ex (sp),ix                  ; ix = window.rect *
   call asm_sms_cls_wc
   
   pop ix
   ret
