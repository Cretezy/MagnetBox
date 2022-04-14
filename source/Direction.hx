package;

import lime.math.Vector2;

abstract Direction(Int) from Int to Int {
	public static inline var UP = 0;
	public static inline var RIGHT = 1;
	public static inline var DOWN = 2;
	public static inline var LEFT = 3;

	public static var VALUES = [UP, RIGHT, DOWN, LEFT];

	public static var VECTORS = [
		UP => new Vector2(0, -1),
		RIGHT => new Vector2(1, 0),
		DOWN => new Vector2(0, 1),
		LEFT => new Vector2(-1, 0),
	];

	public static function fromString(direction:String):Direction {
		return switch (direction) {
			case "up": return Direction.UP;
			case "right": return Direction.RIGHT;
			case "down": return Direction.DOWN;
			case "left": return Direction.LEFT;
			default: return null;
		}
	}

	public static function opposite(direction:Direction):Direction {
		return switch (direction) {
			case UP: return DOWN;
			case RIGHT: return LEFT;
			case DOWN: return UP;
			case LEFT: return RIGHT;
			default: return null;
		}
	}
}
