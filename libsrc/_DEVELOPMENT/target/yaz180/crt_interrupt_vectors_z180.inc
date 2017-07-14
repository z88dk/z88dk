IF (__page_zero_present) && (__crt_org_vector_table != 0)

IF (__Z180 != 0)

; defc __Z180 = 0x04

; defc __Z180_Z80180 = 0x01
; defc __Z180_Z8L180 = 0x02
; defc __Z180_Z8S180 = 0x04

SECTION interrupt_vectors

EXTERN l_ret

;_z180_int_int1:
defw l_ret

;_z180_int_int2:
defw l_ret

;_z180_int_prt0:
defw l_ret

;_z180_int_prt1:
defw l_ret

;_z180_int_dma0:
defw l_ret

;_z180_int_dma1:
defw l_ret

;_z180_int_csio:
defw l_ret

EXTERN _z180_int_asci0  ; FTDI interface on asci0
defw _z180_int_asci0

;_z180_int_asci1:
defw l_ret

ENDIF

ENDIF
