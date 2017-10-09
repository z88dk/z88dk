
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_4000_stdio_msg_writ

EXTERN vgl_01_output_4000_oterm_msg_printc_raw
EXTERN vgl_01_output_4000_refresh
EXTERN vgl_01_output_4000_set_cursor_coord


; By writing out whole strings at once we can safe some unneccessary cursor movements and LCD refreshes
;
; @FIXME: This is highly experimental!
;

vgl_01_output_4000_stdio_msg_writ:

   ; BC' = length > 0
   ; HL' = void *buffer = byte source
   ; HL  = length > 0
   ;
   ; return:
   ;
   ; HL'= void *buffer + num bytes written
   ; HL = number of bytes successfully output
   ; carry set if error

   push hl                     ; num chars to output
   
   exx

writ_loop:

   ld a,(hl)
   ;exx
   
   ld c,a
   
   ;ld a,OTERM_MSG_PUTC
   ;call l_jpix
   ; Directly put char
   call vgl_01_output_4000_oterm_msg_printc_raw
   
   ;exx
   
   cpi                         ; hl++, bc--
   jp pe, writ_loop

writ_end:

   exx
   
   ; Update cursor and refresh screen
   call vgl_01_output_4000_set_cursor_coord
   call vgl_01_output_4000_refresh
   
   pop hl                      ; hl = num chars to output
   
   or a
   ret
