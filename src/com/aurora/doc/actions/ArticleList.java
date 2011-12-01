package com.aurora.doc.actions;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import aurora.database.FetchDescriptor;
import aurora.database.service.BusinessModelService;
import aurora.database.service.DatabaseServiceFactory;
import aurora.service.ServiceThreadLocal;
import uncertain.composite.CompositeMap;
import uncertain.ocm.IObjectRegistry;

public class ArticleList {
	private static final String DOC_CATEGORY_BM = "doc.doc_category";
	private static final int parent_id = -1;

	public static CompositeMap createList(IObjectRegistry registry,
			CompositeMap parameter) throws Exception {
		CompositeMap context = ServiceThreadLocal.getCurrentThreadContext();
		DatabaseServiceFactory factory = (DatabaseServiceFactory) registry
				.getInstanceOfType(DatabaseServiceFactory.class);
		BusinessModelService service = factory.getModelService(DOC_CATEGORY_BM,
				context);
		CompositeMap result = new CompositeMap();
		Map map = new HashMap();
		map.put("parent_id", parent_id);
		CompositeMap father = service.queryAsMap(map);
		Iterator itm = father.getChildIterator();
		try {
			if(itm!=null)
			while (itm.hasNext()) {
				CompositeMap record = new CompositeMap("record");
				CompositeMap fa = (CompositeMap) itm.next();
				record.putString("category_name", fa.getString("category_name"));
				Map para = new HashMap();
				para.put("parent_id", fa.getInt("category_id"));
				CompositeMap children = service.queryAsMap(para);
				record.put("children", children);
				result.addChild(record);
			}
		} catch (Exception e) {
			throw new aurora.presentation.ViewCreationException(e.getMessage());
		}		
		return result;
	}
}
