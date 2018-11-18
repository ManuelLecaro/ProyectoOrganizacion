#include <stdio.h>

// Funcion que imprime el numero num en binario (solo i bits)
void aBinaro(int num, int i) {
    int bit;
    for (i--; i >= 0; i--) {
	    bit = num >> i;		//
	  	if (bit & 1)
	      	printf("1");
	  	else
	     	printf("0");
    }
}

// Estructura que almacena en una region de memoria el numero (32 bits) a convertir,
// especificando el numero de bits por parte
typedef union {
    float num_original;
  	struct {
        unsigned int fraccion : 23;
        unsigned int exponente : 8;
        unsigned int signo : 1;
    } campo;
} floatieee;		// sizeof(floatieee) devuelve 4 (bytes)

// Estructura que almacena en una region de memoria el numero (64 bits) a convertir,
// especificando el numero de bits por parte
typedef union {
    double num_original;
  	struct {
        unsigned int fraccion: 32;
        unsigned : 0;	// marca el inicio de un nuevo registro de 32 bits
        unsigned int fraccion2: 20;	// parte faltante para completar los 52 bits de fraccion
        unsigned int exponente : 11;
        unsigned int signo : 1;
    } campo;
} doubleieee;		// sizeof(doubleieee) devuelve 8 (bytes)

int main() {

   	floatieee f;	// numero de 32 bits a convertir
    printf("Ingrese un numero de punto flotante: ");
	scanf("%f",&f.num_original);

	// impresion del numero por partes
	printf("\nNumero en formato simple: %d ",f.campo.signo);
	aBinaro(f.campo.exponente, 8);
  	printf(" ");
  	aBinaro(f.campo.fraccion, 23);
   	printf("\n");

   	doubleieee d;	// numero de 64 bits a convertir
   	printf("Ingrese de nuevo el numero: ");
	scanf("%lf", &d.num_original);

	// impresion del numero por partes
   	printf("\nNumero en formato doble: %d ",d.campo.signo);
   	aBinaro(d.campo.exponente, 11);
  	printf(" ");
  	aBinaro(d.campo.fraccion2, 20);
  	aBinaro(d.campo.fraccion, 32);
   	printf("\n");

   	return 0;
}