package com.ra2.data 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author messiah
	 */
	public class TmpFile 
	{
		
		public var width:int;
		public var height:int;
		public var tileWidth:int;
		public var tileHeight:int;
		
		public var tileNums:int;
		public var indices:Array;
		
		public var tmpImages:Vector.<TmpImage>;
		
		public function TmpFile() 
		{
			
		}
		
		public function readFromBytes(bytes:ByteArray):void
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			try 
			{
				width = bytes.readUnsignedInt();
				height = bytes.readUnsignedInt();
				tileWidth = bytes.readUnsignedInt();
				tileHeight = bytes.readUnsignedInt();
				
				tileNums = width * height;
				
				indices = new Array(tileNums);
				for (var i:int = 0; i < tileNums; i++)
				{
				  var index:int = bytes.readInt();
				  indices.push(index);
				}
				
				tmpImages = new Vector.<TmpImage>();
				
				for (var j:int = 0; j < indices.length; j++)
				{
				  index = indices[j];
				  if (index > 0)
				  {
					  bytes.position = index;
					  var tmpImage:TmpImage = new TmpImage(tileWidth, tileHeight);
					  tmpImage.readFromBytes(bytes);
					  tmpImages.push(tmpImage);
				  }
				}
			}
			catch (err:Error)
			{
				trace(err.getStackTrace());
			}
			
		}
		
		public function getRect():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			
			var x:int = 0;
			var y:int = 0;
			var cx:int = 0;
			var cy:int = 0;
			for (var i:int = 0; i < tmpImages.length; i++)
			{
				var tmpImg:TmpImage = tmpImages[i];
				
				var x1:int = tmpImg.x;
				var y1:int = tmpImg.y - tileHeight * tmpImg.height / 2;
				var x2:int = tmpImg.x + tileWidth;
				var y2:int = tmpImg.y + tileHeight;
				
				if (tmpImg.hasExtraData())
				{
					if (tmpImg.extraX < x)
						x = tmpImg.extraX;
					if (tmpImg.extraY < y)
						y = tmpImg.extraY;
				}
				if (x1 < x)
					x = x1;
				if (y1 < y)
					y = y1;
				if (x2 > cx)
					cx = x2;
				if (y2 > cy)
					cy = y2;
				
			}
			
			rect.x = x;
			rect.y = y;
			rect.width = cx - x;
			rect.height = cy - y;
			return rect;
		}
		
		public function getHeight():int
		{
			var height:int = 0;
			for (var i:int = 0; i < tmpImages.length; i++) 
			{
				var tmpImg:TmpImage = tmpImages[i];
				if (tmpImg.height > height)
					height = tmpImg.height;
			}
			
			return height;
		}
	}

}