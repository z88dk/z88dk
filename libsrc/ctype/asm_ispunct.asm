; asm_ispunct

XLIB asm_ispunct

IF FORrcmx000
LIB  rcmx_cpir
ENDIF

; determine if the char is punctuation

; enter : a = char
; exit  : P/V reset = not punctuation
; uses  : f, bc, hl

.asm_ispunct

   ld hl,punc_tbl
   ld bc,punc_end - punc_tbl
IF FORrcmx000
   call rcmx_cpir
ELSE
   cpir
ENDIF
   ret

.punc_tbl

   defm "!$%^&*()_+={[]}#~'@;:/?.>,<\|"
   defb 34,163,163           ; quote and pound, must repeat last one

.punc_end
