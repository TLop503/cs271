TITLE Assignment2 (hw2.asm)

; Troy Lopez
; CS 271 Assignment1		1/18/24
; Gets user input and calculates factors

INCLUDE Irvine32.inc

; constants go here
COLON	equ	": ",0


.data
	;variable definitions
	; Notation:
	; prThing is a string to be printed
	; usThing is a user inputted value
	; with the exception of intro, all values not prefixed by pr or us are the results of calcs


	intro1	BYTE	"Hw2: Factors, by Troy Lopez", 0
	intro2	BYTE	"This program calculates and displays the factors of numbers between upper and lower bounds, as well as when numbers are prime.", 0
	prName	BYTE	"Enter your name: ", 0
	prLowr	BYTE	"Enter a number betwen 1 and 1000 for the lower range: ", 0
	prHigh	BYTE	"Enter a number between 1 and 1000 for the higher range: ", 0
	prAgin	BYTE	"Would you like to do another calculation? (1 yes/0 no)", 0
	prLoLo	BYTE	"Sorry, that value is too low, please try again", 0
	prHiLo	BYTE	"Sorry, that value is too high, please try again", 0
	prLoHi	BYTE	"Input must be >= lower bound, please try again", 0

	usName	BYTE	33	DUP(0)
	usLowr	DWORD	?
	usHigh	DWORD	?

.code
	main PROC

	;intro program
	mov		edx, OFFSET intro1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET intro2
	call	WriteString
	call	Crlf

	;get name
	mov		edx, OFFSET prName
	call	WriteString
	
	mov		edx, OFFSET usName
	mov		ecx, 32
	call	ReadString
	call	Crlf


	; get lower bound
getLower:
	mov		edx, OFFSET prLowr
	call	WriteString
	
	call	ReadInt				;stores in eax
	mov		usLowr, eax
	call	crlf
	
	; check if too low
	cmp		usLowr, 0
	jle		lowerTooLow			; if 0 or below
	
	cmp		usLowr, 1001
	jge		lowerTooHigh
	jmp getHigher


	; if user input for lower bound is too low
lowerTooLow:
	mov		edx, OFFSET	prLoLo
	call	WriteString
	call	Crlf
	jmp		getLower


	; if too high
lowerTooHigh:
	mov		edx, OFFSET prHiLo
	call	WriteString
	call	Crlf
	jmp		getLower

	; get higher bound
getHigher:
	mov		edx, OFFSET prHigh
	call	WriteString
	
	call	ReadInt				;stores in eax
	mov		usHigh, eax
	call	crlf
	
	; check if too low
	mov		eax, usLowr
	cmp		usHigh, eax
	jle		higherToolow		; if 0 or below
	
	cmp		usHigh, 1001
	jge		higherTooHigh
	jmp doMath


	; if user input for lower bound is too low
higherTooLow:
	mov		edx, OFFSET	prLoHi
	call	WriteString
	call	Crlf
	jmp		getHigher


	; if too high
higherTooHigh:
	mov		edx, OFFSET prHiLo	;reuse message from too low
	call	WriteString
	call	Crlf
	jmp		getHigher


	;start calcs
prepMath:
	mov ecx, usLowr
	mov ebx, usHigh				;exclusive
	inc ebx						;inc b/c exclusive
	jmp forLoop



endProg:						; if the user doesn't want to do more calculations, say goodbye and quit
	
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;from template
	exit ; exit to operating system
main ENDP
; (insert additional procedures here)
END main