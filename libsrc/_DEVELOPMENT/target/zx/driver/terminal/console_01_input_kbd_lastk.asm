
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; console_01_input_kbd_lastk ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The keyboard is read by monitoring a specific memory address
; for an ascii code.
;
; On the spectrum target, this can be address LASTK in the
; system variables area (hence the name of this driver) but
; it can be any memory address since the memory address used
; is stored in the FDSTRUCT.
;
; Keys are expected to be supplied as follows.  An independent
; scan of the keyboard is performed in a thread separate from
; the program.  This can be done in an interrupt routine, eg.
; A successful keyscan should write the ascii code into
; memory address LASTK.  This driver will monitor that address
; for an ascii code, read it, then write 0 into LASTK to
; indicate the ascii code was consumed.  The external agent
; can implement key repeat and buffering features by
; appropriately monitoring address LASTK.
;
;   * No ROM dependency unless you expect the ROM to write LASTK
;   * Contains busy wait loops
;   * Responsiveness depends on how frequently LASTK is written
;   * Does not return until keypress is registered
;
; This subroutine inherits the library's console_01_input
; terminal code which implements line editing and various
; other niceties.  This means this input console must be
; tied to an output terminal that understands console_01_input
; terminal messages.
;
; This device driver must implement at least one message and
; can forward the rest to the library driver.
;
;   * ITERM_MSG_GETC
;
;     exit : a = keyboard char after character set translation
;            carry set on error, hl = 0 (stream error) or -1 (eof)
;     uses : af, bc, de, hl
;
; This driver reserves extra bytes in the FDSTRUCT:
;
; offset (wrt FDSTRUCT.JP)  description
;
;   25..26                  LASTK address
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

SECTION seg_code_fcntl

PUBLIC console_01_input_kbd_lastk

EXTERN console_01_input_terminal, console_01_input_stdio_msg_ictl
EXTERN console_01_input_stdio_msg_flsh, error_zc

EXTERN IOCTL_ITERM_LASTK
EXTERN ITERM_MSG_GETC, STDIO_MSG_ICTL, STDIO_MSG_FLSH

console_01_input_kbd_lastk:

   cp ITERM_MSG_GETC
   jr z, __getc
   
   cp STDIO_MSG_FLSH
   jr z, __flush
   
   cp STDIO_MSG_ICTL
   jp nz, console_01_input_terminal    ; forward to library

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__ictl:

   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg

   ld a,IOCTL_ITERM_LASTK % 256
   cp e
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library
   
   ld a,IOCTL_ITERM_LASTK / 256
   cp d
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library

   ; IOCTL_ITERM_LASTK
   ; change lastk address
   
   call __lastk_address        ; hl = & LASTK
   
   ld e,(hl)
   ld (hl),c
   inc hl
   ld d,(hl)
   ld (hl),b                   ; store new lastk
   
   ex de,hl                    ; hl = old lastk
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__flush:

   call __lastk
   jp z, console_01_input_stdio_msg_flsh   ; if LASTK = 0
   
   ld (hl),0                               ; clear any pending char
   jp console_01_input_stdio_msg_flsh      ; forward to library

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   call __lastk
   jp z, error_zc              ; if LASTK = 0
   
   ; hl = LASTK
   
loop:

   ld a,(hl)
   or a
   jr z, loop                  ; if no keypress
   
   ld (hl),0                   ; consume the keypress
   
   ; insert character set translation here
   ; must translate to the clib charset

   cp 10
   jr z, key_cr
   
   cp 13
   jr z, key_lf

exit:

   ld l,a                      ; a = hl = ascii code
   ld h,0
   
   or a
   ret

key_cr:

   ld a,CHAR_CR
   jr exit

key_lf:

   ld a,CHAR_LF
   jr exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__lastk_address:

   ; return & LASTK
   
   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,25
   add hl,de                   ; hl = & LASTK

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__lastk:

   ; return LASTK
   
   ; exit : hl = LASTK
   ;        z flag set if hl = 0
   
   call __lastk_address        ; hl = & LASTK

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   or h
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
