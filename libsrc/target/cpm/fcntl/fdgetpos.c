/*
 *  int fdgetpos(int fd, fpos_t *posn) __smallc;
 *
 *
 *  $Id: fdgetpos.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <cpm.h>

int fdgetpos(int fd, fpos_t *posn)
{
    struct fcb *fc = (struct fcb *)fd;

    *posn = (fpos_t)fc->rwptr;

    return 0;
}

