
; Keyboard joysticks for joystick() in <games.h>, which uses the inkey driver.
;
; Each key is a scan code for in_KeyPressed(): the mask of the key in the
; high byte and the row of the keyboard matrix in the low byte (bit 7 of the
; row means that shift has to be held). The order is right, left, down, up,
; fire, fire2.
;
; The keyboard matrix is on ports $00 - $09:
;   row 0: 0 1 2 3 4 5 6 7 (keypad)      row 5: x y z [ \ ] ^ -
;   row 1: 8 9 * + = , . return (keypad) row 6: 0 1 2 3 4 5 6 7
;   row 2: @ a b c d e f g               row 7: 8 9 : ; , . / _
;   row 3: h i j k l m n o               row 8: home up right del grph kana shift ctrl
;   row 4: p q r s t u v w               row 9: stop f1 f2 f3 f4 f5 space esc
;
; The machine only has up and right cursor keys, down and left are shift
; with them.

    SECTION rodata_clib
    PUBLIC  keys_cursor
    PUBLIC  keys_qaop
    PUBLIC  keys_vi
    PUBLIC  keys_8246

; The cursor keys and space
keys_cursor:
    defw    $0408                       ;right
    defw    $0488                       ;left (shift + right)
    defw    $0288                       ;down (shift + up)
    defw    $0208                       ;up
    defw    $4009                       ;fire (space)
    defw    $0000

; qaop, m and n
keys_qaop:
    defw    $0104                       ;p
    defw    $8003                       ;o
    defw    $0202                       ;a
    defw    $0204                       ;q
    defw    $2003                       ;m
    defw    $4003                       ;n
    defw    $0000

; hjkl, s and d
keys_vi:
    defw    $1003                       ;l
    defw    $0103                       ;h
    defw    $0403                       ;j
    defw    $0803                       ;k
    defw    $0804                       ;s
    defw    $1002                       ;d
    defw    $0000

; The keypad: 6, 4, 2, 8, 5 and 0
keys_8246:
    defw    $4000                       ;6
    defw    $1000                       ;4
    defw    $0400                       ;2
    defw    $0101                       ;8
    defw    $2000                       ;5
    defw    $0100                       ;0
    defw    $0000
