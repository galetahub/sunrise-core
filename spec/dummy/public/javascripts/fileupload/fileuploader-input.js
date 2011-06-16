// Collection of all instances on page
qq.FileUploader.instances = new Object();

/**
 * Class that creates upload widget with drag-and-drop and file list
 * @inherits qq.FileUploaderBasic
 */
qq.FileUploaderInput = function(o){
    // call parent constructor
    qq.FileUploaderBasic.apply(this, arguments);
    
    // additional options    
    qq.extend(this._options, {
        element: null,
        // if set, will be used instead of qq-upload-list in template
        listElement: null,
        
        template_id: '#fileupload_tmpl',

        // template for one item in file list
        fileTemplate: '<li>' +
                '<span class="fileupload-file"></span>' +
                '<span class="fileupload-spinner"></span>' +
                '<span class="fileupload-size"></span>' +
                '<a class="fileupload-cancel" href="#">Cancel</a>' +
                '<span class="fileupload-failed-text">Failed</span>' +
            '</li>',        
        
        classes: {
            // used to get elements from templates
            button: 'fileupload-button',
            drop: 'fileupload-drop-area',
            dropActive: 'fileupload-drop-area-active',
            list: 'fileupload-list',
            preview: 'fileupload-preview',
                        
            file: 'fileupload-file',
            spinner: 'fileupload-spinner',
            size: 'fileupload-size',
            cancel: 'fileupload-cancel',

            // added to list item when upload completes
            // used in css to hide progress spinner
            success: 'fileupload-success',
            fail: 'fileupload-fail'
        }
    });
    // overwrite options with user supplied    
    qq.extend(this._options, o);       

    this._element = document.getElementById(this._options.element);
    this._element.innerHTML = $(this._options.template_id).tmpl(this._options).html();        
    this._listElement = this._options.listElement || this._find(this._element, 'list');
    
    this._classes = this._options.classes;
        
    this._button = this._createUploadButton(this._find(this._element, 'button'));        
    
    this._bindCancelEvent();
    //this._setupDragDrop();
    
    qq.FileUploader.instances[this._element.id] = this;
};

// inherit from Basic Uploader
qq.extend(qq.FileUploaderInput.prototype, qq.FileUploaderBasic.prototype);

qq.extend(qq.FileUploaderInput.prototype, {
    /**
     * Gets one of the elements listed in this._options.classes
     **/
    _find: function(parent, type){                                
        var element = qq.getByClass(parent, this._options.classes[type])[0];        
        if (!element){
            throw new Error('element not found ' + type);
        }
        
        return element;
    },
    _setupDragDrop: function(){
        var self = this,
            dropArea = this._find(this._element, 'drop');                        

        var dz = new qq.UploadDropZone({
            element: dropArea,
            onEnter: function(e){
                qq.addClass(dropArea, self._classes.dropActive);
                e.stopPropagation();
            },
            onLeave: function(e){
                e.stopPropagation();
            },
            onLeaveNotDescendants: function(e){
                qq.removeClass(dropArea, self._classes.dropActive);  
            },
            onDrop: function(e){
                dropArea.style.display = 'none';
                qq.removeClass(dropArea, self._classes.dropActive);
                self._uploadFileList(e.dataTransfer.files);    
            }
        });
                
        dropArea.style.display = 'none';

        qq.attach(document, 'dragenter', function(e){     
            if (!dz._isValidFileDrag(e)) return; 
            
            dropArea.style.display = 'block';            
        });                 
        qq.attach(document, 'dragleave', function(e){
            if (!dz._isValidFileDrag(e)) return;            
            
            var relatedTarget = document.elementFromPoint(e.clientX, e.clientY);
            // only fire when leaving document out
            if ( ! relatedTarget || relatedTarget.nodeName == "HTML"){               
                dropArea.style.display = 'none';                                            
            }
        });                
    },
    _onSubmit: function(id, fileName){
        qq.FileUploaderBasic.prototype._onSubmit.apply(this, arguments);
        this._addToList(id, fileName);  
    },
    _onProgress: function(id, fileName, loaded, total){
        qq.FileUploaderBasic.prototype._onProgress.apply(this, arguments);

        var item = this._getItemByFileId(id);
        var size = this._find(item, 'size');
        size.style.display = 'inline';
        
        var text; 
        if (loaded != total){
            text = Math.round(loaded / total * 100) + '% from ' + this._formatSize(total);
        } else {                                   
            text = this._formatSize(total);
        }          
        
        qq.setText(size, text);         
    },
    _onComplete: function(id, fileName, result){
        qq.FileUploaderBasic.prototype._onComplete.apply(this, arguments);

        var item = this._getItemByFileId(id);
        var asset = result.asset;
        
        // mark completed
        qq.remove(this._find(item, 'cancel'));
        qq.remove(this._find(item, 'spinner'));
        
        if (asset && asset.id){
            qq.addClass(item, this._classes.success);
            this._updatePreview(result);
        } else {
            qq.addClass(item, this._classes.fail);
        }
    },
    _addToList: function(id, fileName){
        if (this._listElement) {
          var item = qq.toElement(this._options.fileTemplate);                
          item.qqFileId = id;
          
          var fileElement = this._find(item, 'file');        
          qq.setText(fileElement, this._formatFileName(fileName));
          this._find(item, 'size').style.display = 'none';        

          this._listElement.appendChild(item);
        }
    },
    _getItemByFileId: function(id){
        var item = this._listElement.firstChild;        
        
        // there can't be txt nodes in dynamically created list
        // and we can  use nextSibling
        while (item){            
            if (item.qqFileId == id) return item;            
            item = item.nextSibling;
        }          
    },
    /**
     * delegate click event for cancel link 
     **/
    _bindCancelEvent: function(){
        var self = this,
            list = this._listElement;            
        
        if (list) {
          qq.attach(list, 'click', function(e){            
              e = e || window.event;
              var target = e.target || e.srcElement;
              
              if (qq.hasClass(target, self._classes.cancel)){                
                  qq.preventDefault(e);
                 
                  var item = target.parentNode;
                  self._handler.cancel(item.qqFileId);
                  qq.remove(item);
              }
          });
        }
    },
    
    _updatePreview: function(result) {
      var preview = this._find(this._element, 'preview'),
          asset = result.asset || result;
          img = null;
      
      if (preview && asset) {
        img = document.createElement('img');
        img.src = asset.thumb_url;
        img.alt = asset.filename;
        img.setAttribute('data-url', asset.url);
        
        preview.innerHTML = '';
        preview.appendChild(img);
      }
    }
});
