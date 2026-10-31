; Sharp MZ-2500 keyboard: the codes for in_Inkey and in_LookupKey
;
; Three tables of 96 (12 columns of 8 keys; the column is the number written to the PIO, the bit is the key's bit in what is read): unshifted,
; SHIFT, and CTRL.  255 is a key with no code.  The matrix is MAME's (mz2500.cpp), the Japanese layout:
; the digits' shifted symbols are ! " # $ % & ', : is next to the digits and ; has + on it.  Cursor keys 11 up, 10 down, 8 left, 9 right,
; RETURN 13, ESC 27, BREAK 3, TAB 7, BACKSPACE 12 (shifted 127), F1-F10 128-137.  (MAME has no shifted ^; ~ is a guess.)

    SECTION rodata_clib
    PUBLIC  in_keytranstbl

in_keytranstbl:
 ; Unshifted
    defb    128, 129, 130, 131, 132, 133, 134, 135              ; F1-F8
    defb    136, 137, '8', '9', ',', '.', '+', '-'              ; F9 F10 pad 8 9 , . + -
    defb    '0', '1', '2', '3', '4', '5', '6', '7'              ; pad 0-7
    defb    7, ' ', 13, 11, 10, 8, 9, 3                         ; TAB SPACE RETURN UP DOWN LEFT RIGHT BREAK
    defb    '/', 'a', 'b', 'c', 'd', 'e', 'f', 'g'              ; / a-g
    defb    'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'              ; h-o
    defb    'p', 'q', 'r', 's', 't', 'u', 'v', 'w'              ; p-w
    defb    'x', 'y', 'z', '^', '\\', '_', '.', ','             ; x y z ^ yen _ . ,
    defb    '0', '1', '2', '3', '4', '5', '6', '7'              ; 0-7
    defb    '8', '9', ':', ';', '-', '@', '[', 255              ; 8 9 : ; - @ [ (unused)
    defb    ']', 255, 255, 255, 12, 27, '*', '/'                ; ] COPY CLR INST BS ESC pad* pad/
    defb    255, 255, 255, 255, 255, 255, 255, 255              ; GRPH SLOCK SHIFT KANA CTRL (modifiers)

 ; SHIFT
    defb    128, 129, 130, 131, 132, 133, 134, 135              ; F1-F8
    defb    136, 137, '8', '9', ',', '.', '+', '-'              ; F9 F10 pad 8 9 , . + -
    defb    '0', '1', '2', '3', '4', '5', '6', '7'              ; pad 0-7
    defb    7, ' ', 13, 11, 10, 8, 9, 3                         ; TAB SPACE RETURN UP DOWN LEFT RIGHT BREAK
    defb    '?', 'A', 'B', 'C', 'D', 'E', 'F', 'G'              ; / a-g
    defb    'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'              ; h-o
    defb    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'              ; p-w
    defb    'X', 'Y', 'Z', '~', '|', '_', '>', '<'              ; x y z ^ yen _ . ,
    defb    '0', '!', '\"', '#', '$', '%', '&', '\''            ; 0-7
    defb    '(', ')', '*', '+', '=', '`', '{', 255              ; 8 9 : ; - @ [ (unused)
    defb    '}', 255, 255, 255, 127, 27, '*', '/'               ; ] COPY CLR INST BS ESC pad* pad/
    defb    255, 255, 255, 255, 255, 255, 255, 255              ; GRPH SLOCK SHIFT KANA CTRL (modifiers)

 ; CTRL
    defb    128, 129, 130, 131, 132, 133, 134, 135              ; F1-F8
    defb    136, 137, '8', '9', ',', '.', '+', '-'              ; F9 F10 pad 8 9 , . + -
    defb    '0', '1', '2', '3', '4', '5', '6', '7'              ; pad 0-7
    defb    7, ' ', 13, 11, 10, 8, 9, 3                         ; TAB SPACE RETURN UP DOWN LEFT RIGHT BREAK
    defb    '/', 1, 2, 3, 4, 5, 6, 7                            ; / a-g
    defb    8, 9, 10, 11, 12, 13, 14, 15                        ; h-o
    defb    16, 17, 18, 19, 20, 21, 22, 23                      ; p-w
    defb    24, 25, 26, '^', '\\', '_', '.', ','                ; x y z ^ yen _ . ,
    defb    '0', '1', '2', '3', '4', '5', '6', '7'              ; 0-7
    defb    '8', '9', ':', ';', '-', '@', '[', 255              ; 8 9 : ; - @ [ (unused)
    defb    ']', 255, 255, 255, 12, 27, '*', '/'                ; ] COPY CLR INST BS ESC pad* pad/
    defb    255, 255, 255, 255, 255, 255, 255, 255              ; GRPH SLOCK SHIFT KANA CTRL (modifiers)

