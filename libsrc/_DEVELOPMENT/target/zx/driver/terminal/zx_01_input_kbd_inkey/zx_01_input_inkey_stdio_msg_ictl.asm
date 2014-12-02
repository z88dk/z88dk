
SECTION seg_code_fcntl

PUBLIC zx_01_input_inkey_stdio_msg_ictl

EXTERN IOCTL_ITERM_SET_DELAYS
EXTERN console_01_input_stdio_msg_ictl, zx_01_input_inkey_proc_getk_address

zx_01_input_inkey_stdio_msg_ictl:

   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg

   ld a,IOCTL_ITERM_SET_DELAYS % 256
   cp e
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library
   
   ld a,IOCTL_ITERM_SET_DELAYS / 256
   cp d
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library

   ; IOCTL_ITERM_SET_DELAYS
   ; change repeat rates
   
    call zx_01_input_inkey_proc_getk_address    ; hl = & getk_state
    
    inc hl
    inc hl
    
    ex de,hl                    ; de = & getk_debounce_ms
    
    ld l,c
    ld h,b                      ; hl = void *src
    
    ld bc,5
    ldir                        ; copy from src to delay times
    
    ret
