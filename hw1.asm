TITLE Assignment1 (hw1.asm)

; Troy Lopez
; CS 271 Assignment1		1/18/24
; Gets user input and does a bit of math for building a fence

INCLUDE Irvine32.inc

; Planks are 1x6'
PLANK_SIZE = 6


.data
	;variable definitions
	intro	BYTE	"Hw1: Fencing a pasture by Troy Lopez", 0
	prName	BYTE	"Enter your name: ", 0
	usName	BYTE	33 DUP(0)	;user inputted name initialized to zero
	prWidth	BYTE	"Enter the width of the pasture in feet: ", 0
	usWidth	DWORD	?	;input
	prLen	BYTE	"Enter the length of the pasture in feet ", 0
	usLen	DWORD	?	;input
	prPlk	BYTE	"Enter the linear feet of planks availible", 0
	prArea	BYTE	"The area of the pasture is: ", 0
	area	DWORD	?
	prPerim	BYTE	"The perimiter is: ", 0
	perim	DWORD	?
	
	.code
	main PROC

	; 1. Introduce program
	mov		edx, OFFSET intro
	call	writeString
	call	crlf					;newline


	;from template
	exit ; exit to operating system
main ENDP
; (insert additional procedures here)
END main