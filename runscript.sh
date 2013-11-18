#/bin/sh
# Date: 2013-06-20
# Author: Seamus
# Sina Weibo: @qdvictory

#Run when "Build Configuration" is "Debug". You can change to "ad_hoc","Release" and so on
if [ "${CONFIGURATION}" = "Debug" ]; then

############################开发者配置#################################
#icon地址(相对于项目根目录)
pathtoartwork="iFurniture/icon/120.png"
#####################################################################

#获取app名
ipaname=`/usr/libexec/PlistBuddy -c "Print :CFBundleDisplayName $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"`
#获取版本号
version=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"`
#appid
appid=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"`
#获取当前目录
projectpath=`pwd`

#打包.ipa
/bin/mkdir $CONFIGURATION_BUILD_DIR/Payload
/bin/cp -R $CONFIGURATION_BUILD_DIR/${ipaname}.app $CONFIGURATION_BUILD_DIR/Payload
/bin/cp ${pathtoartwork} $CONFIGURATION_BUILD_DIR/iTunesArtwork
cd $CONFIGURATION_BUILD_DIR

# zip up the directory
/usr/bin/zip -r ${ipaname}.ipa Payload iTunesArtwork

#get last commit if have
gitcommit=`git --git-dir=${projectpath}/.git log -1 --oneline --pretty=format:'%s'`

#fir.im上传第一步
d=`curl "http://fir.im/api/upload_url?appid="${appid}`
#fir.im上传第二步
postFile=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['postFile'];"`
postIcon=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['postIcon'];"`
shorturl=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['short'];"`
curl -T ${ipaname}.ipa ${postFile} -X PUT
curl -T $CONFIGURATION_BUILD_DIR/iTunesArtwork ${postIcon} -X PUT
#fir.im上传第三步
postData='appid='${appid}'&short='${shorturl}'&version='${version}'&name='${ipaname}
if [ "${gitcommit}" ]; then
gitcommit=$(perl -MURI::Escape -e 'print uri_escape("'"${gitcommit}"'");' "$2")
postData=${postData}'&changelog='${gitcommit}
fi
r=`curl -X POST -d ${postData} -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" "http://fir.im/api/finish"`
short=`echo ${r}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['short'];"`
#输出url
`osascript -e 'tell app "System Events" to (display dialog "恭喜您，IPA上传完成。复制地址即可下载。\nhttp://fir.im/'${short}'" with title "IPA一键分享" buttons {"ok"})'`

#删除临时文件
rm -R $CONFIGURATION_BUILD_DIR/Payload
rm ${ipaname}.ipa

fi
exit 0