
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_recv_input_raw_getc

EXTERN STDIO_MSG_GETC
EXTERN l_jpix, error_zc, error_mc

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
   jp nz, error_zc             ; if stream in error state
   
   bit 4,(ix+3)
   jp nz, error_mc             ; if stream in eof state
   
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
   
   ret nc                      ; if no error
   
   ; stream error or eof ?
   
   inc l
   dec l
   jr z, stream_error
   
   ; eof
   
   set 4,(ix+3)                ; set stream state to eof
   ret

stream_error:

   set 3,(ix+3)                ; set stream state to error
   ret
