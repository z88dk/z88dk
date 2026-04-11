#rept ; no expression
#endr
#rept *3 ; syntax error in expression
#endr
#rept ASMPC ; not constant expression
#endr
#rept 1 extra ; extra tokens after expression
#endr
#rept 1 ; no endr
