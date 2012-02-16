package com.aurora.doc.actions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import uncertain.composite.CompositeMap;
import uncertain.composite.QualifiedName;
import uncertain.core.UncertainEngine;
import uncertain.exception.BuiltinExceptionFactory;
import uncertain.exception.GeneralException;
import uncertain.ocm.IObjectRegistry;
import uncertain.pkg.PackageManager;
import uncertain.schema.Array;
import uncertain.schema.Attribute;
import uncertain.schema.ComplexType;
import uncertain.schema.Element;
import uncertain.schema.Enumeration;
import uncertain.schema.ISchemaManager;
import uncertain.schema.Restriction;
import uncertain.schema.SimpleType;

import aurora.application.features.cstm.CustomSourceCode;
import aurora.presentation.ViewComponent;
import aurora.presentation.ViewComponentPackage;

public class ComponentList {

	private static final String mDefaultPackage = "aurora.ui.std";
	private static final String CATEGORY_NAME = "category_name";
	private static final String NS = "ns";
	private static final String PKG = "pkg";
	private static Map nameSpaces;

	private static void initMap(IObjectRegistry registry) {
		if (null == registry)
			throw new RuntimeException(
					"paramter error. 'registry' can not be null.");
		UncertainEngine engine = (UncertainEngine) registry
				.getInstanceOfType(UncertainEngine.class);
		if (null == engine)
			throw new GeneralException(
					"uncertain.exception.instance_not_found", new Object[] {
							UncertainEngine.class.getName(), null },
					(Throwable) null, (CompositeMap) null);
		PackageManager mPackageManager = engine.getPackageManager();
		ViewComponentPackage p = (ViewComponentPackage) mPackageManager
				.getPackage(mDefaultPackage);
		List vcs = new ArrayList(p.getAllComponents());
		Collections.sort(vcs, new NameComparator());
		nameSpaces = new HashMap();
		for (int i = 0; i < vcs.size(); i++) {
			ViewComponent vc = (ViewComponent) vcs.get(i);
			CompositeMap vcmap = new CompositeMap();
			vcmap.put("name", vc.getElementName());
			vcmap.put("description", vc.getDescription());
			vcmap.put("classname", capitalize(vc.getElementName()));
			vcmap.put("category_name", vc.getCategory());
			vcmap.put("ns", vc.getNameSpace());
			Map childMap = (HashMap) nameSpaces.get(vc.getNameSpace());
			if (null == childMap) {
				childMap = new HashMap();
				nameSpaces.put(vc.getNameSpace(), childMap);
			}
			List components = (ArrayList) childMap.get(vc.getCategory());
			if (null == components) {
				components = new ArrayList();
				if (null != vc.getCategory())
					childMap.put(vc.getCategory(), components);
			}
			components.add(vcmap);
		}
		Iterator nsIt = nameSpaces.keySet().iterator();
		while (nsIt.hasNext()) {
			String ns = (String) nsIt.next();
			Map cateGoryMap = (HashMap) nameSpaces.get(ns);
			Map resultMap = new TreeMap();
			Object[] unsortKey = cateGoryMap.keySet().toArray();
			Arrays.sort(unsortKey);
			for (int i = 0; i < unsortKey.length; i++) {
				resultMap.put(unsortKey[i], cateGoryMap.get(unsortKey[i]));
			}
			nameSpaces.put(ns, resultMap);
		}
	}

	@SuppressWarnings("unchecked")
	public static CompositeMap getCategoryList(IObjectRegistry registry,
			CompositeMap parameter) throws Exception {
		if (null == nameSpaces) {
			initMap(registry);
		}
		int total = 0;
		Iterator nsIt = nameSpaces.keySet().iterator();
		List parentList = new ArrayList();
		while (nsIt.hasNext()) {
			String ns = (String) nsIt.next();
			if (null != ns && !ns.isEmpty()) {
				CompositeMap parent = new CompositeMap();
				parentList.add(parent);
				parent.putString(PKG, ns);
				Iterator childIt = ((TreeMap) nameSpaces.get(ns)).keySet()
						.iterator();
				List childList = new ArrayList();
				while (childIt.hasNext()) {
					CompositeMap child = new CompositeMap();
					CompositeMap grandchild = new CompositeMap();
					String category = (String) childIt.next();
					if (null != category && null != ns && !category.isEmpty()) {
						child.putString(CATEGORY_NAME, category);
						child.putString(NS, ns);
						grandchild.addChilds((ArrayList) ((TreeMap) nameSpaces
								.get(ns)).get(category));
						total += grandchild.getChilds().size();
						child.put("grandchildren", grandchild);
						childList.add(child);
					}
				}
				CompositeMap children = new CompositeMap();
				children.addChilds(childList);
				parent.put("children", children);
			}
		}

		CompositeMap result = new CompositeMap();
		result.addChilds(parentList);
		result.put("total", new Integer(total));
		return result;
	}

	@SuppressWarnings("unchecked")
	public static CompositeMap initCategory(IObjectRegistry registry)
			throws Exception {
		if (null == nameSpaces) {
			initMap(registry);
		}
		int total = 0;
		Iterator nsIt = nameSpaces.keySet().iterator();
		List parentList = new ArrayList();
		while (nsIt.hasNext()) {
			String ns = (String) nsIt.next();
			if (null != ns && !ns.isEmpty()) {
				Iterator parentIt = ((TreeMap) nameSpaces.get(ns)).keySet()
						.iterator();
				int category_id = 0;
				while (parentIt.hasNext()) {
					CompositeMap parent = new CompositeMap();
					String category = (String) parentIt.next();
					if (null != category && null != ns && !category.isEmpty()) {
						parent.putString(CATEGORY_NAME, category);
						parent.putString(NS, ns);
						parent.putInt("parent_id", -1);
						int parent_id = new Integer(category_id);
						parent.putInt("category_id", parent_id);
						category_id++;
						List childList = (ArrayList) ((TreeMap) nameSpaces
								.get(ns)).get(category);
						Iterator childIt = childList.iterator();
						List chidrenList = new ArrayList();
						while (childIt.hasNext()) {
							CompositeMap record = (CompositeMap) childIt.next();
							CompositeMap child = new CompositeMap();
							child.put(CATEGORY_NAME, record.getString("name"));
							child.put("category", category);
							child.put(NS, ns);
							child.put("parent_id", parent_id);
							child.put("category_id", new Integer(category_id));
							category_id++;
							chidrenList.add(child);
						}
						CompositeMap children = new CompositeMap();
						children.addChilds(chidrenList);
						parent.put("children", children);
						parentList.add(parent);
					}
				}
			}
		}
		CompositeMap result = new CompositeMap();
		result.addChilds(parentList);
		// result.put("total", new Integer(total));
		return result;
	}

	public static CompositeMap getCategory(IObjectRegistry registry,
			CompositeMap parameter) throws Exception {
		CompositeMap father = initCategory(registry);
		Iterator itm = father.getChildIterator();
		List fatherList = (List) father.getChilds();
		List childrenList = null;
		List resultList = new ArrayList();
		int total = 0;
		while (itm.hasNext()) {
			CompositeMap child = (CompositeMap) itm.next();
			CompositeMap children = (CompositeMap) child.get("children");
			childrenList = (List) children.getChilds();
			resultList.addAll(childrenList);
			total += childrenList.size();
		}
		resultList.addAll(fatherList);
		CompositeMap result = new CompositeMap();
		result.addChilds(resultList);
		result.put("total", total);
		return result;
	}

	@SuppressWarnings("unchecked")
	public static CompositeMap getComponentList(IObjectRegistry registry,
			CompositeMap parameter) throws Exception {
		if (null == nameSpaces) {
			initMap(registry);
		}

		String category = parameter.getString("category");
		String nameSpace = parameter.getString("ns");
		CompositeMap result = new CompositeMap();
		if (null != category && null != nameSpace) {
			Map nsMap = (TreeMap) nameSpaces.get(nameSpace);
			if (null != nsMap) {
				result.addChilds((ArrayList) nsMap.get(category));
			}
		}
		return result;
	}

	public static CompositeMap getSchema(IObjectRegistry registry,
			CompositeMap parameter) {
		ISchemaManager schemaManager = (ISchemaManager) registry
				.getInstanceOfType(ISchemaManager.class);
		if (schemaManager == null)
			throw BuiltinExceptionFactory.createInstanceNotFoundException(
					(new CompositeMap()).asLocatable(), ISchemaManager.class,
					CustomSourceCode.class.getCanonicalName());
		String nameSpace = parameter.getString("ns");
		String tagName = parameter.getString("tag_name");
		Element ele = schemaManager.getElement(new QualifiedName(nameSpace,
				tagName));
		CompositeMap result = new CompositeMap("result");
		if (ele == null)
			return result;

		if (null == nameSpaces) {
			initMap(registry);
		}
		String category = parameter.getString("category");
		if (null != category && null != nameSpace && null != tagName) {
			Map nsMap = (TreeMap) nameSpaces.get(nameSpace);
			if (null != nsMap) {
				List cl = (ArrayList) nsMap.get(category);
				if (null != cl) {
					Iterator it = cl.iterator();
					while (it.hasNext()) {
						CompositeMap vcmap = (CompositeMap) it.next();
						if (tagName.equals(vcmap.get("name"))) {
							vcmap.setName("element");
							vcmap.putString("valid", "true");
							result.addChild(vcmap);
						}
					}
				}
			}
		}
		putArrays(ele, schemaManager, nameSpace, result);
		putAttributes(ele, schemaManager, nameSpace, result, false);
		putElements(ele, schemaManager, nameSpace, result);
		return result;
	}

	private static void putElements(ComplexType ele,
			ISchemaManager schemaManager, String nameSpace, CompositeMap result) {
		List elements = ele.getAllElements();
		if (elements != null && !elements.isEmpty()) {
			Iterator it = elements.iterator();
			List elementList = new ArrayList();
			while (it.hasNext()) {
				Object para = it.next();
				if (para instanceof Element) {
					Element element = (Element) para;
					CompositeMap record = new CompositeMap("record");
					record.put("name", element.getLocalName());
					record.put(
							"type",
							splitType(element.getType(), schemaManager,
									nameSpace));
					record.put("document", element.getDocument());
					elementList.add(record);
				}
			}
			CompositeMap elementMap = new CompositeMap();
			elementMap.addChilds(elementList);
			result.put("elements", elementMap);
		}
	}

	private static void putAttributes(ComplexType ele,
			ISchemaManager schemaManager, String nameSpace,
			CompositeMap result, boolean putList) {
		List attributes = ele.getAllAttributes();
		Iterator it = attributes.iterator();
		List attributeList = new ArrayList();
		while (it.hasNext()) {
			Attribute attribute = (Attribute) it.next();
			CompositeMap record = new CompositeMap("record");
			record.put("name", attribute.getLocalName());
			record.put("type",
					splitType(attribute.getType(), schemaManager, nameSpace));
			record.put("document", attribute.getDocument());
			attributeList.add(record);
		}
		if (putList) {
			result.put("attributes", attributeList);
		} else {
			CompositeMap attributeMap = new CompositeMap();
			attributeMap.addChilds(attributeList);
			result.put("attributes", attributeMap);
		}
	}

	private static void putArrays(ComplexType ele,
			ISchemaManager schemaManager, String nameSpace, CompositeMap result) {
		List arrays = ele.getAllArrays();
		if (arrays != null && !arrays.isEmpty()) {
			Iterator it = arrays.iterator();
			List arrayList = new ArrayList();
			while (it.hasNext()) {
				Array array = (Array) it.next();
				CompositeMap record = new CompositeMap("record");
				record.put("name", array.getLocalName());
				String type = splitType(array.getType(), schemaManager,
						nameSpace);
				record.put("type", type);
				record.put("document", array.getDocument());
				ComplexType child = schemaManager
						.getComplexType(new QualifiedName(nameSpace, type));
				putAttributes(child, schemaManager, nameSpace, record, true);
				arrayList.add(record);
			}
			CompositeMap arrayMap = new CompositeMap();
			arrayMap.addChilds(arrayList);
			result.put("arrays", arrayMap);
		}
	}

	private static String splitType(String type, ISchemaManager schemaManager,
			String nameSpace) {
		if (null == type || !type.matches(".*:.*"))
			return "string";
		type = type.split(":")[1];
		SimpleType st = null;
		try {
			st = schemaManager
					.getSimpleType(new QualifiedName(nameSpace, type));
		} catch (IllegalArgumentException e) {
		}
		if (null != st) {
			StringBuffer sb = new StringBuffer();
			Restriction r = st.getRestriction();
			if (null != r) {
				Enumeration[] e = r.getEnumerations();
				for (int i = 0, len = e.length; i < len; i++) {
					sb.append(e[i].getValue());
					if (i != len - 1) {
						sb.append(" | ");
					}
				}
				type = sb.toString();
			}
		}
		return type;
	}

	private static String capitalize(String word) {
		if (null == word || "".equals(word))
			return word;
		StringBuffer sb = new StringBuffer(word);
		sb.replace(0, 1,
				new String(new char[] { Character.toUpperCase(sb.charAt(0)) }));

		return sb.toString();
	}

	private static class NameComparator implements Comparator {
		@Override
		public int compare(Object o1, Object o2) {
			ViewComponent record1 = (ViewComponent) o1;
			ViewComponent record2 = (ViewComponent) o2;
			return record1.getElementName().compareTo(record2.getElementName());
		}
	}
}
