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
EXTERN asm_vz_sound

.vz_sound_callee
._vz_sound_callee

   pop de
   pop bc
   pop hl
   push de
   
   ; bc = cycles
   ; hl = freq
 
 .asm_vz_sound                   ; similar to z88dk bit_beep()
 
    jp $345c                 ; sound
  
