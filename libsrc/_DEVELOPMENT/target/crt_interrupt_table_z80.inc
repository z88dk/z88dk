
PUBLIC _z80_rst_00h, _z80_rst_08h, _z80_rst_10h, _z80_rst_18h
PUBLIC _z80_rst_20h, _z80_rst_28h, _z80_rst_30h, _z80_rst_38h
PUBLIC _z80_nmi

PUBLIC _z180_trap

_z80_rst_00h:
_z180_trap:

IF (__crt_enable_rst_table & $01) || (__crt_enable_trap)

   EXTERN __z180_trap
   jp __z180_trap

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_08h:

IF (__crt_enable_rst_table & $02)

   EXTERN __z80_rst_08h
   jp __z80_rst_08h

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_10h:

IF (__crt_enable_rst_table & $04)

   EXTERN __z80_rst_10h
   jp __z80_rst_10h

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_18h:

IF (__crt_enable_rst_table & $08)

   EXTERN __z80_rst_18h
   jp __z80_rst_18h

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_20h:

IF (__crt_enable_rst_table & $10)

   EXTERN __z80_rst_20h
   jp __z80_rst_20h

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_28h:

IF (__crt_enable_rst_table & $20)

   EXTERN __z80_rst_28h
   jp __z80_rst_28h

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_30h:

IF (__crt_enable_rst_table & $40)

   EXTERN __z80_rst_30h
   jp __z80_rst_30h

ELSE

   ret
   ret
   ret

ENDIF

_z80_rst_38h:

IF (__crt_enable_rst_table & $80)

   EXTERN __z80_rst_38h
   jp __z80_rst_38h

ELSE

   ei
   reti

ENDIF

_z80_nmi:

IF __crt_enable_nmi_table

   EXTERN __z80_nmi
   jp __z80_nmi

ELSE

   retn
   ret

ENDIF

