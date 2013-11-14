Thanks for [fir.im](http://fir.im)

===========================
1. This shell will upload .ipa to [fir.im](http://fir.im) and others can install from it.
2. This shell only be used for share .ipa to others. So you already configured code signing identity right.

===========================

`EasytoMore` is a demo use Xcode. `Command+B` to build and it's works.

===========================

#Configuration easily.
</br>

!["xcode"](http://www.minroad.com/wp-content/uploads/2013/11/a.png)

###Copy all code from `runscript.shell` to Xcode Run Script.

1. change `ad_hoc` to your "Build Configuration" name.

		if [ "${CONFIGURATION}" = "ad_hoc" ]; then
	
2. change `pathtoartwork` to your artwork or icon path.
   
		pathtoartwork="iFurniture/icon/120.png"
	

That's all.  It will alert url when you build use Build Configuration = "ad_hoc".

!["alert"](http://www.minroad.com/wp-content/uploads/2013/11/b.png)

###Open url use Safari on iPhone. Then click QR code.
</br>
<img src="http://www.minroad.com/wp-content/uploads/2013/11/Screenshot-2013.11.14-13.15.26.png" alt="qr code" width=320px />

<img src="http://www.minroad.com/wp-content/uploads/2013/11/Screenshot-2013.11.14-13.16.29.png" alt="qr code" width=320px />

===========================

If have any question, let me know.

Sina Weibo: [@qdvictory](http://weibo.com/qdvictory)

