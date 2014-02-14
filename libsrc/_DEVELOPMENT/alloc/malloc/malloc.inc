
; heap header

defvars 0
{
   __heap_header_next       ds.w 1
   __heap_header_committed  ds.w 1
   __heap_header_prev       ds.w 1

   __HEAP_HEADER_SZ
}
