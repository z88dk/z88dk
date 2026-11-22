

#ifndef __ARCH_H__
#define __ARCH_H__

#include <sys/compiler.h>

#ifdef __SPECTRUM
#include <../libsrc/newlib/target/zx/config_zx.h>
#endif

#ifdef __ZXNEXT
#include <../libsrc/newlib/target/zxn/config_zxn.h>
#endif

#ifdef __SMS
#include <../lib/target/sms/def/sms.h>
#endif

#endif

