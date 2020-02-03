extends Node2D
var share = null
var admob = null
var isReal = false
var isTop = true
var adBannerId = "ca-app-pub-8814158610826349/8451506754" # Banner Ad Unit ID
var adInterstitialId = "ca-app-pub-8814158610826349/1768363110" # InterStitial Unit ID
var adRewardedId = "ca-app-pub-8814158610826349/7567484701" # Reward AD unit ID

func _ready():
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadBanner()
		loadInterstitial()
		loadRewardedVideo()
	
	get_tree().connect("screen_resized", self, "onResize")

#### ADMOB STUFF ####
### Module interaction ###
# Loaders

func loadBanner():
	if admob != null:
		admob.loadBanner(adBannerId, isTop)

func loadInterstitial():
	if admob != null:
		admob.loadInterstitial(adInterstitialId)
		
func loadRewardedVideo():
	if admob != null:
		admob.loadRewardedVideo(adRewardedId)

# Events

func _on_admob_network_error():
	print("Network Error")

func _on_admob_ad_loaded():
	print("Ad loaded success")
	get_node("CanvasLayer/BtnBan").set_disabled(false)

func _on_interstitial_not_loaded():
	print("Error: Interstitial not loaded")

func _on_interstitial_loaded():
	print("Interstitial loaded")
	get_node("CanvasLayer/BtnInter").set_disabled(false)

func _on_interstitial_close():
	print("Interstitial closed")
	get_node("CanvasLayer/BtnInter").set_disabled(true)

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	get_node("CanvasLayer/BtnRwd").set_disabled(false)
	
func _on_rewarded_video_ad_closed():
	print("Rewarded closed")
	get_node("CanvasLayer/BtnRwd").set_disabled(true)
	loadRewardedVideo()
	
func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	get_node("CanvasLayer/RewRtn").set_text("Reward: " + currency + ", " + str(amount))

# Resize

func onResize():
	if admob != null:
		admob.resize()
 # Buttons 

func _on_BtnBan_toggled(pressed):
	if admob != null:
		if pressed: admob.showBanner()
		else: admob.hideBanner()

func _on_Btninter_pressed():
	if admob != null:
		admob.showInterstitial()

func _on_BtnRwd_pressed():
	if admob != null:
		admob.showRewardedVideo()



### Share Stuff ### 
func _on_ShBtn_pressed():
	
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	# Let two frames pass to make sure the screen was captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	# Retrieve the captured image
	var img = get_viewport().get_texture().get_data()
	# Flip it on the y-axis (because it's flipped)
	img.flip_y()
	
	# user://tmp.png
	var image_save_path = OS.get_user_data_dir() + "/tmp.png"
	
	# saves the capture as user://tmp.png
	img.save_png(image_save_path)
	
	# if share was found, use it
	if share != null:
		share.sharePic(image_save_path, "Image Sharing", "Sharing image with GodotShare", "It's a demo app for testing GodotShare. Do you like it?")




