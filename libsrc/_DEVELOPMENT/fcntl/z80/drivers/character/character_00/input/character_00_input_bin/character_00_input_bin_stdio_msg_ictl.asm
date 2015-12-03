
SECTION code_driver
SECTION code_driver_character_input

PUBLIC character_00_input_bin_stdio_msg_ictl

EXTERN device_reset_error

character_00_input_bin_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_RESET      = $0000
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

   ; flag bits managed by stdio?
   
   ld a,h
   or l
   jr nz, exit_error           ; if stdio message
   
   ; ictl messages
   
   ld a,d
   or e
   jp z, device_reset_error    ; if IOCTL_RESET

exit_error:

   scf
   ret
