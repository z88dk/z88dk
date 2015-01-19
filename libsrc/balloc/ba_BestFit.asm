; CALLER linkage for function pointers

PUBLIC ba_BestFit
EXTERN BABestFit

.ba_BestFit

   ld hl,2
   add hl,sp
   ld b,(hl)
   inc hl
   inc hl
   ld l,(hl)
   ld h,0
   jp BABestFit
