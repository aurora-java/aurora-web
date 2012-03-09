package com.aurora.doc.actions;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.regex.Pattern;

import uncertain.composite.CompositeMap;
import uncertain.ocm.IObjectRegistry;
import aurora.application.sourcecode.SourceCodeUtil;

public class ScreenReader {

	private static final String FILE_PATH = "release/";
	private static String xmlPattern = ".*<\\?xml[^>]*\\?>";
	private static String notePattern = "<!--[^>]*-->";
	private static String screenPattern = ".*<a:screen\\s[^>]*>(.*)</a:screen>.*";
	private static String procedurePattern = ".*<a:init-procedure(/>)|(.*/a:init-procedure>)";
	private static String viewPattern = ".*<a:view[^>]*>(.*)</a:view>.*";

	public static CompositeMap getContent(IObjectRegistry registry,
			CompositeMap parameter) throws IOException {
		File webHome = SourceCodeUtil.getWebHome(registry);
		String version = parameter.getString("version");
		String tag = parameter.getString("tag_name");
		String file_path = FILE_PATH + version + "/screen/" + tag.toLowerCase()
				+ ".screen";
		CompositeMap result = new CompositeMap();
		File file = new File(webHome, file_path);
		if (!file.exists())
			// throw new IOException("Can't get resource from " + file_path);
			result.put("content", null);
		else
			result.put("content", parseContent(getContent(file)));
		return result;
	}

	private static String getContent(File file) throws IOException {
		Reader reader = null;
		try {
			StringBuffer sb = new StringBuffer();
			char[] tempchars = new char[30];
			int begin;
			reader = new InputStreamReader(new FileInputStream(file), "UTF-8");
			while ((begin = reader.read(tempchars)) != -1) {
				sb.append(new String(tempchars, 0, begin));
			}
			return sb.toString();
		} finally {
			if (reader != null)
				reader.close();
		}
	}

	private static String parseContent(String content) {
		if (null == content || "".equals(content))
			return "";
		return replaceAll(
				viewPattern,
				replaceAll(
						procedurePattern,
						replaceAll(
								screenPattern,
								replaceAll(notePattern,
										replaceAll(xmlPattern, content, ""), ""),
								"$1"), ""), "$1");
	}

	private static String replaceAll(String regex, CharSequence input,
			String replacement) {
		return Pattern.compile(regex, Pattern.DOTALL).matcher(input)
				.replaceAll(replacement);
	}
}
