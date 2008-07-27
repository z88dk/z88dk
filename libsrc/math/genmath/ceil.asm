;       Small C+ Math Library
;       ceil(x)


                XLIB    ceil

                LIB     floor
                LIB	odd


;       return -(floor(-x))
.CEIL   CALL    ODD
        jp      floor
