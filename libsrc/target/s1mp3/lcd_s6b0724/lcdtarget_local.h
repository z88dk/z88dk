
#ifndef __LCDTARGET_LOCAL_H__
#define __LCDTARGET_LOCAL_H__

extern void LCDTARGET_EnableLCDWrite( void );
extern void LCDTARGET_DisableLCDWrite( void );
extern void LCDTARGET_PutControlByte( unsigned int byte );
extern void LCDTARGET_PutDataByte( unsigned int byte );

#endif /* __LCDTARGET_LOCAL_H__ */

