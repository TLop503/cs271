TITLE Assignment4 (hw4.asm)

; Troy Lopez
; CS 271 Assignment4 2/28/24
; generate array of random numbers based on user input
; then sort and display some stats

INCLUDE Irvine32.inc

UPPLIM		EQU		200
LOWLIM		EQU		10
ZERO		EQU		1
THOUS		EQU		999


.data
	; variable definitions
	; Notion:
	; prThing prints
	; usThing input

	prIntro1	BYTE	"HW4: Sorting random numbers, by Troy Lopez",0
	prIntro2	BYTE	"This generates N numbers in range [lo, hi], and displays, sorts, and displays again. Then, median value is calculated and displahyed.",0

	prData1		BYTE	"How many numbers should be generated? [10, 200]: ",0
	usNum		DWORD	69
	prErr1		BYTE	"Invalid Input, please try again.",0
	prData2		BYTE	"Enter Lower bound (lo): ",0
	usLo		DWORD	420
	prData3		BYTE	"Enter Upper bound (hi): ",0
	usHi		DWORD	7331

	prArr1		BYTE	"The unsorted random numbers: ",0
	prArr2		BYTE	"The sorted random numbers:",0

	prMed		BYTE	"The median value: ",0

	prAgain		BYTE	"Would you like to go again? (y/n)",0

.code

main PROC
	call intro

	push	OFFSET usNum
	push	OFFSET usLo
	Push	OFFSET usHi
	call	getData

	exit
main ENDP

; print intro
intro PROC
	mov		edx, OFFSET	prIntro1
	call	WRITESTRING
	call	CRLF
	mov		edx, OFFSET prIntro2
	call	WRITESTRING
	call	CRLF
	call	CRLF
	ret
intro ENDP

getData	PROC
		PUSH	ebp
		MOV		ebp, esp	;frame

	getNum:
		mov		ebx, [ebp+16]
		mov		edx, OFFSET	prData1
		call	WRITESTRING
		call	READINT
		mov		[ebx], eax	;store input in usNum?
		; shitty validation to be improved if I have time
		cmp		eax, LOWLIM
		jl		invalidNum
		cmp		eax, UPPLIM
		jg		invalidNum

		jmp		getLo

	invalidNum:
		mov		edx, OFFSET prErr1
		CALL	WRITESTRING
		CALL	CRLF
		jmp		getNum

	getLo:
		mov		ebx, [ebp+12]
		mov		edx, OFFSET	prData1
		call	WRITESTRING
		call	READINT
		mov		[ebx], eax	;store input in usNum?
		; shitty validation to be improved if I have time
		
		cmp		eax, ZERO
		jl		invalidLo
		cmp		eax, THOUS
		jg		invalidLo

		jmp		getHi

	invalidLo:
		mov		edx, OFFSET prErr1
		CALL	WRITESTRING
		CALL	CRLF
		jmp		getLo

	getHi:
		mov		ebx, [ebp+8] ; hi, inputted
		mov		ecx, [ebp+12] ;lo
		mov		edx, OFFSET	prData1
		call	WRITESTRING
		call	READINT
		mov		[ebx], eax	;store input in usNum?
		; shitty validation to be improved if I have time
		cmp		eax,[ecx]
		jl		invalidHi
		cmp		eax, THOUS
		jg		invalidHi

		jmp		ending

	invalidHi:
		mov		edx, OFFSET prErr1
		CALL	WRITESTRING
		CALL	CRLF
		jmp		getHi

	ending:
		pop		ebp
		ret
getData		ENDP

END main