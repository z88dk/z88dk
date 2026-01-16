IF __page_zero_present

SECTION smc_jump_vectors

IF ((__crt_enable_rst & 0x0202) = 0x0202)

   PUBLIC _z80_rst_08h_vector
   
   defc _z80_rst_08h_vector = __z80_rst_08h + 1
   
   EXTERN _z80_rst_08h
   
   __z80_rst_08h:
   
      jp _z80_rst_08h

ENDIF

IF ((__crt_enable_rst & 0x0404) = 0x0404)

   PUBLIC _z80_rst_10h_vector
   
   defc _z80_rst_10h_vector = __z80_rst_10h + 1
   
   EXTERN _z80_rst_10h
   
   __z80_rst_10h:
   
      jp _z80_rst_10h

ENDIF

IF ((__crt_enable_rst & 0x0808) = 0x0808)

   PUBLIC _z80_rst_18h_vector
   
   defc _z80_rst_18h_vector = __z80_rst_18h + 1
   
   EXTERN _z80_rst_18h
   
   __z80_rst_18h:
   
      jp _z80_rst_18h

ENDIF

IF ((__crt_enable_rst & 0x1010) = 0x1010)

   PUBLIC _z80_rst_20h_vector
   
   defc _z80_rst_20h_vector = __z80_rst_20h + 1
   
   EXTERN _z80_rst_20h
   
   __z80_rst_20h:
   
      jp _z80_rst_20h

ENDIF

IF ((__crt_enable_rst & 0x2020) = 0x2020)

   PUBLIC _z80_rst_28h_vector
   
   defc _z80_rst_28h_vector = __z80_rst_28h + 1
   
   EXTERN _z80_rst_28h
   
   __z80_rst_28h:
   
      jp _z80_rst_28h

ENDIF

IF ((__crt_enable_rst & 0x4040) = 0x4040)

   PUBLIC _z80_rst_30h_vector
   
   defc _z80_rst_30h_vector = __z80_rst_30h + 1
   
   EXTERN _z80_rst_30h
   
   __z80_rst_30h:
   
      jp _z80_rst_30h

ENDIF

IF ((__crt_enable_rst & 0x8080) = 0x8080)

   PUBLIC _z80_rst_38h_vector
   
   defc _z80_rst_38h_vector = __z80_rst_38h + 1
   
   EXTERN _z80_rst_38h
   
   __z80_rst_38h:
   
      jp _z80_rst_38h

ENDIF

IF (__crt_enable_nmi > 1)

   PUBLIC _z80_nmi_vector
   
   defc _z80_nmi_vector = __z80_nmi + 1
   
   EXTERN _z80_nmi
   
   __z80_nmi:
   
      jp _z80_nmi

ENDIF

ENDIF
