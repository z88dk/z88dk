
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; console_01_input_kbd_inkey ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The keyboard is read via the library's in_inkey() function.
;
;   * No ROM dependency
;   * Implements key debounce and key repeat
;   * Contains busy wait loops
;   * Very responsive
;   * Reads keyboard directly
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
;   25                      getk_state
;   26                      getk_lastk
;   27                      getk_debounce_ms
;   28..29                  getk_repeatbegin_ms
;   30..31                  getk_repeatperiod_ms
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

SECTION seg_code_fcntl

PUBLIC console_01_input_kbd_inkey

EXTERN asm_z80_delay_ms, asm_in_inkey
EXTERN console_01_input_terminal, l_offset_ix_de

EXTERN IOCTL_ITERM_SET_DELAYS
EXTERN ITERM_MSG_GETC, STDIO_MSG_ICTL, STDIO_MSG_FLSH

console_01_input_kbd_inkey:

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

   ld a,IOCTL_ITERM_SET_DELAYS % 256
   cp e
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library
   
   ld a,IOCTL_ITERM_SET_DELAYS / 256
   cp d
   jp nz, console_01_input_stdio_msg_ictl  ; forward to library

   ; IOCTL_ITERM_SET_DELAYS
   ; change repeat rates
   
    call __getk_state_address   ; hl = & getk_state
    
    inc hl
    inc hl
    
    ex de,hl                    ; de = & getk_debounce_ms
    
    ld l,c
    ld h,b                      ; hl = void *src
    
    ld bc,5
    ldir                        ; copy from src to delay times
    
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__flush:

   call __getk_state_address   ; hl = & getk_state

   xor a

   ld (hl),a                   ; getk_state = 0
   inc hl
   ld (hl),a                   ; getk_lastk = 0

   jp console_01_input_stdio_msg_flsh   ; forward to library

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   call __getk_state_address   ; hl = & getk_state
   
   ld b,(hl)                   ; b = getk_state
   inc hl
   
   ld c,(hl)                   ; c = getk_lastk
   inc hl
   
   push hl                     ; save & getk_debounce_ms
   djnz state_2

state_1:                       ; debounce state

   call asm_in_inkey           ; get intial keypress

state_1t_join:

   inc l
   dec l
   
   jr z, state_1               ; if no key read
   
   ld c,l                      ; c = ascii code
   ld b,$02                    ; next state
   
   pop hl
   push hl
   
   ld l,(hl)
   ld h,0                      ; hl = debounce_ms
   
   jr debounce

state_2:                       ; repeat begin state

   inc hl                      ; hl = & getk_repeat_begin_ms
   djnz state_3
   
   ; repeat begin
   
   jr getk_0

state_unknown:

   dec hl                      ; hl = & getk_debounce_ms
   jr state_1

state_3:                       ; repeat period state

   djnz state_unknown
   
   inc hl
   inc hl                      ; hl = & getk_repeat_period_ms

getk_0:

   ld b,$03                    ; next state
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = repeat_ms

getk_1:

   ;  b = next state
   ;  c = getk_last
   ; hl = delay_ms
   ; stack = & getk_debounce_ms
   
   push hl
   push bc

getk_loop:

   call asm_in_inkey
   
   pop bc
   
   ld a,l
   cp c
   jr nz, state_1t             ; if current keypress does not match lastk
   
   pop hl

debounce:

   ; hl = time remaining to match
   ;  c = getk_last
   ;  b = next state
   ; stack = & getk_debounce_ms
   
   ld a,h
   or l
   jr z, key_pressed
   
   dec hl
   
   push hl
   push bc
   
   ld hl,1
   call asm_z80_delay_ms
   
   jr getk_loop

state_1t:

   ; keypress mismatch, return to debounce state
   
   ; hl = ascii code
   ; stack = & getk_debounce_ms, junk
   
   pop bc
   jr state_1t_join

key_pressed:

   pop hl                      ; hl = & getk_debounce_ms
   
   dec hl
   ld (hl),c                   ; store lastk (current keypress)
   
   dec hl
   ld (hl),b                   ; store next state
   
   ; insert character set translation here
   ; must translate to the clib charset
   
   ld a,c                      ; a = ascii char from in_inkey
   
   cp 10
   jr nz, key_not_cr
   ld c,CHAR_CR

key_not_cr:

   cp 13
   jr nz, key_not_lf
   ld c,CHAR_LF

key_not_lf:

   ld l,c
   ld h,0
   ld a,c                      ; a = hl = translated char
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__getk_state_address:

   ; return & getk_state
   
   ld hl,25
   jp l_offset_ix_de           ; hl = & getk_state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
