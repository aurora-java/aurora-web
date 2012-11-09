var SalesOrder = {
	getHeadBm : function(){
		return $bm('ord.ORD5010.ord_sales_order_headers');
	},
	getLineBm : function(){
		return $bm('ord.ORD5010.ord_sales_order_lines');
	},
	deleteOrders : function(header_arr) {
		var del_head_bm = $bm('ord.ORD5010.ord_sales_order_lines_delete');
		var h_bm = SalesOrder.getHeadBm();
		for(i=0;i<header_arr.length;i++){
			var h=header_arr[i];
			h_bm.delete(h);// delete is a js Key Word
			del_head_bm.execute(h);
		}
		
	},
	canModify : function(p){
		var res = $bm('ord.ORD5010.ord_sales_order_modify_status_check').queryAsMap(p);
		return res.getChildren()[0].count==0;
	},
	closeOrder : function(p,onlyHeaders) {
		$bm('ord.ORD5010.ord_sales_order_headers_close').execute(p);
		if(!onlyHeaders)
        $bm('ord.ORD5010.ord_sales_order_lines_close').execute(p);
	},
	openOrder : function(p){
		$bm('ord.ORD5010.ord_sales_order_headers_open').execute(p);
	},
	orderNumberCheck : function(order_number,company_id){
		var bm=$bm('ord.ORD5010.ord_sales_order_number_check');
		var para = new CompositeMap();
		para.order_number=order_number;
		para.company_id=company_id;
		var res = bm.queryAsMap(para);
		return res.getChildren()[0].exists;
	},
	insertOrder : function(h) {
		if (!h) return;
		var arr = h.getChild('lines').getChildren();
		if (arr.length == 0)
			raise_app_error('没有订单行，不能保存。');
		try{
			SalesOrder.getHeadBm().insert(h);
		}catch(e){
			raise_app_error('订单编号重复，请重新输入。');
		}
		var mul = h.return_order_flag == 'Y' ? -1 : 1;
		var l_bm = SalesOrder.getLineBm();
		for (i = 0; i < arr.length; i++) {
			arr[i].sales_order_id = h.sales_order_id;
			arr[i].trade_quantity = mul * Math.abs(arr[i].trade_quantity);
			arr[i].total_amount = mul * Math.abs(arr[i].total_amount);
			l_bm.insert(arr[i]);
		}
	},
	updateOrder : function(h) {
		if (!h) return;
		SalesOrder.getHeadBm().update(h);
		var arr = h.getChild('lines').getChildren();
		var mul = h.return_order_flag == 'Y' ? -1 : 1;
		var l_bm = SalesOrder.getLineBm();
		for (i = 0; i < arr.length; i++) {
			arr[i].sales_order_id = h.sales_order_id;
			arr[i].trade_quantity = mul * Math.abs(arr[i].trade_quantity);
			arr[i].total_amount = mul * Math.abs(arr[i].total_amount);
			arr[i].company_id=arr[i].company_id||h.company_id;
			l_bm[arr[i]._status](arr[i]);// arr[i]._status may be insert,delete,update
		}
	},
	closeLine:function(p){
		$bm('ord.ORD5010.ord_sales_order_lines_close').execute(p);
	},
	openLine:function (p){
		$bm('ord.ORD5010.ord_sales_order_lines_open').execute(p);
	},
	isAllLinesClosed:function(p){
		 var head_op_bm = $bm('ord.ORD5010.ord_sales_order_headers_close');
         res = head_op_bm.queryAsMap(p);
         var arr = res.getChildren();
         return arr.length==0;
	}
};