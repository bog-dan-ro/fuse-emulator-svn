; Routine to sync with interrupts

; Copyright 2007 Philip Kendall <philip-fuse@shadowmagic.org.uk>
	
; This program is licensed under the GNU General Public License. See the
; file `COPYING' for details

; IM2 table from 0xbe00 to 0xbf00 (inclusive!)
interruptsync_location equ 0xbe

; IM2 routine at 0xbdbd
interruptsync_isrbyte equ interruptsync_location - 1
sync_isr equ interruptsync_isrbyte * 0x0101

; Setup routine; must be called before interruptsync

interruptsync_init
PROC
	di

	ld hl, interruptsync_location * 0x0100
	ld (hl), interruptsync_isrbyte
	ld de, interruptsync_location * 0x0100 + 1
	ld bc, 0x0100
	ldir

	ld hl, sync_isr
	ld (hl), 0xc3		; JP

	ld a, interruptsync_location
	ld i,a

	im 2

	ret
ENDP

; Synchronisation routine: return from this will be exactly 92 tstates
; after interrupt with A reset if successful. If it couldn't sync with
; interrupts, it will return with A set to 0xde.

interruptsync
PROC
	xor a
	ld hl, (framelen)
	ld bc, 0x4fe6
	sbc hl, bc
	ld (_delay), hl

	ld hl, sync_isr + 1
	ld (hl), _isr % 0x100
	inc hl
	ld (hl), _isr / 0x100
	ld b, 0x00

	ei
	halt

	; jp _isr		  19 - 22
_isr
	ld hl, sync_isr + 1	; 29 - 32
	ld (hl), _isr3 % 0x100	; 39 - 42
	inc hl			; 49 - 52
	ld (hl), _isr3 / 0x100	; 55 - 58

_isr1	ld hl, 0xc000 		; 65 - 68
	call delay		; 75 - 78
	ld hl, (_delay)		; 49227 - 49230
	call delay		; 49243 - 49246

				; 48K / 128K timings
	ld hl, 0x0f78		; 65909 - 65912 / 66929 - 66932
	call delay		; 65919 - 65922 / 66939 - 66942

	ei			; 69879 - 69882 / 70899 - 70902
	xor a			; 69883 - 69886 / 70903 - 70906
	inc a			; 69887 / 70907 or interrupt occurred
	di			; Should not be executed
	pop hl
	ld a, 0xff		; Error code
	ret

	; jp _isr3		  19 - 22
_isr3	pop hl			; 29 - 32
	cp b			; 39 - 42
	nop			; 43 - 46
	nop			; 47 - 50
	nop			; 51 - 54
	jp z, _isr1		; 55 - 58
	pop hl			; 68
	xor a			; 78
	ret			; 82

_delay	defw 0x0000

ENDP
