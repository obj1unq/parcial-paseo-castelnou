//Nota: 5. El polimorfismo está bien logrado. 
//Pero la falta de delegación es un problema serio. y además no lanza errores cuando debe
//por ese motivo es preferible que pase por una instancia más de evaluación (integrador). 


//tests: Uno falla por funcionalidad. No está bien resuelto el tema de los chequeos (no poder intercambiar pares ni salir de paseo)
//1) MB
//2) Regular- Debe lanzar el error
//3) B: Mal resuelto para la ropa liviana, ya que no se puede facilmente cambiar el valor para todas 
//4) B+: Tiene problemas de delegación. 
//5) M: No logra resolver lo del juguete, en parte por el problema de delegación del punto 4.
//6) B-: Preocupa la falta de delegación de la solución 
//7) B: duplicacion de codigo si es pequenio, porque no delega en el ninio
//8) R+: No lanza error y falla la delegación

class Familia{
	
	var ninios = #{};
	
	method addNinio(unNinio){
		ninios.add(unNinio);
	}
	
	method infaltables(){
		//TODO: Delegar!! pedir al ninio que resuelva cual es la ropa de maxima calidad
		return ninios.map({ninio => ninio.prendas().max({ropa => ropa.calidad(ninio)})}).asSet();			   
	}
	
	method chiquitos(){
		//TODO: Delegar: preguntarle al ninio si es pequenio
		return ninios.filter({ninio => ninio.edad() < 4});
	}
	
	method pasear(){
		//TODO: Delegar al ninio que salga a pasear
		ninios.forEach({ninio => ninio.prendas().forEach({ropa => ropa.usar()})});
	}
	method puedePasear(){
		//TODO: Chequear que se pueda si no lanzar error
		//TODO: delegar una única pregunta al nene! nene.puedeSalir()
		return ninios.all({nene => nene.cantidadPrendasParaSalir() == nene.cantidadPrendas() 
							and nene.esPrendaSuperior()
							and nene.promedioCalidad(nene) > 8
		});
	}
	
}

class Ninio{
	
	var property talle;
	var property edad;
	var prendas = #{};
	
	method prendas(){
		return prendas;
	}
	
	method cantidadPrendasParaSalir(){
		return 5;
	}
	method cantidadPrendas(){
		return prendas.size();
	}
	
	method esPrendaSuperior(){
		return prendas.any({ropa => ropa.nivelAbrigo() >= 3});
	}
	
	method promedioCalidad(nene){
		return  prendas.sum({ropa => ropa.calidad(nene)}) / self.cantidadPrendas();
	}
}

class Problematico inherits Ninio{
	
	var property juguete;

	override method cantidadPrendasParaSalir(){
		return 4;
	}
	
}

class Prenda{
	
	var property talle;
	var property desgaste = 0; //No todas las prendas necesitan esta variable
	var abrigo = 0; //No todas las prendas necesitan esta variable. Mover a la subclase que corresponde
	
	method nivelAbrigo(){
		return abrigo;
	}
	method nivelComodidad(unNinio){
		//Quedó un poquito duplicado el descuento de desgaste, ya que está en las dos ramas del if
		return if ( unNinio.talle() == talle ) + 8 - self.descontarDesgaste()
			  else -self.descontarDesgaste();
	}
	
	method descontarDesgaste(){
		//TODO: más sencillo: self.nivelDesgaste().min(3)
		return if(self.nivelDesgaste() < 3) self.nivelDesgaste()
			   else 3;
	}
	
	method nivelDesgaste(){
		return desgaste;
	}
	method calidad(unNinio){
		return self.nivelAbrigo() + self.nivelComodidad(unNinio);
	}
	method desgastar(unDesgaste){
		desgaste = desgaste + unDesgaste;
	}	
	method usar(){
	  desgaste = desgaste + 1; 	
	}		
	
}
class PrendaInd{ 
	var property desgaste = 0;
	var property abrigo = 1;	
	
	method desgastar(unDesgaste){
		desgaste = desgaste + unDesgaste;
	}
	method nivelDesgaste(){
		return desgaste;
	}	
}
class PrendaPar inherits Prenda{
	
	var property prendaIzq;
	var property prendaDer;
	
	method setPrendaIzq(unaPrenda){
		prendaIzq = unaPrenda;
	}
	method setPrendaDer(unaPrenda){
		prendaDer = unaPrenda;
	}	
	override method nivelComodidad(unNinio){
		return if( unNinio.edad() < 4 ) super(unNinio) - 1
				else super(unNinio);
	}
	override method nivelAbrigo(){
		return prendaIzq.abrigo() + prendaDer.abrigo();
	}
	
	override method nivelDesgaste(){
		return ( prendaIzq.desgaste() + prendaDer.desgaste() ) / 2
	}
	
	override method usar(){
	  prendaIzq.desgastar(0.8);
	  prendaDer.desgastar(1.2);  	
	}
	
	method intercambiar(prendaPar){
		var aux;
		if (self.talle() == prendaPar.talle()){
			aux = self.prendaDer();
			self.setPrendaDer(prendaPar.prendaDer());
			prendaPar.setPrendaDer(aux);
		}else{
	//TODO: muy importante lanzar el error si no se puede hacer!		
		}	
	}
	
}

class RopaLiviana inherits Prenda{

			
	constructor(){
		//TODO NO, en este caso hay que delegar el en un objeto que mantenga el valor para todas las instancias
		abrigo = 1;
	}
			
	override method nivelComodidad(unNinio){
		return super(unNinio) + 2;
	}
	
}
class RopaPesada inherits Prenda{
	
	constructor(){
		abrigo = 3;
	}
	
}

//Objetos usados para los talles
object xs {
}

object s {
}
object m {
	
}
object l{
	
}
object xl{
	
}
class Juguete{
	var property min;
	var property max;
	
}