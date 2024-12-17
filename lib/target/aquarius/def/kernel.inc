  IF __AQPLUS_FIRMWARE_023q
        #include    "kernel_023q.inc"
  ELIF __AQPLUS_FIRMWARE_023i
        #include    "kernel_023i.inc"
  ELSE
        #include    "kernel_023q.inc"
  ENDIF
