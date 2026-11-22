
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_verify_input

EXTERN error_eacces_mc, error_mc
EXTERN asm1_fflush_unlocked

__stdio_verify_input:

   ; Verify input from stream is possible
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if problem with hl=-1
   ;
   ; uses  : all except bc, de, (hl on no error), ix
   
   ; check for stream error and read mode
   
   ld a,(ix+3)                 ; a = state_flags_0
   
   and $58                     ; keep read, error, eof flags
   cp $40                      ; compare R=1, ERR=0, EOF=0
   
   jr nz, errors
   
   ; check if last operation on stream was a write
   
   bit 1,(ix+4)
   ret nz                      ; if last operation was read
   
   push bc
   push de
   push hl
   
   call asm1_fflush_unlocked
   
   pop hl
   pop de
   pop bc

   ld (ix+4),$02               ; clear unget char, change last op to read

   or a
   ret

errors:

   and $18
   jp nz, error_mc             ; if ERR or EOF, do not alter errno

   jp error_eacces_mc          ; if not open for reading
