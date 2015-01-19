; CALLER LINKAGE FOR FUNCTION POINTERS

PUBLIC vz_sound
EXTERN vz_sound_callee
EXTERN ASMDISP_VZ_SOUND_CALLEE

.vz_sound

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp vz_sound_callee + ASMDISP_VZ_SOUND_CALLEE

