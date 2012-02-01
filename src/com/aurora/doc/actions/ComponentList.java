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
import uncertain.schema.Element;
import uncertain.schema.ISchemaManager;

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
			result.addChilds((ArrayList) ((TreeMap) nameSpaces.get(nameSpace))
					.get(category));
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
		List arrays = ele.getAllArrays();
		if (arrays != null && !arrays.isEmpty()) {
			Iterator it = arrays.iterator();
			List arrayList = new ArrayList();
			while (it.hasNext()) {
				Array array = (Array) it.next();
				CompositeMap record = new CompositeMap("record");
				record.put("name", array.getLocalName());
				record.put("type", array.getType());
				record.put("document", array.getDocument());
				arrayList.add(record);
			}
			CompositeMap arrayMap = new CompositeMap();
			arrayMap.addChilds(arrayList);
			result.put("arrays", arrayMap);
		}
		List attributes = ele.getAllAttributes();
		if (attributes != null && !attributes.isEmpty()) {
			Iterator it = attributes.iterator();
			List attributeList = new ArrayList();
			while (it.hasNext()) {
				Attribute attribute = (Attribute) it.next();
				CompositeMap record = new CompositeMap("record");
				record.put("name", attribute.getLocalName());
				record.put("type", attribute.getType());
				record.put("document", attribute.getDocument());
				attributeList.add(record);
			}
			CompositeMap attributeMap = new CompositeMap();
			attributeMap.addChilds(attributeList);
			result.put("attributes", attributeMap);
		}
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
					record.put("type", element.getType());
					record.put("document", element.getDocument());
					elementList.add(record);
				}
			}
			CompositeMap elementMap = new CompositeMap();
			elementMap.addChilds(elementList);
			result.put("elements", elementMap);
		}
		return result;
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
