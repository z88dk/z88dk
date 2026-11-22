
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_stdio_msg_ictl

EXTERN asm_vioctl_driver, asm_tty_reset, l_offset_ix_de
EXTERN zx_01_output_fzx_stdio_msg_ictl

zx_01_output_fzx_tty_z88dk_stdio_msg_ictl:

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
   jp nz, zx_01_output_fzx_stdio_msg_ictl
   
   ; if cook mode is being enabled also reset the tty state machine
   
   ld a,e
   and c
   and $20
   
   jp z, asm_vioctl_driver     ; cook mode not being enabled
   call asm_vioctl_driver      ; set flags
   
   push hl                     ; save return value
   
   ld hl,55
   call l_offset_ix_de         ; hl = & tty
   
   call asm_tty_reset
   
   pop hl
   ret
