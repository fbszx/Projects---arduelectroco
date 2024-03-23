
;5) Lectura de Teclado Matricial

; Edwin Fabian Cubides Pulido (202022491)
; Kevin Jeffrey Ramos (201920227)

RCC_AHB4ENR   EQU  0x58024540  ;Direccion de Registro control reloj RCC ; BASE: 0x58024400 + OFFSET: 0x140

GPIOB_MODER   EQU  0x58020400  ;Direccion del puerto B  0x58020400
GPIOC_MODER   EQU  0x58020800  ;Direccion del puerto C  0x58020800
GPIOD_MODER   EQU  0x58020C00  ;Direccion del puerto D  0x58020C00

GPIOB_ODR     EQU  0x58020414  ;Registro de salida de datos ODR GPIOB ; Offset   0x14
GPIOD_ODR     EQU  0x58020C14  ;Registro de salida de datos ODR GPIOD ; Offset   0x14
GPIOC_IDR     EQU  0x58020810  ;Registro de entrada de datos IDR GPIOC ; Offset   0x10


		AREA   |.text|, CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT __main

     	
__main

		LDR  R0, = RCC_AHB4ENR	  ;Carga en R0 la dirección de RCC_AHB4ENR
		LDR  R1, [R0]			  ;Leer desde RAM y asigna ese valor en R0
								  ;PUERTOS: GFEDCBA
								  ;         0001110 = 0xE (Se habilita B,C y D)
		ORR  R1, #0x0000000E      ;ORR para habilitacion del RCC en PORT B,C y D;
		STR  R1, [R0]			  ;Se devuelve el valor modificado a la RAM
		
		
		;Config de  PB0 y  PB14 como salida (Led de usuario) 
		
		LDR  R0, = GPIOB_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X0001          ;Parte baja
		MOVT R1, #0X1000          ;Parte alta
		STR  R1, [R0]			  ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R9, = GPIOB_ODR
		
		;Config de  PD7, PD11, PD12 y PD13 como salidas (FILAS de Tecl Matricial 4x4)
		
		LDR  R0, = GPIOD_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X4000          ;Parte baja
		MOVT R1, #0X0540          ;Parte alta
		STR  R1, [R0]			  ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R11, = GPIOD_ODR
		
		;Config de  PC6, PC7, PC8 y PC9 como entradas (COLUMNAS de Tecl Matricial 4x4) 
		
		LDR  R0, = GPIOC_MODER    ;Carga en R0 la direccion de GPIOC_MODER
		MOVW R1, #0X0000          ;Parte baja
		MOVT R1, #0X0000          ;Parte alta
		STR  R1, [R0]	          ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R10, = GPIOC_IDR
       
		MOV   R8, #0 ;Contador Correcto
		MOV   R7, #0 ;Contador Incorrecto
		
LOOP
		CMP   R8, #4
		BEQ.W CORRECTO
		
		CMP  R7, #4
		BEQ.W CONTADOR1
;=====================================================================================

		MOV  R0, #0X80     ;Activado de Fila 1 (PD7 en 1) (PD11,PD12 Y PD13 en 0)
		STR  R0, [R11]

;=====================================================================================
	
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X40    ;Verificar si Columna 1 (PC6) esta en 1 (PC7,PC8,PC9 en 0)
		CMP  R2, #0X40
		BEQ  TECLA1             ;#Número 1
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X80    ;Verificar si Columna 2 (PC7) esta en 1 (PC6,PC8,PC9 en 0)
		CMP  R2, #0X80
		BEQ  TECLA2             ;Número 2
	
	    LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X100     ;Verificar si Columna 3 (PC8) esta en 1 (PC6,PC7,PC9 en 0)
		CMP  R2, #0X100
		BEQ  TECLA3             ;Número 3
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X200     ;Verificar si Columna 4 (PC9) esta en 1 (PC6,PC7,PC8 en 0)
		CMP  R2, #0X200
		BEQ  TECLAA             ;Letra A

;=====================================================================================	    
		
		MOV  R0, #0X800     ;Activado de Fila 2 (PD11 en 1) (PD7,PD12 Y PD13 en 0)
		STR  R0, [R11]

;=====================================================================================

        LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X40    ;Verificar si Columna 1 (PC6) esta en 1 (PC7,PC8,PC9 en 0)
		CMP  R2, #0X40
		BEQ  TECLA4             ;#Número 4
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X80    ;Verificar si Columna 2 (PC7) esta en 1 (PC6,PC8,PC9 en 0)
		CMP  R2, #0X80
		BEQ  TECLA5             ;Número 5
	
	    LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X100     ;Verificar si Columna 3 (PC8) esta en 1 (PC6,PC7,PC9 en 0)
		CMP  R2, #0X100
		BEQ  TECLA6             ;Número 6
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X200     ;Verificar si Columna 4 (PC9) esta en 1 (PC6,PC7,PC8 en 0)
		CMP  R2, #0X200
		BEQ  TECLAB            ;Letra B

;=====================================================================================	

        MOV  R0, #0X1000     ;Activado de Fila 3 (PD12 en 1) (PD7,PD11 Y PD13 en 0)
		STR  R0, [R11]

;=====================================================================================

        LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X40    ;Verificar si Columna 1 (PC6) esta en 1 (PC7,PC8,PC9 en 0)
		CMP  R2, #0X40
		BEQ  TECLA7             ;#Número 7
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X80    ;Verificar si Columna 2 (PC7) esta en 1 (PC6,PC8,PC9 en 0)
		CMP  R2, #0X80
		BEQ  TECLA8             ;Número 8
	
	    LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X100     ;Verificar si Columna 3 (PC8) esta en 1 (PC6,PC7,PC9 en 0)
		CMP  R2, #0X100
		BEQ  TECLA9             ;Número 9
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X200     ;Verificar si Columna 4 (PC9) esta en 1 (PC6,PC7,PC8 en 0)
		CMP  R2, #0X200
		BEQ  TECLAC             ;Letra C

;=====================================================================================

        MOV  R0, #0X2000         ;Activado de Fila 4 (PD13 en 1) (PD7,PD11 Y PD12 en 0)
		STR  R0, [R11]

;=====================================================================================
 
        LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X40    ;Verificar si Columna 1 (PC6) esta en 1 (PC7,PC8,PC9 en 0)
		CMP  R2, #0X40
		BEQ  ASTERIS             ;#Asterisco
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X80    ;Verificar si Columna 2 (PC7) esta en 1 (PC6,PC8,PC9 en 0)
		CMP  R2, #0X80
		BEQ  TECLA0             ;Número 0
	
	    LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X100     ;Verificar si Columna 3 (PC8) esta en 1 (PC6,PC7,PC9 en 0)
		CMP  R2, #0X100
		BEQ  NUMERAL             ;Númeral
		
		LDR  R2, [R10]          ;Lectura de GPIOC - Columnas - Entradas
		AND  R2, R2, #0X200     ;Verificar si Columna 4 (PC9) esta en 1 (PC6,PC7,PC8 en 0)
		CMP  R2, #0X200
		BEQ  TECLAD             ;Letra D
		B LOOP
		
		;=======================CLAVE: 2543 ========================================================
		
		;MOV  R8,#0  ; Contador de CORRECTOS
		;MOV  R7,#0  ; Contador de INCORRECTOS
			
TECLA1
		
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP
		
TECLA2	
	    
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R8,R8,#1
		ADD  R7,R7,#1
		B    LOOP
		
TECLA3
		
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R8,R8,#1
		ADD  R7,R7,#1
		B    LOOP

TECLAA
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP
			
TECLA4
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R8,R8,#1
		ADD  R7,R7,#1
		B    LOOP
		
TECLA5
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R8,R8,#1
		ADD  R7,R7,#1
		B    LOOP

TECLA6
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP	
		
TECLAB
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP

TECLA7
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP
			
TECLA8
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP
		
TECLA9
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP      

TECLAC
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP       
		
		
ASTERIS
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP        			

TECLA0
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP	        		


NUMERAL
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP	        
		
TECLAD
		MOV  R3,#700             ; Delay para funcion de debounce 700mS
        BL   DELAY_MS
		ADD  R7,R7,#1
		B    LOOP

CONTADOR1
	
		ADD R12, R12, #1
		CMP R12, #3
		MOV R7, #0
		BNE LOOP
		BEQ STOP
		
STOP

		MOV  R1, #0x4000      ;Encendido de PB14 - LED D2
	    STR  R1, [R9]        ;Estado se envía a ODR - GPIOB (RAM)
	    MOV  R3, #10000
		BL   DELAY_MS
		MOV  R1, #0x0000      ;Apagado de PB14 - LED D2
	    STR  R1, [R9]        ;Estado se envía a ODR - GPIOB (RAM)
		MOV  R8, #0
		MOV  R7, #0
		B    LOOP

CORRECTO
		
		MOV  R1, #0x0001      ;Encendido de PB0 - LED D1
	    STR  R1, [R9]        ;Estado se envía a ODR - GPIOB (RAM)
		MOV  R8, #0
		MOV  R7, #0
	    B   LOOP 
					
		
;=========================== FUNCION DELAY_MS =====================================0

DELAY_MS
DELAY_02	MOV R4, #0x3E80

DELAY_01    SUB R4, #0x01
            CMP R4, #0x00
			BNE DELAY_01
			SUB R3, #0x01
			CMP R3, #0x00
			BNE DELAY_02
			BX  LR
			
			ALIGN
			END		
	