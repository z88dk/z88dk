
; This table translates key presses into ascii codes.

SECTION rodata_clib
SECTION rodata_input

PUBLIC in_key_translation_table

in_key_translation_table:

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
   ; 9                   [     P     @     O           I

   ; unshifted
   
   defb 'n', '\', 'b', 'c', 'v', 'x', 'z', 255     ; row 0
   defb 'h', 6, 'g', 'd', 'f', 's', 'a', 255       ; row 1
   defb 'u', 'q', 'y', 'r', 't', 'e', 'w', 9       ; row 2
   defb '7', '1', '6', '4', '5', '3', '2', 27      ; row 3
   defb ?, ?, ?, ?, ?, ?, ?, ?                     ; row 4
   defb '8', 255, '9', '-', '0', '^', 12, 255      ; row 5
   defb 'j', 255, 'k', ';', 'l', ':', '
', 255     ; row 6
   defb 3, 10, 9, 11, ?, 8, 13, 255                ; row 7
   defb 'm', 127, ',', '/', '.', 255, ' ', ?       ; row 8
   defb 'i', 255, 'o', '@', 'p', '[', 255, 255     ; row 9

   ; shifted

   defb 'N', '|', 'B', 'C', 'V', 'X', 'Z', 255     ; row 0
   defb 'H', 6, 'G', 'D', 'F', 'S', 'A', 255       ; row 1
   defb 'U', 'Q', 'Y', 'R', 'T', 'E', 'W', 9       ; row 2
   defb 39, '!', '&', '$', '%', '#', '"', 27       ; row 3
   defb ?, ?, ?, ?, ?, ?, ?, ?                     ; row 4
   defb '(', 255, ')', '=', '_', '~', 12, 255      ; row 5
   defb 'J', 255, 'K', '+', 'L', '*', '}', 255     ; row 6
   defb 3, 10, 9, 11, ?, 8, 13, 255                ; row 7
   defb 'M', 127, '<', '?', '>', 255, ' ', ?       ; row 8
   defb 'I', 255, 'O', '`', 'P', '{', 255, 255     ; row 9

   ; ctrl
   ; http://www.siongboon.com/projects/2007-12-08_ascii_code/
   
   defb 14, 28, 2, 3, 22, 24, 26, 255              ; row 0
   defb 8, 6, 7, 4, 6, 19, 1, 255                  ; row 1
   defb 21, 17, 25, 18, 20, 5, 23, 9               ; row 2
   defb 0, 0, $1e, 0, 0, 0, $03, 27                ; row 3
   defb ?, ?, ?, ?, ?, ?, ?, ?                     ; row 4
   defb 0, 255, 0, 31, 0, 30, 12, 255              ; row 5
   defb 10, 255, 11, 0, 12, 0, 29, 255             ; row 6
   defb 3, 10, 9, 11, ?, 8, 13, 255                ; row 7
   defb 13, 127, 0, 0, 0, 255, ' ', ?              ; row 8
   defb 9, 255, 15, 0, 16, 27, 255, 255            ; row 9
   
   ; alt
   ; http://www.siongboon.com/projects/2007-12-08_ascii_code/
   
   defb $31, 0, $30, $2e, $2f, $2d, $2c, 255       ; row 0
   defb $23, 6, $22, $20, $21, $1f, $1e, 255       ; row 1
   defb $16, $10, $15, $13, $14, $12, $11, 9       ; row 2
   defb $7e, $78, $7d, $7b, $7c, $7a, $79, 27      ; row 3
   defb ?, ?, ?, ?, ?, ?, ?, ?                     ; row 4
   defb $7f, 255, $80, $82, $81, 0, 12, 255        ; row 5
   defb $24, 255, $25, 0, $26, 0, 0, 255           ; row 6
   defb 3, 10, 9, 11, ?, 8, 13, 255                ; row 7
   defb $32, 127, 0, 0, 0, 255, ' ', ?             ; row 8
   defb $17, 255, $18, 0, $19, 0, 255, 255         ; row 9
