/* Open a TI-83 Plus variable as a file.

   A bare name is an AppVar, and it is the only type that can be created.
   A type letter and a colon select an existing variable:
   R:A real A, C:B complex B, L:L1 list L1, M:[A] matrix A,
   E:Y1 equation Y1, S:Str1 string 1, I:Pic1 picture 1,
   G:GDB1 graph database 1, P:DEMO program DEMO, O:GROUP group GROUP.
*/

#pragma string name FILES

#include <fcntl.h>
#include <stdio.h>

int main(void)
{
    int fd;
    char buf[2];

    fd = open("DEMO", O_RDWR | O_CREAT | O_TRUNC, 0);
    if (fd >= 0) {
        write(fd, "hi", 2);
        lseek(fd, 0L, SEEK_SET);
        read(fd, buf, 2);
        close(fd);
    }
    remove("DEMO");

    fd = open("R:A", O_RDONLY, 0);
    if (fd >= 0)
        close(fd);

    fd = open("P:DEMO", O_RDONLY, 0);
    if (fd >= 0)
        close(fd);

    return 0;
}
