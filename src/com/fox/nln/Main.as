import com.GameInterface.DistributedValue;
import mx.utils.Delegate;

class com.fox.nln.Main {
	private var LoginRewardsDval:DistributedValue;
	private var SafCollectors:DistributedValue;
	
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new Main(swfRoot);
		swfRoot.onLoad = function() {s_app.onLoad()};
		swfRoot.onUnload = function() {s_app.onUnload()};
	}

	public function Main() { }

	public function onLoad() {
		LoginRewardsDval = DistributedValue.Create("dailyLogin_window");
		SafCollectors = DistributedValue.Create("safCollectorsPurchase_window");
		LoginRewardsDval.SignalChanged.Connect(CloseNewsPage, this);
		SafCollectors.SignalChanged.Connect(CloseCollectors, this);
		CloseNewsPage();
		CloseCollectors();
	}
	
	private function CloseNewsPage(){
		if(LoginRewardsDval.GetValue()){
			if (_root.dailylogin.m_Window.m_Content.m_Skin){
				//news page can still be accessed through the back arrow,no need to disconnect the signal
				_root.dailylogin.m_Window.m_Content.m_Skin.m_NextButton.dispatchEvent({type:"click"});
			}else{
				setTimeout(Delegate.create(this, CloseNewsPage), 50);
			}
		}
	}
	
	private function CloseCollectors(){
		if (SafCollectors.GetValue()){
			SafCollectors.SetValue(false);
			//SAF closed, we can now disconnect the signal so we can access the SAF edition from topbar (onLoad should reconnect it on character change)
			SafCollectors.SignalChanged.Disconnect(CloseCollectors, this);
		}
	}

	public function onUnload() {
		LoginRewardsDval.SignalChanged.Disconnect(CloseNewsPage, this);
		SafCollectors.SignalChanged.Disconnect(CloseCollectors, this);
	}
}