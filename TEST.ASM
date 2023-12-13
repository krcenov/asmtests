.MODEL SMALL
.STACK 100h

.DATA
    result DB 0

.CODE
    ORG 100h ; Set the origin to 100h for COM file

    MOV AX, @DATA
    MOV DS, AX ; Initialize data segment

    ; 50681 + 1000
    MOV AX, 50681
    ADD AX, 1000
    LAHF ; Load flags into AH register
    MOV result, AH ; Store flags in result variable
    CALL DisplayFlagsStatus ; Display the flags
	
	; -32768 + 60
    MOV AX, -32768
    ADD AX, 60
    LAHF
    MOV result, AH
    CALL DisplayFlagsStatus

    ; -1 + 65000
    MOV AX, -1
    ADD AX, 65000
    LAHF ; Load flags into AH register
    MOV result, AH ; Store flags in result variable
    CALL DisplayFlagsStatus ; Display the flags
	
	; -256 – (-32768)
    MOV AX, -256
    ADD AX, -32768
    LAHF
    MOV result, AH
    CALL DisplayFlagsStatus

    ; Int 20h - DOS function: Exit program
    MOV AH, 4Ch
    INT 21h

DisplayFlagsStatus PROC
    MOV AL, result ; Load the flags into AL
    MOV AH, 02h ; DOS function to display character
    
    ; Carry Flag (CF)
    TEST AL, 1
    JZ DISPLAY_FALSECF
    MOV DL, 'T'
	CF_CONT:
    INT 21h ; DOS interrupt

    ; Parity Flag (PF)
    TEST AL, 4
    JZ DISPLAY_FALSEPF
    MOV DL, 'T'
	PF_CONT:
	INT 21h ; DOS interrupt
	
	; Auxiliary Carry Flag (AF)
	TEST AL, 16
    JZ DISPLAY_FALSEAF
    MOV DL, 'T'
	AF_CONT:
	INT 21h ; DOS interrupt
	
	; Zero Flag (ZF)
	TEST AL, 64
    JZ DISPLAY_FALSEZF
    MOV DL, 'T'
	ZF_CONT:
	INT 21h ; DOS interrupt
	
	; Sign Flag (SF)
	TEST AL, 128
    JZ DISPLAY_FALSESF
    MOV DL, 'T'
	SF_CONT:
	INT 21h ; DOS interrupt
	
	; Overflow Flag (OF)
	TEST AL, 8
    JZ DISPLAY_FALSEOF
    MOV DL, 'T'
	OF_CONT:
	INT 21h ; DOS interrupt
	
    ; Newline
    INT 21h ; DOS interrupt
    MOV AH, 02h
    MOV DL, 0DH ; Carriage return
    INT 21h
    MOV DL, 0AH ; Linefeed
    INT 21h
	RET

DISPLAY_FALSECF:
    MOV DL, 'F' ; Display space between flags
	JMP CF_CONT
	
DISPLAY_FALSEPF:
    MOV DL, 'F' ; Display space between flags
	JMP PF_CONT
	
DISPLAY_FALSEAF:
    MOV DL, 'F' ; Display space between flags
	JMP AF_CONT
	
DISPLAY_FALSEZF:
    MOV DL, 'F' ; Display space between flags
	JMP ZF_CONT
	
DISPLAY_FALSESF:
    MOV DL, 'F' ; Display space between flags
	JMP SF_CONT
	
DISPLAY_FALSEOF:
    MOV DL, 'F' ; Display space between flags
	JMP OF_CONT
DisplayFlagsStatus ENDP
END
