
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_oterm_msg_scroll

EXTERN l_offset_ix_de, asm_zx_scroll_wc_up_noexx

zx_01_output_char_32_oterm_msg_scroll:

   ;   enter  :   c = number of rows to scroll
   ;   can use:  af, bc, de, hl
   ;
   ;   Scroll the window upward 'C' character rows.
   
   ld hl,16
   call l_offset_ix_de         ; hl = window.rect *
   
   push hl
   
   ld e,c
   ld d,0                      ; de = number of rows to scroll upward
   
   ld l,(ix+25)                ; l = background colour
   
   ex (sp),ix                  ; ix = window.rect *
   call asm_zx_scroll_wc_up_noexx
   
   pop ix
   ret
