/* Runtime regression test for the llvmz80 string bridges fixed in
 * "Group C klasse 2 batch C" (a Klasse-1-style asm-bridge leftover
 * found while investigating klasse 2): strrspn, strrcspn
 * (libsrc/string/c/sccz80/{strrspn,strrcspn}.asm "Clang bridge" block).
 *
 * Both still carried the old broken `defc ___X = X` stack-ABI alias
 * that commits 2842d1c8f7 (14 functions) and 1ab8970eac
 * (stricmp/strrstr/strlcpy) fixed elsewhere but missed here. Replaced
 * with proper register-ABI bridges following the strrstr.asm pattern
 * (swap HL/DE in -- clang's __ZPROTO2-reversed-arg call passes HL=set,
 * DE=s but the asm worker wants HL=str, DE=cset -- call the asm_X
 * worker, swap the size_t result into DE for the sdcccall(1) return
 * convention).
 *
 * RED:  strrspn/strrcspn both returned 512 regardless of input.
 * GREEN: both bridges compute the correct result.
 */
#include <string.h>
#include <stdio.h>

int main(void) {
    /* strrspn: reverse of strspn -- leading chars up to & including the
     * last char NOT in cset. "abcdee" vs "e" -> 4 (per asm_strrspn.asm
     * worked example). */
    size_t rsp = strrspn("abcdee", "e");

    /* strrcspn: reverse of strcspn -- leading chars up to & including
     * the last char IN cset. "Sentence! Part of a" vs "!.?" -> 9 (per
     * asm_strrcspn.asm worked example). */
    size_t rcsp = strrcspn("Sentence! Part of a", "!.?");

    printf("str4 rsp=%d rcsp=%d\n", (int)rsp, (int)rcsp);
    return 0;
}
