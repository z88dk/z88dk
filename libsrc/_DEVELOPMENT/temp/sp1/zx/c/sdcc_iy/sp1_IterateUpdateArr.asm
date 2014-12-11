; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)

SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateArr

_sp1_IterateUpdateArr:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_IterateUpdateArr.asm"
