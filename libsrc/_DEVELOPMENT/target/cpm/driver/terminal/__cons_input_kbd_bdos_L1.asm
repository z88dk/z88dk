
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keyboard input console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; keypresses are collected via bdos call c=6, e=255

; FILE *
;
; offset   description
;
;   13     driver flags
;  14,15   terminal state *

; terminal state
;
; offset   description
;
;  0,1     FILE *output_terminal_L1
;  2,3     edit buffer address
;  4,5     edit buffer ptr (read from)
;   6      edit buffer len

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __cons_input_kbd_bdos_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_input_terminal_L1
   EXTERN STDIO_MSG_ITERM_GETCHAR

__cons_input_kbd_bdos_L1:

   cp STDIO_MSG_ITERM_GETCHAR
   jp nz, __cons_input_terminal_L1   ; forward message to driver

   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getchar:

   ; return a = hl = char read from device
   ;        carry reset
   ;
   ; must only modify af, hl

   push bc
   push de

__getchar_loop:

   ld c,6
   ld e,255
   call 5
   
   or a
   jr z, __getchar_loop
   
   pop de
   pop bc
   
   ld l,a
   ld h,0
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
