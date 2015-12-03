
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_recv_input_raw_eat_ws
PUBLIC __stdio_recv_input_raw_eat_ws_repeat

EXTERN asm_isspace, __stdio_recv_input_raw_eatc

; ALL HIGH LEVEL STDIO INPUT PASSES THROUGH __STDIO_RECV_INPUT_RAW_*
; EXCEPT FOR VFSCANF.  THIS ENSURES STREAM STATE IS CORRECTLY MAINTAINED

__stdio_recv_input_raw_eat_ws_repeat:

   ; Driver consumes all whitespace from the stream, as qualified by isspace()
   ; C11 specifies no error can occur while eating whitespace so no status is returned to caller
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         bc'= number of chars consumed from stream in last(!!) operation
   ;          a = next unconsumed char (0 on error, 255 on eof)
   ;         stream state set appropriately (error / eof)
   ;
   ; note  : de unaffected

   ld bc,$ffff
   call __stdio_recv_input_raw_eat_ws
   
   call asm_isspace 
   ret c
     
   jr __stdio_recv_input_raw_eat_ws_repeat


__stdio_recv_input_raw_eat_ws:

   ; Driver consumes whitespace from the stream, as qualified by isspace()
   ;
   ; enter : ix = FILE *
   ;         bc = max_length
   ;
   ; exit  : ix = FILE *
   ;         bc'= number of chars consumed from stream in this operation
   ;          a = next unconsumed char (0 on error, 255 on eof)
   ;         stream state set appropriately (error / eof)

   ld hl,asm_isspace
   
   push bc
   exx
   pop hl
   
   call __stdio_recv_input_raw_eatc

   exx
   ret
