
    SECTION code_fp_am9511

    PUBLIC  l_f32_uchar2f
    PUBLIC  l_f32_uint2f
    PUBLIC  l_f32_schar2f
    PUBLIC  l_f32_sint2f
    PUBLIC  l_f32_ulong2f
    PUBLIC  l_f32_slong2f

	EXTERN	asm_am9511_float8
	EXTERN	asm_am9511_float8u
	EXTERN	asm_am9511_float16
	EXTERN	asm_am9511_float16u
	EXTERN	asm_am9511_float32
	EXTERN	asm_am9511_float32u

	defc	l_f32_uchar2f = asm_am9511_float8u
	defc	l_f32_schar2f = asm_am9511_float8
	defc	l_f32_uint2f  = asm_am9511_float16u
	defc	l_f32_sint2f  = asm_am9511_float16
	defc	l_f32_ulong2f = asm_am9511_float32u
	defc	l_f32_slong2f = asm_am9511_float32
