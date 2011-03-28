/* ******************************************
 *	FileProgress Object
 *	Control object for displaying file info
 * ****************************************** */

function FileProgress(file, targetID) {
	this.fileProgressID = "divFileProgress";

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	if (!this.fileProgressWrapper) {
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "progress-container";
		this.fileProgressWrapper.id = this.fileProgressID;
		
		var progressStatus = document.createElement("div");
		progressStatus.className = "status-message";
		progressStatus.innerHTML = "&nbsp;";
		
		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "progress-bar";
		
		var progressBar = document.createElement("div");
		progressBar.className = "progress";

		this.fileProgressElement.appendChild(progressBar);
    
    this.fileProgressWrapper.appendChild(progressStatus);
		this.fileProgressWrapper.appendChild(this.fileProgressElement);
    
		document.getElementById(targetID).appendChild(this.fileProgressWrapper);

	} else {
		this.fileProgressElement = this.fileProgressWrapper.childNodes[1];
		//this.fileProgressElement.childNodes[1].firstChild.nodeValue = file.name;
	}

	this.height = this.fileProgressWrapper.offsetHeight;
}
FileProgress.prototype.setProgress = function(percentage) {
	var value = parseInt((400 * percentage / 100));	
	this.fileProgressElement.childNodes[0].style.width = value + "px";
};
FileProgress.prototype.setComplete = function() {
	/*this.fileProgressElement.className = "progressContainer blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete";
	this.fileProgressElement.childNodes[3].style.width = "";*/

};
FileProgress.prototype.setError = function() {
	/*this.fileProgressElement.className = "progressContainer red";
	this.fileProgressElement.childNodes[3].className = "progressBarError";
	this.fileProgressElement.childNodes[3].style.width = "";*/

};
FileProgress.prototype.setCancelled = function() {
	/*this.fileProgressElement.className = "progressContainer";
	this.fileProgressElement.childNodes[3].className = "progressBarError";
	this.fileProgressElement.childNodes[3].style.width = "";*/

};
FileProgress.prototype.setStatus = function(status) {
	this.fileProgressWrapper.childNodes[0].innerHTML = status;
};
FileProgress.prototype.parseXML = function(xml){
  var xmlDoc = null;
   
  if (window.ActiveXObject) 
  {
    xmlDoc = Ajax.getTransport();
    xmlDoc.async = false;
    xmlDoc.loadXML(xml);
  }
  else
  {
    var parser = new DOMParser();
  	xmlDoc = parser.parseFromString(xml,"text/xml");  
  }
  
  return xmlDoc;
};
FileProgress.prototype.setThumbnail = function(serverData, collection_id) {
  var xml = this.parseXML(serverData);
  var thumbnail = xml.getElementsByTagName('asset');
  var collection = document.getElementById(collection_id);
  
  thumbnail = (thumbnail[0] == null ? xml : thumbnail[0])
  
  if (thumbnail != null)
  {
    var id_node = thumbnail.getElementsByTagName('id')[0]; 
    var filename_node = thumbnail.getElementsByTagName('filename')[0];
    var styles_node = thumbnail.getElementsByTagName('styles')[0];
    var thumb_node = styles_node ? styles_node.getElementsByTagName('thumb')[0] : thumbnail.getElementsByTagName('thumb')[0];
    
    var id = id_node.childNodes[0].nodeValue;
    var filename = filename_node.childNodes[0].nodeValue;
    var thumb = thumb_node.childNodes[0].nodeValue;
    
    var picture = { id: id, link_path: thumb, image_path: thumb, image_title: filename };

    $("#asset_tmpl").tmpl(picture).appendTo( collection );
  }
};

FileProgress.prototype.toggleCancel = function (show, swfuploadInstance) {
	/*this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
	if (swfuploadInstance) {
		var fileID = this.fileProgressID;
		this.fileProgressElement.childNodes[0].onclick = function () {
			swfuploadInstance.cancelUpload(fileID);
			return false;
		};
	}*/
};
