var PurOrder = {
	getHeadBm : function(){
		return $bm('pur.PUR5010.pur_purchase_order_headers');
	},
	getLineBm : function(){
		return $bm('pur.PUR5010.pur_purchase_order_lines');
	},
	deleteOrders : function(header_arr) {
		var del_head_bm = $bm('pur.PUR5010.pur_purchase_order_lines_delete');
		var h_bm = PurOrder.getHeadBm();
		for(i=0;i<header_arr.length;i++){
			var h=header_arr[i];
			h_bm.delete(h);// delete is a js Key Word
			del_head_bm.execute(h);
		}
		
	},
	orderNumberCheck : function(order_number,company_id){
		var bm=$bm('pur.PUR5010.pur_purchase_order_number_check');
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
			PurOrder.getHeadBm().insert(h);
		}catch(e){
			raise_app_error('订单编号重复，请重新输入。');
		}
		var l_bm = PurOrder.getLineBm();
		for (i = 0; i < arr.length; i++) {
			arr[i].purchase_order_header_id = h.purchase_order_header_id;
			println(l_bm.insert);
			l_bm.insert(arr[i]);
		}
	},
	updateOrder : function(h) {
		if (!h) return;
		PurOrder.getHeadBm().update(h);
		var arr = h.getChild('lines').getChildren();
		var mul = h.return_order_flag == 'Y' ? -1 : 1;
		var l_bm = PurOrder.getLineBm();
		for (i = 0; i < arr.length; i++) {
			arr[i].purchase_order_header_id = h.purchase_order_header_id;
			l_bm[arr[i]._status](arr[i]);// arr[i]._status may be insert,delete,update
		}
	}
};