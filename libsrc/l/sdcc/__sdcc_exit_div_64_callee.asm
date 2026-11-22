
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __sdcc_exit_div_64_callee

__sdcc_exit_div_64_callee:

   ex af,af'

   ld e,(ix-2)
   ld d,(ix-1)                 ; de = quotient *
   
   push ix
   pop hl                      ; hl = & quotient
   
   ld bc,8
   ldir                        ; copy quotient to result
   
   pop ix                      ; restore ix
   pop de                      ; return address
   
   ld hl,18
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ex af,af'
   
   ex de,hl                    ; hl = return address
   jp (hl)
