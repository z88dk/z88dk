/* 
	HTC Compatibility Library and OZ extras 
	5. INTERRUPT HANDLING

	$Id: ozint.h,v 1.1 2003-10-21 17:15:19 stefano Exp $
*/

extern __LIB__ _ozcustomisr(void);

extern int __LIB__  ozsetisr(void *f);   /* set custom ISR with paging */
extern int __LIB__  _ozsetisr(void *f);  /* same, but no paging--routine must always
                            be paged in */
extern __LIB__ ozisroff(void);      /* turn off custom ISR (set im 1) */
extern __LIB__ ozdisableinterrupts(void);
extern __LIB__ ozenableinterrupts(void);
extern __LIB__ ozintwait(void);

