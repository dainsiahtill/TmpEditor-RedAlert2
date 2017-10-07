package com.ra2.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author messiah
	 */
	public class TileDisplay extends Sprite 
	{
		private var _bitmap:Bitmap;
		private var _isMouseOver:Boolean = false;
		
		public function TileDisplay(bitmapData:BitmapData, index:int = -1) 
		{
			super();
			
			_bitmap = new Bitmap(bitmapData);
			addChild(_bitmap);
			
			if (index != -1)
			{
				var textField:TextField = new TextField();
				textField.mouseEnabled = false;
				textField.selectable = false;
				textField.text = "" + index;
				textField.autoSize = TextFieldAutoSize.LEFT;
				addChild(textField);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			this.startDrag();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private function onStageMouseUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			//
			this.stopDrag();
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			if (_isMouseOver)
			{
				_isMouseOver = false;
				
				this.filters = [];
			}
			
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			if (!_isMouseOver)
			{
				_isMouseOver = true;
				
				this.filters = [new GlowFilter(0xff0000)];
			}
			
		}
		
	}

}