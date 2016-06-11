; CALLER linkage for function pointers

SECTION code_clib
PUBLIC ba_BestFit
PUBLIC _ba_BestFit
EXTERN BABestFit

.ba_BestFit
._ba_BestFit

   ld hl,2
   add hl,sp
   ld b,(hl)
   inc hl
   inc hl
   ld l,(hl)
   ld h,0
   jp BABestFit
