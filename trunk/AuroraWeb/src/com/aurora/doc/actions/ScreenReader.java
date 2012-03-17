package com.aurora.doc.actions;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

import uncertain.composite.CompositeMap;
import uncertain.ocm.IObjectRegistry;
import aurora.application.sourcecode.SourceCodeUtil;

public class ScreenReader {

	private static final String FILE_PATH = "release/";

	public static CompositeMap getScreenHomePath(IObjectRegistry registry,
			CompositeMap parameter) throws IOException {
		File webHome = SourceCodeUtil.getWebHome(registry);
		String version = parameter.getString("version");
		String tag = parameter.getString("tag_name");
		String file_path = FILE_PATH + version + "/screen/" + tag + ".screen";
		CompositeMap result = new CompositeMap();
		File file = new File(webHome, file_path);
		if (!file.exists())
			// throw new IOException("Can't get resource from " + file_path);
			result.put("home_path", null);
		else {
			result.put("home_path", webHome.getPath());
		}
		return result;
	}
}
