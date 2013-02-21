//--put employee id and name into session
var sys_user_bm = $bm('sys.sys_user');
var users = sys_user_bm.queryAsMap($ctx.session);
var arr = users.getChildren();
$ctx.session.employee_id = arr[0].employee_id;
$ctx.session.employee_name = arr[0].emp_name;
//--get sys_parameter
var config = $config();
var nf1=CompositeUtil.findChild(config,'numberField','id','e_nf_float1');
var nf2=CompositeUtil.findChild(config,'numberField','id','e_nf_float2');
var sys_param_bm=$bm('sys.sys_parameter_company');
var p=new CompositeMap();
p.level_value=$ctx.session.company_id;
var params=sys_param_bm.queryAsMap(p);
arr=params.getChildren();
for(i=0;i<arr.length;i++){
	if(arr[i].parameter_code=='BUSINESS_ACCURACY'){
		$ctx.put('/sys_parameter/@BUSINESS_ACCURACY',arr[i].parameter_value);
		nf2.put('decimalPrecision',arr[i].parameter_value);
	}else if(arr[i].parameter_code=='QUANTITY_ACCURACY'){
		$ctx.put('/sys_parameter/@QUANTITY_ACCURACY',arr[i].parameter_value);
		nf1.put('decimalPrecision',arr[i].parameter_value);
	}else if(arr[i].parameter_code=='TAX_RATE'){
		$ctx.put('/sys_parameter/@TAX_RATE',arr[i].parameter_value);
	}
}
