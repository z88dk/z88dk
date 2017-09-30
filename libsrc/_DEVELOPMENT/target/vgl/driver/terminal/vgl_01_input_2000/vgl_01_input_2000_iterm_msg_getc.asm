
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC vgl_01_input_2000_iterm_msg_getc

EXTERN error_mc


vgl_01_input_2000_iterm_msg_getc:
   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl
   
   
   ; Wait for keypress
   ld a, 0xc0
   ld (__VGL_2000_KEY_STATUS_ADDRESS), a	; Prepare next getkey
      
   ; Wait for key press
   pause_getc_loop:
      ld a, (__VGL_2000_KEY_STATUS_ADDRESS)
      cp 0xd0
      jr nz, pause_getc_loop
   ld a, (__VGL_2000_KEY_CURRENT_ADDRESS)
   
   ; A = ascii code
   ; Map to standard keys, like: ld a,CHAR_LF / CHAR_CR / CHAR_CTRL_Z
   
   cp 0x00
   jp z, error_mc              ; generate EOF
   
   cp 0x60        ;__VGL_KEY_BREAK=0x60
   jr z, key_esc
   
   cp 0x7c        ; __VGL_KEY_ENTER=0x7c
   jr z, key_lf
   ;jr z, key_cr
   
   ;cp 10
   ;jr z, key_lf
   
   cp 0xf4        ; __VGL_KEY_BACKSPACE_X=0xf4
   jr z, key_bs
   
   
   
exit:
   ld l,a
   ld h,0                      ; a = hl = ascii code
   
   or a
   ret

key_bs:
   ld a,CHAR_BS
   jr exit

key_lf:
   ld a,CHAR_LF
   jr exit

key_cr:
   ld a,CHAR_CR
   jr exit

key_esc:
   ld a,CHAR_ESC
   jr exit

key_ungetc:
   ld a, 0        ; See FDSTRUCT for which ungetc to use
   ret