
SECTION code_fcntl

PUBLIC console_01_input_proc_reset

console_01_input_proc_reset:

   ; clear error and eof state bits
   
   ld a,(ix+6)
   and $fc
   ld (ix+6),a
   
   ret
