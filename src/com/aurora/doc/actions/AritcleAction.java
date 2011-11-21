package com.aurora.doc.actions;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.FileUtils;

import uncertain.composite.CompositeMap;
import uncertain.ocm.IObjectRegistry;
import aurora.application.sourcecode.SourceCodeUtil;
import aurora.database.FetchDescriptor;
import aurora.database.service.BusinessModelService;
import aurora.database.service.DatabaseServiceFactory;
import aurora.presentation.component.std.IDGenerator;
import aurora.service.ServiceThreadLocal;

public class AritcleAction {
	
	private static final String DOC_ARTICLE_BM = "doc.doc_article";
	private static final String DOC_BASE_HOME = "build";
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	private static TransformerFactory factory;
	private static Templates tempaltes;
	private static boolean inited = false;
	
	
	private static void init(File webHome){
		try {
			factory = TransformerFactory.newInstance();
			tempaltes = factory.newTemplates(new StreamSource(new File(webHome,"WEB-INF/docbook-xsl-1.76.1/html/docbook.xsl")));
			inited = true;
		} catch (Exception e) {
			throw new RuntimeException("init TransformerFactory failed!. " + e);
		}
	}

	
	@SuppressWarnings("unchecked")
	public static CompositeMap postArticle(IObjectRegistry registry,CompositeMap parameter, String content,Integer cid) throws TransformerException, IOException{
		File webHome = SourceCodeUtil.getWebHome(registry);
		File baseHome = new File(webHome, DOC_BASE_HOME);
		if(!inited) init(webHome);
		String datePath = sdf.format(new Date());
		File direct = new File(baseHome,datePath);
		FileUtils.forceMkdir(direct);
		String id = IDGenerator.getInstance().generate();
		String fileName = id + ".html";
		File dest = new File(direct, fileName);
		transformDocBook(dest,content);
		List list = parameter.getChilds();
		if(list !=null && list.size() > 0){
			CompositeMap record = (CompositeMap)list.get(0);
			record.put("article_path", "/"+ DOC_BASE_HOME + "/" + datePath + "/" + fileName);
		}
		CompositeMap result = new CompositeMap();
		result.put("category_id", cid);
		return result;
	}
	
	
	
	public static CompositeMap updateArticle(IObjectRegistry registry,CompositeMap parameter, String content, Integer aid) throws Exception{
		File webHome = SourceCodeUtil.getWebHome(registry);
		if(!inited) init(webHome);
		CompositeMap context = ServiceThreadLocal.getCurrentThreadContext();
		DatabaseServiceFactory factory = (DatabaseServiceFactory) registry.getInstanceOfType(DatabaseServiceFactory.class);
		BusinessModelService service = factory.getModelService(DOC_ARTICLE_BM, context);       
		
		Map map = new HashMap();
        map.put("article_id", aid);
		CompositeMap resultMap = service.queryAsMap(map,FetchDescriptor.fetchAll());
		if (resultMap != null) {
            List list = resultMap.getChilds();
            if (list != null && list.size() > 0){
            	CompositeMap article = (CompositeMap)list.get(0); 
            	String path = article.getString("article_path");
            	File dest = new File(webHome,path);
            	transformDocBook(dest,content);
            }
        }
		CompositeMap result = new CompositeMap();
		return result;
	}
	
	private static void transformDocBook(File dest, String content) throws TransformerException {
		Transformer transformer = tempaltes.newTransformer();
		StringReader sr = new StringReader(content);
		transformer.transform(new StreamSource(sr), new StreamResult(dest));
	}
}
