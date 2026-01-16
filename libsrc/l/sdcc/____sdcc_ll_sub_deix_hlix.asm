
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_sub_deix_hlix

EXTERN l_sub_64_mde_mhl

____sdcc_ll_sub_deix_hlix:

   ; deix = deix - hlix
   
   push de                     ; save deix
   
IFDEF __SDCC_IX

   push ix
   pop de                      ; de = ix

ELSE

   push iy
   pop de
   
ENDIF

   add hl,de
   ex (sp),hl                  ; save hlix + ix
   
   add hl,de
   ex de,hl                    ; de = deix + ix
   
   pop hl                      ; hl = hlix + ix
   
   jp l_sub_64_mde_mhl
