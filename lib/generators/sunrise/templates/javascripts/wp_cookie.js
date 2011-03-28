/*
	This note must stay intact.
	
	Author:
		Mattias Rundqvist, Webparts (www.webparts.se)
	License:
		Creative Commons Attribution-Share Alike 3.0 License
		http://creativecommons.org/licenses/by-sa/3.0/
*/

function wp_Cookie( mcfg ) {
	
	var cookie = new Array();
	var cookie_cache = "";
	
	mcfg = mcfg?mcfg:{};
	
	var cfg = {
		expires : mcfg["expires"]?mcfg["expires"]:"",
		expires_unit : mcfg["expires_unit"]?mcfg["expires_unit"]:"minutes",
		path : mcfg["path"]?mcfg["path"]:"/",
		use_local_path : (mcfg["use_local_path"]==true)?true:false,
		domain : mcfg["domain"]?mcfg["domain"]:"",
		secure : (mcfg["secure"]==true)?true:false
	};
	
	if( cfg["use_local_path"] == true )
		cfg["path"] = "";
	
	function calcExpires( expires ) {
	
		if( expires ) {
			var expires_units = {
				years : (365*24*60*60*1000),
				months : (30*24*60*60*1000),
				weeks : (7*24*60*60*1000),
				days : (24*60*60*1000),
				hours : (60*60*1000),
				minutes : (60*1000),
				seconds : (1000)
			};
					
			var now = new Date();
			expires = expires * expires_units[cfg["expires_unit"]];
			expires = new Date( now.getTime() + expires );
		}
		return expires;
	}
	
	function cache() {
	
		// -- Har document.cookie ändrats?
		if( cookie_cache == document.cookie )
			return false;
		
		// -- Töm befintlig information...
		cookie = new Array();
		
		// -- ...och cache'a om...
		cookie_cache = document.cookie;
		var pairs = cookie_cache.split("; ");
		var name="",value="";
		
		for( count = 0; count < pairs.length; count++ ) {
			name = unescape(pairs[count].split("=")[0]);
			if( pairs[count].indexOf("=") != -1 )
				value = unescape(pairs[count].split("=")[1]);
			if( name ) {
				cookie[name] = value;
			}
		}
		return true;
	}
	
	this.length = function() {
		cache();
		var tmp = this.cookies();
		return tmp?tmp.length:0;
	}
	
	this.get = function( name ) {
		cache();
		var value = null;
		if( typeof name != "undefined" ) {
			// -- returnera kakans värde
			if( typeof cookie[name] != "undefined" )
				value = cookie[name];
		}
		return value;
	}
	
	this.cookies = function() {
		cache();
		var value = null;
		// -- returnera namn på alla kakor
		for( name in cookie ) {
		
			if( !value ) {
				value = new Array();
			}
		
			// -- Av någon anledning returneras även prototypes i for-in satser...?
			if( typeof value[name] != "function" )
				value[value.length]=name;
		}
		
		return value;
	}
	
	this.set = function( name, value ) {
	
		// expires, path, domain, secure
		var expires = calcExpires( (typeof arguments[2]!="undefined")?arguments[2]:cfg["expires"] );
		var path = (typeof arguments[3]!="undefined")?arguments[3]:cfg["path"];
		var domain = (typeof arguments[4]!="undefined")?arguments[4]:cfg["domain"];
		var secure = (typeof arguments[5]!="undefined")?arguments[5]:cfg["secure"];
		
		var str_cookie = name + "=" +escape( value ) +
		( ( expires ) ? ";expires=" + expires.toGMTString() : "" ) + 
		( ( path ) ? ";path=" + path : "" ) + 
		( ( domain ) ? ";domain=" + domain : "" ) +
		( ( secure ) ? ";secure" : "" );
		
		document.cookie = str_cookie;
		
		return true;
	}
	
	this.remove = function( name ) {
		
		if( typeof name == "undefined" ) {
			name = "";
		}
		
		this.set(name,"",-1);
		
		cache();
	}
	
	this.clear = function() {
	
		cache();
		names = this.cookies();
	
		for( count = 0; count < names.length; count++ ) {
			this.set(names[count],"",-1);
		}
		cache();
	
	}
	
	this.test = function() {
		
		if( typeof document.cookie == "undefined" )
			return false;
			
		this.set("test_cookie_name","test_cookie_value");
		
		if( this.get("test_cookie_name")!="test_cookie_value" )
			return false;
			
		this.remove("test_cookie_name");
		
		return true;
	}
	
}