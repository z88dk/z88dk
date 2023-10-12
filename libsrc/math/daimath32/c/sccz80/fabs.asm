
        SECTION code_fp_dai32

        PUBLIC  fabs

fabs:
  IF    __CPU_INTEL__
        ld      a, d
        and     @01111111
        ld      d, a
  ELSE
        res     7, d
  ENDIF
        ret
