; 2) Mapeo de una entrada a una salida

; Edwin Fabian Cubides Pulido (202022491)
; Kevin Jeffrey Ramos (201920227)

RCC_AHB4ENR   EQU  0x58024540  ;Direccion de Registro control reloj RCC ;    BASE: 0x58024400 + OFFSET: 0x140
GPIOB_MODER   EQU  0x58020400  ;Direccion del puerto B  0x58020400
GPIOC_MODER   EQU  0x58020800  ;Direccion del puerto C  0x58020800
GPIOB_ODR     EQU  0x58020414  ;Registro de salida de datos ODR GPIOB ;      Offset   0x14
GPIOC_IDR     EQU  0x58020810  ;Registro de salida de datos IDR GPIOC ;      Offset   0x10

		AREA   |.text|, CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT __main
			
__main

		LDR  R0, = RCC_AHB4ENR	  ;Carga en R0 la dirección de RCC_AHB4ENR
		LDR  R1, [R0]			  ;Leer desde RAM y asigna ese valor en R0
								  ;PUERTOS: GFEDCBA
								  ;         0000110 = 0x06 (Se habilita B y C)
		ORR  R1, #0x00000006      ;ORR para habilitacion del RCC en PORT B y C; 
		STR  R1, [R0]			  ;Se devuelve el valor modificado a la RAM
		
		
		;Configuracion de  PB0 como salida (LED)
		
		LDR  R0, = GPIOB_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X0001          ;Parte baja
		MOVT R1, #0X0000          ;Parte alta
		STR  R1, [R0]			  ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R10, = GPIOB_ODR     ;Carga de ODR GPIO B en R10
		
		;Configuracion de PC13 como entrada (Botón)
		
		LDR  R0, = GPIOC_MODER    ;Carga en R0 la direccion de GPIOA_MODER
		MOVW R1, #0X0000          ;Parte baja
		MOVT R1, #0X0000          ;Parte alta
		STR  R1, [R0]	          ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R11, = GPIOC_IDR     ;Carga de ODR GPIO C en R11
        
		
LOOP
	    LDR  R2, [R11]            ;Lectura el estado de PC13 desde IDR - GPIOC     
		AND  R2, #0x2000          ;Verificar si PC13 está presionado (bit 13)
		CMP  R2, #0x2000
	    BNE  SIN_PRESIONAR        ;Si no está presionado, salta a SIN_PRESIONAR
		
	    MOV  R0, #0x00000001      ;Encendido de LED PB0 si  está presionado
	    STR  R0, [R10]            ;Estado se envía a ODR - GPIOB (RAM)
	    B    LOOP                 ;Salto - Loop infinito

SIN_PRESIONAR
	    MOV  R0, #0x00000000      ;Apagado de PB0 - LED D1
	    STR  R0, [R10]            ;Estado se envía a ODR - GPIOB (RAM)
	    B    LOOP                 ;Salto - Loop infinit
    
    END

