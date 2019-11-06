    SECTION bss_clib

    PUBLIC  __vz200_mode
    PUBLIC  __MODE1_attr

 __vz200_mode:  defb    0


    SECTION     data_clib
__MODE1_attr:   defb    @11000000,@00000000
