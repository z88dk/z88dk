
SECTION code_clib
SECTION code_fp_math48

PUBLIC derror_edom_infc, derror_edom_pinfc, derror_edom_minfc

EXTERN am48_derror_edom_infc, am48_derror_edom_pinfc, am48_derror_edom_minfc

defc derror_edom_infc  = am48_derror_edom_infc
defc derror_edom_pinfc = am48_derror_edom_pinfc
defc derror_edom_minfc = am48_derror_edom_minfc
