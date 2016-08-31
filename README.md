# HangIt Native Extension for Adobe AIR Developer Guide #

<!--- This guide has the following sections:

* [Overview](#overview)
* [Include the HangIt Library](#include)
* [Update Your Application Descriptor](#descriptor)
* [ActionScript Integration](#integration)

-->

<a id="overview"></a>
## Overview ##

This Native Extension allows you to use the HangIt SDK in Adobe AIR mobile applications.

A complete sample class demonstrating the functions of the ActionScript API is available in the `/example` folder.

Refer to the ActionScript HTML class documentation (`/asdoc`) for specific details on the API's ActionScript methods and classes.


<a id="include"></a>
## Include the HangIt library ##

***Before you begin:*** *This extension requires Adobe AIR 21.0 or higher.  You can get the latest AIR SDK from [here](http://www.adobe.com/devnet/air/air-sdk-download.html).*

**In Flash Professional:**

1. Create a new project of the type AIR for iOS (Or Android).
2. Select File > Publish Settings.
3. Select the wrench icon next to Script for ActionScript Settings.
4. Select the Library Path tab.
5. Press the Browse for Native Extension (ANE) File button and select the `com.hangit.extensions.HangIt.ane` file.
6. **(For Android Only)** Press the Browse for Native Extension (ANE) File button again, and select the `com.hangit.extensions.GoogleServices.ane` file.

**In Flash Builder 4.6 or Later:**

1. Go to Project Properties (right-click your project in Package Explorer and select Properties).
2. Select ActionScript Build Path and click the Native Extensions tab.
3. Click Add ANE and navigate to the `com.hangit.extensions.HangIt.ane` file.
4. **(For Android Only)** Click Add ANE and navigate to the `com.hangit.extensions.GoogleServices.ane` file.
5. Add the extension to the build target before compiling.  
6. (Ensure the 'package' checkbox is selected for the extensions in the target build properties.)

<a id="descriptor"></a>
## Update your Application Descriptor ##


### For All Project Targets ###

To use the extension for either iOS or Android, add the extension identifier for HangIt and to the `<extensions>` block in `application.xml`.  If targeting Android, a `GoogleServices.ane` is also required:

	  <extensions>
		    <extensionID>com.hangit.extensions.HangIt</extensionID>
			<extensionID>com.hangit.extensions.GoogleServices</extensionID>
		</extensions>



### For Projects Targeting iOS ###

To use the extension for iOS, you'll need to include the *NSAppTransportSecurity* data show below into your Application Descriptor's `<InfoAdditions>` block inside the `<iPhone>` block, set the `MinimumOSVersion` to 8.0, and include the required `UIBackgroundModes` and `NSLocationWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription` values:

	<InfoAdditions>
		<![CDATA[
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key><true/>
	</dict>

    <key>MinimumOSVersion</key>
    <string>8.0</string>

    <key>UIBackgroundModes</key>
    <array>
         <string>location</string>
       	<string>fetch</string>
    </array>

	<key>NSLocationWhenInUseUsageDescription</key>
	<string>We offer great deals at places near you, so let us know where you are. We’ll never spam you.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>We offer great deals at places near you, so let us know where you are. We’ll never spam you.</string>
	]]>
	</InfoAdditions>

### For Projects Targeting Android ###

In order to use the HangIt Extension on Android, you'll need to update the `manifestAdditions` block in your your `application.xml` file (for convenience, it may easier to copy and paste this section from the `example/app.xml` file included with the HangIt extension):

 	<android>
        <manifestAdditions><![CDATA[
			<manifest android:installLocation="auto">

				<!-- These permissions are required by HangIt -->
				<uses-permission android:name="android.permission.INTERNET" />
				<uses-permission android:name="android.permission.READ_PHONE_STATE" />
				<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
				<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
				<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
				<uses-permission android:name="com.google.android.providers.gsf.permission.READ_GSERVICES" />
				<uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
				<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

				<application>

				<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />


       <service android:name="com.hangit.android.hangit_sdk.ServiceHangITLocation">
            <meta-data android:name="com.hangit.android.hangit_sdk.notification_icon" android:value="ic_launcher"/>
            <meta-data android:name="com.hangit.android.hangit_sdk.notification_activity" android:value="com.hangit.android.hangit_sdk.UIWebViewActivity"/>
            <meta-data android:name="com.hangit.android.hangit_sdk.appnext_notification_activity" android:value="com.hangit.android.hangit_sdk.UIAppNextActivity"/>
            <meta-data android:name="com.hangit.android.hangit_sdk.notification_back_activity" android:value="com.hangit.android.hangit_sdk.NotificationBackActivity"/>
        </service>
        <service android:name="com.hangit.android.hangit_sdk.ServiceActivityRecognition"/>
        <service android:name="com.hangit.android.hangit_sdk.ServiceBeacon"/>
        <receiver android:name="com.hangit.android.hangit_sdk.ReceiverBootup">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>

        <activity android:name="com.hangit.android.hangit_sdk.UIWebViewActivity"/>
        <activity android:name="com.hangit.android.hangit_sdk.UIMapActivity" android:screenOrientation="portrait"/>
        <activity android:name="com.hangit.android.hangit_sdk.UIBackgroundActivity" android:screenOrientation="portrait"/>
        <activity android:name="com.hangit.android.hangit_sdk.UINotificationBackActivity"/>
        <activity android:name="com.hangit.android.hangit_sdk.UIAppNextActivity" android:screenOrientation="portrait"/>
        <activity android:name="com.hangit.android.hangit_sdk.UIWalletActivity" android:screenOrientation="portrait"/>

        <!--meta-data android:name="com.google.android.maps.v2.API_KEY" android:value="AIzaSyA6anZrDFdlkwkWN41s73rYnzB-INSIgD0"/-->

        <activity android:configChanges="keyboard|keyboardHidden|orientation|screenLayout|screenSize|smallestScreenSize|uiMode" android:name="com.google.android.gms.ads.AdActivity" android:theme="@android:style/Theme.Translucent"/>
        <activity android:name="com.google.android.gms.ads.purchase.InAppPurchaseActivity" android:theme="@style/Theme.IAPTheme"/>

        <meta-data android:name="com.google.android.gms.wallet.api.enabled" android:value="true"/>
        <receiver android:exported="false" android:name="com.google.android.gms.wallet.EnableWalletOptimizationReceiver">
            <intent-filter>
                <action android:name="com.google.android.gms.wallet.ENABLE_WALLET_OPTIMIZATION"/>
            </intent-filter>
        </receiver>
        <service android:exported="false" android:name="com.estimote.sdk.service.BeaconService"/>


				</application>
			</manifest>			
		]]></manifestAdditions>
    </android>

<a id="integration"></a>
## ActionScript Integration ##

To activate HangIt in your project, you include a few simple function calls:

### Initialize the HangIt API ###

Import the  API Packages at the top of any source files that reference HangIt:

	import com.hangit.nativeextensions.*;


Your will need to create an account and login to https://portal.hangit.com to create an app and generate your App ID Key set below, depending on the target platforms of your project.  Create a `HangItConfig` object that contains these values:

		var config:HangItConfig=new HangItConfig()
			.setAndroidKey("your android key goes here")
			.setiOSKey("your ios key goes here");

 At the very start of your application's execution, initialize the HangIt API by calling `HangIt.create(config)`, followed by `HangIt.hangIt.startAllServices()`.  You should call this in either your Document Class constructor function, or on 'frame 1' if you are usins legacy timeline style Flash code.

  You may use the `HangIt.isSupported()` function to determine if the platform your app is running on supports the HangIt API (either Android or iOS):

	if(HangIt.isSupported())
	{
		HangIt.create(config);
		HangIt.hangIt.startAllServices();
	}
	else
	{
		trace("hangit works on iOS And Android only.");
	}

### Opening the Wallet ###

If your application needs to open the HangIt wallet, call the `openWallet()` method at any time after initialization:

	// open wallet
	HangIt.hangIt.openWallet();


### Clearing the Device ###

During testing, you may need to clear the device in order to test a location based notification or offer a second time.  This is done with the `clearDevice()` function:

		// clear device to test location based notifications again
		HangIt.hangIt.clearDevice();
