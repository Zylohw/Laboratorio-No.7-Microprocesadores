        AREA |.text|, CODE, READONLY, ALIGN=2
        THUMB
        REQUIRE8
        PRESERVE8

	
        EXPORT	LEDs_Init
		EXPORT	LED_Toggle
			
RCC		EQU		0x40021000
	
; Deben buscar el valor en el Reference Manual
;GPIOE	EQU		0x0	; EvalBoard
;GPIOB	EQU		0x0	; K8
GPIOB   EQU		0x48000400	; G4
;GPIOA	EQU		0x0 ; RE

AHB2ENR	EQU 	0x0000004C
	
; Deben buscar el valor en el Reference Manual
MODER   EQU		0x00	; OFFSET de MODER
ODR		EQU		0x14 ;OFFSSET  de ODR


LEDs_Init
	push {lr}
	
	;RCC->AHBENR |= (1<<1); 
	;**** Encender el puerto correspondiente de tu tarjeta ****
	
	ldr  r0, =RCC			;read
	ldr  r1, [r0,#AHB2ENR] ; caemos la región donde podemos encender el clock del but AHB2
	movs r2, #0x2      		;modify
	orrs r1, r1, r2     ; encedemos el bit 1 para indicar que queremos el CLOCK del GPIOB
	str  r1, [r0,#AHB2ENR]	;write
	
	;EvalBoard / Discovery
	;	GPIOE->MODER |= (1<<26);
	;	GPIOE->ODR &= ~(1<<13);
	;F303K8
	;	GPIOB->MODER &= ~(1<<7);			
	;	GPIOB->MODER |= (1<<6);
	;G431KB
	;	GPIOB->MODER &= ~(1<<17);
	;	GPIOB->MODER |= (1<<16);
	;F303RE
	;	GPIOA->MODER |= (1<<10);
	;	GPIOA->ODR &= ~(1<<5);	

	ldr r0,=GPIOB ; READ
	ldr r1,[R0,#MODER] ; cargando en el GPIO mas la sección de MODER
	ldr r2, =(1<<17) ; aplicamos mascara
	bic r1,r1,r2 ; operamos el and not para limpiar y setear la mascara
	ldr r3,=(1<<16) ; guardamos el bit donde queremos modificar 
	orr r1,r1,r3 ;aplicamos un OR para modificar el bit que queremos guardado en R3
	str r1, [r0,#MODER] ; escribimos los bits modificados
	pop {pc}

LED_Toggle
	push {lr}
	
	;GPIOE->ODR ^= 1<<13 EvalBoard / Disvovery
	;GPIOB->ODR ^= 1<<3 K8
	;GPIOB->ODR ^= 1<<8 G4
	;GPIOA->ODR ^= 1<<5 RE

	ldr r0,=GPIOB ; cargamos la dirección de GPIOB
	ldr r1,[r0,#ODR] ;usamos el OFFSET del ODR para caer en la región que queremos cambiar
	ldr r2,=(1<<8); indicamos el bit que queremos modificar
	eor r1,r1,r2; aplicaciones operación XOR para camibar el bit que queremos 
	str r1,[r0,#ODR] ;  lo escribimos

	
	pop {pc}

	end
