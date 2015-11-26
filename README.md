# IconBuilder

##Requirements
The only requirement is ImageMagick. It is used to write text and resize the provided app icon.
```sh
brew install imagemagick
```

##MAC OS APP
In order to use the Mac OS App, just download it from the releases tab. Drag and drop an .xcodeproj file into the app and an app icon of 180x180 pixels. Press run and XZibit does the resizing and tagging for you

##Command line tool
You use the command line tool in two easy steps:

 Generate the configuration file for your project
```sh
./Xzibit init pathToYourProject.xcodeproj
```
 Generate the actual app icons based on the generated config file
```sh
./XZibit generate pathToYourProject.xcodeproj PathToYourIcon
```
You get the Xzibit command line tool by building it, clicking Products, show in Finder or in the releases tab here
[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/R9UZF-L7uMA/0.jpg)](http://www.youtube.com/watch?v=R9UZF-L7uMA)
