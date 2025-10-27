include(__link__.m4)

#ifndef __ARCH_H__
#define __ARCH_H__

// target configuration goes here

#ifdef __CPM
#include <../../../libsrc/newlib/target/cpm/config_cpm.h>
#endif

#ifdef __HBIOS
#include <../../../libsrc/newlib/target/hbios/config_hbios.h>
#endif

#ifdef __RC2014
#include <../../../libsrc/newlib/target/rc2014/config_rc2014.h>
#endif

#ifdef __SCZ180
#include <../../../libsrc/newlib/target/scz180/config_scz180.h>
#endif

#ifdef __SMS
#include <../../../libsrc/newlib/target/sms/config_sms.h>
#endif

#ifdef __VGL
#include <../../../libsrc/newlib/target/vgl/config_vgl.h>
#endif

#ifdef __EMBEDDED_Z80
#include <../../../libsrc/newlib/target/z80/config_z80.h>
#endif

#ifdef __EMBEDDED_Z180
#include <../../../libsrc/newlib/target/z180/config_z180.h>
#endif

#ifndef __ZXNEXT

#ifdef __SPECTRUM
#include <../../../libsrc/newlib/target/zx/config_zx.h>
#endif

#ifdef __TS2068
#include <../../../libsrc/newlib/target/ts2068/config_ts2068.h>
#endif

#endif

#ifdef __YAZ180
#include <../../../libsrc/newlib/target/yaz180/config_yaz180.h>
#endif

#ifdef __ZXNEXT
#include <../../../libsrc/newlib/target/zxn/config_zxn.h>
#endif

#endif
