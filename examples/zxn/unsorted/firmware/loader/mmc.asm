;
;TBBlue / ZX Spectrum Next project
;
;Copyright (c) 2015 Fabio Belavenuto & Victor Trucco
;
;This program is free software: you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation, either version 3 of the License, or
;(at your option) any later version.
;
;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;
;You should have received a copy of the GNU General Public License
;along with this program.  If not, see <http://www.gnu.org/licenses/>.
;

SECTION bss_user

mmc_type:  defs 1

SECTION code_user

EXTERN __IO_SPI_CONTROL
EXTERN __IO_SPI_DATA

; Comandos SPI:
CMD0  = 0  | 0x40
CMD1  = 1  | 0x40
CMD8  = 8  | 0x40
CMD9  = 9  | 0x40
CMD10 = 10 | 0x40
CMD12 = 12 | 0x40
CMD16 = 16 | 0x40
CMD17 = 17 | 0x40
CMD18 = 18 | 0x40
CMD24 = 24 | 0x40
CMD25 = 25 | 0x40
CMD55 = 55 | 0x40
CMD58 = 58 | 0x40
ACMD23   = 23 | 0x40
ACMD41   = 41 | 0x40


; ------------------------------------------------
; Algorithm to initialize an SD card
; ------------------------------------------------
; unsigned char MMC_Init();
;

PUBLIC _MMC_Init

_MMC_Init:
   ld    a, 0xFF
   out      (__IO_SPI_CONTROL), a            ; disable SD
   ld    b, 10                ; send 80 clock pulses with sd card disabled
enviaClocksInicio:
   ld    a, 0xFF
   out      (__IO_SPI_DATA), a
   djnz  enviaClocksInicio
   ld    a, 0xFE
   out      (__IO_SPI_CONTROL), a            ; enable SD
   ld    a, CMD12
   call  SD_SEND_CMD             ; cancel any multi-sector read
   ld    b, 9
wait_cancel:
   in    a, (__IO_SPI_DATA)            ; read 9 bytes to ensure cancellation takes effect
   djnz     wait_cancel
   ld    b, 16                ; 16 attempts to CMD0
SD_SEND_CMD0:
   ld    a, CMD0              ; first command: CMD0
   ld    de, 0
   push  bc
   call  SD_SEND_CMD_2_ARGS_TEST_BUSY
   pop      bc
   jp nc, testaSDCV2             ; sd card responded to CMD0, jump
   djnz  SD_SEND_CMD0
   ld    l, 0                 ; cartao nao respondeu ao CMD0, retornar 0
IF __SCCZ80
   ld    h, l
ENDIF
   ld    a, 0xFF
   out      (__IO_SPI_CONTROL), a            ; desabilita SD
   ret
testaSDCV2:
   ld    a, CMD8
   ld    de, 0x1AA
   call  SD_SEND_CMD_2_ARGS_GET_R3
   ld    hl, SD_SEND_CMD1        ; HL aponta para rotina correta
   jr    c, pula4               ; cartao recusou CMD8, enviar comando CMD1
   ld    hl, SD_SEND_ACMD41         ; cartao aceitou CMD8, enviar comando ACMD41
pula4:
   ld    bc, 120              ; 120 tentativas
loop:
   push  bc
   call  jumpHL                 ; chamar rotina correta em HL
   pop      bc
   jp nc,   iniciou
   djnz  loop
   dec      c
   jr    nz, loop
deuerroi:
   ld    l, 0                 ; erro, retornar 0
IF __SCCZ80
   ld    h, l
ENDIF
   ld    a, 0xFF
   out      (__IO_SPI_CONTROL), a            ; desabilita SD
   ret
jumpHL:
   jp    (hl)                 ; chamar rotina correta em HL
iniciou:
   ld    a, CMD58             ; ler OCR
   ld    de, 0
   call  SD_SEND_CMD_2_ARGS_GET_R3  ; enviar comando e receber resposta tipo R3
   jp c, deuerroi
   ld    a, b                 ; testa bit CCS do OCR que informa se cartao eh SDV1 ou SDV2
   and      0x40
   ld    (mmc_type), a           ; salva informacao da versao do SD (V1 ou V2)
   call  z, mudarTamanhoBlocoPara512   ; se bit CCS do OCR for 1, eh cartao SDV2 (Block address - SDHC ou SDXD)
                              ; e nao precisamos mudar tamanho do bloco para 512
   ld    a, 0xFF
   out      (__IO_SPI_CONTROL), a            ; desabilita SD
   ld    a, (mmc_type)           ; retornar tipo de cartao
IF __SCCZ80
   ld    h, 0
ENDIF
   ld    l, 3
   cp    0x40
   ret z
   ld    l, 2
   ret

; ------------------------------------------------
; Setar o tamanho do bloco para 512 se o cartao
; for SDV1
; ------------------------------------------------
mudarTamanhoBlocoPara512:
   ld    a, CMD16
   ld    bc, 0
   ld    de, 512
   jp    SD_SEND_CMD_GET_ERROR



; ------------------------------------------------
; Ler um bloco de 512 bytes do cartao
; ------------------------------------------------
; unsigned char MMC_Read(unsigned long lba, unsigned int *buffer)
; callee linkage

PUBLIC _MMC_Read
PUBLIC asm_MMC_Read

_MMC_Read:

IF __SDCC
	pop   hl
	pop   de
	pop   bc
	ex    (sp),hl
ENDIF

IF __SCCZ80
	pop   af
	pop   hl
	pop   de
	pop   bc
	push  af
ENDIF

asm_MMC_Read:

	; bcde = unsigned long lba
	; hl   = unsigned char *buffer

   ld    a, 0xFE
   out      (__IO_SPI_CONTROL), a            ; habilita SD

   ld    a, (mmc_type)           ; verificar se eh SDV1 ou SDV2
   or    a
   call  z, blocoParaByte        ; se for SDV1 converter blocos para bytes

   ld    a, CMD17             ; ler somente um bloco com CMD17 = Read Single Block
   call  SD_SEND_CMD_GET_ERROR
   jr    nc, ok2
erro2:
   ld    l, 0                 ; informar erro
IF __SCCZ80
   ld    h, l
ENDIF
   ret
ok2:
   call  WAIT_RESP_FE
   jr c, erro2
   ld    bc, __IO_SPI_DATA
   inir
   inir
   nop
   in    a, (__IO_SPI_DATA)            ; descarta CRC
   nop
   in    a, (__IO_SPI_DATA)
   ld    l, 1
IF __SCCZ80
   ld    h, 0
ENDIF
   ret

; ------------------------------------------------
; Converte blocos para bytes. Na pratica faz
; BC DE = (BC DE) * 512
; ------------------------------------------------
blocoParaByte:
   ld    b, c
   ld    c, d
   ld    d, e
   ld    e, 0
   sla      d
   rl    c
   rl    b
   ret

; ------------------------------------------------
; Enviar CMD1 para cartao. Carry indica erro
; Destroi AF, BC, DE
; ------------------------------------------------
SD_SEND_CMD1:
   ld    a, CMD1
SD_SEND_CMD_NO_ARGS:
   ld    bc, 0
   ld    d, b
   ld    e, c
SD_SEND_CMD_GET_ERROR:
   call  SD_SEND_CMD
   or    a
   ret   z                       ; se A=0 nao houve erro, retornar
   ; fall throw

; ------------------------------------------------
; Informar erro
; Nao destroi registradores
; ------------------------------------------------
setaErro:
   scf
   ret

; ------------------------------------------------
; Enviar comando ACMD41
; ------------------------------------------------
SD_SEND_ACMD41:
   ld    a, CMD55
   call  SD_SEND_CMD_NO_ARGS
   ld    a, ACMD41
   ld    bc, 0x4000
   ld    d, c
   ld    e, c
   jr    SD_SEND_CMD_GET_ERROR

; ------------------------------------------------
; Enviar comando em A com 2 bytes de parametros
; em DE e testar retorno BUSY
; Retorna em A a resposta do cartao
; Destroi AF, BC
; ------------------------------------------------
SD_SEND_CMD_2_ARGS_TEST_BUSY:
   ld    bc, 0
   call  SD_SEND_CMD
   ld    b, a
   and      0xFE                 ; testar bit 0 (flag BUSY)
   ld    a, b
   jr    nz, setaErro            ; BUSY em 1, informar erro
   ret                           ; sem erros

; ------------------------------------------------
; Enviar comando em A com 2 bytes de parametros
; em DE e ler resposta do tipo R3 em BC DE
; Retorna em A a resposta do cartao
; Destroi AF, BC, DE, HL
; ------------------------------------------------
SD_SEND_CMD_2_ARGS_GET_R3:
   call  SD_SEND_CMD_2_ARGS_TEST_BUSY
   ret   c
   push  af
   call  WAIT_RESP_NO_FF
   ld    h, a
   call  WAIT_RESP_NO_FF
   ld    l, a
   call  WAIT_RESP_NO_FF
   ld    d, a
   call  WAIT_RESP_NO_FF
   ld    e, a
   ld    b, h
   ld    c, l
   pop      af
   ret

; ------------------------------------------------
; Enviar comando em A com 4 bytes de parametros
; em BC DE e enviar CRC correto se for CMD0 ou
; CMD8 e aguardar processamento do cartao
; Destroi AF, BC
; ------------------------------------------------
SD_SEND_CMD:
   out      (__IO_SPI_DATA), a
   push  af
   ld    a, b
   nop
   out      (__IO_SPI_DATA), a
   ld    a, c
   nop
   out      (__IO_SPI_DATA), a
   ld    a, d
   nop
   out      (__IO_SPI_DATA), a
   ld    a, e
   nop
   out      (__IO_SPI_DATA), a
   pop      af
   cp    CMD0
   ld    b, 0x95                 ; CRC para CMD0
   jr    z, enviaCRC
   cp    CMD8
   ld    b, 0x87                 ; CRC para CMD8
   jr    z, enviaCRC
   ld    b, 0xFF                 ; CRC dummy
enviaCRC:
   ld    a, b
   out      (__IO_SPI_DATA), a
   jr    WAIT_RESP_NO_FF

; ------------------------------------------------
; Esperar que resposta do cartao seja $FE
; Destroi AF, B
; ------------------------------------------------
WAIT_RESP_FE:
   ld    b, 10                ; 10 tentativas
loop1:
   push  bc
   call  WAIT_RESP_NO_FF            ; esperar resposta diferente de $FF
   pop      bc
   cp    0xFE                 ; resposta é $FE ?
   ret   z                       ; sim, retornamos com carry=0
   djnz  loop1
   scf                           ; erro, carry=1
   ret

; ------------------------------------------------
; Esperar que resposta do cartao seja diferente
; de $FF
; Destroi AF, BC
; ------------------------------------------------
WAIT_RESP_NO_FF:
   ld    bc, 100              ; 100 tentativas
loop2:
   in    a, (__IO_SPI_DATA)
   cp    0xFF                 ; testa $FF
   ret   nz                      ; sai se nao for $FF
   djnz  loop2
   dec      c
   jr    nz, loop2
   ret
