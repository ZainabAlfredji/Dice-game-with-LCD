/*
 * dice.inc
 *
 *  Created: 2021-12-16 09:54:05
 *   Author: Judy Sibai, Zainab Alfredji
 */ 


 roll_dice:
		LDI TEMP, 6			;dice have 6 values
test:	NOP
		NOP
		RCALL read_keyboard	;key-value is still pressed 
		CPI RVAL, ROLL_KEY
		BREQ roll			;yes, key 1 is still pressed
		RET					;no, key is released
roll:	DEC TEMP			;start cycle count here
		BREQ roll_dice		;R16 is zero?, start again at 6
		RJMP test			;no, keep rolling