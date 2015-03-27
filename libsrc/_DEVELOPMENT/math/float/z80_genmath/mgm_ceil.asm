;       Small C+ Math Library
;       ceil(x)


                PUBLIC    ceil

                EXTERN     floor
                EXTERN     odd


;       return -(floor(-x))
.ceil   CALL    odd
        jp      floor
