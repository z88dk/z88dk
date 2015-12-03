
SECTION code_driver
SECTION code_driver_character_input

PUBLIC character_00_input_stdio_msg_seek

EXTERN STDIO_MSG_GETC, STDIO_SEEK_CUR
EXTERN l_decu_dehl, l_jpix, error_lzc, error_lznc

character_00_input_stdio_msg_seek:

   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return:
   ;
   ; DEHL = updated file position
   ; carry set on error (file position out of range)
   ; 
   ; note: stdio stages with buffers must flush first when
   ; this message is received.

   exx

   ld a,c
   
   cp STDIO_SEEK_CUR
   jp nz, error_lznc           ; if not seeking forward do nothing
   
   bit 7,d
   jp nz, error_lznc           ; if negative offset do nothing

seek_loop:

   ; dehl = number of chars remaining to consume
   
   ld a,d
   or e
   or h
   or l
   ret z                       ; if done
   
   call l_decu_dehl

   push de
   push hl
   
   ld a,STDIO_MSG_GETC
   call l_jpix
   
   pop hl
   pop de
   jr nc, seek_loop            ; if no error
   
   jp error_lzc                ; if driver error
