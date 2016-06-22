;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	unsigned long file_sector_list (struct flos_file file);
;
;	Get the current sector and update the sector/cluster counters
;
;	$Id: file_sector_list.asm,v 1.4 2016-06-22 22:13:09 dom Exp $

;----------------------------------------------------------------
; ** doc related to kjt_file_sector_list **
;
; Input registers:   A  = Sector offset (within current cluster)
;                   DE = Cluster number
;
; Output registers:  A  = Next sector offset
;                   DE = Updated cluster
;                   HL = Memory address of LSB of 4 byte sector location
;
; How to use:
;
; To obtain the list of sectors that a file uses, first call "kjt_find_file" with
; the filename in HL as normal. On return, DE will be equal the first cluster that
; the file occupies. Clear A (as we're starting at the first sector of this cluster),
; and call "kjt_file_sector_list". On return A and DE are updated to the values required
; for the next time the routine is called (so store them) and HL points to the lowest
; significant byte of the sector address (Sector_LBA0). Copy the 4 bytes from HL to HL+3
; to your sector list buffer and loop around, calling "kjt_file_sector_list" (supplying
; it with the updated values for A and DE) for as many sectors as are used by the file
; (simply subtract 512 from a variable holding the file size every call until variable is = < 0)
;
; Notes: Obtaining the sector list is fast (it doesn't need to load the actual file data)
; and using an obtained sector list to load the file in question is much faster than
; the normal filesystem load routine. 
;
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  file_sector_list
	PUBLIC  _file_sector_list


file_sector_list:
_file_sector_list:
	; __FASTCALL__, HL=ptr to struct
	ld	de,17
	add hl,de

	push	hl		; struct ptr

	ld		e,(hl)	; get  current cluster number
	inc		hl
	ld		d,(hl)
	inc		hl
	ld		a,(hl)	; get current sector
	call	kjt_file_sector_list

	ex		(sp),hl	; struct ptr <-> sector ptr

	ld		(hl),e	; set  current cluster number
	inc		hl
	ld		(hl),d
	inc		hl
	ld		(hl),a	; set current sector

	pop		hl		; sector ptr
	ld		e,(hl)	; get  current cluster number
	inc		hl
	ld		d,(hl)
	inc		hl
	ld		a,(hl)	; get  current cluster number
	inc		hl
	ld		h,(hl)	; get  current cluster number
	ld		l,a
	ex		de,hl

	ret
