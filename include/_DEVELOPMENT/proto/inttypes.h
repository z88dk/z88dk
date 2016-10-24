include(__link__.m4)

#ifndef _INTTYPES_H
#define _INTTYPES_H

#include <stdint.h>

// DATA STRUCTURES

#ifdef __CLANG

   typedef struct imaxdiv_s
   {

      long long rem;
      long long quot;

   } imaxdiv_t;

#endif

#ifdef __SDCC

   typedef struct imaxdiv_s
   {

      long long rem;
      long long quot;

   } imaxdiv_t;

#endif

#ifdef __SCCZ80

   typedef struct imaxdiv_s
   {

      long quot;
      long rem;

   } imaxdiv_t;

#endif

#ifdef __CLANG

extern intmax_t imaxabs(intmax_t j);

#endif

#ifdef __SDCC

extern intmax_t imaxabs(intmax_t j);
extern intmax_t imaxabs_callee(intmax_t j) __z88dk_callee;
#define imaxabs(a) imaxabs_callee(a)

#endif

#ifdef __SCCZ80

__DPROTO(`b,c',`b,c',intmax_t,,imaxabs,intmax_t j)

#endif

__DPROTO(,,void,,_imaxdiv_,imaxdiv_t *md,intmax_t numer,intmax_t denom)
__DPROTO(,,intmax_t,,strtoimax,const char *nptr,char **endptr,int base)
__DPROTO(,,uintmax_t,,strtoumax,const char *nptr,char **endptr,int base)

// PRINTF FORMAT SPECIFIERS

#define PRId8          "%d"
#define PRId16         "%d"
#define PRId32         "%ld"

#define PRIi8          "%i"
#define PRIi16         "%i"
#define PRIi32         "%li"

#define PRIdLEAST8     "%d"
#define PRIdLEAST16    "%d"
#define PRIdLEAST32    "%ld"

#define PRIiLEAST8     "%i"
#define PRIiLEAST16    "%i"
#define PRIiLEAST32    "%li"

#define PRIdFAST8      "%d"
#define PRIdFAST16     "%d"
#define PRIdFAST32     "%ld"

#define PRIiFAST8      "%i"
#define PRIiFAST16     "%i"
#define PRIiFAST32     "%li"

#ifdef __CLANG

#define PRId64         "%lld"
#define PRIi64         "%lli"
#define PRIdLEAST64    "%lld"
#define PRIiLEAST64    "%lli"
#define PRIdFAST64     "%lld"
#define PRIiFAST64     "%lli"

#endif

#ifdef __SDCC

#define PRId64         "%lld"
#define PRIi64         "%lli"
#define PRIdLEAST64    "%lld"
#define PRIiLEAST64    "%lli"
#define PRIdFAST64     "%lld"
#define PRIiFAST64     "%lli"

#endif

#ifdef __CLANG

#define PRIdMAX        "%lld"
#define PRIiMAX        "%lli"

#endif

#ifdef __SDCC

#define PRIdMAX        "%lld"
#define PRIiMAX        "%lli"

#endif

#ifdef __SCCZ80

#define PRIdMAX        "%ld"
#define PRIiMAX        "%li"

#endif

#define PRIdPTR        "%d"
#define PRIiPTR        "%i"

#define PRIo8          "%o"
#define PRIo16         "%o"
#define PRIo32         "%lo"

#define PRIu8          "%u"
#define PRIu16         "%u"
#define PRIu32         "%lu"

#define PRIx8          "%x"
#define PRIx16         "%x"
#define PRIx32         "%lx"

#define PRIX8          "%X"
#define PRIX16         "%X"
#define PRIX32         "%lX"

#ifdef __CLANG

#define PRIo64         "%llo"
#define PRIu64         "%llu"
#define PRIx64         "%llx"
#define PRIX64         "%llX"

#endif

#ifdef __SDCC

#define PRIo64         "%llo"
#define PRIu64         "%llu"
#define PRIx64         "%llx"
#define PRIX64         "%llX"

#endif

#define PRIoLEAST8     "%o"
#define PRIoLEAST16    "%o"
#define PRIoLEAST32    "%lo"

#define PRIuLEAST8     "%u"
#define PRIuLEAST16    "%u"
#define PRIuLEAST32    "%lu"

#define PRIxLEAST8     "%x"
#define PRIxLEAST16    "%x"
#define PRIxLEAST32    "%lx"

#define PRIXLEAST8     "%X"
#define PRIXLEAST16    "%X"
#define PRIXLEAST32    "%lX"

#ifdef __CLANG

#define PRIoLEAST64    "%llo"
#define PRIuLEAST64    "%llu"
#define PRIxLEAST64    "%llx"
#define PRIXLEAST64    "%llX"

#endif

#ifdef __SDCC

#define PRIoLEAST64    "%llo"
#define PRIuLEAST64    "%llu"
#define PRIxLEAST64    "%llx"
#define PRIXLEAST64    "%llX"

#endif

#define PRIoFAST8      "%o"
#define PRIoFAST16     "%o"
#define PRIoFAST32     "%lo"

#define PRIuFAST8      "%u"
#define PRIuFAST16     "%u"
#define PRIuFAST32     "%lu"

#define PRIxFAST8      "%x"
#define PRIxFAST16     "%x"
#define PRIxFAST32     "%lx"

#define PRIXFAST8      "%X"
#define PRIXFAST16     "%X"
#define PRIXFAST32     "%lX"

#ifdef __CLANG

#define PRIoFAST64     "%llo"
#define PRIuFAST64     "%llu"
#define PRIxFAST64     "%llx"
#define PRIXFAST64     "%llX"

#endif

#ifdef __SDCC

#define PRIoFAST64     "%llo"
#define PRIuFAST64     "%llu"
#define PRIxFAST64     "%llx"
#define PRIXFAST64     "%llX"

#endif

#ifdef __CLANG

#define PRIoMAX        "%llo"
#define PRIuMAX        "%llu"
#define PRIxMAX        "%llx"
#define PRIXMAX        "%llX"

#endif

#ifdef __SDCC

#define PRIoMAX        "%llo"
#define PRIuMAX        "%llu"
#define PRIxMAX        "%llx"
#define PRIXMAX        "%llX"

#endif

#ifdef __SCCZ80

#define PRIoMAX        "%lo"
#define PRIuMAX        "%lu"
#define PRIxMAX        "%lx"
#define PRIXMAX        "%lX"

#endif

#define PRIoPTR        "%o"
#define PRIuPTR        "%u"
#define PRIxPTR        "%x"
#define PRIXPTR        "%X"

// SCANF FORMAT SPECIFIERS

#define SCNd8          "%d"
#define SCNd16         "%d"
#define SCNd32         "%ld"

#define SCNi8          "%i"
#define SCNi16         "%i"
#define SCNi32         "%li"

#define SCNdLEAST8     "%d"
#define SCNdLEAST16    "%d"
#define SCNdLEAST32    "%ld"

#define SCNiLEAST8     "%i"
#define SCNiLEAST16    "%i"
#define SCNiLEAST32    "%li"

#define SCNdFAST8      "%d"
#define SCNdFAST16     "%d"
#define SCNdFAST32     "%ld"

#define SCNiFAST8      "%i"
#define SCNiFAST16     "%i"
#define SCNiFAST32     "%li"

#ifdef __CLANG

#define SCNd64         "%lld"
#define SCNi64         "%lli"
#define SCNdLEAST64    "%lld"
#define SCNiLEAST64    "%lli"
#define SCNdFAST64     "%lld"
#define SCNiFAST64     "%lli"

#endif

#ifdef __SDCC

#define SCNd64         "%lld"
#define SCNi64         "%lli"
#define SCNdLEAST64    "%lld"
#define SCNiLEAST64    "%lli"
#define SCNdFAST64     "%lld"
#define SCNiFAST64     "%lli"

#endif

#ifdef __CLANG

#define SCNdMAX        "%lld"
#define SCNiMAX        "%lli"

#endif

#ifdef __SDCC

#define SCNdMAX        "%lld"
#define SCNiMAX        "%lli"

#endif

#ifdef __SCCZ80

#define SCNdMAX        "%ld"
#define SCNiMAX        "%li"

#endif

#define SCNdPTR        "%d"
#define SCNiPTR        "%i"

#define SCNo8          "%o"
#define SCNo16         "%o"
#define SCNo32         "%lo"

#define SCNu8          "%u"
#define SCNu16         "%u"
#define SCNu32         "%lu"

#define SCNx8          "%x"
#define SCNx16         "%x"
#define SCNx32         "%lx"

#ifdef __CLANG

#define SCNo64         "%llo"
#define SCNu64         "%llu"
#define SCNx64         "%llx"

#endif

#ifdef __SDCC

#define SCNo64         "%llo"
#define SCNu64         "%llu"
#define SCNx64         "%llx"

#endif

#define SCNoLEAST8     "%o"
#define SCNoLEAST16    "%o"
#define SCNoLEAST32    "%lo"

#define SCNuLEAST8     "%u"
#define SCNuLEAST16    "%u"
#define SCNuLEAST32    "%lu"

#define SCNxLEAST8     "%x"
#define SCNxLEAST16    "%x"
#define SCNxLEAST32    "%lx"

#ifdef __CLANG

#define SCNoLEAST64    "%llo"
#define SCNuLEAST64    "%llu"
#define SCNxLEAST64    "%llx"

#endif

#ifdef __SDCC

#define SCNoLEAST64    "%llo"
#define SCNuLEAST64    "%llu"
#define SCNxLEAST64    "%llx"

#endif

#define SCNoFAST8      "%o"
#define SCNoFAST16     "%o"
#define SCNoFAST32     "%lo"

#define SCNuFAST8      "%u"
#define SCNuFAST16     "%u"
#define SCNuFAST32     "%lu"

#define SCNxFAST8      "%x"
#define SCNxFAST16     "%x"
#define SCNxFAST32     "%lx"

#ifdef __CLANG

#define SCNoFAST64     "%llo"
#define SCNuFAST64     "%llu"
#define SCNxFAST64     "%llx"

#endif

#ifdef __SDCC

#define SCNoFAST64     "%llo"
#define SCNuFAST64     "%llu"
#define SCNxFAST64     "%llx"

#endif

#ifdef __CLANG

#define SCNoMAX        "%llo"
#define SCNuMAX        "%llu"
#define SCNxMAX        "%llx"

#endif

#ifdef __SDCC

#define SCNoMAX        "%llo"
#define SCNuMAX        "%llu"
#define SCNxMAX        "%llx"

#endif

#ifdef __SCCZ80

#define SCNoMAX        "%lo"
#define SCNuMAX        "%lu"
#define SCNxMAX        "%lx"

#endif

#define SCNoPTR        "%o"
#define SCNuPTR        "%u"
#define SCNxPTR        "%x"

#endif
