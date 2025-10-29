
SECTION code_driver
SECTION code_driver_character_output

PUBLIC character_00_output_stdio_msg_putc

EXTERN OCHAR_MSG_PUTC_BIN, l_jpix

character_00_output_stdio_msg_putc:

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
   
   ld a,OCHAR_MSG_PUTC_BIN
   call l_jpix
   
   exx
   
   ret c
   
   cpi                         ; hl++, bc--
   jp pe, putc_loop

   ret
