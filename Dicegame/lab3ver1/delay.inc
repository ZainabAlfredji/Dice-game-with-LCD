/*
 * delay.inc
 *
 * Author:	Judy Sibai, Zainab Alfredji
 *
 * Date:	2021-12-16
 */ 

;==============================================================================
; Delay of 1 µs (including RCALL)
;==============================================================================
delay_1_micros:   /* UPPGIFT: komplettera med ett antal NOP-instruktioner!!! */
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	RET

;==============================================================================
; Delay of X µs
;	LDI + RCALL = 4 cycles
;==============================================================================
delay_micros:   /* UPPGIFT: komplettera med ett antal NOP-instruktioner!!! */
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

	DEC R24
	CPI R24, 255		; more loops to do?
	BRNE delay_micros	;	continue!
	RET

;==============================================================================
; Delay of X ms
;	LDI + RCALL = 4 cycles
;==============================================================================
delay_ms:
	MOV R19, R24
loop_dms:
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	DEC R19
	CPI R19, 1			; more loops to do?
	BRNE loop_dms		;	continue!
	RET

delay_s:
	MOV R18, R24

loop_s:
	LDI R24, 250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	DEC R18
	CPI R18, 0			; more loops to do?
	BRNE loop_s			; continue!

delay_1_s:
	//MOV R18, R24

//loop_1s:
	LDI R24,250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	//LDI R24, 250
	//RCALL delay_ms
	//LDI R24, 250
	//RCALL delay_ms
//	DEC R18
//	CPI R18, 0			; more loops to do?
//	BRNE loop_1s		; continue!
	RET