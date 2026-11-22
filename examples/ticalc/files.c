/* Open a TI-83 Plus variable as a file.

   A bare name is an AppVar. That is the only type that can be created.
   A type letter and a colon select an existing variable:
   R:A real A, C:B complex B, L:L1 list L1, M:[A] matrix A,
   E:Y1 equation Y1, E:U(n) equation u(n), S:Str1 string 1,
   I:Pic1 picture 1, G:GDB1 graph database 1, P:DEMO program DEMO,
   O:GROUP group GROUP, A:DEMO AppVar DEMO.

   O_APPEND sets the position to the end once, at open.
   A missing name returns EINVAL. There is no ENOENT.
   rename returns ENOTSUP.
   remove of a graph equation returns ENOTSUP.
   A write open of an archived variable returns EACCES.
   A write that passes the end of a fixed variable writes no bytes.
*/

#pragma string name FILES

#include <fcntl.h>
#include <stdio.h>

int main(void)
{
    int fd;
    char buf[2];

    fd = open("DEMO", O_RDWR | O_CREAT | O_TRUNC, 0);
    if (fd < 0)
        return 1;
    if (write(fd, "hi", 2) != 2)
        return 2;
    if (lseek(fd, 0L, SEEK_SET) != 0L)
        return 3;
    if (read(fd, buf, 2) != 2)
        return 4;
    if (buf[0] != 'h' || buf[1] != 'i')
        return 5;
    if (close(fd) < 0)
        return 6;

    fd = open("P:NEWFILE", O_RDWR | O_CREAT, 0);
    if (fd >= 0) {
        close(fd);
        return 7;
    }

    fd = open("A:DEMO", O_RDONLY, 0);
    if (fd < 0)
        return 8;
    if (close(fd) < 0)
        return 9;

    fd = open("A:DEMO", O_WRONLY, 0);
    if (fd < 0)
        return 10;
    if (read(fd, buf, 1) >= 0)
        return 11;
    if (close(fd) < 0)
        return 12;

    if (remove("DEMO") < 0)
        return 13;

    fd = open("R:A", O_RDWR, 0);
    if (fd >= 0) {
        if (write(fd, "0123456789", 10) != 0)
            return 14;
        close(fd);
    }

    fd = open("P:DEMO", O_RDONLY, 0);
    if (fd >= 0)
        close(fd);

    return 0;
}
