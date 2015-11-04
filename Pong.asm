;CPE 311 Lab Final Project
;Zach Matthews
;Igor Artemowicz
;    Zheng\
;SCREEN SIZE: 24 X 80
Assume cs:code, ds:data, ss:stack

data segment 
paddle db "|$"
line1 db "PONG$"
line2 db "PRESS 'E' TO EXIT$"
line3 db "PRESS 'P' TO BEGIN$"
p1Message db "PLAYER 1 WINS!!!$"
p2Message db "PLAYER 2 WINS!!!$"
player1Prompt db "Player 1 Press Enter$"
Player2Prompt db "Player 2 Press Enter$"
readyPrompt db "GET READY!!!!!!!$"
p1Score db 0
p2Score db 0
p1Row db 12
p2Row db 12
ballX db 12
ballY db 40
ballXVel db 0
ballYVel db 0

data ends

stack segment  
dw 100 dup(?)
stacktop:
stack ends

code segment
begin:
mov ax, data
mov ds, ax
mov ax, stack
mov ss, ax
mov sp, offset stacktop

MOV DX, 143H
MOV AL, 02H
OUT DX, AL

mov DX, 141H
mov AL, 0FFH
out DX, AL

MOV DX, 143H
MOV AL, 03H
OUT DX, AL

Start:
CALL DISPLAYMENU
CALL MAINMENU
CALL READY
CALL GAME
jmp Start

exit:
CALL CLEAR
mov ah,4ch
int 21h

PRINT: 
	push ax
	push bx
	push cx
	push dx   


	xxx:
	mov dl, [si]
	cmp dl, "$"
	je return
	int 21H
	inc si
	jmp xxx

	return:

	pop dx
	pop cx
	pop bx
	pop ax
ret

CLEAR:
	push ax
	push bx
	push cx
	push dx 
	
	MOV AH, 06H
	MOV AL,00H
	MOV CX, 0000H
	MOV DL,79H
	MOV DH,24H
	INT 10H

	pop dx
	pop cx
	pop bx
	pop ax
ret

MAINMENU:
	push ax
	push bx
	push cx
	push dx   

	waiting:
	MOV AH, 08H
	INT 21H
	cmp al, 'e'
	je exit
	cmp al, 'p'
	je finished
	jmp waiting
	
	finished:
	pop dx
	pop cx
	pop bx
	pop ax
ret

DISPLAYMENU:
	push ax
	push bx
	push cx
	push dx 
	
	CALL CLEAR
	mov AH, 2H
	mov si, offset line1
	mov DH, 11
	mov DL, 30
	int 10h
	CALL PRINT
	mov si, offset line2
	mov DH, 12
	mov DL, 30
	int 10h
	CALL PRINT 
	mov si, offset line3
	mov DH, 13
	mov DL, 30
	int 10h
	CALL PRINT

	pop dx
	pop cx
	pop bx
	pop ax
ret

GAME:
	push ax
	push bx
	push cx
	push dx 

	
	gameLoop:
	
	CALL DELAY
	CALL CLEAR
	
	CALL moveP1
	CALL moveP2
	CALL moveBall
	CALL CollisionCheck
	CALL ScoreCheck
	
	inc p1Score
	cmp p1Score, 8
	je p1Win
	cmp p2Score, 8
	je p2Win	
	jmp gameLoop

	p1Win:
	mov si, offset p1Message
	jmp gameDone
	p2Win:
	mov si, offset p2Message
	jmp gameDone
	
	gameDone:
	CALL ENDGAME
	pop dx
	pop cx
	pop bx
	pop ax
ret

READY:
	push ax
	push bx
	push cx
	push dx 


	P1Prompt:
	mov AH, 2H
	mov DH, 12
	mov DL, 30
	int 10h
	CALL CLEAR
	CALL DELAY
	mov si, offset Player1Prompt
	CALL PRINT
	MOV AH, 08H
	INT 21H
	cmp AL, 00001101b
	je p2Prompt
	jmp p1Prompt
	
	p2Prompt:
	mov AH, 2H
	mov DH, 12
	mov DL, 30
	int 10h
	CALL CLEAR
	CALL DELAY
	mov si, offset Player2Prompt
	CALL PRINT
	MOV AH, 08H
	INT 21H
	cmp AL, 00001101b
	je doneFlashing
	jmp p2Prompt
	doneFlashing:
	pop dx
	pop cx
	pop bx
	pop ax
ret

moveP1:
	push ax
	push bx
	push cx
	push dx 
	
	MOV DX, 143H 
	MOV AL, 2
	OUT DX, AL
	MOV DX, 140H 
	MOV AL, 00H
	OUT DX, AL
	MOV DX, 143H 
	MOV AL, 3
	OUT DX, AL

	
	mov si, offset paddle
	mov AH, 2H
	mov di, offset p1Row
	mov DH, [di]
	mov DL, 2
	int 10h
	CALL PRINT
	mov si, offset paddle
	add dh,1
	mov DL, 2
	int 10h
	CALL PRINT
	mov si, offset paddle
	SUB dh, 2
	mov DL, 2
	int 10h
	CALL PRINT

	
	pop dx
	pop cx
	pop bx
	pop ax
ret

moveP2:
	push ax
	push bx
	push cx
	push dx 
	
	
	
	
	mov si, offset paddle
	mov AH, 2H
	mov di, offset p2Row
	mov DH, [di]
	mov DL, 77
	int 10h
	CALL PRINT
	
	mov si, offset paddle
	add dh,1
	mov DL, 77
	int 10h
	CALL PRINT
	
	mov si, offset paddle
	SUB dh, 2
	mov DL, 77
	int 10h
	CALL PRINT
	
	pop dx
	pop cx
	pop bx
	pop ax
	
ret

moveBall:
	push ax
	push bx
	push cx
	push dx 
	


	pop dx
	pop cx
	pop bx
	pop ax
ret

collisionCheck:
	push ax
	push bx
	push cx
	push dx 
	


	pop dx
	pop cx
	pop bx
	pop ax
ret

scoreCheck:
	push ax
	push bx
	push cx
	push dx 
	


	pop dx
	pop cx
	pop bx
	pop ax
ret

ENDGAME:
	push ax
	push bx
	push cx
	push dx 
	


	pop dx
	pop cx
	pop bx
	pop ax
ret


delay:
	push ax
	push bx
	push cx
	push dx    
		mov BX, 400       
	Delay1:
		mov CX, 2000   
	Delay2:

	DEC     CX         
	NOP                     
	cmp CX, 0				;if CX != 0 return to delay2
	je Delay3
	jmp Delay2
	Delay3:
	DEC     BX          
	CMP BX, 0				;if BX != 0 return to delay1
	je Delay4
	jmp Delay1
	Delay4:
		
	pop dx
	pop cx
	pop bx
	pop ax
ret

code ends
end begin
