package com.fusetools.insta;




import android.app.Application;
import android.support.multidex.MultiDex;

import com.instabug.library.Instabug;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.bugreporting.model.ReportCategory;
import com.instabug.library.internal.module.InstabugLocale;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.fuse.Activity;




public class fuseinstabug extends Application
{





	public void invoke(String token)
	{



		//MultiDex.install(this);
		Instabug mInstabug = new Instabug.Builder(com.fuse.Activity.getRootActivity().getApplication(), token)
		.setIntroMessageEnabled(true)
        .setInvocationEvent(InstabugInvocationEvent.SHAKE)
        .build();

        mInstabug.setUserEmail("youremail@gmail.com");
        mInstabug.setUsername("yourusername");
        mInstabug.setShakingThreshold(410);
        mInstabug.setDebugEnabled(true);
	}
}
