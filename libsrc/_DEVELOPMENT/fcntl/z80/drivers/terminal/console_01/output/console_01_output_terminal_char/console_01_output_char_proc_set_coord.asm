
SECTION code_fcntl

PUBLIC console_01_output_char_proc_set_coord

console_01_output_char_proc_set_coord:

   ; enter : e = x coord
   ;         d = y coord
   
   ld (ix+14),e
   ld (ix+15),d
   
   ret
