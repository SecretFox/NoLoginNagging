import com.GameInterface.DistributedValue;
import mx.utils.Delegate;

class com.fox.nln.Main {
	private var LoginRewardsDval:DistributedValue;
	private var PatronBundle:DistributedValue;
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new Main(swfRoot);
		swfRoot.onLoad = function() {s_app.onLoad()};
		swfRoot.onUnload = function() {s_app.onUnload()};
	}
	public function Main() { }
	public function onLoad() {
		LoginRewardsDval = DistributedValue.Create("dailyLogin_window");
		PatronBundle = DistributedValue.Create("12MonthBundlePurchase_window");
		PatronBundle.SignalChanged.Connect(ClosePatron, this);
		LoginRewardsDval.SignalChanged.Connect(CloseNewsPage, this);
		CloseNewsPage();
		ClosePatron();
	}
	public function onUnload() {
		LoginRewardsDval.SignalChanged.Disconnect(CloseNewsPage, this);
		PatronBundle.SignalChanged.Disconnect(ClosePatron, this);
	}
	private function ClosePatron() {
		if (PatronBundle.GetValue()){
			PatronBundle.SetValue();
			// Only close it on login, so that user can still open it through icon
			// may have to click the icon twice though
			PatronBundle.SignalChanged.Disconnect(ClosePatron, this);
		}
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
}