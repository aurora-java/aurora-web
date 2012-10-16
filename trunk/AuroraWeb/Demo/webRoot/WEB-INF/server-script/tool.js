function md5(data){
	return String(Packages.aurora.application.util.MD5Util.md5Hex(data));
}

function des_encrypt(data){
	return String(Packages.aurora.application.util.DesEncrypt.desEncrypt(data));
}

function des_decrypt(data){
	return String(Packages.aurora.application.util.DesEncrypt.desDecrypt(data));
}
