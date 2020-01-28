
; This table translates key presses into ascii codes.
; Also used by 'GetKey' and 'LookupKey'.
; I would like to add lower case letters too but not
; sure how to go about it with just one shift key

SECTION rodata_clib
PUBLIC in_keytranstbl
PUBLIC _in_keytranstbl

.in_keytranstbl
._in_keytranstbl

   ; unshifted

   defb 255,'Z','X','C','V'      ; SHIFT, Z, X, C, V
   defb 'A','S','D','F','G'      ; A, S, D, F, G
   defb 'Q','W','E','R','T'      ; Q, W, E, R, T
   defb '1','2','3','4','5'      ; 1, 2, 3, 4, 5
   defb '0','9','8','7','6'      ; 0, 9, 8, 7, 6
   defb 'P','O','I','U','Y'      ; P, O, I, U, Y
   defb 13,'L','K','J','H'       ; ENTER, L, K, J, H
   defb ' ','.','M','N','B'      ; SPACE, ., M, N, B

   ; shifted

   defb 255,':',';','?','/'      ; SHIFT, Z, X, C, V
   defb '~','|',92,'{','}'       ; A, S, D, F, G
   defb 131,132,133,18,20        ; Q, W, E, R, T
   defb 27,28,29,30,8            ; 1, 2, 3, 4, 5
   defb 12,6,9,11,10             ; 0, 9, 8, 7, 6
   defb 34,')','(','$',25        ; P, O, I, U, Y
   defb 13,'=','+','-','^'       ; ENTER, L, K, J, H
   defb 96,',','>','<','*'       ; SPACE, ., M, N, B
