#define str(x) # x

repti fmt, genmath, math48, \
           ieee16, ieee32, ieee64, \
           z80, zx81, zx, z88, \
           mbfs, mbf40, mbf64, \
           am9511
  setfloat fmt
  defm "setfloat", str(fmt)
  ifdef __FLOAT_GENMATH__
    defm "genmath"
  endif
  ifdef __FLOAT_MATH48__
    defm "math48"
  endif
  ifdef __FLOAT_IEEE16__
    defm "ieee16"
  endif
  ifdef __FLOAT_IEEE32__
    defm "ieee32"
  endif
  ifdef __FLOAT_IEEE64__
    defm "ieee64"
  endif
  ifdef __FLOAT_Z80__
    defm "z80"
  endif
  ifdef __FLOAT_ZX81__
    defm "zx81"
  endif
  ifdef __FLOAT_ZX__
    defm "zx"
  endif
  ifdef __FLOAT_Z88__
    defm "z88"
  endif
  ifdef __FLOAT_MBFS__
    defm "mbfs"
  endif
  ifdef __FLOAT_MBF40__
    defm "mbf40"
  endif
  ifdef __FLOAT_MBF64__
    defm "mbf64"
  endif
  ifdef __FLOAT_AM9511__
    defm "am9511"
  endif
endr
