
; ===============================================================
; aralbrec - Mar 2014
; ===============================================================
;
; int fzx_mode(int mode)
;
; Set the fzx printing mode to OR, XOR or RESET
;
; ===============================================================

SECTION seg_code_fzx

PUBLIC asm_fzx_mode

PUBLIC fzx_mode_or, fzx_mode_xor, fzx_mode_reset
EXTERN __fzx_inst_0, __fzx_inst_1, __fzx_inst_2

asm_fzx_mode:

   ; enter : hl = {fzx_mode_or, fzx_mode_xor, fzx_mode_reset}
   ;
   ; exit  : hl = old fzx mode
   ;
   ; uses  : de, hl
   
   ld de,(__fzx_inst_0)        ; get current mode
   
   ld (__fzx_inst_0),hl        ; store new mode
   ld (__fzx_inst_1),hl
   ld (__fzx_inst_2),hl
   
   ex de,hl                    ; return old mode
   ret

defc fzx_mode_or    = $b600    ; nop, or (hl)
defc fzx_mode_xor   = $ae00    ; nop, xor (hl)
defc fzx_mode_reset = $a62f    ; cpl, and (hl)
