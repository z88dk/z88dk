
    SECTION code_fp_math32

    PUBLIC  l_f32_uchar2f
    PUBLIC  l_f32_uint2f
    PUBLIC  l_f32_schar2f
    PUBLIC  l_f32_sint2f
    PUBLIC  l_f32_ulong2f
    PUBLIC  l_f32_slong2f

	EXTERN	m32_float16
	EXTERN	m32_float16u
	EXTERN	m32_float32
	EXTERN	m32_float32u

	defc	l_f32_uchar2f = m32_float16u
	defc	l_f32_schar2f = m32_float16
	defc	l_f32_uint2f  = m32_float16u
	defc	l_f32_sint2f  = m32_float16
	defc	l_f32_ulong2f = m32_float32u
	defc	l_f32_slong2f = m32_float32
