/*
 *  long fdtell(int fd)
 *
 *  $Id: fdtell.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>


long fdtell(int fd)
{
    struct fcb *fc = (struct fcb *)fd;

    return (fc->rwptr);
}

