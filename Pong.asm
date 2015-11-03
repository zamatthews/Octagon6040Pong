;CPE 311 Lab Final Project
;Zach Matthews
;Igor Artemowicz
;    Zheng
Assume cs:code, ds:data, ss:stack

data segment 
password db 100 dup(?)
choice db 100 dup(?)
truePassword db "password$"
prompt db "Enter Password: $"
line1 db "1 - Bit Pattern 1$"
line2 db "2 - Bit Pattern 2$"
line3 db "3 - Bit Pattern 3$"
line4 db "4 - Exit$"
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




exit:
mov ah,4ch
int 21h

code ends
end begin