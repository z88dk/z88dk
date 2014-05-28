
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keyboard input console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; keypresses are read by the input library's inkey() function
; no rom dependency, contains busy wait loops

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
;   7      getk_state
;   8      getk_lastk
;   9      getk_debounce_ms
; 10,11    getk_repeatbegin_ms
; 12,13    getk_repeatperiod_ms

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __cons_input_kbd_inkey_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_input_terminal_L1
   EXTERN STDIO_MSG_FLSH, STDIO_MSG_ITERM_GETCHAR

__cons_input_kbd_inkey_L1:

   cp STDIO_MSG_ITERM_GETCHAR
   jp nz, __cons_input_terminal_L1   ; forward message to driver

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN asm_z80_delay_ms, asm_in_inkey

__getchar:

   ; return a = hl = char read from device
   ;        carry reset
   ;
   ; must only modify af, hl

   push bc
   push de
   
   ld l,(ix+14)
   ld h,(ix+15)                ; hl = terminal state *
   
   ld de,7
   add hl,de                   ; hl = ts->getk_state
   
   ld b,(hl)                   ; b = getk_state
   inc hl
   ld c,(hl)                   ; c = getk_lastk
   inc hl

   push hl
   djnz state_2

state_1:
   
   call asm_in_inkey

state_1t_join:

   inc l
   dec l
   
   jr z, state_1
   
   ld c,l
   ld b,$02

   pop hl
   push hl
   
   ld l,(hl)
   ld h,0
   
   jr debounce

state_2:

   inc hl
   djnz state_3

   ; repeat begin

   jr getk_0

state_3:

   djnz state_unknown

   inc hl
   inc hl

   ; repeat end

getk_0:

   ld b,$03

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

getk_1:

   ;  b = state_next
   ;  c = getk_last
   ; hl = delay_ms

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

   ld a,h
   or l
   jr z, keypressed
   
   dec hl

   push hl
   push bc
   
   ld hl,1
   call asm_z80_delay_ms
   
   jr getk_loop

state_1t:

   pop bc
   jr state_1t_join

keypressed:

   pop hl
   
   dec hl
   ld (hl),c                   ; store lastk
   dec hl
   ld (hl),b                   ; store getk_state

   ld l,c
   ld h,0
   ld a,c
   
   pop de
   pop bc
   
   ret

state_unknown:

   dec hl
   jr state_1   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
