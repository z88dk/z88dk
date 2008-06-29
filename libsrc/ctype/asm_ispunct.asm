; asm_ispunct

XLIB asm_ispunct

; determine if the char is punctuation

; enter : a = char
; exit  : P/V reset = not punctuation
; uses  : f, bc, hl

.asm_ispunct

   ld hl,punc_tbl
   ld bc,punc_end - punc_tbl
   cpir
   ret

.punc_tbl

   defm "!$%^&*()_+={[]}#~'@;:/?.>,<\|"
   defb 34,163,163           ; quote and pound, must repeat last one

.punc_end
