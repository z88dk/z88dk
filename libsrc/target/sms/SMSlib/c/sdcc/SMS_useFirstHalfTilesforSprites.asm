; void SMS_useFirstHalfTilesforSprites(_Bool usefirsthalf)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_useFirstHalfTilesforSprites

EXTERN asm_SMSlib_useFirstHalfTilesforSprites

_SMS_useFirstHalfTilesforSprites:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_SMSlib_useFirstHalfTilesforSprites
