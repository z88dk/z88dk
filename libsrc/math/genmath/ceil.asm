;       Small C+ Math Library
;       ceil(x)


                XLIB    ceil

                LIB     floor
                LIB     odd


;       return -(floor(-x))
.ceil   CALL    odd
        jp      floor
