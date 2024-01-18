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
	prLen	BYTE	"Enter the length of the pasture in feet: ", 0
	usLen	DWORD	?	;input
	prPlk	BYTE	"Enter the linear feet of planks availible: ", 0
	usPlk	DWORd	?	;input
	prArea	BYTE	"The area of the pasture is: ", 0
	area	DWORD	?
	prPerim	BYTE	"The perimiter is: ", 0
	perim	DWORD	?
	
	.code
	main PROC

	; 1. Introduce program
	mov		edx, OFFSET intro
	call	WriteString
	call	Crlf		;newline

	; 2. Get user's name
	mov		edx, OFFSET prName
	call	WriteString

	mov		edx, OFFSET usName
	mov		ecx, 32
	call	ReadString
	call	Crlf

	; 3. Get pasture specs from user
	mov		edx, OFFSET prWidth
	call	WriteString

	call	ReadInt		;stores in eax
	mov		usWidth, eax
	call	Crlf

	mov		edx, OFFSET prLen
	call	WriteString

	call	ReadInt
	mov		usLen, eax
	call	Crlf

	mov		edx, OFFSET prPlk
	call	WriteString

	call	ReadInt
	mov		usPlk, eax
	call	Crlf

	; 4. Do calcs for area
	mov eax, usLen		;factor1
	mov ebx, usWidth	;factor2
	mul ebx				;eax * ebx, stored in eax
	mov area, eax

	mov edx, OFFSET prArea
	call WriteString
	
	mov eax, area
	call WriteDec		;print eax (area)
	call Crlf

	; 5. Do calcs for perimiter
	mov eax, usLen	
	add eax, usWidth
	mov ebx, 2			;perimiter = (l + w )*2
	mul ebx
	mov	perim, eax

	mov edx, OFFSET prPerim
	call WriteString
	
	mov eax, perim
	call WriteDec
	call Crlf





	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;from template
	exit ; exit to operating system
main ENDP
; (insert additional procedures here)
END main