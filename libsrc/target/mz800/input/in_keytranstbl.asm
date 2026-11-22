; Sharp MZ-800 keyboard: the codes for in_Inkey and in_LookupKey
;
; Three tables of 80 (10 strobes of 8 keys; the strobe is written to the 8255's port A, the bit is the key's in port B): unshifted, SHIFT, CTRL.  255 = no code.  The matrix is MAME's
; (mz700.cpp).  Cursor keys 11 up, 10 down, 8 left, 9 right, RETURN 13, BREAK 12 like DEL (an emulator's Backspace is the BREAK key: Takeda maps it so), SHIFT+BREAK 27 (the machine has no ESC), DEL 12 (shifted 127), F1-F5 128-132.  No code: Alpha, Graph, the
; yen/pound key, INST/CLR, HOME.

    SECTION rodata_clib
    PUBLIC  in_keytranstbl

in_keytranstbl:
 ; Unshifted
    defb    13, ':', ';', 255, 255, 255, 255, '_'              ; 0: CR : ; (unused) Alpha pound Graph _
    defb    255, 255, 255, ']', '[', '@', 'z', 'y'              ; 1
    defb    'x', 'w', 'v', 'u', 't', 's', 'r', 'q'              ; 2
    defb    'p', 'o', 'n', 'm', 'l', 'k', 'j', 'i'              ; 3
    defb    'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a'              ; 4
    defb    '8', '7', '6', '5', '4', '3', '2', '1'              ; 5
    defb    '.', ',', '9', '0', ' ', '-', '^', '\\'             ; 6
    defb    '/', '?', 8, 9, 10, 11, 12, 255                     ; 7: / ? left right down up DEL INST
    defb    255, 255, 255, 255, 255, 255, 255, 12               ; 8: SHIFT ... CTRL BREAK (delete)
    defb    255, 255, 255, 132, 131, 130, 129, 128              ; 9: F5 F4 F3 F2 F1

 ; SHIFT
    defb    13, '*', '+', 255, 255, 255, 255, '_'
    defb    255, 255, 255, '}', '{', '`', 'Z', 'Y'
    defb    'X', 'W', 'V', 'U', 'T', 'S', 'R', 'Q'
    defb    'P', 'O', 'N', 'M', 'L', 'K', 'J', 'I'
    defb    'H', 'G', 'F', 'E', 'D', 'C', 'B', 'A'
    defb    '(', 39, '&', '%', '$', '#', '"', '!'              ; (39 is the apostrophe)
    defb    '>', '<', ')', '0', ' ', '=', '~', '|'
    defb    '/', '?', 8, 9, 10, 11, 127, 255
    defb    255, 255, 255, 255, 255, 255, 255, 27               ; (SHIFT+BREAK: Esc)
    defb    255, 255, 255, 132, 131, 130, 129, 128

 ; CTRL
    defb    13, ':', ';', 255, 255, 255, 255, '_'
    defb    255, 255, 255, ']', '[', '@', 26, 25
    defb    24, 23, 22, 21, 20, 19, 18, 17
    defb    16, 15, 14, 13, 12, 11, 10, 9
    defb    8, 7, 6, 5, 4, 3, 2, 1
    defb    '8', '7', '6', '5', '4', '3', '2', '1'
    defb    '.', ',', '9', '0', ' ', '-', '^', '\\'
    defb    '/', '?', 8, 9, 10, 11, 12, 255
    defb    255, 255, 255, 255, 255, 255, 255, 12
    defb    255, 255, 255, 132, 131, 130, 129, 128
