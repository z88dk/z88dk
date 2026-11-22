
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __sdcc_exit_mod_64

EXTERN l_store_64_dehldehl_mbc

__sdcc_exit_mod_64:

   ex af,af'
   
   ld c,(ix-2)
   ld b,(ix-1)                 ; bc = remainder *
   
   call l_store_64_dehldehl_mbc
   
   ex af,af'
   
   pop ix                      ; restore ix
   ret
