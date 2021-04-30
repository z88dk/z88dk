

    SECTION rodata_clib
    PUBLIC  in_keytranstbl

; 4 tables of 72 -> 288 bytes
in_keytranstbl:
 ; Unshifted/unmodified
    defb    255, 'z', 'x', 'c', 'v', 128, 129, 130    ; SHIFT z x c v F1 F2 F3
    defb    'a', 's', 'd', 'f', 'g', 131, 132, 133    ; a s d f g F4 F5 F6
    defb    'q', 'w', 'e', 'r', 't', 134, 135, 136    ; q w e r t F7 F8 F9
    defb    '1', '2', '3', '4', '5',  27,   7,   6    ; 1 2 3 4 5 ESC TAB CAPSLOCK
    defb    '0', '9', '8', '7', '6', '-', '+',  12    ; 0 9 8 7 6 - + BS
    defb    'p', 'o', 'i', 'u', 'y', '=','\"', 137    ; [ p o u y = " F0
    defb     13, 'l', 'k', 'j', 'h', ';', ':',   7    ; RET l k j h ; : EDIT
    defb    ' ', 255, 'm', 'n', 'b', ',', '.','\\'    ; SP SYM m n b , . \
    defb    255,  11,  10,   8,   9, 255, 255, 255    ; CTRL UP DOWN LEFT RIGHT UN UN UN

; Shifted (Caps)
    defb    255, 'Z', 'X', 'C', 'V', 128, 129, 130    ; SHIFT z x c v F1 F2 F3
    defb    'A', 'S', 'D', 'F', 'G', 131, 132, 133    ; a s d f g F4 F5 F6
    defb    'Q', 'W', 'E', 'R', 'T', 134, 135, 136    ; q w e r t F7 F8 F9
    defb    '!', '@', '#', '$', '%',  27,   7,   6    ; 1 2 3 4 5 ESC TAB CAPSLOCK
    defb    '~', ')', '(','\'', '&', '/', '+', 127    ; 0 9 8 7 6 - + BS
    defb    'P', 'O', 'I', 'U', 'Y', '_', '^', 137    ; [ p o u y = " F0
    defb     13, 'L', 'K', 'J', 'H', '[', ']',   7    ; RET l k j h ; : EDIT
    defb    ' ', 255, 'M', 'N', 'B', '<', '>', '?'    ; SP SYM m n b , . \
    defb    255,  11,  10,   8,   9, 255, 255, 255    ; CTRL UP DOWN LEFT RIGHT UN UN UN

 ; Symbol shift 
    defb    255, 'z', 'x', 'c', 'v', 128, 129, 130    ; SHIFT z x c v F1 F2 F3
    defb    'a', 's', 'd', '{', '}', 131, 132, 133    ; a s d f g F4 F5 F6
    defb    '<', '>', 'e', '[', ']', 134, 135, 136    ; q w e r t F7 F8 F9
    defb      7,   6, '3', '4',   8,  27,   7,   6    ; 1 2 3 4 5 ESC TAB CAPSLOCK
    defb     12,   0,   9,  11,  10, '-', '+',  12    ; 0 9 8 7 6 - + BS
    defb    'p', 'o', 'i', 'u', 'y', '=','\"', 137    ; [ p o u y = " F0
    defb     13, '|', 'k', 'j', '^', '{', '}',   7    ; RET l k j h ; : EDIT
    defb    ' ', 255, 'm', 'n', 'b', ',', '.','\\'    ; SP SYM m n b , . \
    defb    255,  11,  10,   8,   9, 255, 255, 255    ; CTRL UP DOWN LEFT RIGHT UN UN UN

 ; Control
    defb    255,  26,  24,   3,  22, 128, 129, 130    ; SHIFT z x c v F1 F2 F3
    defb      1,  19,   4,   6,   7, 131, 132, 133    ; a s d f g F4 F5 F6
    defb     17,  23,   5,  18,  20, 134, 135, 136    ; q w e r t F7 F8 F9
    defb    '1', '2', '3', '4', '5',  27,   7,   6    ; 1 2 3 4 5 ESC TAB CAPSLOCK
    defb    '0', '9', '8', '7', '6', '-', '+',  12    ; 0 9 8 7 6 - + BS
    defb     16,  15,   9,  21,  25, '=','\"', 137    ; [ p o u y = " F0
    defb     13,  12,  11,  10,   8, '{', '}',   7    ; RET l k j h ; : EDIT
    defb    ' ', 255,  13,  14,   2, ',', '.', '|'    ; SP SYM m n b , . \
    defb    255,  11,  10,   8,   9, 255, 255, 255    ; CTRL UP DOWN LEFT RIGHT UN UN UN

