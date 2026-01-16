
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_verify_output

EXTERN error_eacces_mc, error_mc
EXTERN asm1_fflush_unlocked

__stdio_verify_output:

   ; Verify output on stream is possible
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if problem with hl=-1
   ;
   ; uses  : all except bc, de, (hl on no error), ix
   
   ; check for stream error and write mode

   ld a,(ix+3)                 ; a = state_flags_0
   
   and $88                     ; keep write and error flags
   cp $80                      ; compare W=1 and ERR=0
   
   jr nz, errors
   
   ; check if last operation on stream was a read
   
   bit 1,(ix+4)
   ret z                       ; if last operation was write
   
   push bc
   push de
   push hl
   
   call asm1_fflush_unlocked
   
   pop hl
   pop de
   pop bc

   ld (ix+4),0                 ; set last operation to write
   
   or a
   ret

errors:

   and $08
   jp nz, error_mc             ; if ERR bit set, do not alter errno

   jp error_eacces_mc          ; if not open for writing
