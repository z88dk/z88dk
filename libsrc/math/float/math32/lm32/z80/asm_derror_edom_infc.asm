
SECTION code_clib
SECTION code_fp_math32

PUBLIC derror_edom_infc, derror_edom_pinfc, derror_edom_minfc

EXTERN m32_derror_edom_infc, m32_derror_edom_pinfc, m32_derror_edom_ninfc

defc derror_edom_infc  = m32_derror_edom_infc
defc derror_edom_pinfc = m32_derror_edom_pinfc
defc derror_edom_minfc = m32_derror_edom_ninfc
