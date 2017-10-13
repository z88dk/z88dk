
IF (__Z180 != 0) && (__page_zero_present = 0)

PUBLIC _z180_trap_vector
PUBLIC _z180_rst_08h_vector, _z180_rst_10h_vector, _z180_rst_18h_vector 
PUBLIC _z180_rst_20h_vector, _z180_rst_28h_vector, _z180_rst_30h_vector
PUBLIC _z180_rst_38h_vector
PUBLIC _z180_nmi_vector

defc _z180_trap_vector    = __Z80_VECTOR_BASE_BASIC+0x01
defc _z180_rst_08h_vector = __Z80_VECTOR_BASE_BASIC+0x05
defc _z180_rst_10h_vector = __Z80_VECTOR_BASE_BASIC+0x09
defc _z180_rst_18h_vector = __Z80_VECTOR_BASE_BASIC+0x0D
defc _z180_rst_20h_vector = __Z80_VECTOR_BASE_BASIC+0x11
defc _z180_rst_28h_vector = __Z80_VECTOR_BASE_BASIC+0x15
defc _z180_rst_30h_vector = __Z80_VECTOR_BASE_BASIC+0x19
defc _z180_rst_38h_vector = __Z80_VECTOR_BASE_BASIC+0x1D
defc _z180_nmi_vector     = __Z80_VECTOR_BASE_BASIC+0x21


PUBLIC z180_int_int1, z180_int_int2
PUBLIC z180_int_prt0, z180_int_prt1
PUBLIC z180_int_dma0, z180_int_dma1
PUBLIC z180_int_csio
PUBLIC z180_int_asci0, z180_int_asci1

defc Z180_VECTOR_BASE_BASIC = __Z80_VECTOR_BASE_BASIC-(__Z80_VECTOR_BASE_BASIC%(0x100))+__Z180_VECTOR_IL_BASIC

defc z180_int_int1  = Z180_VECTOR_BASE_BASIC+0x00
defc z180_int_int2  = Z180_VECTOR_BASE_BASIC+0x02
defc z180_int_prt0  = Z180_VECTOR_BASE_BASIC+0x04
defc z180_int_prt1  = Z180_VECTOR_BASE_BASIC+0x06
defc z180_int_dma0  = Z180_VECTOR_BASE_BASIC+0x08
defc z180_int_dma1  = Z180_VECTOR_BASE_BASIC+0x0A
defc z180_int_csio  = Z180_VECTOR_BASE_BASIC+0x0C
defc z180_int_asci0 = Z180_VECTOR_BASE_BASIC+0x0E
defc z180_int_asci1 = Z180_VECTOR_BASE_BASIC+0x10

ENDIF
