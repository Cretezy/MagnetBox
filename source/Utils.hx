import flixel.FlxG;

class Utils {
	public static function round(number:Float, ?precision = 2):Float {
		number *= Math.pow(10, precision);
		return Math.round(number) / Math.pow(10, precision);
	}

	public static function floatToStringPrecision(n:Float, prec:Int) {
		n = Math.round(n * Math.pow(10, prec));
		var str = '' + n;
		var len = str.length;
		if (len <= prec) {
			while (len < prec) {
				str = '0' + str;
				len++;
			}
			return '0.' + str;
		} else {
			return str.substr(0, str.length - prec) + '.' + str.substr(str.length - prec);
		}
	}

	public static function showMouse() {
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		#if js
		if (FlxG.html5.onMobile) {
			FlxG.mouse.visible = false;
		}
		#end
	}

	public static function hideMouse() {
		FlxG.mouse.visible = false;
	}
}
