
###############################################################
# Generate Segment Data
#
# $1 = driver name
# $2 = instance name
# $3 = ds* of tied input console (0=none)
#
# Parameters
#
# $4 = character set address (15360 default)
#
# Labels to the driver's local data will have the form:
#
# $2_cons_output_char_L1_LABELNAME
###############################################################

###############################################################
# BSS SEGMENT - EXTERNAL

define(`M4_cons_output_char_L1_PUT_SEGMENT_BSS_DEFVARS',)


###############################################################
# BSS SEGMENT - ATTACHED

define(`M4_cons_output_char_L1_PUT_SEGMENT_BSS_DEFS',)


###############################################################
# DATA SEGMENT - EXTERNAL

define(`M4_cons_output_char_L1_PUT_SEGMENT_DATA_DEFVARS',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_output_char_L1,' instance = $2

   defvars -1
   {
      $2_cons_output_char_L1_file_state	ds.b 6
   }
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - ATTACHED

define(`M4_cons_output_char_L1_PUT_SEGMENT_DATA_DEFB',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_output_char_L1,' instance = $2
   
   $2_cons_output_char_L1_file_state:
   
      defw $3
      defb `0, 0'
      defw `ifelse($4,0,15360,$4)'
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)


###############################################################
# DATA SEGMENT - STORED

define(`M4_cons_output_char_L1_PUT_SEGMENT_DATA_S_DEFB',dnl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; driver = `cons_output_char_L1,' instance = $2
   
   $2_cons_output_char_L1_file_state_s:
   
      defw $3
      defb `0, 0'
      defw `ifelse($4,0,15360,$4)'
   ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)
