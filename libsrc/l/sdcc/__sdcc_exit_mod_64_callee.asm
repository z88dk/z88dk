
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __sdcc_exit_mod_64_callee

EXTERN l_store_64_dehldehl_mbc

__sdcc_exit_mod_64_callee:

   ex af,af'
   
   ld c,(ix-2)
   ld b,(ix-1)                 ; bc = remainder *
   
   call l_store_64_dehldehl_mbc
   
   pop ix                      ; restore ix
   pop de                      ; return address
   
   ld hl,18
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ex af,af'
   
   ex de,hl                    ; hl = return address
   jp (hl)
