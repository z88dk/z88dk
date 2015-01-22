
SECTION code_fcntl

PUBLIC zx_01_input_lastk_stdio_msg_ictl

EXTERN console_01_input_stdio_msg_ictl, console_01_input_stdio_msg_ictl_0
EXTERN zx_01_input_lastk_proc_lastk_address, zx_01_input_lastk_stdio_msg_flsh
EXTERN error_einval_zc

zx_01_input_lastk_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_ITERM_RESET      = $0101
   ; defc IOCTL_ITERM_LASTK      = $1101
   ;
   ; in addition to flags managed by stdio
   ; and messages understood by base class
   ;
   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg (0 if stdio flags)
   ;
   ; exit  : hl = return value
   ;         carry set if ioctl rejected
   ;
   ; uses  : af, bc, de, hl

   ; flags managed by stdio?
   
   ld a,h
   or l
   jp z, console_01_input_stdio_msg_ictl
   
   ; check the message is specifically for an input terminal
   
   ld a,e
   and $07
   cp $01                      ; input terminals are type $01
   jp nz, error_einval_zc
   
   ; interpret ioctl message
   
   ld a,d
   
   dec a
   jp z, zx_01_input_lastk_stdio_msg_flsh
   
   cp $11 - 1
   jp nz, console_01_input_stdio_msg_ictl_0
   
_ioctl_iterm_lastk:

   ; bc = first parameter (lastk address)
   ; hl = void *arg

   call zx_01_input_lastk_proc_lastk_address
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = old lastk
   
   ld a,b
   and c
   inc a
   jr z, _ioctl_iterm_lastk_exit
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; store new lastk

_ioctl_iterm_lastk_exit:

   ex de,hl                    ; hl = old lastk
   
   ld a,(ix+6)
   and $03
   dec a
   ret nz                      ; if not in error state
   
   res 0,(ix+6)
   ret
