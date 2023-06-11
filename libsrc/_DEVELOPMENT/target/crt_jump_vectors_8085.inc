IF __page_zero_present

SECTION smc_jump_vectors

IF ((__crt_enable_rst & 0x0202) = 0x0202)

   PUBLIC _8085_rst_08h_vector
   
   defc _8085_rst_08h_vector = __8085_rst_08h + 1
   
   EXTERN _8085_rst_08h
   
   __8085_rst_08h:
   
      jp _8085_rst_08h

ENDIF

IF ((__crt_enable_rst & 0x0404) = 0x0404)

   PUBLIC _8085_rst_10h_vector
   
   defc _8085_rst_10h_vector = __8085_rst_10h + 1
   
   EXTERN _8085_rst_10h
   
   __8085_rst_10h:
   
      jp _8085_rst_10h

ENDIF

IF ((__crt_enable_rst & 0x0808) = 0x0808)

   PUBLIC _8085_rst_18h_vector
   
   defc _8085_rst_18h_vector = __8085_rst_18h + 1
   
   EXTERN _8085_rst_18h
   
   __8085_rst_18h:
   
      jp _8085_rst_18h

ENDIF

IF ((__crt_enable_rst & 0x1010) = 0x1010)

   PUBLIC _8085_rst_20h_vector
   
   defc _8085_rst_20h_vector = __8085_rst_20h + 1
   
   EXTERN _8085_rst_20h
   
   __8085_rst_20h:
   
      jp _8085_rst_20h

ENDIF

IF (__crt_enable_trap > 1)

   PUBLIC _8085_trap_vector
   
   defc _8085_trap_vector = __8085_trap + 1
   
   EXTERN _8085_trap
   
   __z180_trap:
   
      jp _8085_trap

ENDIF

IF ((__crt_enable_rst & 0x2020) = 0x2020)

   PUBLIC _8085_rst_28h_vector
   
   defc _8085_rst_28h_vector = __8085_rst_28h + 1
   
   EXTERN _8085_rst_28h
   
   __8085_rst_28h:
   
      jp _8085_rst_28h

ENDIF

IF (__crt_enable_intt55 > 1)

   PUBLIC _8085_int55_vector
   
   defc _8085_int55_vector = __8085_int55 + 1
   
   EXTERN _8085_int55
   
   __8085_int55:
   
      jp _8085_int55

ENDIF

IF ((__crt_enable_rst & 0x4040) = 0x4040)

   PUBLIC _8085_rst_30h_vector
   
   defc _8085_rst_30h_vector = __8085_rst_30h + 1
   
   EXTERN _8085_rst_30h
   
   __8085_rst_30h:
   
      jp _8085_rst_30h

ENDIF

IF (__crt_enable_int65 > 1)

   PUBLIC _8085_int65_vector
   
   defc _8085_int65_vector = __8085_int65 + 1
   
   EXTERN _8085_int65
   
   __8085_int65:
   
      jp _8085_int65

ENDIF

IF ((__crt_enable_rst & 0x8080) = 0x8080)

   PUBLIC _8085_rst_38h_vector
   
   defc _8085_rst_38h_vector = __8085_rst_38h + 1
   
   EXTERN _8085_rst_38h
   
   __8085_rst_38h:
   
      jp _8085_rst_38h

ENDIF

IF (__crt_enable_int75 > 1)

   PUBLIC _8085_int75_vector
   
   defc _8085_int75_vector = __8085_int75 + 1
   
   EXTERN _8085_int75
   
   __8085_int75:
   
      jp _8085_int75

ENDIF

IF (__crt_enable_rst40h > 1)

   PUBLIC _8085_rst40h_vector
   
   defc _8085_rst40h_vector = __8085_rst40h + 1
   
   EXTERN _8085_rst40h
   
   __8085_rst40h:
   
      jp _8085_rst40h

ENDIF

ENDIF
