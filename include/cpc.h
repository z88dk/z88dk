/*
 * Headerfile for Amstrad CPC specific functions
 *
 * $Id: cpc.h,v 1.1 2008-05-09 10:35:54 stefano Exp $
 */

#ifndef __CPC_H__
#define __CPC_H__

#include <sys/types.h>

///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

// FDC detection (0-none, 1-Amstrad, 2-Vortex)
extern int  __LIB__ cpc_fdc(void);

// CPC model detection (0-464, 1-664, 2-6128)
extern int  __LIB__ cpc_model(void);

#endif
