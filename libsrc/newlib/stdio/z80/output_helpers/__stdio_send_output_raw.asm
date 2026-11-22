
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_send_output_raw
PUBLIC __stdio_send_output_raw_chars, __stdio_send_output_raw_chars_unchecked
PUBLIC __stdio_send_output_raw_buffer, __stdio_send_output_raw_buffer_unchecked

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT
EXTERN l_jpix

; ALL HIGH LEVEL STDIO OUTPUT EXCEPT VFPRINTF PASSES THROUGH THESE FUNCTIONS
; A COMMON PATH ENSURES STREAM STATE IS UPDATED PROPERLY

__stdio_send_output_raw_chars:

   ; write char to output length times
   ;
   ; enter : ix  = FILE *
   ;          e  = char c
   ;         bc  = length (0 means no output)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = number of chars successfully output
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   ld a,b
   or c
   jr z, return_zero

__stdio_send_output_raw_chars_unchecked:

   ld a,STDIO_MSG_PUTC
   jr __stdio_send_output_raw

__stdio_send_output_raw_buffer:

   ; write buffer to stream
   ;
   ; enter : ix  = FILE *
   ;         hl  = char *buffer
   ;         bc  = length (0 means no output)
   ;
   ; exit  : ix  = FILE *
   ;         hl' = number of chars successfully output
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   ld a,b
   or c
   jr z, return_zero

__stdio_send_output_raw_buffer_unchecked:

   ld a,STDIO_MSG_WRIT
   
   ; fall through

__stdio_send_output_raw:

   ; write chars to stream
   ; all output from high level stdio except vfprintf passes through this function
   ;
   ; enter : ix  = FILE * 
   ;
   ;         if output repeated char
   ;
   ;            a = STDIO_MSG_PUTC
   ;           bc = length > 0
   ;            e = char
   ;
   ;         if output buffer
   ;
   ;            a = STDIO_MSG_WRIT
   ;           bc = length > 0
   ;           hl = void *buffer
   ;
   ; exit  : ix  = FILE *
   ;         hl' = number of chars successfully output on stream
   ;         error state of stream set if an error occurs
   ;         carry set indicates stream error
   ;
   ; uses  : possibly all except ix

   push bc
   exx
   pop hl
   
   call l_jpix
   
   exx
   ret nc                      ; if no error

error_detected:

   set 3,(ix+3)                ; set error state of stream
   ret

return_zero:

   exx
   ld hl,0
   exx
   
   ret
