// ESTAS CONSTANTES DEFINEN LA APARIENCIA
// CUANTO MÁS ALTAS, LAS FORMAS SERÁN MAS REDONDEADAS
$fn=50;
$fa=50;
$fs=50;

//
ArticulacionRebaje=0.75;
ArticulacionToleranciaMM=0.1;
ArticulacionSobresaleBola=0.8;
LadoCubo=100;
RadioCubo=LadoCubo*0.05;


// INICIALIZA NUMEROS ALEATORIOS
SEED=0;
dummy=rands(0,1000,SEED);
     
// PINTA UN PALO
module palo(a,b,r){
     hull(){
          translate(a) sphere(r);
          translate(b) sphere(r);
     }
}

// DISTANCIA ENTRE PUNTOS TRIDIMENSIONALES
function distancia(a,b) = 
     let(
          dx = a[0]-b[0],
          dy = a[1]-b[1],
          dz = a[2]-b[2]
          )
     sqrt(dx*dx + dy*dy + dz*dz);

// EL MÓDULO ES LA LONGITUD DE UN VECTOR
function modulo(vector) = distancia(vector,[0,0,0]);
       
// VECTOR CON LA MISMA DIRECCION, PERO CON UN MÓDULO DADO       
function normaliza( p, radio=1 ) = radio * p / modulo(p);
    

// CREA UN PUNTO TRIDIMENSIONAL ALEATORIO CON COORDENADAS ENTRE -1000 Y 1000
function puntoAleatorio() = rands(-1000,1000,3);


// VER LA WIKIPEDIA
function productoEscalar(v1,v2) =
     suma( [ 
                for(i=[0:len(v1)-1]) v1[i]*v2[i] 
                ] );

// VER LA WIKIPEDIA
function productoVectorial(v1,v2) = 
     [
          v1[1]*v2[2] - v1[2]*v2[1],
          - v1[0]*v2[2] + v1[2]*v2[0],
          v1[0]*v2[1] - v1[1]*v2[0]
          ];

    
// ECUACION DEL PLANO ax+by+cz+d=0
// SI DA 0, ES DEL PLANO
// SI DA >0, ES DE UN LADO DEL PLANO
// SI DA <0, ES DEL OTRO LADO
// SE DEVUELVE [[a,b,c],d] VECTOR NORMAL Y CONSTANTE
function ecuacionDePlanoPorTresPuntos(p1,p2,p3) =
     let(
          puntoEnElPlano = p1,
          vector1 = p2-p1,
          vector2 = p3-p1,
          normal = normaliza(productoVectorial(vector1,vector2)),
          d = -productoEscalar(puntoEnElPlano,normal)
          )
     [normal,d];


// RECIBE EL PLANO [[a,b,c],d] Y SUSTITUYE UN PUNTO
// DARÁ CERO SI EL PUNTO ES DEL PLANO
// DARA >0 O <0 SI ESTÁ EN UN LADO U OTRO DEL PLANO
function sustituyeEcuacionPlano(ecuacion,punto) =
     productoEscalar(ecuacion[0],punto) + ecuacion[1];
    
    
  
// SI UNA LISTA ES [[a,b],[c,d],[e,f]] la deja en [a,b,c,d,e,f]    
// SI UNA LISTA ES [[[a,b],[c,d]],[[e,f],[g,h]]] la deja en [[a,b],[c,d],[e,f],[g,h]]
function aplanaUnNivel(lista) = [
     for( a = lista , b = a ) b
     ];
      
     
// DECIDE SI UN VALOR YA ESTA EN UNA LISTA
function contenidoEnLista(v,lista,indice=0) =
     lista[indice] == v ? 
     true : (
          indice>=len(lista) ?
          false :
          contenidoEnLista(v,lista,indice+1)
          );
     
// AGREAGA UN VALOR A UNA LISTA
function agregarALista(lista,valor) = [
     for(i=[0:len(lista)])
          i < len(lista) ? lista[i] : valor
     ];
      


module ArticulacionMacho(largo,ancho,rebaje=ArticulacionRebaje){
     radio=ancho/2;
     difference(){
          union(){
               sphere(r=radio);
               cylinder(h=largo-radio,r1=radio,r2=radio);
          }
     
          translate([0,0,largo-radio-radio*(ArticulacionSobresaleBola-1)]){
               sphere(r=radio*rebaje);
          }
     }
}

module ArticulacionHembra(largo,ancho,rebaje=ArticulacionRebaje,tolerancia=ArticulacionToleranciaMM){
     radio=ancho/2;
     rotate([180,0,0]){
          union(){
               union(){
                    sphere(r=radio);
                    cylinder(h=largo-radio,r1=radio,r2=radio);
               }
     
          translate([0,0,largo-radio-radio*(1-ArticulacionSobresaleBola)]){
                    sphere(r=radio*rebaje-tolerancia);
               }
          }
     }
}

// PINTA UN PALO
module Palo(a,b,r){
     hull(){
          translate(a) sphere(r);
          translate(b) sphere(r);
     }
}


module Cubo(lado=LadoCubo,radio=RadioCubo){
     union(){
          Palo([0,0,0],[0,0,lado],radio);
     }
}

module DebugArticulacion(){
     intersection(){
          union(){
               ArticulacionMacho(50,10);
               translate([0,0,100]) ArticulacionHembra(50,10);
          }
          translate([-50,0,-50]){
               cube(1000,1000,1000);
          }
     }
}

//DebugArticulacion();

Cubo();
