/**
 * JTouchBar
 *
 * Copyright (c) 2018 - 2019 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
package com.thizzer.jtouchbar.common;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class Image {
	
	private String _name;
	private String _path;
	
	private byte[] _data;

	@SuppressWarnings("unused")
	private Image() {}
	
	/**
	 * 
	 * @param nameOrPath
	 * @param isPath
	 */
	public Image(String nameOrPath, boolean isPath) {
		if(isPath) {
			_path = nameOrPath;
		}
		else {
			_name = nameOrPath;
		}
	}
	
	/**
	 * 
	 * @param data
	 */
	public Image(byte[] data) {
		_data = data;
	}
	
	/**
	 * 
	 * @param dataInputStream
	 * @throws IOException
	 */
	public Image(InputStream dataInputStream) throws IOException {
		readFromInputStream(dataInputStream);
	}
	
	/**
	 * 
	 * @param dataInputStream
	 * @throws IOException
	 */
	public void readFromInputStream(InputStream dataInputStream) throws IOException {
		if(dataInputStream == null) {
			throw new NullPointerException();
		}
		
		try (ByteArrayOutputStream dataOutputStream = new ByteArrayOutputStream()) {
			byte[] buffer = new byte[1024];

	        int read = 0;
	        while((read = dataInputStream.read(buffer)) != -1) {
	        		dataOutputStream.write(buffer, 0, read);
	        }
	        
	        _data = dataOutputStream.toByteArray();
		}
		catch(IOException e) {
			throw e;
		}
		finally {
			dataInputStream.close();
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
	
	public byte[] getData() {
		return _data;
	}

	public void getData(byte[] data) {
		_data = data;
	}
}
