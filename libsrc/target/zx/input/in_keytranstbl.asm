
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.  An effort has been made for
; this key translation table to emulate a PC keyboard with the 'CTRL'
; key represented by CAPS SHIFT + SYM SHIFT.

SECTION rodata_clib
PUBLIC in_keytranstbl

.in_keytranstbl
   defb 255,'z','x','c','v'      ; CAPS SHIFT, Z, X, C, V
   defb 'a','s','d','f','g'      ; A, S, D, F, G
   defb 'q','w','e','r','t'      ; Q, W, E, R, T
   defb '1','2','3','4','5'      ; 1, 2, 3, 4, 5
   defb '0','9','8','7','6'      ; 0, 9, 8, 7, 6
   defb 'p','o','i','u','y'      ; P, O, I, U, Y
   defb 13,'l','k','j','h'       ; ENTER, L, K, J, H
   defb ' ',255,'m','n','b'      ; SPACE, SYM SHIFT, M, N, B

   ; the following are CAPS SHIFTed

   defb 255,'Z','X','C','V'      ; CAPS SHIFT, Z, X, C, V
   defb 'A','S','D','F','G'      ; A, S, D, F, G
   defb 'Q','W','E','R','T'      ; Q, W, E, R, T
   defb 7,6,128,129,8            ; 1, 2, 3, 4, 5
   defb 12,0,9,11,10             ; 0, 9, 8, 7, 6
   defb 'P','O','I','U','Y'      ; P, O, I, U, Y
   defb 13,'L','K','J','H'       ; ENTER, L, K, J, H
   defb ' ',255,'M','N','B'      ; SPACE, SYM SHIFT, M, N, B

   ; the following are SYM SHIFTed

   defb 255,':',96,'?','/'       ; CAPS SHIFT, Z, X, C, V
   defb '~','|',92,'{','}'       ; A, S, D, F, G
   defb 131,132,133,'<','>'      ; Q, W, E, R, T
   defb '!','@','#','$','%'      ; 1, 2, 3, 4, 5
   defb '_',')','(',39,'&'       ; 0, 9, 8, 7, 6
   defb 34,';',130,']','['       ; P, O, I, U, Y
   defb 13,'=','+','-','^'       ; ENTER, L, K, J, H
   defb ' ',255,'.',',','*'      ; SPACE, SYM SHIFT, M, N, B

   ; the following are CAPS SHIFTed and SYM SHIFTed ("CTRL" key)

   defb 255,26,24,3,22           ; CAPS SHIFT, Z, X, C, V
   defb 1,19,4,6,7               ; A, S, D, F, G
   defb 17,23,5,18,20            ; Q, W, E, R, T
   defb 27,28,29,30,31           ; 1, 2, 3, 4, 5
   defb 127,255,134,'`',135      ; 0, 9, 8, 7, 6
   defb 16,15,9,21,25            ; P, O, I, U, Y
   defb 13,12,11,10,8            ; ENTER, L, K, J, H
   defb ' ',255,13,14,2          ; SPACE, SYM SHIFT, M, N, B
