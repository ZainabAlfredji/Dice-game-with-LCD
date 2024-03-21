/*
 * keyboard.inc
 *
 *  Created: 2021-12-16 08:45:24
 *   Author: Judy Sibai, Zainab Alfredji

 */ 

;==============================================================================
; Define number
;==============================================================================
TO_ASCII:

	LDI ZH, high (map_table<< 1)	;initialize Z pointer
	LDI ZL, low(map_table<< 1)
	ADD ZL, RVAL					;add index
	LDI RVAL, 0X00
	ADC ZH, RVAL					; add 0 to catch Carry,if present
	LPM RVAL, Z
	RET

;==============================================================================
; Read keyboard
;==============================================================================
	
map_table: .DB "147*2580369#"

read_keyboard:
	SBI PORTC, 7
	LDI R18, 0	; reset counter
scan_key:
	MOV R19, R18		; R19 => R18
	LSL R19
	LSL R19
	LSL R19
	LSL R19

	OUT PORTB, R19		; set column and row
	LDI R24, 10
	RCALL delay_ms

	SBIC PINE, 6		; PINE.6 = 0
	RJMP return_key_val
	INC R18
	CPI R18, 12
	BRNE scan_key
	LDI R18, NO_KEY		; no key was pressed!

return_key_val:
	MOV RVAL, R18		; RVAL 0 => R18
	CBI PORTC, 7
	RET


