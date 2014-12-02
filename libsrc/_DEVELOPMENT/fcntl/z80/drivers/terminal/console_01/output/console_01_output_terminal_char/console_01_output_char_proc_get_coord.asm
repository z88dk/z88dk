
SECTION seg_code_fcntl

PUBLIC console_01_output_char_proc_get_coord

console_01_output_char_proc_get_coord:

   ; exit : e = x coord
   ;        d = y coord
   
   ld e,(ix+14)
   ld d,(ix+15)
   
   ret
