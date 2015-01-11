
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC console_01_input_stdio_msg_read

EXTERN console_01_input_proc_getc

console_01_input_stdio_msg_read:

   ; DE'= void *buffer = byte destination
   ; BC'= max_length > 0
   ; HL = max_length > 0
   ;
   ; return:
   ;
   ; BC = number of bytes successfully read
   ; DE'= void *buffer_ptr = address of byte following last written
   ; 
   ; carry set on error with HL=0 for stream err, HL=-1 for eof

   exx

read_loop:

   ; bc = num chars remaining
   ; de = void *buffer

   ld a,b
   or c
   jr z, read_exit             ; if no more chars to read
   
   dec bc                      ; num chars to read -= 1
   
   call console_01_input_proc_getc  ; a = hl = char
   jr c, read_exit_error            ; if driver error

   ld (de),a                   ; write char to buffer
   inc de
   
   cp CHAR_LF
   jr nz, read_loop
   
read_exit:

   push bc

   exx
   
   pop bc                      ; bc = num chars remaining
   
   sbc hl,bc
   
   ld c,l
   ld b,h                      ; bc = num chars read
   
   ret

read_exit_error:

   push hl                     ; save driver error code
   push bc                     ; save num chars remaining - 1
   
   exx
   
   pop bc                      ; bc = remaining - 1
   
   sbc hl,bc                   ; hl = max_length - remaining + 1 - 1 (carry)
   
   ld c,l
   ld b,h                      ; bc = num chars read
   
   pop hl                      ; hl = driver error code
   
   scf
   ret
