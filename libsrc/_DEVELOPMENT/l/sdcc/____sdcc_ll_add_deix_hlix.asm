
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_add_deix_hlix

EXTERN l_add_64_mde_mhl

____sdcc_ll_add_deix_hlix:

   ; deix = deix + hlix
   
   push de                     ; save deix
   
   push ix
   pop de                      ; de = ix
   
   add hl,de
   ex (sp),hl                  ; save hlix + ix
   
   add hl,de
   ex de,hl                    ; de = deix + ix
   
   pop hl                      ; hl = hlix + ix
   
   jp l_add_64_mde_mhl
