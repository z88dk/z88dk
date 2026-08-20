
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC cpm_01_output_dcio_stdio_msg_ictl

EXTERN asm_vioctl_driver, error_einval_zc

cpm_01_output_dcio_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_OTERM_CRLF      = $c012
   ; defc IOCTL_OTERM_COOK      = $c022
   ; defc IOCTL_OTERM_BELL      = $c102
   ; defc IOCTL_OTERM_SIGNAL    = $c202
   ; defc IOCTL_OTERM_GET_OTERM = $0602
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
   jr nz, ioctl_message

   call qualify
   jp asm_vioctl_driver

qualify:

   ; stdio ioctl flags
   ; de = affected flag bits
   ;    = accept $0010, $0020, $0100, $0200

   ld a,e
   or a
   jr nz, part_2

part_1:

   dec d
   ret z
   
   dec d
   ret z

reject:

   scf
   ret

part_2:

   inc d
   dec d
   jr nz, reject
   
   cp $10
   ret z
   
   cp $20
   ret z
   
   jr reject

ioctl_message:

   ; check that message is specifically for an output terminal
   
   ld a,e
   cp $02                      ; output terminal messages are type $02
   jp nz, error_einval_zc

   ld a,d
   cp $06
   jp nz, error_einval_zc

_ioctl_get_oterm:

   ; return the address of this oterm's FDSTRUCT
   
   push ix
   pop hl
   
   dec hl
   dec hl
   dec hl
   
   ret
