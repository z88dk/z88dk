
INCLUDE "clib_cfg.asm"

SECTION seg_code_fcntl

PUBLIC zx_01_input_lastk_iterm_msg_getc

EXTERN zx_01_input_lastk_proc_lastk, error_zc

zx_01_input_lastk_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   call zx_01_input_lastk_proc_lastk
   jp z, error_zc              ; if LASTK = 0
   
   ; hl = LASTK
   
loop:

   ld a,(hl)
   or a
   jr z, loop                  ; if no keypress
   
   ld (hl),0                   ; consume the keypress
   
   ; insert character set translation here
   ; must translate to the clib charset

   cp 10
   jr z, key_cr
   
   cp 13
   jr z, key_lf

exit:

   ld l,a                      ; a = hl = ascii code
   ld h,0
   
   or a
   ret

key_cr:

   ld a,CHAR_CR
   jr exit

key_lf:

   ld a,CHAR_LF
   jr exit
