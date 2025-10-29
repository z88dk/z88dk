SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_hbios1_stdio_msg_ictl

EXTERN rc_01_output_hbios0_stdio_msg_ictl

defc rc_01_output_hbios1_stdio_msg_ictl = rc_01_output_hbios0_stdio_msg_ictl

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
