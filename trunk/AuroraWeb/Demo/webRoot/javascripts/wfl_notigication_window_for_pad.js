
/*
** Author : Jonllen
** Create : 2010-05-08
** SVN    : 152
** WebSite: http://www.jonllen.com/
*/




var TreeMenu = function (settings){
    for( p in this.settings) {
        if( !settings.hasOwnProperty(p) ) settings[p] = this.settings[p];
    }
    this.settings = settings;
}

TreeMenu.prototype = {
    visitPathList : new Array(),  //访问路径
    cmpUnitList : new Array(),	//公司部门
    empList : new Array(),	//所有员工
    selectList : new Array(),//已选择的员工
    
    settings : {
        indent : 20,
        container : null,
        recursion : false,
        checkbox : true,
        name : 'ids',
        expendAll : false,
        renderCallback : null
    },
    item : {
        id : null,
        parentId : 0,
        html : '',
        title : '',
        css : 'left-list',
        user_id: null,
        img : null,
        click : null,
        createExpand : true,
        expand : false,
        checked : false,
        disabled : false,
        children : null,
        isLastChild : false,
        unit : '',
        compay : '',
        user_name : ''
    },
    pushCmpUnit : function (item) {
        var list = Object.prototype.toString.apply(item) === '[object Array]' ? item : [item];
        for( var i=0; i< list.length; i++) {
            var  _item = list[i];
            for( p in this.item) {
                if( !_item.hasOwnProperty(p) ) _item[p] = this.item[p];
            }
            this.cmpUnitList.push(_item);
        }
    },
    pushEmp : function (item) {
        var list = Object.prototype.toString.apply(item) === '[object Array]' ? item : [item];
        for( var i=0; i< list.length; i++) {
            var  _item = list[i];
            for( p in this.item) {
                if( !_item.hasOwnProperty(p) ) _item[p] = this.item[p];
            }
            this.empList.push(_item);
        }
    },
    render : function (container, parentid){
        var _this = this;
        
        var container = container || this.settings.container;
        
        while( container.lastChild) {
            container.removeChild( container.lastChild);
        }
        var parent = parentid?parentid:0;
        //在当前container有三种方式追加方式:1 当前级下面为员工；2 当前级下面没有员工或是部门；3 当前级下面还有下一级   
        var children = this.getChlid(parent);
        if(children.length==0){
        	if(this.haveEmployee(parentid)){
        		//1 当前级下面为员工；
        		for( var i=0; i<this.empList.length; i++) {
                    var item = this.empList[i];
                    //加
                    item.index = i;
                    if( item.parentId != parent) continue;
                    
                    var itemElem = document.createElement('div');
                    itemElem.className = item.css;
                    itemElem.title = item.title;    
                    //checkbox
                    if(this.settings.checkbox){
                    	itemElem.innerHTML = '<div></div>';
                        var inputElem = itemElem.childNodes[0];
                        if(item.checked){
                        	inputElem.className = 'checkbox-s';
                        }else{
                        	inputElem.className = 'checkbox';
                        } 	                
                    }                
                    var spanElem = document.createElement('span');
                    spanElem.innerHTML = item.html;
                    itemElem.appendChild(spanElem);
                    
                    item.itemElem = itemElem;      
                    itemElem.treemenu = item;
                    
                    container.appendChild(itemElem);
                }
        	}else{
        		//2 当前级下面没有员工或部门
        		var itemElem = document.createElement('div');  
                
                var spanElem = document.createElement('span');
                spanElem.innerHTML = '<div style="float:left;margin-top:20px;height:50px;line-height:50px;width:300px;font-size:16px;font-weight:bold;float:left;"><img style="border:none;height:50px;width:50px;padding-left:20px;float:left" src="../../../images/for_pad/alert.gif"/>&nbsp;&nbsp;此部门下无员工</div>';
                itemElem.appendChild(spanElem);
                
                container.appendChild(itemElem);
        	}
        }else{
        	//3 当前级下面还有下一级 
        	for( var i=0; i<this.cmpUnitList.length; i++) {
                var item = this.cmpUnitList[i];
                //加
                if( item.parentId != parent) continue;
                
                var itemElem = document.createElement('div');
                itemElem.className = item.css;
                itemElem.title = item.title;    
                
                var spanElem = document.createElement('span');
                spanElem.innerHTML = item.html;
                spanElem.style.paddingLeft='10px';
                itemElem.appendChild(spanElem);
                
                var divElem = document.createElement('div');
                divElem.className = 'notlast';
                itemElem.appendChild(divElem);
                
                item.itemElem = itemElem;      
                itemElem.treemenu = item;
                container.appendChild(itemElem);
                
            }
        }
        this.settings.renderCallback();
        container.onclick = this.onClick;
        container._this = this;
    },
    onClick :function (e) {
        e = e || window.event;
        var target = e.target || e.srcElement;
        
        var _this = this._this;
        var treemenu = target.treemenu || target.parentNode.treemenu || target.parentNode.parentNode.treemenu;
        
        if(!treemenu){
        	return;
        }
        		
        //当前为最后一级员工，不需要render，点击之后加入到右边的输入框当中：要做的事情：1加入到右边的框中；2 把user_id加入到wfl_user_select Dataset中
        if(treemenu.isLastChild){
        	var innerHTML = treemenu.html+'-'+treemenu.unit+'-'+treemenu.compay;
        	var user_id = treemenu.user_id;
        	treemenu.checked = !treemenu.checked;
        	treemenu.checked?_this.selectList.push(treemenu.index):_this.selectList.splice(_this._find(_this.selectList,treemenu.index),1);
        	if(target.childNodes.length>1){
        		if(treemenu.checked){
        			target.childNodes[0].className = "checkbox-s";
        		}else{
        			target.childNodes[0].className = "checkbox";
        		}
        	}else{
        		if(treemenu.checked){
        			target.parentNode.childNodes[0].className = "checkbox-s";
        		}else{
        			target.parentNode.childNodes[0].className = "checkbox";
        		}
        	}
        	addNotityPeople(innerHTML, user_id)
        	return;
        }
        
        //保存路径
        _this.visitPathList.push(treemenu);
        //切换div
        /*_this.settings.container.style.cssText = "display:none;";
        var string = _this.settings.container.id.split('_');
        var nextContainerId = string[0] + '_' + (string[1]-0+1)%2;
        _this.settings.container = document.getElementById(nextContainerId);
        _this.settings.container.style.cssText = "display:block;";*/
        //在div里加入元素
       _this.render(_this.settings.container, treemenu.id);
    },
    expandAll : function () {    
    	/*this.settings.container.style.cssText = "display:none;";
        var string = this.settings.container.id.split('_');
        var nextContainerId = string[0] + '_' + (string[1]-0+1)%2;
        this.settings.container = document.getElementById(nextContainerId);
        this.settings.container.style.cssText = "display:block;";*/
        
        var container = this.settings.container;
        while( container.lastChild) {
            container.removeChild( container.lastChild);
        }
        
    	for( var i=0; i<this.empList.length; i++) {
            var item = this.empList[i];
            
            item.index = i;
            var itemElem = document.createElement('div');
            if(this.settings.checkbox){
            	itemElem.innerHTML = '<div></div>';
                var inputElem = itemElem.childNodes[0];
                if(item.checked){
                	inputElem.className = 'checkbox-s';
                }else{
                	inputElem.className = 'checkbox';
                } 	                
            }
            itemElem.className = item.css;
            itemElem.title = item.title;    
            
            var spanElem = document.createElement('span');
            spanElem.innerHTML = item.html;
            itemElem.appendChild(spanElem);
            
            item.itemElem = itemElem;      
            itemElem.treemenu = item;
            
            container.appendChild(itemElem);
        }
    	this.settings.renderCallback();
    	container.onclick = this.onClick;
        container._this = this;
    },
    getChlid : function (id) {
        var list = new Array();
        for( var i=0;i < this.cmpUnitList.length; i++)
        {
            var item = this.cmpUnitList[i];
            if( item.parentId == id)
            {
                list.push(item);
            }
        }
        return list;
    },
    haveEmployee : function (id) {
        for( var i=0;i < this.empList.length; i++)
        {
            var item = this.empList[i];
            if( item.parentId == id)
            {
                return true
            }
        }
        return false;
    },
    remove : function (item, list){
        list = list || this.list;
        for( var i=0;i < list.length; i++)
        {
            if( list[i].id == item.id)
            {
                list[i].itemElem.parentNode.removeChild(list[i].itemElem);
                list.splice(i,1);
                if( item.parent ) {
                    for ( var j=0; j<item.parent.children.length; j++) {
                        if( item.parent.children[j].id == item.id) {
                            item.parent.children.splice(j,1);
                            break;
                        }
                    }
                    item.parent.expand = false;
                    this.renderChild(item.parent);
                }
                return list;
            }
        }
        return list;
    },
    refresh : function(){
		if(this.settings.expendAll){
			this.expandAll();
		}else{
			var parentId = 0;
			if(this.visitPathList.length!=0){
				parentId = this.visitPathList[this.visitPathList.length-1].id;
			}
			this.render(null,parentId);
		}
    },
    reset : function(){
    	var length = this.selectList.length;
    	for(var i=0; i<length; i++){
    		this.empList[this.selectList[i]].checked  = false;
    	}
    	this.refresh();
    },
    _find : function(array, name){
    	if(array.length == null) return;
    	var length = array.length;
    	for(var i=0; i<length; i++){
    		if(array[i]==name)
    			return i;
    	}
    }
}

