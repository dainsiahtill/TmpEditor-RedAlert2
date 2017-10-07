package com.ra2.data 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author messiah
	 */
	public class PalFile 
	{
		public var colours:Vector.<uint>;
		
		public function PalFile() 
		{
			
		}
		
		public function readFromBytes(bytes:ByteArray):void 
		{
			colours = new Vector.<uint>();
			while (bytes.bytesAvailable)
			{
				var red:uint = bytes.readUnsignedByte() * 4;
				var green:uint = bytes.readUnsignedByte() * 4;
				var blue:uint = bytes.readUnsignedByte() * 4;
				var color:uint = red << 16 | green << 8 | blue;
				colours.push(color);
			}
		}
		
	}

}