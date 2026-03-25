/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: get_current_volume.c $
 */

#include <arch/hdos.h>

int get_current_volume()
{
    return (hdos_default[2]-'0');
}
