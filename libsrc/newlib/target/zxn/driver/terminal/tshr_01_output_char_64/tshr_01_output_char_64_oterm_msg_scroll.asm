SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_64_oterm_msg_scroll

EXTERN l_offset_ix_de, asm0_tshr_scroll_wc_up_pix

tshr_01_output_char_64_oterm_msg_scroll:

   ;   enter  :   c = number of rows to scroll
   ;   can use:  af, bc, de, hl
   ;
   ;   Scroll the window upward 'C' character rows.
   
   ld hl,16
   call l_offset_ix_de         ; hl = window.rect *
   
   push hl
   
   ld a,c
   add a,a
   add a,a
   add a,a
   
   ld e,a                      ; e = number of pixel rows to scroll upward
   ld l,0
   
   ex (sp),ix                  ; ix = window.rect *
   call asm0_tshr_scroll_wc_up_pix
   
   pop ix
   ret
