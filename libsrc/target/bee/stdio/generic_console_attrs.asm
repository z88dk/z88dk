SECTION code_clib

PUBLIC generic_console_set_attribute
PUBLIC generic_console_set_paper
PUBLIC generic_console_set_ink

EXTERN __bee_attr
EXTERN  __CLIB_CONIO_NATIVE_COLOUR
EXTERN  __CLIB_BEE_PREMIUM


set_paper_standard:
    ld      hl,table_standard_paper
    call    conio_map_colour2
    rrca
    rrca 
    rrca
    and     @11100000
    ld      c,a
    ld      b,@0011111
    jr      set_attr

generic_console_set_paper:
    ld      c,__CLIB_BEE_PREMIUM
    rr      c
    jr      nc,set_paper_standard
    call    conio_map_colour_premium
    rlca
    rlca
    rlca
    rlca
    and     @11110000
    ld      c,a
    ld      b,15
set_attr:
    ld      hl,__bee_attr
    ld      a,(hl)
    and     b
    or      c
    ld      (hl),a
generic_console_set_attribute:
    ret

set_ink_standard:
    ld      hl,table_standard_ink
    call    conio_map_colour2
    and     31
    ld      c,a
    ld      b,@11100000
    jr      set_attr	

generic_console_set_ink:
    ld      c,__CLIB_BEE_PREMIUM
    rr      c
    jr      nc,set_ink_standard
    call    conio_map_colour_premium
    and     15
    ld      c,a
    ld      b,240
    jr      set_attr



conio_map_colour_premium:
    ld      hl,table
conio_map_colour2:
    ld      c,__CLIB_CONIO_NATIVE_COLOUR
    rr      c
    ret     c
    and     15
    ld      c,a
    ld      b,0
    add     hl,bc
    ld      a,(hl)
    ret

    SECTION	rodata_clib
table:
    defb    $0	;BLACK -> BLACK
    defb    $4	;BLUE -> BLUE
    defb    $2	;GREEN -> GREEN
    defb    $6	;CYAN -> CYAN
    defb    $1	;RED -> RED
    defb    $5	;MAGENTA -> MAGENTA
    defb    $3	;BROWN -> DARK YELLOW
    defb    $7	;LIGHTGRAY -> WHITE
    defb    $8	;DARKGRAY -> GRAY?
    defb    $c	;LIGHTBLUE -> BRIGHT BLUE
    defb    $a	;LIGHTGREEN -> BRIGHT GREEN
    defb    $e	;LIGHTCYAN -> BRIGHT CYAN
    defb    $9	;LIGHTRED -> BRIGHT RED
    defb    $d	;LIGHTMAGENTA -> BRIGHT MAGENTA
    defb    $b	;YELLOW -> BRIGHT YELLOW
    defb    $f	;WHITE -> BRIGHT WHITE

table_standard_ink:
    defb    0	;BLACK -> BLACK
    defb    1	;BLUE -> BLUE
    defb    2	;GREEN -> GREEN
    defb    3	;CYAN -> CYAN
    defb    4	;RED -> RED
    defb    5	;MAGENTA -> MAGENTA
    defb    18 	;BROWN -> DARK YELLOW
    defb    28  ;LIGHTGRAY -> WHITE
    defb    26  ;DARKGRAY -> GRAY?
    defb    8	;LIGHTBLUE -> BRIGHT BLUE
    defb    9	;LIGHTGREEN -> BRIGHT GREEN
    defb    28 	;LIGHTCYAN -> BRIGHT CYAN
    defb    20 	;LIGHTRED -> BRIGHT RED
    defb    21 	;LIGHTMAGENTA -> BRIGHT MAGENTA
    defb    6	;YELLOW -> BRIGHT YELLOW
    defb    7	;WHITE -> BRIGHT WHITE

table_standard_paper:
    defb    0	;BLACK -> BLACK
    defb    4	;BLUE -> BLUE
    defb    2	;GREEN -> GREEN
    defb    6	;CYAN -> CYAN
    defb    1	;RED -> RED
    defb    5	;MAGENTA -> MAGENTA
    defb    1  	;BROWN -> DARK YELLOW
    defb    7   ;LIGHTGRAY -> WHITE
    defb    7   ;DARKGRAY -> GRAY?
    defb    4	;LIGHTBLUE -> BRIGHT BLUE
    defb    2   ;LIGHTGREEN -> BRIGHT GREEN
    defb    6  	;LIGHTCYAN -> BRIGHT CYAN
    defb    1  	;LIGHTRED -> BRIGHT RED
    defb    5  	;LIGHTMAGENTA -> BRIGHT MAGENTA
    defb    3	;YELLOW -> BRIGHT YELLOW
    defb    7	;WHITE -> BRIGHT WHITE

