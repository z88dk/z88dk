;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __CALLEE__ vz_sound_callee(int freq, int cycles)

XLIB vz_sound_callee
XREF ASMDISP_VZ_SOUND_CALLEE

.vz_sound_callee

   pop de
   pop bc
   pop hl
   push de
   
   ; bc = cycles
   ; hl = freq
 
 .asmentry                   ; similar to z88dk bit_beep()
 
    jp $345c                 ; sound
 
 DEFC ASMDISP_VZ_SOUND_CALLEE = asmentry - vz_sound_callee
 