package com.thizzer.jtouchbar.common;

public class Image {
	
	private String _name;
	
	private String _path;

	public Image() {}
	
	public Image(String nameOrPath, boolean isPath) {
		if(isPath) {
			_path = nameOrPath;
		}
		else {
			_name = nameOrPath;
		}
	}
	
	public String getName() {
		return _name;
	}

	public void setName(String name) {
		_name = name;
	}

	public String getPath() {
		return _path;
	}

	public void setPath(String path) {
		_path = path;
	}
}
