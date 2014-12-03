
SECTION seg_code_fcntl

PUBLIC console_01_output_stdio_msg_writ

EXTERN OTERM_MSG_PUTC, l_jpix

console_01_output_stdio_msg_writ:

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
   ld de,0

writ_loop:

   ld a,(hl)
   exx
   
   ld c,a
   
   ld a,OTERM_MSG_PUTC
   call l_jpix
   
   exx
   
   inc de
   
   cpi                         ; hl++, bc--
   jp pe, writ_loop

writ_end:

   push de
   exx
   pop hl                      ; hl = num chars successfully output
   
   or a
   ret
