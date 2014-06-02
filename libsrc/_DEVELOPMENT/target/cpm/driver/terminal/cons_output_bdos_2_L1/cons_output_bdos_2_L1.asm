
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bdos output console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; character output sent to bdos call c=2

; FILE *
;
; offset   description
;
;  13,14   driver flags
;  15,16   terminal state *

; terminate state
;
; offset   description
;
;   0,1    input terminal state * (structure in input console)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC cons_output_bdos_2_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_output_terminal_L1
   EXTERN STDIO_MSG_OTERM_L1, STDIO_MSG_OTERM_PUTCHAR

cons_output_bdos_2_L1:
   
   cp STDIO_MSG_OTERM_L1
   jr z, __oterm_L1
   
   cp STDIO_MSG_OTERM_PUTCHAR
   jp nz, __cons_output_terminal_L1   ; forward unhandled messages

   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__putchar:

   ; these chars are delivered from stdio, not the input console
   ; this is where tty interpretation should be applied

   ; C = char to output
   ;
   ; return carry set on error
   ; can modify af, bc, de, hl

   ld a,c

   cp 13
   jr z, __putchar_crlf

__putchar_console:

   bit 4,(ix+13)
   jr z, __bdos_outchar        ; if cook disabled

__putchar_cook:

   ; cook is enabled
   ; interpret special codes
   
   cp 12
   jr z, __putchar_cls

__bdos_outchar:

   ld e,a
   ld d,0
   ld c,2
   call 5
   
   or a
   ret

__putchar_crlf:

   ld a,10
   call __bdos_outchar
   
   ld a,13
   jr __bdos_outchar


__putchar_cls:

   ; this is the ANSI CLS call

   ld a,27
   call __bdos_outchar
   
   ld a,'['
   call __bdos_outchar
   
   ld a,'J'
   jr __bdos_outchar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_L1:

   ; STDIO_MSG_OTERM_L1
   ; b = message number
   ; can modify af, bc, de, hl, ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_01:

   djnz __oterm_02

   ;   b = 1 __cons_output_putc
   ;         c = char to output
   ;         carry set if error (ignored by input console)
   ;         do not modify ix

   ; uses  : all except ix, bc', de', hl'

   ; the input console is generating this output
   ; prevent control characters from being output to driver

   ld a,c
   
   cp 13
   jr z, __putchar_crlf
   
   cp 32
   jr nc, __putchar_console
   
   ld a,'?'
   jr __putchar_console

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_02:

   ld a,b
   cp 3
   ret nc

   ;   b = 2 __cons_output_backspace
   ;     = 3 __cons_output_backspace_pwd
   ;         c = char to erase
   ;        de = address of char to erase in edit buffer

   ld a,8
   jr __bdos_outchar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
