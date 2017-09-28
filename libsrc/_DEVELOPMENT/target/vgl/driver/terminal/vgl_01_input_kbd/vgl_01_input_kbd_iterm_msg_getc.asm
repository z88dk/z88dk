
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC vgl_01_input_kbd_iterm_msg_getc

EXTERN error_mc



vgl_01_input_kbd_iterm_msg_getc:
   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl
   
   
;   ; Modify fdstruct
;   ld hl,25
;   jp l_offset_ix_de           ; hl = & getk_state
;   
;   ;ld b,(hl)                   ; b = getk_state
;   ld b, 0
;   ld (hl), b
;   inc hl
;   
;   ;ld c,(hl)                   ; c = getk_lastk
;   ld c, 0
;   ld (hl), c
;   ;inc hl
   
   
   ; Prepare next getkey
   ld a, 0xc0
   ld (__VGL_KEY_STATUS_ADDRESS), a
   
   ; Wait for key press
vgl_01_input_kbd_iterm_msg_getc_loop:
   ld a, (__VGL_KEY_STATUS_ADDRESS)
   cp 0xd0
   jr nz, vgl_01_input_kbd_iterm_msg_getc_loop
   
   ; Get current key
   ld a, (__VGL_KEY_CURRENT_ADDRESS)
   
   ; A = ascii code
   ; Map to standard keys, like: ld a,CHAR_LF / CHAR_CR / CHAR_CTRL_Z
   
   cp 0x60	;CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF
   
   ;ld l,a
   ;ld h,0                      ; a = hl = ascii code
   
   or a
   ret
