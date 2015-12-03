
SECTION code_clib
SECTION code_ctype

PUBLIC asm_ispunct

asm_ispunct:

    ; determine if char is punctuation
    
    ; enter : a = char
    ; exit  : carry if not punctuation
    ; uses  : f
    
    cp '!'                     ; !"#$%&'()*+,-./
    ret c
    cp '/' + 1
    ccf
    ret nc
    
    cp ':'                     ; :;<=>?@
    ret c
    cp '@' + 1
    ccf
    ret nc
    
    cp '['                     ; [\]^_`
    ret c
    cp '`' + 1
    ccf
    ret nc
    
    cp '{'                     ; {|}~
    ret c
    cp '~' + 1
    ccf
    
    ret
