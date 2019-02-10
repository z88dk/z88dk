;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_sound_callee(int freq, int cycles)

SECTION code_clib
PUBLIC vz_sound_callee
PUBLIC _vz_sound_callee
EXTERN ASMDISP_VZ_SOUND_CALLEE

.vz_sound_callee
._vz_sound_callee

   pop de
   pop bc
   pop hl
   push de
   
   ; bc = cycles
   ; hl = freq
 
 .asmentry                   ; similar to z88dk bit_beep()
 
    jp $345c                 ; sound
 
 DEFC ASMDISP_VZ_SOUND_CALLEE = # asmentry - vz_sound_callee
 
