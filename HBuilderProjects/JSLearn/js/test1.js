

function Parent(name) {
	this.name = name
	this.getName = function() {
		return this.name
	}
}

function Child(school) {
	this.school = school
	this.getSchool = function(){
		return this.school
	}
}

Child.prototype = new Parent("father")

function alerMe(){
	var me = new Child("xihua")
alert(me.name)
}



function add1(a){
	return function(b){
		return function(c){
			return a + b +c
		}
	}
}
