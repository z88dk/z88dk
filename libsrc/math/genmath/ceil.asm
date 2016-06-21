;       Small C+ Math Library
;       ceil(x)

        SECTION code_fp
        PUBLIC    ceil

        EXTERN     floor
        EXTERN     odd


;       return -(floor(-x))
.ceil   CALL    odd
        jp      floor
