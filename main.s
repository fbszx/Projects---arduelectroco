
;4) Perifericos Exteriores

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
		
		
		;Config de  PB3, PB4, PB5, PB6, PB7, PB8 y PB9 como salidas (Disp - Decenas)
		
		LDR  R0, = GPIOB_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X5540          ;Parte baja
		MOVT R1, #0X0005          ;Parte alta
		STR  R1, [R0]			  ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R9, = GPIOB_ODR
		
		;Config de  PD0, PD1, PD2, PD3, PD4, PD5 y PD6 como salidas (Disp - Unidades)
		
		LDR  R0, = GPIOD_MODER    ;Carga en R0 la direccion de GPIOB_MODER
		MOVW R1, #0X1555          ;Parte baja
		MOVT R1, #0X0000          ;Parte alta
		STR  R1, [R0]			  ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R11, = GPIOD_ODR
		
		;Configuracion de PC13 como entrada (Botón)
		
		LDR  R0, = GPIOC_MODER    ;Carga en R0 la direccion de GPIOA_MODER
		MOVW R1, #0X0000          ;Parte baja
		MOVT R1, #0X0000          ;Parte alta
		STR  R1, [R0]	          ;Guardado el valor nuevo en la RAM (GPIOMODER)
		LDR  R10, = GPIOC_IDR
        
		MOV R12,#0               ;Registro para contador
		MOV R6, #0                ;Registro para reset
		MOV R5, #0				  ;Registro para contador de decenas
		MOV R8, #0               ;Registro para contador de unidades
		
		;LDR  R9, = GPIOB_ODR  - Decenas
		;LDR  R11, = GPIOD_ODR  - Unidades
		;LDR  R10, = GPIOC_IDR  - Boton
		
		
		
;============================ Apagado de Inicio ===================	
	
		LDR R1, [R11]            
		MOV R1, #0X7F             ; Display Unidades OFF 
		STR R1, [R11]
		
		
		LDR R1, [R11]
		MOV R1, #0X3F8            ; Display Decenas OFF
		STR R1, [R9]
		
;==================================================================	

LOOP

		LDR  R2, [R10]           ; Lectura el estado de PC13 desde IDR - GPIOC
        AND  R2, R2, #0x2000     ; Verificar si PC13 está presionado (bit 13)
        CMP  R2, #0x2000
        BEQ  BOTON_PRESIONADO    ; Si está presionado, saltar a la etiqueta BUTTON_PRESSED 
        B    LOOP                ; Si no está presionado, sigue el LOOP


BOTON_PRESIONADO	
		
		MOV  R3,#2000             ; Delay para funcion de debounce y reset
        BL   DELAY_MS
		ADD  R12, R12, #1        ; Incrementar el contador en +1
		CMP  R12,#100            ; Si es igual a 100, salto a RESET
		BEQ  RESET
		
;========= Esto solo se cumple si se mantiene PRESIONADO el botón (RESET) ======================		
		
		MOV  R3,#100             ; Delay para dar tiempo al despresionado del boton (anterior pulso)
        BL   DELAY_MS
		LDR  R2, [R10]            ; Se realiza nuevamente una lectura del estado del botón
		MOV  R6, #0x2000          ; Valor esperado si esta PRESIONADO el botón
		AND  R2, R2, #0x2000      ; Verificacion  
		CMP  R2, R6               ; Comparacion (Si esta MANTENIDO EL PRESIONADO, se resetea)
		BEQ  RESET				 ; De lo contrario (Un unico pulso previo) sigue el ciclo 
		
;================================================================================================		
		
		;Desplazamiento y comparación para separar unidades de decenas
		
		MOV  R8,R12         ; Asignacion de R8 al mismo valor del contador R12
		MOV  R5,#0		    ; Inicializacion de registro de decenas = 0
		
REP		CMP  R8, #10        ; Bucle de comparación y desplazamiento
		BLT  ACTUALIZACION  ; Si R8 es menor a 10, salto a actualizacion (no hay decenas)
		SUBS R8, R8, #10    ; Resta - 10 a registro R8 para eliminar una decena
		ADDS R5, R5, #1     ; Aumento del contador de decenas R5 +1
		B    REP	        ; Salto a REP
		
;===================================================
RESET 
		MOV  R12, #0        ; Reset de contador R12
		B    LOOP
		
;===================================================
ACTUALIZACION

		LDR  R1, [R11]            ; Lectura del estado actual del display de unidades
		BL   DISPLAY_UNIDADES     ; Actualizacion del estado del display de unidades 
		
		
		LDR  R1, [R9]             ; Lectura del estado actual del display de decenas
		BL   DISPLAY_DECENAS      ; Actualizacion del estado del display de decenas
		B    LOOP

;===================================================
DISPLAY_UNIDADES

	LDR  R1, [R11]  ; Lectura del valor actual del GPIO D
    CMP  R8, #0     ;Comparacion de registro R8 (UNIDADES) con los 9 digitos posibles
    BEQ  CERO       ;Si el digito es igual, salto a la etiqueta del numero respectivo en display 7SEGMENTOS
    CMP  R8, #1
    BEQ  UNO
    CMP  R8, #2
    BEQ  DOS
	CMP  R8, #3
    BEQ  TRES
    CMP  R8, #4
    BEQ  CUATRO
    CMP  R8, #5
    BEQ  CINCO
    CMP  R8, #6
    BEQ  SEIS
    CMP  R8, #7
    BEQ  SIETE
    CMP  R8, #8
    BEQ  OCHO
	CMP  R8, #9
    BEQ  NUEVE

;======================================
CERO
    MOV  R1, #0X40            ; Encendido de #0 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR         

UNO
    MOV  R1, #0X79            ; Encendido de #1 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR        

DOS
    MOV  R1, #0X24            ; Encendido de #2 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR 
	
TRES
    MOV  R1, #0X30            ; Encendido de #3 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR        

CUATRO
    MOV  R1, #0X19            ; Encendido de #4 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR        

CINCO
    MOV  R1, #0X12            ; Encendido de #5 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR 

SEIS
    MOV  R1, #0X02            ; Encendido de #6 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR        

SIETE
    MOV  R1, #0X78            ; Encendido de #7 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR        

OCHO
    MOV  R1, #0X00            ; Encendido de #8 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR  

NUEVE
    MOV  R1, #0X10            ; Encendido de #9 en display de unidades  (ANODO COMUN)
    STR  R1, [R11]          
    BX   LR 
	
;===================================================
DISPLAY_DECENAS

    LDR  R1, [R9]         ; Leer el valor actual del GPIO B
  
    CMP  R5, #0           ;Comparacion de registro R5 (DECENAS) con los 9 digitos posibles
    BEQ  CEROd         ;Si el digito es igual, salto a la etiqueta del numero respectivo en display 7SEGMENTOS
    CMP  R5, #1
    BEQ  UNOd
    CMP  R5, #2
    BEQ  DOSd
	CMP  R5, #3
    BEQ  TRESd
    CMP  R5, #4
    BEQ  CUATROd
    CMP  R5, #5
    BEQ  CINCOd
    CMP  R5, #6
    BEQ  SEISd
    CMP  R5, #7
    BEQ  SIETEd
    CMP  R5, #8
    BEQ  OCHOd
	CMP  R5, #9
    BEQ  NUEVEd

;======================================
CEROd
    MOV  R1, #0X200           ; Encendido de #0 en display de DECENAS  (ANODO COMUN)
    STR  R1, [R9]          
    BX   LR         

UNOd
    MOV  R1, #0X3C8           ; Encendido de #1 en display de DECENAS  (ANODO COMUN)
    STR  R1, [R9]          
    BX   LR          

DOSd
    MOV  R1, #0X120           ; Encendido de #2 en display de DECENAS  (ANODO COMUN)        
    STR  R1, [R9]          
    BX   LR 
	
TRESd
    MOV  R1, #0X180           ; Encendido de #3 en display de DECENAS  (ANODO COMUN)          
    STR  R1, [R9]          
    BX   LR          

CUATROd
    MOV  R1, #0XC8           ; Encendido de #4 en display de DECENAS  (ANODO COMUN)         
    STR  R1, [R9]          
    BX   LR          

CINCOd
    MOV  R1, #0X90           ; Encendido de #5 en display de DECENAS  (ANODO COMUN)        
    STR  R1, [R9]          
    BX   LR 

SEISd
    MOV  R1, #0X10           ; Encendido de #6 en display de DECENAS  (ANODO COMUN)          
    STR  R1, [R9]          
    BX   LR          

SIETEd
    MOV  R1, #0X3C0           ; Encendido de #7 en display de DECENAS  (ANODO COMUN)         
    STR  R1, [R9]          
    BX   LR         

OCHOd
    MOV  R1, #0X00           ; Encendido de #8 en display de DECENAS  (ANODO COMUN)        
    STR  R1, [R9]          
    BX   LR  

NUEVEd
    MOV  R1, #0X80           ; Encendido de #9 en display de DECENAS  (ANODO COMUN)        
    STR  R1, [R9]          
    BX   LR  
		
		
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
	