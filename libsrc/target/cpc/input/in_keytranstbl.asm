
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl


; Custom keys mapped here
; 128 = F1
; 129 = F2
; 130 = F3
; 131 = F4
; 132 = F5
; 133 = F6
; 134 = F7
; 135 = F8
; 136 = F9
; 137 = F0
; 138 = Fdot
; 139 = COPY
; 140 = CLR
; 141 = ENTER
; 6 = CAPSLOCK
; 7 = TAB
; 8 = LEFT
; 9 = RIGHT
; 10 =DOWN
; 11 = UP
; 27 = ESC

.in_keytranstbl


; 10 rows of 8 
    defb    138, 141, 130, 133, 136,  10,   9,  11	;F. ENTER F3 F6 F9 DOWN RIGHT UP
    defb    137, 129, 128, 132, 134, 134, 139,   8	;F0 F2 F1 F5 F8 F7 COPY LEFT
    defb    255,'\\', 255, 131, ']',  13, '[',  140	;CTRL \ SHIFT F4 ] RET [ CLR
    defb    '.', '/', ':', ';', 'p', '@', '-', '^'      ; . / : ; p @ - ^
    defb    ',', 'm', 'k', 'l', 'i', 'o', '9', '0'	; , m k l i o 9 0
    defb    ' ', 'n', 'j', 'h', 'y', 'u', '7' ,'8'	; SP m j h y u 7 8
    defb    'v', 'b', 'f', 'g', 't', 'r', '5', '6'	; v b f g t r 5 6
    defb    'x', 'c', 'd', 's', 'w', 'e', '3', '4'	; x c d s w e 3 4
    defb    'z',   6, 'a',   7, 'q',  27, '2', '1'	; z CAPS a TAB q ESC 2 1
    defb     12, 255, 255, 255, 255, 255, 255, 255	; DEL JOY....

; Shifted
    defb    138, 141, 130, 133, 136,  10,   9,  11	;F. ENTER F3 F6 F9 DOWN RIGHT UP
    defb    137, 129, 128, 132, 134, 134, 139,   8	;F0 F2 F1 F5 F8 F7 COPY LEFT
    defb    255, '`', 255, 131, '}',  13, '{',  140	;CTRL \ SHIFT F4 ] RET [ CLR
    defb    '>', '?', '*', '+', 'P', '|', '=', '~'      ; . / : ; p @ - ^
    defb    '<', 'M', 'K', 'L', 'I', 'O', ')', '_'	; , m k l i o 9 0
    defb    ' ', 'N', 'J', 'H', 'Y', 'U','\'' ,'('	; SP m j h y u 7 8
    defb    'V', 'B', 'F', 'G', 'T', 'R', '%', '&'	; v b f g t r 5 6
    defb    'X', 'C', 'D', 'S', 'W', 'E', '#', '$'	; x c d s w e 3 4
    defb    'Z',   6, 'A',   7, 'Q',  27,'\"', '!'	; z CAPS a TAB q ESC 2 1
    defb    127, 255, 255, 255, 255, 255, 255, 255	; DEL JOY....

; Control
    defb    138, 141, 130, 133, 136,  10,   9,  11	;F. ENTER F3 F6 F9 DOWN RIGHT UP
    defb    137, 129, 128, 132, 134, 134, 139,   8	;F0 F2 F1 F5 F8 F7 COPY LEFT
    defb    255,'\\', 255, 131, ']',  13, '[',  140	;CTRL \ SHIFT F4 ] RET [ CLR
    defb    '.', '/', ':', ';',  16, '@', '-', '^'      ; . / : ; p @ - ^
    defb    ',',  13,  11,  12,   9,  15, '9', '0'	; , m k l i o 9 0
    defb    ' ',  14,  10,   8,  25,  21, '7' ,'8'	; SP m j h y u 7 8
    defb     22,   2,   6,   7,  20,  18, '5', '6'	; v b f g t r 5 6
    defb     24,   3,   4,  19,  23,   5, '3', '4'	; x c d s w e 3 4
    defb     26,   6,   1,   7,  17,  27, '2', '1'	; z CAPS a TAB q ESC 2 1
    defb     12, 255, 255, 255, 255, 255, 255, 255	; DEL JOY....
