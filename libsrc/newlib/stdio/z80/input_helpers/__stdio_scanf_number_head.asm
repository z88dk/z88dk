
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_number_head

EXTERN __stdio_recv_input_eat_ws_repeat, __stdio_recv_input_eatc

__stdio_scanf_number_head:

   ; enter : bc = field width (0 means use default)
   ;         de = void *buffer
   ;          a = char buffer_len
   ;         hl = int (*qualify)(char c)
   ;
   ; exit  : de = void *buffer_ptr (pointing to char following last written)
   ;         carry if stream error
   
   ; CONSUME LEADING WHITESPACE

   push bc
   push af
   push hl

   call __stdio_recv_input_eat_ws_repeat
   
   ; de = void *buffer
   ; stack = width>0, buffer_len, qualify

   ; READ STREAM DIGITS INTO BUFFER
   
   pop hl                      ; hl = qualify state machine

   pop bc
   ld c,b
   ld b,0                      ; bc = number of digits to write to buffer
   
   exx
   
   pop bc                      ; bc = max field width > 0
   
   ld a,b
   or c
   jr nz, width_specified      ; if field width was supplied
   
   dec bc                      ; otherwise consume all digits from stream
   
width_specified:

   call __stdio_recv_input_eatc
   
   exx
   ret c                       ; if stream error or eof with no chars available
   
   xor a
   ld (de),a                   ; zero terminate the buffer
   
   ret
