
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_inkey_stdio_msg_ictl

EXTERN console_01_input_stdio_msg_ictl, console_01_input_stdio_msg_ictl_0
EXTERN error_einval_zc, console_01_input_proc_reset
EXTERN zx_01_input_inkey_proc_getk_address, __stdio_nextarg_bc, __stdio_nextarg_de

zx_01_input_inkey_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_RESET            = $0000
   ; defc IOCTL_ITERM_GET_DELAY  = $1081
   ; defc IOCTL_ITERM_SET_DELAY  = $1001
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
   
   ld a,e
   or d
   jp z, console_01_input_proc_reset   ; if IOCTL_RESET
   
   ; check the message is specifically for an input terminal
   
   ld a,e
   and $07
   cp $01                      ; input terminals are type $01
   jp nz, error_einval_zc

   ; interpret ioctl messages
   
   ld a,d
      
   cp $10
   jp nz, console_01_input_stdio_msg_ictl_0
   
_ioctl_getset_delay:

   ; e & $80 = 1 for get
   ; bc = first parameter (debounce_ms)
   ; hl = void *arg

   ld a,e
   push hl

   call zx_01_input_inkey_proc_getk_address
   
   inc hl
   inc hl                      ; hl = & getk_debounce_ms
   
   add a,a
   jr c, _ioctl_get_delay

_ioctl_set_delay:

   pop de                      ; de = void *arg

   ld (hl),c                   ; set debounce_ms
   inc hl
   
   ex de,hl
   call __stdio_nextarg_bc
   ex de,hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; set repeatbegin_ms
   inc hl
   
   ex de,hl
   call __stdio_nextarg_bc
   ex de,hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; set repeatperiod_ms
   
   ret

_ioctl_get_delay:

   ld a,(hl)                   ; a = debounce_ms
   inc hl
   
   ld (bc),a
   inc bc
   xor a
   ld (bc),a                   ; write debounce_ms
   
   ex (sp),hl                  ; hl = void *arg
   
   call __stdio_nextarg_de
   
   ex (sp),hl                  ; hl = & getk_repeatbegin_ms
   
   ldi
   ldi
   
   ex (sp),hl                  ; hl = void *arg
   
   call __stdio_nextarg_de
   
   pop hl                      ; hl = & getk_repeatperiod_ms
   
   ldi
   ldi

   ret
