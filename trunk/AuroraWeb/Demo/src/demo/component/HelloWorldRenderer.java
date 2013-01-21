package demo.component;

import java.io.IOException;
import java.io.Writer;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import uncertain.composite.CompositeMap;
import aurora.presentation.BuildSession;
import aurora.presentation.ViewContext;
import aurora.presentation.ViewCreationException;
import aurora.presentation.component.std.config.ComponentConfig;

public class HelloWorldRenderer {
	public void onCreateViewContent(BuildSession session,
			ViewContext view_context) {
		CompositeMap view = view_context.getView();
		// 从model中获取需要显示的字段
		CompositeMap model = view_context.getModel();

		String val = view.getString(PROPERTITY_VALUE, "");
		String format = view.getString(PROPERTITY_FORMAT, "###,###.00");
		int width = view.getInt(PROPERTITY_WIDTH, 150);
		String sty = view.getString(PROPERTITY_STYLE, "");
		Object obj = model.getObject(val);
		obj = obj == null ? val : obj;
		String value = "";
		if (obj instanceof Date) {
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			value = sdf.format((Date) obj);
		} else if (obj instanceof Long || obj instanceof Double || obj instanceof Integer) {
			DecimalFormat df = new DecimalFormat(format);
			value = df.format(obj);
		} else if (obj != null) {
			value = obj.toString();
		}

		String wrapClass = "item-label";
		try {
			wrapClass = Integer.valueOf(value) > 0 ? "item-label"
					: "item-label-red";
		} catch (NumberFormatException e) {
		}

		// 将动态内容放入ViewContext的Map中，后面将用于替换模版中的同名标记
		Map content_map = view_context.getMap();
		content_map.put("wrapClass", wrapClass);
		content_map.put("width", width);
		content_map.put("style", sty);
		content_map.put("value", value);
	}

	public static final String VERSION = "$Revision: 6975 $";

	private static final String PROPERTITY_VALUE = ComponentConfig.PROPERTITY_VALUE;
	private static final String PROPERTITY_FORMAT = "format";
	private static final String PROPERTITY_STYLE = ComponentConfig.PROPERTITY_STYLE;
	private static final String PROPERTITY_CLASSNAME = ComponentConfig.PROPERTITY_CLASSNAME;
	private static final String PROPERTITY_WIDTH = ComponentConfig.PROPERTITY_WIDTH;

	public void buildView(BuildSession session, ViewContext view_context)
			throws IOException, ViewCreationException {
		CompositeMap view = view_context.getView();
		CompositeMap model = view_context.getModel();
		Map map = view_context.getMap();
		map.put("aaaaaaaa", "bbbbbbbbbbbbbbb");
		Writer out = session.getWriter();
		String val = view.getString(PROPERTITY_VALUE, "");
		String format = view.getString(PROPERTITY_FORMAT, "");
		String clz = view.getString(PROPERTITY_CLASSNAME, "");
		int width = view.getInt(PROPERTITY_WIDTH, 150);
		String sty = view.getString(PROPERTITY_STYLE, "");
		Object obj = model.getObject(val);
		String value = "";
		if (obj instanceof Date) {
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			value = sdf.format((Date) obj);
		} else if (obj instanceof Long || obj instanceof Double) {
			DecimalFormat df = new DecimalFormat(format);
			value = df.format(obj);
		} else if (obj != null) {
			value = obj.toString();
		}
		out.write("<div ");
		out.write("style='width:" + width + "px;" + sty + "' ");
		out.write("class='item-view ");
		out.write(clz);
		out.write("'>" + value + "</div>");
	}

	public String[] getBuildSteps(ViewContext context) {
		return null;
	}

}
