
XLIB __stdio_verify_output

LIB error_eacces_mc, asm0_fflush

__stdio_verify_output:

   ; Verify output on stream is possible
   ;
   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
   ;         carry set if problem
   ;
   ; uses  : all except bc, de, hl, ix
   
   ; check for stream error and write mode
   
   ld a,(ix+3)                 ; a = state_flags_0
   
   and $48                     ; keep write and error flags
   cp $40                      ; compare W=1 and ERR=0
   
   jp nz, error_eacces_mc
   
   ; check if last operation on stream was a read
   
   bit 1,(ix+4)
   jr z, last_write
   
   push bc
   push de
   push hl
   
   call asm0_fflush_unlocked
   
   pop hl
   pop de
   pop bc

last_write:

   ld (ix+4),0                 ; clear state_flags_1
   
   or a
   ret
