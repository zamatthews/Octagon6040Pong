;CPE 311 Lab Final Project
;Zach Matthews
;Igor Artemowicz
;    Zheng\
;SCREEN SIZE: 24 X 80
;
;	PINS
;PLAYER 1:	PIN		Port/Bit
;UP:		16		C/1
;DOWN:		15		C/2
;LED0				
;LED1
;LED2
;LED3
;LED4
;LED5
;LED6
;LED7
;
;PLAYER 2:
;UP			17		C/3
;DOWN		9		C/7
;LED0
;LED1
;LED2
;LED3
;LED4
;LED5
;LED6
;LED7

Assume cs:code, ds:data, ss:stack

data segment 
paddle db "|$"
ball db "@$"
line1 db "PONG$"
line2 db "PRESS 'E' TO EXIT$"
line3 db "PRESS 'P' TO BEGIN$"
p1Message db "PLAYER 1 WINS!!!$"
p2Message db "PLAYER 2 WINS!!!$"
player1Prompt db "Player 1 Press Enter$"
Player2Prompt db "Player 2 Press Enter$"
ScoreMessage db "SCOOOOOOOOOOOOORE!!!!!!!!!!$"
readyPrompt db "GET READY!!!!!!!$"
loopControl db 0
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
CALL RESET
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
	CALL DisplayP1Score
	CALL DisplayP2Score
	
	cmp p1Score, 3
	je p1Win
	cmp p2Score, 3
	je p2Win	
	jmp gameLoop

	p1Win:
	mov di, offset p1Message
	jmp gameDone
	p2Win:
	mov di, offset p2Message
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

	MOV DX, 143H 
	MOV AL, 2
	OUT DX, AL
	MOV DX, 142H 
	MOV AL, 00H
	OUT DX, AL
	MOV DX, 143H 
	MOV AL, 3
	OUT DX, AL
	
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

	MOV DX, 142H 
	MOV AL, 00H
	IN AL, DX
	AND AL, 06H
	
	cmp AL, 02H
	je P1UP
	cmp AL, 04H
	je P1DOWN
	jmp SKIPP1
	
	P1DOWN:
	cmp P1Row, 1
	je SKIPP1
	dec P1Row
	jmp SKIPP1
	P1UP:
	cmp P1Row, 22
	je SKIPP1
	inc P1Row
	SKIPP1:
	mov di, offset p1Row
	mov si, offset paddle
	mov AH, 2H
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
	
	MOV DX, 142H 
	MOV AL, 00H
	IN AL, DX
	AND AL, 88H
	
	cmp AL, 08H
	je P2UP
	cmp AL, 80H
	je P2DOWN
	jmp SKIPP2
	
	P2DOWN:
	cmp P2Row, 1
	je SKIPP2
	dec P2Row
	jmp SKIPP2
	P2UP:
	cmp P2Row, 22
	je SKIPP2
	inc P2Row
	
	SKIPP2:
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

RESET:
	push ax
	push bx
	push cx
	push dx 
	
mov p1Score, 0
mov p2Score,0
mov p1Row, 12
mov p2Row, 12
mov ballY, 40
mov ballX, 12
CALL BALLSET
	

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

	cmp ballXVel, 1
	je incX
	dec ballX
	jmp doY
	incX:
	inc ballX
	doY:
	cmp ballYVel, 1
	je incY
	dec ballY
	jmp drawBall
	incY:
	inc ballY
	
	drawBall:
	mov si, offset ball
	mov AH, 2H
	mov di, offset ballX
	mov DH, [di]
	mov di, offset ballY
	mov DL, [di]
	int 10h
	CALL PRINT
	
	

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
	
	mov dl, -1
	mov si, offset ballX
	mov bl, [si]

	
	cmp ballY, 3
	je p1Collide
	cmp ballY, 76
	je p2Collide
	jmp wallCollide
	
	P1Collide:
	mov di, offset p1Row
	mov bh, [di]
	cmp bh, bl
	je posY
	ADD bh, 1
	cmp bh, bl
	je posY
	SUB bh, 2
	cmp bh, bl
	je posY
	
	jmp wallCollide

	p2Collide:
	mov di, offset p2Row
	mov bh, [di]
	cmp bh, bl
	je negY
	ADD bh, 1
	cmp bh, bl
	je negY
	SUB bh, 2
	cmp bh, bl
	je negY
	
	posY:
	mov ballYVel, 1
	jmp wallCollide
	negY:
	mov ballYVel, -1
	wallCollide:
	cmp ballX, 23
	je negX
	cmp ballX, 0
	je posX
	jmp endCollision
	
	negX:
	mov ballXvel, -1
	jmp endCollision
	posX:
	mov ballXVel, 1
	
	endCollision:
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
	
	cmp ballY, 0
	je P2Scored
	cmp ballY, 80
	je P1Scored
	jmp NoScored
	
	P2Scored:
	CALL SCORE
	CALL BALLSET
	inc P2Score
	jmp NoScored
	P1Scored:
	CALL SCORE
	CALL BALLSET
	inc P1Score
	
	NoScored:
	pop dx
	pop cx
	pop bx
	pop ax
ret

BALLSET:
	push ax
	push bx
	push cx
	push dx 
	
	mov si, offset ballXVel
	mov di, offset ballYvel
	
	
	MOV AH, 00h
	INT 1Ah
	MOV AX,DX
	XOR DX,DX
	MOV CX, 3
	DIV CX
	mov [si], DX
	dec ballXVel
	
	CALL DELAY
	
	MOV AH, 00h
	INT 1Ah
	MOV AX,DX
	XOR DX,DX
	MOV CX, 3
	DIV CX
	mov [di], DX
	dec ballYVel
	
	mov di, offset ballX
	MOV AH, 00h
	INT 1Ah
	MOV AX,DX
	XOR DX,DX
	MOV CX, 22
	DIV CX
	mov [di], DX
	inc ballX
	mov ballY, 40
	
	pop dx
	pop cx
	pop bx
	pop ax
ret

DisplayP1Score:
	push ax
	push bx
	push cx
	push dx 
	
	MOV DX, 143H
	MOV AL, 02H
	OUT DX, AL

	mov DX, 140H
	mov AL, 0FFH
	out DX, AL

	MOV DX, 143H
	MOV AL, 03H
	OUT DX, AL
	
	
	mov si, offset p1score
	mov bx, [si]
	MOV DX, 140H 
	MOV AX, 000FFH
	lightLoop1:
		cmp bx, 0	
		je out1
		ROL AX, 1
		dec bx
	jmp lightLoop1
	out1:
	OUT DX, AL
	

	pop dx
	pop cx
	pop bx
	pop ax
ret

DisplayP2Score:
	push ax
	push bx
	push cx
	push dx 
	
	MOV DX, 143H
	MOV AL, 02H
	OUT DX, AL

	mov DX, 141H
	mov AL, 0FFH
	out DX, AL

	MOV DX, 143H
	MOV AL, 03H
	OUT DX, AL
	
	
	mov si, offset p2score
	mov bx, [si]
	MOV DX, 141H 
	MOV AX, 000FFH
	lightLoop2:
		cmp bx, 0	
		je out2
		ROL AX, 1
		dec bx
	jmp lightLoop2
	out2:
	OUT DX, AL

	pop dx
	pop cx
	pop bx
	pop ax
ret

SCORE:
	push ax
	push bx
	push cx
	push dx 
	
	mov bx, 15
	ENDLOOP:
	CALL CLEAR
	mov AH, 2H
	mov DH, 11
	mov DL, 30
	int 10h
	mov si, offset ScoreMessage
	CALL PRINT
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL CLEAR
	dec bx
	cmp bx, 0
	je DONELOOP
	jmp ENDLOOP
	DONELOOP:
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
	
	CALL CLEAR
	mov loopControl, 100
	SCORELOOP:
	
	MOV AH, 00h
	INT 1Ah
	MOV AX,DX
	XOR DX,DX
	MOV CX, 23
	DIV CX
	mov BH, DL
	
	CALL DELAY
	
	MOV AH, 00h
	INT 1Ah
	MOV AX,DX
	XOR DX,DX
	MOV CX, 79
	DIV CX
	mov BL, DL
	
	mov AH, 2H
	mov DH, BH
	mov DL, BL
	int 10h
	mov si, di
	CALL PRINT
	CALL DELAY
	CALL DELAY
	CALL DELAY
	dec loopControl
	cmp loopControl, 0
	je DONELOOP2
	jmp SCORELOOP
	DONELOOP2:
	CALL CLEAR
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
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
		mov BX, 5     
	Delay1:
		mov CX, 2000   
	Delay2:

	DEC CX         
	NOP                     
	cmp CX, 0				
	je Delay3
	jmp Delay2
	Delay3:
	DEC   BX          
	CMP BX, 0			
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
