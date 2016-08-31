package  
{
import com.hangit.nativeextensions.*

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;

/** HangItExample App */
public class HangItExample extends Sprite
{
	//
	// Definitions
	//

	/** HangIt Keys */
	private static const HANGIT_IOS_KEY:String="a905ddca3dde20e96094a1711c70e247";
	private static const HANGIT_ANDROID_KEY:String="f64e8abb5d7236c6a7e11f045f4f7b55";

	//
	// Instance Variables
	//
	
	/** Status */
	private var txtStatus:TextField;
	
	/** Buttons */
	private var buttonContainer:Sprite;

	//
	// Public Methods
	//
	
	/** Create New HangItExample */
	public function HangItExample() 
	{	

		createUI();

		if (!HangIt.isSupported())
		{
			log("HangIt is not supported on this platform.");
			removeChild(buttonContainer);
			return;
		}
		
		var config:HangItConfig=new HangItConfig()
			.setAndroidKey(HANGIT_ANDROID_KEY)
			.setiOSKey(HANGIT_IOS_KEY)
			.setPresentNotifications(true)
			.setPresentOfferView(true);
	
	
		log("initializing HangIt...");		
		HangIt.create(config);		

		log("HangIt v"+HangIt.VERSION+" Initialized!");
	}

	//
	// HangIt Test Functions
	//
	
	/** Start Services */
	private function startServices():void
	{
		log("Starting services...");
		
		HangIt.hangIt.startAllServices();
		
		log("Services started.");
	}
	
	/** Open Wallet */
	private function openWallet():void
	{
		log("Opening wallet..");
		
		HangIt.hangIt.openWallet();
		
		log("Opened wallet.");
	}
	
	/** Clear Device */
	private function clearDevice():void
	{
		log("Clearing device...");
		
		HangIt.hangIt.clearDevice();
		
		log("Device cleared.");
	}
	
	/** Stop Services */
	private function stopServices():void
	{
		log("Stopping services...");
		
		HangIt.hangIt.stopAllServices();
		
		log("Services stopped.");
	}

	//
	// Impelementation
	//
	
	/** Log */
	private function log(msg:String):void
	{
		trace("[HangItEx] "+msg);
		txtStatus.text=msg;
	}
	
	
	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",22);
		txtStatus.width=stage.stageWidth;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		addChild(txtStatus);
		
		buttonContainer=new Sprite();
		buttonContainer.y=txtStatus.height;
		addChild(buttonContainer);
		
		var uiRect:Rectangle=new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var layout:ButtonLayout=new ButtonLayout(uiRect, 12);
		
		layout.addButton(new SimpleButton(new Command("Start Services", startServices)));
		layout.addButton(new SimpleButton(new Command("Open Wallet", openWallet)));
		layout.addButton(new SimpleButton(new Command("Clear Device", clearDevice)));
		layout.addButton(new SimpleButton(new Command("Stop Services", stopServices)));
		
		layout.attach(buttonContainer);
		layout.layout();		
	}
}
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/** Simple Button */
class SimpleButton extends Sprite
{
	//
	// Instance Variables
	//
	
	/** Command */
	private var cmd:Command;
	
	/** Width */
	private var _width:Number;
	
	/** Label */
	private var txtLabel:TextField;
	
	//
	// Public Methods
	//
	
	/** Create New SimpleButton */
	public function SimpleButton(cmd:Command)
	{
		super();
		this.cmd=cmd;
		
		mouseChildren=false;
		mouseEnabled=buttonMode=useHandCursor=true;
		
		txtLabel=new TextField();
		txtLabel.defaultTextFormat=new TextFormat("Arial",36,0xFFFFFF);
		txtLabel.mouseEnabled=txtLabel.mouseEnabled=txtLabel.selectable=false;
		txtLabel.text=cmd.getLabel();
		txtLabel.autoSize=TextFieldAutoSize.LEFT;
		
		redraw();
		
		addEventListener(MouseEvent.CLICK,onSelect);
	}
	
	/** Set Width */
	override public function set width(val:Number):void
	{
		this._width=val;
		redraw();
	}

	
	/** Dispose */
	public function dispose():void
	{
		removeEventListener(MouseEvent.CLICK,onSelect);
	}
	
	//
	// Events
	//
	
	/** On Press */
	private function onSelect(e:MouseEvent):void
	{
		this.cmd.execute();
	}
	
	//
	// Implementation
	//
	
	/** Redraw */
	private function redraw():void
	{		
		txtLabel.text=cmd.getLabel();
		_width=_width||txtLabel.width*1.1;
		
		graphics.clear();
		graphics.beginFill(0x444444);
		graphics.lineStyle(2,0);
		graphics.drawRoundRect(0,0,_width,txtLabel.height*1.1,txtLabel.height*.4);
		graphics.endFill();
		
		txtLabel.x=_width/2-(txtLabel.width/2);
		txtLabel.y=txtLabel.height*.05;
		addChild(txtLabel);
	}
}

/** Button Layout */
class ButtonLayout
{
	private var buttons:Array;
	private var rect:Rectangle;
	private var padding:Number;
	private var parent:DisplayObjectContainer;
	
	public function ButtonLayout(rect:Rectangle,padding:Number)
	{
		this.rect=rect;
		this.padding=padding;
		this.buttons=new Array();
	}
	
	public function addButton(btn:SimpleButton):uint
	{
		return buttons.push(btn);
	}
	
	public function attach(parent:DisplayObjectContainer):void
	{
		this.parent=parent;
		for each(var btn:SimpleButton in this.buttons)
		{
			parent.addChild(btn);
		}
	}
	
	public function layout():void
	{
		var btnX:Number=rect.x+padding;
		var btnY:Number=rect.y;
		for each( var btn:SimpleButton in this.buttons)
		{
			btn.width=rect.width-(padding*2);
			btnY+=this.padding;
			btn.x=btnX;
			btn.y=btnY;
			btnY+=btn.height;
		}
	}
}

/** Inline Command */
class Command
{
	/** Callback Method */
	private var fnCallback:Function;
	
	/** Label */
	private var label:String;
	
	//
	// Public Methods
	//
	
	/** Create New Command */
	public function Command(label:String,fnCallback:Function)
	{
		this.fnCallback=fnCallback;
		this.label=label;
	}
	
	//
	// Command Implementation
	//
	
	/** Get Label */
	public function getLabel():String
	{
		return label;
	}
	
	/** Execute */
	public function execute():void
	{
		fnCallback();
	}
}