
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_sub_deix_hlix

EXTERN l_sub_64_mde_mhl

____sdcc_ll_sub_deix_hlix:

   ; deix = deix - hlix
   
   push de                     ; save deix
   
   push ix
   pop de                      ; de = ix
   
   add hl,de
   ex (sp),hl                  ; save hlix + ix
   
   add hl,de
   ex de,hl                    ; de = deix + ix
   
   pop hl                      ; hl = hlix + ix
   
   jp l_sub_64_mde_mhl
