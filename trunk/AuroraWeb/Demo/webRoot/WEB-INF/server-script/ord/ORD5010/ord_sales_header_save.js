var header = $ctx.parameter.getChildren()[0];
if (header) {
	var lines = (header.getChild('lines') || new CompositeMap()).getChildren();
	// if (lines.length == 0)
	// raise_app_error('没有订单行，不能保存。');
	var head_bm = $bm('ord.ORD5010.ord_sales_order_headers');
	// 校验订单编号是否重复
	var p = $ctx.createChild('tmp_param');
	p.order_number = header.order_number;
	var res = head_bm.queryAsMap(p);
	if (res.getChildren().length > 0)
		raise_app_error('订单编号重复，请重新输入。');
	header.company_id = $ctx.session.company_id;
	head_bm[header._status](header);
	var line_bm = $bm('ord.ORD5010.ord_sales_order_lines');
	for (i = 0; i < lines.length; i++) {
		var ln = lines[i];
		ln.sales_order_id = header.sales_order_id;
		ln.company_id = $ctx.session.company_id;
		line_bm[ln._status](ln);
	}
}