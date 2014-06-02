
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keyboard input console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; keypresses are collected via LASTK system variable
; no rom dependency

; FILE *
;
; offset   description
;
;  13,14   driver flags
;  15,16   terminal state *

; terminal state
;
; offset   description
;
;  0,1     FILE *output_terminal_L1
;  2,3     edit buffer address
;  4,5     edit buffer ptr (read from)
;   6      edit buffer len

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC cons_input_kbd_lastk_L1

defc LASTK = 23560

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_input_terminal_L1
   EXTERN STDIO_MSG_FLSH, STDIO_MSG_ITERM_GETCHAR

cons_input_kbd_lastk_L1:

   cp STDIO_MSG_ITERM_GETCHAR
   jr z, __getchar
   
   cp STDIO_MSG_FLSH
   jp nz, __cons_input_terminal_L1   ; forward message to driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__flsh:

   xor a
   ld (LASTK),a

   ld a,STDIO_MSG_FLSH
   jp __cons_input_terminal_L1       ; forward message to driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getchar:

   ; return a = hl = char read from device
   ;        carry reset
   ;
   ; must only modify af, hl
   
   ld a,(LASTK)
   
   or a
   jr z, __getchar             ; if no keypress
   
   ld l,a
   
   xor a
   ld (LASTK),a                ; consume the keypress
   
   ld h,a
   ld a,l
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
