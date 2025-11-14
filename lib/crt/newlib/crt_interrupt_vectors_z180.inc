
IF (__Z180 != 0) && (__page_zero_present) && (__crt_org_vector_table > 0x100)

; defc __Z180 = 0x04

; defc __Z180_Z80180 = 0x01
; defc __Z180_Z8L180 = 0x02
; defc __Z180_Z8S180 = 0x04

SECTION code_crt_interrupt_vector_table

EXTERN l_ret

PUBLIC z180_int_int1, z180_int_int2
PUBLIC z180_int_prt0, z180_int_prt1
PUBLIC z180_int_dma0, z180_int_dma1
PUBLIC z180_int_csio
PUBLIC z180_int_asci0, z180_int_asci1

; z180 internal interrupt vector base address = __crt_org_vector_table + __IO_VECTOR_BASE

; very ugly to insert/skip __IO_VECTOR_BASE bytes. must be a better way to achieve this.
defs __IO_VECTOR_BASE - ASMPC

defc z180_int_int1  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x00
defw l_ret

defc z180_int_int2  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x02
defw l_ret

defc z180_int_prt0  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x04
EXTERN _z180_int_prt0   ; a system tick
defw _z180_int_prt0

defc z180_int_prt1  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x06
defw l_ret

defc z180_int_dma0  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x08
defw l_ret

defc z180_int_dma1  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x0A
defw l_ret

defc z180_int_csio  = __crt_org_vector_table + __IO_VECTOR_BASE + 0x0C
defw l_ret

defc z180_int_asci0 = __crt_org_vector_table + __IO_VECTOR_BASE + 0x0E
EXTERN _z180_int_asci0
defw _z180_int_asci0

defc z180_int_asci1 = __crt_org_vector_table + __IO_VECTOR_BASE + 0x10
EXTERN _z180_int_asci1
defw _z180_int_asci1

ENDIF
