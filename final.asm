include macros2.asm
include number.asm

.MODEL SMALL
.386
.STACK 200h

.DATA

_contador	dd	?
_acumulador	dd	?
_prediccion	dd	?
_cant_iteracion	dd	?
_longitud	dd	?
_mensaje_final	db	?
_0	dd	0.0
_cadena_0	db	"Inicio Programa",'$', 15 dup (?)
_cadena_1	db	"Ins cant itera(Max: 5)",'$', 22 dup (?)
_5	dd	5.0
_1	dd	1.0
_cadena_2	db	"Inserte prediccion",'$', 18 dup (?)
_10	dd	10.0
_cadena_3	db	"Acertaste",'$', 9 dup (?)
_cadena_4	db	"No Acertaste",'$', 12 dup (?)
_20	dd	20.0
@master	dd	?
_15	dd	15.0
@equ_aux	dd	?
@max	dd	?
@min	dd	?
_cadena_5	db	"True EQUMIN",'$', 11 dup (?)
_cadena_6	db	"False EQUMIN",'$', 12 dup (?)
_cadena_7	db	"Inserte long de arr",'$', 19 dup (?)
_100	dd	100.0
_110	dd	110.0
_3	dd	3.0
_cadena_8	db	"Acertaste Longitud",'$', 18 dup (?)
_cadena_9	db	"Algun mensaje Final?",'$', 20 dup (?)
@aux0	dd	?
@aux1	dd	?
@aux2	dd	?
@aux3	dd	?
@aux4	dd	?
@aux5	dd	?
@aux6	dd	?
@aux7	dd	?
@aux8	dd	?
@aux9	dd	?
@aux10	dd	?
@aux11	dd	?
@aux12	dd	?
@aux13	dd	?
@aux14	dd	?
@aux15	dd	?
@aux16	dd	?
@aux17	dd	?
@aux18	dd	?
@aux19	dd	?
@aux20	dd	?
@aux21	dd	?
@aux22	dd	?
@aux23	dd	?
@aux24	dd	?
@aux25	dd	?
@aux26	dd	?
@aux27	dd	?
@aux28	dd	?
@aux29	dd	?
@aux30	dd	?
@aux31	dd	?
@aux32	dd	?
@aux33	dd	?
@aux34	dd	?
@aux35	dd	?
@aux36	dd	?
@aux37	dd	?
@aux38	dd	?

.CODE
mov	AX,@DATA
mov	DS,AX
mov	es,ax	;

FLD	_0
FSTP	@aux0
FLD	@aux0
FSTP	_contador
FFREE
DisplayString	_cadena_0
newline	1
DisplayString	_cadena_1
newline	1
getFloat	_cant_iteracion
newline	1

ETIQ_10:
FLD	_contador
FSTP	@aux1
FLD	_cant_iteracion
FSTP	@aux2
FLD	@aux1
FCOMP	@aux2
FSTSW AX
SAHF
JAE	ETIQ_30
FFREE
FLD	_contador
FSTP	@aux3
FLD	_5
FSTP	@aux4
FLD	@aux3
FCOMP	@aux4
FSTSW AX
SAHF
JAE	ETIQ_30
FFREE
FLD	_contador
FSTP	@aux5
FLD	_1
FSTP	@aux6
FLD	@aux5
FLD	@aux6
FADD
FSTP	@aux7
FLD	@aux7
FSTP	_contador
FFREE
Displayfloat	_contador,2
newline	1
JMP	ETIQ_10

ETIQ_30:
DisplayString	_cadena_2
newline	1
getFloat	_prediccion
newline	1
FLD	_prediccion
FSTP	@aux8
FLD	_10
FSTP	@aux9
FLD	@aux8
FCOMP	@aux9
FSTSW AX
SAHF
JNE	ETIQ_43
FFREE
DisplayString	_cadena_3
newline	1
JMP	ETIQ_41

ETIQ_43:
DisplayString	_cadena_4
newline	1

ETIQ_41:
FLD	_20
FSTP	@aux10
FLD	@aux10
FSTP	@master
FFREE
FLD	_20
FSTP	@aux11
FLD	@aux11
FSTP	@max
FFREE
FLD	_15
FSTP	@aux12
FLD	@aux12
FSTP	@equ_aux
FFREE
FLD	@equ_aux
FSTP	@aux13
FLD	@max
FSTP	@aux14
FLD	@aux13
FCOMP	@aux14
FSTSW AX
SAHF
JNA	ETIQ_62
FFREE
FLD	@equ_aux
FSTP	@aux15
FLD	@aux15
FSTP	@max
FFREE

ETIQ_62:
FLD	_10
FSTP	@aux16
FLD	@aux16
FSTP	@equ_aux
FFREE
FLD	@equ_aux
FSTP	@aux17
FLD	@max
FSTP	@aux18
FLD	@aux17
FCOMP	@aux18
FSTSW AX
SAHF
JNA	ETIQ_73
FFREE
FLD	@equ_aux
FSTP	@aux19
FLD	@aux19
FSTP	@max
FFREE

ETIQ_73:
FLD	@master
FSTP	@aux20
FLD	@max
FSTP	@aux21
FLD	@aux20
FCOMP	@aux21
FSTSW AX
SAHF
JNE	ETIQ_80
FFREE
Displayfloat	_prediccion,2
newline	1

ETIQ_80:
FLD	_10
FSTP	@aux22
FLD	@aux22
FSTP	@master
FFREE
FLD	_20
FSTP	@aux23
FLD	@aux23
FSTP	@min
FFREE
FLD	_10
FSTP	@aux24
FLD	@aux24
FSTP	@equ_aux
FFREE
FLD	@equ_aux
FSTP	@aux25
FLD	@min
FSTP	@aux26
FLD	@aux25
FCOMP	@aux26
FSTSW AX
SAHF
JAE	ETIQ_97
FFREE
FLD	@equ_aux
FSTP	@aux27
FLD	@aux27
FSTP	@min
FFREE

ETIQ_97:
FLD	_5
FSTP	@aux28
FLD	@aux28
FSTP	@equ_aux
FFREE
FLD	@equ_aux
FSTP	@aux29
FLD	@min
FSTP	@aux30
FLD	@aux29
FCOMP	@aux30
FSTSW AX
SAHF
JAE	ETIQ_108
FFREE
FLD	@equ_aux
FSTP	@aux31
FLD	@aux31
FSTP	@min
FFREE

ETIQ_108:
FLD	@master
FSTP	@aux32
FLD	@min
FSTP	@aux33
FLD	@aux32
FCOMP	@aux33
FSTSW AX
SAHF
JNE	ETIQ_117
FFREE
DisplayString	_cadena_5
newline	1
JMP	ETIQ_115

ETIQ_117:
DisplayString	_cadena_6
newline	1

ETIQ_115:
DisplayString	_cadena_7
newline	1
getFloat	_longitud
newline	1
FLD	_100
FSTP	@aux34
FLD	_110
FSTP	@aux35
FLD	_prediccion
FSTP	@aux36
FLD	_3
FSTP	@aux37
FLD	_longitud
FSTP	@aux38
FLD	@aux37
FCOMP	@aux38
FSTSW AX
SAHF
JNE	ETIQ_133
FFREE
DisplayString	_cadena_8
newline	1

ETIQ_133:
DisplayString	_cadena_9
newline	1
getString	_mensaje_final
newline	1
DisplayString	_mensaje_final
newline	1

mov	ah, 1 ; pausa, espera que oprima una tecla
int	21h ; AH=1 es el servicio de lectura
mov	ax,4c00h ; Sale del Dos
int	21h ; Enviamos la interripcion 21h

End

