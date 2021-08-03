
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL'
; key represented by CAPS SHIFT + SYM SHIFT.

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl
   defb	 255, 255,  27, 255,   6, '.', '/', '|'   ; RSH SQR ESC INDEX CAPS . / £
   defb	 255, 255,   7, 255, 255, ',', ';', '\''  ; HELP LSH TAB DIA MENU , ; '
   defb	 '[', ' ', '1', 'q', 'a', 'z', 'l', '0'   ;[ SP 1 q a z l 0
   defb  ']',   8, '2', 'w', 's', 'x', 'm', 'p'   ;] LEFT 2 w s x m p
   defb  '-',   9, '3', 'e', 'd', 'c', 'k', '9'   ;- RIGH 3 e d c k 9
   defb  '=',  10, '4', 'r', 'f', 'v', 'j', 'o'   ;= DOWN 4 r f v j o
   defb '\\',  11, '5', 't', 'g', 'b', 'u', 'i'   ;\ UP 5 t g b u i
   defb   12,  13, '6', 'y', 'h', 'n', '7', '8'   ;DEL ENTER 6 y h n 6 7

   ;Shifted
   defb	 255, 255,  27, 255,   6, '>', '?', '~'   ; RSH SQR ESC INDEX CAPS . / £
   defb	 255, 255,   7, 255, 255, '<', ':', '\"'  ; HELP LSH TAB DIA MENU , ; '
   defb	 '{', ' ', '!', 'Q', 'A', 'Z', 'L', ')'   ;[ SP 1 q a z l 0
   defb  '}',   8, '@', 'W', 'S', 'X', 'M', 'P'   ;] LEFT 2 w s x m p
   defb  '-',   9, '#', 'E', 'D', 'C', 'K', '('   ;- RIGH 3 e d c k 9
   defb  '=',  10, '$', 'R', 'F', 'V', 'J', 'O'   ;= DOWN 4 r f v j o
   defb '\\',  11, '%', 'T', 'G', 'B', 'U', 'I'   ;\ UP 5 t g b u i
   defb  127,  13, '^', 'Y', 'H', 'N', '&', '*'   ;DEL ENTER 6 y h n 6 7

   ;Control
   defb	 255, 255,  27, 255,   6, '.', '/', '|'   ; RSH SQR ESC INDEX CAPS . / £
   defb	 255, 255,   7, 255, 255, ',', ';', '\''  ; HELP LSH TAB DIA MENU , ; '
   defb	 '[', ' ', '1',  17,   1,  26,  12, '0'   ;[ SP 1 q a z l 0
   defb  ']',   8, '2',  23,  19,  24,  13,  16   ;] LEFT 2 w s x m p
   defb  '-',   9, '3',   5,   4,   3,  11, '9'   ;- RIGH 3 e d c k 9
   defb  '=',  10, '4',  18,   6,  22,  10,  15   ;= DOWN 4 r f v j o
   defb '\\',  11, '5',  20,   7,   2,  21,   9   ;\ UP 5 t g b u i
   defb   12,  13, '6',  25,   8,  14, '7', '8'   ;DEL ENTER 6 y h n 6 7
