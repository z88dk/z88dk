/* issue23_fcntl_write.c -- characterization repro for ravn/z88dk#23.
 *
 * #23: under -compiler=llvmz80 the raw fcntl layer open()/write() does not
 * create a file. Run-verified 2026-08-04:
 *   clang : open=0, write=512 (want 3), NO file on host disk.
 *   sccz80: open=6898, write=3, WP.DAT created (128 B) -- proves ntvcm and the
 *           fcntl path work; only the clang ABI wiring is broken.
 *
 * So #23 is STILL RELEVANT. write() returns a garbage byte count (512 instead
 * of the 3 requested) and nothing reaches disk.
 *
 * GREEN (when #23 is fixed): write() returns 3.
 * RED  (now): write() returns something other than 3 (observed 512).
 */
#include <stdio.h>
#include <fcntl.h>

int main(void)
{
    char buf[3] = { 'X', 'Y', 'Z' };
    int fd = open("WP.DAT", O_WRONLY | O_TRUNC | O_CREAT, 0);
    printf("open=%d\n", fd); fflush(stdout);
    int w = write(fd, buf, 3);
    printf("write=%d\n", w); fflush(stdout);   /* want 3 */
    printf("close=%d\n", close(fd)); fflush(stdout);
    return 0;
}
