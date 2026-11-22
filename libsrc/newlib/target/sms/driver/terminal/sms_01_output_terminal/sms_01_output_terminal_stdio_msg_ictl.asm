SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_stdio_msg_ictl
PUBLIC sms_01_output_terminal_stdio_msg_ictl_0

EXTERN asm_vioctl_driver, error_einval_zc, l_offset_ix_de
EXTERN console_01_output_char_stdio_msg_ictl_0

sms_01_output_terminal_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_OTERM_CHARACTER_PATTERN_OFFSET = $0802
   ; defc IOCTL_OTERM_FONT                     = $0802
   ; defc IOCTL_OTERM_SCREEN_MAP_ADDRESS       = $1002
   ; defc IOCTL_OTERM_PRINT_FLAGS              = $1102
   ; defc IOCTL_OTERM_BACKGROUND_CHARACTER     = $1202
   ;
   ; in addition to flags managed by stdio
   ; and messages understood by base class
   ;
   ; enter : de = request
   ;         bc = first parameter
   ;         hl = void *arg (0 if stdio flags)
   ;
   ; exit  : hl = return value
   ;         carry set if ioctl rejected
   ;
   ; uses  : af, bc, de, hl
   
   ; flag bits managed by stdio?
   
   ld a,h
   or l
   jp z, asm_vioctl_driver     ; accept all changes to stdio flags
   
   ; check that message is specifically for an output terminal
   
   ld a,e
   and $07
   cp $02                      ; output terminal messages are type $02
   jp nz, error_einval_zc
   
   ; interpret ioctl message

sms_01_output_terminal_stdio_msg_ictl_0:

   ld a,d
   cp $08
   jr z, _ioctl_char_pattern_offset
   
   sub $10
   jp c, console_01_output_char_stdio_msg_ictl_0

   jr z, _ioctl_screen_map_addr
   
   dec a
   jr z, _ioctl_print_flags
   
   dec a
   jp nz, error_einval_zc

_ioctl_background_char:

   ; bc = first parameter (background character)
   ; hl = void *arg

   ld hl,26

_ioctl_qualified_word:

   call l_offset_ix_de
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = old word

   ld a,b
   and c
   inc a
   jr z, _ioctl_offset_ret     ; if new word == -1 no changes

   ld (hl),b
   dec hl
   ld (hl),c

_ioctl_offset_ret:

   ex de,hl                    ; hl = old word
   ret

_ioctl_char_pattern_offset:

   ; bc = first parameter (char pattern offset)
   ; hl = void *arg

   ld hl,23
   
   ld a,b
   and c
   inc a
   jr z, _ioctl_qualified_word
   
   ld a,b
   and $01
   ld b,a
   
   jr _ioctl_qualified_word

_ioctl_screen_map_addr:

   ; bc = first parameter (screen map address)
   ; hl = void *arg

   ld hl,21
   
   ld a,b
   and c 
   inc a
   jr z, _ioctl_qualified_word
   
   ld a,b
   and $38
   ld b,a
   
   ld c,0
   jr _ioctl_qualified_word

_ioctl_print_flags:

   ; bc = first parameter (print flags)
   ; hl = void *arg

   ld l,(ix+25)
   ld h,0                      ; hl = old flags
   
   ld a,b
   or a
   ret nz                      ; if new flags > 255

   ld (ix+25),c
   ret
