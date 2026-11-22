
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_oterm_msg_pscroll

EXTERN console_01_output_char_proc_putchar_scroll

zx_01_output_fzx_oterm_msg_pscroll:

;   * OTERM_MSG_PSCROLL
;
;     enter  :  hl = number of pixels to scroll
;     exit   :  hl = actual number if pixels scrolled
;               else carry set if screen clears
;     can use:  af, bc, de, hl
;
;     Scroll the window upward at least hl pixels

   ld de,7
   add hl,de                   ; round up to next char
   
   ld a,l
   and $f8
   ld l,a
   
   push hl                     ; save actual number of pixels to scroll
   
   srl h
   rra
   
   srl h
   rra
   
   srl h
   rra                         ; a = number of chars to scroll
   
   call console_01_output_char_proc_putchar_scroll
   
   pop hl                      ; hl = actual number of pixels scrolled
   ret
