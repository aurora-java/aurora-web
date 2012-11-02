var SalesOrder = {
	head_bm : $bm('ord.ORD5010.ord_sales_order_headers'),
	line_bm : $bm('ord.ORD5010.ord_sales_order_lines'),
	deleteOrders : function(header_arr) {
		var del_line_bm = $bm('ord.ORD5010.ord_sales_order_lines_delete');
		for(i=0;i<header_arr.length;i++){
			var h=header_arr[i];
			SalesOrder.head_bm.delete(h);// delete is a js Key Word
			del_line_bm.execute(h);
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
	insertOrder : function(h) {
		if (!h)
			return;
		var arr = h.getChild('lines').getChildren();
		if (arr.length == 0)
			raise_app_error('没有订单行，不能保存。');
		// 校验订单编号是否重复
		try{
			SalesOrder.head_bm.insert(h);
		}catch(e){
			raise_app_error('订单编号重复，请重新输入。');
		}
		var mul = h.return_order_flag == 'Y' ? -1 : 1;
		for (i = 0; i < arr.length; i++) {
			arr[i].sales_order_id = h.sales_order_id;
			arr[i].trade_quantity = mul * Math.abs(arr[i].trade_quantity);
			arr[i].total_amount = mul * Math.abs(arr[i].total_amount);
			SalesOrder.line_bm.insert(arr[i]);
		}
	},
	updateOrder : function(h) {
		if (!h)
			return;
		SalesOrder.head_bm.update(h);
		var arr = h.getChild('lines').getChildren();
		var mul = h.return_order_flag == 'Y' ? -1 : 1;
		for (i = 0; i < arr.length; i++) {
			arr[i].sales_order_id = h.sales_order_id;
			arr[i].trade_quantity = mul * Math.abs(arr[i].trade_quantity);
			arr[i].total_amount = mul * Math.abs(arr[i].total_amount);
			SalesOrder.line_bm[arr[i]._status](arr[i]);// arr[i]._status may be
														// insert,delete,update
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
println('define SalesOrder')