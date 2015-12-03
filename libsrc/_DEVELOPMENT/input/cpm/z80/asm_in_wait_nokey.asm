
; ===============================================================
; Oct 2015
; ===============================================================
; 
; void in_wait_nokey(void)
;
; Busy wait until no keys are pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_wait_nokey

EXTERN __CPM_DCIO
EXTERN asm_cpm_bdos

asm_in_wait_nokey:

   ; uses : potentially all (ix, iy saved for sdcc)

   ld c,__CPM_DCIO             ; direct console i/o
   ld e,0xff                   ; input
   call asm_cpm_bdos
   
   or a
   jr nz, asm_in_wait_nokey

   ret
