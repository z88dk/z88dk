
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dsize

am48_dsize:

   ; size of double in memory
   ;
   ; exit : bc = size of double in bytes
   ;
   ; uses : bc
   
   ld bc,6
   ret
