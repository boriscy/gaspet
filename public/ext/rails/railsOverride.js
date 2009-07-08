/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
// Filtros
Ext.override(Ext.grid.GridFilters, {
    filtersText: 'Filtros'
});
Ext.override(Ext.menu.RangeMenu, {

   icons: {
		gt: '/ext/resources/extraimg/greater_then.png',
		lt: '/ext/resources/extraimg/less_then.png',
		eq: '/ext/resources/extraimg/equals.png'
    }
});

Ext.override(Ext.grid.filter.BooleanFilter, {
    yesText: 'Si'
});

Ext.override(Ext.grid.filter.DateFilter, {
    
    dateFormat: 'Y-m-d',
    beforeText: 'Antes',
    afterText: 'Despues',
    onText: 'En'
});

Ext.override(Ext.PagingToolbar,{
    //new config, set text to display before the page size edit.
    beforePageSizeText: 'Mostrar',

    //new config, set text to display after the page size edit.
    afterPageSizeText:'registro(s)',

    //new config, set tooltip text for the show all button.
    // showAllText:'Mostrar todos los registros en una páginaShow all records on a single page',

    //new public method, set the page size
    setPageSize:function(size){
        size = !size ? 1 : eval(size);//deal with string/null/undefined input
        if(typeof size == 'number')
        {
            if(size < 1)
                size = 1;
            this.sizefield.dom.value = size;//in case we blur whilst sizefield.dom.value is null or zero
            if(size != this.pageSize)
            {
                this.pageSize = size;
                this.doLoad(0);
            }
        }
        else
            throw new SyntaxError('Invalid type for size parameter');
    },

    //new public method, set the current page
    setPage:function(page){
        page = !page ? 1 : eval(page);//deal with string/null/undefined input
        if(typeof page == 'number')
        {
            if(page < 1)
                page = 1;
            var p = (page-1) * this.pageSize;
            this.field.dom.value = p;//in case we blur whilst field.dom.value is null or zero
            var curpage = Math.ceil((this.cursor+this.pageSize)/this.pageSize);
            if(page != curpage)
                this.doLoad(p);
        }
        else
            throw new SyntaxError('Invalid type for page parameter');
    },

    //new public method, retrieve the total number of pages
    getPageTotalCount:function(){
        var t = this.store.getTotalCount();
        return t < this.pageSize ? 1 : Math.ceil(t / this.pageSize);
    },

    //new public method, get the current page number
    getCurrentPage:function(){
        return Math.ceil((this.cursor+this.pageSize)/this.pageSize);
    },

    //override private method
    onRender:function(ct, position){
        Ext.PagingToolbar.superclass.onRender.call(this, ct, position);
        this.first = this.addButton({
            tooltip: this.firstText,
            iconCls: "x-tbar-page-first",
            disabled: true,
            handler: this.onClick.createDelegate(this, ["first"])
        });
        this.prev = this.addButton({
            tooltip: this.prevText,
            iconCls: "x-tbar-page-prev",
            disabled: true,
            handler: this.onClick.createDelegate(this, ["prev"])
        });
        this.addSeparator();
        this.add(this.beforePageText);
        this.field = Ext.get(this.addDom({
           tag: "input",
           type: "text",
           size: "3",
           value: "1",
           cls: "x-tbar-page-number"
        }).el);
        this.field.on("keydown", this.onPagingKeydown, this);
        this.field.on("blur", this.onPagingBlur,this);
        this.field.on("focus", function(){this.dom.select();});
        this.afterTextEl = this.addText(String.format(this.afterPageText, 1));
        this.field.setHeight(18);
        this.addSeparator();
        this.next = this.addButton({
            tooltip: this.nextText,
            iconCls: "x-tbar-page-next",
            disabled: true,
            handler: this.onClick.createDelegate(this, ["next"])
        });
        this.last = this.addButton({
            tooltip: this.lastText,
            iconCls: "x-tbar-page-last",
            disabled: true,
            handler: this.onClick.createDelegate(this, ["last"])
        });
        this.addSeparator();
        this.loading = this.addButton({
            tooltip: this.refreshText,
            iconCls: "x-tbar-loading",
            handler: this.onClick.createDelegate(this, ["refresh"])
        });
        this.addSeparator();
        this.addText(this.beforePageSizeText);
        this.sizefield = Ext.get(this.addDom({
            tag: "input",
            type: "text",
            size: "3",
            value: this.pageSize,
            cls: "x-tbar-page-size"
        }).el);
        this.sizefield.on("keydown", this.onPageSizeKeydown,this);
        this.sizefield.on("blur", this.onPageSizeBlur,this);
        this.sizefield.on("focus", function(){this.dom.select();});
        this.sizefield.setHeight(18);
        this.addText(this.afterPageSizeText);
        /*this.showall = this.addButton({
            tooltip: this.showAllText,
            iconCls: "x-tbar-page-showall",
            disabled: true,
            handler: this.onClick.createDelegate(this,["showall"])
        });*/
        this.addSeparator();

        if(this.displayInfo){
            this.displayEl = Ext.fly(this.el.dom).createChild({cls:'x-paging-info'});
        }
        if(this.dsLoaded){
            this.onLoad.apply(this, this.dsLoaded);
        }
    },

    //override private method
    onLoad:function(store, r, o){
        if(!this.rendered){
            this.dsLoaded = [store, r, o];
            return;
        }
       this.cursor = o.params ? o.params[this.paramNames.start] : 0;
       var d = this.getPageData(), ap = d.activePage, ps = d.pages;

       this.afterTextEl.el.innerHTML = String.format(this.afterPageText, d.pages);
       this.field.dom.value = ap;
       this.first.setDisabled(ap == 1);
       this.prev.setDisabled(ap == 1);
       this.next.setDisabled(ap == ps);
       this.last.setDisabled(ap == ps);
       this.showall.setDisabled(ps == 1);
       this.loading.enable();
       this.updateInfo();
    },

    //new private method
    onAdd : function(store, t, idx){
        //TODO
    },

    //new private method
    onRemove: function(store,t,idx) {
        //TODO
    },

    //override private method
    onPagingKeydown:function(e){
        var k = e.getKey(), d = this.getPageData(), pageNum;
        if (k == e.RETURN) {
            e.stopEvent();
            if(pageNum = this.readPage(d)){
                pageNum = Math.min(Math.max(1, pageNum), d.pages) - 1;
                this.doLoad(pageNum * this.pageSize);
            }
        }else if (k == e.HOME || k == e.END){
            e.stopEvent();
            pageNum = k == e.HOME ? 1 : d.pages;
            this.field.dom.value = pageNum;
        }else if (k == e.UP || k == e.PAGEUP || k == e.DOWN || k == e.PAGEDOWN){
            e.stopEvent();
            if(pageNum = this.readPage(d)){
                var increment = e.shiftKey ? 10 : 1;
                if(k == e.DOWN || k == e.PAGEDOWN){
                    increment *= -1;
                }
                pageNum += increment;
                if(pageNum >= 1 & pageNum <= d.pages){
                    this.field.dom.value = pageNum;
                }
            }
        }else if(!(k == e.TAB || k == e.BACKSPACE || k == e.DELETE || (k > 47 && k < 58)))
            e.stopEvent();
    },

    //new private method
    onPagingBlur:function(e)
    {
        this.setPage(this.field.dom.value);
    },

    //new private method
    onPageSizeKeydown:function(e)
    {
        var k = e.getKey();
        if(k == e.RETURN)
        {
            this.setPageSize(this.sizefield.dom.value);
        }
        else if(!(k == e.TAB || k == e.BACKSPACE || k == e.DELETE || (k > 47 && k < 58)))
            e.stopEvent();
    },

    //new private method
    onPageSizeBlur:function(e)
    {
        this.setPageSize(this.sizefield.dom.value);
    },

    //override private method
    onClick:function(which){
        var store = this.store;
        switch(which){
            case "first":
                this.doLoad(0);
            break;
            case "prev":
                this.doLoad(Math.max(0, this.cursor-this.pageSize));
            break;
            case "next":
                this.doLoad(this.cursor+this.pageSize);
            break;
            case "last":
                var total = store.getTotalCount();
                var extra = total % this.pageSize;
                var lastStart = extra ? (total - extra) : total-this.pageSize;
                this.doLoad(lastStart);
            break;
            case "refresh":
                this.doLoad(this.cursor);
            break;
            case "showall":
                this.setPageSize(this.store.getTotalCount());
            break;
        }
    },

    //override private method
    unbind : function(store){
        store = Ext.StoreMgr.lookup(store);
        store.un("beforeload", this.beforeLoad, this);
        store.un("load", this.onLoad, this);
        store.un("loadexception", this.onLoadError, this);
        store.un("add", this.onAdd, this);
        store.un("remove", this.onRemove, this);
        this.store = undefined;
    },

    //override private method
    bind : function(store){
        store = Ext.StoreMgr.lookup(store);
        store.on("beforeload", this.beforeLoad, this);
        store.on("load", this.onLoad, this);
        store.on("loadexception", this.onLoadError, this);
        store.on("add", this.onAdd, this);
        store.on("remove", this.onRemove, this);
        this.store = store;
    }
});

