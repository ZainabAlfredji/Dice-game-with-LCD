/*
 * lab3ver1.asm
 * 
 * This is a very simple demo program made for the course DA215A at
 * Malmö University. The purpose of this program is:
 *	-	To test if a program can be transferred to the ATmega32U4
 *		microcontroller.
 *	-	To provide a base for further programming in "Laboration 1".
 *
 * After a successful transfer of the program, while the program is
 * running, the embedded LED on the Arduino board should be turned on.
 * The LED is connected to the D13 pin (PORTC, bit 7).
 *
 * Author:	Judy Sibai, Zainab Alfredji
 *
 * Date:	2021-12-16
 */ 
 
;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU RESET		= 0x0000
	.EQU PM_START	= 0x0056
	.DEF TEMP 		= R16
	.DEF RVAL		= R24
	.EQU NO_KEY		= 0x0F
	.DEF NO_PRESS	= R25
	.EQU ROLL_KEY	= 0x04		;Press 2
	.EQU PRESS_C	= 0X08		;Press 3
	.EQU PRESS_H	= 0X06		;Press 8
	.EQU PRESS_I	= 0Xa		;Press 9


;==============================================================================
; Start of program
;==============================================================================
	.CSEG
	.ORG RESET
	RJMP init

	.ORG PM_START
	.INCLUDE "delay.inc"		;anpassa delay.inc med huvudprogrammet
	.INCLUDE "lcd.inc"			;anpassa lcd.inc med huvudprogrammet
	.INCLUDE "keyboard.inc"		;anpassa keyboard.inc med huvudprogrammet
	.INCLUDE "stats.inc"		;anpassa stats.inc med huvudprogrammet
	.INCLUDE "monitor.inc"		;anpassa monitor.inc med huvudprogrammet
	.INCLUDE "stat_data.inc"	;anpassa stats_data.inc med huvudprogrammet
	.INCLUDE "dice.inc"			;anpassa dice.inc med huvudprogrammet

welcome: .DB "Welcome to dice",0	
message: .DB "Press 2 to roll",0
rolling: .DB "Rolling....",0
stats1: .DB "Stats: ",0
clear: .DB "Clearing...",0
monitoring: .DB "Monitor pressed",0

;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	; Set stack pointer to point at the end of RAM.
	LDI R16, LOW(RAMEND)	; TEMP = LOW (RAMEND), logisk nolla
	OUT SPL, R16
	LDI R16, HIGH(RAMEND)	; TEMP = HIGH (RAMEND), logisk etta
	OUT SPH, R16
	; Initialize pins
	CALL init_pins
	; Jump to main part of program
	RCALL lcd_init
	RCALL init_stat
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:	

	LDI R18, 0x00		; TEMP = 0x00
	OUT DDRE, R18		;ingångar
	OUT PORTE, R18
	

	LDI TEMP, 0xFF		; TEMP = 0xFF
	OUT DDRC, TEMP		;utgångar
	OUT DDRF, TEMP
	OUT DDRB, TEMP
	OUT DDRD, TEMP


	RET

;==============================================================================
; Print string
;==============================================================================

write_welcome:
	PRINTSTRING	welcome
	RET

first_row:
	PRINTSTRING message
	RET

rolling_dice:
	PRINTSTRING rolling
	RET

show_stats:
	PRINTSTRING stats1
	RET

clearing:
	PRINTSTRING clear
	RET

monitor_2:
	PRINTSTRING monitoring
	RET


;==============================================================================
; Main part of program
;==============================================================================
main:		
	
	LDI R24, 0X80		;positionen för cursor
	RCALL lcd_write_instr
	RCALL delay_1_s
	RCALL write_welcome
	//LDI R24, 1
	RCALL delay_1_s

start:	
	LDI R24, 0xC0
	RCALL lcd_write_instr
	RCALL delay_1_s
	RCALL first_row

	RCALL delay_1_s

	RCALL read_keyboard		; no key pressed
	CP NO_PRESS, RVAL
	BREQ start

	CPI RVAL, ROLL_KEY		; key 2 is pressed, call PRESS2
	BREQ PRESS2

	CPI RVAL, PRESS_C		; key 3 is pressed, call PRESS3
	BREQ PRESS3

	CPI RVAL, PRESS_H		; key 8 is pressed, call PRESS8
	BREQ PRESS8

	CPI RVAL, PRESS_I		; key 9 is pressed, call PRESS9
	BREQ PRESS9

	RJMP start

PRESS2:
	RCALL lcd_clear_display
	LDI R24, 0X80
	RCALL lcd_write_instr
	RCALL rolling_dice
	RCALL roll_dice
	MOV R24, TEMP
	PUSH R24
	RCALL store_stat
	POP R24
	SUBI R24, -48
	RCALL lcd_write_chr
	LDI R24, 1
	RCALL delay_1_s
	
	RJMP start

PRESS3:
	RCALL lcd_clear_display
	LDI R24, 0X80
	RCALL lcd_write_instr
	RCALL show_stats
	
	RCALL delay_1_s

	RCALL showstat
	RCALL delay_1_s
	RJMP start

PRESS8:
	RCALL lcd_clear_display
	LDI R24, 0X80
	RCALL lcd_write_instr
	RCALL clearing
	RCALL clear_stat
	RCALL delay_1_s
	RJMP start

PRESS9:
	RCALL lcd_clear_display
	LDI R24, 0X80
	RCALL monitor
	RCALL delay_1_s
	RJMP start

read_key:
	CALL read_keyboard		;skriva siffror från tangentbord
	CP NO_PRESS, RVAL
	BREQ read_key
	MOV NO_PRESS, RVAL
	CPI RVAL, NO_KEY
	BREQ read_key
	CPI RVAL, 10
	BRGE AB
	SUBI RVAL, -48

write:
	RCALL lcd_write_chr		;få ut bokstäverna A och B
	RJMP read_key
	AB:
	SUBI RVAL, -55
	JMP write




	loop:
	RJMP loop





