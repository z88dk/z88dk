
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_inkey_iterm_msg_getc

EXTERN zx_01_input_inkey_proc_getk_address
EXTERN asm_in_inkey, asm_z80_delay_ms, error_mc

zx_01_input_inkey_iterm_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   call zx_01_input_inkey_proc_getk_address  ; hl = & getk_state
   
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
   jr z, key_cr
   
   cp 13
   jr z, key_lf

   cp CHAR_CTRL_D
   jp z, error_mc              ; indicate eof

exit:

   ld l,a
   ld h,0                      ; a = hl = ascii code
   
   or a
   ret

key_cr:

   ld a,CHAR_CR
   jr exit

key_lf:

   ld a,CHAR_LF
   jr exit
