package com.ra2.data 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author messiah
	 */
	public class TmpImage 
	{
		public static const ENUM_EXTRA_DATA:int = 0x01;
		public static const ENUM_Z_DATA:int = 0x02;
		public static const ENUM_DAMAGED_DATA:int = 0x04;
	
		public var x:int;
		public var y:int;
		
		public var extraDataOffset:int;
		
		public var zDataOffset:int;
		
		public var extraZDataOffset:int;
		
		public var extraX:int;
		public var extraY:int;
		
		public var extraWidth:uint;
		public var extraHeight:uint;
		
		public var dataPrecencyFlags:uint;
		
		public var height:int;
		
		public var terrainType:int;
		
		public var rampType:int;
		
		public var radarRedLeft:int;
		public var radarGreenLeft:int;
		public var radarBlueLeft:int;
		
		public var radarRedRight:int;
		public var radarGreenRight:int;
		public var radarBlueRight:int;
		
		public var tileData:Vector.<uint>;
		public var zData:Vector.<uint>;
		public var extraData:Vector.<uint>;
		
		public var tileWidth:uint;
		public var tileHeight:uint;
		
		public function TmpImage(tileWidth:uint, tileHeight:uint) 
		{
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
		}
		
		public function readFromBytes(bytes:ByteArray):void 
		{
			x = bytes.readInt();
			y = bytes.readInt();
			extraDataOffset = bytes.readInt();
			zDataOffset = bytes.readInt();
			extraZDataOffset = bytes.readInt();
			extraX = bytes.readInt();
			extraY = bytes.readInt();
			extraWidth = bytes.readUnsignedInt();
			extraHeight = bytes.readUnsignedInt();
			dataPrecencyFlags = bytes.readUnsignedInt();
			
			height = bytes.readByte();
			terrainType = bytes.readByte();
			rampType = bytes.readByte();
			
			radarRedLeft = bytes.readByte();
			radarGreenLeft = bytes.readByte();
			radarBlueLeft = bytes.readByte();
			
			radarRedRight = bytes.readByte();
			radarGreenRight = bytes.readByte();
			radarBlueRight = bytes.readByte();
			
			bytes.position += 3;
			
			var amount:uint = tileWidth * tileHeight / 2;
			tileData = new Vector.<uint>(amount);
			for (var i:int = 0; i < amount; i++) 
			{
				tileData[i] = bytes.readUnsignedByte();
			}
			
			if (hasZData())
			{
				zData = new Vector.<uint>(amount);
				for (var j:int = 0; j < amount; j++) 
				{
					zData[j] = bytes.readUnsignedByte();
				}
			}
			if (hasExtraData())
			{
				amount = extraWidth * extraHeight;
				extraData = new Vector.<uint>(amount);
				for (var k:int = 0; k < amount; k++) 
				{
					extraData[k] = bytes.readUnsignedByte();
				}
			}
		}
		
		public function hasExtraData():Boolean
		{
			return (this.dataPrecencyFlags & ENUM_EXTRA_DATA) == ENUM_EXTRA_DATA;
		}
		
		public function hasZData():Boolean
		{
			return (this.dataPrecencyFlags & ENUM_Z_DATA) == ENUM_Z_DATA;
		}
		
		public function hasDamagedData():Boolean
		{
			return (this.dataPrecencyFlags & ENUM_DAMAGED_DATA) == ENUM_DAMAGED_DATA;
		}
		
		public function toBitmapData(colors:Vector.<uint> = null):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0);
			
			var sx:int = tileWidth / 2;
			var cx:int = 0;
			var position:int = 0;
			for (var y:int = 0; y < (tileHeight / 2); y++) 
			{
				sx -= 2;
				cx += 4;
				
				setLinePixels(bitmapData, sx, y, cx, position, colors);
				
				position += cx;
			}
			for (; y < tileHeight; y++) 
			{
				sx += 2;
				cx -= 4;
				
				setLinePixels(bitmapData, sx, y, cx, position, colors);
				
				position += cx;
			}
			return bitmapData;
		}
		
		private function setLinePixels(bitmapData:BitmapData, startX:int, y:int, pixelsCount:int, position:int, colors:Vector.<uint>):void 
		{
			for (var i:int = 0; i < pixelsCount; i++) 
			{
				var color:uint = tileData[position++];
				if (colors)
				{
					color = colors[color];
				}
				bitmapData.setPixel32(startX + i, y, 0xff << 24 | color);
			}
		}
		
		public function toExtraBitmapData(colors:Vector.<uint>):BitmapData
		{
			var bitmapData:BitmapData = null;
			
			if (hasExtraData())
			{
				bitmapData = new BitmapData(this.extraWidth, this.extraHeight, true);
				for (var i:int = 0; i < this.extraWidth; i++) 
				{
					for (var j:int = 0; j < this.extraHeight; j++) 
					{
						var color:uint = this.extraData[j * this.extraWidth + i];
						if (color > 0)
						{
							if (colors)
								color = colors[color];
							bitmapData.setPixel(i, j, color);
						}
						else 
						{
							bitmapData.setPixel32(i, j, 0);
						}
					}
				}
				
			}
			
			return bitmapData;
		}
	}

}