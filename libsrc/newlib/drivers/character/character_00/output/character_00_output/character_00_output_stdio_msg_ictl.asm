
SECTION code_driver
SECTION code_driver_character_output

PUBLIC character_00_output_stdio_msg_ictl

EXTERN asm_vioctl_driver

character_00_output_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_OCHAR_CRLF = $c014
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
   jr nz, exit_error           ; don't understand any ioctl messages
   
   ; stdio bits
   
   inc d
   dec d
   jr nz, exit_error
   
   ld a,e
   cp $10
   jp z, asm_vioctl_driver     ; accept IOCTL_OCHAR_CRLF

exit_error:

   scf
   ret
