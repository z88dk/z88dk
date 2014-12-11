
; ===============================================================
; Apr 2014
; ===============================================================
; 
; uint16_t in_pause(uint16_t dur_ms)
;
; Busy wait until duration milliseconds have passed or until a
; key is pressed.  If dur_ms == 0, wait forever for a keypress.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

SECTION code_input

PUBLIC asm_in_pause

EXTERN asm_in_wait_key, asm_in_test_key, asm_z80_delay_tstate

asm_in_pause:

   ; enter : hl = duration in milliseconds, 0 = forever
   ;
   ; exit  : keypress caused early exit
   ;
   ;            hl = time remaining in pause in milliseconds
   ;            carry set
   ;
   ;         time expired or dur_ms == 0
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ld a,h
   or l
   jp z, asm_in_wait_key

   ex de,hl
      
pause_loop:

   ; wait for one millisecond then sample the keyboard
   
   ld hl,+(__clock_freq / 1000) - 72 - 27
   call asm_z80_delay_tstate
   
   dec de
   
   ld a,d
   or e
   jr z, exit                  ; if time is up

   call asm_in_test_key
   jr z, pause_loop
   
   ; key is pressed
   
   scf                         ; indicate early exit

exit:

   ex de,hl                    ; hl = time remaining
   ret
