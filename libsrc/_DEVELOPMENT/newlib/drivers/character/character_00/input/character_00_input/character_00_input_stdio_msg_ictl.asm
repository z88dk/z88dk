
SECTION code_driver
SECTION code_driver_character_input

PUBLIC character_00_input_stdio_msg_ictl

EXTERN device_reset_error, asm_vioctl_driver

character_00_input_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_RESET      = $0000
   ; defc IOCTL_ICHAR_CRLF = $c103
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
   jr nz, _ictl_messages

   ; stdio bits
   
   inc e
   dec e
   jr nz, exit_error
   
   dec d
   jp z, asm_vioctl_driver     ; accept IOCTL_ICHAR_CRLF
   
   jr exit_error

_ictl_messages:

   ld a,d
   or e
   jp z, device_reset_error    ; if IOCTL_RESET

exit_error:

   scf
   ret
