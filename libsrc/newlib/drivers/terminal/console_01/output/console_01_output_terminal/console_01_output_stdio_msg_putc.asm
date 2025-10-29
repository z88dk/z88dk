
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_stdio_msg_putc

EXTERN OTERM_MSG_PUTC, l_jpix

console_01_output_stdio_msg_putc:

   ;  E' = char
   ; BC' = number > 0
   ; HL  = number > 0
   ; 
   ; return:
   ;
   ; HL = number of bytes successfully output
   ; carry set if error

   exx
   ld hl,0

putc_loop:

   ld a,e
   exx
   
   ld c,a                      ; c = char
   
   ld a,OTERM_MSG_PUTC
   call l_jpix
   
   exx
   
   cpi                         ; hl++, bc--
   jp pe, putc_loop

   or a
   ret
