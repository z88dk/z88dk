
SECTION code_driver
SECTION code_driver_character_output

PUBLIC character_00_output_stdio_msg_writ

EXTERN OCHAR_MSG_PUTC_BIN, l_jpix

character_00_output_stdio_msg_writ:

   ; BC' = length > 0
   ; HL' = void *buffer = byte source
   ; HL  = length > 0
   ;
   ; return:
   ;
   ; HL'= void *buffer + num bytes written
   ; HL = number of bytes successfully output
   ; carry set if error
   
   exx
   ld de,0                     ; de'= byte count

writ_loop:

   ld a,(hl)
   exx
   
   ld c,a
   
   ld a,OCHAR_MSG_PUTC_BIN
   call l_jpix
   
   exx
   jr c, writ_end
   
   inc de                      ; byte count++
   
   cpi                         ; hl++, bc--
   jp pe, writ_loop

writ_end:

   push de
   exx

   pop hl                      ; hl = num chars to output
   ret
