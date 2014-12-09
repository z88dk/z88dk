
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
   
   ; zx_01_input_kbd_inkey
   
   defc IOCTL_ITERM_GET_DELAY  = $0a81
   defc IOCTL_ITERM_SET_DELAY  = $0a01
   
   ; zx_01_input_kbd_lastk
   
   defc IOCTL_ITERM_GET_LASTK  = $0b81
   defc IOCTL_ITERM_SET_LASTK  = $0b01
   
   ; zx_01_output_char_32
   ; zx_01_output_char_64
   
   defc IOCTL_OTERM_GET_FONT   = $0a82
   defc IOCTL_OTERM_SET_FONT   = $0a02
   defc IOCTL_OTERM_GET_FCOLOR = $0b82
   defc IOCTL_OTERM_SET_FCOLOR = $0b02
   defc IOCTL_OTERM_GET_FMASK  = $0c82
   defc IOCTL_OTERM_SET_FMASK  = $0c02
   defc IOCTL_OTERM_GET_BCOLOR = $0d82
   defc IOCTL_OTERM_SET_BCOLOR = $0d02

;; end target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
