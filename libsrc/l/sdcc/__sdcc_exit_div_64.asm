
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __sdcc_exit_div_64

__sdcc_exit_div_64:

   ex af,af'

   ld e,(ix-2)
   ld d,(ix-1)                 ; de = quotient *
   
   push ix
   pop hl                      ; hl = & quotient
   
   ld bc,8
   ldir                        ; copy quotient to result
   
   ex af,af'
   
   pop ix                      ; restore ix
   ret
