#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<time.h>

typedef struct Carta{

  char *representacion;
  char *nombre;
  char *familia;
  int valor;
  int Valor_real;
  struct Carta *siguiente;
  struct Carta *anterior;

}Carta;

Carta *primera = NULL;
Carta *ultima = NULL;
Carta *anterior = NULL;


int Espadas= 0;
int Corazones= 13;
int Diamantes= 26;
int Treboles= 39;
int Lista_baraja[52];

char Familia_espada[20]= "E";
char Familia_corazones[20]="C";
char Familia_Diamantes[20]="D";
char Familia_Treboles[20]="T";

void crearBaraja();
void imprimirBaraja();
void ordenar();
void barajar();


void crearBaraja(){

  int valor = 1;

	int contador;
	contador = 0;
  	while(contador != 52){
			if(valor == 13){
				valor = valor-13;
			}

			Carta *nueva = (Carta*)malloc(sizeof(Carta));

    	if (primera == NULL){
			//inserta valores a nuevo nodo
			nueva->valor = valor;
			nueva->Valor_real= valor + Espadas;
            nueva->familia= Familia_espada;

            primera= nueva;
            ultima= nueva;
            anterior= nueva;

            primera->siguiente= NULL;

            contador++;

    	}else{
			contador ++;
			valor ++;

			if(contador<=52){
				nueva->Valor_real= valor + Treboles;
				nueva->familia = Familia_Treboles;
			}
			if(contador<=39){
				nueva->Valor_real=valor + Diamantes;
				nueva->familia = Familia_Diamantes;
			}
			if(contador<=26){
				nueva->Valor_real= valor + Corazones;
				nueva->familia= Familia_corazones;
			}
			if(contador<=13){
				nueva->Valor_real= valor+ Espadas;
				nueva->familia= Familia_espada;
			}

			nueva->valor= valor;
			ultima ->siguiente = nueva;
			nueva->siguiente = NULL;
			ultima = nueva;
			anterior =  nueva;
        }
	}
}

void imprimirBaraja(){

	Carta *temp=(Carta*)malloc(sizeof(Carta));
	temp = primera;

	while(temp != NULL){

            if (temp->valor + 0 == temp->Valor_real){
                if (temp->valor == 1){
                printf("        ------------\n");
                printf("        |A         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    E     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       A  |\n");
                printf("        ------------\n");

                temp = temp->siguiente;

                }
                if (temp->valor == 13){
                printf("        ------------\n");
                printf("        |K         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    E     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       K  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;


                }

                if (temp->valor == 12){
                printf("        ------------\n");
                printf("        |Q         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    E     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       Q  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;

                }

                if (temp->valor == 11){
                printf("        ------------\n");
                printf("        |J         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    E     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       J  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;

                }
                else{

                printf("        ------------\n");
                printf("        |%i          |\n",temp->valor);
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |    E      |\n");
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |       %i  |\n",temp->valor);
                printf("        ------------\n");

                temp = temp->siguiente;

                }
            }

            if (temp->valor + 26 == temp->Valor_real){
                if (temp->valor == 1){
                printf("        ------------\n");
                printf("        |A         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    D     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       A  |\n");
                printf("        ------------\n");

                temp = temp->siguiente;

                }
                if (temp->valor == 13){
                printf("        ------------\n");
                printf("        |K         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    D     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       K  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;


                }

                if (temp->valor == 12){
                printf("        ------------\n");
                printf("        |Q         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    D     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       Q  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;

                }

                if (temp->valor == 11){
                printf("        ------------\n");
                printf("        |J         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    D     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       J  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;

                }
                else{
                printf("        ------------\n");
                printf("        |%i          |\n",temp->valor);
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |    D      |\n");
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |       %i  |\n",temp->valor);
                printf("        ------------\n");

                  temp = temp->siguiente;
                }
            }
            if (temp->valor + 13 == temp->Valor_real){
                if (temp->valor == 1){
                printf("        ------------\n");
                printf("        |A         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       A  |\n");
                printf("        ------------\n");

                temp = temp->siguiente;

                }
                if (temp->valor == 13){
                printf("        ------------\n");
                printf("        |K         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       K  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;


                }

                if (temp->valor == 12){
                printf("        ------------\n");
                printf("        |Q         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       Q  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;

                }

                if (temp->valor == 11){
                printf("        ------------\n");
                printf("        |J         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       J  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;

                }
                else{

                printf("        ------------\n");printf("        ------------\n");
                printf("        |%i          |\n",temp->valor);
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |    C      |\n");
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |       %i  |\n",temp->valor);
                printf("        ------------\n");printf("        ------------\n");

                temp = temp->siguiente;

                }
            }

            if (temp->valor + 13 == temp->Valor_real){
                if (temp->valor == 1){
                printf("        ------------\n");printf("        ------------\n");
                printf("        |A         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       A  |\n");
                printf("        ------------\n");printf("        ------------\n");

                temp = temp->siguiente;

                }
                if (temp->valor == 13){
                printf("        ------------\n");printf("        ------------\n");
                printf("        |K         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       K  |\n");
                printf("        ------------\n");printf("        ------------\n");

                  temp = temp->siguiente;


                }

                if (temp->valor == 12){
                printf("        ------------\n");printf("        ------------\n");
                printf("        |Q         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       Q  |\n");
                printf("        ------------\n");printf("        ------------\n");

                  temp = temp->siguiente;

                }

                if (temp->valor == 11){
                printf("        ------------\n");printf("        ------------\n");
                printf("        |J         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    C     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       J  |\n");
                printf("        ------------\n");printf("        ------------\n");

                  temp = temp->siguiente;

                }
                else{
                printf("        ------------\n");
                printf("        |%i          |\n",temp->valor);
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |    C      |\n");
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |       %i  |\n",temp->valor);
                printf("        ------------\n");

                temp = temp->siguiente;
                }
            }

            if (temp->valor + 39 == temp->Valor_real){
                if (temp->valor == 1){
                printf("        ------------\n");
                printf("        |A         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    T     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       A  |\n");
                printf("        ------------\n");

                temp = temp->siguiente;

                }
                if (temp->valor == 13){
                printf("        ------------\n");
                printf("        |K         |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |    T     |\n");
                printf("        |          |\n");
                printf("        |          |\n");
                printf("        |       K  |\n");
                printf("        ------------\n");

                  temp = temp->siguiente;


                }

                if (temp->valor == 12){
                  printf("        ------------\n");
                  printf("        |Q         |\n");
                  printf("        |          |\n");
                  printf("        |          |\n");
                  printf("        |    T     |\n");
                  printf("        |          |\n");
                  printf("        |          |\n");
                  printf("        |       Q  |\n");
                  printf("        ------------\n");

                  temp = temp->siguiente;

                }

                if (temp->valor == 11){
                  printf("        ------------\n");
                  printf("        |J         |\n");
                  printf("        |          |\n");
                  printf("        |          |\n");
                  printf("        |    T     |\n");
                  printf("        |          |\n");
                  printf("        |          |\n");
                  printf("        |       J  |\n");
                  printf("        ------------\n");

                  temp = temp->siguiente;

                }
                else{
                printf("        ------------\n");
                printf("        |%i          |\n",temp->valor);
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |    T      |\n");
                printf("        |           |\n");
                printf("        |           |\n");
                printf("        |       %i  |\n",temp->valor);
                printf("        ------------\n");

                temp = temp->siguiente;
                }
            }
  }
}


void mostrar_carta_actual(struct Carta* baraja){
  if(baraja->siguiente != NULL){
    printf("\n %i De %s",baraja->valor, baraja->familia);
  }
}

void mostrar_carta_siguiente(struct Carta* baraja){
    if(baraja->siguiente != NULL){
	    struct Carta* siguiente = baraja->siguiente;
	    printf("\n %i De %s",siguiente->valor, siguiente->familia);
    }
}

void mostrar_carta_anterior(struct Carta* baraja){

	if(baraja->anterior != NULL){
		struct Carta* anterior = baraja->anterior;
		printf("\n   %i De %s",anterior->valor, anterior->familia);
	}
	else{
		printf("La carta actual es la primera de la baraja");
	}

}

int aleatorio(){
    int r;
    srand(time(NULL));
    r= rand()%(52-1+1)+1;

    return r;
}

void barajar(){
   int cont=0;
   Carta *temp=(Carta*)malloc(sizeof(Carta));
   temp= primera;
   while(cont!= 52){
		int i=0;
        int num;
		num= aleatorio();
		while(i<= cont){
			if (num== Lista_baraja[i]){
				num= aleatorio();
				i=0;
				}else{
				i++;
				}
	    }
		Lista_baraja[cont]= num;
		printf("%d", cont);
		cont++;
	}
	cont= cont-cont;

	while(temp->siguiente!=NULL){
		temp->Valor_real= Lista_baraja[cont];
		if(temp->Valor_real<=52){
			temp->valor= temp->Valor_real-39;
		}
		if(temp->Valor_real<=39){
			temp->valor= temp->Valor_real-26;
		}if(temp->Valor_real<=26){
			temp->valor= temp->Valor_real-13;
		}
		if(temp->Valor_real<=13){
			temp->valor= temp->Valor_real;
		}
		temp= temp->siguiente;
		cont++;
	}
	menu();
}


void menu(){
	int opcion;
	int ciclo =1;
	while(ciclo){
		printf("\n---------------------------------------------------------------------");
		printf("\n(1) Mostrar Carta Actual");
		printf("\n(2) Mostrar siguente carta");
		printf("\n(3) Mostrar carta anterior");
		printf("\n(4) Mostrar Toda la baraja");
		printf("\n(5) Ordenar");
		printf("\n(6) Barajar");
		printf("\n(7) Salir");
		printf("\n---------------------------------------------------------------------");
		printf("\n>> Opcion deseada: ");
		scanf("%d",&opcion);
		switch(opcion){
			case 1:
				mostrar_carta_actual(primera);
				break;

			case 2:
				mostrar_carta_siguiente(primera);
				break;
			case 3:
				mostrar_carta_anterior(primera);
				break;

			case 4:
				imprimirBaraja();
				break;
			case 5:

				break;
			case 6:
				barajar();
				break;

			case 7:
				return ;
			default: ciclo = 0;
		}
	}
}

void main(){
	crearBaraja();
	menu();

}
