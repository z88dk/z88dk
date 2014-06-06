
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keyboard input console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; keypresses are collected from memory location LASTK
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
;  7,8     LASTK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC cons_input_kbd_lastk_L1

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

   call __get_lastk                  ; hl = & lastk

   xor a
   ld (hl),a

   ld a,STDIO_MSG_FLSH
   jp __cons_input_terminal_L1       ; forward message to driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getchar:

   ; return a = hl = char read from device
   ;        carry reset
   ;
   ; must only modify af, hl
   
   call __get_lastk

__getchar_loop:

   ld a,(hl)
   or a
   jr z, __getchar_loop        ; if no keypress
   
   ld (hl),0                   ; consume the keypress

   ld l,a
   ld h,0
      
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__get_lastk:
   
   ld a,(ix+15)
   add a,7
   ld l,a
   
   ld h,(ix+16)
   jr nc, noinc
   inc h

noinc:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = & lastk
   
   ret
