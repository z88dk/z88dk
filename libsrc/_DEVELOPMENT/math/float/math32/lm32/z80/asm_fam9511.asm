
SECTION code_fp_math32

PUBLIC asm_f32_fam9511, asm_fam9511_f32

;-------------------------------------------------------------------------
;  f32_fam9511 - z80 format conversion code
;-------------------------------------------------------------------------
;
; convert am9511 float to IEEE-754 float
;
; enter : DEHL = am9511 float
;
; exit  : DEHL = IEEE-754 float
;
; uses  : af, de, hl
;
;-------------------------------------------------------------------------

EXTERN m32_f32_fam9511

defc asm_f32_fam9511 = m32_f32_fam9511

;-------------------------------------------------------------------------
;  fam9511_f32 - z80 format conversion code
;-------------------------------------------------------------------------
;
; convert IEEE-754 float to math48 float
;
; enter : DEHL = IEEE-754 float
;
; exit  : DEHL = am9511 float
;
; uses  : af, de, hl
;
;-------------------------------------------------------------------------

EXTERN m32_fam9511_f32

defc asm_fam9511_f32 = m32_fam9511_f32

