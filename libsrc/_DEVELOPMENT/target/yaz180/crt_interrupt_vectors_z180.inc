IF __page_zero_present

IF __crt_org_vector_table > 0

INCLUDE "config_private.inc"

; defc __Z180 = 0x04

; defc __Z180_Z80180 = 0x01
; defc __Z180_Z8L180 = 0x02
; defc __Z180_Z8S180 = 0x04

SECTION interrupt_vectors

;_vector_rst_08h:
;   defw default_rst_08h

_vector_asci0:
defw __Z180 ; just an example currently

ENDIF

ENDIF
