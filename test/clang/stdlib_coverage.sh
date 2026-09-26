#!/bin/sh
# stdlib coverage survey for zcc +cpm -compiler=llvmz80.
#
# For each C standard library function, compiles and links a minimal
# caller and reports LINKS or LINK_ERROR.  Does NOT run the binaries
# (some functions may link but misbehave; runtime tests exist separately).
#
# Output format (one line per function):
#   LINKS      <header>  <function>
#   LINK_ERROR <header>  <function>  -- <first error line>
#
# Exit 0 always (this is a survey, not a pass/fail gate).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH ./stdlib_coverage.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

LINKS=0; ERRORS=0

# probe <header> <function> <call>
probe() {
    hdr=$1 fn=$2 call=$3
    src="$WORK/probe_$fn.c"
    cat >"$src" <<CSRC
#include <$hdr>
int main(void) { $call; return 0; }
CSRC
    if zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app \
        -pragma-define:CLIB_MALLOC_HEAP_SIZE=4000 \
        -o "$WORK/probe_$fn" "$src" >"$WORK/probe_$fn.log" 2>&1; then
        printf 'LINKS      %-12s %s\n' "$hdr" "$fn"
        LINKS=$((LINKS + 1))
    else
        errmsg=$(grep -i "undefined\|error\|Error" "$WORK/probe_$fn.log" | head -1 | sed 's/^[[:space:]]*//')
        printf 'LINK_ERROR %-12s %-30s -- %s\n' "$hdr" "$fn" "$errmsg"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "=== z88dk llvmz80 stdlib link coverage survey ==="
echo ""
echo "--- string.h ---"
probe string.h memset   "char b[4]; memset(b,0,4);"
probe string.h memcpy   "char a[4],b[4]; memcpy(a,b,4);"
probe string.h memmove  "char a[4]; memmove(a,a+1,3);"
probe string.h memcmp   "char a[4],b[4]; (void)memcmp(a,b,4);"
probe string.h memchr   "char a[4]; (void)memchr(a,'x',4);"
probe string.h strlen   "const char *s=\"hi\"; (void)strlen(s);"
probe string.h strcpy   "char b[8]; strcpy(b,\"hi\");"
probe string.h strncpy  "char b[8]; strncpy(b,\"hi\",2);"
probe string.h strcat   "char b[16]; strcpy(b,\"a\"); strcat(b,\"b\");"
probe string.h strncat  "char b[16]; strcpy(b,\"a\"); strncat(b,\"b\",1);"
probe string.h strcmp   "(void)strcmp(\"a\",\"b\");"
probe string.h strncmp  "(void)strncmp(\"a\",\"b\",1);"
probe string.h strchr   "(void)strchr(\"hi\",'i');"
probe string.h strrchr  "(void)strrchr(\"hi\",'i');"
probe string.h strstr   "(void)strstr(\"hello\",\"ll\");"
probe string.h strspn   "(void)strspn(\"abc\",\"ab\");"
probe string.h strcspn  "(void)strcspn(\"abc\",\"x\");"
probe string.h strtok   "char b[8]; strcpy(b,\"a,b\"); (void)strtok(b,\",\");"
probe string.h strnlen  "(void)strnlen(\"hi\",10);"
probe string.h strcasecmp "(void)strcasecmp(\"A\",\"a\");"
probe string.h strncasecmp "(void)strncasecmp(\"Ab\",\"ab\",2);"
probe string.h strerror "(void)strerror(0);"
probe string.h strdup   "char *p=strdup(\"hi\"); (void)p;"

echo ""
echo "--- stdlib.h ---"
probe stdlib.h atoi     "(void)atoi(\"42\");"
probe stdlib.h atol     "(void)atol(\"42\");"
probe stdlib.h strtol   "(void)strtol(\"42\",0,10);"
probe stdlib.h strtoul  "(void)strtoul(\"42\",0,10);"
probe stdlib.h itoa     "char b[8]; itoa(42,b,10);"
probe stdlib.h ltoa     "char b[16]; ltoa(42L,b,10);"
probe stdlib.h ultoa    "char b[16]; ultoa(42UL,b,10);"
probe stdlib.h abs      "(void)abs(-1);"
probe stdlib.h labs     "(void)labs(-1L);"
probe stdlib.h rand     "(void)rand();"
probe stdlib.h srand    "srand(1);"
probe stdlib.h malloc   "void *p=malloc(16); (void)p;"
probe stdlib.h calloc   "void *p=calloc(4,4); (void)p;"
probe stdlib.h realloc  "void *p=malloc(4); p=realloc(p,8); (void)p;"
probe stdlib.h free     "free(malloc(4));"
probe stdlib.h qsort    "int a[2]={2,1}; qsort(a,2,2,0);"
# CLASSIC_DESIGN: standard bsearch(key,base,nmemb,size,compar) needs midpoint*size
# (a 16-bit multiply per iteration).  Classic clib deliberately avoids this cost:
# l_bsearch(key,base,n,cmp) only handles 2-byte-element arrays (bit-shift instead
# of multiply, Lbsearch.asm 2005).  Newlib has the full 5-arg version.
probe stdlib.h bsearch  "int a[2]={1,2},k=1; (void)bsearch(&k,a,2,2,0);"
probe stdlib.h exit     "/* exit tested indirectly — not called */"

echo ""
echo "--- stdio.h ---"
probe stdio.h printf    "printf(\"%d\",1);"
probe stdio.h sprintf   "char b[8]; sprintf(b,\"%d\",1);"
probe stdio.h snprintf  "char b[8]; snprintf(b,8,\"%d\",1);"
probe stdio.h fprintf   "fprintf(stdout,\"%d\",1);"
probe stdio.h scanf     "/* scan from stdin -- link only */ int x; (void)scanf(\"%d\",&x);"
probe stdio.h sscanf    "int x; sscanf(\"1\",\"%d\",&x);"
probe stdio.h fscanf    "int x; fscanf(stdin,\"%d\",&x);"
# vprintf is a MACRO in stdio.h (#define vprintf(c,a) vfprintf(stdout,c,a)),
# not a symbol — probe its target vfprintf, which IS the bridged symbol.
# vsnprintf is a real symbol.  Survey checks LINKING only; take the address to
# avoid needing a va_list.  Real behavior: runtime_vaarg.sh.
probe stdio.h vfprintf  "extern int vfprintf(); (void)&vfprintf;"  # vprintf macro -> this
probe stdio.h vsnprintf "extern int vsnprintf(); (void)&vsnprintf;"
probe stdio.h puts      "puts(\"hi\");"
probe stdio.h putchar   "putchar('A');"
probe stdio.h getchar   "(void)getchar();"
probe stdio.h fopen     "FILE *f=fopen(\"x\",\"r\"); (void)f;"
probe stdio.h fclose    "FILE *f=fopen(\"x\",\"r\"); if(f) fclose(f);"
probe stdio.h fread     "char b[4]; FILE *f=fopen(\"x\",\"rb\"); if(f){fread(b,1,4,f);fclose(f);}"
probe stdio.h fwrite    "char b[4]={0}; FILE *f=fopen(\"x\",\"wb\"); if(f){fwrite(b,1,4,f);fclose(f);}"
probe stdio.h fgets     "char b[8]; FILE *f=fopen(\"x\",\"r\"); if(f){fgets(b,8,f);fclose(f);}"
probe stdio.h fputs     "FILE *f=fopen(\"x\",\"w\"); if(f){fputs(\"hi\",f);fclose(f);}"
probe stdio.h fseek     "FILE *f=fopen(\"x\",\"r\"); if(f){fseek(f,0,0);fclose(f);}"
probe stdio.h ftell     "FILE *f=fopen(\"x\",\"r\"); if(f){ftell(f);fclose(f);}"
probe stdio.h rewind    "FILE *f=fopen(\"x\",\"r\"); if(f){rewind(f);fclose(f);}"
probe stdio.h feof      "FILE *f=fopen(\"x\",\"r\"); if(f){(void)feof(f);fclose(f);}"
probe stdio.h ferror    "FILE *f=fopen(\"x\",\"r\"); if(f){(void)ferror(f);fclose(f);}"
probe stdio.h fflush    "fflush(stdout);"
probe stdio.h remove    "(void)remove(\"x\");"
probe stdio.h rename    "(void)rename(\"a\",\"b\");"
# CLASSIC_DESIGN: CP/M has no temp-file primitives; tmpfile() is deliberately
# absent from +cpm stdio.h across all compilers (not a missing bridge).
probe stdio.h tmpfile   "(void)tmpfile();"

echo ""
echo "--- ctype.h ---"
probe ctype.h isalpha   "(void)isalpha('a');"
probe ctype.h isdigit   "(void)isdigit('1');"
probe ctype.h isalnum   "(void)isalnum('a');"
probe ctype.h isspace   "(void)isspace(' ');"
probe ctype.h isupper   "(void)isupper('A');"
probe ctype.h islower   "(void)islower('a');"
probe ctype.h toupper   "(void)toupper('a');"
probe ctype.h tolower   "(void)tolower('A');"
probe ctype.h isprint   "(void)isprint('x');"
probe ctype.h ispunct   "(void)ispunct('.');"
probe ctype.h iscntrl   "(void)iscntrl(0);"

echo ""
echo "--- math.h (expect LINK_ERROR -- no libm) ---"
probe math.h sqrt       "(void)sqrt(4.0);"
probe math.h sin        "(void)sin(1.0);"
probe math.h cos        "(void)cos(1.0);"
probe math.h exp        "(void)exp(1.0);"
probe math.h log        "(void)log(1.0);"
probe math.h atan       "(void)atan(1.0);"
probe math.h pow        "(void)pow(2.0,3.0);"
probe math.h fabs       "(void)fabs(-1.0);"
probe math.h floor      "(void)floor(1.5);"
probe math.h ceil       "(void)ceil(1.5);"

echo ""
echo "--- time.h (expect LINK_ERROR on CP/M) ---"
probe time.h time       "time_t t; (void)time(&t);"
probe time.h clock      "(void)clock();"

echo ""
echo "PASS: stdlib coverage survey: $LINKS LINK, $ERRORS LINK_ERROR (see output above for details)"
