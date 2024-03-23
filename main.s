

; 1) Secuencia de encendido y apagado de LEDS

; Edwin Fabian Cubides Pulido (202022491)
; Kevin Jeffrey Ramos ()

RCC_AHB4ENR   EQU  0x58024540  ;Direccion de Registro control reloj RCC ; BASE: 0x58024400 + OFFSET: 0x140
GPIOB_MODER   EQU  0x58020400  ;Direccion del puerto B  0x58020400
GPIOE_MODER   EQU  0x58021000  ;Direccion del puerto E  0x58021000
GPIOB_ODR     EQU  0x58020414  ;Registro de salida de datos ODR GPIOB ; Offset   0x14
GPIOE_ODR     EQU  0x58021014  ;Registro de salida de datos ODR GPIOE ; Offset   0x14

		AREA   |.text|, CODE, READONLY, ALIGN = 2
		ENTRY
		EXPORT __main
			
__main

		LDR  R0, = RCC_AHB4ENR	  ;Carga en R0 la dirección de RCC_AHB4ENR
		LDR  R1, [R0]			  ;Lectura desde RAM y asignacion en R0

								  ;PUERTOS: GFEDCBA
								  ;         0010010 = 0x12 (Se habilita E y B)
		ORR  R1, #0x00000012      ;ORR para habilitacion del RCC en PORT B y E; 
		STR  R1, [R0]			  ; Se devuelve el valor modificado a la RAM
		
		
		;Configuracion de PB14 y PB0 como salidas
		
		LDR  R0, = GPIOB_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X0001          ;Parte baja
		MOVT R1, #0X1000          ;Parte alta
		STR  R1, [R0]			  ;Guarda el valor nuevo en la RAM (GPIOMODER)
		LDR  R10, = GPIOB_ODR     ; Carga en R10 el ODR para GPIOB
		
		;Configuracion de PE1 como salida
		
		LDR  R0, = GPIOE_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X0004          ;Parte baja
		MOVT R1, #0X0000          ;Parte alta
		STR  R1, [R0]	          ;Guarda el valor nuevo en la RAM (GPIOMODER)
		LDR  R11, = GPIOE_ODR     ; Carga en R11 el ODR para GPIOB
	
	
LOOP

		MOV  R0, #0x00000001      ;Encendido de LED PB0
		STR  R0,[R10]             ;Estado se  envia a ODR - GPIOB (RAM)
		MOV  R3, #500            ; Delay  de 0.5 (s)
		BL   DELAY_MS
		
		
		MOV  R0, #0x00000003      ;Encendido de PB0 y PE1
		STR  R0,[R10]             ;Estado  se envia a ODR - GPIOB (RAM)
		STR  R0,[R11]             ;Estado  se envia a ODR - GPIOE (RAM)
		MOV  R3, #500 			  ; Delay  de 0.5 (s)
        BL   DELAY_MS
		
		MOV  R0, #0x00004003      ;Encendido de PB0, PE1 y PB14
		STR  R0,[R10]             ;Estado  se envia a ODR - GPIOB (RAM)
		STR  R0,[R11]             ;Estado  se envia a ODR - GPIOE (RAM)
		MOV  R3, #500            ; Delay  de 0.5 (s)
		BL   DELAY_MS             ;Salto a DELAY_MS
		
		;======================================================
		
		MOV  R0, #0x00004002      ;Apagado de PB0 - Encendido de PB14 y PE1
		STR  R0,[R10]             ;Estado se  envia a ODR (RAM)- GPIOB (RAM)
		MOV  R3, #500            ; Delay  de 0.5 (s)
		BL   DELAY_MS
		
		
		MOV  R0, #0x00004000      ;Encendido de PB0 y PE1
		STR  R0,[R10]             ;Estado  se envia a ODR (RAM)- GPIOB (RAM)
		STR  R0,[R11]             ;Estado  se envia a ODR (RAM)- GPIOE (RAM)
		MOV  R3, #500 			  ; Delay  de 0.5 (s)
        BL   DELAY_MS
		
		
		MOV  R0, #0x00000000      ;Apagado de todos los leds
		STR  R0,[R10]             ;Estado  se envia a ODR (RAM) - GPIOB (RAM)
		STR  R0,[R11]             ;Estado  se envia a ODR (RAM) - GPIOE (RAM)
		MOV  R3, #500            ; Delay  de 0.5 (s)
		BL   DELAY_MS             ;Salto a DELAY_MS
		
		B    LOOP                 ;Salto - Loop infinito



;Funcion de retardo- delay en ms 
DELAY_MS
DELAY_02	MOV R4, #0x3E80

DELAY_01	SUB R4, #0x01
			CMP R4, #0x00
			BNE DELAY_01
			SUB R3, #0x01
			CMP R3, #0x00
			BNE DELAY_02
			BX  LR
			
			ALIGN
			END
						
				

				
				