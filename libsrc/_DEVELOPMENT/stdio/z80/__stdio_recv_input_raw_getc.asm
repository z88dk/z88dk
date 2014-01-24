
XLIB __stdio_recv_input_raw_getc

LIB l_jpix

; ALL HIGH LEVEL STDIO INPUT PASSES THROUGH __STDIO_RECV_INPUT_RAW_*
; EXCEPT FOR VFSCANF.  THIS ENSURES STREAM STATE IS CORRECTLY MAINTAINED

__stdio_recv_input_raw_getc:

   ; Driver reads a single char and returns it
   ;
   ; enter : ix = FILE *
   ; 
   ; exit  : if success
   ;
   ;            hl = char
   ;            carry reset
   ;
   ;         if EOF
   ;
   ;            hl = -1
   ;            carry set
   ;
   ;         if stream error
   ;
   ;            hl = 0
   ;            carry set

   bit 3,(ix+3)
   jr nz, immediate_stream_error
   
   bit 4,(ix+3)
   jr nz, immediate_eof_error
   
   bit 0,(ix+4)
   jr z, _no_ungetc_gc         ; if no unget char available

   xor a
   ld h,a
   ld l,(ix+6)                 ; hl = unget char
   
   res 0,(ix+4)                ; consume the unget char
   ret

_no_ungetc_gc:

   ld a,STDIO_MSG_GETC
   call l_jpix
   
   ret

immediate_stream_error:

   ld hl,0
   scf
   ret

immediate_eof_error:

   ld hl,-1
   scf
   ret
