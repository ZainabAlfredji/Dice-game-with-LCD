/*
 * stat_data.inc
 *
 *  Created: 2021-12-16 11:30:17
 *   Author: Judy sibai, Zainab Alfredji
 */ 
/* --------------------------------------------------- 
Space in the RAM to save the results from dice throws. 
The following functions are provided: 
	
	store_stat (R24 contains the dice value)
	The function will increment the 
	Total number of throws and the 
	number of throws with results equals R24.
get_stat (R24 gives the value for which the 
	result is retrieved. If R24 = 0, the 
	total number of throws shall be returned. 
	The result is returned in R24. 
clear_stat (no parameters in nor out) 
	Clears all data. 
--------------------------------------------------------*/ 
.DSEG 					; The following applies to the RAM: 
.ORG 		0x100		; Set starting 
						; address of data
						; segment to 0x100 
	
statistics:		.BYTE 7		;skapa sa mycket plats som behovs.
							;Antag att max varde per lagrad variable ar 255>
				.CSEG

store_stat: 		
			LDI YL, LOW(statistics)
			LDI YH, HIGH(statistics)

			PUSH R24		; push R24
			LD R24, Y		; load R24, Y
			INC R24			; increase R24
			ST Y, R24		; store R24 to Y
			POP R24			; take back R24
			ADD YL, R24		; add R24 to YL
			LD R24, Y
			INC R24
			ST Y, R24

			RET

get_stat:					
			LDI YL, LOW(statistics)
			LDI YH, HIGH(statistics)

			ADD YL, RVAL	; add the stored data
			LD RVAL, Y

			RET

clear_stat: 				
			RCALL lcd_clear_display		
			PRINTSTRING clearstring
			LDI YL, LOW(statistics)
			LDI YH, HIGH(statistics)
back:		LDI R24, 0		;clear stats by loading R24 to 0
			ST Y+, R24		;store Y+ to R24
			CPI YL, 8		
			BRNE back

			RET