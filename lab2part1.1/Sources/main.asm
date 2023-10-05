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
            ORG   $4000


Entry:
_Startup:   
            LDAA  #$FF            ; ACCA - $FF (Load A into into Hex FF)
            STAA  DDRH            ; Config. Port H for output (Set Port H as output) 
            STAA  PERT            ; Enab. pull-up res. of Port T (Set up Port T so it is able to read inputs from the board, the switches)
            
Loop:       LDAA  PTT             ; Read Port T
            STAA  PTH             ; Display SW1 on LED1 connected to Port H
            BRA   Loop            ; Loop (Loop so you can read multiple inputs)
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