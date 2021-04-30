
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL' key

SECTION rodata_clib
PUBLIC in_keytranstbl


; Custom keys mapped here
; 128 = F1
; 138 = F11
; 148 = F21
; 158 = F31

; Keypad codes from 170
; 170 = KP Space
; 171 = KP Tab
; 172 = KP Enter
; 173 = KP Enter
; 174 = KP F1
; 175 = KP F2
; 176 = KP F3
; 177 = KP F4
; 178 = KP Home
; 179 = KP Left
; 180 = KP Up
; 181 = KP Right
; 182 = KP Left
; 183 = KP Prior
; 184 = KP Page up
; 185 = KP Next
; 186 = KP Page down
; 187 = KP End
; 188 = KP Insert
; 189 = KP Delete
; 190 = KP Equal
; 191 = KP Multiply
; 192 = KP ADd
; 193 = KP Separator
; 194 = KP Subtract
; 195 = KP Decimal
; 196 = KP Divide
; 197 = KP 0
; 198 = KP 1
; 199 = KP 2
; 200 = KP 3
; 201 = KP 4
; 202 = KP 5
; 203 = KP 6
; 204 = KP 7
; 205 = KP 8
; 206 = KP 9


; Modifiers
;
; 240 = Lshift
; 241 = rshift
; 242 = lcontrol
; 243 = rcontrol
;   6 = capslock (or 244)
; 245 = shift lock
; 246 = lmeta
; 247 = rmeta
; 248 = lalt
; 249 = ralt
; Super/hyper?
; 255 = no key


; This table contains universal 

.in_keytranstbl


; 16 rows of 8 

;Unshifted
    defb    $c0, '1', '9', 'e', '[', 'g', 255, ','	;LMB 1 9 e [ g LSH ,
    defb    $c1, '2', '0', 'r', '+', 'h', 'z', '.'	;RMB 2 0 r + h z .
    defb    $c2, '3','\'', 't', 255, 'j', 'x', '-'	;MO-U 3 ' t INS j x -
    defb    $c3, '4', ']', 'y',   6, 'k', 'c',  11	;MO-L 4 ] y CAPS k c UP
    defb    $c4, '5',  12, 'u', 'a', 'l', 'v', 255	;MO-R 5 BS u a l v RSH
    defb    $c5, '6',  27, 'i', 's','\\', 'b', 255	;MO-D 6 ESC i s \ b HELP
    defb    255, '7', 'q', 'o', 'd', '/', 'n', 255	;F10 7 q o d / n SYMBOL
    defb    255, '8', 'w', 'p', 'f',  13, 'm', 255	;OFF 8 w p f RET m ANS
    defb    ' ', 128, 129, 255, 255, 255, 255, 255	;SP WORD PLAYER UN UN UN UN UN
    defb    255, 130, 131, 255, 255, 255, 255, 255	;LALT MATH LEVEL UN UN UN UN UN
    defb    255, 132, 133, 255, 255, 255, 255, 255	;RPT TRIVIA CART UN UN UN UN UN
    defb      8, 134, 135, 255, 255, 255, 255, 255	;LEFT LOGIC BUSBASICS UN UN UN UN UN
    defb     10, 255, 255, 255, 255, 255, 255, 255	;DOWN UN UN UN UN UN UN UN
    defb      9, 255, 255, 255, 255, 255, 255, 255	;RIGHT UN UN UN UN UN UN UN
    defb    $c6, 255, 255, 255, 255, 255, 255, 255	;LMB (KEY) UN UN UN UN UN UN UN
    defb    $c7, 255, 255, 255, 255, 255, 255, 255	;RMB (KEY) UN UN UN UN UN UN UN
; Shifted
    defb    $c0, '!', '(', 'E', '{', 'g', 255, '<'	;LMB 1 9 e [ g LSH ,
    defb    $c1, '@', ')', 'R', '=', 'H', 'Z', '>'	;RMB 2 0 r + h z .
    defb    $c2, '#','\'', 'T', 255, 'J', 'X', '_'	;MO-U 3 ' t INS j x -
    defb    $c3, '$', '}', 'Y',   6, 'K', 'C',  11	;MO-L 4 ] y CAPS k c UP
    defb    $c4, '%', 127, 'U', 'A', 'L', 'V', 255	;MO-R 5 BS u a l v RSH
    defb    $c5, '^',  27, 'I', 'S', '|', 'B', 255	;MO-D 6 ESC i s \ b HELP
    defb    255, '&', 'Q', 'O', 'D', '?', 'N', 255	;F10 7 q o d / n SYMBOL
    defb    255, '*', 'W', 'P', 'F',  13, 'M', 255	;OFF 8 w p f RET m ANS
    defb    ' ', 128, 129, 255, 255, 255, 255, 255	;SP WORD PLAYER UN UN UN UN UN
    defb    255, 130, 131, 255, 255, 255, 255, 255	;LALT MATH LEVEL UN UN UN UN UN
    defb    255, 132, 133, 255, 255, 255, 255, 255	;RPT TRIVIA CART UN UN UN UN UN
    defb      8, 134, 135, 255, 255, 255, 255, 255	;LEFT LOGIC BUSBASICS UN UN UN UN UN
    defb     10, 255, 255, 255, 255, 255, 255, 255	;DOWN UN UN UN UN UN UN UN
    defb      9, 255, 255, 255, 255, 255, 255, 255	;RIGHT UN UN UN UN UN UN UN
    defb    $c6, 255, 255, 255, 255, 255, 255, 255	;LMB (KEY) UN UN UN UN UN UN UN
    defb    $c7, 255, 255, 255, 255, 255, 255, 255	;RMB (KEY) UN UN UN UN UN UN UN
; Ctrl (LALT)
    defb    $c0, '1', '9', 'e', '[', 'g', 255, ','	;LMB 1 9 e [ g LSH ,
    defb    $c1, '2', '0', 'r', '+', 'h', 'z', '.'	;RMB 2 0 r + h z .
    defb    $c2, '3','\'', 't', 255, 'j', 'x', '-'	;MO-U 3 ' t INS j x -
    defb    $c3, '4', ']', 'y',   6, 'k', 'c',  11	;MO-L 4 ] y CAPS k c UP
    defb    $c4, '5',  12, 'u', 'a', 'l', 'v', 255	;MO-R 5 BS u a l v RSH
    defb    $c5, '6',  27, 'i', 's','\\', 'b', 255	;MO-D 6 ESC i s \ b HELP
    defb    255, '7', 'q', 'o', 'd', '/', 'n', 255	;F10 7 q o d / n SYMBOL
    defb    255, '8', 'w', 'p', 'f',  13, 'm', 255	;OFF 8 w p f RET m ANS
    defb    ' ', 128, 129, 255, 255, 255, 255, 255	;SP WORD PLAYER UN UN UN UN UN
    defb    255, 130, 131, 255, 255, 255, 255, 255	;LALT MATH LEVEL UN UN UN UN UN
    defb    255, 132, 133, 255, 255, 255, 255, 255	;RPT TRIVIA CART UN UN UN UN UN
    defb      8, 134, 135, 255, 255, 255, 255, 255	;LEFT LOGIC BUSBASICS UN UN UN UN UN
    defb     10, 255, 255, 255, 255, 255, 255, 255	;DOWN UN UN UN UN UN UN UN
    defb      9, 255, 255, 255, 255, 255, 255, 255	;RIGHT UN UN UN UN UN UN UN
    defb    $c6, 255, 255, 255, 255, 255, 255, 255	;LMB (KEY) UN UN UN UN UN UN UN
    defb    $c7, 255, 255, 255, 255, 255, 255, 255	;RMB (KEY) UN UN UN UN UN UN UN
