class Familia{
	
	var ninios = #{};
	
	method addNinio(unNinio){
		ninios.add(unNinio);
	}
	
	method infaltables(){
		return ninios.map({ninio => ninio.prendas().max({ropa => ropa.calidad(ninio)})}).asSet();			   
	}
	
	method chiquitos(){
		return ninios.filter({ninio => ninio.edad() < 4});
	}
	
	method pasear(){
		ninios.forEach({ninio => ninio.prendas().forEach({ropa => ropa.usar()})});
	}
	method puedePasear(){
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
	var property desgaste = 0;
	var abrigo = 0;
	
	method nivelAbrigo(){
		return abrigo;
	}
	method nivelComodidad(unNinio){
		return if ( unNinio.talle() == talle ) + 8 - self.descontarDesgaste()
			  else -self.descontarDesgaste();
	}
	
	method descontarDesgaste(){
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
			
		}	
	}
	
}

class RopaLiviana inherits Prenda{
			
	constructor(){
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