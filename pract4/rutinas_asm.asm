/*-----------------------------------------------------------------
**
**  Fichero:
**    rutinas_asm.asm  10/6/2014
**
**    Fundamentos de Computadores
**    Dpto. de Arquitectura de Computadores y Automática
**    Facultad de Informática. Universidad Complutense de Madrid
**
**
**
**  Notas de diseño:
**
**---------------------------------------------------------------*/

.global contarUnos
.extern sumarUnos

.text

contarUnos:
push {r4-r10, fp, lr}
		add fp, sp, #40 		@ 40 = 4*11-4
		mov r4, r0				@ R4, direccion de inicio matriz
		mov r5, r1				@ R5, direccion de inicio de vector
		mov r6, r2				@ R6, numero de filas
		mov r7, r3				@ R7, numero de columnas
		mov r0, #0				@ R0, i
		mov r1, #0				@ R1, j
		mov r2, #0
		mul r2, r6, r7

for_filas:
		cmp r0, r6					@ Comparar i con filas
		bge fin						@ Cuando acabe salta a fin
		ldr r8, [r5, r0, lsl #2]	@ Mueve v[i] a registro
		mov r8, #0					@ Mueve un 0 a v[i]

for_cols:
		cmp r1,r7					@ Compara j con columnas
		bge add_i					@ Cuando acabe salta a sumar uno a i
		mla r3, r7, r0, r1			@ Posicion de acceso a matriz, columnas * i + j
		ldr r9, [r4, r3, lsl #2]	@ Cargar en r9 posicion de matriz
		cmp r9, #1					@ Comprar posicion matriz con 1
		beq add_v					@ Si se cumple salta a add_v
ret_add_v:
    add r1, r1, #1 @ Suma uno a la j
    b for_cols

add_v:
		add r8, r8, #1			@ Sumar uno a la posicion v[i]
		b ret_add_v				@ Vuelve a posicion inicial

add_i:
		str r8, [r5, r0, lsl #2]	@ Guarda en memoria v[i]
		mov r1, #0					@ Pone a 0 j
		add r0, r0, #1				@ Suma uno a i
		b for_filas					@ Vuelve al for_filas

fin:
		mov r0, r5				@ Mover a r0 inicio vector
		mov r1, r7				@ Tamaño del vector a r1
		bl sumarUnos			@ Salto a subrutina
		pop {r4-r10, fp, lr}
		mov pc, lr
