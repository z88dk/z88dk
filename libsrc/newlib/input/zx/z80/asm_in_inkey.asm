
; ===============================================================
; Sep 2005, improved Apr 2014
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

   ; locate a key row with key active
   
   ld bc,$fefe                 ; key port, first row selected
   ld de,$0500                 ; e = offset into key translation table
   ld hl,$ffe0                 ; constant used in loop

   ; first row contains CAPS shift
   
   in a,(c)
   or $e1                      ; ignore CAPS shift
   cp h
   jr nz, keyhit_0             ; if key is pressed in this row

   ld e,d
   ld b,$fd
   
row_loop:

   in a,(c)
   or l
   cp h
   jr nz, keyhit_0             ; if key is pressed in this row

   ld a,e
   add a,d
   ld e,a                      ; increase index into key translation table
   
   rlc b
   jp m, row_loop              ; if key row is not the last one

   ; last row contains SYM shift
   
   in a,(c)
   or $e2                      ; ignore SYM shift
   cp h
   ld c,a
   jr nz, keyhit_1             ; if key is pressed in this row

   jp error_znc                ; if no keys pressed

keyhit_0:

   ; at least one key row is active
   ; make sure no others are active
   
   ld c,a
   
   ;  c = key result
   ;  b = key row containing keypress
   ;  e = index into key translation table for row
   ; hl = $ffe0
   ;  d = 5
   
   ld a,b
   cpl
   or $81
   
   in a,($fe)                  ; look at all other rows except CAPS/SYM rows
   or l
   cp h
   jp nz, error_zc             ; if more than one key pressed
   
   ld a,$7f
   in a,($fe)                  ; read SYM shift row
   or $e2                      ; ignore sym shift
   cp h
   jp nz, error_zc             ; if key in sym shift row pressed
   
keyhit_1:

   ; only one key row is active
   ; determine ascii code from translation table
   
   ;  c = key result
   ;  e = index into key translation table for row
   ;  d = 5
   
   ld b,0
   ld hl,rowtable - $e0
   add hl,bc
   
   ld a,(hl)
   cp d
   jp nc, error_zc             ; if more than one key is pressed in row
   
   add a,e
   ld e,a                      ; e = index into key translation table for key
   
   ld hl,in_key_translation_table
   ld d,b
   add hl,de
   
   ; check for shift modifiers

check_caps:

   ld a,$fe
   in a,($fe)
   and $01
   jr nz, check_sym
   
   ld e,40
   add hl,de

check_sym:

   ld a,$7f
   in a,($fe)
   and $02
   jr nz, ascii
   
   ld e,80
   add hl,de

ascii:

   ld l,(hl)
   ld h,b
   
   ret

rowtable:

   defb 255,255,255,255,255,255,255
   defb 255,255,255,255,255,255,255,255
   defb 4,255,255,255,255,255,255
   defb 255,3,255,255,255,2,255,1
   defb 0,255
