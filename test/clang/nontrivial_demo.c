/* Non-trivial end-to-end demo for `zcc +cpm -compiler=llvmz80`.
 *
 * Exercises recursion, structs, static arrays, the sieve of Eratosthenes
 * (memset), sprintf (%s/%d/%ld/%lu), 32-bit multiply/divide/modulo runtime
 * helpers, and strcpy/strlen -- i.e. the integer helpers, the string/mem
 * clang bridges, and the fastcall-redirect header routing all at once.
 *
 * Build + run (native, no Docker):
 *   export PATH=/Users/ravn/z80/z88dk/bin:$PATH
 *   export ZCCCFG=/Users/ravn/z80/z88dk/lib/config
 *   zcc +cpm -compiler=llvmz80 -O2 nontrivial_demo.c -o nt.com -create-app
 *   /Users/ravn/z80/ntvcm/ntvcm nt.com
 *
 * Expected output (matches the host reference exactly):
 *   Ada/36 fib(15)=610 primes<200=46 12345*6=74070
 *   div=1003 mod=12 strlen=46
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* recursion */
static long fib(int n) { return n < 2 ? n : fib(n - 1) + fib(n - 2); }

/* struct + fixed array */
typedef struct {
    char name[12];
    int age;
} person_t;

/* sieve of Eratosthenes -> count primes below limit */
static int count_primes(int limit) {
    static unsigned char sieve[200];
    memset(sieve, 1, sizeof sieve);
    sieve[0] = sieve[1] = 0;
    int c = 0;
    for (int i = 2; i < limit; i++) {
        if (sieve[i]) {
            c++;
            for (int j = i * 2; j < limit; j += i) sieve[j] = 0;
        }
    }
    return c;
}

int main(void) {
    person_t p;
    strcpy(p.name, "Ada");
    p.age = 36;

    char buf[64];
    sprintf(buf, "%s/%d fib(15)=%ld primes<200=%d %lu*%lu=%lu",
            p.name, p.age, fib(15), count_primes(200),
            12345UL, 6UL, 12345UL * 6UL);
    printf("%s\n", buf);

    /* 32-bit divide/modulo runtime helpers */
    long a = 1000003, b = 997;
    printf("div=%ld mod=%ld strlen=%d\n", a / b, a % b, (int)strlen(buf));
    return 0;
}
