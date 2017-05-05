// ESTAS CONSTANTES DEFINEN LA APARIENCIA
// CUANTO MÁS ALTAS, LAS FORMAS SERÁN MAS REDONDEADAS
$fn=60;
$fa=60;
$fs=60;

//
LadoCubo=50;
RadioCubo=LadoCubo*0.05;
ArticulacionLargo=LadoCubo*0.12;
ArticulacionRadio=ArticulacionLargo*0.5;
ArticulacionRebaje=1.0;
ArticulacionToleranciaMM=0.1;
ArticulacionSobresaleBola=0.25;


// INICIALIZA NUMEROS ALEATORIOS
SEED=0;
dummy=rands(0,1000,SEED);
     
// PINTA UN PALO
module Palo(a,b,r){
     redondeamiento = 0.9;

     difference(){
          hull(){
               l = 2*r*redondeamiento;
               s = 2*r - l;
               d = -(l + s)/2 + redondeamiento/2;

               translate(a) minkowski(){
                    translate([d,d,d]) cube(l);
                    sphere(s);
               }
               translate(b) minkowski(){
                    translate([d,d,d]) cube(l);
                    sphere(s);
               }
          }
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
      


module ArticulacionHembra(largo=ArticulacionLargo,ancho=ArticulacionRadio,rebaje=ArticulacionRebaje,tolerancia=ArticulacionToleranciaMM){
     radio=ancho/2;
     translate([0,0,-largo+radio-tolerancia/2]){
          difference(){
               union(){
                    sphere(r=radio);
                    cylinder(h=largo-radio,r1=radio,r2=radio);
               }
     
               translate([0,0,largo-radio-radio*(ArticulacionSobresaleBola-1)+tolerancia*0.9]){
                    sphere(r=radio*rebaje);
               }
          }
     }
}

module ArticulacionMacho(largo=ArticulacionLargo,ancho=ArticulacionRadio,rebaje=ArticulacionRebaje,tolerancia=ArticulacionToleranciaMM){
     radio=ancho/2;
     translate([0,0,largo-radio+tolerancia/2]){
          rotate([180,0,0]){
               union(){
                    union(){
                         sphere(r=radio);
                         cylinder(h=largo-radio,r1=radio,r2=radio);
                    }
     
                    translate([0,0,largo-radio-radio*(1-ArticulacionSobresaleBola)]){
                         sphere(r=radio*rebaje);
                    }
               }
          }
     }
}



module Cubo(lado=LadoCubo,radio=RadioCubo){
     l = lado-radio*2;
     vaciamiento = 2*radio/8;
     traslado = radio - vaciamiento;
     ladoVaciamiento = lado - traslado*2;
     difference(){
          translate( [radio,radio,radio] ){
               union(){
                    Palo([0,0,0],[0,0,l],radio);
                    Palo([0,0,0],[0,l,0],radio);
                    Palo([0,0,0],[l,0,0],radio);

                    Palo([l,l,l],[l,0,l],radio);
                    Palo([l,l,l],[l,l,0],radio);
                    Palo([l,l,l],[0,l,l],radio);

                    Palo([0,0,l],[0,l,l],radio);
                    Palo([0,0,l],[l,0,l],radio);

                    Palo([l,l,0],[0,l,0],radio);
                    Palo([l,l,0],[l,0,0],radio);

                    Palo([l,0,0],[l,0,l],radio);

                    Palo([0,l,0],[0,l,l],radio);
               }
          }
          translate([traslado,traslado,traslado]){
               cube(ladoVaciamiento);
          } 
     }
}




module PegaArticulacionesHembra(lado=LadoCubo,ancho=ArticulacionRadio,largo=ArticulacionLargo,tolerancia=ArticulacionToleranciaMM){
     desplazamiento=[0,0,2*ArticulacionLargo];
     difference(){
          union(){
               children(0);
               translate(desplazamiento){
                    ArticulacionHembra(ancho=ancho);
               }
               translate(-desplazamiento+[0,0,lado]){
                    rotate([180,0,0]){
                         ArticulacionHembra(ancho=ancho);
                    }
               }

          }
          union(){
               translate(desplazamiento){
                    ArticulacionMacho(tolerancia=-tolerancia,ancho=ancho+tolerancia*2,largo=largo+tolerancia*2);
               }
               translate(-desplazamiento+[0,0,lado]){
                    rotate([180,0,0]){
                         ArticulacionMacho(tolerancia=-tolerancia, ancho=ancho+tolerancia*2, largo=largo+tolerancia*2);
                    }
               }
          }
     }
}

module PegaArticulacionesMacho(lado=LadoCubo,ancho=ArticulacionRadio,tolerancia=ArticulacionToleranciaMM,largo=ArticulacionLargo){
     desplazamiento=[0,0,2*ArticulacionLargo];
     union(){
          difference(){
               children(0);
          
               union(){
                    translate(desplazamiento){
                         ArticulacionHembra(tolerancia=-tolerancia,ancho=ancho+tolerancia*2,rebaje=0,largo=largo+tolerancia*2);
                    }
                    translate(-desplazamiento+[0,0,lado]){
                         rotate([180,0,0]){
                              ArticulacionHembra(tolerancia=-tolerancia,ancho=ancho+tolerancia*2,rebaje=0, largo=largo+tolerancia*2);
                         }
                    }
               }
          
          }
          translate(desplazamiento){
               ArticulacionMacho(ancho=ancho);
          }
          translate(-desplazamiento+[0,0,lado]){
               rotate([180,0,0]){
                    ArticulacionMacho(ancho=ancho);
               }
          }

     }
}



module DebugCuboConArticulaciones(lado=LadoCubo){
     intersection(){
          union(){
               color(c=[0.9,0.7,0.5]) PegaArticulacionesHembra() Cubo();
               rotate([0,0,180+(90)*$t]){
                    color(c=[0.5,0.7,0.9]) PegaArticulacionesMacho() Cubo();
               }
          }

          
          rotate([0,0,45]){
               translate([-500,0,-500]){
                    cube(1000,1000,1000);
               }
          }
          
          
     }
}

module DebugArticulacion(){
     intersection(){
          union(){
               ArticulacionMacho();
               ArticulacionHembra();
          }
          translate([-500,0,-500]){
               cube(1000,1000,1000);
          }
     }
}


//DebugArticulacion();
//DebugCuboConArticulaciones();


module CuboTipoA(lado=LadoCubo){

     PegaArticulacionesMacho()
          translate( [lado/2,lado/2,lado/2] )
          rotate([90,0,0])
          rotate([180,0,-90])
          translate( [-lado/2,-lado/2,-lado/2] )
          PegaArticulacionesHembra()
          Cubo();
}


CuboTipoA();
