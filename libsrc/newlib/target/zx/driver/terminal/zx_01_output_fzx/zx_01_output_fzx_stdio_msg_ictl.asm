
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_stdio_msg_ictl
PUBLIC zx_01_output_fzx_stdio_msg_ictl_0

EXTERN asm_vioctl_driver, error_einval_zc
EXTERN console_01_output_fzx_stdio_msg_ictl_0

zx_01_output_fzx_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_OTERM_FCOLOR     = $1002
   ; defc IOCTL_OTERM_FMASK      = $1102
   ; defc IOCTL_OTERM_BCOLOR     = $1202
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

zx_01_output_fzx_stdio_msg_ictl_0:

   ld a,d
   
   sub $10
   jp c, console_01_output_fzx_stdio_msg_ictl_0
   
   jr z, _ioctl_fcolor
   
   dec a
   jr z, _ioctl_fmask
   
   dec a
   jp nz, error_einval_zc

_ioctl_bcolor:

   ; bc = background_colour
   
   ld l,(ix+54)
   ld h,0                      ; hl = old background colour
   
   ld a,b
   or a
   ret nz                      ; if bcolour > 255
   
   ld (ix+54),c
   ret

_ioctl_fmask:

   ; bc = foreground mask
   
   ld l,(ix+53)
   ld h,0                      ; hl = old foreground mask
   
   ld a,b
   or a
   ret nz                      ; if fmask > 255
   
   ld (ix+53),c
   ret

_ioctl_fcolor:

   ; bc = foreground colour
   
   ld l,(ix+52)
   ld h,0                      ; hl = old foreground colour
   
   ld a,b
   or a
   ret nz                      ; if fcolour > 255
   
   ld (ix+52),c
   ret
