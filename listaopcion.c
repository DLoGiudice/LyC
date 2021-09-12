
int main(int argc,char *argv[])
{ 
  FILE *archTabla = fopen("ts.txt","w");
  fprintf(archTabla,"%s\n","NOMBRE\t\t\tTIPODATO\t\tVALOR");
  fclose(archTabla);

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }
	 

int insertarEnTS(char nombreToken[],char tipoToken[],char valorString[],int valorInteger, double valorFloat){
  
  FILE *tablaSimbolos = fopen("ts.txt","r");
  char simboloNuevo[200];
  int repetido = 0;
  int i = 0;
  
  char tab[6] = "\t\t\t"; 	
  char *finCadena;

  int j;
  int cantidadACiclar;

  char valor[20];
  char valorCte[20];
  char lineaComparada[20];
  char linea[200];
  
  //Si el tipo de símbolo no es ID
  if(strcmp(tipoToken,"ID") != 0){
    //Chequea si el tipo de simbolo es entero
    if(strcmp(tipoToken,"CTE_ENTERA") == 0){
      sprintf(valor,"%d",valorInteger);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);


      cantidadACiclar = (strlen(valor)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }


      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,valor);
      //strcat(simboloNuevo,"\t\t\t");
      strcat(simboloNuevo,tab);
      strcat(simboloNuevo,"Ent");
      strcat(simboloNuevo,"\t\t\t");
      strcat(simboloNuevo,valor);
    }

    //Chequea si es real
    if(strcmp(tipoToken,"CTE_REAL") == 0){
      sprintf(valor,"%.3f",valorFloat);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);


      cantidadACiclar = (strlen(valor)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }

      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,valor);
      strcat(simboloNuevo,tab);
      strcat(simboloNuevo,"Real");
      strcat(simboloNuevo,"\t\t\t");
      strcat(simboloNuevo,valor);
    }

    //Chequea si es string
    if(strcmp(tipoToken,"CTE_STRING") == 0){
      sprintf(valor,"%s",nombreToken);
      strcpy(valorCte,"_");
      strcat(valorCte,valor);


	  cantidadACiclar = (strlen(valor)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }


      strcpy(simboloNuevo,"_");
      strcat(simboloNuevo,nombreToken);
      //strcat(simboloNuevo,"\t\t");
      strcat(simboloNuevo,tab);
      strcat(simboloNuevo,"String");
      strcat(simboloNuevo,"\t\t\t");
      //strcat(simboloNuevo,tab);
      strcat(simboloNuevo,valorString);


    }
  }else{


      cantidadACiclar = (strlen(nombreToken)-1)/8;

      for(j=0; j<cantidadACiclar; j++){
      	finCadena = strrchr(tab,'\t');
	  	*finCadena = '\0';
      }

    strcpy(simboloNuevo,nombreToken);
    strcat(simboloNuevo,tab);
    strcat(simboloNuevo,tipoToken);
    strcat(simboloNuevo,"\t\t\t");
    strcat(simboloNuevo,valorString);
  }

  //Vuelve a posición 0
  rewind(tablaSimbolos);

  char *pos;
//Compara linea a linea si hay repetidos
  do {
	  pos = fgets(linea,200,tablaSimbolos);
	  strcpy(lineaComparada,simboloNuevo);
	  strcat(lineaComparada,"\n");
	  if(strcmp(lineaComparada,linea) == 0){
		  repetido = 1;
	  }
	  i++;
  }while(pos != NULL && repetido == 0);

  fclose(tablaSimbolos);

//Si no es un símbolo repetido, lo graba
  tablaSimbolos = fopen("ts.txt","a");
  if(repetido == 0){
    fprintf(tablaSimbolos,"%s\n",simboloNuevo);
  }

  fclose(tablaSimbolos);
}