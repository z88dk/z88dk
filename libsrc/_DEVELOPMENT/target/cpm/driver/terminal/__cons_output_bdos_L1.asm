
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bdos output console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; character output sent to bdos call c=2

; FILE *
;
; offset   description
;
;   13     driver flags
;  14,15   input terminal state * (structure in input console)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __cons_output_bdos_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_output_terminal_L1
   EXTERN STDIO_MSG_OTERM_L1

__cons_output_fzx_L1:
   
   cp STDIO_MSG_OTERM_L1
   jp nz, __cons_output_terminal_L1   ; forward unhandled messages

   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_L1:

   ; STDIO_MSG_OTERM_L1
   ; can modify af, bc, de, hl, ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_01:

   djnz __oterm_02

   ;   b = 1 __cons_output_putc
   ;         c = char to output
   ;         carry set if error (ignored by input console)
   ;         do not modify ix

   ; uses  : all except ix, bc', de', hl'

   push ix
   call __bdos_putc
   pop ix
   ret

__bdos_putc:

   ld a,c

   cp 13
   jr z, __bdos_putc_crlf

   bit 4,(ix+13)
   jr z, __bdos_outchar

__bdos_putc_cook:

   ; cook is enabled
   ; interpret special codes
   
   cp 12
   jr z, __bdos_putc_cls

__bdos_outchar:

   ld e,a
   ld d,0
   ld c,2
   call 5
   
   or a
   ret

__bdos_putc_crlf:

   ld de,10
   ld c,2
   call 5
   
   ld a,13
   jr __bdos_outchar


__bdos_putc_cls:

   ; this is the ANSI CLS call

   ld a,27
   call __bdos_outchar
   
   ld a,'['
   call __bdos_outchar
   
   ld a,'J'
   jp __bdos_outchar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_02:

   djnz __oterm_03

   ;   b = 2 __cons_output_backspace
   ;         c = char to erase
   ;        de = address of char to erase in edit buffer
   ;        carry set if password mode (set locally)

__oterm_02_bs:




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_03:

   djnz __oterm_04

   ;   b = 3 __cons_output_backspace_pwd
   ;         c = password char
   ;        de = address of char to erase in edit buffer

   scf
   jr __oterm_02_bs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


__oterm_04:

   djnz __oterm_unknown

   ;   b = 4 input console is starting read line
   ;        de = address of edit buffer








__oterm_unknown:

   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
