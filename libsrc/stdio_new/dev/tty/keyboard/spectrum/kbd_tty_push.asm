; void kbd_tty_push(struct kbd_state_tty *)
; 08.2009 aralbrec

PUBLIC kbd_tty_push
EXTERN kbd_getkey

; Should be called from within the 50 Hz interrupt routine.
; Pushes keypresses to the attached tty driver.
;
; struct kbd_state_tty
; {
;    uchar  res0;               // 33  : LD HL,nn
;    void  *tty_arg;            // tty driver parameter
;    uchar  res1;               // 195 : JP nn
;    void  *tty_pushchar;       // tty driver push address
;    struct kbd_state;          // see kbd_getkey()
; }
;
; enter : hl = struct kbd_state_tty *
; uses  : af, bc, de, hl

.kbd_tty_push

   push hl                     ; save struct kbd_state_tty *
   ld bc,6
   add hl,bc                   ; hl = & struct kbd_state
   
   call kbd_getkey             ; a = ascii code of keypress
   ret nc                      ; jump to tty driver push code if key pressed
   
   pop hl
   ret
