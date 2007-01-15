; CALLER linkage for function pointers

XLIB ba_BestFit
LIB BABestFit

.ba_BestFit

   ld hl,2
   add hl,sp
   ld b,(hl)
   inc hl
   inc hl
   ld l,(hl)
   ld h,0
   jp BABestFit
