TITLE Assignment2 (hw2.asm)

; Troy Lopez
; CS 271 Assignment1     1/18/24
; Gets user input and calculates factors

INCLUDE Irvine32.inc

; constants go here
;COLON   equ ": ",0
LIM     equ 1001    ; 1001 so check can be inclusive

.data
    ; variable definitions
    ; Notation:
    ; prThing is a string to be printed
    ; usThing is a user inputted value
    ; with the exception of intro, all values not prefixed by pr or us are the results of calcs

    intro1  BYTE "Hw2: Factors, by Troy Lopez", 0
    intro2  BYTE "This program calculates and displays the factors of numbers between upper and lower bounds, as well as when numbers are prime.", 0
    
    prName  BYTE "Enter your name: ", 0
    prLowr  BYTE "Enter a number between 1 and 1000 for the lower range: ", 0
    prHigh  BYTE "Enter a number between 1 and 1000 for the higher range: ", 0
    prAgin  BYTE "Would you like to do another calculation? (1 yes/0 no)", 0
    prLoLo  BYTE "Sorry, that value is too low, please try again", 0
    prHiLo  BYTE "Sorry, that value is too high, please try again", 0
    prLoHi  BYTE "Input must be >= lower bound, please try again", 0
    prPrime BYTE "*** PRIME NUMBER ***",0
    prAgain	BYTE "Would you like to do another calc? (0 = no / 1 = yes): ", 0
	prExit	BYTE "Goodbye ", 0
   
    usName  BYTE 33 DUP(0)
    usLowr  DWORD ?
    usHigh  DWORD ?
   	usAgain DWORD ?

    loopCt  DWORD ?
    colon   BYTE ": ",0
    space   BYTE " ",0
    flag    WORD 0

.code
main PROC

    ; intro program
    mov     edx, OFFSET intro1
    call    WriteString
    call    Crlf
    mov     edx, OFFSET intro2
    call    WriteString
    call    Crlf

    ; get name
    mov     edx, OFFSET prName
    call    WriteString
    
    mov     edx, OFFSET usName
    mov     ecx, 32
    call    ReadString
    call    Crlf


    ; get lower bound
getLower:
    mov     edx, OFFSET prLowr
    call    WriteString
    
    call    ReadInt             ; stores in eax
    mov     usLowr, eax
    call    Crlf
    
    ; check if too low
    cmp     usLowr, 1
    jl      lowerTooLow         ; if below 1
    
    cmp     usLowr, 1000
    jg      lowerTooHigh
    jmp     getHigher


    ; if user input for lower bound is too low
lowerTooLow:
    mov     edx, OFFSET prLoLo
    call    WriteString
    call    Crlf
    jmp     getLower


    ; if too high
lowerTooHigh:
    mov     edx, OFFSET prHiLo
    call    WriteString
    call    Crlf
    jmp     getLower

    ; get higher bound
getHigher:
    mov     edx, OFFSET prHigh
    call    WriteString
    
    call    ReadInt             ; stores in eax
    mov     usHigh, eax
    call    Crlf
    
    ; check if too low
    mov     eax, usLowr
    cmp     usHigh, eax
    jl      higherTooLow       ; if below lower bound
    
    cmp     usHigh, LIM
    jg      higherTooHigh
    jmp     prepMath


    ; if user input for lower bound is too low
higherTooLow:
    mov     edx, OFFSET prLoHi
    call    WriteString
    call    Crlf
    jmp     getHigher


    ; if too high
higherTooHigh:
    mov     edx, OFFSET prHiLo
    call    WriteString
    call    Crlf
    jmp     getHigher

    ; start calcs
prepMath:
    mov     ecx, usLowr
    dec     ecx                 ; decrement by 1 so that foorloop can include an inc  
    mov     ebx, usHigh         ; exclusive
    inc     ebx                 ; inc b/c exclusive
    mov     edx, 0              ; prep for division
    jmp     forLoop

    ; do while ecx != ebx
forLoop:
    call    crlf
    mov     flag, 0

    inc     ecx
    cmp     ecx, ebx
    je      continue

    mov     eax, ecx
    call    WriteDec
    mov     edx, OFFSET colon
    call    WriteString

    mov     loopCt, 2
    jmp     innerLoop

  

    ; run inner loop
innerLoop:
    cmp     loopCt, ecx           ; while j < i
    jge     checkPrime

    mov     eax, ecx
    mov     edx, 0
    div     loopCt

    cmp     edx, 0                 ; check for remainder
    je      printFactor

    inc     loopCt
    jmp     innerLoop        
    
checkPrime:
    cmp flag, 0
    je printPrime
    jmp forLoop


    ; if no remainder print factor
printFactor:
    mov     flag, 1
    mov     eax, loopCt
    call    WriteDec
    mov     edx, OFFSET space
    call    WriteString

    inc     loopCt
    jmp     innerLoop


printPrime:
    ; print that number was prime
    mov     edx, OFFSET prPrime
    call    WriteString
    jmp     forLoop

    


continue:

endProg:

    ; from template
    exit ; exit to operating system
main ENDP

; (insert additional procedures here)
END main
