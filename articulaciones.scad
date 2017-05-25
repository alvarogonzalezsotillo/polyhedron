// ESTAS CONSTANTES DEFINEN LA APARIENCIA
// CUANTO MÁS ALTAS, LAS FORMAS SERÁN MAS REDONDEADAS
$fn=60;
$fa=60;
$fs=60;

//
LadoCubo=57/2;
RadioCubo=LadoCubo*0.125;
ArticulacionLargo=LadoCubo*0.12;
ArticulacionRadio=ArticulacionLargo*0.5;
ArticulacionRebaje=1.0;
ArticulacionToleranciaMM=0.1;
ArticulacionSobresaleBola=0.25;



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
     redondeamiento = lado*0.02;
     echo("redondeamiento:",redondeamiento);
     l = lado - 2*redondeamiento;
     lAgujero = l-2*radio;
     lVacio = (lAgujero + l)/2;
     echo("lAgujero:",lAgujero);
     


     translate([lado/2,lado/2,lado/2]){
          difference(){
               
               minkowski(){
                    translate([-l/2,-l/2,-l/2])cube(l);
                    sphere(redondeamiento);
               }
          
               scale(v=[10,1,1]) translate([-lAgujero/2,-lAgujero/2,-lAgujero/2]) cube(lAgujero);
               scale(v=[1,10,1]) translate([-lAgujero/2,-lAgujero/2,-lAgujero/2]) cube(lAgujero);
               scale(v=[1,1,10]) translate([-lAgujero/2,-lAgujero/2,-lAgujero/2]) cube(lAgujero);

               translate([-lVacio/2,-lVacio/2,-lVacio/2]) cube(lVacio);
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

     PegaArticulacionesHembra()
          translate( [lado/2,lado/2,lado/2] )
          rotate([90,0,0])
          rotate([180,0,-90])
          translate( [-lado/2,-lado/2,-lado/2] )
          PegaArticulacionesHembra()
          Cubo(lado);
}

module CuboTipoB(lado=LadoCubo){

     PegaArticulacionesMacho()
          translate( [lado/2,lado/2,lado/2] )
          rotate([-90,0,0])
          rotate([180,0,-90])
          translate( [-lado/2,-lado/2,-lado/2] )
          PegaArticulacionesMacho()
          Cubo(lado);
}


//Cubo();

translate([LadoCubo,LadoCubo,0]) CuboTipoA();

translate([-LadoCubo,-LadoCubo,0]) CuboTipoB();
