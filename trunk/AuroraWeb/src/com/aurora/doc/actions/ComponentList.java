package com.aurora.doc.actions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import uncertain.composite.CompositeMap;
import uncertain.core.UncertainEngine;
import uncertain.ocm.IObjectRegistry;
import uncertain.pkg.PackageManager;
import aurora.presentation.ViewComponent;
import aurora.presentation.ViewComponentPackage;

public class ComponentList {

	private static final String mDefaultPackage = "aurora.ui.std";
	private static final String CATEGORY_NAME = "category_name";
	private static final String NS = "ns";
	private static final String PKG = "pkg";
	private static Map nameSpaces;

	@SuppressWarnings("unchecked")
	public static CompositeMap getCategoryList(IObjectRegistry registry,
			CompositeMap parameter) throws Exception {
		UncertainEngine engine = (UncertainEngine) registry
				.getInstanceOfType(UncertainEngine.class);
		PackageManager mPackageManager = engine.getPackageManager();
		ViewComponentPackage p = (ViewComponentPackage) mPackageManager
				.getPackage(mDefaultPackage);
		List vcs = new ArrayList(p.getAllComponents());
		nameSpaces = new HashMap();
		for (int i = 0; i < vcs.size(); i++) {
			ViewComponent vc = (ViewComponent) vcs.get(i);
			CompositeMap vcmap = new CompositeMap();
			vcmap.put("name", vc.getElementName());
			Map childMap = (HashMap) nameSpaces.get(vc.getNameSpace());
			if (null == childMap) {
				childMap = new HashMap();
			}
			List components = (ArrayList) childMap.get(vc.getCategory());
			if (null == components) {
				components = new ArrayList();
			}
			components.add(vcmap);
			childMap.put(vc.getCategory(), components);
			nameSpaces.put(vc.getNameSpace(), childMap);
		}

		Iterator nsIt = nameSpaces.keySet().iterator();
		List parentList = new ArrayList();
		while (nsIt.hasNext()) {
			String ns = (String) nsIt.next();
			CompositeMap parent = new CompositeMap();
			parentList.add(parent);
			parent.putString(PKG, ns);
			Iterator childIt = ((HashMap) nameSpaces.get(ns)).keySet().iterator();
			List childList = new ArrayList();
			while (childIt.hasNext()) {
				CompositeMap child = new CompositeMap();
				child.putString(CATEGORY_NAME, (String) childIt.next());
				child.putString(NS, ns);
				childList.add(child);
			}
			CompositeMap children = new CompositeMap();
			children.addChilds(childList);
			parent.put("children", children);
		}

		CompositeMap result = new CompositeMap();
		result.addChilds(parentList);
		return result;
	}

	@SuppressWarnings("unchecked")
	public static CompositeMap getComponentList(IObjectRegistry registry,
			CompositeMap parameter) throws Exception {
		if (null == nameSpaces) {
			getCategoryList(registry, parameter);
		}
		String category = parameter.getString("category");
		String nameSpace = parameter.getString("ns");
		CompositeMap result = new CompositeMap();
		if (null != category && null != nameSpace) {
			result.addChilds((ArrayList) ((HashMap) nameSpaces.get(nameSpace))
					.get(category));
		}
		return result;
	}
}
