#ifndef __SYS_PROTO_H__
#define __SYS_PROTO_H__

// 
// 

#if __SCCZ80
#define __ZPROTO2(r,p, n,t1,a1,t2,a2) extern r __LIB__ p n(t1 a1,t2 a2) __smallc;
#elif __SDCC
#define __ZPROTO2(r,p, n,t1,a1,t2,a2) extern r p n(t1 a1,t2 a2) __smallc;
#else
#define __ZPROTO2(r,p, n,t1, a1,t2, a2) extern r p __##n  (t2 a2,t1 a1); \
  __attribute__((always_inline)) \
  static inline r p n(t1 a1,t2 a2) \
        __attribute__((overloadable)) \
        __attribute__((enable_if(1, ""))) { \
        return __##n  (a2,a1); \
  }
#endif

#if __SCCZ80
#define __ZPROTO3(r,p, n,t1,a1,t2,a2,t3,a3) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3) __smallc;
#elif __SDCC
#define __ZPROTO3(r,p, n,t1,a1,t2,a2,t3,a3) extern r p n(t1 a1,t2 a2, t3 a3) __smallc;
#else
#define __ZPROTO3(r,p, n,t1,a1,t2,a2,t3,a3) extern r p __##n  (t3 a3, t2 a2,t1 a1); \
  __attribute__((always_inline)) \
  static inline r p n(t1 a1,t2 a2, t3 a3) \
        __attribute__((overloadable)) \
        __attribute__((enable_if(1, ""))) { \
        return __##n  (a3, a2,a1); \
  }
#endif

#if __SCCZ80
#define __ZPROTO4(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3,t4 a4) __smallc;
#elif __SDCC
#define __ZPROTO4(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4) extern r p n(t1 a1,t2 a2, t3 a3, t4 a4) __smallc;
#else
#define __ZPROTO4(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4) extern r p __##n  (t4 a4, t3 a3, t2 a2,t1 a1); \
  __attribute__((always_inline)) \
  static inline r p n(t1 a1,t2 a2, t3 a3, t4 a4) \
        __attribute__((overloadable)) \
        __attribute__((enable_if(1, ""))) { \
        return __##n  (a4, a3, a2,a1); \
  }
#endif

#if __SCCZ80
#define __ZPROTO5(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4,t5,a5) extern r __LIB__ p n(t1 a1,t2 a2, t3 a3,t4 a4,t5 a5) __smallc;
#elif __SDCC
#define __ZPROTO5(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4,t5,a5) extern r p n(t1 a1,t2 a2, t3 a3, t4 a4,t5 a5) __smallc;
#else
#define __ZPROTO5(r,p, n,t1,a1,t2,a2,t3,a3,t4,a4,t5,a5) extern r p __##n  (t5 a5, t4 a4, t3 a3, t2 a2,t1 a1); \
  __attribute__((always_inline)) \
  static inline r p n(t1 a1,t2 a2, t3 a3,t4 a4,t5 a5) \
        __attribute__((overloadable)) \
        __attribute__((enable_if(1, ""))) { \
        return __##n  (a5, a4, a3, a2,a1); \
  }
#endif



#endif
