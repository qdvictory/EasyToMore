#/bin/sh
# Date: 2013-06-20
# Author: Seamus
# Sina Weibo: @qdvictory

#Run when "Build Configuration" is "Debug". You can change to "ad_hoc","Release" and so on
if [ "${CONFIGURATION}" = "Debug" ]; then

############################开发者配置#################################
#icon地址(相对于项目根目录)
pathtoartwork="EasytoMore/iTunesArtwork.png"
#Note:token 用于识别用户身份, 如果请求不带token 作为匿名访问处理. token可以在用户信息中找到(只有上传过应用的用户才具有使用开发者API的权限)
token="qingzixingxiugai"
#####################################################################

#获取app名
ipaname=`/usr/libexec/PlistBuddy -c "Print :CFBundleDisplayName $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"`
#target name
target=$TARGET_NAME
#空格转义
displayname=$(perl -MURI::Escape -e 'print uri_escape("'"${ipaname}"'");' "$2")
#获取版本号
version=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"`
#appid
appid=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"`
#获取当前目录
projectpath="$(pwd | sed 's/ /\\ /g')"
gitpath=`pwd`

#打包.ipa
/bin/mkdir $CONFIGURATION_BUILD_DIR/Payload
/bin/cp -R $CONFIGURATION_BUILD_DIR/${target}.app $CONFIGURATION_BUILD_DIR/Payload
/bin/cp ${pathtoartwork} $CONFIGURATION_BUILD_DIR/iTunesArtwork
cd $CONFIGURATION_BUILD_DIR

# zip up the directory
/usr/bin/zip -r ${target}.ipa Payload iTunesArtwork

#get last commit if have
gitcommit=`git --git-dir="${gitpath}/.git" log -1 --oneline --pretty=format:'%s'`

#fir.im上传第一步
d=`curl "http://fir.im/api/v2/app/info/"${appid}"?token="${token}`
pkgkey=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['bundle']['pkg']['key'];"`
pkgurl=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['bundle']['pkg']['url'];"`
pkgtoken=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['bundle']['pkg']['token'];"`
iconkey=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['bundle']['icon']['key'];"`
iconurl=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['bundle']['icon']['url'];"`
icontoken=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['bundle']['icon']['token'];"`
pkgid=`echo ${d}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['id'];"`

up=`curl -F "key="${iconkey} -F "token="${icontoken} -F "file=@"$CONFIGURATION_BUILD_DIR"/iTunesArtwork" ${iconurl}`
upipa=`curl -F "key="${pkgkey} -F "token="${pkgtoken} -F "file=@"${target}".ipa" ${pkgurl}`
editinfo=`curl -d "changelog="${gitcommit}"&version="${version} -X PUT "http://fir.im/api/v2/app/"${pkgid}"?token="${token}`


#删除临时文件
rm -R $CONFIGURATION_BUILD_DIR/Payload
rm ${target}.ipa

short=`echo ${editinfo}| ruby -e "require 'rubygems'; require 'json'; puts JSON[STDIN.read]['short'];"`
#输出url
`osascript -e 'tell app "System Events" to (display dialog "恭喜您，IPA上传完成。复制地址即可下载。\nhttp://fir.im/'${short}'" with title "IPA一键分享" buttons {"ok"})'`

fi
exit 0
