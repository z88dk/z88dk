
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_recv_input_eat_ws
PUBLIC __stdio_recv_input_eat_ws_repeat

EXTERN asm_isspace, __stdio_recv_input_eatc

; ALL INPUT FOR VFSCANF PASSES THROUGH __STDIO_RECV_INPUT_*
; DE' IS USED TO TRACK NUMBER OF CHARS READ FROM STREAM
; HL' IS USED TO TRACK NUMBER OF ITEMS ASSIGNED
;
; OTHER HIGH LEVEL STDIO SHOULD USE __STDIO_RECV_INPUT_RAW_*

__stdio_recv_input_eat_ws_repeat:

   ; Driver consumes all whitespace from the stream, as qualified by isspace()
   ; C11 specifies no error can occur while eating whitespace so no status is returned to caller
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
   ;         stream state set appropriately (error / eof)
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
   ;         stream state set appropriately (error / eof)

   ld hl,asm_isspace
   
   push bc
   exx
   pop bc
   
   call __stdio_recv_input_eatc

   exx
   ret
