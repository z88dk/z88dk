; void SMS_loadPSGaidencompressedTiles(void *src, unsigned int tilefrom)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadPSGaidencompressedTiles_callee
PUBLIC SMS_loadPSGaidencompressedTiles_callee_0

EXTERN asm_SMSlib_loadPSGaidencompressedTiles

SMS_loadPSGaidencompressedTiles_callee:

   pop af
   pop hl
   pop de
   push af

SMS_loadPSGaidencompressedTiles_callee_0:

   push ix
   push iy
   
   call asm_SMSlib_loadPSGaidencompressedTiles

   pop iy
   pop ix
   
   ret
