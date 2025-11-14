
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dread3

EXTERN cm48_sdcciyp_dload

cm48_sdcciyp_dread3:

   ; sdcc float primitive
   ; Read sdcc floats from the stack
   ;
   ; Covert from sdcc float format to math48 format.
   ;
   ; enter : stack = sdcc_float, word, ret1, ret0
   ;
   ; exit  : AC'= double (math48)
   ; 
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld hl,6
   add hl,sp
   
   jp cm48_sdcciyp_dload
