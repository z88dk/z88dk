
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strrev(char *s)
;
; Reverse string in place.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strrev

EXTERN __str_locate_nul

asm_strrev:

   ; enter: hl = char *s
   ;
   ; exit : hl = char *s (reversed)
   ;        bc = 0
   ;
   ; uses : af, bc, de

   ; find end of string and string length
   
   ld e,l
   ld d,h                      ; de = char *s
   
   call __str_locate_nul       ; bc = -strlen(s) - 1
   dec hl                      ; hl = ptr to char prior to terminating 0
      
   push de                     ; save char *s

   ld a,b                      ; bc = ceil(-((-strlen-1)/2)-1)
   sra a                       ;    = ceil((strlen-1)/2)
   rr c                        ; -1 maps to 0 (strlen = 0)
   cpl                         ; -2 maps to 0 (strlen = 1)
   ld b,a                      ; -3 maps to 1 (strlen = 2)
   ld a,c                      ; -4 maps to 1 (strlen = 3)
   cpl                         ; etc, yields number of chars to swap
   ld c,a

   or b
   jr z, exit                  ; if numswaps == 0, exit
   
loop:

   ld a,(de)                   ; char at front of s
   ldi                         ; char at rear written to front of s
   dec hl
   ld (hl),a                   ; char from front written to rear of s 
   dec hl
   
   jp pe, loop
   
exit:

   pop hl                      ; hl = char *s
   ret
