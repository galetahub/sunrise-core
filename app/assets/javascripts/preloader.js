// Ajax Preloader
var Preloader;

if (Preloader == undefined) {
	Preloader = function(dom_id) {
		this.show(dom_id);
	};
}

Preloader.select = function(dom_id) {
  var element_id = (dom_id == null) ? 'preloader' : dom_id;

  if (this.element == null)
  {      
    this.element = document.getElementById(element_id);
  }
};

Preloader.show = function(dom_id) {
  this.select(dom_id);
	if (this.element == null) return;
	    
  this.draw();
};

Preloader.draw = function(){
  if (this.element == null) return;
  
  var client = window.innerHeight || document.documentElement.clientHeight;
  var top = window.pageYOffset || document.body.scrollTop || document.documentElement.scrollTop;
  var prefix = top + (client / 2);
	
	this.element.style.top = prefix + 'px';
	this.element.style.display = '';
};

Preloader.hide = function(dom_id){
  this.select(dom_id);
	if (this.element == null) return;
	
	this.element.style.display = 'none';
	this.element.style.top = '0px';
};

Preloader.is_enable = function(){
  return (document.getElementById('preloader') != null);
};
