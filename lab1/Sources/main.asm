;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
Counter     DS.W 1
FiboRes     DS.W 1


; code section
            ORG   $3000
*This program will run a calculator for unsigned multiplication of two numbers 

FIRSTNUM    FCB   01;      First Number that you're multiplying 
SECNUM      FCB   02;      Second Number that you're multiplying
PRODUCT     RMB   1;       Result of Multiplication 

            ORG $4000
Entry:
_Startup:
            LDAA  FIRSTNUM; Loads the first number in acc A
            LDAB  SECNUM;   Loads the second number in acc B
            mul;            Multiplies the two number loaded in acc A and B 
            STAB  PRODUCT;  Stores the Product of the two numbers          
            SWI
mainLoop:
            LDX   #1              ; X contains counter
couterLoop:
            STX   Counter         ; update global.
            BSR   CalcFibo
            STD   FiboRes         ; store result
            LDX   Counter
            INX
            CPX   #24             ; larger values cause overflow.
            BNE   couterLoop
            BRA   mainLoop        ; restart.

CalcFibo:  ; Function to calculate fibonacci numbers. Argument is in X.
            LDY   #$00            ; second last
            LDD   #$01            ; last
            DBEQ  X,FiboDone      ; loop once more (if X was 1, were done already)
FiboLoop:
            LEAY  D,Y             ; overwrite second last with new value
            EXG   D,Y             ; exchange them -> order is correct again
            DBNE  X,FiboLoop
FiboDone:
            RTS                   ; result in D

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
