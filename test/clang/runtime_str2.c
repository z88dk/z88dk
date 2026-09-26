/* Runtime regression test for the additional llvmz80 string bridges:
 * strstr, strspn, strcspn, strncmp, strncat, strtok, strrchr, strnlen,
 * strcasecmp (libsrc/string/c/sccz80/{fn}.asm "Clang bridge" block).
 *
 * Each bridge converts the reversed-arg llvmz80 register ABI
 * (HL=a2, DE=a1 for ZPROTO2; HL=a3, DE=a2, stack=a1 for ZPROTO3) into
 * the asm_X worker's expected register layout, then returns the result
 * in DE (the llvmz80 return-value register).
 *
 * RED:  with the old `defc ___X = X` stack-ABI aliases, every call returns
 *       garbage / hangs because the asm workers read the wrong registers.
 * GREEN: all assertions print matching values on a single output line.
 */
#include <string.h>
#include <stdio.h>

int main(void) {
    /* strstr: "world" starts at offset 6 in "hello world" */
    const char *hay = "hello world";
    char *ss = strstr(hay, "world");
    int ss_off = ss ? (int)(ss - hay) : -1;    /* expect 6 */

    /* strspn: "hello" all-in "hel" for 4 chars */
    int spn = (int)strspn("hello", "hel");     /* expect 4 */

    /* strcspn: "hello" - chars NOT in "lo" - first l at index 2 */
    int cspn = (int)strcspn("hello", "lo");    /* expect 2 */

    /* strncmp: "abcX" vs "abcY" for n=3 -> equal (0) */
    int ncmp = strncmp("abcX", "abcY", 3);     /* expect 0 */

    /* strncat: "foo" + up to 3 of "bar!" -> "foobar" */
    char nb[16]; strcpy(nb, "foo");
    strncat(nb, "bar!", 3);                    /* expect "foobar" */

    /* strrchr: last 'b' in "abcabc" -> points to "bc" */
    char *rr = strrchr("abcabc", 'b');         /* expect offset 4 */
    int rr_off = rr ? (int)(rr - "abcabc") : -1;

    /* strnlen: "hello" with max=3 -> 3 */
    int nl = (int)strnlen("hello", 3);         /* expect 3 */

    /* strcasecmp: "Hello" vs "hello" -> 0 */
    int ci = strcasecmp("Hello", "hello");     /* expect 0 */

    /* strtok: "a,b,c" split on "," -> "a", "b" */
    char tok[16]; strcpy(tok, "a,b,c");
    char *t1 = strtok(tok, ",");               /* expect "a" */
    char *t2 = strtok(NULL, ",");              /* expect "b" */

    printf("str2 ss=%d spn=%d cspn=%d ncmp=%d [%s] rr=%d nl=%d ci=%d [%s][%s]\n",
           ss_off, spn, cspn, ncmp, nb, rr_off, nl, ci, t1, t2);
    return 0;
}
