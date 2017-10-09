using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

using Fuse.Platform;

[Require("Gradle.Dependency.Compile", "com.instabug.library:instabug:4.3.0")]
[Require("AndroidManifest.Permission", "android.permission.RECORD_AUDIO")]
[ForeignInclude(Language.Java, "com.instabug.library.Instabug")]
[ForeignInclude(Language.Java, "com.instabug.library.InstabugColorTheme")]
[ForeignInclude(Language.Java, "com.instabug.library.InstabugCustomTextPlaceHolder")]
[ForeignInclude(Language.Java, "com.instabug.library.bugreporting.model.ReportCategory")]
[ForeignInclude(Language.Java, "com.instabug.library.internal.module.InstabugLocale")]
[ForeignInclude(Language.Java, "com.instabug.library.invocation.InstabugInvocationEvent")]
[ForeignInclude(Language.Java, "android.app.Application")]
[ForeignInclude(Language.Java, "android.net.Uri")]
[ForeignInclude(Language.Java, "android.os.Handler")]
[ForeignInclude(Language.Java, "android.os.Looper")]
[ForeignInclude(Language.Java, "android.support.annotation.Nullable")]
[ForeignInclude(Language.Java, "com.fuse.Activity")]

extern(android)
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
        if (TokenAndroid == null) {
            return;
        }
        if (!_foreground)
            return;
        _inited = true;
        if defined(android) 
            InitImpl(TokenAndroid);
    }

    [Foreign(Language.Java)]
    extern(android) void InitImpl(string token) 
    @{
        Instabug mInstabug = new Instabug.Builder(Activity.getRootActivity().getApplication(), token)
        .setIntroMessageEnabled(false)
        .setInvocationEvent(InstabugInvocationEvent.SHAKE)
        .build();

        mInstabug.setUserEmail("pondonda@gmail.com");
        mInstabug.setUsername("prince");
        mInstabug.setShakingThreshold(110);

    @}

    static string _token;
    public string TokenAndroid {
        get { return _token; } 
        set { 
            _token = value;
            Init();
        }
    }

    public string Token {
        get { return null;} 
        set { }
    }
}