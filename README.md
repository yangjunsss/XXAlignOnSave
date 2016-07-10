##XXAlignOnSave

An amazing Xcode plugin to automatically align and indent when save your regular code,such as C,C++,OC.It's based on the XAlign plugin which is configurable.More about XAlign [Here](https://github.com/qfish/XAlign).

##Why I create it?

I'm lazy to align the code through select.I want a more convenient way.

### Install & Uninstall

####Install
```shell
curl -fsSL https://raw.githubusercontent.com/yangjunsss/XXAlignOnSave/master/Scripts/install.sh | sh
```
####Unisntall
```shell
curl -fsSL https://raw.githubusercontent.com/yangjunsss/XXAlignOnSave/master/Scripts/uninstall.sh | sh
```

or Delete the following directory:

```
~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/XXAlignOnSave.xcplugin
```


### Align on Save

Here are some example alignment patterns. Of course you can make your own. The pattern file is here:  `XAlign/patterns.plist`, and the patterns are based on regular expression.

#### Align by equals sign
![Equal](http://qfi.sh/XAlign/images/equal.gif)

#### Align by define group
![Define](http://qfi.sh/XAlign/images/define.gif)

#### Align by property group
![Property](http://qfi.sh/XAlign/images/property.gif)

### Usage

```
Xcode -> Edit -> XXAlign -> Auto Align On Save
```
The default is enable.


### Issue  
[GitHub Issue](https://github.com/yangjunsss/XXAlignOnSave/issues)
  
#### If you use New version Xcode, Try this in your terminal : 
  
  1. Get current Xcode UUID  
  
  ```shell
  XCODEUUID=`defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`
  ```
  2. Write it into the Plug-ins's plist  
  
  ```shell
  for f in ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/*; do defaults write "$f/Contents/Info" DVTPlugInCompatibilityUUIDs -array-add $XCODEUUID; done
  ```
  3. Restart your Xcode, and select <kbd>Load Bundles</kbd> on the alert
   

