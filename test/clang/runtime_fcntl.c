/* Runtime regression test for the llvmz80 fd-layer ABI fixed in
 * "Group C klasse 3": open/read/write (include/fcntl.h __ZPROTO3 class).
 *
 * The +test target's fcntl workers (libsrc/target/test/fcntl/{open,read,
 * write}.asm) are plain stack-based smallc routines: they read all three
 * 16-bit args left-to-right off the stack (name/fd deepest at [sp+6]) and
 * caller-cleans (`ret`). All three asm labels open/_open/___open alias this
 * one worker; there is no register bridge.
 *
 * include/fcntl.h declares them via __ZPROTO3, whose clang branch reverses
 * the args and uses the DEFAULT sdcccall(1) convention (HL=1st, DE=2nd,
 * stack=3rd) -- a REGISTER contract that a purpose-written ___name bridge
 * must honour (as itoa/ltoa do in libsrc/l/llvmz80/__itoa.asm). The fcntl
 * workers have no such bridge, so under llvmz80 open() returned a garbage
 * fd (245) and read() a garbage count -> md5sum hashed wrong bytes.
 *
 * The fix (fcntl.h __LLVMZ80 branch) declares reversed-arg __smallc entries
 * (__open(mode,flags,name) etc): sdcccall(0) pushes the reversed params
 * right-to-left, landing name deepest at [sp+6] exactly where the unmodified
 * stack worker reads it. No asm change.
 *
 * RED:  open() returns a garbage fd (e.g. 245), read() a garbage count.
 * GREEN: open() returns a valid fd, read() returns the exact byte count and
 *        the bytes' checksum matches, write() returns the exact count.
 */
#include <fcntl.h>
#include <stdio.h>

int main(void) {
    int fd = open("FIX.TXT", O_RDONLY, 0);
    int fd_ok = (fd >= 0) ? 1 : 0;
    int n = -1, sum = 0;
    if (fd_ok) {
        unsigned char buf[32];
        n = read(fd, buf, sizeof(buf));
        for (int i = 0; i < n; i++) sum += buf[i];
        close(fd);
    }
    int wn = -1;
    int wfd = open("OUT2.TXT", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (wfd >= 0) {
        wn = write(wfd, "ok\n", 3);
        close(wfd);
    }
    /* GREEN: fd_ok=1 n=10 sum=1015 wn=3  (FIX.TXT = "abcdefghij") */
    printf("fcntl fd_ok=%d n=%d sum=%d wn=%d\n", fd_ok, n, sum, wn);
    return 0;
}
