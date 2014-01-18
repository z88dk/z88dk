
XLIB __stdio_recv_input_eat_ws
XDEF __stdio_recv_input_eat_ws_repeat

LIB asm_isspace, __stdio_recv_input_eatc

__stdio_recv_input_eat_ws_repeat:

   ; Driver consumes all whitespace from the stream, as qualified by isspace()
   ;
   ; enter : ix = FILE *
   ;         de'= number of chars read from stream so far
   ;         hl'= number of items assigned so far
   ;
   ; exit  : ix = FILE *
   ;         bc'= number of chars consumed from stream in last(!!) operation
   ;         de'= number of chars read from stream so far (updated)
   ;         hl'= number of items assigned so far
   ;          a = next unconsumed char (0 on error, 255 on eof)
   ;         carry set on error or eof, stream state set appropriately
   ;
   ; note  : de unaffected

   ld bc,$ffff
   call __stdio_recv_input_eat_ws
   
   call asm_isspace
   ret c
   
   jr __stdio_recv_input_eat_ws_repeat


__stdio_recv_input_eat_ws:

   ; Driver consumes whitespace from the stream, as qualified by isspace()
   ;
   ; enter : ix = FILE *
   ;         bc = max_length
   ;         de'= number of chars read from stream so far
   ;         hl'= number of items assigned so far
   ;
   ; exit  : ix = FILE *
   ;         bc'= number of chars consumed from stream in this operation
   ;         de'= number of chars read from stream so far (updated)
   ;         hl'= number of items assigned so far
   ;          a = next unconsumed char (0 on error, 255 on eof)
   ;         carry set on error or eof, stream state set appropriately

   ld hl,asm_isspace
   
   push bc
   exx
   pop bc
   
   call __stdio_recv_input_eatc

   exx
   ret
