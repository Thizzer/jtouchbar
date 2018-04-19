[![Build Status](https://travis-ci.org/Thizzer/JTouchBar.svg?branch=master)](https://travis-ci.org/Thizzer/JTouchBar)

# JTouchBar

Java library for using the touchbar API on supported macbooks.

## Support the Developers!

Please take a look at the other stuff the developers are working on and support them in other ways.

* [ttveldhuis](https://github.com/ttveldhuis)
  * Buy ttveldhuis a coffee - https://ko-fi.com/ttveldhuis
  * Patreon Page - https://www.patreon.com/ttveldhuis  
  * Blog - https://www.thizzer.com
  
## Installation & Usage

### Maven

```
<dependency>
	<groupId>com.thizzer.jtouchbar</groupId>
	<artifactId>jtouchbar</artifactId>
	<version>0.2.0-SNAPSHOT</version>
</dependency>
```

### Using JTouchBar with SWT

```
Shell shell = ...

JTouchBar jTouchBar = new JTouchBar();
jTouchBar.setCustomizationIdentifier("MySWTJavaTouchBar");

// Customize your touchbar

jTouchBar.show(shell);
```

### Using JTouchBar with Swing

```
JFrame frame = ...

JTouchBar jTouchBar = new JTouchBar();
jTouchBar.setCustomizationIdentifier("MySwingJavaTouchBar");

// Customize your touchbar

jTouchBar.show(frame);
```

### Using JTouchBar with JavaFX

```
Stage stage = ...

JTouchBar jTouchBar = new JTouchBar();
jTouchBar.setCustomizationIdentifier("MyJavaFXJavaTouchBar");

// Customize your touchbar

jTouchBar.show(stage);
```

### Using JTouchBar with LWJGL

```
long window = ... // LWJGL window

JTouchBar jTouchBar = new JTouchBar();
jTouchBar.setCustomizationIdentifier("MyLWJGLJavaTouchBar");

// Customize your touchbar

jTouchBar.show(
		GLFWNativeCocoa.glfwGetCocoaWindow(window)
	);
```

### Adding views to your touchbar

```
// flexible space
jTouchBar.addItem(new TouchBarItem(TouchBarItem.NSTouchBarItemIdentifierFlexibleSpace));

// fixed space
jTouchBar.addItem(new TouchBarItem(TouchBarItem.NSTouchBarItemIdentifierFixedSpaceSmall));

// button
TouchBarButton touchBarButtonImg = new TouchBarButton();
touchBarButtonImg.setTitle("Button 1");
touchBarButtonImg.setAction(new TouchBarViewAction() {
	@Override
	public void onCall( TouchBarView view ) {
		System.out.println("Clicked Button_1.");
	}
});

Image image = new Image();
img.setName(ImageName.NSImageNameTouchBarColorPickerFill);
touchBarButtonImg.setImage(image);

jTouchBar.addItem(new TouchBarItem("Button_1", touchBarButtonImg, true));

// label
TouchBarTextField touchBarTextField = new TouchBarTextField();
touchBarTextField.setStringValue("TextField 1");

jTouchBar.addItem(new TouchBarItem("TextField_1", touchBarTextField, true));

// scrubber
TouchBarScrubber touchBarScrubber = new TouchBarScrubber();
touchBarScrubber.setActionListener(new ScrubberActionListener() {
	@Override
	public void didSelectItemAtIndex(TouchBarScrubber scrubber, long index) {
		System.out.println("Selected Scrubber Index: " + index);
	}
});
touchBarScrubber.setDataSource(new ScrubberDataSource() {
	@Override
	public ScrubberView getViewForIndex(TouchBarScrubber scrubber, long index) {
		if(index == 0) {
			ScrubberTextItemView textItemView = new ScrubberTextItemView();
			textItemView.setIdentifier("ScrubberItem_1");
			textItemView.setStringValue("Scrubber TextItem");
			
			return textItemView;
		}
		else {
			ScrubberImageItemView imageItemView = new ScrubberImageItemView();
			imageItemView.setIdentifier("ScrubberItem_2");
			imageItemView.setImage(new Image(ImageName.NSImageNameTouchBarAlarmTemplate, false));
			imageItemView.setAlignment(ImageAlignment.CENTER);
			
			return imageItemView;
		}
	}
	
	@Override
	public int getNumberOfItems(TouchBarScrubber scrubber) {
		return 2;
	}
});

jTouchBar.addItem(new TouchBarItem("Scrubber_1", touchBarScrubber, true));


```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
