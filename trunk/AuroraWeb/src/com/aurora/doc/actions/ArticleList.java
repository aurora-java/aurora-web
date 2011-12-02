package com.aurora.doc.actions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import uncertain.composite.CompositeMap;
import uncertain.ocm.IObjectRegistry;
import aurora.database.service.BusinessModelService;
import aurora.database.service.DatabaseServiceFactory;
import aurora.service.ServiceThreadLocal;

public class ArticleList {
	
	private static final String DOC_CATEGORY = "doc.doc_category";
	private static final String CATEGORY_ID = "category_id";
	private static final String PARENT_ID = "parent_id";
	

	@SuppressWarnings("unchecked")
	public static CompositeMap createList(IObjectRegistry registry,CompositeMap parameter) throws Exception {
		CompositeMap context = ServiceThreadLocal.getCurrentThreadContext();
		DatabaseServiceFactory factory = (DatabaseServiceFactory) registry.getInstanceOfType(DatabaseServiceFactory.class);
		BusinessModelService service = factory.getModelService(DOC_CATEGORY,context);
		
		CompositeMap result = new CompositeMap();
		CompositeMap allList = service.queryAsMap(new HashMap());
		List parentList = new ArrayList();
		List items = allList.getChilds();
		if(items !=null){
			Iterator it = items.iterator();
			while(it.hasNext()){
				CompositeMap record = (CompositeMap)it.next();
				Integer parentId = record.getInt(PARENT_ID);
				if(parentId == -1){
					parentList.add(record);
				}
			}
			ListComparator c = new ListComparator();  
			Collections.sort(parentList,c);
			Iterator pit = parentList.iterator();
			while(pit.hasNext()){
				CompositeMap parent = (CompositeMap)pit.next();
				List childrenList = new ArrayList();
				Integer categoryId = parent.getInt(CATEGORY_ID);
				Iterator cit = items.iterator();
				while(cit.hasNext()){
					CompositeMap child = (CompositeMap)cit.next();
					Integer parentId = child.getInt(PARENT_ID);
					if(parentId.intValue() == categoryId.intValue()){
						childrenList.add(child);
					}
				}
				Collections.sort(childrenList,c);
				CompositeMap children = new CompositeMap();
				children.addChilds(childrenList);
				parent.put("children", children);
			}
			result.addChilds(parentList);
		}		
		return result;
	}
	
}
@SuppressWarnings("unchecked")
class ListComparator implements Comparator {
	private static final String SEQUENCE = "sequence";
	
	public int compare(Object o1, Object o2) {
		CompositeMap record1 = (CompositeMap)o1;
		CompositeMap record2 = (CompositeMap)o2;
		
		return record1.getInt(SEQUENCE, 0) - record2.getInt(SEQUENCE, 0);
	}
	
}