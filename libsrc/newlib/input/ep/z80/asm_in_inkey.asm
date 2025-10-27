
; ===============================================================
; Aug 2015
; ===============================================================
; 
; int in_inkey(void)
;
; Read instantaneous state of the keyboard and return ascii code
; if only one key is pressed.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_inkey

EXTERN in_key_translation_table, error_znc, error_zc

asm_in_inkey:

   ; exit : if one key is pressed
   ;
   ;           hl = ascii code
   ;           carry reset
   ;
   ;         if no keys are pressed
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if more than one key is pressed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses : af, bc, de, hl

   ;EP keyboard matrix:
   ;        b7    b6    b5    b4    b3    b2    b1    b0
   ;Row    80H   40H   20H   10H   08H   04H   02H   01H
   ; 0   L.SH.     Z     X     V     C     B     \     N
   ; 1    CTRL     A     S     F     D     G  LOCK     H
   ; 2     TAB     W     E     T     R     Y     Q     U
   ; 3     ESC     2     3     5     4     6     1     7
   ; 4      F1    F2    F7    F5    F6    F3    F8    F4
   ; 5         ERASE     ^     0     -     9           8
   ; 6             
     :     L     ;     K           J
   ; 7     ALT ENTER   LEFT  HOLD   UP   RIGHT DOWN  STOP
   ; 8     INS SPACE R.SH.     .     /     ,   DEL     M
   ; 9                   [     P     @     0           I
 
   ld bc,$09b5
   ld d,$ff
   ld hl,shift_table + 9

hit_loop:

   out (c),b                   ; select key row
   in a,($b5)                  ; read key state active low
   
   or (hl)                     ; ignore shift keys in this row
   dec hl
   
   cp d
   jr nz, key_hit_0            ; if at least one key pressed in row
   
   dec b
   jp p, hit_loop              ; repeat for rows 9 to 0
   
   jp error_znc                ; if no keys pressed

key_hit_0:

   ; at least one key row is active

   ;  a = active low key result
   ;  b = row containing key press
   ;  c = $b5
   ;  d = $ff
   ; hl = shift table address corresponding to key press - 1

   ; find bit position corresponding to key press

   ld e,d

bit_loop:

   inc e
   rrca
   jr c, bit_loop
   
   cp $7f
   jp nz, error_zc             ; if multiple keys pressed

   ; make sure no other rows are active
   
   ;  e = key bit position 0-7
   ;  b = row containing key press
   ;  c = $b5
   ;  d = $ff
   ; hl = shift table address corresponding to key press - 1
   
   ld h,l
   push hl
   
miss_loop:

   dec b
   jp m, key_hit_1             ; if done checking other key rows
   
   out (c),b                   ; select key row
   in a,($b5)                  ; read key state active low
   
   or (hl)                     ; ignore shift keys in this row
   dec hl
   
   cp d
   jr z, miss_loop             ; if no keys pressed in row
   
   jp error_zc - 1             ; if multiple keys pressed

key_hit_1:

   ; exactly one key is pressed
   
   ;     c = $b5
   ;     e = key bit position 0-7
   ;     d = $ff
   ; stack = LSB shift table address corresponding to key press - 1

   pop af                      ; a = LSB of shift table address for key press
   
   sub (shift_table & 0xff) - 1
   add a,a
   add a,a
   add a,a                     ; row offset into table in bytes
   
   add a,e                     ; add key bit offset into table
   
   ld e,a
   inc d                       ; de = key offset into table
   
   ; check for shift modifiers

   ; de = key offset into table 0-79
   
check_LSHIFT:

   xor a
   out ($b5),a                 ; select row 0

   in a,($b5)
   and $80                     ; LSHIFT
   
   ld hl,in_key_translation_table + 80   
   jr z, ascii                 ; if pressed

check_RSHIFT:

   ld a,8
   out ($b5),a                 ; select row 8
   
   in a,($b5)
   and $20                     ; RSHIFT
   jr z, ascii                 ; if pressed

check_CTRL:

   ld a,1
   out ($b5),a                 ; select row 1
   
   in a,($b5)
   and $80                     ; CTRL
   
   ld hl,in_key_translation_table + 160
   jr z, ascii                 ; if pressed

check_ALT:

   ld a,7
   out ($b5),a                 ; select row 7
   
   in a,($b5)
   and $80                     ; ALT
   
   ld hl,in_key_translation_table + 240
   jr z, ascii                 ; if pressed
   
   ; no shift modifiers
   
   ld hl,in_key_translation_table

ascii:

   add hl,de
   
   ld l,(hl)
   ld h,0
   
   ret

shift_table:

   defb $80 ; row 0 ignore LSHIFT
   defb $80 ; row 1 ignore CTRL
   defb $00 ; row 2
   defb $00 ; row 3
   defb $00 ; row 4
   defb $80 ; row 5 ignore unconnected
   defb $80 ; row 6 ignore unconnected
   defb $80 ; row 7 ignore ALT
   defb $20 ; row 8 ignore RSHIFT
   defb $c2 ; row 9 ignore unconnected
