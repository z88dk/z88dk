
SECTION seg_code_fcntl

PUBLIC zx_01_input_lastk_stdio_msg_ictl

EXTERN IOCTL_ITERM_SET_LASTK

EXTERN console_01_input_stdio_msg_ictl
EXTERN zx_01_input_lastk_proc_lastk_address

zx_01_input_lastk_stdio_msg_ictl:

   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg

   ld a,IOCTL_ITERM_SET_LASTK % 256
   cp e
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library
   
   ld a,IOCTL_ITERM_SET_LASTK / 256
   cp d
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library

   ; IOCTL_ITERM_SET_LASTK
   ; change lastk address
   
   call zx_01_input_lastk_proc_lastk_address   ; hl = & LASTK
   
   ld e,(hl)
   ld (hl),c
   inc hl
   ld d,(hl)
   ld (hl),b                   ; store new lastk
   
   ex de,hl                    ; hl = old lastk
   ret
