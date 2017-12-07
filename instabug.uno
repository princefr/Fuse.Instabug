using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Resources;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;
using Fuse.Controls.Native.iOS;

using Fuse.Platform;

[extern(iOS) Require("Cocoapods.Podfile.Target", "pod 'Instabug'")]
[extern(iOS) ForeignInclude(Language.ObjC, "Instabug/Instabug.h")]

[extern(android) Require("Gradle.Dependency.Compile", "com.instabug.library:instabug:4.3.3")]
[extern(android) Require("Gradle.Dependency.Compile", "com.android.support:multidex:1.0.1")]
[extern(android) Require("AndroidManifest.Permission", "android.permission.RECORD_AUDIO")]
[extern(android) ForeignInclude(Language.Java, "com.instabug.library.Instabug")]
[extern(android) ForeignInclude(Language.Java, "com.instabug.library.InstabugColorTheme")]
[extern(android) ForeignInclude(Language.Java, "com.instabug.library.InstabugCustomTextPlaceHolder")]
[extern(android) ForeignInclude(Language.Java, "com.instabug.library.bugreporting.model.ReportCategory")]
[extern(android) ForeignInclude(Language.Java, "com.instabug.library.internal.module.InstabugLocale")]
[extern(android) ForeignInclude(Language.Java, "com.instabug.library.invocation.InstabugInvocationEvent", "android.support.multidex.MultiDex")]
[extern(android) ForeignInclude(Language.Java, "android.app.Application", "com.fuse.Activity")]
[extern(android) ForeignInclude(Language.Java, "android.net.Uri")]
[extern(android) ForeignInclude(Language.Java, "android.os.Handler")]
[extern(android) ForeignInclude(Language.Java, "android.os.Looper")]
[extern(android) ForeignInclude(Language.Java, "android.support.annotation.Nullable")]


public class FuseInstabug : Behavior {
    public FuseInstabug () {
        if defined(DESIGNMODE)
            return;
        if ((Fuse.Platform.Lifecycle.State == Fuse.Platform.ApplicationState.Foreground)
            || (Fuse.Platform.Lifecycle.State == Fuse.Platform.ApplicationState.Interactive)
            ) {
            _foreground = true;
        }
        else {
            Fuse.Platform.Lifecycle.EnteringForeground += OnEnteringForeground;
        }
    }



    void OnEnteringForeground(Fuse.Platform.ApplicationState newState)
    {
        _foreground = true;
        Fuse.Platform.Lifecycle.EnteringForeground -= OnEnteringForeground;
        Init();
    }

    static bool _foreground = false;
    static bool _inited = false;

    void Init() {
        debug_log "Init";
        if defined(DESIGNMODE)
            return;
        if (_inited)
            return;
        if (Token == null || TokenAndroid == null) {
            return;
        }
        if (!_foreground)
            return;
        _inited = true;
        if defined(Android)
            InitImplAndroid(TokenAndroid);
        if defined(iOS) 
            InitImpl(Token);

    }

    [Foreign(Language.ObjC)]
    extern(iOS) void InitImpl(string token) 
    @{
        
        [Instabug startWithToken:token invocationEvent:IBGInvocationEventShake];
        [Instabug identifyUserWithEmail:@"youremail@gmail.com" name:@"yourusername"];
        [Instabug setLocale:IBGLocaleFrench];

    @}


    [Foreign(Language.Java)]
    public void InitImplAndroid(string token) 
    @{

        Instabug mInstabug = new Instabug.Builder(Activity.getRootActivity().getApplication(), token)
        .setIntroMessageEnabled(true)
        .setInvocationEvent(InstabugInvocationEvent.SHAKE)
        .build();


        mInstabug.setUserEmail("youremail@gmail.com");
        mInstabug.setUsername("yourusername");
        mInstabug.setShakingThreshold(110);
        mInstabug.setDebugEnabled(true);
    @}




    static string _token;
    public string Token {
        get { return _token; } 
        set { 
            if defined(iOS){
                _token = value;
                Init();
            }
        }
    }


    public string TokenAndroid {
        get { return _token; } 
        set { 
            if defined(Android){
                _token = value;
                Init();
            }
        }
    }


}
