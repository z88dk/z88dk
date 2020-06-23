
    SECTION code_fp_math16

    PUBLIC ___uchar2h_callee
    PUBLIC _f16_u8_fastcall

    EXTERN cm16_sdcc___uchar2h_callee
    EXTERN cm16_sdcc___uchar2h_fastcall
    
    defc ___uchar2h_callee = cm16_sdcc___uchar2h_callee
    defc _f16_u8_fastcall = cm16_sdcc___uchar2h_fastcall
