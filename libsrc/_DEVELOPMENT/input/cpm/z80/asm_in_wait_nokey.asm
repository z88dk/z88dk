
; ===============================================================
; Oct 2015
; ===============================================================
; 
; void in_wait_nokey(void)
;
; Busy wait until no keys are pressed.
;
; ===============================================================

SECTION code_input

PUBLIC asm_in_wait_nokey

EXTERN asm_cpm_bdos

asm_in_wait_nokey:

   ; uses : potentially all (ix, iy saved for sdcc)

   ld c,0x06                   ; direct console i/o
   ld e,0xff                   ; input
   call asm_cpm_bdos
   
   or a
   jr nz, asm_in_wait_nokey

   ret
