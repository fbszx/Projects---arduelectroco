

;3) Mapeo de una entrada a una salida avanzado

; Edwin Fabian Cubides Pulido (202022491)
; Kevin Jeffrey Ramos (201920227)

RCC_AHB4ENR   EQU  0x58024540  ;Direccion de Registro control reloj RCC ; BASE: 0x58024400 + OFFSET: 0x140
GPIOB_MODER   EQU  0x58020400  ;Direccion del puerto B  0x58020400
GPIOC_MODER   EQU  0x58020800  ;Direccion del puerto C  0x58020800
GPIOB_ODR     EQU  0x58020414  ;Registro de salida de datos ODR GPIOB ; Offset   0x14
GPIOC_IDR     EQU  0x58020810  ;Registro de salida de datos IDR GPIOC ; Offset   0x10

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
		LDR  R11, = GPIOC_IDR     ;Carga de IDR GPIO C en R11
        
		MOV R12, #0               ;Registro para contador
		
LOOP
        LDR  R2, [R11]            ; Lectura del estado de PC13 desde IDR - GPIOC
        AND  R2, R2, #0x2000      ; Verificar si PC13 está presionado (bit 13)
        CMP  R2, #0x2000
        BEQ  BOTON_PRESIONADO     ; Si está presionado, saltar a la etiqueta BOTON_PRESIONADO 
        B    LOOP

BOTON_PRESIONADO
        
		MOV R3,#300                  
        BL   DELAY_MS             ; Delay para funcion debounce - 300mS
		
        ADD  R12, R12, #1         ; Incrementar en +1 del registro contador R12

        
        CMP  R12, #5              ; Verificacion y comparacion de 5 pulsos (# modificable)
        BNE  LOOP                 ; Si es diferente a 5, sigue el LOOP

       
        LDR  R2, [R10]            ; Lectura del estado del LED PB0
        CMP  R2, #0X00000000      ; Comparacion para el estado de LED 
        MOVNE  R2, #0X00000000    ; Si el LED está encendido, apagarlo
        MOVEQ  R2, #0X00000001    ; Si el LED está apagado, encenderlo
        STR  R2, [R10]            ; Actualizacion del estado del LED

        MOV  R12, #0              ; Reinicio del contador R12
        B    LOOP
		
		
;=============Funcion de DELAY ===============================
	
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
				
