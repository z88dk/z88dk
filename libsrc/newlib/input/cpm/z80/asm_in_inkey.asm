
; ===============================================================
; Oct 2015
; ===============================================================
; 
; int in_inkey(void)
;
; Read instantaneous state of the keyboard and return ascii code
; if only one key is pressed.
;
; Note: Limited by cpm here as it can only register one keypress.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_inkey

EXTERN __CPM_DCIO
EXTERN asm_cpm_bdos, error_znc

asm_in_inkey:

   ; exit : if one key is pressed
   ;
   ;           hl = ascii code
   ;           carry reset
   ;
   ;         if no keys are pressed
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if more than one key is pressed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses : potentially all (ix, iy saved for sdcc)
   
   ld c,__CPM_DCIO             ; direct console i/o
   ld e,0xff                   ; input
   call asm_cpm_bdos
   
   ld l,a
   xor a
   ld h,a
   
   ret
