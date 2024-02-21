TITLE Assignment 3 (HW3.asm)

; Troy Lopez
; CS 271 Assignment4     2/18/24
; Gets user input and calculates factors. Exercises understanding of control flow with psuedo-loops

INCLUDE Irvine32.inc

UPPLIM     EQU     401     ; 401 so check is inclusive
LOWLIM     EQU     0     

.data
    introMsg  BYTE    "Hw3: Composite Numbers, by Troy Lopez",0


.code

main PROC
    call intro
main ENDP

intro PROC
    MOV     EDX, OFFSET introMsg
    CALL    WRITESTRING
    CALL    CRLF
    CALL    CRLF
    RET
intro ENDP

END main