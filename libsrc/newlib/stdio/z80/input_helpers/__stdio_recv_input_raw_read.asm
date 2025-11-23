
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_recv_input_raw_read

EXTERN STDIO_MSG_READ
EXTERN l_jpix

; ALL HIGH LEVEL STDIO INPUT PASSES THROUGH __STDIO_RECV_INPUT_RAW_*
; EXCEPT FOR VFSCANF.  THIS ENSURES STREAM STATE IS CORRECTLY MAINTAINED

__stdio_recv_input_raw_read:

   ; Driver reads a block of bytes from the stream and writes to buffer
   ;
   ; enter : ix = FILE *
   ;         bc = max_length = number of chars to read from stream
   ;         de = void *buffer = destination buffer
   ; 
   ; exit  : ix = FILE *
   ;         de = void *buffer_ptr = address of byte following last written
   ;          a = on error: 0 for stream error, -1 for eof
   ;         bc'= number of bytes successfully read from stream
   ;
   ;         carry set on error or eof, stream state set appropriately

   bit 3,(ix+3)
   jr nz, immediate_stream_error
   
   bit 4,(ix+3)
   jr nz, immediate_eof_error

   ld a,b
   or c
   jr z, len_zero              ; if length is zero
   
   bit 0,(ix+4)
   jr z, _no_ungetc_rd         ; if no unget char available

   ld a,(ix+6)                 ; a = unget char
   res 0,(ix+4)                ; consume the unget char

   ld (de),a                   ; write char to buffer
   inc de
   dec bc
   
   ld a,b
   or c
   jr z, len_one   

   call _no_ungetc_rd
   
   exx
   inc bc
   exx
   
   ret

_no_ungetc_rd:

   ld a,STDIO_MSG_READ
   
   push bc
   exx
   pop hl
   
   call l_jpix
   
   ld a,l
   exx

   ret nc                      ; if no error
   
   ; stream error or eof ?
   
   inc a
   dec a
   jr z, stream_error
   
   ; eof
   
   set 4,(ix+3)                ; set stream state to eof
   ret

stream_error:

   set 3,(ix+3)                ; set stream state to error
   ret

len_one:

   exx
   ld bc,1
   exx
   
   ret

immediate_stream_error:

   xor a
   scf
   jr len_zero

immediate_eof_error:

   ld a,$ff
   scf

len_zero:

   exx
   ld bc,0
   exx
   
   ret
