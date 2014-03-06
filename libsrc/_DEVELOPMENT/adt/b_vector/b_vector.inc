
; b_vector structure

defvars 0
{
   __b_vector_array         ds.w 1   ; address of vector's array
   __b_vector_size          ds.w 1   ; number of bytes occupied in array
   __b_vector_capacity      ds.w 1   ; number of bytes allocated for array
   __b_vector_max_size      ds.w 1   ; maximum capacity allowed

   __B_VECTOR_SZ
}
