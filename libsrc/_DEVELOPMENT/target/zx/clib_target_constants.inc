
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target error
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target messages
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target ioctls
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
   
   ; keep consistent with ioctl_spectrum.h
   
   ; zx_01_input_kbd_inkey
   
   defc IOCTL_ITERM_GET_DELAY  = $1081
   defc IOCTL_ITERM_SET_DELAY  = $1001
   
   ; zx_01_input_kbd_lastk
   
   defc IOCTL_ITERM_LASTK      = $1101
   
   ; zx_01_output_char_32
   ; zx_01_output_char_64
   ; zx_01_output_char_32_tty_z88dk
   ; zx_01_output_char_64_tty_z88dk
   
   defc IOCTL_OTERM_FCOLOR     = $1002
   defc IOCTL_OTERM_FMASK      = $1102
   defc IOCTL_OTERM_BCOLOR     = $1202

;; end target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
