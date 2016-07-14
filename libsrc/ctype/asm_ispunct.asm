; asm_ispunct

        SECTION code_clib

PUBLIC asm_ispunct

IF FORrcmx000
EXTERN  rcmx_cpir
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

   defm "!$%^&*()_-+={[]}#~'`@;:/?.>,<\\|/"
   defb 34,34		; quote (pound isn't punctuation)

.punc_end
