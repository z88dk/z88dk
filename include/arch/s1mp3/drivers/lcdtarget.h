
#ifndef  __LCDTARGET_H__
#define  __LCDTARGET_H__

#include <ATJ2085_Ports.h>


#define LCDTARGET_CE_REGISTER   EM_PAGE_HI_REG
#define LCDTARGET_CE            EM_PAGE_HI_CE3_INV

/* IO Register/Pins */
#define LCDTARGET_REGISTER  MFP_GPOA_SELECT_REG
#define LCDTARGET_WHYTHIS   MFP_SELECT_CS0S
#define LCDTARGET_ENABLE    GPOA2_ENABLE
#define LCDTARGET_A0        GPOA2_OUTPUT_0
#define LCDTARGET_UNUSED    GPOA2_OUTPUT_1
#define LCDTARGET_RESET_INV GPOA2_OUTPUT_2
#define LCDTARGET_MASK      (LCDTARGET_ENABLE | LCDTARGET_A0 | LCDTARGET_RESET_INV | LCDTARGET_WHYTHIS | LCDTARGET_UNUSED)

/* command function equates for S6B0724 LCD Display Controller */
#define LCD_DISP_OFF 		0xAE	/* turn LCD panel OFF */
#define LCD_DISP_ON		0xAF	/* turn LCD panel ON */
#define LCD_SET_LINE		0x40	/* set line for COM0 (6 lsbs = ST5:ST4:ST3:ST2:ST1:ST0) */
#define LCD_SET_PAGE		0xB0	/* set page address (4 lsbs = P3:P2:P1:P0) */
#define LCD_SET_COL_HI		0x10	/* set column address (4 lsbs = Y7:Y6:Y5:Y4) */
#define LCD_SET_COL_LO		0x00	/* set column address (4 lsbs = Y3:Y2:Y1:Y0) */
#define LCD_SET_ADC_NOR		0xA0	/* ADC set for normal direction */
#define LCD_SET_ADC_REV		0xA1	/* ADC set for reverse direction */
#define LCD_DISP_NOR		0xA6	/* normal pixel display */
#define LCD_DISP_REV		0xA7	/* reverse pixel display */
#define LCD_EON_OFF		0xA4	/* normal display mode */
#define LCD_EON_ON		0xA5	/* entire display on */

#define LCD_SET_BIAS_0		0xA2	/* set LCD bias select to 0 */
#define LCD_SET_BIAS_1		0xA3	/* set LCD bias select to 1 */
#define LCD_SET_MODIFY		0xE0	/* set modify read mode */
#define LCD_CLR_MODIFY		0xEE	/* clear modify read mode */
#define LCD_RESET		0xE2	/* soft reset command */
#define LCD_SET_SHL_NOR		0xC0	/* set COM direction normal */
#define LCD_SET_SHL_REV		0xC8	/* set COM direction reverse */
#define LCD_PWR_CTL		0x28	/* set power control (3 lsbs = VC:VR:VF) */
#define LCD_REG_RESISTOR	0x20	/* set regulator resistor (3 lsbs = R2:R1:R0) */

#define LCD_REF_VOLT_MODE	0x81	/* set reference voltage mode (first of dual command) */
#define LCD_REF_VOLT_REG	0x00	/* set reference voltage register (6 lsbs = SV5:SV4:SV3:SV2:SV1:SV0) */
#define LCD_ST_IND_MODE_0	0xAC	/* set static indicator mode to 0 */
#define LCD_ST_IND_MODE_1	0xAD	/* set static indicator mode to 1 */
#define LCD_ST_IND_REG		0x00	/* set the static indicator register (2 lsbs = S1:S0) */
#define LCD_NOP			0xE3	/* LCD controller NOP command */
#define LCD_TEST_CMD_1		0xF0	/* LCD Test Instruction 1.. do not use */
#define LCD_TEST_CMD_2		0x90	/* LCD Test Instruction 2.. do not use */
//#define LCD_BOOSTER_SET		0xF8	/* set booster ratio (first of dual command) */
//#define LCD_BOOSTER_RATE_4X	0x00	/* booster ratio */

extern void __LIB__ LCDTARGET_Initialise( unsigned char Contrast );
extern void __LIB__ LCDTARGET_UpdateScreen( void );


#endif /* __LCDTARGET_H__ */

