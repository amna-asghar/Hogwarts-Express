[org 0x0100]
call starting

;jmp start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;globally initialize data
color:			db 0x64,0x64,0x64,0x64,0x64,0x16,0x16,0x16,0x16,0x16,0x16,0x16,0x16,0x16
my_row:         db 9,6,12,14,13,9,8,7,4,4,1,8,9,10
my_col:         db 10,34,56,48,20,69,73,76,83,93,106,114,121,128
my_size:        db 10,13,7,5,6,3,2,2,4,4,6,3,3,3
my_entries:     dw 0xE


string1: db 'GAME INSTRUCTIONS',0 ;;;; length - 17
string2: db '-> press up to jump',0 ;;;; -19
string3: db '-> blue bricks will disappear after sometime',0 ;;;;;;-43
string4: db '-> catch carrots to increase the score',0 ;;;;-38
string5: db '-> PRESS ESC TO EXIT',0;;;;;;-20
;;;;;;FOR SCROLLING up

;--------------------------------------------------------------------
; Score system & rabbit/carrot position data
;--------------------------------------------------------------------
score:          dw 0           ; Current score (increments when rabbit eats carrot)
score_label:    db 'SCORE: ',0 ; Label for score display (7 chars)
score_digits:   db '00000',0   ; Score displayed as ASCII digits (up to 99999)

; Rabbit position in screen columns (tracks where rabbit is horizontally)
rabbit_col:     dw 79          ; Starting column of rabbit center (matches initial draw offset)
; Carrot position in screen columns
carrot_col:     dw 75          ; Starting column of carrot (matches initial draw offset ~9914/2/132 col)

; Scroll direction counter to know when positions shift
scroll_tick:    dw 0           ; Counts scroll cycles

; Flag: carrot visible (1) or eaten/respawning (0)
carrot_visible: db 1

; Respawn counter (delay before carrot reappears after being eaten)
respawn_timer:  dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------------------------------
; Subroutine to clear the screen
;--------------------------------------------------------------------
clrscr:
    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax       ; Point es to video base
    mov di, 0        ; Point di to top left column
    mov ah, 0x07
    mov al, 0

nextloc:
    mov word [es:di], ax   ; Clear next character on the screen
    inc al
    add di, 2             ; Move to the next screen location
    cmp di, 11352         ; 132x43x2
    jne nextloc           ; If not cleared, move to the next position

    pop di
    pop ax
    pop es
    ret

;--------------------------------------------------------------------
; Subroutine to divide the screen into three parts with colors
;--------------------------------------------------------------------
divideScreen:

    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax           ; Point es to video base
    mov di, 0            ; Point di to top left column
    


    ;mov cx, 19           ; Top section 
    call fillSection1

    ;mov cx, 33           ; Middle section 
    call fillSection2

        
    ;mov cx, 43           ; Bottom section 
    call fillSection3
	
	push 3128
	push '%'
	push 0x63
	push 5
	push 8
	push 254
	call bridge_Grid ;3rd Last Pillar
	push 3406
	push '%'
	push 0x63
	push 5
	push 7
	push 254
	call bridge_Grid ;2nd Last Pillar
	push 3684
	push '%'
	push 0x63
	push 5
	push 6
	push 254
	call bridge_Grid ;Last Pillar
	push 3302
	push '%'
	push 0x63
	push 6
	push 7
	push 252
	call bridge_Grid ; 1st Pillar 
	push 2050
	push '%'
	push 0x34
	push 11
	push 12
	push 242
	call bridge_Grid ; Middle Building
	push 3048
	push '%'
	push 0x43
	push 31
	push 8
	push 202
	call bridge_Grid ; First Building
	push 2784
	push '%'
	push 0x63
	push 3
	push 2
	push 258 
	call bridge_Grid ; Upper 1st Pillar
	push 2292
	push '%'
	push 0x63
	push 7
	push 4
	push 250
	call bridge_Grid ; Upper 4th Pillar
    push 2272
	push '%'
	push 0x63
	push 7
	push 4
	push 250 
	call bridge_Grid ; Upper 1st Pillar
	push 2526
	push '%'
	push 0x63
	push 3
	push 3
	push 258
	call bridge_Grid ; Upper 2nd Pillar
	push 4160
	push '%'
	push 0x53
	push 28
	push 4
	push 208
	call bridge_Grid ; 3rd Building
	push 7580
	push '%'
	push 0x53
	push 32
	push 3
	push 200
	call bridge_Grid ; Main Engine Floor
	push 5998
	push '%'
	push 0x54
	push 8
	push 8
	push 248
	call bridge_Grid ; Main Engine Door
	push 6806
	push '%'
	push 0x16
	push 6
	push 4
	push 252
	call bridge_Grid ; Engine 1st 
	push 7082
	push '%'
	push 0x46
	push 6
	push 3
	push 252
	call bridge_Grid ; Engine 2nd 
	push 7358
	push '%'
	push 0x64
	push 6
	push 2
	push 252
	call bridge_Grid ; Engine 3rd
	push 7106
	push '%'
	push 0x12
	push 6
	push 4
	push 252
	call bridge_Grid ; steam Part_Engine
	push 6580
	push '%'
	push 0x72
	push 2
	push 2
	push 260
	call bridge_Grid ; steamer
	push 6730
	push '%'
	push 0x47
	push 25
	push 6
	push 214
	call bridge_Grid ; First Bunker
	push 6406
	push '%'
	push 0x47
	push 25
	push 7
	push 214
	call bridge_Grid ; second Bunker
	push 6346
	push '%'
	push 0x47
	push 25
	push 7
	push 214
	call bridge_Grid ; third Bunker
	
;---------------------------------------------------------------------
;                       Calling of Train's Tyre
;---------------------------------------------------------------------
	push 8200
	push ''
	push 0x07
	push 4
	push 1
	push 2
	call bridge_Grid     ;tyre 1
	
	
	
	push 8228
	push ''
	push 0x07
	push 4
	push 1
	push 2
	call bridge_Grid     ;tyre 2
	
	
	push 8260
	push ''
	push 0x07
	push 4
	push 1
	push 2
	call bridge_Grid     ;tyre 3
	
	push 8288
	push ''
	push 0x07
	push 4
	push 1
	push 2
	call bridge_Grid     ;tyre 4
	
	push 8320
	push ''
	push 0x07
	push 4
	push 1
	push 2
	call bridge_Grid     ;tyre 5
	
	push 8348
	push ''
	push 0x07
	push 4
	push 1
	push 2
	call bridge_Grid     ;tyre 6
	
	push 8376
	push ''
	push 0x00
	push 4
	push 2
	push 2
	call bridge_Grid     ;main tyre
    push 8422
	push ' '
	push 0x00
	push 4
	push 1
	push 2
	call bridge_Grid     ;front tyre
	

;--------------------------------------------------------
;                   connection line
;--------------------------------------------------------
   
	push 7716
	push '-'
	push 0x02
	push 5
	push 3
	push 50
	call bridge_Grid 
    
	push 7402
	push '%'
	push 0x4E
	push 25
	push 2
	push 214
	call bridge_Grid   
	
	push 7462
	push '%'
	push 0x4E
	push 25
	push 2
	push 214
	call bridge_Grid  
	
	push 7522
	push '%'
	push 0x4E
	push 25
	push 2
	push 214
	call bridge_Grid  
;--------------------------------------------------------
;                     CAP - Heads
;--------------------------------------------------------

	push 6470
	push '$'
	push 0x74
	push 21
	push 1
	push 2
	call bridge_Grid  ; First box
	push 6140
	push '$'
	push 0x74
	push 27
	push 1
	push 2
	call bridge_Grid  ; Second box
	push 6080
	push '$'
	push 0x74
	push 27
	push 1
	push 2
	call bridge_Grid  ; third box
	push 5732
	push '$'
	push 0x14
	push 10
	push 1
	push 2
	call bridge_Grid ; main Engine
;-----------------------------------------------------------
;                     Train - Windows
;-----------------------------------------------------------
	push 6612
	push '&'
	push 0xB1
	push 7
	push 3
	push 250
	call bridge_Grid 
	
	push 6628
	push '&'
	push 0xB1
	push 7
	push 3
	push 250
	call bridge_Grid 
	
	push 6644
	push '&'
	push 0xB1
	push 7
	push 3
	push 250
	call bridge_Grid 
	
	push 6672
	push '&'
	push 0xB1
	push 7
	push 3
	push 250
	call bridge_Grid 
	
	push 6688
	push '&'
	push 0xB1
	push 7
	push 3
	push 250
	call bridge_Grid 
	
	push 6704
	push '&'
	push 0xB1
	push 7
	push 3
	push 250
	call bridge_Grid 
	
	push 7056
	push '&'
	push 0x31
	push 6
	push 3
	push 252
	call bridge_Grid 
;-----------------------------------------------------------
;                     Hogwarts - Windows
;-----------------------------------------------------------
    push 2316
	push '%'
	push 0xBE
	push 1
	push 5
	push 2
	call bridge_Grid 
	
	push 2844
	push '%'
	push 0xBE
	push 1
	push 5
	push 2
	call bridge_Grid 
	
	push 3376
	push '%'
	push 0xBE
	push 1
	push 4
	push 2
	call bridge_Grid 
	
	push 2558
	push '%'
	push 0xEE
	push 1
	push 3
	push 2
	call bridge_Grid 
	
	push 2822
	push '%'
	push 0xEE
	push 1
	push 3
	push 2
	call bridge_Grid 
	
	push 2538
	push '%'
	push 0xEE
	push 1
	push 3
	push 2
	call bridge_Grid 
	
	push 2802
	push '%'
	push 0xEE
	push 1
	push 3
	push 2
	call bridge_Grid 
	
	push 3580
	push '%'
	push 0xBE
	push 3
	push 2
	push 258
	call bridge_Grid 
	
	push 3588
	push '%'
	push 0xBE
	push 3
	push 2
	push 258
	call bridge_Grid 
	
	push 3596
	push '%'
	push 0xBE
	push 3
	push 2
	push 258
	call bridge_Grid 
	
	push 3604
	push '%'
	push 0xBE
	push 3
	push 2
	push 258
	call bridge_Grid 
	
	push 3612
	push '%'
	push 0xBE
	push 3
	push 2
	push 258
	call bridge_Grid 
	
	push 3620
	push '%'
	push 0xBE
	push 3
	push 2
	push 258
	call bridge_Grid 
;-------------------------------------------------------
;      Phase 3
;-------------------------------------------------------
;carrots
push 9914
push '\'
push 0x07
push 1
push 2
push 266
call bridge_Grid ; left

push 9918
push '/'
push 0x07
push 1
push 2
push 260
call bridge_Grid
;Rabbit   
push 10422
push '('
push 0x07
push 1
push 2
push 262
call bridge_Grid ; left

push 10434
push ')'
push 0x07
push 1
push 2
push 262
call bridge_Grid ; right

push 10426
push '^'
push 0x07
push 1
push 2
push 2
call bridge_Grid ; eyes

push 10952
push '-'
push 0x07
push 1
push 5
push 0
call bridge_Grid ; Feet

push 10168
push '/'
push 0x07
push 1
push 1
push 0
call bridge_Grid ; EEAR_R

push 10160
push '\'
push 0x07
push 1
push 1
push 0
call bridge_Grid ; EEAR_L

push 10162
push '-'
push 0x07
push 1
push 3
push 0
call bridge_Grid ; Head

push 10962
push '0'
push 0x07
push 1
push 1
push 0
call bridge_Grid ; Tail

push 10692
push 'v'
push 0x07
push 1
push 1
push 0
call bridge_Grid ; mouth
;-----------------------------------------------
;        BRICKS
;-----------------------------------------------
push 11208
push '-'
push 0x44
push 1
push 15
push 0
call bridge_Grid
;-----------------------------------------------------------
	call border_Grid
	

    pop di
    pop ax
    pop es
    ret
;--------------------------------------------------------------------
fillSection1:
	
	push di
	push ax
	push es

	mov di,0
	mov al,' '			; Storing Character
	mov ah,0x00        ; Attribute Byte

fillLoop1:
    mov [es:di], ax     ; Fill the screen location with the specified color and character
    add di, 2            ; Move to the next screen location
	cmp di,5016
    jnz fillLoop1          ; Continue until the section is filled
	
	pop es
	pop ax
	pop di
	
    ret
	
;---------------------------------------------------------------------
;          					BRIDGE BRICKS
;--------------------------------------------------------------------



bridge_Grid:
	push bp
	mov bp,sp
	push cx
	push ax
	push di
	push es
	
	mov ax, 0xb800
    mov es, ax  
	mov ch,[bp+6] ;outer counter
	mov di,[bp+14]
	mov al,[bp+12]
	mov ah,[bp+10]
	
outerloop:

	mov cl,[bp+8]
	innerloop:
	
	mov[es:di],ax
	add di,2
	dec cl
	jnz innerloop
	add di,[bp+4]
	dec ch
	
	jnz outerloop
	
	
	pop es
	pop di
	pop ax
	pop cx
	pop bp
	ret 12
	

;--------------------------------------------------------------------
;          					Border Line
;--------------------------------------------------------------------

	
	
border_Grid:
	push ax
	push di
	push es
	
	mov di,8976
	mov al,' '
	mov ah,0x00
	
filler_Border:

	mov[es:di],ax
	add di,2
	cmp di,9240
	jnz filler_Border
	
	pop es
	pop di
	pop ax
	border_Grid1:
	push ax
	push di
	push es
	
	mov di,8448
	mov al,' '
	mov ah,0x07
	
filler_Border1:

	mov[es:di],ax
	add di,2
	cmp di,8712
	jnz filler_Border1
	
	pop es
	pop di
	pop ax
	
	call border_Grid2
	
	border_Grid2:
	push ax
	push di
	push es
	
	mov di,8448
	mov al,'/'
	mov ah,0x06
	
filler_Border2:

	mov[es:di],ax
	add di,6
	cmp di,8712
	jnz filler_Border2
	
	pop es
	pop di
	pop ax
	
	    ret 
	ret 

ret 


fillSection2:
   
	push ax
	push di
	push es

    mov ah,0x2F ; Attribute Byte
	mov al,' '  ; Storing Character
	mov di,5016

fillLoop2:
    mov [es:di], ax      ; Fill the screen location with the specified color and character
    add di, 2            ; Move to the next screen location
	cmp di,8976
    jnz fillLoop2          ; Continue until the section is filled

	pop es
	pop di
	pop ax
	
    ret

;--------------------------------------------------------------------
fillSection3:
	
	push ax
	push di
	push cx
	push es
	
    mov ah, 0x07	; Attribute Byte
	mov al, '' ; Character Storage
	mov di,8976

fillLoop3:
    mov [es:di], ax      ; Fill the screen location with the specified color and character
    add di, 2            ; Move to the next screen location
    dec cx
	cmp di,11352
    jnz fillLoop3          ; Continue until the section is filled

	pop es
	pop cx
	pop di
	pop ax
	
    ret
	
;--------------------------------------------------------------------
;          				mountain
;--------------------------------------------------------------------	
draw_triangle:
    push bp             ; Save the current base pointer
    mov bp, sp          ; Set up a new base pointer

    sub sp, 4           ; Allocate 4 bytes of space for local variables
    mov word[bp-4], 0   ; Initialize a local variable to 0 for row tracking

    push es             ; Save ES register
    push ax             ; Save AX register
    push bx             ; Save BX register
    push di             ; Save DI register
    push si             ; Save SI register

    mov cx, [bp+4]      ; Load the size of the triangle from the stack
    mov ax, 0xb800      ; Set AX to the video memory segment (0xb800)
    mov es, ax          ; Set ES to the video memory segment

    mov si, [bp+8]      ; Load the starting row for drawing the triangle
    mov ax, 132         ; Compute the starting offset in video memory
    mul si				; Multiplies AX with SI 
    push bx
    mov bx, 2           ; Each character cell in video memory is 2 bytes
    mul bx				; Multiplies AX with BX 
    pop bx
    mov bx, ax			; It multiplies the starting row index (SI) by 132 (the number of character cells in each row) and then doubles the result to account for the 2 bytes per character cell

    mov ax, [bp+6]      ; Load the character or color information for drawing
    push cx				
    mov cx, 2           ; Multiply by 2 for the character cell size
    mul cx				;This effectively doubles the value stored in AX. The result is stored back in AX. Since the value in AX originally represented the character or color information, it now represents double that information, essentially creating a pair of characters with the same character and color.
    pop cx
    add bx, ax          ; Add the offset to the character information

    mov [bp-2], bx      ; Store the base address for video memory in a local variable

    mov cx, [bp+4]      ; Reload the size of the triangle
    mov di, 0           ; Initialize DI for row tracking
    mov si, 2           ; Initialize SI for column tracking
    mov ax, [bp+10]     ; Load character or color information

right_half:
    mov word [es:bx], ax ; Write the character or color information to video memory

    push ax
    mov ax, 132         ; Width of a row in characters
    push bx
    mov bx, 2           ; Character cell size
    mul bx
    pop bx
    push cx
    mov cx, si          ; Current column
    add ax, cx
    pop cx
    add bx, ax

    pop ax

    push dx
    push bx
    push cx
    cmp cx, 1           ; Check if it's the first character in the row
    je skip_right
    mov di, 2           ; If not, set the row increment to 2
    mov dx, bx          ; Save the base address of the previous row
    mov cx, [bp-4]
    sub bx, 2           ; Move to the previous row

fill_right:
    cmp cx, 0           ; Loop to fill characters in the row
    jz skip_right
    mov word [es:bx], ax
    sub bx, di
    sub cx, 1
    cmp cx, 0
    jnz fill_right

skip_right:
    pop cx
    pop bx
    pop dx
    add word [bp-4], 1   ; Increment the row counter

    sub cx, 1
    jnz right_half

						 ; Second half variables reset
    mov si, 2            ; Reset SI for diagonal change
    mov di, 0            ; Reset DI for row change
    mov cx, [bp+4]       ; Reload the size of the triangle
    mov bx, [bp-2]       ; Reload the base address for video memory
    mov word [bp-4], 0   ; Reset row counter
    mov ax, [bp+10]      ; Reload character or color information

left_half:
    mov word [es:bx], ax ; Write character or color information to video memory
    push ax
    mov ax, 132         ; Width of a row in characters
    push bx
    mov bx, 2           ; Character cell size
    mul bx
    pop bx
    push cx
    mov cx, si          ; Current column
    sub ax, cx
    pop cx
    add bx, ax
    pop ax

    push dx
    push bx
    push cx
    cmp cx, 1           ; Check if it's the first character in the row
    je skip_left
    mov di, 2           ; If not, set the row increment to 2
    mov dx, bx          ; Save the base address of the previous row
    mov cx, [bp-4]
    add bx, 2           ; Move to the next row

fill_left:
    mov word [es:bx], ax ; Fill characters in the row
    add bx, di
    sub cx, 1
    cmp cx, 0
    jnl fill_left

skip_left:
    pop cx
    pop bx
    pop dx
    add word [bp-4], 1   ; Increment the row counter
    sub cx, 1
    jnz left_half

    pop si
    pop di
    pop bx
    pop ax
    pop es

    mov sp, bp           ; Restore the stack pointer
    pop bp               ; Restore the base pointer
    ret 8                ; Return from the function, cleaning up 8 bytes of arguments

;------------------------------------------------
;                  Phase 2
;------------------------------------------------

;-------------------------------------------------
;         scroll left	
;-------------------------------------------------
scroll_left:
    push bp
	mov bp,sp
    push di
    push si
    push ax
    push es
    push cx
	push ds

    mov ax, 0xb800
    mov es, ax
    mov ds, ax
	
    mov cx,19
    mov di, 0 ; Starting position (right end of the last row)
    mov si, 2 ; Starting position (right end of the last row)
	mov dx,di

outer:
    mov ax, [es:di]
	mov dx,di
	cld
	add dx,262
inner:
    
    movsw
	cmp dx,di
    jg inner
   
    mov [es:di],ax
	add di, 2  ; Move di left
    add si, 2 ; Move si left
	
	loop outer
   

    pop cx
    pop es
    pop ax
    pop si
    pop di
	pop ds
	pop bp
	call delay
    ret
;-------------------------------------------------
;         scroll right	
;-------------------------------------------------
scroll_right:
    push bp
	mov bp,sp
    push di
    push si
    push ax
    push es
    push cx
	push ds

    mov ax, 0xb800
    mov es, ax
    mov ds, ax
	
    mov cx,14
    mov di, 8974; Starting position (right end of the last row)
    mov si, 8972  ; Starting position (right end of the last row)
	;mov dx,di

outer1:
    mov ax, [es:di]
	mov dx,di
	sub dx,262
	std
inner1:
   
    movsw
	cmp dx,di
    jb inner1
   
    mov [es:di],ax
	sub di, 2  ; Move di left
    sub si, 2 ; Move si left
	
	loop outer1
   

    pop cx
    pop es
    pop ax
    pop si
    pop di
	pop ds
	pop bp
	call delay
    ret

	
delay:
xor cx,cx
xor dx,dx
mov cx,20000
next:
mov dx,1
next2:
dec dx
jnz next2
loop next
ret	

;------------------------------------------------
;                  phase 5
;------------------------------------------------

starting:

pusha  
    mov ah, 0x00
    mov al, 0x54
    int 0x10
	;;;;for clear screen
	mov ah,06h 
	xor al,al
	xor cx,cx 
	mov dh,42
	mov dl,132 ;;; dh=row and dl=column 
	mov bh,40h ;;;red background and black foreground 
	int 10h
	
	mov ah,0x13
	mov al,1
	mov bh,0
	mov bl,40h
	mov cx,17 ;;; length
	mov dh,2
	mov dl,66
	push cs
	pop es
	mov bp,string1
	int 0x10
	
	mov ah,0x13
	mov al,1 ;;;; update the cursor
	mov bh,0 ;;;;; page number
	mov bl,40h ;;;;; attribute
	mov cx,19 ;;;; 2nd length
	mov dh,6
	mov dl,0
	push cs
	pop es
	mov bp,string2
	int 0x10
	
	mov ah,0x13
	mov al,1 ;;;; update the cursor
	mov bh,0
	mov bl,40h
	mov cx,43 
	mov dh,7
	mov dl,0
	push cs
	pop es
	mov bp,string3 
	int 0x10

	mov ah,0x13
	mov al,1 ;;;; update the cursor
	mov bh,0
	mov bl,40h
	mov cx,38
	mov dh,8
	mov dl,0
	push cs
	pop es
	mov bp,string4 
	int 0x10

	mov ah,0x13
	mov al,1 ;;;; update the cursor
	mov bh,0
	mov bl,40h
	mov cx,20
	mov dh,9
	mov dl,0
	push cs
	pop es
	mov bp,string5
	int 0x10
	call delay
	jmp start
	
	
;--------------------------------------------------------------------
start:
    ; Change your screen resolution to 43x132 Mode
	
    mov ah, 0x00
    mov al, 0x54
    int 0x10
    ;call starting
    ; Call the function to divide the screen into three parts with colors
    call divideScreen
	; call the screen for the mountains
	mov al,'-'
    mov ah,0x07
    push ax
    push word(0xe)

    mov al, '-'
    mov ah, 0x07
    push ax
    push word(0x1c)
    mov si,0
	draw_mountains:
    mov al,'%'
    mov ah,byte[color+si]
    push ax

    mov ah, 0
    mov al, byte[my_row + si]
    push ax                         ; push row
    mov al, byte[my_col + si]
    push ax                         ; push col
    mov al, byte[my_size + si]
    push ax                         ; push size of triangle

    call draw_triangle
	
    inc si
    cmp si, word[my_entries]
    jne draw_mountains
	
	;------------------------------------------------------------
	; Main game loop
	;------------------------------------------------------------
	game_loop:
	    call scroll_left
	    call scroll_right

	    ; --- Update scroll positions for rabbit and carrot ---
	    ; scroll_left shifts scene left by 1 col, scroll_right shifts right by 1 col
	    ; Net effect per full cycle: scene returns to same place, but we track
	    ; the carrot moving toward the rabbit (leftward scroll dominates visually)
	    ; We treat every 2 scroll cycles as carrot moving 1 col closer to rabbit
	    inc word [cs:scroll_tick]
	    cmp word [cs:scroll_tick], 2
	    jl  skip_pos_update
	    mov word [cs:scroll_tick], 0

	    ; Move carrot left (toward rabbit) each tick
	    cmp byte [cs:carrot_visible], 0
	    je  check_respawn

	    dec word [cs:carrot_col]
	    cmp word [cs:carrot_col], 0   ; If carrot scrolled off left edge
	    jg  check_collision
	    mov word [cs:carrot_col], 131  ; Respawn at right edge
	    jmp skip_pos_update

	check_collision:
	    ; Collision: rabbit eats carrot if carrot_col within 4 cols of rabbit_col
	    mov ax, [cs:rabbit_col]
	    mov bx, [cs:carrot_col]
	    sub ax, bx
	    jns .pos_diff
	    neg ax
	.pos_diff:
	    cmp ax, 4
	    jg  skip_pos_update     ; Not close enough

	    ; --- RABBIT EATS CARROT ---
	    inc word [cs:score]
	    mov byte [cs:carrot_visible], 0
	    mov word [cs:respawn_timer], 80   ; Wait 80 ticks before respawning
	    call erase_carrot
	    call display_score
	    jmp skip_pos_update

	check_respawn:
	    dec word [cs:respawn_timer]
	    cmp word [cs:respawn_timer], 0
	    jg  skip_pos_update
	    ; Respawn carrot at right side
	    mov byte [cs:carrot_visible], 1
	    mov word [cs:carrot_col], 131
	    call draw_carrot

	skip_pos_update:
	    ; Draw score on screen every loop
	    call display_score

	    ; --- Check for ESC key (non-blocking) ---
	    mov ah, 0x01          ; Check if key available
	    int 0x16
	    jz  game_loop         ; No key pressed, keep looping
	    mov ah, 0x00          ; Read the key
	    int 0x16
	    cmp al, 0x1B          ; ESC key
	    jne game_loop         ; Not ESC, ignore and loop

	    ; --- ESC pressed: Exit ---
	    mov ah, 0x4C
	    int 0x21


;--------------------------------------------------------------------
; display_score  -- writes "SCORE: NNNNN" in top-right of screen
; Uses INT 10h write string (ah=13h) for simplicity
;--------------------------------------------------------------------
display_score:
	    push ax
	    push bx
	    push cx
	    push dx
	    push si
	    push di
	    push es

	    ; Convert score word to 5 ASCII digits in score_digits
	    mov ax, [cs:score]
	    mov di, cs
	    mov es, di
	    mov di, score_digits + 4   ; Point to last digit

	    mov cx, 5
	.conv_loop:
	    xor dx, dx
	    mov bx, 10
	    div bx                ; ax = quotient, dx = remainder
	    add dl, '0'
	    mov [es:di], dl
	    dec di
	    loop .conv_loop

	    ; Display score label at row 0, col 119 (top-right area)
	    mov ah, 0x13
	    mov al, 1             ; Move cursor after write
	    mov bh, 0             ; Page 0
	    mov bl, 0x0E          ; Yellow on black
	    mov cx, 7             ; "SCORE: " is 7 chars
	    mov dh, 0             ; Row 0
	    mov dl, 119           ; Col 119 (132-col screen)
	    push cs
	    pop es
	    mov bp, score_label
	    int 0x10

	    ; Display the 5-digit number right after (col 126)
	    mov ah, 0x13
	    mov al, 1
	    mov bh, 0
	    mov bl, 0x0E
	    mov cx, 5
	    mov dh, 0
	    mov dl, 126
	    push cs
	    pop es
	    mov bp, score_digits
	    int 0x10

	    pop es
	    pop di
	    pop si
	    pop dx
	    pop cx
	    pop bx
	    pop ax
	    ret


;--------------------------------------------------------------------
; draw_carrot  -- draws carrot at current carrot_col position, row 39
;--------------------------------------------------------------------
draw_carrot:
	    push ax
	    push bx
	    push di
	    push es

	    mov ax, 0xb800
	    mov es, ax

	    ; Compute video offset: row=37, col=carrot_col
	    ; offset = (row * 132 + col) * 2
	    mov ax, 37
	    mov bx, 132
	    mul bx              ; ax = 37*132 = 4884
	    add ax, [cs:carrot_col]
	    shl ax, 1           ; *2 for word offset
	    mov di, ax

	    ; Draw '\' char (left of carrot)
	    mov word [es:di], 0x075C   ; '\\' with light grey attr
	    add di, 2
	    ; Draw '/' char (right of carrot)
	    mov word [es:di], 0x072F   ; '/' with light grey attr

	    pop es
	    pop di
	    pop bx
	    pop ax
	    ret


;--------------------------------------------------------------------
; erase_carrot  -- erases carrot from screen (writes spaces)
;--------------------------------------------------------------------
erase_carrot:
	    push ax
	    push bx
	    push di
	    push es

	    mov ax, 0xb800
	    mov es, ax

	    mov ax, 37
	    mov bx, 132
	    mul bx
	    add ax, [cs:carrot_col]
	    shl ax, 1
	    mov di, ax

	    mov word [es:di], 0x0720    ; Space (erase left char)
	    add di, 2
	    mov word [es:di], 0x0720    ; Space (erase right char)

	    pop es
	    pop di
	    pop bx
	    pop ax
	    ret