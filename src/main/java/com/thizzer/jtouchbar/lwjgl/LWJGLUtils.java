package com.thizzer.jtouchbar.lwjgl;

import java.lang.reflect.Field;
import java.nio.ByteBuffer;

public class LWJGLUtils {
    public static ByteBuffer getViewPointer() throws Exception {
        Class CLASS_display = Class.forName("org.lwjgl.opengl.Display");
        Field FIELD_display_impl = CLASS_display.getDeclaredField("display_impl");
        FIELD_display_impl.setAccessible(true);
        Object display_impl = FIELD_display_impl.get(null);

        if (display_impl == null) throw new RuntimeException("Coundn't get display_impl of Display!");
//        if (!"org.lwjgl.opengl.MacOSXDisplay".equals(display_impl.getClass().getSimpleName())) throw new RuntimeException("Display doesn't using MacOSXDisplay!");

        Field FIELD_window = display_impl.getClass().getDeclaredField("window");
        FIELD_window.setAccessible(true);
        ByteBuffer window = (ByteBuffer) FIELD_window.get(display_impl);
        if (window == null) throw new RuntimeException("Coundn't find any window inited");
        return window;
    }
}
