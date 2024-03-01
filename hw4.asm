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
MAX_SIZE	EQU		100
FOUR		EQU		4


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

	array		DWORD	MAX_SIZE	DUP(?)	;the array, intially full of garbage

	prArr1		BYTE	"The unsorted random numbers: ",0
	prArr2		BYTE	"The sorted random numbers:",0

	flag		DWORD	0

	prMed		BYTE	"The median value: ",0

	prAgain		BYTE	"Would you like to go again? (y/n)",0

.code

main PROC
	call intro

	push	OFFSET usNum
	push	OFFSET usLo
	Push	OFFSET usHi
	call	getData
	
	Push	usLo
	Push	usHi
	push	OFFSET	array
	push	usNum
	call	fillArray

	Push	usNum
	Push	OFFSET	array
	Push	OFFSET	prArr1
	CALL	printList

	Push	flag
	Push	usNum
	Push	OFFSET	array
	CALL	bubbleSort
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
		mov		edx, OFFSET	prData2
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
		mov		edx, OFFSET	prData3
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

fillArray	PROC
		PUSH	ebp
		MOV		ebp, esp	;frame

		; get usNum for loop counter
		mov		ecx, [ebp+8];
		
		;get array into edi
		mov		edi, [ebp+12]

		again:	;the loop
			mov		eax, [ebp+16]	;get upper limit
			sub		eax, [ebp+20]	;sub low
			inc		eax		; b/c exclusive
			call	RANDOMRANGE	;[0, eax]
			add		eax, [ebp+20]
			; code above this line works and indexes are correct

			; populate array
			mov		[edi], eax
			;CALL	WRITEINT
			;CALL	CRLF
			add		edi, 4

			loop again

			pop ebp
			ret
fillArray	ENDP

printList	PROC
		PUSH	ebp
		MOV		ebp, esp	;frame
		
		mov		edx, [ebp+8]	;title
		CALL	WRITESTRING

		mov		edx, [ebp+12]	;total items
		mov		esi, [ebp+16]	;the array
		mov		ebx, 1

		again:	;the loop
			mov		eax, 4
			;mul		ebx
			sub		edi, eax
			mov		eax, [edi]
			CALL	WRITEINT
			cmp		ebx, [ebp+16]
			je		ending
			inc		ebx
			jmp		again

		ending:
			pop		ebp
			ret
printList	ENDP		

bubbleSort	PROC

	PUSH	ebp
	MOV		ebp, esp

	; flag is stored at +16
	; num is stored at +12
	; array is stored at +8

	mov		ecx, [ebp + 12]	; works

	outer:
		mov		eax, 0
		mov		[ebp + 16], eax		;should work
		
		push	ecx		; save for loop. outer i is now stored in +4
		dec		ecx		; start inner loop from one less
		inner:
			; if statement goes here
			; i = [ebp - 4]
			; j = ecx
			mov		eax,	[ebp - 4]
			mov		edx, FOUR
			mul		edx
			mov		ebx, eax		; i is in ebx

			mov		eax, ecx
			mov		edx, FOUR
			mul		edx			; j is in eax

			swap:
				;stuff goes here
				
			loop inner
		;jmp else

		;notswapped:
			; break out of outer
		
		;else:
		;	pop		ecx
		;	loop	outer
			

		

			


	pop		ebp
	ret
	
bubbleSort	ENDP
			

			
END main