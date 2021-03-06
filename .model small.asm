.model small 
.stack 256
.data

a db 1
b db 9
c db 3
d db 7


.code

    main:
        mov ax,@data
        mov ds,ax
        
        ; if(1)
        mov al,a
        mov ah,c
        imul ah ; значение сохранилось в регистре ax
        mov cx,ax 
        mov al,b
        sub al,d ; отняли от b d
        cbw ; расширяем al/ah до ax (8->16 бит)
        cmp ax,cx ; сравниваем два значения
        jne print1 ; прыгаем на метку если не равны
        
        mov al,a    
        mov ah,d
        cmp al,ah
        jl print1 ; прыгаем если меньше

        ; if(2)
        mov al,b
        add al,c
        mov ah,a
        sub ah,d
        cmp al,ah
        jge print3
        mov al,a
        mov ah,b
        cmp al,ah
        jl print2
        jmp print3

    print1:
        mov al,c
        sub al,d
        mov ah,b
        imul ah
        mov bx,ax
        mov al,a
        cbw
        add bx,ax
        mov dx,bx
        mov ax,dx
        jmp printnumber

    print2:
        mov al,c
        mov ah,c
        imul ah
        mov bx,ax
        mov al,a
        mov ah,3
        imul ah
        add bx,ax
        mov al,d
        cbw
        add bx,ax
        sub bx,4
        mov dx,bx
        mov ax,dx
        jmp printnumber

    print3:
        mov al,b
        mov ah,2
        imul ah
        mov bx,ax
        mov al,a
        mov ah,5
        imul ah
        sub bx,ax
        add bx,8
        mov dx,bx
        mov ax,dx
        jmp printnumber
    
    printnumber:
	    cmp ax, 0
	    jz printifzero
	    jnl printpositive
	    mov dl, '-'
	    push ax
	    mov ah, 02h
	    int 21h
	    pop ax
        not ax 
	    inc ax


    printpositive:
	    cmp ax, 0
	    jz zero
	    mov dx, 0
	    mov bx, 10
	    div bx    
	    add dl, 48
	    push dx
        call printpositive
	    pop dx
	    push ax
	    mov ah, 02h
	    int 21h
	    pop ax
        ret

    zero:
	    ret

    printifzero:
	    mov dl, 30h
	    mov ah, 02h
	    int 21h
	    ret

    exit:
        mov ax, 4c00h
        mov al, 0
        int 21h
    end     main