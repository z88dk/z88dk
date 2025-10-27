
SECTION code_clib
SECTION code_fp_math32

PUBLIC derror_erange_infc, derror_erange_pinfc, derror_erange_minfc

EXTERN m32_derror_erange_infc, m32_derror_erange_pinfc, m32_derror_erange_ninfc

defc derror_erange_infc  = m32_derror_erange_infc
defc derror_erange_pinfc = m32_derror_erange_pinfc
defc derror_erange_minfc = m32_derror_erange_ninfc

