
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isupper

asm_isupper:

    ; determine if char is in [A-Z

    
    ; enter : a = char
    ; exit  : carry if not upper
    ; uses  : f
    
    cp 'A'
    ret c
    
    cp 'Z'+1
    ccf
    
    ret
 